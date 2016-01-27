//
//  CallingView.m
//  Amity-Care
//
//  Created by Vijay Kumar on 22/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "CallingView.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
//#import "UIImageView+WebCache.h"
#import "SqliteManager.h"
#import "AmityCareServices.h"
#import "QSStrings.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface CallingView (Private)<CallNotifierInvocationDelegate,SINCallDelegate,SINAudioControllerDelegate>

@end

@implementation CallingView
@synthesize delegate;
@synthesize dtmfCmd;
@synthesize imgViewPic;
@synthesize str_callId;
@synthesize end_btb_press;
typedef void (^CompletionBlock)();

#define ANIMATION_DURATION 0.3

/*
 - (id)initWithFrame:(CGRect)frame delegate:(id)del
 {
 self = [super initWithFrame:frame];
 if (self) {
 
 NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"CallingView" owner:self options:nil];
 self = [arr objectAtIndex:0];
 
 [mainView setAlpha:0.0];
 lblUsername.font = [UIFont fontWithName:appfontName size:30.0];
 lblCallStatus.font = [UIFont fontWithName:appfontName size:18.0];
 self.delegate = del;
 imgViewPic.layer.cornerRadius = 5.0;
 imgViewPic.clipsToBounds = YES;
 [self showCallingView];
 // Initialization code
 }
 return self;
 }
 */

- (id<SINAudioController>)audioController {
    return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] audioController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   // unsigned long int i;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){

    }
    return self;
}

- (void)setCall:(id<SINCall>)call1 {
    _call = call1;
    _call.delegate = self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.call direction] == SINCallDirectionIncoming) {
        
        lblCallStatus.text = @"";
        [self showRecieverControls];
        [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];
    } else {
        lblCallStatus.text = @"calling...";
        [self showDialerControls];
    }
}


#pragma mark - Sounds

- (NSString *)pathForSound:(NSString *)soundName {
    
    NSLog(@"path of audio = %@",[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName]);
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"incoming"
                                                         ofType:@"wav"];
 //   return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName]; bundlePath
    return filePath;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    end_btb_press = FALSE;
    
    NSArray *foo = [[self.call remoteUserId] componentsSeparatedByString: @"_"];
    
    NSString* str_name = [foo objectAtIndex: 1];
    
    NSString *finalString = [str_name stringByReplacingOccurrencesOfString:@"_" withString:@" "];

    lblUsername.text = finalString;
    
    isIncomingCall = FALSE;
    [mainView setAlpha:0.0];
    lblUsername.font = [UIFont fontWithName:appfontName size:30.0];
    lblCallStatus.font = [UIFont fontWithName:appfontName size:18.0];
    imgViewPic.layer.cornerRadius = 5.0;
    imgViewPic.clipsToBounds = YES;
    [self showCallingView];
    
}


- (void)dealloc
{
    NSLog(@"Calling DEALLLOC:");
    
    mainView = nil;
    dialerView =nil;
    recieverView = nil ;
    
    btnCallEND = nil;
    btnContacts = nil;
    btnDeclineCall = nil;
    btnMute =nil ;
    btnRecieveCall = nil;
    btnSpeaker =nil;
    btnSpeaker =nil;
    
    [super dealloc];
}

#pragma mark-

- (void)setSpeakerPhoneEnabled:(BOOL)enable
{
    if(enable){
        [[self audioController] enableSpeaker];
    }
    else{
        [[self audioController] disableSpeaker];
    }
    
}

- (void)setMute:(BOOL)enable
{
    if(enable){
        [[self audioController] mute];
    }
    else{
        [[self audioController] unmute];
    }
    /* FIXME maybe I must look for conf_port */

}

- (void)setHoldEnabled: (BOOL)enable
{
    ///[self.call sendDTMF:@""];
    
}
#pragma mark---------


-(IBAction)transferCallAction:(id)sender
{
    
}

#pragma mark---------
-(void)showCallingView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [mainView setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)performActionWithCompletion:(CompletionBlock)completionBlock{
    [self hideCallingView];
    completionBlock();
}


-(void)hideCallingView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [mainView setAlpha:0.0];
    [UIView commitAnimations];
}

#pragma mark- UserImage

-(void)setUserImage:(NSString*)url
{
    @try {
       // [imgViewPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,url]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    }
    @catch (NSException *exception) {
        NSLog(@"NSException Settting User Image :: %@ ",[exception debugDescription]);
    }
}

#pragma mark- IBActions

-(IBAction)muteBtnAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    [self setMute:sender.selected];
    
    //    if([self.delegate respondsToSelector:@selector(muteBtnDidClicked:)]){
    //        [self.delegate muteBtnDidClicked:sender];
    //    }
}

