//
//  CustomCameraViewController.m
//  MNCustomCamera
//
//  Created by 马宁 on 2017/5/19.
//  Copyright © 2017年 ChangYou. All rights reserved.
//  自定义拍照页面

#import "CustomCameraViewController.h"
#import "TakeAPictureView.h"

#define WeakSelf    __weak typeof(self) weakSelf = self;
#define StrongSelf  __strong typeof(weakSelf) self = weakSelf;

#define MNScreenWidth [UIScreen mainScreen].bounds.size.width
#define MNScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CustomCameraViewController ()

@property(nonatomic,strong)TakeAPictureView *cameraView;
@property(nonatomic,strong)UIButton *btnTakePicture;
@property(nonatomic,strong)UIButton *btnClose;

@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self initViews];
    
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}

//初始化布局
-(void)initViews
{
    //全屏
    self.view.frame = CGRectMake(0, 0, MNScreenWidth, MNScreenHeight);
    
    //拍照View
    _cameraView = [[TakeAPictureView alloc] initWithFrame:CGRectMake(0, 0, MNScreenWidth, MNScreenHeight)];
    //拍照回调
    WeakSelf
    [_cameraView setBlockTakePicture:^(UIImage *image){
        if(_blockGetPicture != nil){
            StrongSelf
            self.blockGetPicture(image);
        }
        //关闭页面
        StrongSelf
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //拍照按钮
    _btnTakePicture = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [_btnTakePicture setBackgroundImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
    CGFloat btnW = 70;
    CGFloat btnH = btnW;
    CGFloat btnY = MNScreenHeight - btnH - 40;
    CGFloat btnX = (MNScreenWidth - btnW) / 2;
    _btnTakePicture.frame = CGRectMake(btnX, btnY, btnW, btnH);

    [_btnTakePicture addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    //关闭按钮
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom] ;
    CGFloat buttonCloseW = 40;
    CGFloat buttonCloseH = buttonCloseW;
    CGFloat buttonCloseY = btnY + btnH/ 2 - buttonCloseH/ 2;
    CGFloat buttonCloseX = (btnX - buttonCloseW) / 2;
    _btnClose.frame = CGRectMake(buttonCloseX, buttonCloseY, buttonCloseW, buttonCloseH);
    
    [_btnClose addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageClose = [[UIImageView alloc] init];
    [imageClose setImage:[UIImage imageNamed:@"camera_close"]];
    [imageClose setContentMode:UIViewContentModeScaleAspectFill];
    CGFloat imageCloseW = 30;
    CGFloat imageCloseH = imageCloseW;
    CGFloat imageCloseY = btnY + btnH/ 2 - imageCloseH/ 2;
    CGFloat imageCloseX = (btnX - imageCloseW) / 2;
    imageClose.frame = CGRectMake(imageCloseX, imageCloseY, imageCloseW, imageCloseH);
    
    
    [self.view addSubview:_cameraView];
    [self.view addSubview:_btnTakePicture];
    [self.view addSubview:_btnClose];
    [self.view addSubview:imageClose];

}

- (void)closeClick:(id)sender {
    //关闭页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePicture:(id)sender {
    //照相
    [_cameraView takeAPicture];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cameraView startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.cameraView stopRunning];
}


@end
