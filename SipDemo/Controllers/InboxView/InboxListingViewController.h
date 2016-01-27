//
//  InboxListingViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import <UIKit/UIKit.h>
#import "InboxListTableViewCell.h"
#import "InboxListInvocation.h"
#import "DeleteMailInvocation.h"

@interface InboxListingViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,InboxListInvocationDelegate,InboxListTableViewCellDelegate,DeleteMailInvocationDelegate>
{
    InboxListTableViewCell *cell;
    IBOutlet UITableView *tblView;
    NSIndexPath* selectedIndxpath;
}

@property (assign, nonatomic) NSUInteger selectedRowIndex;

@property(nonatomic,strong)NSMutableArray *arrInboxListing;
@property(nonatomic,strong)NSString *tagId;

@end
