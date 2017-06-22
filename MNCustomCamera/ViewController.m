//
//  ViewController.m
//  MNCustomCamera
//
//  Created by 马宁 on 2017/5/19.
//  Copyright © 2017年 ChangYou. All rights reserved.
//

#import "ViewController.h"
#import "CustomCameraViewController.h"

#define MNScreenWidth [UIScreen mainScreen].bounds.size.width
#define MNScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(nonatomic,strong)UIButton *btnTakePicture;
@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, MNScreenWidth, MNScreenHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    //拍照按钮
    _btnTakePicture = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [_btnTakePicture setBackgroundColor: [UIColor blueColor]];
    [_btnTakePicture setTitle:@"拍照" forState:UIControlStateNormal];
    CGFloat btnX = 100;
    CGFloat btnY = 100;
    CGFloat btnW = 100;
    CGFloat btnH = 44;
    _btnTakePicture.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    [_btnTakePicture addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //显示回调图片
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(20, 150, MNScreenWidth - 40, 400);
    [_imageView setBackgroundColor:[UIColor lightGrayColor]];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:_btnTakePicture];
    [self.view addSubview:_imageView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takePicture:(id)sender {
    NSLog(@"%@---点击了",self.navigationController);
    //跳转拍照
    CustomCameraViewController *controller = [[CustomCameraViewController alloc] init];
    [controller setBlockGetPicture:^(UIImage *image){
        _imageView.image = image;
    }];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
