//
//  UserHomeViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 03/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Tags.h"
#import "NormalActionSheetDelegate.h"
#import "FeedListTableViewCell.h"
#import "InboxListTableViewCell.h"
#import "CallingView.h"
#import "PhoneCallDelegate.h"
#import <MessageUI/MessageUI.h>
#import "LTKPopoverActionSheet.h"
#import "LTKPopoverActionSheetDelegate.h"
#import <AddressBookUI/AddressBookUI.h>
#import "OptionsPopOverVC.h"

#import "GetAmityContactsList.h"
#import "GetKeywordFeedsInvocation.h"
#import "GetNotificationInvocation.h"
#import "DeleteNotificationInvocation.h"
#import "OptionsPopOverVC.h"
#import "DeleteAllNotificationInvocation.h"
#import "UserFeedListInvocation.h"
#import "UserStatusListInvocation.h"
#import "SortUserFeedsDateWiseInvocation.h"
#import "SortUserStatusDateWiseInvocation.h"
#import "UserEmailListInvocation.h"
#import "DeleteUserEmailInvocation.h"
#import "AddFavoriteInvocation.h"
#import "SendMessageInvocation.h"
#import "UserFeedListInvocation.h"
#import "SendMessageInvocation.h"
#import "uploadDocInvocation.h"

@class ClockInView;
@class TaskCalenderViewController;
@class SadSmileViewController;
@class SmileViewController;
@class FavoriteViewController;
@class SettingViewController;
@class UpdateStatusView;
@class UploadDocVC;
@class FormListViewController;
@class MessagesListVC;
@class ChatDetailVC;
@class AddNewTaskVC;
@class ReimbursementsViewController;
@class MadFormViewController;
@class EditMadFormViewController;
@class BackPackViewController;
@class UserLocationVC;
@class AddContactsVC;
@class OptionsPopOverVC;

@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class InboxDetailViewController;
@class OCRReceiptListViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface UserHomeViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,SendMessageInvocationDelegate,GetAmityContactsListDelegate,GetKeywordFeedsInvocationDelegate,GetNotificationInvocationDelegate,UserFeedListInvocationDelegate,GetKeywordFeedsInvocationDelegate,NormalActionDeledate,UIPopoverControllerDelegate,FeedListTableViewCellDelegate,InboxListTableViewCellDelegate,UISearchBarDelegate,DeleteNotificationInvocationDelegate,ABPeoplePickerNavigationControllerDelegate,LTKPopoverActionSheetDelegate,NormalActionDeledate,LTKPopoverActionSheetDelegate,OptionsPopOverVCDelegate,DeleteAllNotificationInvocationDelegate,FeedListTableViewCellDelegate,UserFeedListInvocationDelegate,UserStatusListInvocationDelegate,SortUserFeedsDateWiseInvocationDelegate,SortUserStatusDateWiseInvocationDelegate,UserEmailListInvocationDelegate,DeleteUserEmailInvocationDelegate,AddFavoriteInvocationDelegate,UploadDocInvocationDelegate>

