//
//  UserCompletedFormViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "ConfigManager.h"
#import "ScheduleUserListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UserCompletedFormDetailViewController.h"
#import "ContactD.h"
#import "UserCompletedFormListInvocation.h"


@class UserCompletedFormDetailViewController;
@class ScheduleUserListTableViewCell;

@interface UserCompletedFormViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UserCompletedFormListInvocationDelegate>
{
    ScheduleUserListTableViewCell *appCell;

    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *searchBar;
    unsigned long int recordCount,pageIndex;

}
@property(nonatomic,strong)UserCompletedFormDetailViewController *objUserCompletedFormDetailViewController;

@property(nonatomic,strong)NSMutableArray *arrUserList;
@property(nonatomic,strong)NSIndexPath *selectedIndxpath;

@end
