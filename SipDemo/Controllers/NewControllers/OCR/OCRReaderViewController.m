//
//  OCRReaderViewController.m
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "OCRReaderViewController.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "UIImageExtras.h"

@interface OCRReaderViewController ()

@end

@implementation OCRReaderViewController

@synthesize activeSheet,normalActionSheetDelegate,imagePickerController,imagePickerView,popover;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,750)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    txtVCommentDesc.text = @"Enter description";
    txtVCommentDesc.textColor = [UIColor lightGrayColor];
    
    txtVCommentDesc.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.5] CGColor];
    txtVCommentDesc.layer.borderWidth= 1.0f;
    txtVCommentDesc.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = YES;
    
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)uploadOcrImageAction:(id)sender
{
    actionButton = (UIButton *)sender;
    [self dismissActionSheets];
    
    if (nil == self.normalActionSheetDelegate)
    {
        self.normalActionSheetDelegate = [[NormalActionSheetDelegate alloc] init];
        self.normalActionSheetDelegate.normalDelegate = self;
    }
    
    if (nil == self.activeSheet)
    {
        UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select any resource to upload file:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",nil];
        
        self.activeSheet = normalActionSheet;
        self.activeSheet.tag = AC_ACTIONSHEET_SELECT_RESOURCE;
    }
    [self.activeSheet showFromRect:((UIButton*)sender).frame inView:[sender superview] animated:YES];
}
-(void)dismissActionSheets
{
    if (self.activeSheet)
    {
        if ([self.activeSheet isVisible])
        {
            [self.activeSheet dismissWithClickedButtonIndex:-1 animated:YES];
        }
        self.activeSheet = nil;
    }
}
#pragma mark- NormalActionSheetDelegate
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_SELECT_RESOURCE)
    {
        
        if(buttonIndex==0)
        {
            [self performSelector:@selector(showCameraImagePicker) withObject:nil afterDelay:1.0];
            
        }
        
        else if(buttonIndex==1){
            
            [self performSelector:@selector(showGalleryImagePicker) withObject:nil afterDelay:1.0];
            
        }
        
    }
    
}
-(void)showCameraImagePicker
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [ConfigManager showAlertMessage:nil Message:@"Your device does not support this feature."];
        return;
    }
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    if (IS_DEVICE_IPAD) {
        
        self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
        [self.popover presentPopoverFromRect:btnOcrMedia.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        self.imagePickerView = self.imagePickerController.view;
        
        CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
        
        self.imagePickerView.frame = cameraViewFrame;
        
        [self.view addSubview:self.imagePickerView];
        
    }
    
}
-(void)showGalleryImagePicker
{
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    
    if (IS_DEVICE_IPAD) {
        
        self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
        [self.popover presentPopoverFromRect:btnOcrMedia.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        self.imagePickerView = self.imagePickerController.view;
        
        CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
        
        self.imagePickerView.frame = cameraViewFrame;
        
        [self.view addSubview:self.imagePickerView];
    }
    
}
#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mType = [info valueForKey:UIImagePickerControllerMediaType];
    
    if([mType isEqualToString:@"public.image"])
    {
        UIImage *image = [((UIImage*)[info objectForKey:UIImagePickerControllerEditedImage]) imageByScalingAndCroppingForSize:CGSizeMake(600, 600)] ;
        
        [imgOcrMedia setImage:image];
        
        // [self.navigationController pushViewController:uploadMediaVc animated:YES];
        
    }
    
    if (IS_DEVICE_IPAD) {
        
        [self.popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (IS_DEVICE_IPAD) {
        
        if(self.popover)
        {
            [self.popover dismissPopoverAnimated:YES];
        }
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
-(IBAction)uploadDataAction:(id)sender
{
    [txtVCommentDesc resignFirstResponder];
    
    if(txtVCommentDesc.text.length ==0)
    {
        [ConfigManager showAlertMessage:nil Message:@"Comment required"];
        return;
    }
    else
    {
        if([ConfigManager isInternetAvailable])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:txtVCommentDesc.text forKey:@"comment"];
            
            [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
            [dict setObject:@"attachment" forKey:@"attachment_key"];
            [dict setObject:@"uploadOcr" forKey:@"request_path"];
            [dict setObject:@"image.jpg" forKey:@"filename"];
            NSLog(@"%@",dict);
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            
            [dict setObject:@"image.jpg" forKey:@"filename"];
            [dict setObject:@"1" forKey:@"content_type"];
            
            [[AmityCareServices sharedService] UploadOcrInvocation:dict uploadData:(UIImageJPEGRepresentation(imgOcrMedia.image, 0.50)) delegate:self];
            
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
    
    
}
-(void)UploadOcrInvocationDidFinish:(UploadOcrInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSDictionary *msgDic=[dict valueForKey:@"response"];
        NSLog(@"%@",msgDic);
        
        NSString* strSuccess = NULL_TO_NIL([msgDic objectForKey:@"success"]);
        
        NSString* strMessage = NULL_TO_NIL([msgDic objectForKey:@"message"]);
        
        NSLog(@"%@",strSuccess);
        NSLog(@"%@",strMessage);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: AC_OCR_UPDATE object:nil];
            
            [self.view removeFromSuperview];
            
            UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:strMessage];
            
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollViewToCenterOfScreen:textView];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        [textView resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        return NO;
        
    }
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return YES;
    
}
- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 245;
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
