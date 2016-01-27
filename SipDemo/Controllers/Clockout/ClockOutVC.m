//
//  ClockOutVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 09/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ClockOutVC.h"
#import "ClockoutInvocation.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "UserTagsVC.h"

@interface ClockOutVC ()<ClockoutInvocationDelegate,UIAlertViewDelegate>

@end

@implementation ClockOutVC
@synthesize canvas,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lblTimer.text=@"";
   
    
    [self startTimer];
    
    self.canvas =[[SmoothLineView alloc] initWithFrame:drawingView.frame];
    sharedAppDelegate.strCheckDrawLine=@"YES";
    sharedAppDelegate.checkBlankSmoothLineView=@"YES";
    [self.view addSubview:self.canvas];
    
    [self setLayouts];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];

    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
}
-(void)startTimer
{
    timerCounter=60;
    
    if(![clockOutTimer isValid]){
        clockOutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:clockOutTimer forMode:NSRunLoopCommonModes];
    }
    [clockOutTimer fire];
    
}
-(void)stopTimer
{
    [clockOutTimer invalidate];
    clockOutTimer = nil;
    
    checkClockOutTimer=@"clockOut";
    
    if ([self.delegate respondsToSelector:@selector(ClockOutVCDidCancel:)]) {
        
        [self.delegate ClockOutVCDidCancel:nil];
        
    }
    
    // [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDoneAction:(id)sender
{
    [clockOutTimer invalidate];
    clockOutTimer = nil;
    
    checkClockOutTimer=@"clockOut";
    
    if ([self.delegate respondsToSelector:@selector(ClockOutVCDidCancel:)]) {
        
        [self.delegate ClockOutVCDidCancel:nil];
        
    }
    
}
-(void)updateTimer
{
    if (timerCounter<=0) {
        
        [lblTimer setText:[NSString stringWithFormat:@"%d",timerCounter]];
        
        [self stopTimer];
        
    }
    else
    {
        [lblTimer setText:[NSString stringWithFormat:@"%d",timerCounter]];
    }
    
    timerCounter=timerCounter-1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)dealloc{
    NSLog(@"!!!!!!! %@ dealloc ",[self class]);
    btnClear = nil;
    btnSubmit = nil;
    lblSignature= nil;
    self.canvas = nil;
    
    [super dealloc];
}*/
#pragma mark- NavigationButton Actions
-(void)leftBarButtonDidClicked:(id)sender
{
    // [[[UIAlertView alloc] initWithTitle:@"Please submit your signature." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitBtnAction:(id)sender
{
    if ([sharedAppDelegate.checkBlankSmoothLineView isEqualToString:@"NO"]) {
        
        [self performSelectorOnMainThread:@selector(clockoutView) withObject:nil waitUntilDone:YES];
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Please submit your signature." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    //    NSLog(@" submitBtnAction =>>> %d",[self.canvas empty]);
    //    return;
    
}
-(void)clockoutView
{
    UIGraphicsBeginImageContext(self.canvas.bounds.size);
    
    [self.canvas.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSLog(@"image size =%f %f",image.size.height,image.size.width);
    
    if([ConfigManager isInternetAvailable]){
        
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Signature" forKey:@"title"];
        [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
        [dict setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];
        
        [dict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tags"];
        [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
        [dict setObject:@"attachment" forKey:@"attachment_key"];
        [dict setObject:@"clock_out" forKey:@"request_path"];
        [dict setObject:@"image.jpg" forKey:@"filename"];
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
        
        [[AmityCareServices sharedService] clockOutInvocation:dict signature:imageData delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)clearBtnAction:(id)sender
{
    [self.canvas clear];
}
-(IBAction)btnBackAction:(id)sender
{
    [clockOutTimer invalidate];
    clockOutTimer = nil;
    
    checkClockOutTimer=@"clockout";
    [self.navigationController popViewControllerAnimated:YES];
    
    //  [[[UIAlertView alloc] initWithTitle:@"Please submit your signature." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


-(void)setLayouts
{
    drawingView.layer.borderWidth = 1.0;
    drawingView.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.7] CGColor];
    drawingView.clipsToBounds = YES;
    
    lblSignature.font = [UIFont fontWithName:appfontName size:15.0];
    btnClear.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:20.0];
    btnSubmit.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:20.0];
}

#pragma mark- UIAlertView
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DOC_UPDATED_SUCCESSFULLY){
        
        
        //        [self.navigationController popViewControllerAnimated:YES];
        
        checkClockOutTimer=@"";
        
        [self stopTimer];
        
        id controller = [self.navigationController viewControllers];
        
        for (id temp  in controller) {
            if([temp isKindOfClass:[UserTagsVC class]])
            {
                [self.navigationController popToViewController:temp animated:YES];
                break;
            }
        }
    }
}

#pragma mark- Invocation
-(void)clockoutInvocationDidFinish:(ClockoutInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"clockoutInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                /* if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                 
                 [sharedAppDelegate invalidateRecordingTimers];
                 
                 }*/
                
                
                sharedAppDelegate.userObj.clockInTagId=@"";
                sharedAppDelegate.userObj.clockInTagTitle=@"";
                
                if (IS_DEVICE_IPAD) {
                    
                    if ([self.delegate respondsToSelector:@selector(ClockOutVCDidFinish:)]) {
                        
                        [self.delegate ClockOutVCDidFinish:dict];
                        
                    }
                }
                else
                {
                    
                    checkClockOutTimer=@"clockout";
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
                /* id controller = [self.navigationController viewControllers];
                 
                 for (id temp  in controller) {
                 if([temp isKindOfClass:[UserTagsVC class]])
                 {
                 
                 if (IS_DEVICE_IPAD) {
                 
                 if ([self.delegate respondsToSelector:@selector(ClockOutVCDidFinish:)]) {
                 
                 [self.delegate ClockOutVCDidFinish:dict];
                 
                 }
                 }
                 else
                 {
                 
                 checkClockOutTimer=@"clockout";
                 [self.navigationController popToViewController:temp animated:YES];
                 
                 }
                 
                 break;
                 }
                 }*/
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                
                if (IS_DEVICE_IPAD) {
                    
                    checkClockOutTimer=@"clockOut";
                    
                    if ([self.delegate respondsToSelector:@selector(ClockOutVCDidCancel:)]) {
                        
                        [self.delegate ClockOutVCDidCancel:nil];
                        
                    }
                }
                else
                {
                    checkClockOutTimer=@"clockOut";
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}

@end
