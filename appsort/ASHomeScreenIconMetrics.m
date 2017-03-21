//
// Created by Zheng on 06/03/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "ASHomeScreenIconMetrics.h"

const NSString *homeScreenHeight = @"homeScreenHeight";
const NSString *homeScreenWidth = @"homeScreenWidth";
const NSString *homeScreenIconColumns = @"homeScreenIconColumns";
const NSString *homeScreenIconDockMaxCount = @"homeScreenIconDockMaxCount";
const NSString *homeScreenIconFolderColumns = @"homeScreenIconFolderColumns";
const NSString *homeScreenIconFolderMaxPages = @"homeScreenIconFolderMaxPages";
const NSString *homeScreenIconFolderRows = @"homeScreenIconFolderRows";
const NSString *homeScreenIconHeight = @"homeScreenIconHeight";
const NSString *homeScreenIconMaxPages = @"homeScreenIconMaxPages";
const NSString *homeScreenIconRows = @"homeScreenIconRows";
const NSString *homeScreenIconWidth = @"homeScreenIconWidth";

@implementation ASHomeScreenIconMetrics {

}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSAssert(dictionary != nil, @"ASHomeScreenIconMetrics");
        _height = [dictionary[homeScreenHeight] unsignedIntegerValue];
        _width = [dictionary[homeScreenWidth] unsignedIntegerValue];
        _iconColumns = [dictionary[homeScreenIconColumns] unsignedIntegerValue];
        _iconDockMaxCount = [dictionary[homeScreenIconDockMaxCount] unsignedIntegerValue];
        _iconFolderColumns = [dictionary[homeScreenIconFolderColumns] unsignedIntegerValue];
        _iconFolderMaxPages = [dictionary[homeScreenIconFolderMaxPages] unsignedIntegerValue];
        _iconFolderRows = [dictionary[homeScreenIconFolderRows] unsignedIntegerValue];
        _iconHeight = [dictionary[homeScreenIconHeight] unsignedIntegerValue];
        _iconMaxPages = [dictionary[homeScreenIconMaxPages] unsignedIntegerValue];
        _iconRows = [dictionary[homeScreenIconRows] unsignedIntegerValue];
        _iconWidth = [dictionary[homeScreenIconWidth] unsignedIntegerValue];
    }
    return self;
}

@end