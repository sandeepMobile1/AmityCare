//
//  ChangePasswordVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "AmityCareServices.h"
#import "MFSideMenu.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "AppSetting.h"

@interface ChangePasswordVC ()<ChangePasswordInvocationDelegate,UIAlertViewDelegate>

@end

@implementation ChangePasswordVC

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

    
    fieldsArray=[[NSMutableArray alloc] initWithObjects:tfOldPassword,tfNewPassword,tfConfirmPassword, nil];
    
    
    [self layoutViewSubviews];

    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
       // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    self.navigationController.navigationBarHidden = YES;

    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changePasswordAction:(id)sender
{
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    [self resignTextField];
    
    if([tfOldPassword.text length]==0){
        [ConfigManager showAlertMessage:nil Message:@"Enter old password"];
        return;
    }
    else if ([tfOldPassword.text length]<8){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MINIMUM_PASSWORD_LENGTH];
        return;
    }
    else if([tfOldPassword.text length]>20){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MINIMUM_PASSWORD_LENGTH];
        return;
    }
    else if(![ConfigManager validatePassword:tfOldPassword.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_PASSWORD_ALERT];
        return;
    }
    else if([tfNewPassword.text length]==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_NEW_PASSWORD];
        return;
    }
    else if ([tfNewPassword.text length]<8){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MINIMUM_NEW_PASSWORD_LENGTH];
        return;
    }
    else if([tfNewPassword.text length]>20){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MAXIMUM_NEW_PASSWORD_LENGTH];
        return;
    }
    else if(![ConfigManager validatePassword:tfNewPassword.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_NEW_PASSWORD_ALERT];
        return;
    }
    else if([tfConfirmPassword.text length]==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_CONFIRM_PASSWORD];
        return;
    }
    else if ([tfConfirmPassword.text length]<8){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MINIMUM_CONFIRM_PASSWORD_LENGTH];
        return;
    }
    else if([tfConfirmPassword.text length]>20){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MAXIMUM_CONFIRM_PASSWORD_LENGTH];
        return;
    }
    else if(![ConfigManager validatePassword:tfConfirmPassword.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_CONFIRM_PASSWORD_ALERT];
        return;
    }
    else if(![tfNewPassword.text isEqualToString:tfConfirmPassword.text])
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NEW_CONFIRM_PASSWORD_MISMATCH];
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dict setObject:tfOldPassword.text forKey:@"old_password"];
    [dict setObject:tfNewPassword.text forKey:@"new_password"];
    [dict setObject:tfConfirmPassword.text forKey:@"confirm_password"];

    [DSBezelActivityView newActivityViewForView:self.view withLabel:LOADING_VIEW_DEFAULT_HEADING width:200];
    
    AmityCareServices *service = [[AmityCareServices alloc] init];
    [service changePasswordInvocation:dict delegate:self];
    
}
#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(IS_DEVICE_IPAD){
    }
    else
    {
        
        [self scrollViewToCenterOfScreen:textField];
        [textField setInputAccessoryView:keyboardtoolbar];
        
        if(DEVICE_OS_VERSION_7_0)
        {
            keyboardtoolbar.barStyle = UIBarStyleDefault;
            
        }
        for (int n=0; n<[fieldsArray count]; n++)
        {
            if ([fieldsArray objectAtIndex:n]==textField)
            {
                if (n==[fieldsArray count]-2)
                {
                    [barButton setStyle:UIBarButtonItemStyleDone];
                }
            }
        }
        
        
    }
    
    
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 245;
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(IS_DEVICE_IPAD){
    }
    else
    {
        if (textField) {
            [textField resignFirstResponder];
            
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
        }
        
    }
    
    return YES;
}

