//
//  HersImagePickerController.h
//  HersApp_Dida
//
//  Created by Pengxiao Huang on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@protocol HerImagePickerDelegate <NSObject>

- (void)hersImagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;

@optional
- (void)hersImagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end

@interface HersImagePickerController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    id<HerImagePickerDelegate> hersImagePickerDelegate;
}

@property (nonatomic,assign) BOOL allowsEditing;

- (id)init;
- (void)setHersImagePickerDelegate : (id<HerImagePickerDelegate> ) hersDelegate;

- (void)show;

@end


