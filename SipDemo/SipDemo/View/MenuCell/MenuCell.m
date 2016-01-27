//
//  MenuCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 02/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "MenuCell.h"
#import "AppDelegate.h"

@implementation MenuCell

@synthesize cellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
    }
    return self;
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

-(void)configureCell:(NSString*)image title:(NSString*)title setSelected:(BOOL)selected{

    _isSelected = selected;
    
    self.textLabel.text = title;
    UIImage *_image = [UIImage imageNamed:image];
    imageSize = _image.size;
    [self.imageView setImage:_image];
    
    
    if(cellIndex==0 && (sharedAppDelegate.unreadTagCount>0 && [title isEqualToString:@"Tags"]))
    {
        UIImageView * imgBubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert.png"]];
        [imgBubbleView setFrame:CGRectMake(185, 12.0, 25, 18)];
        [self.contentView addSubview:imgBubbleView];
        
        UILabel* lblUnreadCount = [[UILabel alloc] initWithFrame:imgBubbleView.frame];
        lblUnreadCount.textColor = [UIColor whiteColor];
        lblUnreadCount.backgroundColor = [UIColor clearColor];
        lblUnreadCount.textAlignment = NSTextAlignmentCenter;
        lblUnreadCount.font = [UIFont fontWithName:boldfontName size:13.0f];
        lblUnreadCount.text = [NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadTagCount];
        [self.contentView addSubview:lblUnreadCount];
    }

    
    if(cellIndex==5 && (sharedAppDelegate.unreadNotifications>0 && [title isEqualToString:@"Notifications"]))
    {
        UIImageView * imgBubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert.png"]];
        [imgBubbleView setFrame:CGRectMake(185, 12.0, 25, 18)];
        [self.contentView addSubview:imgBubbleView];
        
        UILabel* lblUnreadCount = [[UILabel alloc] initWithFrame:imgBubbleView.frame];
        lblUnreadCount.textColor = [UIColor whiteColor];
        lblUnreadCount.backgroundColor = [UIColor clearColor];
        lblUnreadCount.textAlignment = NSTextAlignmentCenter;
        lblUnreadCount.font = [UIFont fontWithName:boldfontName size:13.0f];
        lblUnreadCount.text = [NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadNotifications];
        [self.contentView addSubview:lblUnreadCount];
    }
    
    if(cellIndex==2 && (sharedAppDelegate.unreadMsgCount>0 && [title isEqualToString:@"Messages"]))
    {
        UIImageView * imgBubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert.png"]];
        [imgBubbleView setFrame:CGRectMake(185, 12.0, 25, 18)];
        [self.contentView addSubview:imgBubbleView];
        
        UILabel* lblUnreadCount = [[UILabel alloc] initWithFrame:imgBubbleView.frame];
        lblUnreadCount.textColor = [UIColor whiteColor];
        lblUnreadCount.backgroundColor = [UIColor clearColor];
        lblUnreadCount.textAlignment = NSTextAlignmentCenter;
        lblUnreadCount.font = [UIFont fontWithName:boldfontName size:13.0f];
        lblUnreadCount.text = [NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadMsgCount];
        [self.contentView addSubview:lblUnreadCount];
    }
    
    if(cellIndex==4 && (sharedAppDelegate.unreadContactCount>0 && [title isEqualToString:@"Contacts"]))
    {
        UIImageView * imgBubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert.png"]];
        [imgBubbleView setFrame:CGRectMake(185, 12.0, 25, 18)];
        [self.contentView addSubview:imgBubbleView];
        
        UILabel* lblUnreadCount = [[UILabel alloc] initWithFrame:imgBubbleView.frame];
        lblUnreadCount.textColor = [UIColor whiteColor];
        lblUnreadCount.backgroundColor = [UIColor clearColor];
        lblUnreadCount.textAlignment = NSTextAlignmentCenter;
        lblUnreadCount.font = [UIFont fontWithName:boldfontName size:13.0f];
        lblUnreadCount.text = [NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadContactCount];
        [self.contentView addSubview:lblUnreadCount];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.textLabel.opaque = NO;
    self.textLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.imageView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

    CGRect frame = self.imageView.frame;
    frame.size.width = imageSize.width;
    frame.size.height = imageSize.height;
    self.imageView.frame = frame;
    [self.imageView setCenter:CGPointMake(30, 20)];
    
    self.textLabel.frame = CGRectMake(60.0f, 5.0f, 190.0f, 30.0f);
    self.textLabel.font = AC_FONT_GOTHIC_NORMAL;
    self.textLabel.textColor = [UIColor whiteColor];
    
    if(DEVICE_OS_VERSION_7_0)
    {
        if(_isSelected){
            [self setAlpha:1.0f];
            [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1f]];
        }
        else{
            [self setAlpha:0.5f];
            [self setBackgroundColor:[UIColor clearColor]];
        }
    }
    else
    {
        if(_isSelected){
            [self setAlpha:1.0f];
            [self.contentView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1f]];
        }
        else{
            [self setAlpha:0.5f];
            [self.contentView setBackgroundColor:[UIColor clearColor]];
        }
    }
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

@end
