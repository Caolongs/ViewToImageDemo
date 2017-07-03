//
//  LJShowImageView.m
//  ViewToImageDemo
//
//  Created by cao longjian on 17/6/22.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import "LJShowImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface LJShowImageView ()
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, copy)   dispatch_block_t confirmBlock;
@property (nonatomic, strong) UIImage *image;

@end

@implementation LJShowImageView

+ (LJShowImageView *)showViewWithImage:(UIImage *)image confirmBlock:(dispatch_block_t)confirmBlock {
    LJShowImageView *showView = [[LJShowImageView alloc] initWithImage:image confirmBlock:confirmBlock];
    [showView show];
    return showView;
}

- (instancetype)initWithImage:(UIImage *)image confirmBlock:(dispatch_block_t)confirmBlock {

    if (self = [super init]) {
        self.frame      = [UIScreen mainScreen].bounds;
        _confirmBlock   = confirmBlock;
        _image          = image;
        
        CGRect imgRect = CGRectMake(self.contentView.bounds.size.width * 0.1, 15, self.contentView.bounds.size.width * 0.8, self.contentView.bounds.size.height * 0.8);
        UIImageView * imgv  = [[UIImageView alloc] initWithFrame:imgRect];
        imgv.image          = image;
        
        UIButton *saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame       = CGRectMake(0, 0, imgRect.size.width * 0.5, 44);
        saveBtn.center      = CGPointMake(imgv.center.x, CGRectGetMaxY(imgv.frame) + 32);
        saveBtn.backgroundColor = [UIColor blueColor];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.layer.cornerRadius  = 22;
        saveBtn.layer.masksToBounds = YES;
        
        [self addSubview:self.bgView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:imgv];
        [self.contentView addSubview:saveBtn];
        
    }
    return self;
}

- (void)saveClickBtn:(UIButton *)btn {
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    
    if (authStatus == PHAuthorizationStatusNotDetermined) { // 未授权
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            //不考虑
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self writeToAlbum];
                } else if (status == PHAuthorizationStatusDenied) {
                    [self failed];
                } else if (status == PHAuthorizationStatusRestricted) {
                    [self failed];
                }
            }];
        }
        
    } else if (authStatus == PHAuthorizationStatusAuthorized) {
        [self writeToAlbum];
    } else if (authStatus == PHAuthorizationStatusDenied) {
        [self failed];
    } else if (authStatus == PHAuthorizationStatusRestricted) {
        [self failed];
    }
    
    
}

- (void)writeToAlbum {
    UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    
}

- (void)failed {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self dismiss];
}


//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismiss];
    }];
    [alert addAction:action];
    id vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc showViewController:alert sender:nil];
}

-(void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.5;
    }];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)])
    {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
    
    [self springingAnimationWithView:self.contentView];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        
        self.contentView.center = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+40);
        self.bgView.alpha       = 0.0;
        self.contentView.alpha  = 0.0;
        
    } completion:^(BOOL finished){
        
        [self removeFromSuperview];
        
    }];
}
-(void)dealloc
{
    _confirmBlock = nil;
}

- (void)springingAnimationWithView:(UIView *)view {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[view layer] addAnimation:popAnimation forKey:nil];
}

- (UIView*)bgView {
    if (!_bgView) {
        _bgView=[[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor=[UIColor blackColor];
        _bgView.alpha=0.0f;
    }
    return _bgView;
}

- (UIView*)contentView {
    if (!_contentView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGRect imgRect = CGRectMake(screenSize.width * 0.1, screenSize.height * 0.2, screenSize.width * 0.8, screenSize.height * 0.6);
        _contentView = [[UIView alloc] initWithFrame:imgRect];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor=[UIColor whiteColor];
    }
    return _contentView;
}



@end
