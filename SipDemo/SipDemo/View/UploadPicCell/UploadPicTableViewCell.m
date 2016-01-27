//
//  UploadPicTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "UploadPicTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation UploadPicTableViewCell

@synthesize imgView,delegate,btnDelete,lblTitle,btnCheckMark;

+(UploadPicTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    
    NSArray *wired;
    
    if (IS_DEVICE_IPAD) {
        
        wired = [[NSBundle mainBundle] loadNibNamed:@"UploadPicTableViewCell" owner:owner options:nil];
        
    }
    else
    {
        wired = [[NSBundle mainBundle] loadNibNamed:@"UploadPicTableViewCell_iphone" owner:owner options:nil];
        
    }
    
    UploadPicTableViewCell* cell = (UploadPicTableViewCell*)[wired firstObjectWithClass:[UploadPicTableViewCell class]];
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
