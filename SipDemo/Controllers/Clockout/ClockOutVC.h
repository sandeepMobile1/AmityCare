//
//  ClockOutVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 09/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"

@class ClockOutVC;

@protocol ClockOutVCDelegate

-(void)ClockOutVCDidFinish:(NSDictionary*)dic;
-(void)ClockOutVCDidCancel:(NSDictionary*)dic;

@end

@interface ClockOutVC : UIViewController
{
    IBOutlet UIView *drawingView;
    IBOutlet UIButton* btnClear, *btnSubmit;
    IBOutlet UILabel* lblSignature;
    
    NSTimer* clockOutTimer;
    
    IBOutlet UILabel *lblTimer;
    
    int timerCounter;
}
@property (nonatomic,retain) SmoothLineView * canvas;
@property(unsafe_unretained) NSObject<ClockOutVCDelegate> *delegate;

-(IBAction)submitBtnAction:(id)sender;
-(IBAction)clearBtnAction:(id)sender;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnDoneAction:(id)sender;

-(void)stopTimer;
-(void)startTimer;
-(void)updateTimer;

@end
