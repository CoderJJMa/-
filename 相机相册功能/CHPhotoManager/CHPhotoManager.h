//
//  CHPhotoManager.h
//  相机相册功能
//
//  Created by majianjie on 2018/6/22.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "CHPhotoConfiguration.h"


/**
 *  照片选择的管理类, 使用照片选择时必须先懒加载此类,然后赋值给对应的对象
 */
typedef enum : NSUInteger {
    CHPhotoManagerSelectedTypePhoto = 0,        // 只显示图片
    CHPhotoManagerSelectedTypeVideo = 1,        // 只显示视频
    CHPhotoManagerSelectedTypePhotoAndVideo     // 图片和视频一起显示
} CHPhotoManagerSelectedType;



@interface CHPhotoManager : NSObject


/**
 显示的类型 图片 / 视频  / 图片和视频
 */
@property (assign, nonatomic) CHPhotoManagerSelectedType type;

/**
 @param type 选择类型
 */
- (instancetype)initWithType:(CHPhotoManagerSelectedType)type;

/**
 配置信息
 */
@property (strong, nonatomic) CHPhotoConfiguration *configuration;

/**
 *  本地图片数组 <UIImage *> 装的是UIImage对象 - 已设置为选中状态
 */
@property (copy, nonatomic) NSArray *localImageList;


@end
