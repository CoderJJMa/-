//
//  CHSelectedViews.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "CHSelectedViews.h"

@implementation CHSelectedViews

- (void)awakeFromNib{

    [super awakeFromNib];

    self.firstImg.hidden = YES;
    self.secondImg.hidden = YES;
    self.thirdImg.hidden = YES;
    self.fourImg.hidden = YES;

}

+ (instancetype)loadView{

    UINib * nib = [UINib nibWithNibName:@"CHSelectedViews" bundle:nil];
    CHSelectedViews * view = [nib instantiateWithOwner:nib options:nil].firstObject;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    return view;

}

@end