- (IBAction) next
{
    for (int n=0; n<[fieldsArray count]; n++)
    {
        if ([[fieldsArray objectAtIndex:n] isEditing] && n!=[fieldsArray count]-1)
        {
            
            [[fieldsArray objectAtIndex:n+1] becomeFirstResponder];
            
            if (n+1==[fieldsArray count]-1)
            {
                [barButton setTitle:@"Done"];
                [barButton setStyle:UIBarButtonItemStyleDone];
            }else
            {
                [barButton setTitle:@"Done"];
                [barButton setStyle:UIBarButtonItemStyleDone];
            }
            
            break;
        }
        
    }
}

- (IBAction) previous
{
    for (int n=0; n<[fieldsArray count]; n++)
    {
        
        if ([[fieldsArray objectAtIndex:n] isEditing]&& n!=0)
        {
            
            [[fieldsArray objectAtIndex:n-1] becomeFirstResponder];
            [barButton setTitle:@"Done"];
            [barButton setStyle:UIBarButtonItemStyleDone];
            
            break;
        }
        
    }
}

- (IBAction) dismissKeyboard:(id)sender
{
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    [self resignTextField];
    
}
-(void)resignTextField
{
    [tfConfirmPassword resignFirstResponder];
    [tfNewPassword resignFirstResponder];
    [tfOldPassword resignFirstResponder];
}
-(IBAction) slideFrameUp:(UITextField *)textField
{
    if (textField.tag == 3) {
        value = 1;
    }
    else if(textField.tag == 4) {
        value = 2;
    }
    else if(textField.tag == 5) {
        value = 3;
    }
    [self slideFrame:YES];
}

-(IBAction) slideFrameDown
{
    [self slideFrame:NO];
}
-(void) slideFrame:(BOOL) up
{
    NSLog(@"11111");
    
    if(value == 1){
        
        NSLog(@"2222");
        
        movementDistance = 70;
        movementDuration = 0.3f;
    }
    else if(value == 2) {
        movementDistance = 120;
        movementDuration = 0.3f;
    }
    else if(value == 3){
        movementDistance = 210;
        movementDuration = 0.3f;
    }
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
    
}

#pragma mark- UIAlertView Deleagate
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.alertTag == AC_ALERTVIEW_PROFIE_UPDATED)
    {
        tfOldPassword.text = @"";
        tfNewPassword.text = @"";
        tfConfirmPassword.text = @"";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_PROFILE_UPDATED_SUCCESSFULLY object:nil];
    }
    
}
#pragma mark------------
#pragma mark- Others Methods

-(void)layoutViewSubviews
{
    for (id tempView in [self.view subviews]) {
        if([tempView isKindOfClass:[UIView class]])
        {
            for ( id innerView in [tempView subviews]) {
                if([innerView isKindOfClass:[UITextField class]]){
                    [self addPaddingOnTextFields:(UITextField*)innerView];
                }
            }
        }
    }
    
    tfOldPassword.font = [UIFont fontWithName:appfontName size:15.0f];
    tfNewPassword.font = [UIFont fontWithName:appfontName size:15.0f];
    tfConfirmPassword.font = [UIFont fontWithName:appfontName size:15.0f];
    
    if (IS_DEVICE_IPAD) {
        
        btnChangePass.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];

    }
    else
    {
        btnChangePass.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:17.0f];
 
    }
    
}

-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark- Invocation Delegates
-(void)changePasswordInvocationDidFinish:(ChangePasswordInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    @try {
        if(!error)
        {
            [DSBezelActivityView removeView];

            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString* strSuccess = [response valueForKey:@"success"];
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:DATE_FORMAT_LOGIN];
                    NSString* strDate = [dateformatter stringFromDate:[NSDate date]];
                    
                    [AppSetting setPasswordChnageTime:strDate];

                    
                    ACAlertView* alertView = [ConfigManager alertView:nil message:@"Password Changed Successfully" del:self];
                    alertView.alertTag = AC_ALERTVIEW_PROFIE_UPDATED;
                    [alertView show];
                }
                else if([strSuccess rangeOfString:@"false"].length>0)
                {
                    
                    [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                }
            }//if
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
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
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}


@end
