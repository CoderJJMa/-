//
//  TakePhtotView.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/25.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "CameraVC.h"
#import "CHPhotoModel.h"

//导入相机框架
#import <AVFoundation/AVFoundation.h>
//将拍摄好的照片写入系统相册中，所以我们在这里还需要导入一个相册需要的头文件iOS8
#import <Photos/Photos.h>

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height
#define BottomHeight 55

#define Tag 1024

@interface CameraVC()

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

// ------------- UI --------------
//拍照按钮
@property (nonatomic)UIButton *photoButton;
//闪光灯按钮
@property (nonatomic)UIButton *flashButton;
//聚焦
@property (nonatomic)UIView *focusView;
//是否开启闪光灯
@property (nonatomic)BOOL isflashOn;

@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)UIView *takeFinishView;

@end


@implementation CameraVC

- (instancetype)init{

    if (self == [super init]) {
        self.view.backgroundColor = [UIColor lightGrayColor];

    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    if ( [self checkCameraPermission]) {

        [self customCamera];
        [self initSubViews];

        [self focusAtPoint:CGPointMake(0.5, 0.5)];

    }
}

- (void)customCamera
{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];

    self.ImageOutPut = [[AVCaptureStillImageOutput alloc]init];
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    }

    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];

    }

    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }

    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 60 - 125);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];

    //开始启动
    [self.session startRunning];

    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {

        //闪光灯自动
//        if ([self.device supportsAVCaptureSessionPreset:AVCaptureFlashModeAuto]) {
//            [self.device AVCapturePhotoSettings.flashMode];
//        }

        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }

        //解锁
        [self.device unlockForConfiguration];


    }

}

- (void)initSubViews
{
    // 关闭按钮
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(20, 20, 32, 44);
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"navbar_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(disMiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    // 底部的整体的view
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 - 125, self.view.frame.size.width, 130)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];

    // 拍照的button
    self.photoButton = [UIButton new];
    [self.photoButton setImage:[UIImage imageNamed:@"phtoto_btn_take"] forState:UIControlStateNormal];
    [self.photoButton addTarget:self action:@selector(shutterCamera)
               forControlEvents:UIControlEventTouchUpInside];
    self.photoButton.frame = CGRectMake(0, 0, 70, 70);
    self.photoButton.center = CGPointMake(self.view.bounds.size.width / 2, self.bottomView.frame.size.height / 2 + 10);
    [self.bottomView addSubview:self.photoButton];

    //
    self.focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.focusView.layer.borderWidth = 1.0;
    self.focusView.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:self.focusView];
    self.focusView.hidden = YES;

    // 切换前后镜头按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setTitle:@"切换" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"phtoto_icon_camera"] forState:UIControlStateNormal];

    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    leftButton.frame = CGRectMake(self.view.frame.size.width - 50, 30, 32, 44);
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];


    // 闪光灯按钮
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [ self.flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"phtoto_icon_lamp_hover"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"phtoto_icon_lamp_normal"] forState:UIControlStateSelected];

    self.flashButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.flashButton.frame = CGRectMake(self.view.frame.size.width - 100, 30, 32, 44);
    [self.flashButton sizeToFit];
    [ self.flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.flashButton];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];


    // 拍完照后显示的 view
    self.takeFinishView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 - 125, self.view.frame.size.width, 130)];
    self.takeFinishView.backgroundColor = [UIColor whiteColor];
    self.takeFinishView.hidden = YES;
    [self.view addSubview:self.takeFinishView];


    // 左侧的返回按钮
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.takeFinishView.frame.size.width / 2, self.takeFinishView.frame.size.height)];
    leftV.backgroundColor = [UIColor whiteColor];

    UIImageView *leftBackImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phtoto_btn_back"]];
    leftBackImg.frame = CGRectMake(0, leftV.frame.size.height - 65, 70, 70);
    CGPoint point = CGPointMake(70, 75);
    leftBackImg.center = CGPointMake(leftV.frame.size.width - 70, 75);
    [leftV addSubview:leftBackImg];


    [self.takeFinishView addSubview:leftV];

    // 右侧的确定按钮
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftV.frame), 0, self.takeFinishView.frame.size.width / 2, self.takeFinishView.frame.size.height)];
    rightV.backgroundColor = [UIColor whiteColor];

    UIImageView *commitImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phtoto_btn_determine"]];
    commitImg.frame = CGRectMake(0, 0, 70, 70);
    commitImg.center = point;

    [rightV addSubview:commitImg];

    [self.takeFinishView addSubview:rightV];



    leftBackImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [leftBackImg addGestureRecognizer:tapBack];


    commitImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *commitB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commit)];
    [commitImg addGestureRecognizer:commitB];


}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );

    if ([self.device lockForConfiguration:nil]) {

        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }

        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }

        [self.device unlockForConfiguration];

        __weak typeof(_focusView) weakFocusView = _focusView;

        _focusView.center = point;
        _focusView.hidden = NO;

        [UIView animateWithDuration:0.3 animations:^{
            weakFocusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                weakFocusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                weakFocusView.hidden = YES;
            }];
        }];
    }

}

