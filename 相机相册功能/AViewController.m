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
        [self updateUI];
    }

}

- (void)updateUI{

    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];


    dispatch_async(dispatch_get_main_queue(), ^{


        switch (self.selectedPhotos.count) {
            case 0:
            {
                self.measurePhotoView.firstImg.hidden = NO;
                self.measurePhotoView.secondImg.hidden = YES;
                self.measurePhotoView.thirdImg.hidden = YES;
                self.measurePhotoView.fourthImg.hidden = YES;
                break;
            }
            case 1:{
                self.measurePhotoView.firstImg.hidden = NO;
                CHPhotoModel *model = self.selectedPhotos[0];

                [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:model.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.firstImg.image = result;
                    });
                }];

                self.measurePhotoView.secondImg.hidden = NO;
                self.measurePhotoView.thirdImg.hidden = YES;
                self.measurePhotoView.fourthImg.hidden = YES;

                break;
            }
            case 2:{

                self.measurePhotoView.firstImg.hidden = NO;
                CHPhotoModel *model = self.selectedPhotos[0];

                [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:model.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.firstImg.image = result;
                    });
                }];

                self.measurePhotoView.secondImg.hidden = NO;
                CHPhotoModel *model2 = self.selectedPhotos[1];

                [[PHImageManager defaultManager] requestImageForAsset:model2.asset targetSize:model2.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.secondImg.image = result;
                    });
                }];
                self.measurePhotoView.thirdImg.hidden = NO;
                self.measurePhotoView.fourthImg.hidden = YES;

                break;
            }
            case 3:{

                self.measurePhotoView.firstImg.hidden = NO;
                CHPhotoModel *model = self.selectedPhotos[0];

                [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:model.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.firstImg.image = result;
                    });
                }];

                self.measurePhotoView.secondImg.hidden = NO;
                CHPhotoModel *model2 = self.selectedPhotos[1];

                [[PHImageManager defaultManager] requestImageForAsset:model2.asset targetSize:model2.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.secondImg.image = result;
                    });
                }];


                self.measurePhotoView.thirdImg.hidden = NO;
                CHPhotoModel *model3 = self.selectedPhotos[2];

                [[PHImageManager defaultManager] requestImageForAsset:model3.asset targetSize:model3.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.thirdImg.image = result;
                    });
                }];

                self.measurePhotoView.fourthImg.hidden = NO;

                break;
            }
            case 4:{
                self.measurePhotoView.firstImg.hidden = NO;
                CHPhotoModel *model = self.selectedPhotos[0];

                [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:model.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.firstImg.image = result;
                    });
                }];

                self.measurePhotoView.secondImg.hidden = NO;
                CHPhotoModel *model2 = self.selectedPhotos[1];

                [[PHImageManager defaultManager] requestImageForAsset:model2.asset targetSize:model2.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.secondImg.image = result;
                    });
                }];


                self.measurePhotoView.thirdImg.hidden = NO;
                CHPhotoModel *model3 = self.selectedPhotos[2];

                [[PHImageManager defaultManager] requestImageForAsset:model3.asset targetSize:model3.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.thirdImg.image = result;
                    });
                }];

                self.measurePhotoView.fourthImg.hidden = NO;
                CHPhotoModel *model4 = self.selectedPhotos[3];

                [[PHImageManager defaultManager] requestImageForAsset:model4.asset targetSize:model4.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.measurePhotoView.fourthImg.image = result;
                    });
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
    // `linear', `easeIn', `easeOut' `easeInEaseOut' and `default'
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self presentViewController:nav animated:YES completion:nil];

}


@end
