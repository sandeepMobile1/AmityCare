//
//  MessageTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "MessageTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageTableViewCell

@synthesize lblMessage,delegate,btnDelete,btnCheckMark;

+(MessageTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    MessageTableViewCell* cell = (MessageTableViewCell*)[wired firstObjectWithClass:[MessageTableViewCell class]];
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
