//
//  OCRReaderViewController.h
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalActionSheetDelegate.h"
#import "UploadOcrInvocation.h"

@interface OCRReaderViewController : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NormalActionDeledate,UploadOcrInvocationDelegate>
{
    IBOutlet UIScrollView *scrollView;

    IBOutlet UIImageView* imgOcrMedia;
    IBOutlet UIButton *btnOcrMedia;
    IBOutlet UITextView* txtVCommentDesc;
    UIButton *actionButton;

}
@property(nonatomic,strong)UIImagePickerController *imagePickerController;
@property(nonatomic,strong)UIView *imagePickerView;
@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic, strong) UIPopoverController* popover;


-(IBAction)uploadOcrImageAction:(id)sender;
-(IBAction)uploadDataAction:(id)sender;
-(IBAction)btnBackAction:(id)sender;


@end
