//
//  ReimbursementsViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 17/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ReimbursementTableViewCell.h"
#import "MapRouteViewController.h"
#import "ReimembursementListInvocation.h"
#import "DeleteRootInvocation.h"
#import "ShareRootListInvocation.h"
#import "GetAmityContactsList.h"
#import "TagsInvocation.h"
#import "AddRouteCommentInvocation.h"
#import "AddCommentInvocation.h"
#import "RecieptTableViewCell.h"
#import "UploadReceiptViewController.h"

@class RouteCommentViewController;

@class RouteCommentViewController;
@class MapRouteViewController;

@interface ReimbursementsViewController : UIViewController <ShareReimbursementInvocationDelegate,ReimembursementListInvocationDelegate,UITableViewDataSource,UITableViewDelegate,ReimbursementTableViewCellDelegate,MapRouteViewControllerDelegate,UIPopoverControllerDelegate,UITextFieldDelegate,MKMapViewDelegate,DeleteRootInvocationDelegate,ShareRootListInvocationDelegate,GetAmityContactsListDelegate,TagsInvocationDelegate,UITextFieldDelegate,AddRouteCommentInvocationDelegate,AddCommentInvocationDelegate,RecieptTableViewCellDelegate,UploadReceiptViewControllerDelegate>
{
    ReimbursementTableViewCell *rootCell;
    RecieptTableViewCell *recieptCell;
    
    IBOutlet UILabel *lblDistance;
    IBOutlet MKMapView *mapView;
    IBOutlet UITableView *tblView;

    IBOutlet UIImageView *imgMapView;
    
    IBOutlet UILabel *lblTotalAmount;
    IBOutlet UILabel *lblTotalMileage;

    NSTimer *distanceTimer;
    
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;

    UIDatePicker *datePicker;
    
    UIToolbar *toolbar;

    IBOutlet UITableView *tblViewTagList;
    IBOutlet UIButton *btnStop;
    IBOutlet UIButton *btnShare;

    IBOutlet UITableView *tblViewContactList;
    
    IBOutlet UIButton *btnReciept;
    
    IBOutlet UITextField *txtUser;
    IBOutlet UITextField *txtTag;
    IBOutlet UIButton *btnSearch;
    
    IBOutlet UIImageView *imgTxtUserName;
    IBOutlet UIImageView *imgTxtTagName;

}
@property(nonatomic,strong)MapRouteViewController *objMapRouteMapView;
@property(nonatomic,strong)UIPopoverController *popoverController;
@property(nonatomic,strong)UIViewController* popoverContent;
@property(nonatomic,strong)UIView *popoverView;
@property(nonatomic,strong)UIViewController *popoverContactContent;
@property(nonatomic,strong)UIViewController* popoverContentDatePicker;

@property(nonatomic,strong)IBOutlet UIView *contactView;
@property(nonatomic,strong)IBOutlet UIView *tagView;
@property(nonatomic,assign)float totalAmount;
@property(nonatomic,assign)float totalMileage;

@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSMutableArray *arrCheckMarkList;

@property(nonatomic,strong)NSString *shareTagId;


@property(nonatomic,strong)NSString *startLatitude;
@property(nonatomic,strong)NSString *startLongitude;
@property(nonatomic,strong)NSString *endLatitude;
@property(nonatomic,strong)NSString *endLongitude;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;

@property(nonatomic,strong)NSString *checkClockin;
@property(nonatomic,strong)NSMutableArray *arrContactList;
@property (retain, nonatomic) NSMutableArray *arrTagsList;

@property (nonatomic, assign)int selectedIndxpath;


@property(nonatomic,strong)NSMutableArray *arrRouteList;
@property(nonatomic,strong)RouteCommentViewController *objRootCommentViewController;
@property(nonatomic,strong)UploadReceiptViewController *objUploadReceiptViewController;

-(IBAction)btnStartPressed:(id)sender;
-(IBAction)btnStopPressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)btnTagCrossPressed:(id)sender;
-(IBAction)btnContactCrossPressed:(id)sender;
-(IBAction)btnReceiptPressed:(id)sender;

@end
