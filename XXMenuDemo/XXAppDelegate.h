//
//  XXAppDelegate.h
//  XXMenuDemo
//
//  Created by shan xu on 14-4-11.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXMenuViewController.h"

@interface XXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) XXMenuViewController *XXMenuVC;

//private method
+ (XXAppDelegate *)sharedAppDelegate;

@end
