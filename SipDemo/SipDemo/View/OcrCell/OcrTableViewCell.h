//
//  OcrTableViewCell.h
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  OcrTableViewCell;


@protocol OcrTableViewCellDelegate <NSObject>

@end

@interface OcrTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)IBOutlet UIImageView *imgViewOcr;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblAmount;
@property(nonatomic,strong)IBOutlet UILabel *lblAddress;
@property(nonatomic,strong)IBOutlet UILabel *lblComment;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblNumber;

@property(nonatomic,assign) id<OcrTableViewCellDelegate>delegate;

+(OcrTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

@end
