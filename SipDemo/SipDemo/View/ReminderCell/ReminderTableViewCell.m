//
//  ReminderTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "ReminderTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReminderTableViewCell
@synthesize lblTitle,lblDate,delegate,btnDelete,lblDesc,btnCheckMark;

+(ReminderTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"ReminderTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"ReminderTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    ReminderTableViewCell* cell = (ReminderTableViewCell*)[wired firstObjectWithClass:[ReminderTableViewCell class]];
    cell.delegate = delegate;
    
    
    return cell;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
