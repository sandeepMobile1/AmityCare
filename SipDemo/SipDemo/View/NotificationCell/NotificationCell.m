//
//  NotificationCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 27/11/14.
//
//

#import "NotificationCell.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
    }
    return self;
}

-(void)setNotificationData:(NotificationD *)notificationData
{
    _notificationData = notificationData;
    self.textLabel.text = _notificationData.ntext;
    self.detailTextLabel.text=_notificationData.createdTime;
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_DEVICE_IPAD) {
        
        self.textLabel.font = [UIFont fontWithName:appfontName size:13.0];
        self.detailTextLabel.font = [UIFont fontWithName:appfontName size:11.0];

    }
    else{
        
        self.textLabel.font = [UIFont fontWithName:appfontName size:11.0];
        self.detailTextLabel.font = [UIFont fontWithName:appfontName size:10.0];
    }
    self.textLabel.textColor = [UIColor whiteColor];
    
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    self.detailTextLabel.textAlignment=NSTextAlignmentRight;
  
    if (!IS_DEVICE_IPAD) {
        
        self.textLabel.numberOfLines=0;
        self.textLabel.frame = CGRectMake(5.0f, 15.0f, 310, 40.0f);
        self.detailTextLabel.frame = CGRectMake(150.0f, 2.0f, 140.0f, 13.0f);

    }
    else
    {
        self.textLabel.numberOfLines=0;
        self.textLabel.frame = CGRectMake(10.0f, 15.0f, 330, 40.0f);
        self.detailTextLabel.frame = CGRectMake(190.0f, 2.0f, 150.0f, 13.0f);

    }
   

    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
