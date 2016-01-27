//
//  FormDetailTableViewCell.m
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import "FormDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "FormDetailTableViewCell.h"
#import "Feeds.h"

@implementation FormDetailTableViewCell

@synthesize lblUname;
@synthesize lblTagName;
@synthesize lblCompletionTime;
@synthesize lblFormName;
@synthesize lblBadges;
@synthesize delegate;
@synthesize profileImage;

- (void)awakeFromNib {
    // Initialization code
}

-(IBAction)buttonAction:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(ButtonDidClick:)]){
        [self.delegate ButtonDidClick:sender];
    }
}
-(void)setForm:(Feeds *)formD
{
    _form=formD;
    self.profileImage.layer.cornerRadius = floor(self.profileImage.frame.size.width/2);
    self.profileImage.clipsToBounds = YES;
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,_form.formUserImage]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    self.lblUname.text = _form.formUserName;
    self.lblFormName.text = _form.formTitle;
    self.lblTagName.text=_form.formTag;
    self.lblCompletionTime.text=_form.formCompletionTime;
    self.lblBadges.text=_form.formTag;
    
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
