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
#import "CHPhotoManager.h"

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
        [self updateUI];
    }

}

- (void)updateUI{

    dispatch_async(dispatch_get_main_queue(), ^{

        self.measurePhotoView.firstImg.hidden = NO;
        self.measurePhotoView.secondImg.hidden = self.selectedPhotos.count == 0;
        self.measurePhotoView.thirdImg.hidden = self.selectedPhotos.count == 1 || self.selectedPhotos.count == 0;
        self.measurePhotoView.fourthImg.hidden = self.selectedPhotos.count == 1 || self.selectedPhotos.count == 0 || self.selectedPhotos.count == 2;


        CGSize size = self.measurePhotoView.firstImg.frame.size;

        switch (self.selectedPhotos.count) {
            case 0:
            {
                break;
            }
            case 1:{
                CHPhotoModel *model = self.selectedPhotos[0];
                [CHPhotoManager getPhotoForPHAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                   self.measurePhotoView.firstImg.image = image;
                }];

                break;
            }
            case 2:{
                CHPhotoModel *model = self.selectedPhotos[0];
                [CHPhotoManager getPhotoForPHAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.firstImg.image = image;
                }];

                CHPhotoModel *model2 = self.selectedPhotos[1];
                [CHPhotoManager getPhotoForPHAsset:model2.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.secondImg.image = image;
                }];
                break;
            }
            case 3:{
                CHPhotoModel *model = self.selectedPhotos[0];
                [CHPhotoManager getPhotoForPHAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.firstImg.image = image;
                }];

                CHPhotoModel *model2 = self.selectedPhotos[1];
                [CHPhotoManager getPhotoForPHAsset:model2.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.secondImg.image = image;
                }];

                CHPhotoModel *model3 = self.selectedPhotos[2];
                [CHPhotoManager getPhotoForPHAsset:model3.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.thirdImg.image = image;
                }];
                break;
            }
            case 4:{
                CHPhotoModel *model = self.selectedPhotos[0];
                [CHPhotoManager getPhotoForPHAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.firstImg.image = image;
                }];

                CHPhotoModel *model2 = self.selectedPhotos[1];
                [CHPhotoManager getPhotoForPHAsset:model2.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.secondImg.image = image;
                }];

                CHPhotoModel *model3 = self.selectedPhotos[2];
                [CHPhotoManager getPhotoForPHAsset:model3.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.thirdImg.image = image;
                }];

                CHPhotoModel *model4 = self.selectedPhotos[3];
                [CHPhotoManager getPhotoForPHAsset:model4.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                    self.measurePhotoView.fourthImg.image = image;
                }];

                break;
            }

            default:
                break;
        }

    });



}

- (IBAction)jump:(id)sender {

    MainVC *targetVC = [[MainVC alloc] init];
    targetVC.albmsvc.allSelectedPhotos = [self.selectedPhotos mutableCopy];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:targetVC];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self presentViewController:nav animated:YES completion:nil];

}


@end
