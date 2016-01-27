//
//  ProfileViewController.m
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LTKPopoverActionSheet.h"
#import "LTKPopoverActionSheetDelegate.h"
#import "NormalActionSheetDelegate.h"
#import "UIImageExtras.h"
#import "UIImageView+WebCache.h"
#import "MFSideMenu.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "GetProfileInvocation.h"
#import "SetProfileInvocation.h"
@interface ProfileViewController ()<NormalActionDeledate,LTKPopoverActionSheetDelegate,GetProfileInvocationDelegate,SetProfileInvocationDelegate>
@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic, strong) UIPopoverController* popover;
@end

@implementation ProfileViewController

@synthesize popover;
@synthesize userid,imagePickerView,imagePickerController;

UIButton *uploadButton =nil;
#define TXTVIEW_PLACEHOLDER  @"write about yourself..."

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
    
    self.navigationController.navigationBarHidden = YES;
    
   
    
    txtvwAboutMe.text = TXTVIEW_PLACEHOLDER;
    txtvwAboutMe.textColor = [UIColor lightGrayColor];
    
    txtvwAboutMe.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.5] CGColor];
    txtvwAboutMe.layer.borderWidth= 1.0f;
    txtvwAboutMe.clipsToBounds = YES;
    
    fieldsArray=[[NSMutableArray alloc] initWithObjects:tfFirstName,tfLastName,tfContactNo,tfAddress,txtvwAboutMe, nil];
    
    [self layoutProfileSubviews];
    
    if([ConfigManager isInternetAvailable]){
        [self requestForProfileDetails];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
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
#pragma mark------------
#pragma mark- NavigationMethods
-(void)leftBarButtonDidClicked:(id)sender
{
    
    if (!IS_DEVICE_IPAD) {
        
        
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
        
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
    else if(alertView.tag==102)
    {
        
        if(buttonIndex==0)
        {
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [ConfigManager showAlertMessage:nil Message:@"Your device does not support this feature."];
                return;
            }
            //camera
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:uploadButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                
                // [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            
        }
        else
        {
            //gallery
            if(buttonIndex==1)
            {
                self.imagePickerController = [[UIImagePickerController alloc] init];
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
                self.imagePickerController.delegate = self;
                self.imagePickerController.allowsEditing = YES;
                if (IS_DEVICE_IPAD) {
                    
                    self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                    [self.popover presentPopoverFromRect:uploadButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else
                {
                    self.imagePickerView = self.imagePickerController.view;
                    
                    CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                    
                    self.imagePickerView.frame = cameraViewFrame;
                    
                    [self.view addSubview:self.imagePickerView];
                    //[self presentViewController:imagePickerController animated:YES completion:nil];
                }
            }
        }
        
    }
}

#pragma mark------------
#pragma mark- Others Methods

-(void)requestForProfileDetails
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching profile details..." width:200];
    [[AmityCareServices sharedService] GetProfileInvocation:sharedAppDelegate.userObj.userId delegate:self];
}

-(void)fillUserValues:(User*)user
{
    tfFirstName.text = user.fname;
    tfLastName.text = user.lname;
    tfEmail.text = user.email;
    tfContactNo.text = user.phoneNo;
    tfAddress.text = user.address;
    txtvwAboutMe.text = [ConfigManager trimmedString:[user.aboutMe stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    [imgProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,user.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    NSLog(@"Proflie image url %@",[NSString stringWithFormat:@"%@%@",smallThumbImageURL,user.image]);
    
}

-(void)layoutProfileSubviews
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
    
    if (IS_DEVICE_IPAD) {
        
        imgProfilePic.layer.cornerRadius = 67.0f;
        imgProfilePic.layer.borderWidth=1.0f;
        
    }
    else
    {
        imgProfilePic.layer.cornerRadius = 50.0f;
        imgProfilePic.layer.borderWidth=1.0f;
        
    }
    imgProfilePic.layer.borderColor = [[UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:0.5f] CGColor];
    
    imgProfilePic.clipsToBounds = YES;
    
    tfFirstName.font = [UIFont fontWithName:appfontName size:15.0f];
    tfLastName.font = [UIFont fontWithName:appfontName size:15.0f];
    tfEmail.font = [UIFont fontWithName:appfontName size:15.0f];
    tfContactNo.font = [UIFont fontWithName:appfontName size:15.0f];
    tfAddress.font = [UIFont fontWithName:appfontName size:15.0f];
    lblAboutMe.font = [UIFont fontWithName:appfontName size:15.0f];
    txtvwAboutMe.font = [UIFont fontWithName:appfontName size:15.0f];
    btnUpdateProfile.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    
    if (!IS_DEVICE_IPAD) {
        
        if (IS_IPHONE_5) {
            
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,500)];
            
        }
        else
        {
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,500+IPHONE_FIVE_FACTOR)];
            
        }
        
    }
}

