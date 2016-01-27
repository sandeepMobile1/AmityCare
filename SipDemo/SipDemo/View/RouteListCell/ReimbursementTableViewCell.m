//
//  ReimbursementTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 20/04/15.
//
//

#import "ReimbursementTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation ReimbursementTableViewCell

@synthesize lblStartAdd;
@synthesize lblEndAdd;
@synthesize lblWeekDay;
@synthesize lblDate;
@synthesize lblStartTime;
@synthesize lblEndTime;
@synthesize lblDistance;
@synthesize MKStartMapView;
@synthesize MKEndMapView;
@synthesize btnStartMapView;
@synthesize btnEndMapView;
@synthesize btnDelete;
@synthesize delegate;
@synthesize backView;
@synthesize imgView;
@synthesize btnCheckMark;
@synthesize lblShare;
@synthesize lblShareValue;
@synthesize commentView;
@synthesize txtCommentView;
@synthesize lblComment;
@synthesize btnMore;
@synthesize lblTagName;

- (void)awakeFromNib {
    // Initialization code
}
+(ReimbursementTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"ReimbursementTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"ReimbursementTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    ReimbursementTableViewCell* cell = (ReimbursementTableViewCell*)[wired firstObjectWithClass:[ReimbursementTableViewCell class]];
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
    if ([self.delegate respondsToSelector:@selector(buttonCheckMarkClick:)])
    {
        [self.delegate buttonCheckMarkClick:self];
    }
}
-(IBAction)btnMorePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonMoreClick:)])
    {
        [self.delegate buttonMoreClick:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
