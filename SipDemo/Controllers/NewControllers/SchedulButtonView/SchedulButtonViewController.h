//
//  SchedulButtonViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <UIKit/UIKit.h>
#import "DeleteSelfCreatedScheduleINvocation.h"
#import "FilterScheduleListInvocation.h"
#import "SelfCreatedScheduleListInvocation.h"
#import "DeleteSelfCreatedScheduleINvocation.h"

@class ScheduleUserListTableViewCell;
@class SelfCreatedScheduleViewTableViewCell;
@class ScheduleUserDetailViewController;
@class AddScheduleViewController;

@interface SchedulButtonViewController : UIViewController <UITableViewDataSource,DeleteSelfCreatedScheduleINvocationDelegate,UITableViewDelegate,UIAlertViewDelegate,UIPopoverControllerDelegate,UITextFieldDelegate,FilterScheduleListInvocationDelegate,SelfCreatedScheduleListInvocationDelegate,DeleteSelfCreatedScheduleINvocationDelegate>
{
    ScheduleUserListTableViewCell *appCell;
    SelfCreatedScheduleViewTableViewCell *scheduleCell;

    IBOutlet UITableView *tblView;
    IBOutlet UISegmentedControl *segment;
    
    IBOutlet UIButton *btnSearch;
    
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
    unsigned long int recordCount,pageIndex;

    IBOutlet UITextField *txtEmplyeeName;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    UIToolbar *toolbar;

    

}
@property(nonatomic,strong)ScheduleUserDetailViewController *objScheduleUSerDetailViewController;
@property(nonatomic,strong)AddScheduleViewController *objAddScheduleViewController;
@property(nonatomic,strong)UIPopoverController *popoverController;
@property(nonatomic,strong)UIViewController* popoverContent;
@property(nonatomic,strong)UIView *popoverView;

@property(nonatomic,strong)NSMutableArray *arrScheduleList;
@property(nonatomic,strong)NSIndexPath *selectedIndxpath;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;
@property(nonatomic,strong)NSString *deletedScheduleId;

-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)btnSegmentPressed:(id)sender;

@end
