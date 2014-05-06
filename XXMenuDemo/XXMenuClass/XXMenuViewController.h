//
//  XXMenuViewController.h
//  XXMenuDemo
//
//  Created by shan xu on 14-4-11.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXLeftMenuViewController.h"
#import "XXRightMenuViewController.h"

typedef enum : NSUInteger {
    RootOnEles = 0,
    RootOnMain,
    RootOnRightStatic,
    RootOnLeftStatic,
} rootStatus;

@interface XXMenuViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic, strong) XXLeftMenuViewController *leftMenuView;
@property(nonatomic, strong) XXRightMenuViewController *rightMenuView;
@property(nonatomic, strong) UIViewController *rootVC;
@property(nonatomic, assign) CGRect rootViewFrame;
@property(nonatomic, assign) CGRect leftViewFrame;
@property(nonatomic, assign) CGRect rightViewFrame;
@property(nonatomic, assign) BOOL isMenuAnimate;//菜单正在移动
@property(nonatomic, assign) rootStatus rootStatusIndex;

- (id)initWithRootVC:(UIViewController *)controller;
- (void)showMenu:(BOOL)isLeftMenu;
- (void)replaceRootVC:(UIViewController *)replaceVC isFromLeft:(BOOL)isFromLeft;
@end
