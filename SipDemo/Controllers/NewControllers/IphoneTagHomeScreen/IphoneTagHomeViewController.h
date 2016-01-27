//
//  IphoneTagHomeViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 06/01/15.
//
//

#import <UIKit/UIKit.h>
#import "Tags.h"
#import "FeedListTableViewCell.h"
#import "InboxListTableViewCell.h"
#import "ClockOutVC.h"

#import "GetFeedsInvocation.h"
#import "GetKeywordFeedsInvocation.h"
#import "GetTaskListInvocation.h"
#import "TagsInvocation.h"
#import "TagCalenderListInvocation.h"
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
@class EditTagIntroViewController;
@class UserLocationVC;
@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class InboxDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface IphoneTagHomeViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GetFeedsInvocationDelegate,GetKeywordFeedsInvocationDelegate,TagsInvocationDelegate,TagSearchInvocationDelegate,ClockInInvocationDelegate,CheckPinInvocationDelegate,GetKeywordFeedsInvocationDelegate,InboxListInvocationDelegate,FeedListTableViewCellDelegate,InboxListTableViewCellDelegate,UIPopoverControllerDelegate,SortFeedsDateWiseInvocationDelegate,TagStatusListInvocationDelegate,SortTagStatusDateWiseInvocationDelegate,GetKeywordStatusInvocationDelegate,TagNotificationListInvocationDelegate,DeleteAllTagNotificationInvocationDelegate,DeleteMailInvocationDelegate,DeleteNotificationInvocationDelegate,AddFavoriteInvocationDelegate,AddSadSmileInvocationDelegate,AddSmileInvocationDelegate,GetAmityContactsListDelegate,SendMessageInvocationDelegate,UploadDocInvocationDelegate>
{
   
    IBOutlet UISegmentedControl *leftMainSegment;
    IBOutlet UISegmentedControl *leftSecondSegment;

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

    IBOutlet ClockInView* clockInView;
    IBOutlet UITableView *hashTagTblView;
    IBOutlet UITableView *shareTblView;

    NSUInteger selectedHashTagIndex;
    
    UIToolbar *toolbar;

    unsigned long int recordCount,pageIndex,totalNumber;
    NSString *pdfNameStr;

    FeedListTableViewCell *feedCell;
    InboxListTableViewCell *inboxCell;

#pragma mark search and sorting variables and outlet declearation
    
    IBOutlet UIButton* btnSearch;
    IBOutlet UIButton* btnCancel;
    UIDatePicker *datePicker;
    
    IBOutlet UIButton *btnMenu;

    BOOL checkHashSearch;
    
    NSString *checkPN;
    
    IBOutlet UILabel *lblClockIn;
    IBOutlet UILabel *lblClockOut;
    IBOutlet UIImageView *imgSwitch;
    IBOutlet UIView *backTagView;
    
    IBOutlet UIButton *btnSpecialChatCount;
    IBOutlet UIButton *btnGroupChatCount;
    IBOutlet UIButton *btnTagNotificationCount;
    IBOutlet UILabel *lblEmail;
    
    BOOL checkSmile;


}

@property (strong, nonatomic) UserLocationVC* locationVC;
@property (strong, nonatomic) InboxDetailViewController *objInboxDetailViewController;
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

@property (strong, nonatomic) UIPopoverController *popoverController;
@property (assign, nonatomic)NSUInteger selectedIndex;

@property (strong, nonatomic) EditTagIntroViewController *objEditTagIntroViewController;
@property (strong, nonatomic) IBOutlet UITableView  *tblViewTagList;
@property (strong, nonatomic) UIPopoverController   *popover;
@property (strong, nonatomic) IBOutlet UIView       *tagPopoverView;
@property (strong, nonatomic) IBOutlet UIView       *hashTagPopoverView;
@property (strong, nonatomic) IBOutlet UIView       *shareContactView;

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
@property (nonatomic, retain)   NSIndexPath* selectedIndxpath;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;

// keeps track of selected tag by default selected, while uploading

-(IBAction)btnFirstSearchPressed:(id)sender;
-(IBAction)btnSecondSearchPressed:(id)sender;
-(IBAction)leftMainSegmentAction:(id)sender;
-(IBAction)leftSecondSegmentAction:(id)sender;
-(IBAction)clockInSwitchAction:(id)sender;
-(IBAction)btnTagsAction:(id)sender;
- (IBAction)hashTagBtnPressed:(id)sender;
-(IBAction)editIntroAction:(id)sender;
-(IBAction)btnClearAllAction:(id)sender;
-(IBAction)btnCloseTagView:(id)sender;
-(IBAction)btnCloseHashTagView:(id)sender;
-(IBAction)btnCloseShareView:(id)sender;
-(IBAction)btnMessageAction:(id)sender;
-(IBAction)btnSpecialMessageAction:(id)sender;

-(IBAction)menuButtonAction:(id)sender;
-(IBAction)btnShareAction:(id)sender;

-(void)requestForTagSearchFeeds:(NSMutableDictionary*)dict;

-(void)requestGetTagFeeds:(NSNumber*)index;
-(void)reqeustForTagList;
-(void)fetchAssignedTags;
-(void)requestForTagEmailList;
-(void)requestForTagStatusList:(NSNumber*)index;
-(void)requestForNotificationList;

@end
