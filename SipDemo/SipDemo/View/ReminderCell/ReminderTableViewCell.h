//
//  ReminderTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <UIKit/UIKit.h>

@class  ReminderTableViewCell;

@protocol ReminderTableViewCellDelegate <NSObject>

@end

@interface ReminderTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *   lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *   lblDate;
@property(nonatomic,strong)IBOutlet UILabel *   lblDesc;

@property(nonatomic,strong)IBOutlet UIButton *  btnDelete;
@property(nonatomic,strong)IBOutlet UIButton  *  btnCheckMark;

@property(nonatomic,assign) id<ReminderTableViewCellDelegate>delegate;

+(ReminderTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;


@end
