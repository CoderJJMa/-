//
//  UIView+Extension.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "UIView+Extension.h"
#import "CHPhotoManager.h"

@implementation UIView (Extension)

- (void)setHx_x:(CGFloat)hx_x
{
    CGRect frame = self.frame;
    frame.origin.x = hx_x;
    self.frame = frame;
}

- (CGFloat)hx_x
{
    return self.frame.origin.x;
}

- (void)setHx_y:(CGFloat)hx_y
{
    CGRect frame = self.frame;
    frame.origin.y = hx_y;
    self.frame = frame;
}

- (CGFloat)hx_y
{
    return self.frame.origin.y;
}

- (void)setHx_w:(CGFloat)hx_w
{
    CGRect frame = self.frame;
    frame.size.width = hx_w;
    self.frame = frame;
}

- (CGFloat)hx_w
{
    return self.frame.size.width;
}

- (void)setHx_h:(CGFloat)hx_h
{
    CGRect frame = self.frame;
    frame.size.height = hx_h;
    self.frame = frame;
}

- (CGFloat)hx_h
{
    return self.frame.size.height;
}

- (void)setHx_size:(CGSize)hx_size
{
    CGRect frame = self.frame;
    frame.size = hx_size;
    self.frame = frame;
}

- (CGSize)hx_size
{
    return self.frame.size;
}

- (void)setHx_origin:(CGPoint)hx_origin
{
    CGRect frame = self.frame;
    frame.origin = hx_origin;
    self.frame = frame;
}

- (CGPoint)hx_origin
{
    return self.frame.origin;
}

/**
 获取当前视图的控制器

 @return 控制器
 */
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (CGFloat)getTextWidth:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize {
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;

    return newSize.width;
}

- (CGFloat)getTextHeight:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize {
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;

    return newSize.height;
}

-(void)setX:(CGFloat)x
{
    CGRect tempF = self.frame;
    tempF.origin.x = x;
    self.frame = tempF;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGRect tempF = self.frame;
    tempF.origin.y = y ;
    self.frame = tempF;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width
{
    CGRect tempF = self.frame;
    tempF.size.width = width;
    self.frame = tempF;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint tempF = self.center;
    tempF.x = centerX;
    self.center = tempF;
}
-(CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint tempF = self.center;
    tempF.y = centerY;
    self.center = tempF;
}
-(CGFloat)centerY
{
    return self.center.y;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height
{
    CGRect tempF = self.frame;
    tempF.size.height = height;
    self.frame = tempF;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setSize:(CGSize)size
{
    CGRect tempF = self.frame;
    tempF.size = size;
    self.frame = tempF;
}
-(CGSize)size
{
    return self.frame.size;
}

- (void)showImageHUDText:(NSString *)text {
    CGFloat hudW = [self getTextWidth:text height:15 fontSize:14];
    if (hudW > self.frame.size.width - 60) {
        hudW = self.frame.size.width - 60;
    }
    CGFloat hudH = [self getTextHeight:text width:hudW fontSize:14];
    if (hudW < 100) {
        hudW = 100;
    }
    HXHUD *hud = [[HXHUD alloc] initWithFrame:CGRectMake(0, 0, hudW + 20, 110 + hudH - 15) imageName:@"alert_failed_icon" text:text];
    hud.alpha = 0;
    hud.tag = 1008611;
    [self addSubview:hud];
    hud.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        hud.alpha = 1;
    }];
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(handleGraceTimer) withObject:nil afterDelay:1.5f inModes:@[NSRunLoopCommonModes]];
}

- (void)showLoadingHUDText:(NSString *)text {
//    CGFloat hudW = [HXPhotoTools getTextWidth:text height:15 fontSize:14];
//    if (hudW > self.frame.size.width - 60) {
//        hudW = self.frame.size.width - 60;
//    }
//    CGFloat hudH = [HXPhotoTools getTextHeight:text width:hudW fontSize:14];
//    CGFloat width = 110;
//    CGFloat height = width + hudH - 15;
//    if (!text) {
//        width = 95;
//        height = 95;
//    }
//    HXHUD *hud = [[HXHUD alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:@"alert_failed_icon@2x.png" text:text];
//    [hud showloading];
//    hud.alpha = 0;
//    hud.tag = 10086;
//    [self addSubview:hud];
//    hud.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
//    [UIView animateWithDuration:0.25 animations:^{
//        hud.alpha = 1;
//    }];
}

- (void)handleLoading {
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    for (UIView *view in self.subviews) {
        if (view.tag == 10086) {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

- (void)handleGraceTimer {
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    for (UIView *view in self.subviews) {
        if (view.tag == 1008611) {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}


@end


@interface HXHUD ()
@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *text;
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation HXHUD

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        self.imageName = imageName;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        [self setup];
    }
    return self;
}

- (void)setup {
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[HXPhotoTools hx_imageNamed:self.imageName]];
//    [self addSubview:imageView];
//    CGFloat imgW = imageView.image.size.width;
//    CGFloat imgH = imageView.image.size.height;
//    CGFloat imgCenterX = self.frame.size.width / 2;
//    imageView.frame = CGRectMake(0, 20, imgW, imgH);
//    imageView.center = CGPointMake(imgCenterX, imageView.center.y);
//    self.imageView = imageView;
//
//    UILabel *label = [[UILabel alloc] init];
//    label.text = self.text;
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:14];
//    label.numberOfLines = 0;
//    [self addSubview:label];
//    CGFloat labelX = 10;
//    CGFloat labelY = CGRectGetMaxY(imageView.frame) + 10;
//    CGFloat labelW = self.frame.size.width - 20;
//    CGFloat labelH = [HXPhotoTools getTextHeight:self.text width:labelW fontSize:14];
//    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

- (void)showloading {
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    [self addSubview:loading];
    if (self.text) {
        loading.frame = self.imageView.frame;
    }else {
        loading.frame = self.bounds;
    }
    self.imageView.hidden = YES;
}
@end
