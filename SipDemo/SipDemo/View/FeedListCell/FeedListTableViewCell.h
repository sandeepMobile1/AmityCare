//
//  FeedListTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 03/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"

@class  FeedListTableViewCell;

@protocol FeedListTableViewCellDelegate <NSObject>

@optional
-(void)FavButtonDidClick:(UIButton*)sender;
-(void)SadSmileDidClick:(UIButton*)sender;
-(void)SmileDidClick:(UIButton*)sender;
-(void)LocationButtonDidClick:(UIButton*)sender;

@end

@interface FeedListTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;

@property(nonatomic,strong)IBOutlet UILabel *   lblName;
@property(nonatomic,strong)IBOutlet UILabel *   lblIntro;
@property(nonatomic,strong)IBOutlet UILabel *   lbldate;
@property(nonatomic,strong)IBOutlet UILabel *   lblEmail;

@property(nonatomic,strong)IBOutlet UIButton*   btnFav;
@property(nonatomic,strong)IBOutlet UIButton*   btnSmile;
@property(nonatomic,strong)IBOutlet UIButton*   btnSadSmile;
@property(nonatomic,strong)IBOutlet UIButton*   btnLocation;

@property(nonatomic,strong)Feeds *feed;
@property(nonatomic,assign) id<FeedListTableViewCellDelegate>delegate;

+(FeedListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;


-(IBAction)favButtonAction:(id)sender;
-(IBAction)locationButtonAction:(id)sender;
-(IBAction)smileButtonAction:(id)sender;
-(IBAction)sadSmileButtonAction:(id)sender;


@end
