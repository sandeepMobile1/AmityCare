//
//  AllHappyFacePostViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/03/15.
//
//

#import <UIKit/UIKit.h>
#import "FavoriteTableViewCell.h"

#import "AllHappyFacePostsInvocation.h"
@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface AllHappyFacePostViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AllHappyFacePostsInvocationDelegate>
{
    IBOutlet UITableView *tblView;
    FavoriteTableViewCell *feedCell;

    unsigned long int recordCount,pageIndex;
    NSString *checkPN;
    
}
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (strong, nonatomic)UIPopoverController *popoverController;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

@property(nonatomic,strong)NSMutableArray *arrFeedList;
@property(nonatomic,strong)NSString *tagId;

-(void)requestForGetTagFeeds;

@end
