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
}

- (void)panGes:(UIPanGestureRecognizer *)panGes{
    NSLog(@"panGes");
    if (isMenuAnimate) {
        return;
    }
//    CGPoint panGesPoint = [panGes locationInView:self.view];
//    CGRect rect = [self.view convertRect:rootVC.view.frame toView:self.view];
//    
//    if (!CGRectContainsPoint(rect, panGesPoint)) {
//        return;
//    }
    CGPoint translation = [panGes translationInView:self.view];//x、y移动值
//    CGPoint velocity = [panGes velocityInView:self.view];//x、y移动速度
//    CGPoint pointer = [panGes locationInView:self.view];//x、y当前值

    if (panGes.state == UIGestureRecognizerStateBegan) {
        rootViewFrame = rootVC.view.frame;
        leftViewFrame = leftMenuView.view.frame;
        rightViewFrame = rightMenuView.view.frame;

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
            }else{
                float scale = 1.0 + translation.x/2000;
                
                if (translation.x <= -menuViewWidth) {
                    scale = 1.0 - menuViewWidth/2000;
                    moveX = -menuViewWidth;
                }
                //缩放rootView
                rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                rootVC.view.center = CGPointMake(320+moveX-screenWidth*scale/2, self.view.bounds.size.height/2);
            }
        }else if (rootStatusIndex == RootOnRightStatic) {
            if (moveX > 0){
                return;
            }else{
                float scale;
                if (translation.x >= -menuViewWidth) {
                    scale = 1.0 - menuViewWidth/2000 - moveX/2000;
                }else if (translation.x > -(3*menuViewWidth-screenWidth) && translation.x < -menuViewWidth) {
                    scale = 1.0 + (moveX+menuViewWidth)/2000;
                }else if (translation.x <= -(3*menuViewWidth-screenWidth)) {
                    moveX = -(3*menuViewWidth-screenWidth);
                    scale = 1.0 + (moveX+menuViewWidth)/2000;
                }
                //缩放rootView
                rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                rootVC.view.center = CGPointMake(menuViewWidth + moveX + screenWidth*scale/2, self.view.bounds.size.height/2);
            }
        }else if (rootStatusIndex == RootOnLeftStatic){
            if (moveX < 0){
                return;
            }else{
                float scale;
                if (translation.x <= menuViewWidth) {
                    scale = 1.0 - menuViewWidth/2000 + moveX/2000;
                }else if (translation.x < 3*menuViewWidth-screenWidth && translation.x > menuViewWidth) {
                    scale = 1.0 - (moveX-menuViewWidth)/2000;
                }else if (translation.x >= 3*menuViewWidth-screenWidth) {
                    moveX = 3*menuViewWidth-screenWidth;
                    scale = 1.0 - (moveX-menuViewWidth)/2000;
                }
                
                //缩放rootView
                rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                rootVC.view.center = CGPointMake(screenWidth-menuViewWidth-screenWidth*scale/2+moveX, self.view.bounds.size.height/2);
            }
        }
    }else if (panGes.state == UIGestureRecognizerStateCancelled || panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateFailed || panGes.state == UIGestureRecognizerStatePossible){
        float moveX = translation.x;
        [self resetRootOrMenView:moveX];
    }
}
- (void)resetRootOrMenView:(float)moveX{
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
        [UIView animateWithDuration:.3 animations:^{
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
        [UIView animateWithDuration:.3 animations:^{
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
    [UIView animateWithDuration:.3 animations:^{
        //leftViewMenu or rightViewMenu重置
        if (rootVC.view.frame.origin.x < 0) {
            CGRect frame = rightMenuView.view.frame;
            frame.origin.x = screenWidth;
            rightMenuView.view.frame = frame;
        }else{
            CGRect frame = leftMenuView.view.frame;
            frame.origin.x = -menuViewWidth;
            leftMenuView.view.frame = frame;
        }
        
        //rootView重置
        //CGPoint rootPoint = rootVC.view.center;
        rootVC.view.center = self.view.center;
        rootVC.view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        isMenuAnimate = NO;
        rootStatusIndex = RootOnMain;
        NSLog(@"reset OK!");
    }];
}
#pragma mark - UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

- (void)tapGus:(UIPanGestureRecognizer *)tapGes{
    NSLog(@"tapGes-");
    isMenuAnimate = NO;
    [self resetRootViewAndMenuView];
//    CGPoint tapGesPoint = [tapGes locationInView:self.view];
//    CGRect rootViewRect = [self.view convertRect:rootVC.view.frame toView:self.view];
//    if (CGRectContainsPoint(rootViewRect,tapGesPoint) && rootStatusIndex != RootOnMain) {
//        isMenuAnimate = NO;
//        [self resetRootViewAndMenuView];
//    }else{  
//    }
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
        rootVC = controller;
        [self.view addSubview:rootVC.view];

        UIPanGestureRecognizer *panGus = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
        panGus.delegate = self;
        panGus.delaysTouchesBegan = YES;
        panGus.cancelsTouchesInView = NO;
        [rootVC.view addGestureRecognizer:panGus];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired = 1;
        [rootVC.view addGestureRecognizer:tapGes];
        
        [rootVC.view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (isMenuAnimate) {
        return;
    }
    float rootViewX;
    float rootViewWidth;
    if([keyPath isEqualToString:@"center"]) {
        rootViewX = rootVC.view.frame.origin.x;
        rootViewWidth = rootVC.view.frame.size.width;
    }
    //leftView定位
    CGRect changedLeftFrame = leftViewFrame;
    changedLeftFrame.origin.x = rootViewX - menuViewWidth;
    leftMenuView.view.frame = changedLeftFrame;

    //rightView定位
    CGRect changedRightFrame = rightViewFrame;
    changedRightFrame.origin.x = rootViewX + rootViewWidth;
    rightMenuView.view.frame = changedRightFrame;
}
- (void)dealloc{
    [rootVC.view removeObserver:self forKeyPath:@"center"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
