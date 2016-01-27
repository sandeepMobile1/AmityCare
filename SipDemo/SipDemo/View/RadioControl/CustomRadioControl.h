//
//  CustomRadioControl.h
//  Amity-Care
//
//  Created by Vijay Kumar on 03/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PARTICIPANTS_MOOD_ARRAY [NSArray arrayWithObjects:@"happy",@"sad",@"angry",@"content",@"awake",@"sleep",@"away",@"bored",\
@"chipper",@"confused",@"curious",@"depressed",@"energetic",@"enraged",@"excited",@"exhausted",@"grateful",@"hopeful",@"hungry",@"hot",\
@"cold",@"irritated",@"lazy",@"lonely",@"loved",@"mad",@"moody",@"naughty",@"optimistic",@"pissed off",@"pleased",@"relaxed",@"satisfied",@"shocked",@"tired",@"uncomfortable",@"weird", nil]

@class CustomRadioControl;

@protocol CustomRadioControlDelegate <NSObject>
-(void)radioBtnAction:(CustomRadioControl*)view;
@end


@interface CustomRadioControl : UIView
{
    @public
    IBOutlet UIButton* btnRadio;
    IBOutlet UILabel * lblOptTitle;
    id<CustomRadioControlDelegate>_delegate;
}
@property(nonatomic,strong)  IBOutlet UIButton* btnRadio;
@property(nonatomic,unsafe_unretained)  id<CustomRadioControlDelegate>delegate;

- (id)initWithFrame:(CGRect)frame;
-(void)setOptionTitle:(int)index;
-(IBAction)radioBtnClicked:(id)sender;

@end
