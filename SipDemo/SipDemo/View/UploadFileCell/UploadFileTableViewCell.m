//
//  UploadFileTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "UploadFileTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation UploadFileTableViewCell

@synthesize imgView,delegate,btnDelete,btnCheckMark,lblTitle;

+(UploadFileTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"UploadFileTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"UploadFileTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    UploadFileTableViewCell* cell = (UploadFileTableViewCell*)[wired firstObjectWithClass:[UploadFileTableViewCell class]];
    cell.delegate = delegate;
    
    cell.imgView.layer.cornerRadius=5;
    [cell.imgView setClipsToBounds:YES];
    
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
