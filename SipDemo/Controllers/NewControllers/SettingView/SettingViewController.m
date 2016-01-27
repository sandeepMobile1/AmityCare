//
//  SettingViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ConfigManager.h"
#import "UIImageExtras.h"
#import "UIImageView+WebCache.h"
#import "ProfileDetailVC.h"
#import "ProfileViewController.h"
#import "UpdateAppPinVC.h"
#import "UserHomeViewController.h"
#import "ChangePasswordVC.h"
#import "TagAsignViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize arrSettingList,objProfileDetailVC,objChangePasswordVC,objProfileViewController,objTagAsignViewController,objUpdateAppPinVC,mailComposer,mailView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                    
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                    
                }
                else
                {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 886)];
                    
                }
            }
            else if([sharedAppDelegate.userObj.role isEqualToString:@"3"])
            {
                if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                    
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                    
                }
                else
                {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 855)];
                    
                }
            }
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                
            }
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        
        //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
        
        self.arrSettingList=[[NSMutableArray alloc] initWithObjects:@"Assign tags to users",@"My Profile",@"Edit Profile",@"Change Password",@"Update Pin",@"Feedback",@"Notifications",@"Logout", nil];
        
    }
    else
    {
        self.arrSettingList=[[NSMutableArray alloc] initWithObjects:@"My Profile",@"Edit Profile",@"Change Password",@"Update Pin",@"Feedback",@"Notifications",@"Logout", nil];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }}
