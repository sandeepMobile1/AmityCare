//
//  TagHomeViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 03/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Tags.h"
#import "FeedListTableViewCell.h"
#import "InboxListTableViewCell.h"
#import "ClockOutVC.h"

#import "GetFeedsInvocation.h"
#import "GetKeywordFeedsInvocation.h"
#import "TagsInvocation.h"
#import "TagSearchInvocation.h"
#import "ClockInInvocation.h"
#import "CheckPinInvocation.h"
#import "InboxListInvocation.h"
#import "SortFeedsDateWiseInvocation.h"
#import "TagStatusListInvocation.h"
#import "SortTagStatusDateWiseInvocation.h"
#import "GetKeywordStatusInvocation.h"
#import "TagNotificationListInvocation.h"
#import "DeleteAllTagNotificationInvocation.h"
#import "AddFavoriteInvocation.h"
#import "AddSadSmileInvocation.h"
#import "AddSmileInvocation.h"
#import "GetAmityContactsList.h"
#import "SendMessageInvocation.h"
#import "UploadDocInvocation.h"
#import "DeleteMailInvocation.h"
#import "DeleteNotificationInvocation.h"

@class ClockInView;
@class TaskCalenderViewController;
@class EditTagIntroViewController;
@class SadSmileViewController;
@class SmileViewController;
@class FavoriteViewController;
@class SettingViewController;
@class UpdateStatusView;
@class UploadDocVC;
@class FormListViewController;
@class AddNewTaskVC;
@class ChatDetailVC;
@class ReimbursementsViewController;
@class AllTagsViewController;
@class FormButtonViewController;
@class SchedulButtonViewController;
@class AllPeopleViewController;
@class AddScheduleViewController;
@class AllHappyFacePostViewController;
@class AllSadFacePostViewController;

@class ManagerAssignedTagViewController;
@class UserCompletedFormViewController;
@class CompletedTagFormViewController;
@class UpdateSharePostViewController;
@class DeletePostViewController;
@class UploadDropBoxFileViewController;
@class MadFormViewController;
@class EditMadFormViewController;
@class BackPackViewController;
@class UserLocationVC;
@class FormFolderListViewController;

@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class InboxDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;
@class ManagerReimbursementViewController;

@interface TagHomeViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GetFeedsInvocationDelegate,GetKeywordFeedsInvocationDelegate,TagsInvocationDelegate,TagSearchInvocationDelegate,ClockInInvocationDelegate,CheckPinInvocationDelegate,GetKeywordFeedsInvocationDelegate,InboxListInvocationDelegate,FeedListTableViewCellDelegate,InboxListTableViewCellDelegate,UIPopoverControllerDelegate,SortFeedsDateWiseInvocationDelegate,ClockOutVCDelegate,TagStatusListInvocationDelegate,SortTagStatusDateWiseInvocationDelegate,GetKeywordStatusInvocationDelegate,TagNotificationListInvocationDelegate,DeleteAllTagNotificationInvocationDelegate,DeleteMailInvocationDelegate,DeleteNotificationInvocationDelegate,AddFavoriteInvocationDelegate,AddSadSmileInvocationDelegate,AddSmileInvocationDelegate,GetAmityContactsListDelegate,SendMessageInvocationDelegate,UploadDocInvocationDelegate>
{
    #pragma mark Outlet view declearation
 
    
    
    IBOutlet UISegmentedControl *leftMainSegment;
    IBOutlet UISegmentedControl *leftSecondSegment;
    IBOutlet UISegmentedControl *rightMainSegment;
    IBOutlet UISegmentedControl *SupervisiorRightMainSegment;
    IBOutlet UISegmentedControl *FamilyRightMainSegment;
    IBOutlet UISegmentedControl *FamilyTopRightMainSegment;

    IBOutlet UISegmentedControl *ManagerRightMainSegment;

    IBOutlet UITextField *txtSearch;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    
    IBOutlet UIButton *btnFirstSearch;
    IBOutlet UIButton *btnSecondSearch;
    IBOutlet UIButton *btnAddTak;
    
