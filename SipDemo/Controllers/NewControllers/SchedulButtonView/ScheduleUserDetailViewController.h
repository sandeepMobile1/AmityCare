//
//  ScheduleUserDetailViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 02/03/15.
//
//

#import <UIKit/UIKit.h>
#import "ScheduleUserDetailInvocation.h"

@class EditScheduleListViewController;
@class ScheduleLocationVC;

@interface ScheduleUserDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UITextFieldDelegate,ScheduleUserDetailInvocationDelegate>
{
    
    
    
    IBOutlet UITableView *tblView;
    
    IBOutlet UIButton *btnSearch;
    
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
    unsigned long int recordCount,pageIndex;
    
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    IBOutlet UITextField *txtTagName;

    
    UIToolbar *toolbar;
    

    IBOutlet UILabel *lblTotalHour;
}
@property(nonatomic,strong)EditScheduleListViewController *objEditScheduleListViewController;
@property(nonatomic,strong)ScheduleLocationVC *objScheduleLocationVC;
@property(nonatomic,strong)UIViewController* popoverContent;
@property(nonatomic,strong)UIView *popoverView;
@property(nonatomic,strong)UIPopoverController *popoverController;

@property(nonatomic,strong)NSMutableArray *arrScheduleList;
@property(nonatomic,strong)NSString *userIdStr;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;

-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;

@end
