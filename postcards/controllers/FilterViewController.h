//
//  FilterViewController.h
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"


@interface FilterViewController : UIViewController
{
    GPUImageOutput<GPUImageInput> *filter;
}

@property (nonatomic,retain) UIImage *image;

@end
