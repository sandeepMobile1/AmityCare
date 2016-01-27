//
//  RouteListTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 19/02/15.
//
//

#import "RouteListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation RouteListTableViewCell

@synthesize lblDistance;
@synthesize lblStartLat;
@synthesize lblStartLong;
@synthesize lblEndLat;
@synthesize lblEndLong;
@synthesize delegate;
@synthesize lblStartAdd;
@synthesize lblEndAdd;

- (void)awakeFromNib {
    // Initialization code
}
+(RouteListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"RouteListTableViewCell" owner:owner options:nil];
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"RouteListTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    RouteListTableViewCell* cell = (RouteListTableViewCell*)[wired firstObjectWithClass:[RouteListTableViewCell class]];
    cell.delegate = delegate;
    
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
