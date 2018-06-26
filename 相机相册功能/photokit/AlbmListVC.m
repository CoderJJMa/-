//
//  AlbmsView.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/25.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "AlbmListVC.h"
#import "CHAlbumModel.h"
#import "CHAlbumListCell.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height


@interface AlbmListVC()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *albumModelArray;

@property (nonatomic,strong)UIView *navView;
@property (nonatomic,strong)UIButton *closeBtn;

@end



@implementation AlbmListVC

- (instancetype)init{

    if (self == [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;

}

- (void)viewDidLoad{

    [super viewDidLoad];

    [self configTitle];

    [self.view addSubview:self.collectionView];

}

- (void)configTitle{

    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    self.navView.backgroundColor = [UIColor colorWithHexString:@"2089EB"];
    [self.view addSubview:self.navView];


    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.navView.frame.size.width - 15 - 32, 20, 32, 44)];
    [self.closeBtn setImage:[UIImage imageNamed:@"navbar_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.closeBtn];


    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
    titleLabel.text = @"所有照片";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment  = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.center = CGPointMake(self.navView.center.x , self.navView.center.y + 10);
    [self.navView addSubview:titleLabel];


}

- (void)closePage{

    NSLog(@"%s",__func__);

}


#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;//self.albumModelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHAlbumListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor  =[UIColor redColor];
    cell.model = self.albumModelArray[indexPath.item];
    return cell;
}
#pragma mark - < UICollectionViewDelegate >
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(CHAlbumListCell *)cell cancelRequest];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navView.frame), self.view.hx_w, self.view.hx_h - 64) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[CHAlbumListCell class] forCellWithReuseIdentifier:@"cellId"];
        //        _collectionView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
        //        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
            if ((NO)) {
#endif
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            if (self.manager.configuration.open3DTouchPreview) {
                if ([self respondsToSelector:@selector(traitCollection)]) {
                    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
                        
                    }
                }
            }
        }
        return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (self.view.hx_w - 25) / 4;
        CGFloat itemHeight = itemWidth;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _flowLayout;
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



@interface CHAlbumListQuadrateViewCell : UICollectionViewCell

@property (strong, nonatomic) CHAlbumModel *model;

- (void)cancelRequest ;

@end
