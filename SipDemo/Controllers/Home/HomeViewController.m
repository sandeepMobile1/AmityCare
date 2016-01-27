//
//  HomeViewController.m
//  Amity-Care
//
//  Created by Vijay Kumar on 28/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "HomeViewController.h"
#import "RegistrationVC.h"
#import "AmityCareServices.h"
#import <TargetConditionals.h>
#import "MFSideMenuContainerViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "AppSetting.h"
#import "TopNavigationView.h"

@interface HomeViewController (Private)<LoginInvocationDelegate,ForgotPasswordInvocationDelegate>

@end

@implementation HomeViewController


#pragma mark------------
#pragma mark- ViewLifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.navigationController.navigationBarHidden = YES;
    
    tfEmail.text = @"";
    tfPassword.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!IS_DEVICE_IPAD) {
        
        TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
        navigation.lblTitle.text = @"Login";
        [self.view addSubview:navigation];
        
    }
        
    fieldsArray = [[NSArray alloc] initWithObjects:tfEmail,tfPassword,nil];

    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    
    forgotPasswordCount=0;
    
    [self layoutLoginSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------------
#pragma mark- Others Methods

-(void)layoutLoginSubviews
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
    
    lblTitle.font = [UIFont fontWithName:TITLE_FONT_NAME size:24.0f];
    lblRememberMe.font = [UIFont fontWithName:appfontName size:15.0f];
    tfEmail.font = [UIFont fontWithName:appfontName size:15.0f];
    tfPassword.font = [UIFont fontWithName:appfontName size:15.0f];
    btnLogin.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    btnRegister.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
}

-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

-(void)showLandingPage
{
    sharedAppDelegate.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    [DSBezelActivityView removeView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_LOGIN];
    [formatter stringFromDate:[NSDate date]];
    
    [AppSetting setLastLoginTime:[formatter stringFromDate:[NSDate date]]];
    
    ARCHIEVE_USER_DATA;
    sharedAppDelegate.userObj = UNARCHIEVE_USER_DATA;

    NSLog(@"Email =%@, password =%@ userid =%@",sharedAppDelegate.userObj.email,sharedAppDelegate.userObj.password,sharedAppDelegate.userObj.userId);
    
    [sharedAppDelegate showEmployeeDashBoard:[self navigationController]];
    
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"centralManagerDidUpdateState");
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        //Do what you intend to do
        
        
    } else if(central.state == CBCentralManagerStatePoweredOff) {
        
        
        //Bluetooth is disabled. ios pops-up an alert automatically
    }
}
#pragma mark------------
#pragma mark- UIAlertViewDelegate

- (void)willPresentAlertView:(UIAlertView *)alertView{

    if(alertView.tag == AC_ALERTVIEW_FORGOT_PASSWORD){
        [[alertView textFieldAtIndex:0] setPlaceholder:@"Enter your Email"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == AC_ALERTVIEW_FORGOT_PASSWORD){
        
        UITextField* textfield = [alertView textFieldAtIndex:0];
        
        if(textfield.text.length==0){
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_EMAIL];
            return;
        }
        else if(![ConfigManager validateEmail:textfield.text]){
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_EMAIL_ADDRESS];
            return;
        }
        else
        {
            forgotPasswordCount = 0;
            [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Processing please wait..." width:180];
            AmityCareServices *service = [[AmityCareServices alloc] init];
            [service forgotPasswordInvocation:textfield.text delegate:self];
        }
    }
}


#pragma mark------------
#pragma mark- IBActions

-(IBAction)LoginAction:(id)sender
{

    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    
    if(tfEmail.text.length==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_EMAIL];
        return;
    }
    else if([ConfigManager stringContainsSpecialCharacters:tfEmail.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_SPECIAL_CHARACTERS];
        return;
    }
    else if(![ConfigManager validateEmail:tfEmail.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_EMAIL_ADDRESS];
        return;
    }
    
    else if([tfPassword.text length]==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_PASSWORD];
        return;
    }
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Logging please wait..." width:280];
        AmityCareServices *service = [[AmityCareServices alloc] init];
        
        NSString* strEmail = [ConfigManager trimmedString:tfEmail.text];
        NSString* strPassword = [ConfigManager trimmedString:tfPassword.text];
        
        NSString* strToken = @"";
