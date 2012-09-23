//
//  CardsViewController.h
//  postcards
//
//  Created by 黄 鹏霄 on 12-9-21.
//  Copyright (c) 2012年 Huang Pengxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardsViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,retain) UIImagePickerController *picker;


@end
