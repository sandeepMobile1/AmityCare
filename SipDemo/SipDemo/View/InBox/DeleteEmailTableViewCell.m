//
//  DeleteEmailTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/03/15.
//
//

#import "DeleteEmailTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation DeleteEmailTableViewCell

@synthesize btnDelete,lblTitle,lblSubject,lblMessage,lblDate,cellDelegate;

- (void)awakeFromNib
{
    // Initialization code
}
+(DeleteEmailTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"DeleteEmailTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"DeleteEmailTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    DeleteEmailTableViewCell* cell = (DeleteEmailTableViewCell*)[wired firstObjectWithClass:[DeleteEmailTableViewCell class]];
    
    cell.cellDelegate = delegate;
    
    return cell;
    
}

-(IBAction)btnDeletePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonEmailDeleteClick:)])
    {
        [self.cellDelegate buttonEmailDeleteClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
