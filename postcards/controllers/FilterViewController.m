//
//  FilterViewController.m
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import "FilterViewController.h"
#import "GPUImageView.h"
#import "GPUImagePicture.h"
#import "GPUImageSepiaFilter.h"

#define FILTER_HEIGHT 60

@interface FilterViewController ()

@end

@implementation FilterViewController
@synthesize image = _image;

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
    [scroll setContentSize:CGSizeMake(imageWidth, imageHeight > (frame.size.height - 44) ? imageHeight : frame.size.height - 44)];
    [scroll addSubview:view];
    
    UIScrollView *horizonal = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scroll.frame.size.height, frame.size.width, FILTER_HEIGHT)];
    horizonal.backgroundColor = [UIColor grayColor];
    
    [self renderFilters:horizonal];
    
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

#pragma mark - private selectors
- (void)renderFilters:(UIView *) parentView
{
    GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:[self image] smoothlyScaleOutput:YES];
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    [sepiaFilter forceProcessingAtSize:primaryView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    [sourcePicture addTarget:sepiaFilter];
    [sepiaFilter addTarget:primaryView];
    
    [sourcePicture processImage];
    [parentView addSubview:primaryView];
}

@end
