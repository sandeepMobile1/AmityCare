//
//  UploadBackPackViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import <UIKit/UIKit.h>
#import "NormalActionSheetDelegate.h"
#import "LTKPopoverActionSheet.h"
#import "LTKPopoverActionSheetDelegate.h"
#import "AddPicInvocation.h"
#import "CreateFolderInvocation.h"
#import "FolderListInvocation.h"
#import "ChooseBackpackFileInvocation.h"

@class DropBoxManager;

@interface UploadBackPackViewController : UIViewController <LTKPopoverActionSheetDelegate,NormalActionDeledate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,AddPicInvocationDelegate,UITextFieldDelegate,CreateFolderInvocationDelegate,FolderListInvocationDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ChooseBackpackFileInvocationDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtSelectFolder;

    IBOutlet UIButton *btnImage;
    UIView *imagePickerView;
    UIAlertView *successAlert;
    UIButton *actionButton;
    
    UIAlertView *folderAlert;
    UITextField *txtFolderAlert;
    
    UIPickerView *myPicker;
    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
    int movementDistance;
    float movementDuration;
    
    IBOutlet UIView *fileView;
    IBOutlet UITableView *tblFileView;

}
@property(nonatomic,strong)UIImagePickerController *imagePickerController;
@property(nonatomic,strong)UIView *imagePickerView;
@property(nonatomic,strong)DropBoxManager *dbManager;
@property(nonatomic,strong)UIView *masterView;

@property(nonatomic,strong)NSString *checkUpload;
@property(nonatomic,strong)NSData *imgData;
@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSString *folderId;
@property(nonatomic,strong)NSString *strExtension;

@property(nonatomic,strong)NSMutableArray *arrFolderList;
@property(nonatomic,strong)NSMutableArray *arrFileList;

-(IBAction)btnUploadPressed:(id)sender;
-(IBAction)btnImagePressed:(id)sender;
-(IBAction)btnCrossAction:(id)sender;

-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnCreateFolderAction:(id)sender;
- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(void)resignTextField;

@end
