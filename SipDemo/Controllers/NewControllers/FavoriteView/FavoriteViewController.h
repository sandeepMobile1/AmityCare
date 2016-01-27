//
//  FavoriteViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <UIKit/UIKit.h>
#import "FavoriteTableViewCell.h"
#import "FavoriteFeedListInvocation.h"

@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface FavoriteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,FavoriteFeedListInvocationDelegate,FavoriteTableViewCellDelegate>
{
    FavoriteTableViewCell *feedCell;
    IBOutlet UITableView *tblLeftFeedView;
    
    int recordCount,pageIndex;

}
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (strong, nonatomic) UIPopoverController *popoverController;

@property(nonatomic,strong)NSMutableArray *arrFeedList;
@property(nonatomic,strong)NSString *tagId;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

-(void)requestForGetTagFeeds;

@end
