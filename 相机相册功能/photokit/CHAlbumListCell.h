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
#import "CHPhotoModel.h"

@interface CHAlbumListCell : UICollectionViewCell

@property (strong, nonatomic) CHPhotoModel *model;
@property (nonatomic,assign)BOOL isSelected;

@property (strong, nonatomic) UIImageView *imagev;

@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UIButton *selectNumberBtn;

- (void)selectedIndexPath:(NSIndexPath *)indexPath model:(CHPhotoModel *)model;

@end

