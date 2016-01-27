//
//  DeletePostViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "DeleteEmailTableViewCell.h"
#import "FormButtonTableViewCell.h"
#import "FormButtonEmailTableViewCell.h"

#import "DeleteEmailInvocation.h"
#import "DeleteEmailTableViewCell.h"
#import "DeletePostInvocation.h"
#import "ScheduleStatusListInvocation.h"
#import "AllPostListInvocation.h"
#import "FormButtonEmailTableViewCell.h"
#import "FormButtonTableViewCell.h"
#import "DeleteEmailListInvocation.h"

@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class InboxDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface DeletePostViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,AllPostListInvocationDelegate,ScheduleStatusListInvocationDelegate,DeleteEmailListInvocationDelegate,UIPopoverControllerDelegate,DeleteEmailTableViewCellDelegate,DeleteEmailInvocationDelegate,DeletePostInvocationDelegate,FormButtonTableViewCellDelegate,FormButtonEmailTableViewCellDelegate>
{
    FormButtonTableViewCell *feedCell;
    FormButtonEmailTableViewCell *emailCell;
    DeleteEmailTableViewCell *inboxCell;

    IBOutlet UITableView *tblView;
    IBOutlet UISegmentedControl *segment;
    
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    IBOutlet UIImageView *imgStartDate;
    IBOutlet UIImageView *imgEndDate;
    
    IBOutlet UISearchBar* searchBar;
    IBOutlet UIButton* btnSearch;

    
    UIDatePicker *datePicker;
    
    UIToolbar *toolbar;
    
    int recordCount,pageIndex;
    
    

}
@property (strong, nonatomic) InboxDetailViewController *objInboxDetailViewController;

@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

@property (strong, nonatomic) UIViewController* popoverContent;
@property (strong, nonatomic) UIView *popoverView;
@property (strong, nonatomic) UIPopoverController *popoverController;

@property(nonatomic,strong)NSMutableArray *arrFeedList;
@property(nonatomic,strong)NSMutableArray *arrEmailList;

@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;
@property (nonatomic, retain)   NSIndexPath* selectedIndxpath;

-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)segmentPressed:(id)sender;

@end
