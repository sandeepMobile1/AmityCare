//
//  TaskDetailVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TaskDetailVC.h"
#import "AddNewTaskVC.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface TaskDetailVC ()<TaskStatusInvocationDelegate,UIAlertViewDelegate>

@end

@implementation TaskDetailVC
@synthesize taskObj,checkView;

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
    //  [self.view addSubview:navigation];
    
    /*if (!IS_DEVICE_IPAD) {
     
     if (DEVICE_OS_VERSION>=7) {
     
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     [scrollView setFrame:CGRectMake(0, 0, 320, 568)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [scrollView setFrame:CGRectMake(0, 0, 320, 568-IPHONE_FIVE_FACTOR)];
     
     }
     }
     else
     {
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     [scrollView setFrame:CGRectMake(0, 0, 320, 558)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [scrollView setFrame:CGRectMake(0, 0, 320, 558-IPHONE_FIVE_FACTOR)];
     
     }
     }
     
     }*/
    lblTaskTitle.font = [UIFont fontWithName:boldfontName size:20.0f];
    lblPostedBy.font = [UIFont fontWithName:appfontName size:12.0f];
    lblPostedOn.font = [UIFont fontWithName:appfontName size:12.0f];
    lblTaskDesc.font = [UIFont fontWithName:appfontName size:12.0f];
    
    [self setTaskDetails];
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
    [self setAttributedText:lblPostedBy];
    [self setAttributedText:lblPostedOn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- TopNavigation Delegate

-(void)leftBarButtonDidClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)rightBarButtonDidClicked:(id)sender{
    
    AddNewTaskVC* addTask;
    
    if (IS_DEVICE_IPAD) {
        
        addTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
        
    }
    else
    {
        addTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
        
    }
    
    
    
    [self.navigationController pushViewController:addTask animated:YES];
}

#pragma mark- Custom Methods

-(void)changeTaskStatusToCmplete
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating task status..." width:200];
        [[AmityCareServices sharedService] taskStatusInvocation:sharedAppDelegate.userObj.userId taskID:self.taskObj.taskId delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)btnCompleteAction:(id)sender
{
    if([ConfigManager isInternetAvailable]){
        
        NSLog(@"%@",self.taskObj.taskId);
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating task status..." width:200];
        [[AmityCareServices sharedService] taskStatusInvocation:sharedAppDelegate.userObj.userId taskID:self.taskObj.taskId delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(NSString*)shortDateStyle:(NSString*)strDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc ] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [df dateFromString:strDate];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    return [df stringFromDate:date];
}

-(void)setTaskDetails
{
    
    lblTaskTitle.text = self.taskObj.taskTitle;
    lblPostedBy.text = [NSString stringWithFormat:@"Posted By: %@",self.taskObj.mngrName];
    
    if ([self.checkView isEqualToString:@"calender"]) {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *tdate = [df dateFromString:self.taskObj.taskDate];
        
        lblPostedOn.text = [NSString stringWithFormat:@"Posted On: %@",[self shortStyleDate:tdate]];
        
        // lblPostedOn.text = [NSString stringWithFormat:@"Posted On: %@",self.taskObj.taskDate];
        
    }
    else
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *tdate = [df dateFromString:self.taskObj.taskDate];
        
        lblPostedOn.text = [NSString stringWithFormat:@"Posted On: %@",[self shortStyleDate:tdate]];
        
        
        // lblPostedOn.text = [NSString stringWithFormat:@"Posted On: %@",[self shortDateStyle:self.taskObj.taskDate]];
        
    }
    lblTaskDesc.text = self.taskObj.taskDesc;
    
    //lblPostedOn.text = [self shortDateStyle:self.taskObj.taskDate];
    int height;
    
    if (IS_DEVICE_IPAD) {
        
        height = [ConfigManager getLabelHeight:lblTaskDesc constrainedSize:CGSizeMake(390, 9999) text:self.taskObj.taskDesc];
    }
    else
    {height = [ConfigManager getLabelHeight:lblTaskDesc constrainedSize:CGSizeMake(280, 9999) text:self.taskObj.taskDesc];
        
    }
    
    CGRect frame = lblTaskDesc.frame;
    frame.size.height = height;
    lblTaskDesc.frame = frame;
    lblTaskDesc.numberOfLines = ceil(height/lblTaskDesc.font.pointSize);
    lblTaskDesc.text = self.taskObj.taskDesc;
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

-(void)setAttributedText:(UILabel*)label
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: label.attributedText];
    [text addAttribute: NSForegroundColorAttributeName value: [UIColor darkGrayColor] range: NSMakeRange(0, 11)];
    [label setAttributedText: text];
}

#pragma mark- UIAlertView

-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_TASK_STATUS_CHANGED){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_ADD_TASK_UPDATE object:nil];
        
        [self.view removeFromSuperview];
    }
}

#pragma mark- Invocation

-(void)taskStatusInvocationDidFinish:(TaskStatusInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"taskStatusInvocationDidFinish");
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0){
                ACAlertView* alert = [ConfigManager alertView:nil message:@"Status Changed Successfully" del:self];
                alert.alertTag = AC_ALERTVIEW_TASK_STATUS_CHANGED;
                [alert show];
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
                [ConfigManager showAlertMessage:nil Message:@"Status not updated"];
                
            }
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :::::: %@",exception);
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


@end
