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
#import "SmoothLineView.h"

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
    verticalScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 44 - FILTER_HEIGHT)];
    [self.view addSubview: verticalScroll];
    
    staticp = [[GPUImagePicture alloc] initWithImage:[self image] smoothlyScaleOutput:YES];
    float imageWidth = 320;
    float imageHeight = ([self image].size.height / [self image].size.width) * imageWidth;
    [self setGpuImageView: [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)]] ;
    [self setFilter:0];
    [staticp addTarget:filter];
    [filter addTarget:[self gpuImageView]];
    [staticp processImage];
    
    [verticalScroll setContentSize:CGSizeMake(imageWidth, imageHeight > (frame.size.height - 44) ? imageHeight : frame.size.height - 44)];
    [verticalScroll addSubview:[self gpuImageView]];
    
    smoothView = [[SmoothLineView alloc]initWithFrame:CGRectMake(0, 0, [self gpuImageView].frame.size.width, [self gpuImageView].frame.size.height)];
    smoothView.backgroundColor = [UIColor clearColor];
    [smoothView setHidden:YES];
    [verticalScroll addSubview:smoothView];
    
    UIScrollView *horizonal = [[UIScrollView alloc] initWithFrame:CGRectMake(0, verticalScroll.frame.size.height, frame.size.width, FILTER_HEIGHT)];
    horizonal.backgroundColor = [UIColor grayColor];
    
    paintButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [paintButton setFrame:CGRectMake(0, 0, 40, 40)];
    [paintButton setTitle:@"画画" forState:UIControlStateNormal];
    [paintButton addTarget:self action:@selector(prepareToDraw:) forControlEvents:UIControlEventTouchUpInside];
    
    [self renderFilters:horizonal];
    
    [horizonal addSubview:paintButton];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDrawing:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
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

- (void)prepareToDraw:(UIButton *)sender
{
    if (smoothView.hidden == YES) {
        verticalScroll.scrollEnabled = NO;
        smoothView.hidden = NO;
        [paintButton setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        verticalScroll.scrollEnabled = YES;
        smoothView.hidden = YES;
        [paintButton setTitle:@"画画" forState:UIControlStateNormal];
    }
}

- (void)saveDrawing:(UIButton *)sender
{
    NSLog(@"saving image");
    UIGraphicsBeginImageContext(smoothView.bounds.size);
    CGContextRef Context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(Context, 1.0, -1.0);
    CGContextTranslateCTM(Context, 0, -smoothView.frame.size.height);
    
    CGContextDrawImage(Context,
                       CGRectMake(0, 0, smoothView.frame.size.width, smoothView.frame.size.height),
                       [self image].CGImage);
    
    CGContextScaleCTM(Context, 1.0, -1.0);
    CGContextTranslateCTM(Context, 0, -smoothView.frame.size.height);
    
    [smoothView.layer renderInContext:Context];
    UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(bgImg, nil, nil, nil);
}


@end
