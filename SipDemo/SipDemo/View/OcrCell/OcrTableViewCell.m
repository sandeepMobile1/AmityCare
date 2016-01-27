//
//  OcrTableViewCell.m
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "OcrTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CAVNSArrayTypeCategory.h"

@implementation OcrTableViewCell

@synthesize imgViewOcr;
@synthesize lblTitle;
@synthesize lblAmount;
@synthesize lblAddress;
@synthesize lblComment;
@synthesize lblDate;
@synthesize lblNumber;
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}
+(OcrTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"OcrTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"OcrTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    OcrTableViewCell* cell = (OcrTableViewCell*)[wired firstObjectWithClass:[OcrTableViewCell class]];
    cell.delegate = delegate;
    
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
