//
//  ASDeviceAdapter.h
//  appsort
//
//  Created by Zheng on 06/03/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"

@class ASDeviceAdapter;

@interface ASDeviceAdapter : NSObject
<MobileDeviceAccessListener>
{
    AMDevice *iosDevice;
    AMSpringboardServices *springboardServices;
}

@property (nonatomic, retain) AMDevice *iosDevice;
@property (nonatomic, retain) AMSpringboardServices *springboardServices;

+ (ASDeviceAdapter *)sharedInstance;

- (BOOL)isDeviceConnected;

@end
