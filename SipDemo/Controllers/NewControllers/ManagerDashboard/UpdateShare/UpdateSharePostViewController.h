//
//  UpdateSharePostViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "ManagerSharePostListInvocation.h"

@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface UpdateSharePostViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ManagerSharePostListInvocationDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UITextField *txtTagName;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    unsigned long int recordCount,pageIndex;
    UIDatePicker *datePicker;
    UIToolbar *toolbar;


}
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (strong, nonatomic) UIPopoverController *popoverController;

@property(nonatomic,strong)NSMutableArray *arrFeedList;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

-(IBAction)btnSearchPressed:(id)sender;
@end
