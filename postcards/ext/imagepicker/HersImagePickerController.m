//
//  HersImagePickerController.m
//  HersApp_Dida
//
//  Created by Pengxiao Huang on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HersImagePickerController.h"

@interface HersImagePickerController (Private)
-(void)addSomeElements:(UIViewController *)viewController;
@end

@implementation HersImagePickerController
@synthesize allowsEditing = _allowsEditing;

#pragma mark - life cycle
- (id) init
{
    if(self = [super init]){
        _allowsEditing = YES;
    }
    return self;
}

- (void) setHersImagePickerDelegate:(id<HerImagePickerDelegate> )hersDelegate
{
    hersImagePickerDelegate = hersDelegate;
}

- (void) show
{
    UIViewController *viewController = (UIViewController *)hersImagePickerDelegate;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    imagePicker.allowsEditing = _allowsEditing;
//    imagePicker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    
    [viewController.navigationController presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

#pragma mark - UINavigationController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addSomeElements:viewController];
}


-(UIView *)findView:(UIView *)aView withName:(NSString *)name{  
    Class cl = [aView class];  
    NSString *desc = [cl description];  
    
    if ([name isEqualToString:desc])  
        return aView;  
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)  
    {  
        UIView *subView = [aView.subviews objectAtIndex:i];  
        subView = [self findView:subView withName:name];  
        if (subView)  
            return subView;  
    }  
    return nil;  
}  

-(void)addSomeElements:(UIViewController *)viewController{  
    //Add the motion view here, PLCameraView and picker.view are both OK  
    UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];  
//    [PLCameraView addSubview:touchView];//[viewController.view addSubview:self.touchView];//You can also try this one.  
    
    //Add button for Timer capture  
    //[PLCameraView addSubview:timerButton];  
    //[PLCameraView addSubview:continuousButton];  
    //
    //[PLCameraView insertSubview:bottomBarImageView atIndex:1];  
    
    //Used to hide the transiton, last added view will be the topest layer  
    //[PLCameraView addSubview:myTransitionView];  
    
    //Add label to cropOverlay  
    //UIView *cropOverlay=[self findView:PLCameraView withName:@"PLCropOverlay"];  
    //[cropOverlay addSubview:lblWatermark];  
    
    //Get Bottom Bar  
    UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];  
    
    
    //Get ImageView For Save  
    UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];  
    
    //Get Button 0  
    UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];  
    [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];  
    //[cameraButton addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    
    //Get Button 1  
    UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];  
    [useButton setTitle:@"保存" forState:UIControlStateNormal];  
    
    //Get ImageView For Camera  
    UIImageView *bottomBarImageForCamera = [bottomBar.subviews objectAtIndex:1];  
    
    //Set Bottom Bar Image  
    //UIImage *image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"nav-bg.png"]];  
    //bottomBarImageForCamera.image=image;  
    //[image release];  
    
    //Get Button 0(The Capture Button)  
    //UIButton *cameraButton=[bottomBarImageForCamera.subviews objectAtIndex:0];  
    //[cameraButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];  
    
    //Get Button 1  
    UIButton *cancelButton=[bottomBarImageForCamera.subviews objectAtIndex:1];  
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];  
    //[cancelButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    /*UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav-bg.png"]];
     
     [bottomBar addSubview:imageView];*/
    
    //Add a button for open album
    UIButton *album = [UIButton buttonWithType:UIButtonTypeCustom];
    [album setImage:[UIImage imageNamed:@"camera_btn_library.png"] forState:UIControlStateNormal];
    [album setFrame:CGRectMake(250, cancelButton.frame.origin.y, cancelButton.frame.size.width, cancelButton.frame.size.height)];
    [album addTarget:self action:@selector(showAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarImageForCamera addSubview:album];
    //bottomBar.backgroundColor = [UIColor whiteColor];
}  

- (void)showAlbum:(UIButton *) sender
{
    UIViewController *viewController = (UIViewController *)hersImagePickerDelegate;
    [viewController dismissModalViewControllerAnimated:NO ];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePicker.allowsEditing = _allowsEditing;
    [viewController.navigationController presentModalViewController:imagePicker animated:NO];
    [imagePicker release];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [hersImagePickerDelegate hersImagePickerController:picker didFinishPickingImage:image editingInfo:editingInfo];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIViewController *viewController = (UIViewController *)hersImagePickerDelegate;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [viewController dismissModalViewControllerAnimated:NO];
    if([viewController respondsToSelector:@selector(hersImagePickerControllerDidCancel:)]){
        [hersImagePickerDelegate hersImagePickerControllerDidCancel:picker];
    }
    
}

@end