//#ifdef TARGET_IPHONE_SIMULATOR
//        strToken = @"";
//#elif TARGET_OS_IPHONE
//        strToken =sharedAppDelegate.strDeviceToken
//#endif

        strToken = sharedAppDelegate.strDeviceToken!=nil?sharedAppDelegate.strDeviceToken:@"";
        
        [service loginInvocationEmail:strEmail password:strPassword devToken:strToken delegate:self];
        
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }

}
-(IBAction)RegistartionAction:(id)sender
{
    if(IS_DEVICE_IPAD){

        RegistrationVC *registrationVc = [[RegistrationVC alloc] initWithNibName:@"RegistrationVC" bundle:nil];
        [self.navigationController pushViewController:registrationVc animated:YES];
    }
    else
    {
        RegistrationVC *registrationVc = [[RegistrationVC alloc] initWithNibName:@"Registration_iphone" bundle:nil];
        [self.navigationController pushViewController:registrationVc animated:YES];
    }
}

-(IBAction)RememberMeAction:(id)sender
{
    [btnRememberMe setSelected:!btnRememberMe.isSelected];
}
#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

-(void)resignTextField
{
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
}
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
#pragma mark- Invocation Methods
-(void)forgotPasswordInvocationDidFinish:(ForgotPasswordInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    NSLog(@"Forgot Response =%@",dict);
    @try {
        if(!error)
        {
            @try
            {
                id response = [dict valueForKey:@"response"];
                if([response isKindOfClass:[NSDictionary class]])
                {
                    NSString* strSuccess = [response valueForKey:@"success"];

                    if([strSuccess rangeOfString:@"true"].length>0)
                    {
                        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_FORGOT_PASSWORD_MAIL_SEND];
                    }
                    else if([strSuccess rangeOfString:@"false"].length>0)
                    {
                        [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {

    }
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    [self resignTextField];

}

-(void)loginInvocationDidFinish:(LoginInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    NSLog(@"Login Result =%@ \n error =%@",dict,error);
    @try {
        
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            id beacon = [dict valueForKey:@"Ibeacon"];
            
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString* success = [response valueForKey:@"success"];
                if([success rangeOfString:@"true"].length>0)
                {
                    NSDictionary *data = [response valueForKey:@"data"];
                    
                    sharedAppDelegate.userObj = [[User alloc] init];
                    sharedAppDelegate.userObj.email =   NULL_TO_NIL([data valueForKey:@"email"]);
                    sharedAppDelegate.userObj.image =   NULL_TO_NIL([data valueForKey:@"image"]);
                    sharedAppDelegate.userObj.userId =  NULL_TO_NIL([data valueForKey:@"userId"]);
                    sharedAppDelegate.userObj.fname =   NULL_TO_NIL([data valueForKey:@"first_name"]);
                    sharedAppDelegate.userObj.lname =   NULL_TO_NIL([data valueForKey:@"last_name"]);
                    sharedAppDelegate.userObj.phoneNo = NULL_TO_NIL([data valueForKey:@"phone_number"]);
                    sharedAppDelegate.userObj.role =    NULL_TO_NIL([data valueForKey:@"user_type"]);
                    sharedAppDelegate.userObj.default_email =    NULL_TO_NIL([data valueForKey:@"inbox_email"]);

                    sharedAppDelegate.userObj.notification_status =    [NSString stringWithFormat:@"%@",NULL_TO_NIL([data valueForKey:@"notificationStatus"])];

                    sharedAppDelegate.userObj.role_id =    NULL_TO_NIL([data valueForKey:@"role_id"]);
                    sharedAppDelegate.userObj.appPin =    NULL_TO_NIL([data valueForKey:@"appPin"]);//Dharmbir140919
                    sharedAppDelegate.userObj.aboutMe=NULL_TO_NIL([data valueForKey:@"description"]);
                    
                    
                    NSString* strCount = [response valueForKey:@"contactCount"];//Dharmbir210814
                    
                    sharedAppDelegate.unreadContactCount = [strCount integerValue];
                    
                    NSLog(@"Count %ld",(long)[strCount integerValue]);
                    
                    if(sharedAppDelegate.unreadContactCount>0)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_CONTACT_RECIEVE object:nil];
                    }
//
                    NSDictionary* sipDetailsD = NULL_TO_NIL([response objectForKey:@"sip_details"]);
                    
                    if(sipDetailsD)
                    {
                        //Save Logged in user SIP details, It will be used when calling from app to app as well as while receving calls
                        sharedAppDelegate.userObj.sip = [[SipAcDetails alloc] init];
                        
                        sharedAppDelegate.userObj.sip.ipAddress =   NULL_TO_NIL([sipDetailsD valueForKey:@"ipAddress"]);
                        sharedAppDelegate.userObj.sip.password =   NULL_TO_NIL([sipDetailsD valueForKey: @"password"]);
                        sharedAppDelegate.userObj.sip.username =   NULL_TO_NIL([sipDetailsD valueForKey: @"username"]);

                    }
                    [sharedAppDelegate initUserDefaults];
                    
                    [sharedAppDelegate initSipServices];
                    
                    NSString* strInterval = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"recording_interval"])];
                    NSString* strStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"recording_status"])];
                    NSString* strTimeLimit = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"recording_time_limit"])];
                    
                    sharedAppDelegate.userObj.recordingLength = strTimeLimit;
                    sharedAppDelegate.userObj.recordingStatus = strStatus;
                    sharedAppDelegate.userObj.recordingTimeInterval = strInterval;
                    
                    NSLog(@"%@",sharedAppDelegate.userObj.recordingLength);
                    NSLog(@"%@",sharedAppDelegate.userObj.recordingStatus);
                    NSLog(@"%@",sharedAppDelegate.userObj.recordingTimeInterval);

                    
                    sharedAppDelegate.unreadContactCount = [NULL_TO_NIL([response valueForKey:@"contactCount"]) integerValue];

                    sharedAppDelegate.unreadMsgCount = [NULL_TO_NIL([response valueForKey:@"chatCount"]) integerValue];

                    sharedAppDelegate.unreadTagCount = [NULL_TO_NIL([response valueForKey:@"tagCount"]) integerValue];
                    
                    sharedAppDelegate.unreadUserNotifiationCount = [NULL_TO_NIL([response valueForKey:@"callCount"]) integerValue];


                    sharedAppDelegate.userObj.clockInTagId = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagId"])];
                    sharedAppDelegate.userObj.clockInTagTitle = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagTitle"])];
                    
                    NSLog(@"%@",sharedAppDelegate.userObj.clockInTagId);
                    NSLog(@"%@",sharedAppDelegate.userObj.clockInTagTitle);

                    NSString* strChangePasswordDate = NULL_TO_NIL([data valueForKey:@"changePasswordDate"]);
                    
                    if(strChangePasswordDate){
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:DATE_FORMAT_LOGIN];
                        NSDate *chngDate = [formatter dateFromString:strChangePasswordDate];
                        
                        [AppSetting setPasswordChnageTime:[formatter stringFromDate:chngDate]];
                    }
                    
                    //role type 2= employee, 3= manager
                    if([sharedAppDelegate.userObj.role isEqualToString:@"2"])
                       
                        sharedAppDelegate.userObj.isEmployee = TRUE;
                    
                    else if([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"])
                        
                        sharedAppDelegate.userObj.isEmployee = FALSE;
                    
                    else
                    {
                        sharedAppDelegate.userObj.isEmployee = TRUE;

                    }
                    
                    [standardUserDefault synchronize];
                    
                    [self showLandingPage];
                }
                else if([success rangeOfString:@"false"].length>0)
                {
                    NSString *message = [response valueForKey:@"message"];
                    
                    if ([message isEqualToString:@"Your Email address invalid"])
                    {
                        [ConfigManager showAlertMessage:nil Message:@"Invalid E-mail"];
                    }
                    else if ([message isEqualToString:@"Your Password invalid"])
                    {
                        forgotPasswordCount++;
                       
                        if(forgotPasswordCount>=3){
                            
                            tfPassword.text = @"";
                            
                            ACAlertView* forgotAlert =[ConfigManager alertView:@"Forgot Password?" message:nil del:self];
                            forgotAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                            forgotAlert.alertTag = AC_ALERTVIEW_FORGOT_PASSWORD;
                            [forgotAlert show];
                        }
                        else{
                            tfPassword.text = @"";
                            [ConfigManager showAlertMessage:nil Message:@"Wrong Password"];
                        }
                    }
                    else if ([message isEqualToString:@"Thank you for applying for an account. Your account is currently pending approval by the site administrator."])
                    {
                        [ConfigManager showAlertMessage:nil Message:@"Thank you for applying for an account. Your account is currently pending approval by the site administrator."];

                    }
                    else if ([message isEqualToString:@"Your Account inactive"]){
                          [ConfigManager showAlertMessage:nil Message:@"Your account is Deactivated"];
                    }
                    
                }
            }
            else
            {
                [ConfigManager showAlertMessage:@"Invalid Response" Message:[dict debugDescription]];
            }
            
                if ([beacon count]>0) {
                    
                   [sharedAppDelegate loadIbeaconsItems:beacon];
                }
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
}
@end