-(IBAction)holdBtnAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    [self setHoldEnabled:sender.selected];
    
}
-(IBAction)speakerBtnAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    [self setSpeakerPhoneEnabled:sender.selected];
    
}

-(IBAction)contactsBtnAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

-(IBAction)callEndBtnAction:(id)sender
{
    end_btb_press = TRUE;
    
    [self.call hangup];
    [self dismiss];
}

- (void)dismiss {

    
    [self.view removeFromSuperview];
}

-(IBAction)declineCall:(id)sender
{
    [self.call hangup];
    [self dismiss];
}

-(IBAction)answerCall:(id)sender
{
    [[self audioController] stopPlayingSoundFile];
    [self.call answer];
}
- (void)onDurationTimer:(NSTimer *)unused {
    NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
    [self setDuration:duration];
}

#pragma mark - SINCallDelegate


- (void)callDidProgress:(id<SINCall>)call {
    lblCallStatus.text = @"Ringing...";
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}

- (void)setDuration:(NSInteger)seconds {
    lblCallStatus.text = [NSString stringWithFormat:@"%02d:%02d", (int)(seconds / 60), (int)(seconds % 60)];
}

- (void)internal_updateDuration:(NSTimer *)timer {
    SEL selector = NSSelectorFromString([timer userInfo]);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:timer];
#pragma clang diagnostic pop
    }
}


- (void)callDidEstablish:(id<SINCall>)call {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                          target:self
                                                        selector:@selector(onDurationTimer:)
                                                        userInfo:_timer
                                             repeats:YES];
    
    
    [self showDialerControls];
    
    [[self audioController] stopPlayingSoundFile];
}

- (void)callDidEnd:(id<SINCall>)call {
    
    if(!end_btb_press){
        if ([self.call direction] == SINCallDirectionOutgoing) {
            NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
            //    NSLog(@"duration = %ld",duration);
            if(duration < 1){
              
               // UIAlertView *show_alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Enable to pickup call." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
               // [show_alert show];
                
                
                offlineAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:[NSString stringWithFormat:@"%@ is busy",sharedAppDelegate.strCallUserName]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Continue", nil];
                [offlineAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                UITextField * alertTextField =nil;
                alertTextField=[offlineAlert textFieldAtIndex:0];
                alertTextField.keyboardType = UIKeyboardTypeDefault;
                [offlineAlert show];

            }
            
        }
    }
    else{
        end_btb_press = FALSE;
    }
    
    [self dismiss];
    [[self audioController] stopPlayingSoundFile];
    [self stopCallDurationTimer];
}

- (void)stopCallDurationTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark----
-(void)showDialerControls
{
    NSLog(@"showDialerControls:");
    [menuBtnView setHidden:NO];
    [dialerView setHidden:NO];
    [recieverView setHidden:YES];
}
-(void)showRecieverControls
{
    NSLog(@"showRecieverControls:");
    [menuBtnView setHidden:YES];
    [dialerView setHidden:YES];
    [recieverView setHidden:NO];
    //[self shakeView];
}

-(void)shakeView {
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:50];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(btnRecieveCall.center.x - 5,btnRecieveCall.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(btnRecieveCall.center.x + 5, btnRecieveCall.center.y)]];
    [btnRecieveCall.layer addAnimation:shake forKey:@"position"];
}
#pragma mark- UIALERTVIEW

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView==offlineAlert) {
        
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1 )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==offlineAlert) {
        
        if (buttonIndex==1) {
            
            NSString *inputText = [[offlineAlert textFieldAtIndex:0] text];
            
            if ([inputText length]>0) {
                
                if([ConfigManager isInternetAvailable]){
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    NSString *encodedString=[QSStrings encodeBase64WithString:inputText];
                    
                    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                    [dic setObject:sharedAppDelegate.strCallUserId forKey:@"member_id"];
                    [dic setObject:encodedString forKey:@"message"];
                    [dic setObject:@"call" forKey:@"type"];

                    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
                    [[AmityCareServices sharedService] OfflineMessageInvocation:dic delegate:self];
                    
                    
                }
                else{
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
            
        }
    }
 
    
}

#pragma mark- Invocation

-(void)callNotifierInvocationDidFinish:(CallNotifierInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"backgroundClockInInvocationDidFinish %@",dict);
}
-(void)OfflineMessageInvocationDidFinish:(OfflineMessageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        NSString* strMessage = [response valueForKey:@"message"];
        
        if([strSuccess rangeOfString:@"true"].length>0){
            
            [ConfigManager showAlertMessage:nil Message:strMessage];
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
    
}

@end
