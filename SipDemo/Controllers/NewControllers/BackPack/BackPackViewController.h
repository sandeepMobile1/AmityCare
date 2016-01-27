//
//  BackPackViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <UIKit/UIKit.h>

#import "ReminderTableViewCell.h"
#import "MessageTableViewCell.h"
#import "UploadPicTableViewCell.h"
#import "UploadFileTableViewCell.h"
#import "AllBackPackFileListInvocation.h"
#import "AllBackpackMessageListInvocation.h"
#import "AllBackpackPicListInvocation.h"
#import "AllReminderListInvocation.h"
#import "DeleteBackpackReminderInvocation.h"
#import "DeletebackpackMessageInvocation.h"
#import "DeleteBackpackFileInvocation.h"
#import "DeleteBackpackPicInvocation.h"
#import "GetAmityContactsList.h"
#import "ShareBackpackInvocation.h"
#import "AddReminderInvocation.h"
#import "FolderListInvocation.h"
#import "AddMessageInvocation.h"
#import "AddPicInvocation.h"
#import "CreateFolderInvocation.h"

@class AddReminderViewController;
@class AddBackPackMessageViewController;
@class UploadBackPackViewController;
@class UploadListViewController;

@interface BackPackViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MessageTableViewCellDelegate,ReminderTableViewCellDelegate,UploadPicTableViewCellDelegate,UploadFileTableViewCellDelegate,AllReminderListInvocationDelegate,AllBackpackMessageListInvocationDelegate,AllBackpackPicListInvocationDelegate,AllBackPackFileListInvocationDelegate,DeleteBackpackReminderInvocationDelegate,DeletebackpackMessageInvocationDelegate,DeleteBackpackPicInvocationDelegate,DeleteBackpackFileInvocationDelegate,UIAlertViewDelegate,GetAmityContactsListDelegate,ShareBackpackInvocationDelegate,FolderListInvocationDelegate>
{
    
    ReminderTableViewCell *reminderCell;
    MessageTableViewCell *messageCell;
    UploadPicTableViewCell *picCell;
    UploadFileTableViewCell *fileCell;
    IBOutlet UIButton *btnAdd;
    IBOutlet UISegmentedControl *segment;
    IBOutlet UITableView *tblView;
    IBOutlet UITableView *tblViewContactList;
  
    
    
    IBOutlet UIButton *btnShare;

}

@property (nonatomic,strong)AddReminderViewController *objAddReminderViewController;
@property (nonatomic,strong)AddBackPackMessageViewController *objAddBackPackMessageViewController;

@property (nonatomic,strong)UploadBackPackViewController *objUploadBackPackViewController;
@property (nonatomic,strong)UploadListViewController *objUploadListViewController;
@property (nonatomic,strong)IBOutlet UIView *contactView;
@property (nonatomic,strong)UIViewController* popoverContent;
@property (nonatomic,strong)UIView *popoverView;
@property (nonatomic,strong)UIViewController *popoverContactContent;
@property (nonatomic,strong)UIPopoverController *popoverController;

@property (nonatomic,strong)NSMutableArray *arrBackPackList;
@property (nonatomic, assign)unsigned long int selectedIndxpath;
@property(nonatomic,strong)NSMutableArray *arrCheckMarkList;
@property(nonatomic,strong)NSMutableArray *arrContactList;
@property(nonatomic,strong)NSString *tagId;

-(IBAction)btnAddPressed:(id)sender;
-(IBAction)segmentPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnContactCrossPressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;

@end
