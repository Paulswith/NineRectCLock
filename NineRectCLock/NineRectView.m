//
//  NineRectView.m
//  NineRectCLock
//
//  Created by Dobby on 2017/8/16.
//  Copyright © 2017年 Dobby. All rights reserved.
//

#import "NineRectView.h"
#import "ViewController.h"


#define passWD @"034678"      //可以根据需要, 进行沙盒存储
@interface NineRectView()

@property(assign,nonatomic)CGPoint locatePoin; //
@property(strong,nonatomic)NSMutableArray *selectBtnArray; //
@property(strong,nonatomic)UIAlertController *alertContrl; //

@end

@implementation NineRectView


+ (instancetype)nineRectViewWithFrame:(CGRect)frame {
    NineRectView *nineView = [[NineRectView alloc] init];
    nineView.backgroundColor = [UIColor clearColor];
    nineView.frame = frame;
    return nineView;
}

#pragma mark - 根据事件操作进行绘制
/*开始点击, 首个启动绘制逻辑*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.locatePoin = [self pointWithTouches:touches];   //保存当前点
    for (UIButton *btn in self.subviews) {                                      //遍历拿到子控件
        if (CGRectContainsPoint(btn.frame, self.locatePoin) && !btn.isSelected) {   //
            btn.selected = YES;
            [self.selectBtnArray addObject:btn];
            [self setNeedsDisplay];    //首次确认点到九宫格了再开始绘制
        }
    }
}
/*移动中,添加到选中数组*/
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.locatePoin = [self pointWithTouches:touches];
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, self.locatePoin) && !btn.isSelected) {
            btn.selected = YES;
            [self.selectBtnArray addObject:btn];
        }
    }
    [self setNeedsDisplay]; //每次移动都需要绘制, 因为有跟随点移动
}
/*结束移动的时候, 移除*/
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectBtnArray.count) {                                  //避免点击空白处也进入处理逻辑,减少内存损耗
        NSMutableString *mutableString = [NSMutableString string];    //临时字符串 保存当前密码
        for (UIButton *btn in self.selectBtnArray) {
            btn.selected = NO;
            [mutableString appendFormat:@"%ld",btn.tag];         //tag属性对象当前的索引, 可以为密码
        }
        [self.selectBtnArray removeAllObjects];
        [self setNeedsDisplay];
        NSLog(@"%@",mutableString);
        [self alretMessageWithBool:[mutableString  isEqualToString:passWD]];       //弹窗处理
        
    }

}

- (void)drawRect:(CGRect)rect {
    if (self.selectBtnArray.count) {                                    //初始化view的时候就不要绘制了
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        for (int i=0; i< self.selectBtnArray.count; i++) {
            UIButton *btn =  self.selectBtnArray[i];
            if (i == 0) {
                [bezierPath moveToPoint:btn.center];
            }else{
                [bezierPath addLineToPoint:btn.center];
            }
        }
        [bezierPath setLineWidth:10];
        [[UIColor redColor] set];
        [bezierPath setLineJoinStyle:kCGLineJoinRound];
        [bezierPath addLineToPoint:self.locatePoin];
        [bezierPath stroke];
    }
    
}

#pragma mark - 方法剥离
/**
 根据touchese返回当前点
 */
- (CGPoint)pointWithTouches:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    return  [touch locationInView:self];
}


#pragma mark - ErrorAlert
- (void)alretMessageWithBool:(BOOL)isPasswdEqual {
    if (isPasswdEqual) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isPasswdEqual" object:nil userInfo:nil];
    }else{
        [[self currentVC] presentViewController:self.alertContrl animated:YES completion:nil];
    }
}

- (UIViewController *)currentVC {
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(currentVC.presentedViewController){
        currentVC = currentVC.presentedViewController;
    }
    return currentVC;
}


#pragma mark - lazyLoad
- (NSMutableArray *)selectBtnArray {
    if (!_selectBtnArray) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 \\ for 错误弹窗
 是否有必要存在该单例?该页面调用频繁,绘制频繁~~
 */
- (UIAlertController *)alertContrl {
    if (!_alertContrl) {
        _alertContrl = [UIAlertController alertControllerWithTitle:@"密码错误" message:@"请重新输入正确密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [_alertContrl addAction:sureAction];
    }
    return _alertContrl;
}
@end
