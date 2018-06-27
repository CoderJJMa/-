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
#import "CHAlbumModel.h"
#import "CHPhotoModel.h"
#import "CHSelectedViews.h"

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height


@interface AlbmListVC()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *albumModelArray;

@property (nonatomic,strong)UIView *navView;
@property (nonatomic,strong)UIButton *closeBtn;


@property (nonatomic,strong)CHSelectedViews *selectedView;

@end


@implementation AlbmListVC

- (instancetype)init{

    if(self == [super init]){
        self.allSelectedPhotos = [NSMutableArray array];
    }
    return self;

}

- (void)viewDidLoad{

    [super viewDidLoad];

    [self configTitle];


    [self.view addSubview:self.collectionView];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    if (self.albumModelArray.count == 0) {
        [self.manager getAlbumModelList:^(CHAlbumModel *firstAlbumModel) {

            for (NSInteger i = 0; i < firstAlbumModel.result.count; i++) {
                // 获取一个资源（PHAsset）
                PHAsset *asset = firstAlbumModel.result[i];
                CHPhotoModel *model = [CHPhotoModel new];
                model.asset = asset;
                [self.albumModelArray addObject:model];
            }

            [self.collectionView reloadData];

        }];
    }

//    if(self.allSelectedPhotos.count > 0){
//        [UIView animateWithDuration:0.3 animations:^{
//            self.selectedView.frame = CGRectMake(0, KScreenHeight - 74, KScreenWidth, 74);
//        }];
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
//            self.selectedView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 74);
//        }];
//    }

}

- (void)configTitle{

    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    self.navView.backgroundColor = [UIColor colorWithHexString:@"2089EB"];
    [self.view addSubview:self.navView];


    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.navView.frame.size.width - 15 - 32, 20, 32, 44)];
    [self.closeBtn setImage:[UIImage imageNamed:@"navbar_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closePage:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.closeBtn];


    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
    titleLabel.text = @"所有照片";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment  = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.center = CGPointMake(self.navView.center.x , self.navView.center.y + 10);
    [self.navView addSubview:titleLabel];


    self.selectedView = [CHSelectedViews loadView];
    self.selectedView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 74);
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectedView];

    __weak typeof(self)WeakSelf = self;

    self.selectedView.commit = ^{

        [WeakSelf closePage:1];

    };

    self.selectedView.remove = ^(int index) {

        if (WeakSelf.allSelectedPhotos.count > 0) {

            CHPhotoModel *model = WeakSelf.allSelectedPhotos[index];
            CHAlbumListCell *cell = (CHAlbumListCell *)[WeakSelf.collectionView cellForItemAtIndexPath:model.indexPath];

            cell.isSelected = NO;
            cell.coverView.hidden = YES;

            [WeakSelf.collectionView reloadItemsAtIndexPaths:@[model.indexPath]];

            [WeakSelf.allSelectedPhotos removeObjectAtIndex:index];
            [WeakSelf deleteAddUI];
        }
    };

}

- (void)closePage:(BOOL)isSendMessage{

    if (isSendMessage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedPhotos" object:self.allSelectedPhotos];
    }
    self.selectedView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumModelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHAlbumListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor  =[UIColor redColor];
    cell.model = self.albumModelArray[indexPath.item];
    return cell;
}
#pragma mark - < UICollectionViewDelegate >
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CHPhotoModel *model = self.albumModelArray[indexPath.item];
    CHAlbumListCell *cell = (CHAlbumListCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (self.allSelectedPhotos.count >= _manager.configuration.photoMaxNum) {
        if(cell.isSelected){
            [self.allSelectedPhotos removeObject:model];
        }else{
            [self alert];
            return;
        }
    }else{
        if (cell.isSelected) {
            [self.allSelectedPhotos removeObject:model];
        }else{
            model.indexPath = indexPath;
            [self.allSelectedPhotos addObject:model];
        }
    }

    [cell selectedIndexPath:indexPath model:model photos:self.allSelectedPhotos];

    [self selectedViewUI];

    [self deleteAddUI];

}

