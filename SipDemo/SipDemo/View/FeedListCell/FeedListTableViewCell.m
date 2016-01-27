//
//  FeedListTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 03/12/14.
//
//

#import "FeedListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation FeedListTableViewCell

@synthesize lblName;
@synthesize lblIntro;
@synthesize btnFav;
@synthesize btnSmile;
@synthesize btnSadSmile;
@synthesize btnLocation;
@synthesize imgView;
@synthesize delegate;
@synthesize lbldate;
@synthesize lblEmail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       }
    return self;
}
+(FeedListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"FeedListTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"FeedListTableViewCell_Iphone" owner:owner options:nil];
        
    }
    
    FeedListTableViewCell* cell = (FeedListTableViewCell*)[wired firstObjectWithClass:[FeedListTableViewCell class]];
    
    cell.delegate = delegate;
    
    
    return cell;
    
}



-(IBAction)favButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(FavButtonDidClick:)]){
        [self.delegate FavButtonDidClick:sender];
    }
}
    
-(IBAction)smileButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(SmileDidClick:)]){
        [self.delegate SmileDidClick:sender];
    }
}

-(IBAction)sadSmileButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(SadSmileDidClick:)]){
        [self.delegate SadSmileDidClick:sender];
    }
}

-(IBAction)locationButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(LocationButtonDidClick:)]){
        [self.delegate LocationButtonDidClick:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
