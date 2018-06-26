//
//  AlbmsView.h
//  相机相册功能
//
//  Created by majianjie on 2018/6/25.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHPhotoManager.h"

@interface AlbmListVC : UIViewController

@property (strong, nonatomic) CHPhotoManager *manager;

- (void)directGoPhotoViewController;

@end
