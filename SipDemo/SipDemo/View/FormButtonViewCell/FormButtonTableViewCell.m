//
//  FormButtonTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 03/03/15.
//
//

#import "FormButtonTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation FormButtonTableViewCell

@synthesize lblName;
@synthesize lblIntro;
@synthesize imgView;
@synthesize lbldate;
@synthesize delegate;
@synthesize lblTagName;
@synthesize btnDelete;

- (void)awakeFromNib {
    // Initialization code
}
+(FormButtonTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"FormButtonTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"FormButtonTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    FormButtonTableViewCell* cell = (FormButtonTableViewCell*)[wired firstObjectWithClass:[FormButtonTableViewCell class]];
    cell.delegate = delegate;
    
    return cell;
    
}
-(IBAction)btnDeletePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonDeleteClick:)])
    {
        [self.delegate buttonDeleteClick:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
