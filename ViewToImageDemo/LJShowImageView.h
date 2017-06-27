//
//  LJShowImageView.h
//  ViewToImageDemo
//
//  Created by cao longjian on 17/6/22.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJShowImageView : UIView

+ (LJShowImageView *)showViewWithImage:(UIImage *)image inView:(UIView *)superView confirmBlock:(dispatch_block_t)confirmBlock;

@end
