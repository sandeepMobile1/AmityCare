//
//  UserCompletedFormDetailViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "UserCompletedFormDetailInvocation.h"

@class FormDetailTableViewCell;
@class FormFeedDetailViewController;

@interface UserCompletedFormDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UserCompletedFormDetailInvocationDelegate,UIPopoverControllerDelegate>
{
    FormDetailTableViewCell *detailCell;

    IBOutlet UITableView *tblView;

    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;    
    
    unsigned long int recordCount,pageIndex;
    IBOutlet UILabel *lblTotalForm;

    
}
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;

@property(nonatomic,strong)UIViewController* popoverContent;
@property(nonatomic,strong)UIView *popoverView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIPopoverController *popoverController;
@property(nonatomic,strong)UIToolbar *toolbar;

@property(nonatomic,strong)NSString *userIdStr;
@property(nonatomic,strong)NSMutableArray *arrUserFormList;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;

-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
