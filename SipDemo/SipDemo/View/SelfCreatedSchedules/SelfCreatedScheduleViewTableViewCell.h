//
//  SelfCreatedScheduleViewTableViewCell.h
//  Amity-Care
//
//  Created by Admin on 18/03/15.
//
//

#import <UIKit/UIKit.h>

@class  SelfCreatedScheduleViewTableViewCell;

@protocol SelfCreatedScheduleViewTableViewCellDelegate <NSObject>

@end

@interface SelfCreatedScheduleViewTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *   lblName;
@property(nonatomic,strong)IBOutlet UILabel *   lblCreated;
@property(nonatomic,strong)IBOutlet UILabel *   lblStartWeek;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndWeek;
@property(nonatomic,strong)IBOutlet UIButton *  btnDelete;

@property(nonatomic,assign) id<SelfCreatedScheduleViewTableViewCellDelegate>delegate;

+(SelfCreatedScheduleViewTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

@end
