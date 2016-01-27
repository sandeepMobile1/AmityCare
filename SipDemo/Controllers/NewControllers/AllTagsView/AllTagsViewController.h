//
//  AllTagsViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <UIKit/UIKit.h>
#import "TagsListInvocation.h"

@class AllFeedListViewController;

@interface AllTagsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,TagsListInvocationDelegate>
{
    IBOutlet UITableView *tblView;
}
@property(nonatomic,strong)AllFeedListViewController *objAllFeedListViewController;

@property(nonatomic,strong)NSMutableArray *arrAllTagList;
@end
