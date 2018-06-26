//
//  AlbmsView.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/25.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "AlbmListVC.h"
#import "HXPhotoPicker.h"

@interface AlbmListVC()<HXPhotoViewDelegate,HXAlbumListViewControllerDelegate>


@end



@implementation AlbmListVC

- (instancetype)init{

    if (self == [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;

}


- (void)directGoPhotoViewController {

//    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
//    vc.manager = self.manager;
//    vc.delegate = self;
//
//    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
//
//    [self presentViewController:nav animated:YES completion:nil];

}



// 懒加载 照片管理类
- (CHPhotoManager *)manager {

    if (!_manager) {

        _manager = [[CHPhotoManager alloc] initWithType:CHPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 4;
        _manager.configuration.videoMaxNum = 6;
        _manager.configuration.maxNum = 10;
        _manager.configuration.videoMaxDuration = 500.f;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.selectTogether = NO;

    }

    return _manager;
}

@end
