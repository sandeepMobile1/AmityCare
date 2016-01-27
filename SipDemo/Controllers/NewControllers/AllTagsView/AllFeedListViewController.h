//
//  AllFeedListViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import <UIKit/UIKit.h>
#import "AllTagPostInvocation.h"

@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;


@interface AllFeedListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,AllTagPostInvocationDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UITableView *tblView;
    unsigned long int recordCount,pageIndex;
    
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    IBOutlet UITextField *txtHashSearch;

    UIDatePicker *datePicker;
    
    UIToolbar *toolbar;
    
    
}

@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

@property (strong, nonatomic)UIViewController* popoverContent;
@property (strong, nonatomic)UIView *popoverView;
@property (strong, nonatomic)UIPopoverController *popoverController;


@property(nonatomic,strong)NSMutableArray *arrFeedList;
@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;


-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnSearchAction:(id)sender;

@end
