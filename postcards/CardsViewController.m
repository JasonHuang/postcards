//
//  CardsViewController.m
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import "CardsViewController.h"
#import "FilterViewController.h"

@interface CardsViewController ()

@end

@implementation CardsViewController
@synthesize picker = _picker;
- (void)loadView
{
    [super loadView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 50, 60, 60);
    [button setTitle:@"拍照" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma  mark - private selectors
- (void)startCamera:(UIButton *) sender
{
    [self setPicker: [[UIImagePickerController alloc] init]];
    [self picker].sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self picker].delegate = self;
    [self presentModalViewController:[self picker] animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];

    FilterViewController *filterController = [[FilterViewController alloc]init];
    [filterController setImage:image];
    
    [self.navigationController pushViewController:filterController animated:YES];
}


@end
