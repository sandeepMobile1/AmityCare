//
//  TopNavigationView.m
//  Amity-Care
//
//  Created by Vijay Kumar on 31/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TopNavigationView.h"

@implementation TopNavigationView
@synthesize delegate;
@synthesize view;
@synthesize lblTitle,leftBarButton,rightBarButton,pencilBtn,searchBtn,feedBtn;

//- (void) awakeFromNib
//{
//    [super awakeFromNib];
//    [self addSubview:self.view];
//}

- (id)initWithFrame:(CGRect)frame withRef:(id)ref
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *array;
        
        if (IS_DEVICE_IPAD) {
            
            if(DEVICE_OS_VERSION_7_0){
                array =[[NSBundle mainBundle] loadNibNamed:@"TopNavigationView" owner:self options:nil];
            }
            else{
                array =[[NSBundle mainBundle] loadNibNamed:@"TopNavigationViewIOs6" owner:self options:nil];
            }

        }
        else
        {
            array =[[NSBundle mainBundle] loadNibNamed:@"TopNavigationView_iphone" owner:self options:nil];

        }
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_list_bg.png"]]];
        self.delegate = ref;
        self.view = [array objectAtIndex:0];
        self.lblTitle.font= AC_FONT_NAV_TITLE_HEADING;
        [self addSubview:self.view];
        
    }
    return self;
}
-(IBAction)leftBarButtonPressed:(id)sender;
{
    NSLog(@"leftBarButtonPressed Clicked");
    if([self.delegate respondsToSelector:@selector(leftBarButtonDidClicked:)]){
        [self.delegate leftBarButtonDidClicked:sender];
    }
}

-(IBAction)rightBarButtonPressed:(id)sender;
{
    NSLog(@"rightBarButtonPressed Clicked");
    if([self.delegate respondsToSelector:@selector(rightBarButtonDidClicked:)]){
        [self.delegate rightBarButtonDidClicked:sender];
    }
}

@end
