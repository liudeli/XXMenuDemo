//
//  XXMenuViewController.m
//  XXMenuDemo
//
//  Created by shan xu on 14-4-11.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "XXMenuViewController.h"


#define scaleValue 0.875
#define menuViewWidth 250.0
#define screenWidth self.view.bounds.size.width

@interface XXMenuViewController ()
@end

@implementation XXMenuViewController
@synthesize leftMenuView;
@synthesize rightMenuView;
@synthesize rootVC;
@synthesize rootViewFrame;
@synthesize leftViewFrame;
@synthesize rightViewFrame;
@synthesize isMenuAnimate;
@synthesize rootStatusIndex;
@synthesize rootXdic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        leftMenuView = [[XXLeftMenuViewController alloc] init];
        rightMenuView = [[XXRightMenuViewController alloc] init];
        isMenuAnimate = NO;
        rootStatusIndex = RootOnMain;
        [self initFrame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"bgImg.png"];
    bgImgView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImgView];
    
    UIPanGestureRecognizer *panGus = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    panGus.delegate = self;
    panGus.delaysTouchesBegan = YES;
    panGus.cancelsTouchesInView = NO;    
    [self.view addGestureRecognizer:panGus];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
    tapGes.delegate = self;
    tapGes.numberOfTouchesRequired = 1;
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
}

