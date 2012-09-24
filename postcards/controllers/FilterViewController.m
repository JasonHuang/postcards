//
//  FilterViewController.m
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import "FilterViewController.h"

#define FILTER_HEIGHT 60

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)loadView
{
    [super loadView];
    
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 44 - FILTER_HEIGHT)];
    [self.view addSubview: scroll];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[self image]];
    float imageWidth = 320;
    float imageHeight = ([self image].size.height / [self image].size.width) * imageWidth;
    view.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    [scroll setContentSize:CGSizeMake(imageWidth, imageHeight)];
    [scroll addSubview:view];
    
    UIScrollView *horizonal = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scroll.frame.size.height, frame.size.width, FILTER_HEIGHT)];
    [horizonal setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:horizonal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