-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark- UIButton Actions

-(IBAction)btnAddImageAction:(id)sender
{
    uploadButton = (UIButton *)sender;
    /* [self dismissActionSheets];
     
     if (nil == self.normalActionSheetDelegate)
     {
     self.normalActionSheetDelegate = [[NormalActionSheetDelegate alloc] init];
     self.normalActionSheetDelegate.normalDelegate = self;
     }
     
     if (nil == self.activeSheet)
     {
     UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Resource:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
     
     self.activeSheet = normalActionSheet;
     self.activeSheet.tag = AC_ACTIONSHEET_UPLOAD_PROFILE_PIC;
     }
     [self.activeSheet showFromRect:((UIButton*)sender).frame inView:[sender superview] animated:YES];*/
    
    ACAlertView *alert=[[ACAlertView alloc] initWithTitle:@"Select Resource" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Picture", nil];
    alert.tag=102;
    [alert show];
}

-(IBAction)btnUpdateProfileAction:(id)sender
{
    [tfFirstName resignFirstResponder];
    [tfLastName resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfContactNo resignFirstResponder];
    [tfAddress resignFirstResponder];
    [txtvwAboutMe resignFirstResponder];
    
    if(tfFirstName.text.length==0)
    {
        [ConfigManager showAlertMessage:@"" Message:ALERT_MSG_BLANK_FIRST_NAME];
        return;
    }
    else if(tfFirstName.text.length<3 || tfFirstName.text.length>20){
        [ConfigManager showAlertMessage:nil Message:@"First name should be 3-20 characters long"];
        return;
    }
    
    else if([ConfigManager stringContainsSpecialCharacters:tfFirstName.text])
    {
        [ConfigManager showAlertMessage:@"" Message:ALERT_MSG_SPECIAL_CHARACTERS];
        return;
    }
    else if(tfLastName.text.length==0)
    {
        [ConfigManager showAlertMessage:@"" Message:ALERT_MSG_BLANK_LAST_NAME];
        return;
    }
    else if([ConfigManager stringContainsSpecialCharacters:tfLastName.text])
    {
        [ConfigManager showAlertMessage:@"" Message:ALERT_MSG_SPECIAL_CHARACTERS];
        return;
    }
    
    else if(tfLastName.text.length<3 || tfLastName.text.length>20){
        [ConfigManager showAlertMessage:nil Message:@"last name should be 3-20 characters long"];
        return;
    }
    
    else if(tfContactNo.text.length == 0)
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_PHONE_ENTERED];
        return;
    }
    
    if([tfContactNo.text length]==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_PHONE_NO];
        return;
    }
    else if([ConfigManager stringContainsSpecialCharacters:tfContactNo.text]){
        [ConfigManager showAlertMessage:nil Message:@"Phone number should not contain special characters"];
        return;
    }
    else if(![ConfigManager validatePhoneNum:tfContactNo.text]){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_INVALID_PHONE_ENTERED];
        return;
    }
    
    else if([ConfigManager stringContainsSpecialCharacters:tfContactNo.text])
    {
        [ConfigManager showAlertMessage:@"" Message:ALERT_MSG_SPECIAL_CHARACTERS];
        return;
    }
    else if(tfAddress.text.length==0)
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_ADDRESS];
        return;
    }
    else if([ConfigManager stringContainsSpecialCharacters:tfAddress.text])
    {
        [ConfigManager showAlertMessage:@"" Message:ALERT_MSG_SPECIAL_CHARACTERS];
        return;
    }
    else if(txtvwAboutMe.text.length == 0 || [txtvwAboutMe.text isEqualToString:TXTVIEW_PLACEHOLDER])
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_ABOUT_ME_DESC];
        return;
    }
    else if([ConfigManager stringContainsSpecialCharacters:txtvwAboutMe.text])
    {
        [ConfigManager showAlertMessage:@"" Message:ALERT_MSG_SPECIAL_CHARACTERS];
        return;
    }
    
    @try
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:[ConfigManager trimmedString:tfFirstName.text] forKey:@"firstname"];
        [dict setValue:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dict setValue:[ConfigManager trimmedString:tfLastName.text] forKey:@"lastname"];
        [dict setValue:@"newImage" forKey:@"attachment_key"];
        [dict setValue:[ConfigManager trimmedString:tfAddress.text] forKey:@"address"];
        [dict setValue:[ConfigManager trimmedString:tfContactNo.text] forKey:@"phone_number"];
        [dict setValue:[ConfigManager trimmedString:txtvwAboutMe.text] forKey:@"description"];
        [dict setValue:sharedAppDelegate.userObj.image forKey:@"image"];
        [dict setValue:@"set_profile" forKey:@"request_path"];
        [dict setObject:@"image.jpg" forKey:@"filename"];
        
        NSData *imgData = UIImageJPEGRepresentation(imgProfilePic.image, 1);
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
        [[AmityCareServices sharedService] setProfileInvocation:dict imgData:imgData delegate:self];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)dismissActionSheets
{
    if (self.activeSheet)
    {
        if ([self.activeSheet isVisible])
        {
            [self.activeSheet dismissWithClickedButtonIndex:-1 animated:YES];
        }
        self.activeSheet = nil;
    }
}

