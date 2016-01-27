//
//  RegistererAddressVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 02/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "RegistererAddressVC.h"
#import "AmityCareServices.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface RegistererAddressVC (Private)<RegistrationInvocationDelegate>

@end

@implementation RegistererAddressVC
@synthesize userInfo;

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
    
    fieldsArray = [[NSArray alloc] initWithObjects:tfPhoneNo,tfAddress,nil];
    
    [self layoutAddrViewSubviews];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.navigationController.navigationBarHidden = YES;
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    
    
    
    if([ConfigManager isInternetAvailable]){
        [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching address..." width:200];
        [self performSelector:@selector(fetchAddress) withObject:nil afterDelay:0.2f];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------
#pragma mark- Custom Methods
-(void)layoutAddrViewSubviews
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
    tfPhoneNo.font = [UIFont fontWithName:appfontName size:15.0f];
    tfAddress.font = [UIFont fontWithName:appfontName size:15.0f];
    
    btnRegister.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
}

-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

-(void)fetchAddress{
    
    [self getAddressFromLatLong:sharedAppDelegate.locationManager.location.coordinate];
    
}

-(NSString *)getAddressFromLatLong:(CLLocationCoordinate2D)latLong{
    
    NSError *error;
    
    NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",latitude,longitude];//latLong.latitude,latLong.longitude
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSString *formattedAddress=@"";
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];//[result JSONValue];
    NSLog(@"JSON @@@@@@ ---- =%@",results);
    NSMutableArray *tempArray=[results objectForKey:@"results"];
    
    [DSBezelActivityView removeView];
    
    for (NSMutableDictionary *dict in tempArray)
    {
        formattedAddress=[dict objectForKey:@"formatted_address"];
        if (![formattedAddress isEqualToString:@""])
        {
            tfAddress.text = formattedAddress;
            break;
        }
    }
    
    return formattedAddress;
}

#pragma mark--------
#pragma mark- IBActions

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)registerationAction:(id)sender
{
    @try {
        [tfPhoneNo resignFirstResponder];
        [tfAddress resignFirstResponder];
        
        if([tfPhoneNo.text length]==0){
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_PHONE_NO];
            return;
        }
        else if([ConfigManager stringContainsSpecialCharacters:tfPhoneNo.text]){
            [ConfigManager showAlertMessage:nil Message:@"Phone number should not contain special characters"];
            return;
        }
        else if(![ConfigManager validatePhoneNum:tfPhoneNo.text]){
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_PHONE_ENTERED];
            return;
        }
        else if ([tfAddress.text length]==0){
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_ADDRESS];
            return;
        }
        else if([ConfigManager stringContainsSpecialCharacters:tfAddress.text]){
            [ConfigManager showAlertMessage:nil Message:@"Address should not contain special characters"];
            return;
        }
        
        [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Processing please wait..." width:200];
        AmityCareServices* service = [[AmityCareServices alloc] init];
        
        [userInfo setObject:[ConfigManager trimmedString:tfPhoneNo.text] forKey:@"phone"];
        [userInfo setObject:[ConfigManager trimmedString:tfAddress.text] forKey:@"address"];
        [userInfo setObject:@"1" forKey:@"type"];   //type 1= iphone, 2= android
        [userInfo setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [userInfo setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        
        NSString* strToken = @"";
        
        strToken = sharedAppDelegate.strDeviceToken!=nil?sharedAppDelegate.strDeviceToken:@"";
        
        [userInfo setObject:strToken forKey:@"device_token"];
        [userInfo setObject:@"1" forKey:@"type"];   //1= iphone //2= android
        
        [service registrationInvocationInfo:userInfo delegate:self];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

-(void)resignTextField
{
    [tfPhoneNo resignFirstResponder];
    [tfAddress resignFirstResponder];
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

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == AC_ALERTVIEW_REGISTER_SUCCESSFULLY)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark- Invocation Methods
-(void)registrationInvocationDidFinish:(RegistrationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    @try {
        if (!error) {
            
            NSLog(@"registrationInvocationDidFinish =%@ \nError =%@=", dict,[error debugDescription]);
            id response = [dict valueForKey:@"response"];
            
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString *success = [response valueForKey:@"success"];
                if ([success rangeOfString:@"true"].length>0) {
                    
                    ACAlertView *alert = [ConfigManager alertView:nil message:@"Registered Successfully" del:self];//[response valueForKey:@"message"]
                    alert.tag = AC_ALERTVIEW_REGISTER_SUCCESSFULLY;
                    [alert show];
                }
                else
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
    
    [DSBezelActivityView removeView];
    
}

#pragma mark orientation delegates

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    
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
            sharedAppDelegate.isPortrait=NO;
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            sharedAppDelegate.isPortrait=YES;
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}


@end
