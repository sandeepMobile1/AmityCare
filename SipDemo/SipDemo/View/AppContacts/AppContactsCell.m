//
//  TaskCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "AppContactsCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ConfigManager.h"

@implementation AppContactsCell

@synthesize lblUname;
@synthesize lblIntro;
@synthesize btnRequest;
@synthesize profileImage;
@synthesize imgReqSent;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
    }
    return self;
}
-(IBAction)sendRequestAction:(id)sender{

    if([self.delegate respondsToSelector:@selector(sendRequestButtonDidClick:)]){
        [self.delegate sendRequestButtonDidClick:sender];
    }
}
-(void)setContact:(ContactD *)contact
{
    _contact = contact;
    
    self.profileImage.layer.cornerRadius = floor(self.profileImage.frame.size.width/2);
    self.profileImage.clipsToBounds = YES;
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,contact.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    self.lblUname.text = _contact.userName;
    self.lblIntro.text = _contact.introduction;

    if(contact.isConnected){
        [self.btnRequest setHidden:YES];
        [self.imgReqSent setHidden:NO];
    }
    else{
        [self.btnRequest setHidden:NO];
        [self.imgReqSent setHidden:YES];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {

    [super layoutSubviews];

    self.lblUname.font = [UIFont fontWithName:boldfontName size:15.0];
    self.lblIntro.font = [UIFont fontWithName:appfontName size:11.0f];
    self.btnRequest.titleLabel.font = [UIFont fontWithName:appfontName size:11.0f];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