    IBOutlet UITableView *tblLeftFeedView;
    
    IBOutlet UISwitch *clockInSwitch;
    IBOutlet UIButton *btnEditIntro;
    IBOutlet UIButton *btnTopHashTag;
    IBOutlet UIImageView *imgDate;
    IBOutlet UIButton *btnClearAll;
    IBOutlet UIButton *btnShare;
    IBOutlet UIButton *btnMesssage;
    IBOutlet UILabel *lblNumber;
    IBOutlet UIButton *btnSpecialMesssage;

    #pragma mark Feeds variables declearation

    BOOL isNormalSearch;
    BOOL isTwentyHoursUpdate;
    BOOL isTopHashTag;
    BOOL isClockInFeedAdded;
    BOOL userDidClockedIn;
    BOOL userInRadiusRange;
    BOOL moveToKeywordSearch;;
    BOOL clockInPress;
    
    FeedListTableViewCell *feedCell;
    InboxListTableViewCell *inboxCell;

    IBOutlet ClockInView* clockInView;
    UITableView *hashTagTblView;
    unsigned long int selectedHashTagIndex;
    
    
    IBOutlet UIButton *btnTag;

    NSString *pdfNameStr;

    unsigned long int recordCount,pageIndex,totalNumber;

    //UIPopoverController* popover;
    UITableView *tblViewTagList;

    #pragma mark search and sorting variables and outlet declearation
    
    IBOutlet UIButton* btnSearch;
    IBOutlet UIButton* btnCancel;
    UIDatePicker *datePicker;
    

    NSString *checkPN;

    BOOL checkHashSearch;
    
    
    
    BOOL checkClockOutPopoverView;
    IBOutlet UILabel *lblClockIn;
    IBOutlet UILabel *lblClockOut;
    IBOutlet UIImageView *imgSwitch;
    IBOutlet UIView *backTagView;
    
    IBOutlet UIButton *btnSpecialChatCount;
    IBOutlet UIButton *btnGroupChatCount;
    IBOutlet UIButton *btnChatCount;
    IBOutlet UIButton *btnTagNotificationCount;

    IBOutlet UILabel *lblEmail;
    IBOutlet UIButton *btnBackPack;
    
    BOOL checkSmile;
    BOOL checkCaledarLoad;


}
@property (strong, nonatomic) InboxDetailViewController *objInboxDetailViewController;
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (assign, nonatomic)NSUInteger selectedIndex;

@property (strong, nonatomic) EditTagIntroViewController *objEditTagIntroViewController;
@property (strong, nonatomic) SadSmileViewController *objSadSmileViewController;
@property (strong, nonatomic) SmileViewController *objSmileViewController;
@property (strong, nonatomic) FavoriteViewController *objFavoriteViewController;
@property (strong, nonatomic) SettingViewController *objSettingViewController;
@property (strong, nonatomic) UpdateStatusView *objUpdateStatusView;
@property (strong, nonatomic) UploadDocVC *objUploadDocVC;
@property (strong, nonatomic) FormListViewController *objFormListViewController;
@property (strong, nonatomic) AddNewTaskVC *objAddNewTaskVC;
@property (strong, nonatomic) ChatDetailVC *objChatDetailVC;
@property (strong, nonatomic) ReimbursementsViewController *objReimbursementsViewController;
@property (retain, nonatomic) AddScheduleViewController *objAddScheduleViewController;

@property (strong, nonatomic) AllTagsViewController *objAllTagsViewController;
@property (strong, nonatomic) FormButtonViewController *objFormButtonViewController;
@property (strong, nonatomic) SchedulButtonViewController *objSchedulButtonViewController;
@property (strong, nonatomic) AllPeopleViewController *objAllPeopleViewController;
@property (strong, nonatomic) AllHappyFacePostViewController *objAllHappyFacePostViewController;
@property (strong, nonatomic) AllSadFacePostViewController *objAllSadFacePostViewController;

