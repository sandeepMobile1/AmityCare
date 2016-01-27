//
//  InboxListTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import "InboxListTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation InboxListTableViewCell

@synthesize lblTitle,lblSubject,lblMessage,lblDate,cellDelegate,btn;

- (void)awakeFromNib
{
    // Initialization code
}
+(InboxListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    if (IS_DEVICE_IPAD) {
       
        wired = [[NSBundle mainBundle] loadNibNamed:@"InboxListTableViewCell" owner:owner options:nil];

    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"InboxListTableViewCell_iphone" owner:owner options:nil];

    }
    
    InboxListTableViewCell* cell = (InboxListTableViewCell*)[wired firstObjectWithClass:[InboxListTableViewCell class]];
    
    cell.cellDelegate = delegate;
    
    return cell;
    
}

-(IBAction)btnPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonClick:)])
    {
		[self.cellDelegate buttonClick:self];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
