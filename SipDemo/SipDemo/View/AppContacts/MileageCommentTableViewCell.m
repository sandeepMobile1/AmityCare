//
//  MileageCommentTableViewCell.m
//  SipDemo
//
//  Created by Octal on 18/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "MileageCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation MileageCommentTableViewCell

@synthesize lblUname;
@synthesize lblComment;
@synthesize profileImage;
@synthesize lblCommentTime;
@synthesize btnDelete,delegate;

+(MileageCommentTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"MileageCommentTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"MileageCommentTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    MileageCommentTableViewCell* cell = (MileageCommentTableViewCell*)[wired firstObjectWithClass:[MileageCommentTableViewCell class]];
    cell.delegate = delegate;
    
    return cell;
    
}
-(IBAction)btnDeletePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(btnDeleteClick:)])
    {
            [self.delegate btnDeleteClick:self];
      }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
