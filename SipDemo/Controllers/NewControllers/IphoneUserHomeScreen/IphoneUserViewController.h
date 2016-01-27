//
//  IphoneUserViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 06/01/15.
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
#import "UploadDocInvocation.h"

@class ClockInView;
@class ChatDetailVC;
@class ReimbursementsViewController;
@class UserLocationVC;
@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class InboxDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface IphoneUserViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GetAmityContactsListDelegate,GetKeywordFeedsInvocationDelegate,GetNotificationInvocationDelegate,GetKeywordFeedsInvocationDelegate,NormalActionDeledate,UIPopoverControllerDelegate,FeedListTableViewCellDelegate,InboxListTableViewCellDelegate,UISearchBarDelegate,DeleteNotificationInvocationDelegate,LTKPopoverActionSheetDelegate,NormalActionDeledate,LTKPopoverActionSheetDelegate,OptionsPopOverVCDelegate,DeleteAllNotificationInvocationDelegate,FeedListTableViewCellDelegate,UserFeedListInvocationDelegate,UserStatusListInvocationDelegate,SortUserFeedsDateWiseInvocationDelegate,SortUserStatusDateWiseInvocationDelegate,UserEmailListInvocationDelegate,DeleteUserEmailInvocationDelegate,AddFavoriteInvocationDelegate,SendMessageInvocationDelegate,UploadDocInvocationDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    FeedListTableViewCell *feedCell;
    InboxListTableViewCell *inboxCell;
    ChatDetailVC *objChatDetailVC;
    
    #pragma mark Outlet view declearation
    
    IBOutlet UISegmentedControl *leftMainSegment;
    IBOutlet UISegmentedControl *leftSecondSegment;

    IBOutlet UITextField *txtSearch;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIButton *btnFirstSearch;
    IBOutlet UIButton *btnSecondSearch;
    IBOutlet UIButton *btnShare;

    IBOutlet UITableView *tblLeftFeedView;
    
    IBOutlet UIButton *btnClearAll;
    IBOutlet UIButton *btnAddContact;
    
    IBOutlet UILabel *lblUserTitle;
    IBOutlet UITextView *descriptionTxtView;
    IBOutlet UIImageView *imgUserView;
    UIToolbar *toolbar;


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

    NSString *pdfNameStr;

    UITableView *tblViewTagList;
    
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
   
    
    IBOutlet UIButton *btnMenu;
   


    NSString *checkPN;
    
    IBOutlet UIButton *btnUserNotificationCount;


}
@property(nonatomic,strong)UserLocationVC* locationVC;
@property (strong, nonatomic) InboxDetailViewController *objInboxDetailViewController;
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;


@property (strong, nonatomic)IBOutlet UIView *shareContactView;
@property (strong, nonatomic)MFMessageComposeViewController *msgComposer;
@property (strong, nonatomic)UIPopoverController *popoverController;
@property (strong, nonatomic)UIPopoverController* popover;
@property (strong, nonatomic)IBOutlet UITableView *shareTblView;

@property(nonatomic,strong)   NSMutableArray *arrFeedList;
@property (retain, nonatomic) NSMutableArray *formsArr;
@property (retain, nonatomic) NSMutableArray *formNameArr;
@property (retain, nonatomic) NSMutableArray *tenHashTagArr;
@property (retain, nonatomic) NSMutableDictionary *normalSearchDic;
@property(nonatomic,strong)   NSMutableArray *arrInboxListing;
@property (retain, nonatomic) NSMutableArray *arrTagsList;
@property (retain, nonatomic) NSMutableArray *arrStatusList;
@property (retain, nonatomic) NSMutableArray *arrNotificationList;
@property (retain, nonatomic) NSMutableArray *arrSearchList;
@property (retain, nonatomic) NSMutableArray *contactEmailArr;

#pragma mark Contatcts variables and outlet declearation

@property (retain, nonatomic) NSMutableArray *arrContactsList;
@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;
@property (nonatomic, retain)   NSIndexPath* selectedIndxpath;
@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;

@property(nonatomic,strong)Tags *selectedTag;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;

-(IBAction)btnFirstSearchPressed:(id)sender;
-(IBAction)btnSecondSearchPressed:(id)sender;
-(IBAction)leftMainSegmentAction:(id)sender;
-(IBAction)leftSecondSegmentAction:(id)sender;
-(IBAction)btnClearAllAction:(id)sender;
-(IBAction)btnAddContactAction:(id)sender;
-(IBAction)menuButtonAction:(id)sender;
-(IBAction)btnShareAction:(id)sender;
-(IBAction)btnCloseShareView:(id)sender;

-(void)requestForTagSearchFeeds:(NSMutableDictionary*)dict;
-(void)requestGetTagFeeds:(NSNumber*)index;
-(void)requestForEmailList;
-(void)requestForUserStatusList:(NSNumber*)index;
-(void)requestForNotificationList;
-(void)requestForContactList;

@end
