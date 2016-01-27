//
//  UploadListViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 15/05/15.
//
//

#import <UIKit/UIKit.h>
#import "UploadPicTableViewCell.h"
#import "UploadFileTableViewCell.h"
#import "DeleteBackpackFileInvocation.h"
#import "DeleteBackpackPicInvocation.h"
#import "GetAmityContactsList.h"
#import "AllBackPackFileListInvocation.h"
#import "AllBackpackPicListInvocation.h"
#import "ShareBackpackInvocation.h"

@class BackpackZoomViewController;

@interface UploadListViewController : UIViewController <UploadPicTableViewCellDelegate,UploadFileTableViewCellDelegate,DeleteBackpackPicInvocationDelegate,DeleteBackpackFileInvocationDelegate,UIAlertViewDelegate,GetAmityContactsListDelegate,ShareBackpackInvocationDelegate,AllBackpackPicListInvocationDelegate,AllBackPackFileListInvocationDelegate,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate>
{
    UploadPicTableViewCell *picCell;
    UploadFileTableViewCell *fileCell;
    
    IBOutlet UITableView *tblView;
    IBOutlet UITableView *tblViewContactList;
    
   
    
    IBOutlet UIButton *btnShare;

}
@property (nonatomic,strong)IBOutlet UIView *contactView;
@property (nonatomic,strong)UIViewController* popoverContent;
@property (nonatomic,strong)UIView *popoverView;
@property (nonatomic,strong)UIViewController *popoverContactContent;
@property (nonatomic,strong)UIPopoverController *popoverController;

@property (nonatomic,strong)NSMutableArray *arrBackPackList;
@property (nonatomic, assign)int selectedIndxpath;
@property(nonatomic,strong)NSMutableArray *arrCheckMarkList;
@property(nonatomic,strong)NSMutableArray *arrContactList;
@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSString *folderId;
@property(nonatomic,strong)NSString *folderTitle;
@property(nonatomic,strong) BackpackZoomViewController *imgPhoto;

@property(nonatomic,strong)NSString *checkUpload;

-(IBAction)btnSharePressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnContactCrossPressed:(id)sender;

@end
