//
//  FormButtonViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <UIKit/UIKit.h>
#import "InboxData.h"
#import "EmailPermissionInvocation.h"
#import "ScheduleEmailListInvocation.h"
#import "ScheduleFormListInvocation.h"
#import "ScheduleStatusListInvocation.h"


@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;

@class FormButtonTableViewCell;
@class FormButtonEmailTableViewCell;


@interface FormButtonViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ScheduleEmailListInvocationDelegate,ScheduleFormListInvocationDelegate,ScheduleStatusListInvocationDelegate,UIPopoverControllerDelegate,UITextFieldDelegate,UISearchBarDelegate,EmailPermissionInvocationDelegate>
{
    FormButtonTableViewCell *feedCell;
    FormButtonEmailTableViewCell *emailCell;
    
    IBOutlet UISegmentedControl *segment;
    IBOutlet UITableView *tblView;
    int recordCount,pageIndex;

    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    IBOutlet UIImageView *imgStartDate;
    IBOutlet UIImageView *imgEndDate;

    
    UIDatePicker *datePicker;
    
    UIToolbar *toolbar;
    IBOutlet UISearchBar* searchBar;
    IBOutlet UIButton* btnSearch;
    
    

    IBOutlet UIButton *customEmployeeBtn;
    IBOutlet UIButton *customManagerBtn;
    IBOutlet UIButton *customTLBtn;
    IBOutlet UIButton *customFamlityBtn;
    //IBOutlet UIButton *customTrainingBtn;
    IBOutlet UIButton *customBSBtn;
    IBOutlet UIButton *radioEmployeeBtn;
    IBOutlet UIButton *radioManagerBtn;
    IBOutlet UIButton *radioTLBtn;
    IBOutlet UIButton *radioFamilyBtn;
    IBOutlet UIButton *radioBSBtn;
   

}
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (strong, nonatomic)UIViewController* permissionPopoverContent;
@property (strong, nonatomic)UIPopoverController *popoverController;

@property(nonatomic,strong)IBOutlet UIView *permissionView;
@property(nonatomic,strong)IBOutlet UIView *permissionInnerView;
@property(nonatomic,strong)NSMutableArray *arrStatusList;
@property(nonatomic,strong)NSMutableArray *arrFeedList;
@property(nonatomic,strong)NSMutableArray *arrEmailList;
@property(nonatomic,assign)NSUInteger selectedIndex;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;

- (IBAction)employeeBtnPressed:(id)sender;
//- (IBAction)managerBtnPressed:(id)sender;
- (IBAction)teamLeaderBtnPressed:(id)sender;
//- (IBAction)trainingBtnPressed:(id)sender;
- (IBAction)familyBtnPressed:(id)sender;
- (IBAction)bSBtnPressed:(id)sender;

-(IBAction)segmentAction:(id)sender;
-(IBAction)btnSearchAction:(id)sender;

- (IBAction)btnClosePressed:(id)sender;

@end
