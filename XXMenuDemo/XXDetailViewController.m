//
//  XXDetailViewController.m
//  XXMenuDemo
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "XXDetailViewController.h"

@interface XXDetailViewController ()

@end

@implementation XXDetailViewController
@synthesize indexNum;
@synthesize titStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = titStr;
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
    lab.text = [NSString stringWithFormat:@"%d",indexNum];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor redColor];
    lab.font = [UIFont systemFontOfSize:160];
    [self.view addSubview:lab];
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
