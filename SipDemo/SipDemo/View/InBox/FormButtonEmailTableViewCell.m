//
//  FormButtonEmailTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import "FormButtonEmailTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation FormButtonEmailTableViewCell

@synthesize lblDate,lblMessage,lblSubject,lblTitle,cellDelegate;

- (void)awakeFromNib {
    // Initialization code
}
+(FormButtonEmailTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"FormButtonEmailTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"FormButtonEmailTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    FormButtonEmailTableViewCell* cell = (FormButtonEmailTableViewCell*)[wired firstObjectWithClass:[FormButtonEmailTableViewCell class]];
    
    cell.cellDelegate = delegate;
    
    return cell;
    
}
-(IBAction)btnDeletePressed:(id)sender
{
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
