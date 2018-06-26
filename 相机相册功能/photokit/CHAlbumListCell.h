//
//  CHAlbumListCell.h
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHAlbumModel.h"
#import <Photos/Photos.h>

@interface CHAlbumListCell : UICollectionViewCell

@property (strong, nonatomic) CHAlbumModel *model;

- (void)cancelRequest ;

@property (strong, nonatomic) UIImageView *coverView1;
@property (strong, nonatomic) UIImageView *coverView2;
@property (strong, nonatomic) UIImageView *coverView3;
@property (strong, nonatomic) UILabel *albumNameLb;
@property (strong, nonatomic) UILabel *photoNumberLb;
@property (assign, nonatomic) PHImageRequestID requestId1;
@property (assign, nonatomic) PHImageRequestID requestId2;
@property (assign, nonatomic) PHImageRequestID requestId3;


@end
