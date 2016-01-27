//
//  SadSmileViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <UIKit/UIKit.h>
#import "FavoriteTableViewCell.h"
#import "SmileFeedListInvocation.h"
#import "AllSadFacePostsInvocation.h"
#import "DeleteSmileyInvocation.h"

@class FormFeedDetailViewController;
@class StatusFeedDetailViewController;
@class FeedDetailViewController;
@class RouteFeedDetailViewController;
@class RecieptFeedDetailViewController;

@interface SadSmileViewController : UIViewController <SmileFeedListInvocationDelegate,UITableViewDataSource,UITableViewDelegate,AllSadFacePostsInvocationDelegate,DeleteSmileyInvocationDelegate>
{
    FavoriteTableViewCell *feedCell;
    IBOutlet UITableView *tblLeftFeedView;
    unsigned long int recordCount,pageIndex;
    NSString *checkPN;
    
    IBOutlet UISegmentedControl *segment;

}
@property (strong, nonatomic) FormFeedDetailViewController *objFormFeedDetailViewController;
@property (strong, nonatomic) StatusFeedDetailViewController *objStatusFeedDetailViewController;
@property (strong, nonatomic) FeedDetailViewController *objFeedDetailViewController;
@property (strong, nonatomic) UIPopoverController *popoverController;
@property (nonatomic, strong)   NSIndexPath* selectedIndxpath;

@property(nonatomic,strong)NSMutableArray *arrFeedList;
@property(nonatomic,strong)NSString *tagId;
@property (nonatomic, strong) RouteFeedDetailViewController *objRouteFeedDetailViewController;
@property(nonatomic,strong)RecieptFeedDetailViewController *objRecieptFeedDetailViewController;

-(void)requestForGetTagFeeds;
-(IBAction)segmentAction:(id)sender;

@end