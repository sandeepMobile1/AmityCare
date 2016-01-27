//
//  ChatListTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 06/01/15.
//
//

#import "ChatListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation ChatListTableViewCell

@synthesize lblUserName,lblDateTime,lblMessage,imgView,delegate;

- (void)awakeFromNib {
    // Initialization code
}
+(ChatListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatListTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatListTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    ChatListTableViewCell* cell = (ChatListTableViewCell*)[wired firstObjectWithClass:[ChatListTableViewCell class]];
    cell.delegate = delegate;
    
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
