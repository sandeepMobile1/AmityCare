//
//  AudioRecieverCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import "AudioRecieverCell.h"

@implementation AudioRecieverCell

@synthesize width,audioSlider,btnPlay,cellDelegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessage:(MessageD *)message
{
    _message = message;
    lblUsername.text =_message.sender_uname;
    lblTime.text = _message.msg_display_time;
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [lblUsername setFont:[UIFont fontWithName:appfontName size:14.0]];
    [lblTime setFont:[UIFont fontWithName:appfontName size:11.0]];
    [imgChatBox setImage:[[imgChatBox image] stretchableImageWithLeftCapWidth:13 topCapHeight:21]];
    
}

+(CGFloat)recieverCellHeight:(MessageD*)message
{
    return 80;
    
}

-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatRecieverAudioButtonClick:)])
    {
        [self.cellDelegate ChatRecieverAudioButtonClick:self];
    }
}

-(IBAction)sliderMoved:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatRecieverAudioSliderMovedClick:)])
    {
        [self.cellDelegate ChatRecieverAudioSliderMovedClick:self];
    }
}
@end