#pragma mark- NormalActionSheetDelegate
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_UPLOAD_PROFILE_PIC)
    {
        
        if(buttonIndex==0)
        {
            //camera
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            if (IS_DEVICE_IPAD) {
                
                self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                [self.popover presentPopoverFromRect:uploadButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.imagePickerView = self.imagePickerController.view;
                
                CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                
                self.imagePickerView.frame = cameraViewFrame;
                
                [self.view addSubview:self.imagePickerView];
                
                //  [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            
        }
        else
        {
            //gallery
            if(buttonIndex==1)
            {
               self.imagePickerController = [[UIImagePickerController alloc] init];
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.imagePickerController.mediaTypes= [NSArray arrayWithObject:@"public.image"];
                self.imagePickerController.delegate = self;
                self.imagePickerController.allowsEditing = YES;
                if (IS_DEVICE_IPAD) {
                    
                    self.popover=[[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                    [self.popover presentPopoverFromRect:uploadButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else
                {
                    self.imagePickerView = self.imagePickerController.view;
                    
                    CGRect cameraViewFrame = CGRectMake(0, 0, 275, 470);
                    
                    self.imagePickerView.frame = cameraViewFrame;
                    
                    [self.view addSubview:self.imagePickerView];
                    // [self presentViewController:imagePickerController animated:YES completion:nil];
                }
            }
        }
    }
}

#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mType = [info valueForKey:UIImagePickerControllerMediaType];
    if([mType isEqualToString:@"public.image"])
    {
        _didPicUpdated = YES;
        UIImage *image = [((UIImage*)[info objectForKey:UIImagePickerControllerEditedImage]) imageByScalingAndCroppingForSize:CGSizeMake(800, 800)] ;
        imgProfilePic.image = image;
    }
    
    if (IS_DEVICE_IPAD) {
        
        [self.popover dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        
        // [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    if (IS_DEVICE_IPAD) {
        
        if(self.popover)
        {
            _didPicUpdated = NO;
            [self.popover dismissPopoverAnimated:YES];
        }
        
    }
    else
    {
        [self.imagePickerView removeFromSuperview];
        
        //  [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
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
            
            [UIView beginAnimations:@"anim" context: nil];
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
    [tfAddress resignFirstResponder];
    [tfFirstName resignFirstResponder];
    [tfLastName resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfContactNo resignFirstResponder];
    [txtvwAboutMe resignFirstResponder];
    
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [self scrollViewToCenterOfScreen:textView];
    
}
#pragma mark- UITextView
#pragma mark- UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:keyboardtoolbar];
    
    if (txtvwAboutMe.textColor == [UIColor lightGrayColor]) {
        txtvwAboutMe.text = @"";
        txtvwAboutMe.textColor = [UIColor darkGrayColor];
    }
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(txtvwAboutMe.text.length == 0)
    {
        txtvwAboutMe.text = TXTVIEW_PLACEHOLDER;
        txtvwAboutMe.textColor = [UIColor lightGrayColor];
        [txtvwAboutMe resignFirstResponder];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(!(textView.textColor == [UIColor lightGrayColor]))
    {
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        [textView resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        return NO;
        
    }
    
    
    return YES;
    
}
#pragma mark - Invocation
-(void)getProfileInvocationDidFinish:(GetProfileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    NSLog(@"getProfileInvocationDidFinish =%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                NSDictionary * uDict = [response valueForKey:@"User"];
                sharedAppDelegate.userObj.fname =NULL_TO_NIL( [uDict valueForKey:@"first_name"] );
                sharedAppDelegate.userObj.lname = NULL_TO_NIL([uDict valueForKey:@"last_name"]);
                sharedAppDelegate.userObj.username = NULL_TO_NIL([uDict valueForKey:@"username"]);
                sharedAppDelegate.userObj.email = NULL_TO_NIL([uDict valueForKey:@"email"]);
                sharedAppDelegate.userObj.phoneNo = NULL_TO_NIL([uDict valueForKey:@"phone_number"]);
                sharedAppDelegate.userObj.address = NULL_TO_NIL([uDict valueForKey:@"address"]);
                sharedAppDelegate.userObj.image = NULL_TO_NIL([uDict valueForKey:@"image"]);
                sharedAppDelegate.userObj.aboutMe = NULL_TO_NIL([uDict valueForKey:@"description"]);
                
                [self fillUserValues:sharedAppDelegate.userObj];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:@"Unable to get profile details."];
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

-(void)setProfileInvocationDidFinish:(SetProfileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    [DSBezelActivityView removeView];
    NSLog(@"setProfileInvocationDidFinish =%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                _didPicUpdated = NO;
                
                
                NSDictionary * uDict = [response valueForKey:@"User"];
                sharedAppDelegate.userObj.fname = NULL_TO_NIL([uDict valueForKey:@"first_name"]);
                sharedAppDelegate.userObj.lname = NULL_TO_NIL([uDict valueForKey:@"last_name"]);
                sharedAppDelegate.userObj.username = NULL_TO_NIL([uDict valueForKey:@"username"]);
                
                sharedAppDelegate.userObj.image = NULL_TO_NIL([uDict valueForKey:@"image"]);
                
                NSLog(@"Userobj.image %@",sharedAppDelegate.userObj.image);
                
                //            user.image = NULL_TO_NIL([uDict valueForKey:@"image"]);
                ARCHIEVE_USER_DATA;
                [standardUserDefault synchronize];
                ACAlertView* alertView = [ConfigManager alertView:nil message:@"Profile updated successfully" del:self];
                alertView.alertTag = AC_ALERTVIEW_PROFIE_UPDATED;
                [alertView show];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:@"Unable to get profile details."];
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


@end
