//
//  StatusCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 09/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "StatusCell.h"


@implementation StatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont fontWithName:appfontName size:13.0];
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setStatusD:(Status *)statusD
{
    _statusD = statusD;
    self.textLabel.text = _statusD.statusDesc;
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    self.textLabel.frame = CGRectMake(10.0f, 0.0f, 290.0f, 0.0);
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.height = fmaxf(39, (float)[[self class] heightForCellWithPost:_statusD]);
    self.textLabel.frame = textLabelFrame;

}

+ (CGFloat)heightForCellWithPost:(Status *)status {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize sizeToFit = [status.statusDesc sizeWithFont:[UIFont fontWithName:appfontName size:13.0] constrainedToSize:CGSizeMake(290.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    NSLog(@"cell height =%f",fmaxf(39, (float)sizeToFit.height));
    return fmaxf(39.0f, (float)sizeToFit.height+10);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
