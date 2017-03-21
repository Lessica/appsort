//
//  main.m
//  appsort
//
//  Created by Zheng on 06/03/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDeviceAdapter.h"
#import "ASHomeScreenState.h"
#import "SLColorArt.h"
#import "NSColor+Utilities.h"
#import "ASHomeScreenIconKey.h"

int main(int argc, const char *argv[]) {
    NSLog(@"Waiting for iOS Device...");

    ASDeviceAdapter *deviceAdapter = [ASDeviceAdapter sharedInstance];
    AMDevice *singleDevice = deviceAdapter.iosDevice;
    NSLog(@"Device %@ (%@) found.", singleDevice.deviceName, singleDevice.udid);

    // Home Screen State <- SpringboardServices
    AMSpringboardServices *springboardServices = [singleDevice newAMSpringboardServices];
    ASHomeScreenState *homeScreenState = [[ASHomeScreenState alloc] init];

    // Icon Metrics
    NSDictionary *dictIconMetrics = [springboardServices getHomeScreenIconMetrics];
    assert(dictIconMetrics != nil);
    ASHomeScreenIconMetrics *iconMetrics = [[ASHomeScreenIconMetrics alloc] initWithDictionary:dictIconMetrics];
    homeScreenState.iconMetrics = iconMetrics;
    NSLog(@"iconMetrics: %@", dictIconMetrics);

    // Interface Orientation
    NSDictionary *dictInterfaceOrientation = [springboardServices getInterfaceOrientation];
    assert(dictInterfaceOrientation != nil);
    NSNumber *numInterfaceOrientation = dictInterfaceOrientation[@"interfaceOrientation"];
    homeScreenState.interfaceOrientation = (UIInterfaceOrientation) [numInterfaceOrientation integerValue];
    NSLog(@"interfaceOrientation: %@", numInterfaceOrientation);

    // Icon State
    NSArray *arrIconState = [springboardServices getIconState];
    assert(arrIconState != nil);

    NSLog(@"%@", arrIconState);

    NSMutableArray <NSDictionary *> *mutArrIconState = [NSMutableArray array];
    // Pages in main screen
    for (NSUInteger i = 1; i < arrIconState.count; ++i) {
        // Icons in pages
        for (NSUInteger j = 0; j < ((NSArray *) arrIconState[i]).count; ++j) {
            // If is folder
            if ([arrIconState[i][j][@"listType"] isEqualToString:@"folder"]) {
                // Pages in folder
                for (NSUInteger k = 0; k < ((NSArray *) arrIconState[i][j][@"iconLists"]).count; ++k) {
                    // Icons in folder pages
                    for (NSUInteger l = 0; l < ((NSArray *) arrIconState[i][j][@"iconLists"][k]).count; ++l) {
                        NSDictionary *iconDict = arrIconState[i][j][@"iconLists"][k][l];
                        [mutArrIconState addObject:iconDict];
                    }
                }
            } else {
                NSDictionary *iconDict = arrIconState[i][j];
                [mutArrIconState addObject:iconDict];
            }
        }
    }

    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    NSString *dirPath = [[defaultFileManager currentDirectoryPath] stringByAppendingPathComponent:@"icons"];
    NSError *error;
    if (![defaultFileManager createDirectoryAtPath:dirPath
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:&error]) {

    }

    NSMutableArray <NSDictionary *> *mutArrIconRes = [NSMutableArray arrayWithCapacity:mutArrIconState.count];
    // get icon images
    for (NSUInteger m = 0; m < mutArrIconState.count; ++m) {
        NSMutableDictionary *mutIconDict = [mutArrIconState[m] mutableCopy];
        NSString *appIdentifier = mutIconDict[keyDisplayIdentifier];
        NSDictionary *appIconData = [springboardServices getIconPNGData:appIdentifier];

        // get background color
        NSImage *displayIcon = [[NSImage alloc] initWithData:appIconData[@"pngData"]];
        SLColorArt *colorArt = [SLColorArt colorArtWithImage:displayIcon scaledSize:displayIcon.size];
        NSColor *backgroundColor = [colorArt backgroundColor];
        NSColor *mainColor = [backgroundColor closestColorInCalveticaPalette];
//        if (mainColor.redComponent == 1.f && mainColor.greenComponent == 1.f && mainColor.blueComponent == 1.f) {
//            NSColor *primaryColor = [colorArt primaryColor];
//            mainColor = primaryColor ? [primaryColor closestColorInCalveticaPalette] : mainColor;
//        }

        NSString *filePathAndDirectory = [dirPath stringByAppendingPathComponent:appIdentifier];
        NSString *iconPath = [filePathAndDirectory stringByAppendingPathExtension:@".png"];
        if (![defaultFileManager fileExistsAtPath:iconPath]) {
            [appIconData[@"pngData"] writeToFile:iconPath atomically:NO];
        }

//        mutIconDict[@"displayIcon"] = appIconData[@"pngData"];
//        mutIconDict[keyDisplayIconBackgroundColor] = backgroundColor;
        mutIconDict[keyDisplayIconMainColor] = mainColor;

        NSDictionary *iconState = [[NSDictionary alloc] initWithDictionary:[mutIconDict copy]];
        [mutArrIconRes addObject:iconState];
        NSLog(@"parsed: %@", mutIconDict);
    }
    homeScreenState.iconStates = mutArrIconRes;

    // Process Color
    NSArray <NSColor *> * palette = [NSColor calveticaPalette];
    NSMutableArray <NSArray <NSDictionary *> *> * separatedColorIcons = [NSMutableArray arrayWithCapacity:palette.count];
    NSMutableArray <NSDictionary *> * separatedColorList = [NSMutableArray arrayWithCapacity:homeScreenState.iconStates.count];
    for (NSColor *color in palette) {
        NSMutableArray <NSDictionary *> *oneTypeColorIcons = [NSMutableArray array];
        for (NSDictionary *iconState in homeScreenState.iconStates) {
            if ([iconState[keyDisplayIconMainColor] isEqual:color]) {
                [oneTypeColorIcons addObject:iconState];
            }
        }
        [separatedColorIcons addObject:[oneTypeColorIcons copy]];
        [separatedColorList addObjectsFromArray:oneTypeColorIcons];
    }

    // Generate final state
    NSUInteger iconNum = separatedColorList.count;
    NSUInteger iconsPerPage = (homeScreenState.iconMetrics.iconColumns * homeScreenState.iconMetrics.iconRows);
    NSUInteger pageNum = (NSUInteger) ceil((double)iconNum / (double)iconsPerPage);
    NSMutableArray <NSArray *> *pagedIconArray = [NSMutableArray arrayWithCapacity:(pageNum + 1)];
    [pagedIconArray addObject:arrIconState[0]];
    for (NSUInteger n = 0; n < pageNum; ++n) {
        NSMutableArray *iconThisPage = [NSMutableArray arrayWithCapacity:(iconsPerPage)];
        for (NSUInteger i = 0; i < iconsPerPage && n * iconsPerPage + i < iconNum; ++i) {
            NSDictionary *origDict = separatedColorList[n * iconsPerPage + i];
            NSMutableDictionary *newDict = [origDict mutableCopy];
//            [newDict removeObjectForKey:keyDisplayIconBackgroundColor];
            [newDict removeObjectForKey:keyDisplayIconMainColor];
            [iconThisPage addObject:[newDict copy]];
        }
        [pagedIconArray addObject:iconThisPage];
    }
    NSLog(@"%@", pagedIconArray);

    // Set icon state
    [springboardServices setIconState:[pagedIconArray copy]];

    return 0;
}
