//
//  RightMenuViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/01/15.
//
//

#import <UIKit/UIKit.h>
#import "NormalActionSheetDelegate.h"
#import "LTKPopoverActionSheet.h"
#import "LTKPopoverActionSheetDelegate.h"
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>

@class TaskCalenderViewController;
@class SadSmileViewController;
@class SmileViewController;
@class FavoriteViewController;
@class SettingViewController;
@class UpdateStatusView;
@class UploadDocVC;
@class FormListViewController;
@class MessagesListVC;
@class AddNewTaskVC;
@class TaskCalenderViewController;
@class UpdateStatusView_iphone;
@class ChatDetailVC;
@class ReimbursementsViewController;
@class AllTagsViewController;
@class FormButtonViewController;
@class SchedulButtonViewController;
@class AllPeopleViewController;
@class AddContactsVC;
@class AddScheduleViewController;
@class AllHappyFacePostViewController;
@class AllSadFacePostViewController;
@class MadFormViewController;

@class ManagerAssignedTagViewController;
@class ManagerReimbursementViewController;
@class UserCompletedFormViewController;
@class CompletedTagFormViewController;
@class UpdateSharePostViewController;
@class DeletePostViewController;
@class UploadDropBoxFileViewController;
@class BackPackViewController;
@class FormFolderListViewController;

@interface RightMenuViewController : UIViewController <NormalActionDeledate,ABPeoplePickerNavigationControllerDelegate>
{
    
    
    IBOutlet UIView *rightInnerView;
    IBOutlet UISegmentedControl *rightMainSegment;
    
    IBOutlet UIButton *btnAddTak;
    
    IBOutlet UIScrollView *segmentScroll;
    UIButton *actionSheetbutton;
    NSMutableArray* arrEmail;
    
    
    IBOutlet UIButton *btnChatCount;
    IBOutlet UIButton *btnContactNotificationCount;
    IBOutlet UIButton *btnBackPack;

}

@property (nonatomic, strong)SadSmileViewController *objSadSmileViewController;
@property (nonatomic, strong)SmileViewController *objSmileViewController;
@property (nonatomic, strong)FavoriteViewController *objFavoriteViewController;
@property (nonatomic, strong)SettingViewController *objSettingViewController;
@property (nonatomic, strong)UploadDocVC *objUploadDocVC;
@property (nonatomic, strong)FormListViewController *objFormListViewController;
@property (nonatomic, strong)MessagesListVC *objMessagesListVC;
@property (nonatomic, strong)AddNewTaskVC *objAddNewTaskVC;
@property (nonatomic, strong)TaskCalenderViewController *objTaskCalenderViewController;
@property (nonatomic, strong)UpdateStatusView_iphone *objUpdateStatusView;
@property (nonatomic, strong)ChatDetailVC *objChatDetailVC;
@property (nonatomic, strong)ReimbursementsViewController *objReimbursementsViewController;
@property (nonatomic, strong)AllTagsViewController *objAllTagsViewController;
@property (nonatomic, strong)FormButtonViewController *objFormButtonViewController;
@property (nonatomic, strong)SchedulButtonViewController *objSchedulButtonViewController;
@property (nonatomic, strong)AllPeopleViewController *objAllPeopleViewController;
@property (nonatomic, strong)AddContactsVC *objAddContactsVC;
@property (nonatomic, strong)AddScheduleViewController *objAddScheduleViewController;
@property (nonatomic, strong)AllHappyFacePostViewController *objAllHappyFacePostViewController;
@property (nonatomic, strong)AllSadFacePostViewController *objAllSadFacePostViewController;
@property (nonatomic, strong)MadFormViewController *objMadFormViewController;

@property (nonatomic, strong)ManagerAssignedTagViewController   *objManagerAssignedTagViewController;
@property (nonatomic, strong)ManagerReimbursementViewController *objManagerReimbursementViewController;
@property (nonatomic, strong)UserCompletedFormViewController    *objUserCompletedFormViewController;
@property (nonatomic, strong)CompletedTagFormViewController     *objCompletedTagFormViewController;
@property (nonatomic, strong)UpdateSharePostViewController      *objUpdateSharePostViewController;
@property (nonatomic, strong)DeletePostViewController           *objDeletePostViewController;
@property (nonatomic, strong)UploadDropBoxFileViewController    *objUploadDropBoxFileViewController;
@property (nonatomic, strong)BackPackViewController *objBackPackViewCOntroller;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong)MFMessageComposeViewController *msgComposer;

@property (strong, nonatomic) FormFolderListViewController* objFormFolderListViewController;


-(IBAction)rightMainSegmentAction:(id)sender;
-(IBAction)addTaskAction:(id)sender;
-(IBAction)familyTopRightMainSegmentAction:(id)sender;
-(IBAction)familyTopUserRightMainSegmentAction:(id)sender;
-(IBAction)btnBackPackPressed:(id)sender;


@end

