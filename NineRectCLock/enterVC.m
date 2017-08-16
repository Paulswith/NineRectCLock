//
//  enterVC.m
//  NineRectCLock
//
//  Created by Dobby on 2017/8/16.
//  Copyright © 2017年 Dobby. All rights reserved.
//

#import "enterVC.h"

@interface enterVC ()
@property(strong,nonatomic)UIImageView *imageView; //
@end

@implementation enterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    /*隐藏状态栏*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]; //左按钮去除

    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _imageView.image = [UIImage imageNamed:@"youcool"];
    }
    return _imageView;
}



@end
