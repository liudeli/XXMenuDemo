//
//  XXMenuViewController.m
//  XXMenuDemo
//
//  Created by shan xu on 14-4-11.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "XXMenuViewController.h"

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
@synthesize obArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        leftMenuView = [[XXLeftMenuView alloc] initWithFrame:CGRectMake(0, screenHeight*(1-scaleValue)/2, menuViewWidth, screenHeight*scaleValue)];
        rightMenuView = [[XXRightMenuView alloc] initWithFrame:CGRectMake(0, screenHeight*(1-scaleValue)/2, menuViewWidth, screenHeight*scaleValue)];
        isMenuAnimate = NO;
        rootStatusIndex = RootOnMain;
        obArray = [[NSMutableArray alloc] init];
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
    
    
    [self initFrame];
}

- (void)panGes:(UIPanGestureRecognizer *)panGes{
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
        leftViewFrame = leftMenuView.frame;
        rightViewFrame = rightMenuView.frame;

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

- (void)replaceRootVC:(UIViewController *)replaceVC isFromLeft:(BOOL)isFromLeft{
    CGRect frame = rootVC.view.frame;
    NSLog(@"frame--->>%f/%f/%f/%f/%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height,rootVC.view.transform.tx);
    if (rootVC) {
        [rootVC.view removeFromSuperview];
    }
    rootVC = replaceVC;
    //rootView缩小
    if (isFromLeft) {
        rootVC.view.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
        rootVC.view.center = CGPointMake(menuViewWidth+screenWidth*scaleValue/2, self.view.bounds.size.height/2);
    }else{
        rootVC.view.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
        rootVC.view.center = CGPointMake(320 - menuViewWidth-screenWidth*scaleValue/2, self.view.bounds.size.height/2);
    }
////    CGRect frame = rightMenuView.view.frame;
////    frame.origin.x = screenWidth - menuViewWidth;
////    rightMenuView.view.frame = frame;
    rootVC.view.frame = frame;
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

- (void)showMenu:(BOOL)isLeftMenu{
    if (isMenuAnimate) {
        return;
    }
    if (isLeftMenu) {
        if (leftMenuView.frame.origin.x == 0) {
            isMenuAnimate = NO;
            [self resetRootViewAndMenuView];
            return;
        }
        isMenuAnimate = YES;
        [UIView animateWithDuration:.3 animations:^{
            CGRect frame = leftMenuView.frame;
            frame.origin.x = 0;
            leftMenuView.frame = frame;
            
            //rootView缩小
            rootVC.view.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
            rootVC.view.center = CGPointMake(menuViewWidth+screenWidth*scaleValue/2, self.view.bounds.size.height/2);
        } completion:^(BOOL finished) {
            isMenuAnimate = NO;
            rootStatusIndex = RootOnRightStatic;
        }];
    }else{
        if (rightMenuView.frame.origin.x == screenWidth - menuViewWidth) {
            isMenuAnimate = NO;
            [self resetRootViewAndMenuView];
            return;
        }
        isMenuAnimate = YES;
        [UIView animateWithDuration:.3 animations:^{
            CGRect frame = rightMenuView.frame;
            frame.origin.x = screenWidth - menuViewWidth;
            rightMenuView.frame = frame;
            
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
            CGRect frame = rightMenuView.frame;
            frame.origin.x = screenWidth;
            rightMenuView.frame = frame;
        }else{
            CGRect frame = leftMenuView.frame;
            frame.origin.x = -menuViewWidth;
            leftMenuView.frame = frame;
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
    if (rootStatusIndex == RootOnMain && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    
    UINavigationController *nav = (UINavigationController *)rootVC;

    int i = nav.viewControllers.count;
    if (i > 1) {
        return NO;
    }
    return YES;
}

- (void)tapGus:(UITapGestureRecognizer *)tapGes{

    NSLog(@"tapGes-");
    isMenuAnimate = NO;
    [self resetRootViewAndMenuView];
}
- (void)initFrame{
    CGRect leftViewframe = leftMenuView.frame;
    leftViewframe.origin.x = -menuViewWidth;
    leftMenuView.frame = leftViewframe;
    
    CGRect rightViewframe = rightMenuView.frame;
    rightViewframe.origin.x = screenWidth;
    rightMenuView.frame = rightViewframe;

    [self.view addSubview:leftMenuView];
    [self.view addSubview:rightMenuView];
}
- (id)initWithRootVC:(UIViewController *)controller{
    if ([super init]) {
        
        if(![obArray containsObject:controller])
        {
            [obArray addObject:controller];
        }
        
        if (rootVC) {
            [rootVC.view removeFromSuperview];
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
    leftMenuView.frame = changedLeftFrame;

    //rightView定位
    CGRect changedRightFrame = rightViewFrame;
    changedRightFrame.origin.x = rootViewX + rootViewWidth;
    rightMenuView.frame = changedRightFrame;
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
