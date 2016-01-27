//
//  AddReminderViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import <UIKit/UIKit.h>
#import "AddReminderInvocation.h"

@interface AddReminderViewController : UIViewController <UITextFieldDelegate,AddReminderInvocationDelegate,UIAlertViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextView *txtDesc;
    UIDatePicker *datePicker;
    UIToolbar* toolbar;
    
    UIAlertView *successAlert;
}
@property(nonatomic,strong) NSString *serverDate;
@property(nonatomic,strong)NSString *tagId;

-(IBAction)btnAddReminderPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
