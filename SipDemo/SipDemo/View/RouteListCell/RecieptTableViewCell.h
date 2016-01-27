//
//  RecieptTableViewCell.h
//  SipDemo
//
//  Created by Octal on 03/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  RecieptTableViewCell;

@protocol RecieptTableViewCellDelegate <NSObject>

-(void) buttonRecieptCheckMarkClick:(RecieptTableViewCell*)cellValue;
-(void) buttonRecieptMoreClick:(RecieptTableViewCell*)cellValue;

@end
@interface RecieptTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)IBOutlet UILabel *   lblRecieptDate;
@property(nonatomic,strong)IBOutlet UILabel *   lblShare;
@property(nonatomic,strong)IBOutlet UILabel *   lblShareValue;
@property(nonatomic,strong)IBOutlet UILabel *   lblMerchant;
@property(nonatomic,strong)IBOutlet UILabel *   lblAmount;
@property(nonatomic,strong)IBOutlet UILabel *   lblReimbursement;
@property(nonatomic,strong)IBOutlet UILabel *txtDescription;
@property(nonatomic,strong)IBOutlet UILabel *   lblTagName;


@property(nonatomic,strong)IBOutlet UIButton  *  btnDelete;
@property(nonatomic,strong)IBOutlet UIButton  *  btnCheckMark;

@property(nonatomic,strong)IBOutlet UIView  *  backView;
@property(nonatomic,strong)IBOutlet UIImageView  * imgView;
@property(nonatomic,strong)IBOutlet UIView *commentView;
@property(nonatomic,strong)IBOutlet UITextField *txtCommentView;
@property(nonatomic,strong)IBOutlet UILabel *lblComment;
@property(nonatomic,strong)IBOutlet UIButton *btnMore;
@property(nonatomic,strong)IBOutlet UILabel *   lblWeekDay;
@property(nonatomic,strong)IBOutlet UILabel *   lblDate;

@property(nonatomic,assign) id<RecieptTableViewCellDelegate>delegate;

+(RecieptTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;
-(IBAction)btnCheckMarkPressed:(id)sender;
-(IBAction)btnMorePressed:(id)sender;

@end
