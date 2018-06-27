//
//  MeasureResultPhotosView.h
//  相机相册功能
//
//  Created by majianjie on 2018/6/27.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasureResultPhotosView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *firstImg;

@property (weak, nonatomic) IBOutlet UIImageView *secondImg;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImg;


+ (instancetype)loadView;


@end
