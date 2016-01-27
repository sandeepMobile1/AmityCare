//
//  TaskCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor colorWithRed:105/255.0 green:114/255.0 blue:13/255.0 alpha:1.0];
        self.textLabel.font = [UIFont fontWithName:boldfontName size:15.0];
        
        self.detailTextLabel.font = [UIFont fontWithName:appfontName size:11.0f];
        self.detailTextLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        self.detailTextLabel.numberOfLines = 2;
        
        UIImageView *imagv = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"arrow"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:14.0]];
        imagv.tag=101;
        self.accessoryView = imagv;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
     
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setTask:(Task *)taskObj
{
    _task = taskObj;
    self.textLabel.text = _task.taskTitle;
    self.detailTextLabel.text = _task.taskDesc;
    [self setNeedsLayout];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    if (IS_DEVICE_IPAD) {
       
        self.textLabel.frame = CGRectMake(10.0f, 0.0f, 485.0f, 21.0f);
        self.detailTextLabel.frame = CGRectMake(10.0f, 21.0f, 485.0f, 42.0f);
    }
    else
    {
        self.textLabel.frame = CGRectMake(10.0f, 0.0f, 300.0f, 21.0f);
        self.detailTextLabel.frame = CGRectMake(10.0f, 21.0f, 300.0f, 42.0f);
    }
   
    
    CGRect accessoryViewFrame = self.accessoryView.frame;
    accessoryViewFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(accessoryViewFrame);
    accessoryViewFrame.origin.y= 1.0f;
    accessoryViewFrame.size.height = self.bounds.size.height-2.0f;
    self.accessoryView.frame = accessoryViewFrame;
    
    UIImageView* imagev = (UIImageView*)[self.accessoryView viewWithTag:101];
    [imagev setImage:[imagev.image stretchableImageWithLeftCapWidth:2 topCapHeight:0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
