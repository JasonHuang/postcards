//
//  FilterViewController.m
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)loadView
{
    UIImageView *view = [[UIImageView alloc]initWithImage:[self image]];
    view.frame = CGRectMake(0, 0, [self image].size.width, [self image].size.height);
    [self.view addSubview:view];
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