//
//  ManagerReimbursementViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "ManagerReimbursementListInvocation.h"
#import "FormButtonTableViewCell.h"
#import "GetAmityContactsList.h"
#import "ShareRootListInvocation.h"

@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface ManagerReimbursementViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ManagerReimbursementListInvocationDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,FormButtonTableViewCellDelegate,GetAmityContactsListDelegate,ShareRootListInvocationDelegate>
{
    FormButtonTableViewCell *feedCell;

    IBOutlet UILabel *lblTotalAmount;
    IBOutlet UILabel *lblTotalMileage;

    IBOutlet UITableView *tblView;
    IBOutlet UITableView *tblViewContactList;

    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtTagName;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolbar;
    int recordCount,pageIndex;
    
    UIButton *selectedShareBtn;

}
@property(nonatomic,strong)NSMutableArray *arrRouteList;
@property(nonatomic,strong)NSMutableArray *arrContactList;

@property(nonatomic,strong)UIPopoverController *popoverController;
@property(nonatomic,strong)UIViewController* popoverContentDatePicker;

@property(nonatomic,strong)UIViewController *popoverContactContent;
@property(nonatomic,strong)IBOutlet UIView *contactView;


@property(nonatomic,strong)UIView *popoverView;
@property(nonatomic,assign)float totalAmount;
@property(nonatomic,assign)float totalMileage;

@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

-(IBAction)btnContactCrossPressed:(id)sender;

-(IBAction)btnSearchPressed:(id)sender;
@end
