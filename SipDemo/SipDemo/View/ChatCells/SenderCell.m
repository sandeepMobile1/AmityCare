//
//  SenderCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "SenderCell.h"

@implementation SenderCell

#define MAX_WIDTH  292
#define MAX_HEIGHT 9999

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

-(CGSize)constrainedWidth:(NSString*)string label:(UILabel*)label
{
    CGSize constainedSize;
    
    if (IS_DEVICE_IPAD) {
        
        constainedSize= CGSizeMake(MAX_WIDTH, MAX_HEIGHT);
        
    }
    else
    {
        constainedSize= CGSizeMake(242, MAX_HEIGHT);
        
    }
    //CGSize expectedSize = [string sizeWithFont:[UIFont fontWithName:appfontName size:14] constrainedToSize:constainedSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect textRect = [string boundingRectWithSize:constainedSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:14]}
                                                          context:nil];
    
    CGSize expectedSize = textRect.size;
    
    return expectedSize;
}

-(void)setMessage:(MessageD *)message
{
    _message = message;
    lblUsername.text = _message.sender_uname;
    lblTime.text = _message.msg_display_time;
    lblMessage.text = _message.msg_text;
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [lblUsername setFont: [UIFont fontWithName:appfontName size:14.0]];
    [lblTime setFont: [UIFont fontWithName:appfontName size:11.0]];
    [lblMessage setFont:[UIFont fontWithName:appfontName size:14.0]];
    
    
    if (IS_DEVICE_IPAD) {
        
        CGSize namesize = CGSizeMake(70, 21);//[self constrainedWidth:_message.sender_uname label:lblUsername];
        CGSize msgSize = [self constrainedWidth:_message.msg_text label:lblMessage];
        
        float unameWidth = namesize.width ;
        float msgWidth = msgSize.width;
        
        _width = (msgWidth>=150) ? msgWidth: 150;
        
        CGRect frame = imgChatBox.frame;
        frame.size.width = _width+15;
        frame.size.height = 26+msgSize.height+10;
        [imgChatBox setFrame:frame];
        [imgChatBox setImage:[[imgChatBox image] stretchableImageWithLeftCapWidth:13 topCapHeight:21]];
        
        
        frame = mainView.frame;
        frame.size = imgChatBox.frame.size;
        [mainView setFrame:frame];
        
        frame = lblUsername.frame;
        frame.size.width = unameWidth;
        [lblUsername setFrame: frame];
        
        frame = lblTime.frame;
        frame.origin.x  = _width - (lblTime.frame.size.width+5 );
        frame.size.width = 75;
        [lblTime setFrame:frame];
        
        lblMessage.numberOfLines= ceil(msgWidth/lblMessage.font.pointSize);
        frame = lblMessage.frame;
        frame.size = msgSize;
        [lblMessage setFrame: frame];

    }
    else
    {
       // CGSize namesize = CGSizeMake(70, 21);
        
        CGSize msgSize = [self constrainedWidth:_message.msg_text label:lblMessage];
        
        //float unameWidth = namesize.width ;
        float msgWidth = msgSize.width;
        
        _width = (msgWidth>=150) ? msgWidth: 150;
        
        CGRect frame = imgChatBox.frame;
       // frame.size.width = _width+15;
        frame.size.width = 260;
        frame.size.height = 26+msgSize.height+10;
        [imgChatBox setFrame:frame];
        [imgChatBox setImage:[[imgChatBox image] stretchableImageWithLeftCapWidth:13 topCapHeight:21]];
        
        
        frame = mainView.frame;
        frame.size = imgChatBox.frame.size;
        [mainView setFrame:frame];
        
        /*frame = lblUsername.frame;
        frame.size.width = unameWidth;
        [lblUsername setFrame: frame];
        
        frame = lblTime.frame;
        frame.origin.x  = _width - (lblTime.frame.size.width+5 );
        frame.size.width = 75;
        [lblTime setFrame:frame];*/
        
        lblMessage.numberOfLines= ceil(msgWidth/lblMessage.font.pointSize);
        frame = lblMessage.frame;
        frame.size = msgSize;
        [lblMessage setFrame: frame];

    }
    }

+(CGFloat)senderCellHeight:(MessageD *)message
{
    CGSize sizeToFit;
    
    if (IS_DEVICE_IPAD) {
        
       // sizeToFit = [message.msg_text sizeWithFont:[UIFont fontWithName:appfontName size:14.0] constrainedToSize:CGSizeMake(277.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [message.msg_text boundingRectWithSize:CGSizeMake(277.0f, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:14]}
                                               context:nil];
        
        sizeToFit = textRect.size;
        
    }
    else
    {
       // sizeToFit = [message.msg_text sizeWithFont:[UIFont fontWithName:appfontName size:14.0] constrainedToSize:CGSizeMake(242.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [message.msg_text boundingRectWithSize:CGSizeMake(242.0f, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:14.0]}
                                               context:nil];
        
        sizeToFit = textRect.size;

        
    }
    
    
    NSLog(@"cell height =%f",fmaxf(52.0f, (float)sizeToFit.height + 26+10));
    return fmaxf(57.0f, (float)sizeToFit.height + 40+10+5);
}

@end
