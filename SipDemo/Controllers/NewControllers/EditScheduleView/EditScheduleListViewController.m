//
//  EditScheduleListViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 13/03/15.
//
//

#import "EditScheduleListViewController.h"
#import "ActionSheetPicker.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface EditScheduleListViewController ()

@end

@implementation EditScheduleListViewController

@synthesize pData,startDateStr,endDateStr,startDate,endDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startDateStr=@"";
    self.endDateStr=@"";
    
    self.startDate=nil;
    self.endDate=nil;
    
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
    
    [self fillScheduleValues];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}

-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)fillScheduleValues
{
    txtUserName.text = self.pData.userName;
    txtTagName.text = self.pData.userClockInTag;
    
    txtClockInTime.text = pData.userClockInTime;
    
    if ([pData.userEditedClockOutTime isEqualToString:@""]) {
        
        if ([pData.userClockOutTime isEqualToString:@""]) {
            
            txtClockOutTime.text = pData.userClockOutAddress;
            
        }
        else
        {
            txtClockOutTime.text = pData.userClockOutTime;
            
        }
        
    }
    else
    {
        txtClockOutTime.text = pData.userEditedClockOutTime;
        
    }
    
    self.startDateStr=pData.userClockInCreatedTime;
    self.endDateStr=pData.userClockOutCreatedTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.startDate = [[NSDate alloc] init];
    self.startDate = [dateFormatter dateFromString:self.startDateStr];
    
    NSLog(@"%@",self.startDateStr);
    
    NSLog(@"%@",self.startDate);
    
    
    self.endDate = [[NSDate alloc] init];
    self.endDate = [dateFormatter dateFromString:self.endDateStr];
    
    NSLog(@"%@",self.endDate);
    
    
    
}
-(void)createEditView
{
    
}
-(NSString*)shortStyleDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString* shortDate = [df stringFromDate:date];
    return shortDate;
}
-(IBAction)btnUpdateScheduleAction:(id)sender
{
    [txtClockInTime resignFirstResponder];
    [txtClockOutTime resignFirstResponder];
    
    if (self.startDateStr==nil || self.endDateStr==(NSString*)[NSNull null]) {
        
        self.startDateStr=@"";
    }
    if (self.endDateStr==nil || self.endDateStr==(NSString*)[NSNull null]) {
        
        self.endDateStr=@"";
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dict setValue:pData.postId forKey:@"udateId"];
    [dict setValue:pData.tagId forKey:@"tag_id"];
    [dict setValue:self.startDateStr forKey:@"start_date"];
    [dict setValue:self.endDateStr forKey:@"end_date"];
    
    NSLog(@"%@",dict);
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
    [[AmityCareServices sharedService] UpdateScheduleInvocation:dict delegate:self];
    
}

-(void)UpdateScheduleInvocationDidFinish:(UpdateScheduleInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict valueForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: AC_SCHEDULE_UPDATE object:nil];
            
            
        }
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Updated successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        [self.view removeFromSuperview];
    }
}
#pragma mark- UITextField Delegate

-(void)selectDate:(id)sender
{
    [txtClockInTime resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    self.startDateStr=dateStr;
    
    self.startDate = [dateformate dateFromString:dateStr];
    
    NSLog(@"StartDate is %@",[dateformate stringFromDate:self.startDate]);
    NSLog(@"EndDate is %@",[dateformate stringFromDate:self.endDate]);
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Clockin time should be less than clockout time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    
    NSLog(@"%@",dateStr);
    
    NSString* strDate = [self shortStyleDate:date];
    txtClockInTime.text = strDate;
}
-(void)selectEndDate:(id)sender
{
    [txtClockOutTime resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    NSLog(@"%@",dateStr);
    self.endDateStr=dateStr;
    
    self.endDate = [dateformate dateFromString:dateStr];
    
    
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Clockout time should be greater than clockin time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    
    NSString* strDate = [self shortStyleDate:date];
    txtClockOutTime.text = strDate;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:txtClockInTime])
    {
        if (IS_DEVICE_IPAD) {
            
            [ActionSheetPicker displayActionPickerWithView:txtClockInTime datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(selectDate:) title:@"Select Clock In Date"];
            
        }
        else
        {
            
            [self showDatePicker];
            [textField resignFirstResponder];
            
            
        }
        
        
        //return FALSE;
    }
    else
    {
        if (IS_DEVICE_IPAD) {
            
            [ActionSheetPicker displayActionPickerWithView:txtClockOutTime datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(selectEndDate:) title:@"Select Clock Out Date"];
            
        }
        else
        {
            
            [self showEndDatePicker];
            [textField resignFirstResponder];
            
            
        }
        
        
        //return FALSE;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        
        [textField resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
    }
    
    return YES;
}
-(void)showDatePicker
{
    [toolbar removeFromSuperview];
    [datePicker removeFromSuperview];
    
    toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(done)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    [self.view addSubview:datePicker];
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 150.0+IPHONE_FIVE_FACTOR, 275.0, 44.0)];
        datePicker.frame=CGRectMake(0,194+IPHONE_FIVE_FACTOR,275, 216);
        
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 150.0, 275, 44.0)];
        
        datePicker.frame=CGRectMake(0,194,275, 216);
        
    }
    
}
-(void)showEndDatePicker
{
    [toolbar removeFromSuperview];
    [datePicker removeFromSuperview];
    
    toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(EndDone)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    [self.view addSubview:datePicker];
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 150.0+IPHONE_FIVE_FACTOR, 275.0, 44.0)];
        datePicker.frame=CGRectMake(0,194+IPHONE_FIVE_FACTOR,275, 216);
        
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 150.0, 275, 44.0)];
        
        datePicker.frame=CGRectMake(0,194,275, 216);
        
    }
    
}
-(IBAction)cancel
{
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [txtClockInTime resignFirstResponder];
    [txtClockOutTime resignFirstResponder];
    
}
-(IBAction)done
{
    
    NSDate *date = datePicker.date;
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateformate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    self.startDateStr=dateStr;
    
    self.startDate = [dateformate dateFromString:dateStr];
    
    NSLog(@"StartDate is %@",[dateformate stringFromDate:self.startDate]);
    NSLog(@"EndDate is %@",[dateformate stringFromDate:self.endDate]);
    
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Clockin time should be less than clockout time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    //  self.startDateStr=dateStr;
    
    NSString* strDate = [self shortStyleDate:date];
    txtClockInTime.text = strDate;
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    [txtClockInTime resignFirstResponder];
    [txtClockOutTime resignFirstResponder];
    
    
}
-(IBAction)EndDone
{
    
    NSDate *date = datePicker.date;
    
    //self.endDate=date;
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    self.endDateStr=dateStr;
    self.endDate = [dateformate dateFromString:dateStr];
    
    NSLog(@"self.endDate %@",self.endDate);
    
    NSLog(@"StartDate is %@",[dateformate stringFromDate:self.startDate]);
    NSLog(@"EndDate is %@",[dateformate stringFromDate:self.endDate]);
    
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Clockout time should be greater than clockin time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    NSString* strDate = [self shortStyleDate:date];
    txtClockOutTime.text = strDate;
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    [txtClockInTime resignFirstResponder];
    [txtClockOutTime resignFirstResponder];
    
    
}
#pragma mark- UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
        
    }
    
    return TRUE;
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