- (void)panGes:(UIPanGestureRecognizer *)panGes{
    NSLog(@"isMenuAnimate-->>%d/%d",isMenuAnimate,rootStatusIndex);
    if (isMenuAnimate) {
        return;
    }
    CGPoint translation = [panGes translationInView:self.view];//x、y移动值
//    CGPoint velocity = [panGes velocityInView:self.view];//x、y移动速度
//    CGPoint pointer = [panGes locationInView:self.view];//x、y当前值

    if (panGes.state == UIGestureRecognizerStateBegan) {
        rootViewFrame = rootVC.view.frame;
        leftViewFrame = leftMenuView.view.frame;
        rightViewFrame = rightMenuView.view.frame;
        CGPoint panGesPoint = [panGes locationInView:self.view];
        CGRect rect = [self.view convertRect:rootVC.view.frame toView:self.view];
        
        if (!CGRectContainsPoint(rect, panGesPoint)) {
            return;
        }
        
        if (rootVC.view.frame.origin.x == 0) {
            rootStatusIndex = RootOnMain;
        }else if (rootVC.view.frame.origin.x == menuViewWidth){
            rootStatusIndex = RootOnRightStatic;
        }else if (rootVC.view.frame.origin.x == screenWidth-menuViewWidth-screenWidth*scaleValue){
            rootStatusIndex = RootOnLeftStatic;
        }
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        float moveX = translation.x;
        if (rootStatusIndex == RootOnMain){
            if (moveX > 0) {
                float scale = 1.0 - translation.x/2000;
                if (translation.x >= menuViewWidth) {
                    scale = 1.0 - menuViewWidth/2000;
                    moveX = menuViewWidth;
                }
                
                //缩放rootView
                rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                rootVC.view.center = CGPointMake(moveX+screenWidth*scale/2, self.view.bounds.size.height/2);
                //leftView定位
                float leftViewX = leftViewFrame.origin.x;
                CGRect changedLeftFrame = leftViewFrame;
                changedLeftFrame.origin.x = leftViewX + moveX;
                
                leftMenuView.view.frame = changedLeftFrame;
            }else{
                float scale = 1.0 + translation.x/2000;
                
                if (translation.x <= -menuViewWidth) {
                    scale = 1.0 - menuViewWidth/2000;
                    moveX = -menuViewWidth;
                }
                //缩放rootView
                rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                rootVC.view.center = CGPointMake(320+moveX-screenWidth*scale/2, self.view.bounds.size.height/2);
                //leftView定位
                float rightViewX = rightViewFrame.origin.x;
                CGRect changedRightFrame = rightViewFrame;
                changedRightFrame.origin.x = rightViewX + moveX;
                rightMenuView.view.frame = changedRightFrame;
            }
        }else if (rootStatusIndex == RootOnRightStatic) {
            if (moveX > 0){
                return;
            }else{
                float scale = 1.0 - menuViewWidth/2000 - moveX/2000;
                if (translation.x <= -menuViewWidth) {
                    scale = 1.0;
                }
                if (translation.x <= -430) {
                    moveX = -430;
                }
                if (translation.x > -430 & translation.x <= -menuViewWidth) {
                    //leftView定位
                    float rightViewX = rightViewFrame.origin.x;
                    CGRect changedrightFrame = rightViewFrame;
                    changedrightFrame.origin.x = rightViewX + moveX + menuViewWidth;
                    rightMenuView.view.frame = changedrightFrame;
                }
                //缩放rootView
                rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                rootVC.view.center = CGPointMake(menuViewWidth + moveX + screenWidth*scale/2, self.view.bounds.size.height/2);
                //leftView定位
                float leftViewX = leftViewFrame.origin.x;
                CGRect changedLeftFrame = leftViewFrame;
                changedLeftFrame.origin.x = leftViewX + moveX;
                leftMenuView.view.frame = changedLeftFrame;
            }
        }else if (rootStatusIndex == RootOnLeftStatic){
            if (moveX < 0){
                return;
            }else{
                float scale = 1.0 - menuViewWidth/2000 + moveX/2000;
                if (translation.x >= menuViewWidth) {
                    scale = 1.0;
                }
                if (translation.x >= 430) {
                    moveX = 430;
                }
                if (translation.x < 430 & translation.x >= menuViewWidth) {
                    //leftView定位
                    float leftViewX = leftViewFrame.origin.x;
                    CGRect changedLeftFrame = leftViewFrame;
                    changedLeftFrame.origin.x = leftViewX + moveX - menuViewWidth;
                    leftMenuView.view.frame = changedLeftFrame;
                }
                //缩放rootView
                rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                rootVC.view.center = CGPointMake(screenWidth-menuViewWidth-screenWidth*scale/2+moveX, self.view.bounds.size.height/2);
                //leftView定位
                float rightViewX = rightViewFrame.origin.x;
                CGRect changedRightFrame = rightViewFrame;
                changedRightFrame.origin.x = rightViewX + moveX;
                rightMenuView.view.frame = changedRightFrame;
            }
        }
    }else if (panGes.state == UIGestureRecognizerStateCancelled || panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateFailed || panGes.state == UIGestureRecognizerStatePossible){
        float moveX = translation.x;
        [self resetRootOrMenView:moveX];
    }
}
- (void)resetRootOrMenView:(float)moveX{
    NSLog(@"moveXV--->>%f/%d",moveX,rootStatusIndex);
    if (rootStatusIndex == RootOnMain) {
        if ((moveX > 0 && moveX <= 50) || (moveX < 0 && moveX >= -50)) {
            isMenuAnimate = NO;
            [self resetRootViewAndMenuView];
        }
        
        if (moveX > 50 && moveX < menuViewWidth) {
            [self showMenu:YES];
        }
        if (moveX == menuViewWidth) {
            rootStatusIndex = RootOnRightStatic;
        }
        if (moveX < 0 && moveX >= -menuViewWidth) {
            [self showMenu:NO];
        }
    }else if (rootStatusIndex == RootOnRightStatic){
        if (moveX > 0) {
            return;
        }
        if (moveX < 0 && moveX >= -50) {
            [self showMenu:YES];
        }
        if (moveX == -menuViewWidth) {
            rootStatusIndex = RootOnLeftStatic;
        }
        if (moveX < -50 && moveX > -menuViewWidth-50) {
            isMenuAnimate = NO;
            [self resetRootViewAndMenuView];
        }
        if (moveX < -menuViewWidth-50) {
            [self showMenu:NO];
        }
    }else if (rootStatusIndex == RootOnLeftStatic){
        if (moveX < 0) {
            return;
        }
        if (moveX > 0 && moveX <= 50) {
            [self showMenu:NO];
        }
        if (moveX == menuViewWidth) {
            rootStatusIndex = RootOnRightStatic;
        }
        if (moveX > 50 && moveX < menuViewWidth+50) {
            isMenuAnimate = NO;
            [self resetRootViewAndMenuView];
        }
        if (moveX > menuViewWidth+50) {
            [self showMenu:YES];
        }
    }
}
- (void)showMenu:(BOOL)isLeftMenu{
    if (isMenuAnimate) {
        return;
    }
    if (isLeftMenu) {
        if (leftMenuView.view.frame.origin.x == 0) {
            isMenuAnimate = NO;
            [self resetRootViewAndMenuView];
            return;
        }
        isMenuAnimate = YES;
        [UIView animateWithDuration:.5 animations:^{
            CGRect frame = leftMenuView.view.frame;
            frame.origin.x = 0;
            leftMenuView.view.frame = frame;
            
            //rootView缩小
            rootVC.view.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
            rootVC.view.center = CGPointMake(menuViewWidth+screenWidth*scaleValue/2, self.view.bounds.size.height/2);
        } completion:^(BOOL finished) {
            isMenuAnimate = NO;
            rootStatusIndex = RootOnRightStatic;
        }];
    }else{
        if (rightMenuView.view.frame.origin.x == screenWidth - menuViewWidth) {
            isMenuAnimate = NO;
            [self resetRootViewAndMenuView];
            return;
        }
        isMenuAnimate = YES;
        [UIView animateWithDuration:.5 animations:^{
            CGRect frame = rightMenuView.view.frame;
            frame.origin.x = screenWidth - menuViewWidth;
            rightMenuView.view.frame = frame;
            
            //rootView缩小
            rootVC.view.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
            rootVC.view.center = CGPointMake(320 - menuViewWidth-screenWidth*scaleValue/2, self.view.bounds.size.height/2);
        } completion:^(BOOL finished) {
            isMenuAnimate = NO;
            rootStatusIndex = RootOnLeftStatic;
        }];
    }
}

