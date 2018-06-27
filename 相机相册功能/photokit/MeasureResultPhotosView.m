//
//  MeasureResultPhotosView.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/27.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "MeasureResultPhotosView.h"

@implementation MeasureResultPhotosView

- (void)awakeFromNib{

    [super awakeFromNib];

    self.backgroundColor = [UIColor whiteColor];

}

+ (instancetype)loadView{

    UINib * nib = [UINib nibWithNibName:@"MeasureResultPhotosView" bundle:nil];
    MeasureResultPhotosView * view = [nib instantiateWithOwner:nib options:nil].firstObject;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    return view;

}

@end
