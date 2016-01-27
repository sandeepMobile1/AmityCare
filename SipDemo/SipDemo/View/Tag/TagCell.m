//
//  TagCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont fontWithName:appfontName size:15.0];
        self.textLabel.textColor = [UIColor colorWithRed:105/255.0 green:114/255.0 blue:13/255.0 alpha:1.0];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        
    }
    return self;
}

-(void)setTagData:(Tags *)tagData
{
    _tagData = tagData;
    self.textLabel.text = _tagData.tagTitle;
    [self setNeedsLayout];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.bounds.size.width - (self.accessoryView.frame.size.width+20), self.textLabel.frame.size.height);
    
    CGRect accessoryViewFrame = self.accessoryView.frame;
    accessoryViewFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(accessoryViewFrame);
    accessoryViewFrame.origin.y=1.0f;
    accessoryViewFrame.size.height= self.bounds.size.height - 2.0f;
    self.accessoryView.frame = accessoryViewFrame;
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
