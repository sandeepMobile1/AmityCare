//
//  MessageListCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "MessageListCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ConfigManager.h"
#import "AppDelegate.h"


@implementation MessageListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessage:(MessageD *)message
{
    _message = message;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,_message.sender_image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    lblUserName.text = _message.sender_uname;
    
    lblDateTime.text = _message.msg_display_time;
    
    if ([message.fileType isEqualToString:@"text"])
        lblMessage.text = _message.msg_text;
    else
        lblMessage.text = @"pdf";
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 675, 670)];
            
        }
    }

    //imgView.frame = CGRectMake(5, 5, 50, 50);
    imgView.layer.cornerRadius = floor(imgView.frame.size.width/2);
    imgView.clipsToBounds = YES;

    lblUserName.font= [UIFont fontWithName:boldfontName size:15.0f];
    lblMessage.font= [UIFont fontWithName:appfontName size:12.0f];
    lblDateTime.font= [UIFont fontWithName:appfontName size:12.0f];
    
    if(!_message.isRead){
        [self setBackgroundColor:[UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:0.05]];
    }
    else{
        [self setBackgroundColor:[UIColor clearColor]];
    }
    

    
    //[self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

@end
