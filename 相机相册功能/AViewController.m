//
//  AViewController.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "AViewController.h"
#import "MainVC.h"
#import "CHPhotoModel.h"
#import "MeasureResultPhotosView.h"

@interface AViewController ()

@property (nonatomic,strong)MeasureResultPhotosView *measurePhotoView;

@end

@implementation AViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePhotos:) name:@"SelectedPhotos" object:nil];


    self.measurePhotoView = [MeasureResultPhotosView loadView];
    self.measurePhotoView.frame = CGRectMake(12, 80, self.view.frame.size.width - 24, 72);
    [self.view addSubview:self.measurePhotoView];


}

- (void)receivePhotos:(NSNotification *)notify{

    NSMutableArray *allPic = notify.object;

    if (allPic.count > 0) {

        

        [allPic enumerateObjectsUsingBlock:^(CHPhotoModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            CHPhotoModel *model = obj;
            if (model && model.asset) {
                NSString *filename = [model.asset valueForKey:@"filename"];
                NSLog(@"选中的图片 : %@",filename);
            }
        }];

    }

}

- (IBAction)jump:(id)sender {

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MainVC new]];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    // `linear', `easeIn', `easeOut' `easeInEaseOut' and `default'
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    animation.type = kCATransitionFade;
    //可以改变subtype的类型
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:nav animated:YES completion:nil];

}



@end