#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSettingList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* settingCellIdentifier = @"FeedListCell";
    
    UITableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
    
    if(!settingCell)
    {
        settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:settingCellIdentifier];
        
        [settingCell setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lblName=[[UILabel alloc] init];
        [lblName setFrame:CGRectMake(10, 5,400,35)];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setFont:[UIFont systemFontOfSize:14]];
        [lblName setTag:2];
        
        if(DEVICE_OS_VERSION_7_0)
            [settingCell.contentView addSubview:lblName];
        else
            [settingCell addSubview:lblName];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            if (indexPath.row==6) {
                
                [lblName setFrame:CGRectMake(10, 5,100,35)];
                notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160, 5, 80, 0)];
                
                [notificationSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                
                [settingCell addSubview:notificationSwitch];
                
                NSLog(@"%@",sharedAppDelegate.userObj.notification_status);
                
                if (sharedAppDelegate.userObj.notification_status==nil || sharedAppDelegate.userObj.notification_status==(NSString*)[NSNull null] || [sharedAppDelegate.userObj.notification_status isEqualToString:@""] || [sharedAppDelegate.userObj.notification_status isEqualToString:@"1"]) {
                    
                    [notificationSwitch setOn:YES];
                }
                else
                {
                    [notificationSwitch setOn:NO];
                }
                
            }
            
        }
        else
        {
            if (indexPath.row==5) {
                
                [lblName setFrame:CGRectMake(10, 5,100,35)];
                notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160, 5, 80, 0)];
                
                [notificationSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                
                [settingCell addSubview:notificationSwitch];
                
                NSLog(@"%@",sharedAppDelegate.userObj.notification_status);
                
                if (sharedAppDelegate.userObj.notification_status==nil || sharedAppDelegate.userObj.notification_status==(NSString*)[NSNull null] || [sharedAppDelegate.userObj.notification_status isEqualToString:@""] || [sharedAppDelegate.userObj.notification_status isEqualToString:@"1"]) {
                    
                    [notificationSwitch setOn:YES];
                }
                else
                {
                    [notificationSwitch setOn:NO];
                }
                
            }
        }
        
    }
    
    UILabel *lbl=(UILabel*)[settingCell viewWithTag:2];
    [lbl setText:[self.arrSettingList objectAtIndex:indexPath.row]];
    
    
    return settingCell;
    
}
- (void)changeSwitch:(id)sender{
    
    if([sender isOn]){
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dic setObject:@"1" forKey:@"notification_status"];
            
            
            [[AmityCareServices sharedService] SettingNotificationInvocation:dic delegate:self];
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
        
    } else{
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dic setObject:@"0" forKey:@"notification_status"];
            
            
            [[AmityCareServices sharedService] SettingNotificationInvocation:dic delegate:self];
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
        
        if (indexPath.row==0) {
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objTagAsignViewController = [[TagAsignViewController alloc]initWithNibName:@"TagAsignViewController" bundle:nil];
            }
            else
            {
                self.objTagAsignViewController = [[TagAsignViewController alloc]initWithNibName:@"TagAsignViewController_iphone" bundle:nil];
            }
            self.objTagAsignViewController.checkView=FALSE;
            
            [self.view addSubview:self.objTagAsignViewController.view];
        }
        else if (indexPath.row==1) {
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objProfileDetailVC=[[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC" bundle:nil];
                
            }
            else
            {
                self.objProfileDetailVC=[[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC_iphone" bundle:nil];
                
            }
            
            self.objProfileDetailVC.userid=sharedAppDelegate.userObj.userId;
            self.objProfileDetailVC.checkLocationProfile=TRUE;

            [self.view addSubview:self.objProfileDetailVC.view];
            
            
        }
        else if (indexPath.row==2) {
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objProfileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
                
            }
            else
            {
                self.objProfileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController_iphone" bundle:nil];
                
            }
            
            self.objProfileViewController.userid=sharedAppDelegate.userObj.userId;
            
            [self.view addSubview:self.objProfileViewController.view];
            
            
            
        }
        else if (indexPath.row==3) {
            
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objChangePasswordVC=[[ChangePasswordVC alloc] initWithNibName:@"ChangePasswordVC" bundle:nil];
                
            }
            else
            {
                self.objChangePasswordVC=[[ChangePasswordVC alloc] initWithNibName:@"ChangePasswordVC_iphone" bundle:nil];
                
            }
            
            
            [self.view addSubview:self.objChangePasswordVC.view];
            
            
        }
        else if (indexPath.row==4) {
            
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objUpdateAppPinVC=[[UpdateAppPinVC alloc] initWithNibName:@"UpdateAppPinVC" bundle:nil];
                
            }
            else
            {
                self.objUpdateAppPinVC=[[UpdateAppPinVC alloc] initWithNibName:@"UpdateAppPinVC_iphone" bundle:nil];
                
            }
            
            [self.view addSubview:self.objUpdateAppPinVC.view];
            
            
        }
        else if (indexPath.row==5) {
            
            if(self.mailComposer!=Nil){
                self.mailComposer = Nil;
            }
            self.mailComposer = [[MFMailComposeViewController alloc] init];
            self.mailComposer.mailComposeDelegate = self ;
            if([MFMailComposeViewController canSendMail])
            {
                [self.mailComposer setToRecipients:[NSArray arrayWithObject:[NSString stringWithFormat:@"info@amitycare.com"]]];
                [self.mailComposer setCcRecipients:[NSArray arrayWithObject:@""]];
                [self.mailComposer setMessageBody:[NSString stringWithFormat:@""] isHTML:YES];
                
                [self presentViewController:self.mailComposer animated:YES completion:nil];

                
            }
            
        }
        else if (indexPath.row==6) {}
        else
        {
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
            alertView.tag = 101;
            [alertView show];
            
        }
        
    }
    else
    {
        if (indexPath.row==0) {
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objProfileDetailVC=[[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC" bundle:nil];
                
            }
            else
            {
                self.objProfileDetailVC=[[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC_iphone" bundle:nil];
                
            }
            
            self.objProfileDetailVC.userid=sharedAppDelegate.userObj.userId;
            self.objProfileDetailVC.isAvailable=YES;

            self.objProfileDetailVC.checkLocationProfile=TRUE;

            [self.view addSubview:self.objProfileDetailVC.view];
            
            
        }
        else if (indexPath.row==1) {
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objProfileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
                
            }
            else
            {
                self.objProfileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController_iphone" bundle:nil];
                
            }
            
            self.objProfileViewController.userid=sharedAppDelegate.userObj.userId;
            
            [self.view addSubview:self.objProfileViewController.view];
            
            
            
        }
        else if (indexPath.row==2) {
            
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objChangePasswordVC=[[ChangePasswordVC alloc] initWithNibName:@"ChangePasswordVC" bundle:nil];
                
            }
            else
            {
                self.objChangePasswordVC=[[ChangePasswordVC alloc] initWithNibName:@"ChangePasswordVC_iphone" bundle:nil];
                
            }
            
            
            [self.view addSubview:self.objChangePasswordVC.view];
            
            
        }
        else if (indexPath.row==3) {
            
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objUpdateAppPinVC=[[UpdateAppPinVC alloc] initWithNibName:@"UpdateAppPinVC" bundle:nil];
                
            }
            else
            {
                self.objUpdateAppPinVC=[[UpdateAppPinVC alloc] initWithNibName:@"UpdateAppPinVC_iphone" bundle:nil];
                
            }
            
            [self.view addSubview:self.objUpdateAppPinVC.view];
            
            
        }
        else if (indexPath.row==4) {
            
            if(self.mailComposer!=Nil){
                self.mailComposer = Nil;
            }
            self.mailComposer = [[MFMailComposeViewController alloc] init];
            self.mailComposer.mailComposeDelegate = self ;
            if([MFMailComposeViewController canSendMail])
            {
                [self.mailComposer setToRecipients:[NSArray arrayWithObject:[NSString stringWithFormat:@"info@amitycare.com"]]];
                [self.mailComposer setCcRecipients:[NSArray arrayWithObject:@""]];
                [self.mailComposer setMessageBody:[NSString stringWithFormat:@""] isHTML:YES];
                
                
                if (IS_DEVICE_IPAD) {
                    
                    [self presentViewController:self.mailComposer animated:YES completion:nil];
                    
                }
                else
                {
                    self.mailView=self.mailComposer.view;
                    
                    CGRect mailViewFrame = CGRectMake(0, 0, 275, 470);
                    
                    self.mailView.frame = mailViewFrame;
                    
                    [self.view addSubview:self.mailView];
                }
                
                
                
            }
            
        }
        else if (indexPath.row==5) {}
        else
        {
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
            alertView.tag = 101;
            [alertView show];
            
        }
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex==0)
        {
            if([ConfigManager isInternetAvailable])
            {
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Logging Out..." width:150];
                AmityCareServices *service = [[AmityCareServices alloc] init];
                [service logoutInvocation:sharedAppDelegate.userObj.userId delegate:self];
            }
            
            else
            {
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
        }
    }
    
}
#pragma mark- Mail Composer
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            [ConfigManager alertViewWithButtonTitle:nil Message:@"Your E-mail has been cancelled" okBtnTitle:@"Ok"];
            break;
        case MFMailComposeResultSaved:
            [ConfigManager alertViewWithButtonTitle:nil Message:@"Your E-mail has been saved" okBtnTitle:@"Ok"];
            break;
        case MFMailComposeResultSent:
            [ConfigManager alertViewWithButtonTitle:nil Message:@"Your E-mail has been sent" okBtnTitle:@"Ok"];
            break;
        case MFMailComposeResultFailed:
            [ConfigManager alertViewWithButtonTitle:nil Message:@"E-mail has been failed" okBtnTitle:@"Ok"];
            break;
        default:
            break;
    }
    
    if (IS_DEVICE_IPAD) {
        
        [controller dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        [self.mailView removeFromSuperview];
        
    }
    
}
#pragma mark- Invocation Delegates
-(void)logoutInvocationDidFinish:(LogoutInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        if(!error)
        {
            NSLog(@"Logout response=%@", dict);
            
            id response = [dict objectForKey:@"response"];
            
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    [sharedAppDelegate logoutFromApp];
                }
                else if([strSuccess rangeOfString:@"false"].length>0){
                    [ConfigManager showAlertMessage:nil Message:@"Logout Failed"];
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
-(void)SettingNotificationInvocationDidFinish:(SettingNotificationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        if(!error)
        {
            
            id response = [dict objectForKey:@"response"];
            
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString* strSuccess = [response valueForKey:@"success"];
                NSString* strStatus = [response valueForKey:@"notification_status"];
                
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    if ([strStatus isEqualToString:@"1"]) {
                        
                        sharedAppDelegate.userObj.notification_status=strStatus;
                        
                        [notificationSwitch setOn:YES];
                    }
                    else
                    {
                        sharedAppDelegate.userObj.notification_status=strStatus;
                        
                        [notificationSwitch setOn:NO];
                        
                        
                    }
                }
                else if([strSuccess rangeOfString:@"false"].length>0){
                    
                    [ConfigManager showAlertMessage:nil Message:@"notification setting Failed"];
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
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
