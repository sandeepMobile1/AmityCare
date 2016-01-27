//
//  CompletedTagFormDetailViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "TagCompletedFormDetailInvocation.h"

@class FormDetailTableViewCell;
@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;

@interface CompletedTagFormDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TagCompletedFormDetailInvocationDelegate,UIPopoverControllerDelegate>
{
    FormDetailTableViewCell *detailCell;
    IBOutlet UITableView *tblView;
    
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolbar;
    
    unsigned long int recordCount,pageIndex;
    
    IBOutlet UILabel *lblTotalForm;
    
}
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (strong, nonatomic) UIViewController* popoverContent;
@property (strong, nonatomic) UIView *popoverView;
@property (strong, nonatomic) UIPopoverController *popoverController;


@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSMutableArray *arrUserFormList;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;

-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;

@end
