//
//  ASDeviceAdapter.m
//  appsort
//
//  Created by Zheng on 06/03/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "ASDeviceAdapter.h"

@implementation ASDeviceAdapter

@synthesize iosDevice, springboardServices;

+ (ASDeviceAdapter *)sharedInstance {
    static ASDeviceAdapter *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (_sharedInstance == nil) {
            _sharedInstance = [[ASDeviceAdapter alloc] init];
            while (!_sharedInstance.iosDevice &&
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {

            }
            _sharedInstance.springboardServices = [_sharedInstance.iosDevice newAMSpringboardServices];
        }
    });
    return _sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        [[MobileDeviceAccess singleton] setListener:self];
    }
    
    return self;
}

- (void)dealloc {
    self.iosDevice = nil;
    self.springboardServices = nil;
}

#pragma mark MobileDeviceAccessListener

- (void)deviceConnected:(AMDevice*)device {
    self.iosDevice = device;
}

- (void)deviceDisconnected:(AMDevice*)device {
    self.iosDevice = nil;
}


- (BOOL)isDeviceConnected {
    return self.iosDevice != nil;
}

@end
