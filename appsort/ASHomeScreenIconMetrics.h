//
// Created by Zheng on 06/03/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ASHomeScreenIconMetrics : NSObject

@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger iconColumns;
@property (nonatomic, assign) NSUInteger iconDockMaxCount;
@property (nonatomic, assign) NSUInteger iconFolderColumns;
@property (nonatomic, assign) NSUInteger iconFolderMaxPages;
@property (nonatomic, assign) NSUInteger iconFolderRows;
@property (nonatomic, assign) NSUInteger iconHeight;
@property (nonatomic, assign) NSUInteger iconMaxPages;
@property (nonatomic, assign) NSUInteger iconRows;
@property (nonatomic, assign) NSUInteger iconWidth;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end