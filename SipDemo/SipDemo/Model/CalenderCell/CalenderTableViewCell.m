//
//  CalenderTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 13/10/14.
//
//

#import "CalenderTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation CalenderTableViewCell

@synthesize lblDate,lblTitle,cellDelegate;

- (void)awakeFromNib {
    // Initialization code
}
+(CalenderTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if(IS_DEVICE_IPAD)
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"CalenderTableViewCell" owner:owner options:nil];

    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"CalenderTableViewCell_iphone" owner:owner options:nil];

    }
    
    CalenderTableViewCell* cell = (CalenderTableViewCell*)[wired firstObjectWithClass:[CalenderTableViewCell class]];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnPressed:(id)sender
{
//    if ([self.cellDelegate respondsToSelector:@selector(buttonClick:)])
//    {
//        [self.cellDelegate buttonClick:self];
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
