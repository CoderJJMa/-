//
//  CHSelectedViews.h
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitPhotosBlock)(void);

@interface CHSelectedViews : UIView

@property (nonatomic,copy)CommitPhotosBlock commit;

@property (weak, nonatomic) IBOutlet UIView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;


@property (weak, nonatomic) IBOutlet UIView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

@property (weak, nonatomic) IBOutlet UIView *thirdImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;


@property (weak, nonatomic) IBOutlet UIView *fourImg;
@property (weak, nonatomic) IBOutlet UIImageView *fourImage;

@property (weak, nonatomic) IBOutlet UIView *okView;

@property (weak, nonatomic) IBOutlet UIView *commitView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;


+ (instancetype)loadView;

@end
