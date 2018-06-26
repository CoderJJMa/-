//
//  CHPhotoModel.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "CHPhotoModel.h"

@implementation CHPhotoModel

- (void)setAsset:(PHAsset *)asset{

    _asset = asset;

    if (_asset) {

        NSString *filename = [_asset valueForKey:@"filename"];
        self.fileName = filename;
        NSLog(@"filename:%@",filename);

    }

}

@end
