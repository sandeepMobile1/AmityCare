//
//  RecieptTableViewCell.m
//  SipDemo
//
//  Created by Octal on 03/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "RecieptTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation RecieptTableViewCell

@synthesize lblWeekDay;
@synthesize lblDate;
@synthesize btnDelete;
@synthesize backView;
@synthesize imgView;
@synthesize btnCheckMark;
@synthesize lblShare;
@synthesize lblShareValue;
@synthesize commentView;
@synthesize txtCommentView;
@synthesize lblComment;
@synthesize btnMore;
@synthesize delegate;
@synthesize lblAmount;
@synthesize lblMerchant;
@synthesize lblRecieptDate;
@synthesize lblReimbursement;
@synthesize txtDescription;
@synthesize lblTagName;

- (void)awakeFromNib {
    // Initialization code
}
+(RecieptTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"RecieptTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"RecieptTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    RecieptTableViewCell* cell = (RecieptTableViewCell*)[wired firstObjectWithClass:[RecieptTableViewCell class]];
    cell.delegate = delegate;
    
    cell.backView.layer.cornerRadius=5;
    cell.backView.clipsToBounds=YES;
    
    cell.imgView.layer.cornerRadius=5;
    cell.imgView.clipsToBounds=YES;
    
    //    cell.lblDate.layer.cornerRadius=5;
    //    cell.lblDate.clipsToBounds=YES;
    
    CGRect bounds = cell.lblWeekDay.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    cell.lblWeekDay.layer.mask = maskLayer;
    
    CGRect bounds1 = cell.lblDate.bounds;
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:bounds1
                                                    byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                          cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = bounds;
    maskLayer1.path = maskPath1.CGPath;
    
    cell.lblDate.layer.mask = maskLayer1;
    
    return cell;
    
}
-(IBAction)btnCheckMarkPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonRecieptCheckMarkClick:)])
    {
        [self.delegate buttonRecieptCheckMarkClick:self];
    }
}
-(IBAction)btnMorePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonRecieptMoreClick:)])
    {
        [self.delegate buttonRecieptMoreClick:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
