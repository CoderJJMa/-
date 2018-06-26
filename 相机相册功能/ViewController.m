//
//  ViewController.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/22.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "ViewController.h"
#import "AlbmsView.h"
#import "CameraView.h"

#define SelectedColor [UIColor blueColor]
#define UnSelectedColor [UIColor blackColor]
#define SelfHeight  self.view.frame.size.height
#define SelfWidth  self.view.frame.size.width
#define BottomHeight 55

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)AlbmsView *albmsView;
@property (nonatomic,strong)CameraView *takePhtotView;

//@property (nonatomic,strong)MainPagePhotosView *photosView;

@property (nonatomic,strong)UIScrollView *scrollView;


@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)UIView *bottomView2;

@property (nonatomic,strong)UIButton *takePhotoBtn;
@property (nonatomic,strong)UIButton *albmPhotoBtn;

@property (nonatomic,strong)UIView *leftLine;
@property (nonatomic,strong)UIView *rightLine;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, self.view.frame.size.height - BottomHeight)];
    self.scrollView.contentSize = CGSizeMake(SelfWidth * 2, self.scrollView.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];

    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;


    self.albmsView = [[AlbmsView alloc] init];
    self.albmsView.view.frame = CGRectMake(SelfWidth, 0, SelfWidth, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.albmsView.view];
    [self addChildViewController:self.albmsView];
//    [self.albmsView directGoPhotoViewController];



    self.takePhtotView = [[CameraView alloc] init];
    self.takePhtotView.view.frame = CGRectMake(0, 0, SelfWidth, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.takePhtotView.view];
    [self addChildViewController:self.takePhtotView];


    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SelfHeight - BottomHeight, SelfWidth, BottomHeight)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView];


    CGFloat margin = 20;
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth / 2 - margin, BottomHeight)];
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(SelfWidth / 2 + margin, 0, SelfWidth / 2 - margin, BottomHeight)];

    [self.bottomView addSubview:leftV];
    [self.bottomView addSubview:rightV];

    CGFloat btnwidth = 40;
    CGFloat btnheigh = 40;

    self.takePhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftV.frame.size.width - 60, 15, btnwidth, btnheigh)];
    [self.takePhotoBtn setTitle:@"拍摄" forState:UIControlStateNormal];
    [self.takePhotoBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.takePhotoBtn.tag = 1004;
    [self.takePhotoBtn setTitleColor:UnSelectedColor forState:UIControlStateNormal];
    [self.takePhotoBtn setTitleColor:SelectedColor forState:UIControlStateSelected];
    self.takePhotoBtn.selected = YES;

    CGFloat lineHeight = 4;

    self.leftLine = [[UIView alloc] initWithFrame:CGRectMake(self.takePhotoBtn.frame.origin.x, self.bottomView.frame.size.height - lineHeight, self.takePhotoBtn.frame.size.width, lineHeight)];
    self.leftLine.layer.cornerRadius = self.leftLine.frame.size.height / 2;
    self.leftLine.backgroundColor = [UIColor blueColor];
    [leftV addSubview:self.leftLine];
    [leftV addSubview:self.takePhotoBtn];


    self.albmPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, btnwidth, btnheigh)];
    [self.albmPhotoBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.albmPhotoBtn setTitle:@"相册" forState:UIControlStateNormal];
    self.albmPhotoBtn.tag = 1005;
    [self.albmPhotoBtn setTitleColor:UnSelectedColor forState:UIControlStateNormal];
    [self.albmPhotoBtn setTitleColor:SelectedColor forState:UIControlStateSelected];

    self.rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.albmPhotoBtn.frame.origin.x, self.bottomView.frame.size.height - lineHeight , self.albmPhotoBtn.frame.size.width, lineHeight)];
    self.rightLine.layer.cornerRadius = self.leftLine.frame.size.height / 2;
    self.rightLine.backgroundColor = [UIColor blueColor];
    self.rightLine.hidden = YES;

    [rightV addSubview:self.rightLine];
    [rightV addSubview:self.albmPhotoBtn];


    self.navigationController.navigationBar.hidden = YES;


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBottomView:) name:@"BottomViewChanged" object:nil];



    self.bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(0, SelfHeight - BottomHeight, SelfWidth, BottomHeight)];
    self.bottomView2.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView2];


    [self addLabel:@"返回" frame:0 color:[UIColor lightGrayColor]];
    [self addLabel:@"确定" frame:1 color:[UIColor blueColor]];
    self.bottomView2.hidden = YES;

}

- (void)addLabel:(NSString *)content frame:(int)frame color:(UIColor *)color{

    UILabel *backLabel = [[UILabel alloc] init];

//    CGFloat margin = 20;
//    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth / 2 - margin, BottomHeight)];
//    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(SelfWidth / 2 + margin, 0, SelfWidth / 2 - margin, BottomHeight)];
//    [self.bottomView2 addSubview:leftV];
//    [self.bottomView2 addSubview:rightV];
//
//    CGFloat btnwidth = 40;
//    CGFloat btnheigh = 40;

    if (frame) {
        backLabel.frame = CGRectMake( SelfWidth / 2 + 50, 5, 40, 20);
    }else{
        backLabel.frame = CGRectMake(self.takePhotoBtn.frame.origin.x + self.takePhotoBtn.frame.size.width / 2 - 30 , 5, 40, 20);
    }
    backLabel.text = content;

    backLabel.textColor = color;
    backLabel.textAlignment = NSTextAlignmentCenter;
    backLabel.font = [UIFont systemFontOfSize:16];
    backLabel.backgroundColor = [UIColor whiteColor];

    [self.bottomView2 addSubview:backLabel];

}


- (void)showBottomView:(NSNotification *)notify{

    NSNumber *num = notify.object;

    [[UIApplication sharedApplication].keyWindow viewWithTag:1111];

    if ([num  isEqual: @1]) {
        self.bottomView.hidden = YES;
        self.bottomView2.hidden = NO;
    }else{
        self.bottomView.hidden = NO;
        self.bottomView2.hidden = YES;
    }

}


// =========== UIScrollViewDelegate  =========
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x == SelfWidth) {
        [self changBottomUI:NO];
    }else if(scrollView.contentOffset.x == 0){
        [self changBottomUI:YES];
    }
}


- (void)clickBtn:(UIButton *)sender{


    switch (sender.tag) {
        case 1004:{
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self changBottomUI:YES];
            break;
        }
        case 1005:{
            [self.scrollView setContentOffset:CGPointMake(SelfWidth, 0) animated:YES];
            [self changBottomUI:NO];
            break;
        }
        default:
            break;
    }

}

- (void)changBottomUI:(BOOL)isLeft{

    if (isLeft) {
        self.rightLine.hidden = YES;
        self.leftLine.hidden = NO;
        self.albmPhotoBtn.selected = NO;
        self.takePhotoBtn.selected = YES;

    }else{

        self.rightLine.hidden = NO;
        self.leftLine.hidden = YES;
        self.albmPhotoBtn.selected = YES;
        self.takePhotoBtn.selected = NO;
    }

}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
