//
//  InboxDetailViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import <UIKit/UIKit.h>
#import "MailDescCell.h"
#import "InboxData.h"

@interface InboxDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

{
    IBOutlet UITableView *tblView;
}
@property(nonatomic,strong) NSMutableArray *arrMailData;
@property(nonatomic,assign) NSUInteger selectedIndex;
-(IBAction)btnBackAction:(id)sender;

@end
