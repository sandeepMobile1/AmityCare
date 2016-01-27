//
//  UploadReceiptViewController.m
//  SipDemo
//
//  Created by Octal on 03/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "UploadReceiptViewController.h"
#import "UIImageExtras.h"
#import "DropBoxManager.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "ActionSheetPicker.h"
#import <QuartzCore/QuartzCore.h>
#import "TagSelectionVC.h"

@interface UploadReceiptViewController ()<TopNavigationViewDelegate>
@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic, strong) UIPopoverController* popover;

@end

@implementation UploadReceiptViewController

@synthesize popover,imagePickerView,imagePickerController,dbManager,reimbursmentStr,strTag,tagS,imgData,delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    reimbursmentStr=@"1";
    
    txtDescription.text = @"Reciept Description";
    txtDescription.textColor = [UIColor lightGrayColor];
    
    txtDescription.layer.borderWidth = 1.0f;
    txtDescription.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.5] CGColor];
    txtDescription.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromDropBoxList) name: AC_DROPBOX_UPDATE object:nil];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
        }
        
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height+100)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTagIdOnTextField) name:AC_RECIEPT_TAG_SELECTION object:nil];
    
}
-(void)updateFromDropBoxList
{
    
    NSLog(@"%@",sharedAppDelegate.dropBoxContentD);
    
    self.imgData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[sharedAppDelegate.dropBoxContentD objectForKey:@"url"]]];
    
    [imgView setImage:[UIImage imageWithData:self.imgData]];
    
    
}
-(void)setTagIdOnTextField
{
    [txtTag setText:sharedAppDelegate.uploadRecieptTagName];
}
-(IBAction)btnBackPressed:(id)sender
{
    [self.view removeFromSuperview];
}

#pragma mark----------------
#pragma IBAction method

-(IBAction)btnImagePressed:(id)sender
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
        UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select any resource to upload file:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", @"DropBox", nil];
        //UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select any resource to upload file:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
        
        self.activeSheet = normalActionSheet;
        self.activeSheet.tag = AC_ACTIONSHEET_SELECT_RESOURCE;
    }
    [self.activeSheet showFromRect:((UIButton*)sender).frame inView:[sender superview] animated:YES];
    
}
-(IBAction)btnUploadPressed:(id)sender
{
    [txtDate resignFirstResponder];
    [txtMerchant resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtAmount resignFirstResponder];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    if (txtMerchant.text.length ==0) {
        [ConfigManager showAlertMessage:Nil Message:@"Merchant is required"];
        return;
    }
    if (txtAmount.text.length ==0) {
        [ConfigManager showAlertMessage:Nil Message:@"Amount is required"];
        return;
    }
    if (txtTag.text.length ==0) {
        [ConfigManager showAlertMessage:Nil Message:@"Tag is required"];
        return;
    }
    if (txtDate.text.length ==0) {
        [ConfigManager showAlertMessage:Nil Message:@"Date is required"];
        return;
    }
    if (txtDescription.text.length ==0) {
        [ConfigManager showAlertMessage:Nil Message:@"Description is required"];
        return;
    }
    if (reimbursmentStr==nil || reimbursmentStr==(NSString*)[NSNull null] || [reimbursmentStr isEqualToString:@""]) {
        [ConfigManager showAlertMessage:Nil Message:@"Please select reimbursement status"];
        return;
    }
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading" width:200];
        
        
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init];
        [tDict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [tDict setObject:txtMerchant.text forKey:@"merchant_name"];
        [tDict setObject:txtAmount.text forKey:@"amount"];
        [tDict setObject:txtDate.text forKey:@"date"];
        [tDict setObject:txtDescription.text forKey:@"description"];
        [tDict setObject:reimbursmentStr forKey:@"reimbursment"];
        [tDict setObject:sharedAppDelegate.uploadRecieptTagId forKey:@"tag_id"];
        [tDict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [tDict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        
        [tDict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
        [tDict setObject:@"image" forKey:@"attachment_key"];
        [tDict setObject:@"upload_reciept" forKey:@"request_path"];
        [tDict setObject:@"image.jpg" forKey:@"filename"];
        
        [[AmityCareServices sharedService] UploadReceiptInvocation:tDict uploadData:self.imgData delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)btnYesPressed:(id)sender
{
    [btnYes setSelected:YES];
    [btnNo setSelected:NO];
    
    reimbursmentStr=@"1";
}
-(IBAction)btnNoPressed:(id)sender
{
    [btnYes setSelected:NO];
    [btnNo setSelected:YES];
    
    reimbursmentStr=@"0";
    
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ConfigManager showAlertMessage:nil Message:@"Your device does not support this feature."];
            return;
        }
        if (buttonIndex==0) {
            
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                //  [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
        
        else if(buttonIndex==1)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init] ;
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            self.imagePickerController.videoMaximumDuration = 60.0f;//no. of seconds
            self.imagePickerController.delegate = self;
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                //[self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
        
    }
    else if(alertView.tag==102)
    {
        if(buttonIndex==0)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            
            
            
            
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
        else if(buttonIndex==1)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self. imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [txtAmount resignFirstResponder];
    [txtDate resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtMerchant resignFirstResponder];
    [txtTag resignFirstResponder];
    
    [super viewWillDisappear:YES];
}
#pragma mark- NormalActionSheetDelegate
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_SELECT_RESOURCE)
    {
        
        if(buttonIndex==0){
            if (nil == self.activeSheet)
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Select File" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select Picture", nil];
                alert.tag=101;
                [alert show];
                
            }
            
        }
        else if(buttonIndex==1){
            if (nil == self.activeSheet)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Select File" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select Picture", nil];
                alert.tag=102;
                [alert show];
                
            }
            [self.activeSheet showFromRect:actionButton.frame inView:[actionButton superview]  animated:YES];
            
        }
        else if(buttonIndex==2){
            
            
            if (IS_DEVICE_IPAD) {
                
                self.dbManager=[[DropBoxManager alloc] initWithNibName:@"DropBoxManager~ipad" bundle:nil];
            }
            else
            {
                self.dbManager=[[DropBoxManager alloc] initWithNibName:@"DropBoxManager" bundle:nil];
                
            }
            self.dbManager.checkView=@"backpack";
            [self.view addSubview:self.dbManager.view];
            //[self.navigationController pushViewController:dbManager animated:YES];
        }
    }
    else if(actionSheet.tag == AC_ACTIONSHEET_UPLOAD_FROM_CAMERA)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ConfigManager showAlertMessage:nil Message:@"Your device does not support this feature."];
            return;
        }
        if(buttonIndex==0)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                // overlay = [[CameraOverlayView alloc] initWithFrame:self.view.bounds];
                
                //[self setOverlayViewModel];
                
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                //[self presentViewController:imagePickerController animated:YES completion:nil];
            }
            
        }
        else if(buttonIndex==1)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init] ;
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            self.imagePickerController.videoMaximumDuration = 60.0f;//no. of seconds
            self.imagePickerController.delegate = self;
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }
    else if (actionSheet.tag == AC_ACTIONSHEET_UPLOAD_FROM_GALLERY)
    {
        if(buttonIndex==0)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                // [self presentViewController:imagePickerController animated:YES completion:nil];
            }      }
        else if(buttonIndex==1)
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.movie"];
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                // [self presentViewController:imagePickerController animated:YES completion:nil];
            }    }
    }
}

