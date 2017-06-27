//
//  UIImage+View.m
//  ViewToImageDemo
//
//  Created by cao longjian on 17/6/22.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import "UIImage+View.h"

@implementation UIImage (View)

+ (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
