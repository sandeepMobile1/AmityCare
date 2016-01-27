//
//  AllContactTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import "AllContactTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ConfigManager.h"

@implementation AllContactTableViewCell

@synthesize lblUname;
@synthesize lblClockInTime,lblHourly,lblTagName;
@synthesize profileImage;
@synthesize delegate;
@synthesize lblClockOutTime;
@synthesize btnClockInLocation;
@synthesize btnClockOutLocation;
@synthesize btnEditSchedule;


- (void)awakeFromNib {
    // Initialization code
}
-(IBAction)buttonAction:(id)sender{
    
   /* if([self.delegate respondsToSelector:@selector(ButtonDidClick:)]){
        [self.delegate ButtonDidClick:sender];
    }*/
}
-(void)setPeople:(PeopleData *)people
{
    _people = people;
    
    self.profileImage.layer.cornerRadius = floor(self.profileImage.frame.size.width/2);
    self.profileImage.clipsToBounds = YES;
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,people.userImage]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
   
    self.lblUname.text = _people.userName;
    self.lblTagName.text = _people.userClockInTag;
    self.lblHourly.text=_people.userClockInHour;
    self.lblClockInTime.text=_people.userClockInTime;
    
    if (_people.userClockOutTime==nil || _people.userClockOutTime==(NSString*)[NSNull null] || [_people.userClockOutTime isEqualToString:@""]) {
        
        self.lblClockOutTime.text=_people.userClockOutAddress;

    }
    else
    {
        self.lblClockOutTime.text=_people.userClockOutTime;

    }
    
    
   
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.lblUname.font = [UIFont fontWithName:boldfontName size:15.0];
   // self.lblClockInTime.font = [UIFont fontWithName:appfontName size:11.0f];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
