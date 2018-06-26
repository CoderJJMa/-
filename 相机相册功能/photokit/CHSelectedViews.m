//
//  CHSelectedViews.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "CHSelectedViews.h"

@implementation CHSelectedViews

+ (instancetype)loadView{

    UINib * nib = [UINib nibWithNibName:@"CHSelectedViews" bundle:nil];
    CHSelectedViews * view = [nib instantiateWithOwner:nib options:nil].firstObject;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    return view;

}

@end
