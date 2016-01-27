//
//  AddScheduleViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import <UIKit/UIKit.h>
#import "ScheduleData.h"

#import "UpdateSelfCreatedScheduleInvocation.h"
#import "AddSelfCreatedScheduleInvocation.h"
#import "UserSelectionVC.h"

@class TagAsignViewController;

@interface AddScheduleViewController : UIViewController <UpdateSelfCreatedScheduleInvocationDelegate,AddSelfCreatedScheduleInvocationDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UserSelectionDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *btnAddTime;
    IBOutlet UIButton *btnAddSchedule;
    
    IBOutlet UITextField *txtStartWeek;
    IBOutlet UITextField *txtEndWeek;
    IBOutlet UITextField *txtStartTime;
    IBOutlet UITextField *txtEndTime;
    IBOutlet UITextField *txtTagName;
    IBOutlet UITextField *txtUserName;

    IBOutlet UIImageView *imgTagName;
    IBOutlet UIImageView *imgUserName;

    UIPickerView *weekPickerView;
    UIView *weekView;
    UIPopoverController* popoverController;
    
    UITextField *txtTempStartTime;
    UITextField *txtTempEndTime;
    
    BOOL checkAddPressed;
    
    BOOL checkTextFieldPicker;

    UIDatePicker *datePicker;
    UIToolbar* toolbar;

}
@property(nonatomic,strong)TagAsignViewController *tagVC;
@property(nonatomic,strong) UserSelectionVC *usvc;

@property(nonatomic,strong)NSMutableArray *arrWeekList;
@property(nonatomic,strong)NSMutableArray *shiftArray;
@property(nonatomic,strong)NSMutableArray *startShiftTextFieldArray;
@property(nonatomic,strong)NSMutableArray *endShiftTextFieldArray;
@property(nonatomic,strong)NSMutableArray *arrSelUsersD;
@property(nonatomic,strong)NSDate *startTime;
@property(nonatomic,strong)NSDate *endTime;
@property(nonatomic,strong)ScheduleData *sData;

-(IBAction)btnAddSchedulePressed:(id)sender;
-(IBAction)btnAddTimePressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
