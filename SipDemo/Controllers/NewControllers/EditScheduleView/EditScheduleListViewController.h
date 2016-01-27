//
//  EditScheduleListViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 13/03/15.
//
//

#import <UIKit/UIKit.h>
#import "PeopleData.h"
#import "UpdateScheduleInvocation.h"

@interface EditScheduleListViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate,UpdateScheduleInvocationDelegate>
{
    
    IBOutlet UIScrollView *scrollView;
   
    IBOutlet UITextField* txtUserName;
    IBOutlet UITextField* txtTagName;
    IBOutlet UITextField* txtClockInTime;
    IBOutlet UITextField* txtClockOutTime;
    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
      
    UIDatePicker *datePicker;
    UIToolbar* toolbar;
    
    
    
}
@property(nonatomic,strong)PeopleData *pData;
@property(nonatomic,strong)NSString *startDateStr;
@property(nonatomic,strong)NSString *endDateStr;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;

-(IBAction)btnUpdateScheduleAction:(id)sender;
-(IBAction)btnBackAction:(id)sender;
-(void)createEditView;
//-(void) slideFrame:(BOOL) up;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;

@end