- (void)deleteAddUI{

    if (self.allSelectedPhotos.count > 0) {

        if (self.allSelectedPhotos.count == 1) {

            self.selectedView.firstImg.hidden = NO;

            CHPhotoModel *model = self.allSelectedPhotos[0];

            [CHPhotoManager getPhotoForPHAsset:model.asset size:model.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.firstImage.image = image;
            }];

            self.selectedView.secondImg.hidden = YES;
            self.selectedView.thirdImg.hidden = YES;
            self.selectedView.fourImg.hidden = YES;

        }else if (self.allSelectedPhotos.count == 2){

            CHPhotoModel *model1 = self.allSelectedPhotos[0];
            CHPhotoModel *model2 = self.allSelectedPhotos[1];

            self.selectedView.firstImg.hidden = NO;
            self.selectedView.secondImg.hidden = NO;

            [CHPhotoManager getPhotoForPHAsset:model1.asset size:model1.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.secondImage.image = image;
            }];

            [CHPhotoManager getPhotoForPHAsset:model2.asset size:model2.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.firstImage.image = image;
            }];

            self.selectedView.thirdImg.hidden = YES;
            self.selectedView.fourImg.hidden = YES;

        }else if (self.allSelectedPhotos.count == 3){

            CHPhotoModel *model1 = self.allSelectedPhotos[0];
            CHPhotoModel *model2 = self.allSelectedPhotos[1];
            CHPhotoModel *model3 = self.allSelectedPhotos[2];

            self.selectedView.firstImg.hidden = NO;
            self.selectedView.secondImg.hidden = NO;
            self.selectedView.thirdImg.hidden = NO;

            [CHPhotoManager getPhotoForPHAsset:model1.asset size:model1.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.secondImage.image = image;
            }];

            [CHPhotoManager getPhotoForPHAsset:model2.asset size:model2.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.firstImage.image = image;
            }];

            [CHPhotoManager getPhotoForPHAsset:model3.asset size:model3.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.thirdImage.image = image;
            }];

            self.selectedView.fourImg.hidden = YES;

        }else if (self.allSelectedPhotos.count == 4){

            CHPhotoModel *model1 = self.allSelectedPhotos[0];
            CHPhotoModel *model2 = self.allSelectedPhotos[1];
            CHPhotoModel *model3 = self.allSelectedPhotos[2];
            CHPhotoModel *model4 = self.allSelectedPhotos[3];

            self.selectedView.firstImg.hidden = NO;
            self.selectedView.secondImg.hidden = NO;
            self.selectedView.thirdImg.hidden = NO;
            self.selectedView.fourImg.hidden = NO;

            [CHPhotoManager getPhotoForPHAsset:model1.asset size:model1.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.secondImage.image = image;
            }];

            [CHPhotoManager getPhotoForPHAsset:model2.asset size:model2.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.firstImage.image = image;
            }];

            [CHPhotoManager getPhotoForPHAsset:model3.asset size:model3.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.thirdImage.image = image;
            }];

            [CHPhotoManager getPhotoForPHAsset:model4.asset size:model4.size completion:^(UIImage *image, NSDictionary *info) {
                self.selectedView.fourImage.image = image;
            }];

        }

    }else{

        [UIView animateWithDuration:0.3 animations:^{
            self.selectedView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 74);
        }];
    }


    self.selectedView.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.allSelectedPhotos.count,_manager.configuration.photoMaxNum];

}

// 底部选中图片显示/隐藏
- (void)selectedViewUI{

    if(self.allSelectedPhotos.count > 0){
        [UIView animateWithDuration:0.3 animations:^{
            self.selectedView.frame = CGRectMake(0, KScreenHeight - 74, KScreenWidth, 74);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.selectedView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 74);
        }];
    }

}

- (void)alert{

    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"最大数量限制" message:@"最多选择4张" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertV addAction:ok];

    [self presentViewController:alertV animated:YES completion:nil];

}

#pragma mark - < UICollectionViewDelegate >

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

- (NSMutableArray *)allSelectedPhotos{
    if (!_allSelectedPhotos) {
        _allSelectedPhotos = [NSMutableArray array];
    }
    return _allSelectedPhotos;
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

- (NSMutableArray *)albumModelArray{

    if (!_albumModelArray) {
        _albumModelArray = [NSMutableArray array];
    }
    return _albumModelArray;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



@interface CHAlbumListQuadrateViewCell : UICollectionViewCell

@property (strong, nonatomic) CHAlbumModel *model;

- (void)cancelRequest ;

@end
