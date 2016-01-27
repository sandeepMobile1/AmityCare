//
//  RouteListTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/02/15.
//
//

#import <UIKit/UIKit.h>

@class  RouteListTableViewCell;

@protocol RouteListTableViewCellDelegate <NSObject>

@end

@interface RouteListTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;

@property(nonatomic,strong)IBOutlet UILabel *   lblDistance;
@property(nonatomic,strong)IBOutlet UILabel *   lblStartLat;
@property(nonatomic,strong)IBOutlet UILabel *   lblStartLong;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndLat;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndLong;
@property(nonatomic,strong)IBOutlet UILabel *   lblStartAdd;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndAdd;

@property(nonatomic,assign) id<RouteListTableViewCellDelegate>delegate;

+(RouteListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;


@end