#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mType = [info valueForKey:UIImagePickerControllerMediaType];
    
    if([mType isEqualToString:@"public.image"])
    {
        UIImage *image = [((UIImage*)[info objectForKey:UIImagePickerControllerEditedImage]) imageByScalingAndCroppingForSize:CGSizeMake(600, 600)] ;
        
        self.imgData=(UIImageJPEGRepresentation(image, 0.50)) ;
        
        [imgView setImage:image];
    }
    
    if (IS_DEVICE_IPAD) {
        
        [self.popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        
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
#pragma mark- UITextField Delegate

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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:txtDate] || [textField isEqual:txtTag])
    {
        [txtAmount resignFirstResponder];
        [txtMerchant resignFirstResponder];
        [txtDescription  resignFirstResponder];
        
    }
    
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:txtDate])
    {
        if (IS_DEVICE_IPAD) {
            
            
            [ActionSheetPicker displayActionPickerWithView:txtDate datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(selectDate:) title:@"Select Date"];
            [textField resignFirstResponder];
            
        }
        else
        {
            
            [self showDatePicker];
            
            [textField resignFirstResponder];
            
        }
        
        
    }
    else if([textField isEqual:txtTag])
    {
        [textField resignFirstResponder];
        
        if (IS_DEVICE_IPAD) {
            
            self.tagS = [[TagSelectionVC alloc] initWithNibName:@"TagSelectionVC" bundle:nil];
            
        }
        else
        {
            self.tagS = [[TagSelectionVC alloc] initWithNibName:@"TagSelectionVC_iphone" bundle:nil];
            
        }
        self.tagS.checkRecieptSelection=TRUE;
        
        [self.view addSubview:self.tagS.view];
        
        
    }
    else
    {
        if (!IS_DEVICE_IPAD) {
            
            [self scrollViewToCenterOfScreen:textField];
            
        }
    }
    
}
-(void)didFinishAssignTags:(NSMutableArray *)arrSEL
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        
        [textField resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
    }
    
    return YES;
}
-(void)showDatePicker
{
    [toolbar removeFromSuperview];
    [datePicker removeFromSuperview];
    
    toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(done)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    [self.view addSubview:datePicker];
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 180.0+IPHONE_FIVE_FACTOR, 275.0, 44.0)];
        datePicker.frame=CGRectMake(0,224+IPHONE_FIVE_FACTOR,275.0, 216);
        
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 180.0, 275.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,224,275.0, 216);
        
    }
    
}
-(IBAction)cancel
{
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [txtDescription resignFirstResponder];
    [txtMerchant resignFirstResponder];
    [txtAmount resignFirstResponder];
    [txtDate resignFirstResponder];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
}
-(IBAction)done
{
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    NSDate *date = datePicker.date;
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    
    txtDate.text = dateStr;
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    [txtDate resignFirstResponder];
    
    
}
-(void)selectDate:(id)sender
{
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    [txtDate resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    txtDate.text = dateStr;
}

#pragma mark- UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
    }
    if (txtDescription.textColor == [UIColor lightGrayColor]) {
        txtDescription.text = @"";
        txtDescription.textColor = [UIColor blackColor];
    }
    
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(txtDescription.text.length == 0)
    {
        txtDescription.text = @"Description";
        txtDescription.textColor = [UIColor lightGrayColor];
        [txtDescription resignFirstResponder];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(!(textView.textColor == [UIColor lightGrayColor]))
    {
        // strAbtDesc = textView.text;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (!IS_DEVICE_IPAD) {
        
        if ([text isEqualToString:@"\n"])
        {
            
            [textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            return NO;
            
        }
        
    }
    
    
    return YES;
    
}


-(void)UploadReceiptInvocationDidFinish:(UploadReceiptInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"UploadReceiptInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            NSString* strmessage = NULL_TO_NIL([response valueForKey:@"message"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                [self.delegate RecieptDidUpdate];
                
                [self.view removeFromSuperview];
                
                UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:nil message:strmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [successAlert show];
                
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:strmessage];
                
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView];
    }
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
