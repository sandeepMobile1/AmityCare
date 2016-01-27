//
//  ContactsCell.m
//  Amity-Care
//
//  Created by Vijay Kumar on 05/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ContactsCell.h"

@implementation ContactsCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.textColor = TEXT_COLOR_GREEN;
        self.textLabel.font = [UIFont fontWithName:appfontName size:15.0];
       
        UIImageView* onlineStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
        onlineStatus.tag = 101;
        self.accessoryView =onlineStatus;
        
              
    }
    return self;
}

#pragma mark- IBActions
-(void)callBtnAction:(UIButton*)sender
{
    if([self.delegate respondsToSelector:@selector(callBtnDidClicked:)]){
        [self.delegate callBtnDidClicked:sender];
    }
}

-(void)msgBtnAction:(UIButton*)sender
{
    if([self.delegate respondsToSelector:@selector(msgBtnDidClicked:)]){
        [self.delegate msgBtnDidClicked:sender];
    }
}

#pragma mark- accessor

-(void)setContact:(ContactD *)contact{

    _contact  = contact;
    
    self.textLabel.text = _contact.userName;

    [self setNeedsDisplay];
    
}
- (void)awakeFromNib
{
    // Initialization code
}
-(void)layoutSubviews
{
    UIImageView* imgVw = (UIImageView*)[self.accessoryView viewWithTag:101];
    NSString* imgStatus = _contact.isOnline?@"online.png":@"offline.png";
    [imgVw setImage:[UIImage imageNamed:imgStatus]];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
