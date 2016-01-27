//
//  ScheduleUserListTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 02/03/15.
//
//

#import <UIKit/UIKit.h>
#import "ContactD.h"

@protocol ScheduleUserListTableViewCellDelegate <NSObject>

@end

@interface ScheduleUserListTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *   lblUname;
@property(nonatomic,strong)IBOutlet UILabel *   lblIntro;
@property(nonatomic,strong)IBOutlet UIImageView*profileImage;
@property(nonatomic,strong)IBOutlet UILabel *   lblClockInTime;

@property(nonatomic,strong)ContactD *contact;
@property(nonatomic,assign) id<ScheduleUserListTableViewCellDelegate>delegate;

@end