- (void)resetRootViewAndMenuView{
    if (isMenuAnimate) {
        return;
    }
    isMenuAnimate = YES;
    [UIView animateWithDuration:.5 animations:^{
        //leftViewMenu or rightViewMenu重置
        if (rootVC.view.frame.origin.x < 0) {
            CGRect frame = rightMenuView.view.frame;
            frame.origin.x = screenWidth;
            rightMenuView.view.frame = frame;
        }else{
            CGRect frame = rightMenuView.view.frame;
            frame.origin.x = -menuViewWidth;
            leftMenuView.view.frame = frame;
        }
        
        //rootView重置
        //            CGPoint rootPoint = rootVC.view.center;
        rootVC.view.center = self.view.center;
        rootVC.view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        isMenuAnimate = NO;
        rootStatusIndex = RootOnMain;
        NSLog(@"reset OK!");
    }];
}

- (void)tapGus:(UIPanGestureRecognizer *)tapGes{
    NSLog(@"tapGus");
    CGPoint tapGesPoint = [tapGes locationInView:self.view];
    CGRect rect = [self.view convertRect:rootVC.view.frame toView:self.view];

    if (!CGRectContainsPoint(rect,tapGesPoint)) {
        return;
    }
    if (rootStatusIndex == RootOnMain) {
        return;
    }
    isMenuAnimate = NO;
    [self resetRootViewAndMenuView];
}
- (void)initFrame{
    CGRect leftViewframe = self.view.bounds;
    leftViewframe.origin.x = -menuViewWidth;
    leftMenuView.view.frame = leftViewframe;
    
    CGRect rightViewframe = self.view.bounds;
    rightViewframe.origin.x = screenWidth;
    rightMenuView.view.frame = rightViewframe;
    
//    [self.view insertSubview:leftMenuView.view aboveSubview:rootVC.view];
//    [self.view insertSubview:rightMenuView.view aboveSubview:rootVC.view];
    [self.view addSubview:leftMenuView.view];
    [self.view addSubview:rightMenuView.view];

}
- (id)initWithRootViewController:(UIViewController *)controller{
    if ([super init]) {
        if (rootVC) {
            rootVC = nil;
        }
//        rootVC = [[UIViewController alloc] init];
        rootVC = controller;
//        rootFrame = rootVC.view.frame;
//        rootXdic = [[NSDictionary alloc] initWithObjectsAndKeys:@"originX",[NSNumber numberWithFloat:0], nil];
//        [rootXdic addObserver:self forKeyPath:@"originX" options:NSKeyValueObservingOptionOld context:nil];
//        
        
        [self.view addSubview:rootVC.view];

//        UIViewController *views = (UIViewController *)rootVC.view;
//        [rootVC.view.layer addObserver:self forKeyPath:@"frame" options:0 context:nil];
//        [rootVC.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
//        [rootVC.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
//        [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"changeValue");
    if([keyPath isEqualToString:@"originX"]) {
        //change frame of View B according to View A
    }
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    NSLog(@"changeValue");
////    CGRect newFrame;
////    if([object valueForKeyPath:keyPath] != [NSNull null]) {
////        newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
////        NSLog(@"newFrame--->>%f",newFrame.size.width);
////    }
//}
- (void)dealloc{
    [rootVC removeObserver:self forKeyPath:@"view.frame"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
