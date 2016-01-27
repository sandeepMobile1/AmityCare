//
//  SelfCreatedScheduleViewTableViewCell.m
//  Amity-Care
//
//  Created by Admin on 18/03/15.
//
//

#import "SelfCreatedScheduleViewTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation SelfCreatedScheduleViewTableViewCell

@synthesize lblCreated,lblEndWeek,lblName,lblStartWeek,delegate,btnDelete;

- (void)awakeFromNib {
    // Initialization code
}
+(SelfCreatedScheduleViewTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"SelfCreatedScheduleViewTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"SelfCreatedScheduleViewTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    SelfCreatedScheduleViewTableViewCell* cell = (SelfCreatedScheduleViewTableViewCell*)[wired firstObjectWithClass:[SelfCreatedScheduleViewTableViewCell class]];
    cell.delegate = delegate;
    
    return cell;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
