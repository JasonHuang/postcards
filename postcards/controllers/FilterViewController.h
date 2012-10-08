//
//  FilterViewController.h
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@class SmoothLineView;

@interface FilterViewController : UIViewController
{
    GPUImageOutput<GPUImageInput> *filter;
    GPUImagePicture *staticp;
    UIScrollView *verticalScroll;
    SmoothLineView *smoothView;
    UIButton *paintButton;
}

@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) GPUImageView *gpuImageView;

@end
