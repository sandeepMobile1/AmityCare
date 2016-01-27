//
//  ScheduleUserListTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 02/03/15.
//
//

#import "ScheduleUserListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ConfigManager.h"

@implementation ScheduleUserListTableViewCell

@synthesize lblUname;
@synthesize lblIntro;
@synthesize profileImage;
@synthesize delegate;
@synthesize lblClockInTime;

- (void)awakeFromNib {
    // Initialization code
}
-(void)setContact:(ContactD *)contact
{
    _contact = contact;
    
    self.profileImage.layer.cornerRadius = floor(self.profileImage.frame.size.width/2);
    self.profileImage.clipsToBounds = YES;
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,contact.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    self.lblUname.text = _contact.userName;
    self.lblIntro.text = _contact.introduction;
    self.lblClockInTime.text = _contact.clockInTime;

        [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //self.lblUname.font = [UIFont fontWithName:boldfontName size:15.0];
    //self.lblIntro.font = [UIFont fontWithName:appfontName size:11.0f];
    //self.lblClockInTime.font = [UIFont fontWithName:appfontName size:11.0f];

    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
