//
//  ViewController.m
//  NineRectCLock
//
//  Created by Dobby on 2017/8/16.
//  Copyright © 2017年 Dobby. All rights reserved.
//

#import "ViewController.h"
#import "NineRectView.h"
#import "enterVC.h"


#define screenSize [UIScreen mainScreen].bounds.size
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*隐藏状态栏*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_refresh_bg"]]];
    [self.view addSubview:self.nineView];
    [self setupNineBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNextpage) name:@"isPasswdEqual" object:nil];
}

- (void)setupNineBtn {
    for (int i=0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO; //拒绝时间处理, 事件处理传递到上层
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [self.nineView addSubview:btn];
    }
}
#pragma mark - 九宫格位置设置
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnWH = 74;
    CGFloat originHorizontalSpace = (self.nineView.frame.size.width - 3 * btnWH)/4;

    for (int i=0; i < self.nineView.subviews.count; i++) {
        UIButton *btn = self.nineView.subviews[i];
        btnX = originHorizontalSpace + (btnWH + originHorizontalSpace) * (i % 3);  //i%3得到列, 当前列*(间距+btn宽)
        btnY = originHorizontalSpace + (btnWH + originHorizontalSpace) * (i / 3); //i/3得到行, 当前行*(间距+btn宽)
        btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
        btn.tag = i;
    }
}

- (NineRectView *)nineView {
    if (!_nineView) {
        CGFloat horizontalSpace = 50;
        CGFloat verticalSapce = 150;
        _nineView = [NineRectView nineRectViewWithFrame:CGRectMake(horizontalSpace, verticalSapce, screenSize.width - horizontalSpace *2, screenSize.height - verticalSapce * 2)];
    }
    return _nineView;
}

- (void)pushNextpage {
    enterVC *nextPage = [[enterVC alloc] init];
    [self.navigationController pushViewController:nextPage animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
