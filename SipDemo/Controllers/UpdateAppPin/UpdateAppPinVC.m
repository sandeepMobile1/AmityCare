//
//  UpdateAppPinVC.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 19/09/14.
//
//

#import "UpdateAppPinVC.h"
#import "MFSideMenu.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"


@interface UpdateAppPinVC ()

@end

@implementation UpdateAppPinVC

@synthesize pinNewTxtFld;

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
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationController.navigationBarHidden = YES;
    
  
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    // [self.view addSubview:navigation];
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
- (IBAction)changePinPressed:(id)sender
{
    [self.view endEditing:YES];
    
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:pinNewTxtFld.text];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    
    if([ConfigManager isInternetAvailable])
    {
        if([pinNewTxtFld.text length]==0){
            [ConfigManager showAlertMessage:nil Message:@"Please enter pin"];
            return;
        }
        else if ([pinNewTxtFld.text length]<=3){
            [ConfigManager showAlertMessage:nil Message:@"Please enter 4 digit pin"];
            return;
        }
        else if(!isValid)
        {
            [ConfigManager showAlertMessage:nil Message:@"Please enter only numeric digit"];
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dict setObject:pinNewTxtFld.text forKey:@"appPin"];
            
            
            [DSBezelActivityView newActivityViewForView:self.view withLabel:LOADING_VIEW_DEFAULT_HEADING width:200];
            
            AmityCareServices *service = [[AmityCareServices alloc] init];
            [service updatePinInvocation:dict delegate:self];
        }
        
        
    }else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}
#pragma mark
#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (resultStr.length > 4)
    {
        return NO;
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
}

#pragma mark
#pragma mark - Invocation

- (void)updateAppPinInvocationDidFinish:(UpdateAppPinInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString* strSuccess = [response valueForKey:@"success"];
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    sharedAppDelegate.userObj.appPin = pinNewTxtFld.text;
                    [standardUserDefault synchronize];
                    
                    pinNewTxtFld.text = @"";
                    
                    NSLog(@"Pin %@",sharedAppDelegate.userObj.appPin);
                    
                    
                    ACAlertView* alertView = [ConfigManager alertView:nil message:@"Pin has been updated Successfully" del:self];
                    alertView.alertTag=AC_ALERTVIEW_PROFIE_UPDATED;
                    [alertView show];
                    
                }
                else if([strSuccess rangeOfString:@"false"].length>0)
                {
                    
                    [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
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
#pragma mark- UIALERTVIEW
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_PROFIE_UPDATED)
    {
        [self.view removeFromSuperview];
        //[[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_PROFILE_UPDATED_SUCCESSFULLY object:nil];
    }
}
#pragma mark orientation delegates

- (BOOL)shouldAutorotate {
    
    if (IS_DEVICE_IPAD) {
        
        return YES;
        
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    if (IS_DEVICE_IPAD) {
        
        return UIInterfaceOrientationMaskAll;
        
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            sharedAppDelegate.isPortrait=YES;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            sharedAppDelegate.isPortrait=NO;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    

   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [super viewDidDisappear:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
