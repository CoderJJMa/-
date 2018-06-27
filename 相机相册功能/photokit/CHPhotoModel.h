//
//  CHPhotoModel.h
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface CHPhotoModel : NSObject

@property (nonatomic,strong)NSString *fileName;

@property (nonatomic,strong)PHAsset *asset;

@property (nonatomic,assign)CGSize size;

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
