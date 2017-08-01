//
//  TakeAPictureView.m
//  自定义相机
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 QIYIKE. All rights reserved.
//

#import "TakeAPictureView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+info.h"

@interface TakeAPictureView ()

@property (nonatomic, strong) AVCaptureSession *session;/**< 输入和输出设备之间的数据传递 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;/**< 输入设备 */
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;/**< 照片输出流 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;/**< 预览图片层 */
@property (nonatomic, strong) UIImage *image;

@end

@implementation TakeAPictureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initAVCaptureSession];
    [self initCameraOverlayView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initAVCaptureSession];
        [self initCameraOverlayView];
    }
    return self;
}

- (void)startRunning
{
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)stopRunning
{
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)initCameraOverlayView
{
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGFloat imageW = width - 40;
    CGFloat imageH = imageW / 1.6;
    CGFloat imageX = 20;
    CGFloat imageY = (height -imageH) / 2;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    imageV.clipsToBounds = YES;
    imageV.layer.borderColor = [UIColor whiteColor].CGColor;
    imageV.layer.borderWidth = 2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageY - 40, width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请将身份证放入框内拍照,只会取框内图像";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    
    
    //半透明背景View
    UIView *viewTop = [[UIView alloc] init];
    [viewTop setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    viewTop.frame = CGRectMake(0, 0, width, (height - imageH) / 2);
    
    UIView *viewLeft = [[UIView alloc] init];
    [viewLeft setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    viewLeft.frame = CGRectMake(0, (height - imageH) / 2 , imageX, imageH);
    
    UIView *viewRight = [[UIView alloc] init];
    [viewRight setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    viewRight.frame = CGRectMake(imageW + 20, (height - imageH) / 2 , imageX, imageH);
    
    UIView *viewBottom = [[UIView alloc] init];
    [viewBottom setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    viewBottom.frame = CGRectMake(0, imageY + imageH, width, height-imageY - imageH );
    
    
    [self addSubview:viewTop];
    [self addSubview:viewLeft];
    [self addSubview:viewRight];
    [self addSubview:viewBottom];
    [self addSubview:label];
    [self addSubview:imageV];
    
}

- (void)initAVCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    
    // 设置闪光灯自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    // 照片输出流
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    // 设置输出图片格式
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    // 初始化预览层
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = self.bounds;
    [self.layer addSublayer:self.previewLayer];
    
}

// 获取设备方向

- (AVCaptureVideoOrientation)getOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeRight;
    } else if ( deviceOrientation == UIDeviceOrientationLandscapeRight){
        return AVCaptureVideoOrientationLandscapeLeft;
    }
    return (AVCaptureVideoOrientation)deviceOrientation;
}

// 拍照
- (void)takeAPicture
{
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avOrientation = [self getOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avOrientation];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:jpegData];
        
        NSLog(@"%f,%f",image.size.width ,image.size.height);
        
        //定义保存图片的大小
        CGFloat width =image.size.width;
        CGFloat height =image.size.height;
        image = [UIImage image:image scaleToSize:CGSizeMake(width, height)];
        //定义裁剪
        CGFloat imageW = width - 40;
        CGFloat imageH = imageW / 1.6;
        CGFloat imageX = 20;
        CGFloat imageY = (height -imageH) / 2;
        CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
        image = [UIImage imageFromImage:image inRect:rect];
        
        //回调
        if(_blockTakePicture != nil){
            self.blockTakePicture(image);   
        }
        
    }];
    
}

- (void)setFrontOrBackFacingCamera:(BOOL)isUsingFrontFacingCamera {
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    } else {
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
}


@end
