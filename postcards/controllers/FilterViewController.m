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
#import "GrayscaleContrastFilter.h"
#import "UIImage+Resize.h"

#define FILTER_HEIGHT 60

@interface FilterViewController ()

@end

@implementation FilterViewController
@synthesize image = _image;
@synthesize gpuImageView = _gpuImageView;

- (void)loadView
{
    [super loadView];
    
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 44 - FILTER_HEIGHT)];
    [self.view addSubview: scroll];
    
    staticp = [[GPUImagePicture alloc] initWithImage:[self image] smoothlyScaleOutput:YES];
    float imageWidth = 320;
    float imageHeight = ([self image].size.height / [self image].size.width) * imageWidth;
    [self setGpuImageView: [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)]] ;
    [self setFilter:0];
    [staticp addTarget:filter];
    [filter addTarget:[self gpuImageView]];
    [staticp processImage];
    
    [scroll setContentSize:CGSizeMake(imageWidth, imageHeight > (frame.size.height - 44) ? imageHeight : frame.size.height - 44)];
    [scroll addSubview:[self gpuImageView]];
    
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
- (void)renderFilters:(UIScrollView *) parentView
{
//    GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
//    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:[self image] smoothlyScaleOutput:YES];
//    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
//    [sepiaFilter forceProcessingAtSize:primaryView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
//    [sourcePicture addTarget:sepiaFilter];
//    [sepiaFilter addTarget:primaryView];
//        
//    [sourcePicture processImage];
//    [parentView addSubview:primaryView];、
    for (int i=0; i<10; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *strechableButtonImage = [[self image] resizedImage:CGSizeMake(40, 40) interpolationQuality:1.0];
        
        [self setFilter:i];
        GPUImagePicture *staticPicture = [[GPUImagePicture alloc] initWithImage:strechableButtonImage smoothlyScaleOutput:YES];
        GPUImageView *imageView = [[GPUImageView alloc]initWithFrame:CGRectMake(20 + i * 60, 10, 40, 40)] ;
        imageView.layer.masksToBounds=YES;
        imageView.layer.cornerRadius=5;
        [staticPicture addTarget:filter];
        [filter addTarget:imageView];
        [staticPicture processImage]; 
        
//        [btn setBackgroundImage:strechableButtonImage forState:UIControlStateNormal];
//        [btn.layer setMasksToBounds:YES];
//        btn.layer.cornerRadius=5;
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(renderImage:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [imageView addSubview:btn];
        [parentView addSubview:imageView];
    }
    [parentView setContentSize:CGSizeMake(600 + 20, parentView.frame.size.height)];
}

-(void) setFilter:(int) index {
    switch (index) {
        case 1:{
            filter = [[GPUImageContrastFilter alloc] init];
            [(GPUImageContrastFilter *) filter setContrast:1.75];
        } break;
        case 2: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess.acv"];
        } break;
        case 3: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02.acv"];
        } break;
        case 4: {
            filter = [[GrayscaleContrastFilter alloc] init];
        } break;
        case 5: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17.acv"];
        } break;
        case 6: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua.acv"];
        } break;
        case 7: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red.acv"];
        } break;
        case 8: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06.acv"];
        } break;
        case 9: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green.acv"];
        } break;
        default:
            filter = [[GPUImageRGBFilter alloc] init];
            break;
    }
}

- (void)renderImage:(UIButton *)sender
{
    [self setFilter:sender.tag - 100];
    [staticp addTarget:filter];
    [filter addTarget:[self gpuImageView]];
    [staticp processImage];
}

@end
