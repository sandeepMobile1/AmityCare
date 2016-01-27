//
//  UploadDocVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTKPopoverActionSheet.h"
#import "LTKPopoverActionSheetDelegate.h"
#import "NormalActionSheetDelegate.h"

@class UploadMediaFilesVc;
@class DropBoxManager;

@interface UploadDocVC : UIViewController<LTKPopoverActionSheetDelegate,NormalActionDeledate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UILabel* lblUploadDoc;
    IBOutlet UIButton* btnBrowseDoc;
}
@property(nonatomic,strong)UIImagePickerController *imagePickerController;
@property(nonatomic,strong)UIView *imagePickerView;
@property(nonatomic,strong)DropBoxManager *dbManager;
@property(nonatomic,strong) UploadMediaFilesVc *uploadMediaVc ;

-(IBAction)browseButtonAction:(id)sender;
@end