{
    
    #pragma mark Outlet view declearation

   
    
    
    IBOutlet UISegmentedControl *leftMainSegment;
    IBOutlet UISegmentedControl *leftSecondSegment;
    IBOutlet UISegmentedControl *rightMainSegment;
    IBOutlet UISegmentedControl *FamilyTopRightMainSegment;

    
    IBOutlet UITextField *txtSearch;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIButton *btnFirstSearch;
    IBOutlet UIButton *btnSecondSearch;
    IBOutlet UIButton *btnAddTak;

    IBOutlet UITableView *tblLeftFeedView;
    
    IBOutlet UIButton *btnClearAll;
    IBOutlet UIButton *btnAddContact;
    IBOutlet UIButton *btnShare;

    IBOutlet UILabel *lblUserTitle;
    IBOutlet UITextView *descriptionTxtView;
    IBOutlet UIImageView *imgUserView;

    IBOutlet UISearchBar *searchBar;
    
    #pragma mark Feeds variables declearation

    BOOL isNormalSearch;
    BOOL isTwentyHoursUpdate;
    BOOL isTopHashTag;
    BOOL isClockInFeedAdded;
    BOOL userDidClockedIn;
    BOOL userInRadiusRange;
    BOOL moveToKeywordSearch;
    BOOL checkSharePDF;

    IBOutlet ClockInView* clockInView;
    
    unsigned long int recordCount,pageIndex;
    NSUInteger selectedIndex;

   // UIPopoverController* popover;
    UITableView *tblViewTagList;
    NSString *pdfNameStr;

    #pragma mark search and sorting variables and outlet declearation
    
    IBOutlet UIButton* btnSearch;
    IBOutlet UIButton* btnCancel;
    UIDatePicker *datePicker;
    
    #pragma mark Contatcts variables and outlet declearation

    NSRange contactRange;
    BOOL isSearchEnable;
    id<PhoneCallDelegate> phoneCallDelegate;
    
    IBOutlet UIScrollView *segmentScroll;
    
    UIButton *actionSheetbutton;
    NSMutableArray* arrEmail;

    NSString *checkPN;
    
   
    IBOutlet UIButton *btnChatCount;
    IBOutlet UIButton *btnUserNotificationCount;
    IBOutlet UIButton *btnContactNotificationCount;
    
    IBOutlet UIButton *btnBackPack;


}
@property (strong, nonatomic) InboxDetailViewController *objInboxDetailViewController;
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (strong, nonatomic)TaskCalenderViewController *objTaskCalenderView;
@property (strong, nonatomic)FeedListTableViewCell *feedCell;
@property (strong, nonatomic)InboxListTableViewCell *inboxCell;
@property (strong, nonatomic)SadSmileViewController *objSadSmileViewController;
@property (strong, nonatomic)SmileViewController *objSmileViewController;
@property (strong, nonatomic)FavoriteViewController *objFavoriteViewController;
@property (strong, nonatomic)SettingViewController *objSettingViewController;
@property (strong, nonatomic)UpdateStatusView *objUpdateStatusView;
@property (strong, nonatomic)UploadDocVC *objUploadDocVC;
@property (strong, nonatomic)FormListViewController *objFormListViewController;
@property (strong, nonatomic)MessagesListVC *objMessagesListVC;
@property (strong, nonatomic)ChatDetailVC *objChatDetailVC;
@property (strong, nonatomic)AddNewTaskVC *objAddNewTaskVC;
@property (strong, nonatomic)ReimbursementsViewController *objReimbursementsViewController;
@property (strong, nonatomic)MadFormViewController *objMadFormViewController;
@property (strong, nonatomic)EditMadFormViewController *objEditMadFormViewController;
@property (strong, nonatomic)BackPackViewController *objBackPackViewCOntroller;
@property (strong, nonatomic)UserLocationVC *locationVC;
@property (strong, nonatomic)AddContactsVC *objAddContactView;
@property (strong, nonatomic)OptionsPopOverVC * opt;
@property (strong, nonatomic)OCRReceiptListViewController *objOCRReceiptListViewController;

@property (strong, nonatomic)UIPopoverController *popoverController;
@property (strong, nonatomic)UIViewController* popoverContent;
@property (strong, nonatomic)UIView *popoverView;
@property (strong, nonatomic)MFMessageComposeViewController *msgComposer;

@property (strong, nonatomic)IBOutlet UIView *leftView;
@property (strong, nonatomic)IBOutlet UIView *rightView;
@property (strong, nonatomic)IBOutlet UIView *rightInnerView;

@property (strong, nonatomic) NSMutableArray *arrFeedList;
@property (strong, nonatomic) NSMutableArray *formsArr;
@property (strong, nonatomic) NSMutableArray *formNameArr;
@property (strong, nonatomic) NSMutableArray *tenHashTagArr;
@property (strong, nonatomic) NSMutableDictionary *normalSearchDic;
@property (strong, nonatomic) NSMutableArray *arrInboxListing;
@property (strong, nonatomic) NSMutableArray *arrTagsList;
@property (strong, nonatomic) NSMutableArray *arrStatusList;
@property (strong, nonatomic) NSMutableArray *arrNotificationList;
@property (strong, nonatomic) NSMutableArray *arrSearchList;
@property (strong, nonatomic) NSMutableArray *contactEmailArr;

#pragma mark Contatcts variables and outlet declearation

@property (strong, nonatomic) NSMutableArray *arrContactsList;
@property (nonatomic, strong)   id<PhoneCallDelegate> phoneCallDelegate;
@property (nonatomic, strong)   NSIndexPath* selectedIndxpath;
@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)Tags *selectedTag;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

-(IBAction)btnFirstSearchPressed:(id)sender;
-(IBAction)btnSecondSearchPressed:(id)sender;
-(IBAction)btnBackPackPressed:(id)sender;

-(IBAction)leftMainSegmentAction:(id)sender;
-(IBAction)leftSecondSegmentAction:(id)sender;
-(IBAction)rightMainSegmentAction:(id)sender;
-(IBAction)familyTopRightMainSegmentAction:(id)sender;

-(IBAction)clockInSwitchAction:(id)sender;
-(IBAction)btnClearAllAction:(id)sender;
-(IBAction)btnAddContactAction:(id)sender;
-(IBAction)addTaskAction:(id)sender;
-(IBAction)btnShareAction:(id)sender;
-(IBAction)btnOCRAction:(id)sender;

-(void)requestForTagSearchFeeds:(NSMutableDictionary*)dict;

-(void)requestGetTagFeeds:(NSNumber*)index;
-(void)requestForEmailList;
-(void)requestForUserStatusList:(NSNumber*)index;
-(void)requestForNotificationList;
-(void)requestForContactList;
-(void)showCalenderView;

@end
