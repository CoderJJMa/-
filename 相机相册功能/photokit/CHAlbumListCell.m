//
//  CHAlbumListCell.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "CHAlbumListCell.h"
#import "UIView+Extension.h"

@interface CHAlbumListCell()



@end


@implementation CHAlbumListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {

    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.imagev];
    [self.contentView addSubview:self.selectNumberBtn];

}

- (void)setModel:(CHPhotoModel *)model {

    _model = model;

    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];

    [[PHImageManager defaultManager] requestImageForAsset:_model.asset targetSize:CGSizeMake(self.hx_w * 1.5, self.hx_w * 1.5) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

        dispatch_async(dispatch_get_main_queue(), ^{
            self.imagev.image = result;
        });
    }];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverView.frame = CGRectMake(0, 0, self.hx_w, self.hx_w);
    self.imagev.frame = CGRectMake(0, 0, self.hx_w, self.hx_w);

    self.selectNumberBtn.hx_size =  CGSizeMake(20, 20);
    self.selectNumberBtn.hx_x = self.hx_w - 20 - 5;
    self.selectNumberBtn.hx_y = 5;
}

- (void)selectedIndexPath:(NSIndexPath *)indexPath model:(CHPhotoModel *)model{

    NSLog(@"filename : %@   indexPath : %ld",model.fileName,(long)indexPath.row);
    self.isSelected = !self.isSelected;
    self.selectNumberBtn.selected = self.isSelected;

    

}

#pragma mark - < cell懒加载 >
- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius = 4;
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
    }
    return _coverView;
}

- (UIImageView *)imagev {
    if (!_imagev) {
        _imagev = [[UIImageView alloc] init];
        _imagev.layer.masksToBounds = YES;
        _imagev.layer.cornerRadius = 4;
        _imagev.contentMode = UIViewContentModeScaleAspectFill;
        _imagev.clipsToBounds = YES;
    }
    return _imagev;
}

- (UIButton *)selectNumberBtn {
    if (!_selectNumberBtn) {
        _selectNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectNumberBtn.userInteractionEnabled = NO;
        [_selectNumberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectNumberBtn setImage:[UIImage imageNamed:@"phtoto_icon_radio"] forState:UIControlStateNormal];
        [_selectNumberBtn setImage:[UIImage imageNamed:@"phtoto_icon_choose"] forState:UIControlStateSelected];
        _selectNumberBtn.layer.cornerRadius = _selectNumberBtn.hx_w / 2;
        _selectNumberBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _selectNumberBtn;
}


@end