- (void)FlashOn{

    self.flashButton.selected = !self.flashButton.selected;

    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                [_flashButton setTitle:@"闪光灯开" forState:UIControlStateNormal];
            }
        }

        [_device unlockForConfiguration];
    }
}

- (void)changeCamera{
    //获取摄像头的数量
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //摄像头小于等于1的时候直接返回
    if (cameraCount <= 1) return;

    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向(前还是后)
    AVCaptureDevicePosition position = [[self.input device] position];

    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";

    if (position == AVCaptureDevicePositionFront) {
        //获取后置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
    }else{
        //获取前置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }

    [self.previewLayer addAnimation:animation forKey:nil];
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];


    if (newInput != nil) {

        [self.session beginConfiguration];
        //先移除原来的input
        [self.session removeInput:self.input];

        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;

        } else {
            //如果不能加现在的input，就加原来的input
            [self.session addInput:self.input];
        }

        [self.session commitConfiguration];

    }


}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}


#pragma mark- 拍照
- (void)shutterCamera{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];

    if (videoConnection ==  nil) {
        return;
    }
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

        if (imageDataSampleBuffer == nil) {
            return;
        }
        NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self saveImageWithImage:[UIImage imageWithData:imageData]];
    }];
}
/**
 * 保存图片到相册
 */
- (void)saveImageWithImage:(UIImage *)image {

    if (image) {

        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        imageV.tag = Tag;
        imageV.contentMode = UIViewContentModeScaleToFill;
        imageV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 60 - 125);
        [self.view addSubview:imageV];

        self.takeFinishView.hidden = NO;
        self.bottomView.userInteractionEnabled = NO;
        self.bottomView.hidden = YES;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"BottomViewChanged" object:@1];
        
    }

}

- (void)disMiss:(BOOL)isSendMessage{

    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark- 检测相机权限
- (BOOL)checkCameraPermission
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:cancel];

        return NO;

    }
    else{
        return YES;
    }
    return YES;
}

- (void)back{

    UIImageView *image = [self.view viewWithTag:Tag];
    [image removeFromSuperview];

    self.takeFinishView.hidden = YES;
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.hidden = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"BottomViewChanged" object:@0];

}

- (void)commit{

    UIImageView *image = [self.view viewWithTag:Tag];

    [self back];

    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadImageFinished:image.image];
        });


    }];

}

- (void)loadImageFinished:(UIImage *)image
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];

    } completionHandler:^(BOOL success, NSError * _Nullable error) {

        NSLog(@"success = %d, error = %@", success, error);

        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                imageAsset = obj;
                *stop = YES;
            }];

            if (imageAsset){
                
                CHPhotoModel *model = [[CHPhotoModel alloc] init];
                model.asset = imageAsset;
                NSMutableArray *array = [NSMutableArray array];
                 [array addObject:model];
                [self disMiss:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedPhotos" object:array];
                //加载图片数据
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                                                                  options:nil
                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {

                                                                NSLog(@"imageData = %@", imageData);

                                                            }];
            }
        }

    }];
}




@end
