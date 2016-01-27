//
//  TopNavigationView.h
//  Amity-Care
//
//  Created by Vijay Kumar on 31/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopNavigationViewDelegate <NSObject>
@optional
-(void)leftBarButtonDidClicked:(id)sender;
-(void)rightBarButtonDidClicked:(id)sender;
@end

@interface TopNavigationView : UIView
{
    id<TopNavigationViewDelegate>__unsafe_unretained delegate;
}

@property(nonatomic,retain)IBOutlet UIButton *leftBarButton;
@property(nonatomic,retain)IBOutlet UIButton *rightBarButton;

@property(nonatomic,retain)IBOutlet UIButton *pencilBtn;
@property(nonatomic,retain)IBOutlet UIButton *searchBtn;
@property(nonatomic,retain)IBOutlet UIButton *feedBtn;

@property(nonatomic,retain)IBOutlet UILabel *lblTitle;

@property(nonatomic,retain) UIView *view;

@property(nonatomic,unsafe_unretained)id<TopNavigationViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withRef:(id)ref;

-(IBAction)leftBarButtonPressed:(id)sender;
-(IBAction)rightBarButtonPressed:(id)sender;


@end
