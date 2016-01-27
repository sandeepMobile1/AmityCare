//
//  UploadReceiptViewController.h
//  SipDemo
//
//  Created by Octal on 03/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTKPopoverActionSheet.h"
#import "LTKPopoverActionSheetDelegate.h"
#import "NormalActionSheetDelegate.h"
#import "UploadReceiptInvocation.h"

@class DropBoxManager;
@class TagSelectionVC;

@class UploadReceiptViewController;

@protocol UploadReceiptViewControllerDelegate <NSObject>

-(void)RecieptDidUpdate;

@end


@interface UploadReceiptViewController : UIViewController  <LTKPopoverActionSheetDelegate,NormalActionDeledate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UploadReceiptInvocationDelegate,UITextFieldDelegate>

{
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIImageView *imgView;
    IBOutlet UIButton *btnImage;
    
    IBOutlet UITextField *txtMerchant;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextView *txtDescription;
    IBOutlet UITextField *txtTag;
    
    IBOutlet UIButton *btnYes;
    IBOutlet UIButton *btnNo;
    UIButton *actionButton;

    UIDatePicker *datePicker;
    UIToolbar* toolbar;
    
}

@property(nonatomic,strong)UIImagePickerController *imagePickerController;
@property(nonatomic,strong)UIView *imagePickerView;
@property(nonatomic,strong)DropBoxManager *dbManager;
@property(nonatomic,strong)NSString *reimbursmentStr;
@property(nonatomic,strong)NSString *strTag;
@property(nonatomic,strong)NSData *imgData;

@property(nonatomic,strong) TagSelectionVC *tagS;
@property (nonatomic,unsafe_unretained)id<UploadReceiptViewControllerDelegate>delegate;

-(IBAction)btnImagePressed:(id)sender;
-(IBAction)btnUploadPressed:(id)sender;
-(IBAction)btnYesPressed:(id)sender;
-(IBAction)btnNoPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;

@end
