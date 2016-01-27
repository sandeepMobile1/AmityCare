//
//  FavoriteTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 15/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"

@class  FavoriteTableViewCell;

@protocol FavoriteTableViewCellDelegate <NSObject>

@end

@interface FavoriteTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;

@property(nonatomic,strong)IBOutlet UILabel *   lblName;
@property(nonatomic,strong)IBOutlet UILabel *   lblIntro;
@property(nonatomic,strong)IBOutlet UILabel *   lbldate;
@property(nonatomic,strong)Feeds *feed;
@property(nonatomic,assign) id<FavoriteTableViewCellDelegate>delegate;

+(FavoriteTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

@end
