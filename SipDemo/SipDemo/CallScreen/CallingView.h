//
//  CallingView.h
//  Amity-Care
//
//  Created by Vijay Kumar on 22/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentCall.h"
#import <Sinch/Sinch.h>
#import "OfflineMessageInvocation.h"


@protocol CallingViewDelegate <NSObject>

@optional
-(void)muteBtnDidClicked:(id)sender;
-(void)transferCallBtnDidClicked:(id)sender;
-(void)speakerBtnDidClicked:(id)sender;
-(void)contactsBtnDidClicked:(id)sender;
-(void)callEndDidClicked:(id)sender;

@end

@interface CallingView : UIViewController <UIAlertViewDelegate,OfflineMessageInvocationDelegate>
{
    IBOutlet UIView* mainView;
    IBOutlet UIImageView* imgViewPic;
    IBOutlet UILabel *lblUsername;
    IBOutlet UILabel *lblCallStatus;
    
    // Menu
    IBOutlet UIView* menuBtnView;
    IBOutlet UIButton *btnMute;
    IBOutlet UIButton *btnHoldCall;
    IBOutlet UIButton *btnSpeaker;
    IBOutlet UIButton *btnContacts;
    
    // DialerView
    IBOutlet UIView* dialerView;
    IBOutlet UIButton *btnCallEND;
    
    // RecieverView
    IBOutlet UIView* recieverView;
    IBOutlet UIButton *btnRecieveCall;
    IBOutlet UIButton *btnDeclineCall;
    
    id<CallingViewDelegate> _delegate;
    
    BOOL isIncomingCall;
    
    NSTimer *_timer;
    NSString *dtmfCmd;
    
    UIAlertView *offlineAlert;
}
@property (nonatomic, readwrite, strong) id<SINCall> call;

@property(nonatomic, strong)NSString *str_callId;
@property(nonatomic, assign)BOOL end_btb_press;



@property(nonatomic,unsafe_unretained)id<CallingViewDelegate>delegate;
@property(nonatomic,strong)IBOutlet UIImageView* imgViewPic;

@property (nonatomic, retain)  NSString *dtmfCmd;

//- (id)initWithFrame:(CGRect)frame delegate:(id)del;

-(void)setUserImage:(NSString*)url;
-(IBAction)muteBtnAction:(id)sender;
-(IBAction)transferCallAction:(id)sender;
-(IBAction)speakerBtnAction:(id)sender;
-(IBAction)contactsBtnAction:(id)sender;
-(IBAction)callEndBtnAction:(id)sender;

//Reciever


-(IBAction)declineCall:(id)sender;
-(IBAction)answerCall:(id)sender;

-(void)showDialerControls;
-(void)showRecieverControls;

@end