@property (strong, nonatomic) ManagerAssignedTagViewController   *objManagerAssignedTagViewController;
@property (strong, nonatomic) ManagerReimbursementViewController *objManagerReimbursementViewController;
@property (strong, nonatomic) UserCompletedFormViewController    *objUserCompletedFormViewController;
@property (strong, nonatomic) CompletedTagFormViewController     *objCompletedTagFormViewController;
@property (strong, nonatomic) UpdateSharePostViewController      *objUpdateSharePostViewController;
@property (strong, nonatomic) DeletePostViewController           *objDeletePostViewController;
@property (strong, nonatomic) UploadDropBoxFileViewController    *objUploadDropBoxFileViewController;

@property (strong, nonatomic) MadFormViewController *objMadFormViewController;
@property (strong, nonatomic) EditMadFormViewController *objEditMadFormViewController;
@property (strong, nonatomic) BackPackViewController *objBackPackViewCOntroller;
@property (strong, nonatomic) TaskCalenderViewController *objTaskCalenderView;
@property (strong, nonatomic) UserLocationVC* locationVC;
@property (strong, nonatomic) FormFolderListViewController* objFormFolderListViewController;

@property (strong, nonatomic) UIPopoverController *popoverController;
@property (strong, nonatomic) UIPopoverController *clockOutPopoverController;
@property (strong, nonatomic) UIViewController* popoverContent;
@property (strong, nonatomic) UIView *popoverView;
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UIView *rightInnerView;

@property (strong, nonatomic) IBOutlet UIImageView *tagImgView;
@property (strong, nonatomic) IBOutlet UILabel *tagTitleLbl;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (strong, nonatomic) IBOutlet UILabel *tagLblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)   NSMutableArray *arrFeedList;
@property (strong, nonatomic) NSMutableArray *tenHashTagArr;
@property (strong, nonatomic) NSMutableDictionary *normalSearchDic;
@property(nonatomic,strong)   NSMutableArray *arrInboxListing;
@property (strong, nonatomic) NSMutableArray *arrTagsList;
@property (strong, nonatomic) NSMutableArray *arrStatusList;
@property (strong, nonatomic) NSMutableArray *arrNotificationList;
@property (strong, nonatomic) NSMutableArray* arrTaggedKeywords;
@property (strong, nonatomic) NSMutableArray *contactEmailArr;

@property (strong, nonatomic) NSString *strHashTag;

@property(nonatomic,strong)Tags *selectedTag;
@property (nonatomic, strong)   NSIndexPath* selectedIndxpath;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

// keeps track of selected tag by default selected, while uploading

-(IBAction)btnFirstSearchPressed:(id)sender;
-(IBAction)btnSecondSearchPressed:(id)sender;
-(IBAction)btnBackPackPressed:(id)sender;

-(IBAction)leftMainSegmentAction:(id)sender;
-(IBAction)leftSecondSegmentAction:(id)sender;
-(IBAction)rightMainSegmentAction:(id)sender;
-(IBAction)familyTopRightMainSegmentAction:(id)sender;

-(IBAction)supervisiorRightMainSegmentAction:(id)sender;
-(IBAction)familyRightMainSegmentAction:(id)sender;
-(IBAction)managerRightMainSegmentAction:(id)sender;


-(IBAction)clockInSwitchAction:(id)sender;
-(IBAction)btnTagsAction:(id)sender;
- (IBAction)hashTagBtnPressed:(id)sender;
-(IBAction)editIntroAction:(id)sender;
-(IBAction)addTaskAction:(id)sender;
-(IBAction)btnClearAllAction:(id)sender;
-(IBAction)btnShareAction:(id)sender;
-(IBAction)btnMessageAction:(id)sender;
-(IBAction)btnSpecialMessageAction:(id)sender;

-(void)requestForTagSearchFeeds:(NSMutableDictionary*)dict;

-(void)requestGetTagFeeds:(NSNumber*)index;
-(void)reqeustForTagList;
-(void)fetchAssignedTags;
-(void)requestForTagEmailList;
-(void)requestForTagStatusList:(NSNumber*)index;
-(void)requestForNotificationList;


@end
