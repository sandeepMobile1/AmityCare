//
//  CustomRadioControl.m
//  Amity-Care
//
//  Created by Vijay Kumar on 03/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "CustomRadioControl.h"

@implementation CustomRadioControl
@synthesize delegate;
@synthesize btnRadio;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"CustomRadioControl" owner:self options:nil];
        self = [arr objectAtIndex:0];
    }
    return self;
}

#pragma mark- IBAction

-(IBAction)radioBtnClicked:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(radioBtnAction:)]){
        [self.delegate radioBtnAction:self];
    }
}

-(void)setOptionTitle:(int)index
{
    lblOptTitle.text = [[PARTICIPANTS_MOOD_ARRAY objectAtIndex:index] capitalizedString];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
