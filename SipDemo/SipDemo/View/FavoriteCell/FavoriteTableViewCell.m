//
//  FavoriteTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 15/12/14.
//
//

#import "FavoriteTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation FavoriteTableViewCell

@synthesize lblName;
@synthesize lblIntro;
@synthesize imgView;
@synthesize lbldate;
@synthesize delegate;


- (void)awakeFromNib {
    // Initialization code
}
+(FavoriteTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"FavoriteTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"FavoriteTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    FavoriteTableViewCell* cell = (FavoriteTableViewCell*)[wired firstObjectWithClass:[FavoriteTableViewCell class]];
    cell.delegate = delegate;

    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
