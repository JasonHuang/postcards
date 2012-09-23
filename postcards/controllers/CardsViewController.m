//
//  CardsViewController.m
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import "CardsViewController.h"
#import "FilterViewController.h"
#import "HersImagePickerController.h"


@interface CardsViewController ()

@end

@implementation CardsViewController
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
    HersImagePickerController *imagePicker = [[HersImagePickerController alloc]init];
    [imagePicker setHersImagePickerDelegate:self];
    [imagePicker show];
}

- (void) toEditImage:(UIImage *)image
{
    FilterViewController *filterController = [[FilterViewController alloc]init];
    [filterController setImage:image];
    [self.navigationController pushViewController:filterController animated:YES];
}

#pragma mark - HersImagePickerDelegate
- (void)hersImagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

    [self dismissModalViewControllerAnimated:YES];
    [self toEditImage:image];
//    [self performSelector:@selector(toEditImage:) withObject:image afterDelay:1.0];
}


@end
