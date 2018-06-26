//
//  CHAlbumModel.h
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface CHAlbumModel : NSObject

/**
 相册名称
 */
@property (copy, nonatomic) NSString *albumName;

/**
 照片数量
 */
@property (assign, nonatomic) NSInteger count;

/**
 照片集合对象
 */
@property (strong, nonatomic) PHFetchResult *result;

/**
 标记
 */
@property (assign, nonatomic) NSInteger index;

/**
 选中的个数
 */
@property (assign, nonatomic) NSInteger selectedCount;

@end
