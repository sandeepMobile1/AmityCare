//
//  MileageCommentTableViewCell.h
//  SipDemo
//
//  Created by Octal on 18/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  MileageCommentTableViewCell;

@protocol MileageCommentTableViewCellDelegate <NSObject>

-(void)btnDeleteClick:(MileageCommentTableViewCell*)cellValue;

@end

@interface MileageCommentTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *     lblUname;
@property(nonatomic,strong)IBOutlet UILabel *     lblComment;
@property(nonatomic,strong)IBOutlet UIImageView * profileImage;
@property(nonatomic,strong)IBOutlet UILabel *     lblCommentTime;
@property(nonatomic,strong)IBOutlet UIButton *    btnDelete;

@property(nonatomic,assign) id<MileageCommentTableViewCellDelegate>delegate;
+(MileageCommentTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnDeletePressed:(id)sender;

@end
