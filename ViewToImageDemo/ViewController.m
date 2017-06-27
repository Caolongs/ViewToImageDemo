//
//  ViewController.m
//  ViewToImageDemo
//
//  Created by cao longjian on 17/6/22.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+View.h"
#import "LJShowImageView.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor grayColor];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    imageV.backgroundColor = [UIColor yellowColor];
    [view addSubview:imageV];
    
    self.shareView = view;
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0, 0, 100, 44);
    clickBtn.center = self.view.center;
    clickBtn.backgroundColor = [UIColor redColor];
    [clickBtn setTitle:@"生成图片" forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
    
    
}
- (void)clickBtn:(UIButton *)btn {
    UIImage *viewImage = [UIImage createViewImage:self.shareView];
    [LJShowImageView showViewWithImage:viewImage inView:self.view confirmBlock:^{
        
    }];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
