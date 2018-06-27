//
//  CHPhotoManager.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/22.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "CHPhotoManager.h"

@implementation CHPhotoManager

- (instancetype)initWithType:(CHPhotoManagerSelectedType)type{

    _type = type;

    return self;

}

- (CHPhotoConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [[CHPhotoConfiguration alloc] init];
    }
    return _configuration;
}

- (NSMutableArray *)localImageList{

    if (!_localImageList) {
        _localImageList = [NSMutableArray array];
    }
    return _localImageList;
}

@end
