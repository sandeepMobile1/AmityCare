//
//  MailDescCell.m
//  VoipApp
//
//  Created by Arun Goyal on 15/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MailDescCell.h"

@implementation MailDescCell

@synthesize lblHeading,lblValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 25)];
        [self.lblHeading setBackgroundColor:[UIColor clearColor]];
        self.lblHeading.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        self.lblHeading.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.lblHeading];
        
        if (IS_DEVICE_IPAD) {
            
            self.lblValue = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 420, 25)];

        }
        else
        {
            self.lblValue = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 250, 25)];

        }
        [self.lblValue setBackgroundColor:[UIColor clearColor]];
        self.lblValue.font = [UIFont boldSystemFontOfSize:15.0f];
        self.lblValue.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        [self.contentView addSubview:self.lblValue];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
