//
//  TaskCalenderViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "VRGCalenderViewIphone.h"
#import "AmityCareServices.h"
#import "TagCalenderListInvocation.h"
#import "CalenderTableViewCell.h"
#import "UserCalenderListInvocation.h"
#import "AddNewTaskVC.h"
@class TaskDetailVC;


@interface TaskCalenderViewController : UIViewController <VRGCalendarViewDelegate,VRGCalenderViewIphoneDelegate,TagCalenderListInvocationDelegate,UITableViewDataSource,UITableViewDelegate,CalenderTableViewCellDelegate,UserCalenderListInvocationDelegate,TagAssignCalendarListInvocationDelegate,UserAssignCalandarListInvocationDelegate,TaskDelegate>
{
    
    CalenderTableViewCell *cell;
    
    VRGCalendarView *calendar;
    VRGCalenderViewIphone *calendar_iphone;
    
    AmityCareServices *service;
    
    IBOutlet UIView *calView;
    
    IBOutlet UITableView *tblView;
    
    IBOutlet UISegmentedControl *calenderSegment;
    
}
@property(nonatomic,strong)TaskDetailVC* objTaskDetailVC;
@property(nonatomic,strong)AddNewTaskVC *editTask;
@property(nonatomic,strong)NSMutableArray *arrDateList;
@property(nonatomic,strong)NSMutableArray *arrSelectedDateList;

@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSString *tagName;

-(IBAction)calenderSegmentAction:(id)sender;
-(void)requestForMyTask;
-(void)requestForAssignTask;

@end
