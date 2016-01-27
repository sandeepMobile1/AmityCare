//
//  RegistrationVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 28/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "RegistrationVC.h"
#import "RegistererAddressVC.h"
#import "AmityCareServices.h"
#import "TopNavigationView.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface RegistrationVC ()<CheckEmailInvocationDelegate,TopNavigationViewDelegate>

-(IBAction)nextBtnAction:(id)sender;

@end

@implementation RegistrationVC

@synthesize arrRoleList,strRole,masterView;

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
    
    fieldsArray = [[NSArray alloc] initWithObjects:tfFname,tfLname,tfEmail,tfPassword,tfConfirmPassword,txtUserRole,nil];
    
    
    self.arrRoleList=[[NSMutableArray alloc] initWithObjects:@"Employee",@"Manager",@"Supervisor",@"Family",@"3rd Party", nil];
    
    [self layoutRegistrationSubviews];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [sharedAppDelegate startUpdatingLocation];
    
    if (IS_DEVICE_IPAD) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    
    if (!IS_DEVICE_IPAD) {
        
        TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
        navigation.lblTitle.text = @"Register";
        [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        
        [self.view addSubview:navigation];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----------
#pragma mark- Custom

-(void)layoutRegistrationSubviews
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
    tfEmail.font = [UIFont fontWithName:appfontName size:15.0f];
    tfPassword.font = [UIFont fontWithName:appfontName size:15.0f];
    tfFname.font = [UIFont fontWithName:appfontName size:15.0f];
    tfLname.font = [UIFont fontWithName:appfontName size:15.0f];
    tfConfirmPassword.font = [UIFont fontWithName:appfontName size:15.0f];
    
    btnNext.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
}

-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

-(void)moveToAddressViewController
{
    if(IS_DEVICE_IPAD){
        
        RegistererAddressVC *addressVc = [[RegistererAddressVC alloc] initWithNibName:@"RegistererAddressVC" bundle:nil];
        
        NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
        [info setObject:[ConfigManager trimmedString:tfFname.text] forKey:@"first_name"];
        [info setObject:[ConfigManager trimmedString:tfLname.text] forKey:@"last_name"];
        [info setObject:[ConfigManager trimmedString:tfEmail.text] forKey:@"email"];
        [info setObject:[ConfigManager trimmedString:tfPassword.text] forKey:@"password"];
        [info setObject:[ConfigManager trimmedString:self.strRole] forKey:@"role"];
        
        addressVc.userInfo = info;
        
        [self.navigationController pushViewController:addressVc animated:YES];
        
    }
    else
    {
        RegistererAddressVC *addressVc = [[RegistererAddressVC alloc] initWithNibName:@"RegistererAddressVC_iphone" bundle:nil];
        
        NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
        [info setObject:[ConfigManager trimmedString:tfFname.text] forKey:@"first_name"];
        [info setObject:[ConfigManager trimmedString:tfLname.text] forKey:@"last_name"];
        [info setObject:[ConfigManager trimmedString:tfEmail.text] forKey:@"email"];
        [info setObject:[ConfigManager trimmedString:tfPassword.text] forKey:@"password"];
        [info setObject:[ConfigManager trimmedString:self.strRole] forKey:@"role"];
        
        addressVc.userInfo = info;
        
        [self.navigationController pushViewController:addressVc animated:YES];
        
    }
}


#pragma mark----------
#pragma mark- IBActions


-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(IBAction)nextBtnAction:(id)sender
{
    [tfFname resignFirstResponder];
    [tfLname resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfConfirmPassword resignFirstResponder];
    
    tfFname.text= [tfFname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tfLname.text= [tfLname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tfEmail.text= [tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tfPassword.text= [tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tfConfirmPassword.text= [tfConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if(tfFname.text.length==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_FIRST_NAME];
        return;
    }
    else if(tfFname.text.length<3 || tfFname.text.length>20){
        [ConfigManager showAlertMessage:nil Message:@"first name should be 3-20 characters long"];
        return;
    }
    else if([ConfigManager stringContainsSpecialCharacters:tfFname.text]){
        [ConfigManager showAlertMessage:nil Message:@"first name should not contain special characters"];
        return;
    }
    if(tfLname.text.length==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_LAST_NAME];
        return;
    }
    else if(tfLname.text.length<3 || tfLname.text.length>20){
        [ConfigManager showAlertMessage:nil Message:@"last name should be 3-20 characters long"];
        return;
    }
    else if([ConfigManager stringContainsSpecialCharacters:tfLname.text]){
        [ConfigManager showAlertMessage:nil Message:@"Last name should not contain special characters"];//ALERT_MSG_SPECIAL_CHARACTERS
        return;
    }
    if(tfEmail.text.length==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_EMAIL];
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
    else if ([tfPassword.text length]<8){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MINIMUM_PASSWORD_LENGTH];
        return;
    }
    else if([tfPassword.text length]>20){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_MINIMUM_PASSWORD_LENGTH];
        return;
    }
    else if(![ConfigManager validatePassword:tfPassword.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_PASSWORD_ALERT];
        return;
    }
    else if([tfConfirmPassword.text length]==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_CONFIRM_PASSWORD_BLANK];
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
    else if(![tfConfirmPassword.text isEqualToString:tfPassword.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_PASSWORDS_MISMATCH];
        return;
    }
    else if(txtUserRole.text.length==0){
        [ConfigManager showAlertMessage:nil Message:@"User's role is required"];
        return;
    }
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Processing please wait..." width:180];
        AmityCareServices *service = [[AmityCareServices alloc ] init];
        [service checkEmailInvocation:tfEmail.text delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

#pragma mark----------
#pragma mark- IBActions

-(void)resignTextField
{
    [tfFname resignFirstResponder];
    [tfLname resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfConfirmPassword resignFirstResponder];
    [txtUserRole resignFirstResponder];
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
    
    if (textField==txtUserRole)
    {
        
        [self.view endEditing:YES];
        
        [self showRolePicker];
        
        return NO;
    }
    else
        return YES;
    
    
}


-(void)showRolePicker
{
    [self resignTextField];
    
    self.masterView = [[UIView alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [self.masterView setFrame:CGRectMake(0, 0, 300, 260)];
    }
    else
    {
        if (IS_IPHONE_5) {
            
            [self.masterView setFrame:CGRectMake(0, 220+IPHONE_FIVE_FACTOR, 320, 260)];
            
        }
        else
        {
            [self.masterView setFrame:CGRectMake(0, 220, 320, 260)];
            
        }
        
    }
    
    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:@"Role"];
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.masterView addSubview:pickerToolbar];
    
    CGRect pickerFrame ;
    
    if (IS_DEVICE_IPAD) {
        
        pickerFrame = CGRectMake(0, 40, 300, 216);
    }
    else
    {
        pickerFrame = CGRectMake(0, 40, 320, 216);
        
    }
    
    
    
    myPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    [myPicker setDataSource: self];
    [myPicker setDelegate: self];
    myPicker.tag=1;
    [myPicker setBackgroundColor:[UIColor whiteColor]];
    [myPicker selectRow:0 inComponent:0 animated:NO];
    [myPicker setShowsSelectionIndicator:YES];
    [self.masterView addSubview:myPicker];
    
    if (IS_DEVICE_IPAD) {
        
        UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        viewController.view = self.masterView;
        viewController.preferredContentSize = viewController.view.frame.size;
        popover =[[UIPopoverController alloc] initWithContentViewController:viewController];
        [popover presentPopoverFromRect:txtUserRole.bounds
                                 inView:txtUserRole
               permittedArrowDirections:UIPopoverArrowDirectionDown
                               animated:YES];
    }
    else
    {
        [self.view addSubview:self.masterView];
    }
}
- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    
    CGRect frame;
    
    if (IS_DEVICE_IPAD) {
        
        frame = CGRectMake(0, 0, 300, 44);
    }
    else
    {
        frame = CGRectMake(0, 0, 320, 44);
    }
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [self createButtonWithType:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [barItems addObject:flexSpace];
    if (title){
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
    
}
- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    [toolBarItemlabel setTextAlignment:NSTextAlignmentCenter];
    [toolBarItemlabel setTextColor:[UIColor whiteColor]];
    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
    toolBarItemlabel.text = aTitle;
    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
    return buttonLabel;
    
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction];
    
}
- (IBAction)actionPickerDone:(id)sender {
    
    
    [txtUserRole setText:[self.arrRoleList objectAtIndex:[myPicker selectedRowInComponent:0]]];
    
    if ([txtUserRole.text isEqualToString:@"Employee"]) {
        
        self.strRole=@"2";
    }
    if ([txtUserRole.text isEqualToString:@"Manager"]) {
        
        self.strRole=@"3";
    }
    if ([txtUserRole.text isEqualToString:@"Supervisor"]) {
        
        self.strRole=@"5";
    }
    if ([txtUserRole.text isEqualToString:@"Family"]) {
        
        self.strRole=@"6";
    }
    
    if ([txtUserRole.text isEqualToString:@"3rd Party"]) {
        
        self.strRole=@"8";
    }
    
    if (IS_DEVICE_IPAD) {
        
        if (popover && popover.popoverVisible)
            [popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        [self resignTextField];
        
        [self.masterView removeFromSuperview];
    }
    
}
- (IBAction)actionPickerCancel:(id)sender {
    
    if (IS_DEVICE_IPAD) {
        
        if (popover && popover.popoverVisible)
            [popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self resignTextField];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        [self.masterView removeFromSuperview];
    }
    
}

#pragma mark----------
#pragma mark- PickerView delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

{
    return [self.arrRoleList count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

{
    
    return [self.arrRoleList objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
}
#pragma mark----------
#pragma mark- Webservice delegates

-(void)checkEmailInvocationDidFinish:(CheckEmailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"Check Mail Response = %@",dict);
    [DSBezelActivityView removeView];
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        if([response isKindOfClass:[NSDictionary class]])
        {
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                [self moveToAddressViewController];
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:@"E-mail already exists"];
            }
        }
        else
        {
            [ConfigManager showAlertMessage:@"Invalid Response!" Message:[dict debugDescription]];
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
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
