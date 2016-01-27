//
//  ImageSenderCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import "ImageSenderCell.h"
#import "UIImageExtras.h"
#import "UIImageView+WebCache.h"
#import "ConfigManager.h"

@implementation ImageSenderCell

@synthesize width,btnImage,cellDelegate,imgView;

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
    lblUsername.text = @"Me:";//_message.sender_uname;
    lblTime.text = _message.msg_display_time;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largeThumbChatImageURL,_message.fileName]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];

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
    return 200;
    
}
-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatSenderImageButtonClick:)])
    {
        [self.cellDelegate ChatSenderImageButtonClick:self];
    }
}

@end
