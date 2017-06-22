//
//  CustomCameraViewController.h
//  MNCustomCamera
//
//  Created by 马宁 on 2017/5/19.
//  Copyright © 2017年 ChangYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCameraViewController : UIViewController

// 获取拍照后的图片
@property (nonatomic, copy) void (^blockGetPicture)(UIImage *image);

@end
