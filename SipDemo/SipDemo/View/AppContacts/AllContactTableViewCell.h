//
//  AllContactTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import <UIKit/UIKit.h>
#import "PeopleData.h"

@protocol AllContactTableViewCellDelegate <NSObject>

//-(void)ButtonDidClick:(UIButton*)sender;


@end

@interface AllContactTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *   lblUname;
@property(nonatomic,strong)IBOutlet UILabel *   lblTagName;
@property(nonatomic,strong)IBOutlet UILabel *   lblHourly;
@property(nonatomic,strong)IBOutlet UILabel *   lblClockInTime;
@property(nonatomic,strong)IBOutlet UILabel *   lblClockOutTime;
@property(nonatomic,strong)IBOutlet UIButton *   btnClockInLocation;
@property(nonatomic,strong)IBOutlet UIButton *   btnClockOutLocation;
@property(nonatomic,strong)IBOutlet UIButton *   btnEditSchedule;


@property(nonatomic,strong)IBOutlet UIImageView*profileImage;

@property(nonatomic,strong)PeopleData *people;
@property(nonatomic,assign) id<AllContactTableViewCellDelegate>delegate;

-(IBAction)buttonAction:(id)sender;

@end
