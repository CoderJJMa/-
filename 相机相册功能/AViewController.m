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
@property (nonatomic,strong)NSMutableArray *selectedPhotos;

@end

@implementation AViewController

- (void)viewDidLoad{

    [super viewDidLoad];

    _selectedPhotos = [NSMutableArray array];

}

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

        [self.selectedPhotos addObjectsFromArray:allPic];

        NSSet *set = [NSSet setWithArray:self.selectedPhotos];
        self.selectedPhotos = [[set allObjects] mutableCopy];
        NSLog(@"选中的图片 : %@",self.selectedPhotos);
    }

}

- (IBAction)jump:(id)sender {

    MainVC *targetVC = [[MainVC alloc] init];
    targetVC.albmsvc.allSelectedPhotos = [self.selectedPhotos mutableCopy];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:targetVC];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    // `linear', `easeIn', `easeOut' `easeInEaseOut' and `default'
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self presentViewController:nav animated:YES completion:nil];

}


@end
