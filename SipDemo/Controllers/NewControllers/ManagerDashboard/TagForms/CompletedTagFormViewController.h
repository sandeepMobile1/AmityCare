//
//  CompletedTagFormViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import <UIKit/UIKit.h>
#import "TagCompletedFormListInvocation.h"

@class CompletedTagFormDetailViewController;

@interface CompletedTagFormViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,TagCompletedFormListInvocationDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *searchBar;
    unsigned long int recordCount,pageIndex;

}
@property(nonatomic,strong)CompletedTagFormDetailViewController *objCompletedTagFormDetailViewController;

@property(nonatomic,strong)NSMutableArray *arrAllTagList;

@end
