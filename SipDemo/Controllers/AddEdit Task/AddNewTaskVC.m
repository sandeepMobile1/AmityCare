//
//  AddNewTaskVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "AddNewTaskVC.h"
#import <QuartzCore/QuartzCore.h>
#import "TagSelectionVC.h"
#import "ActionSheetPicker.h"
#import "UserSelectionVC.h"
#import "Tags.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "AddTaskInvocation.h"
#import "EditTaskInvocation.h"
#import "UserSelectionVC.h"

@interface AddNewTaskVC ()<TagSelectionDelegate,UserSelectionDelegate,AddTaskInvocationDelegate,EditTaskInvocationDelegate>

@end

@implementation AddNewTaskVC
@synthesize delegate,tagS,usvc;
/* For edit task case */
@synthesize isEditTask;
@synthesize taskDetails,selectedDate,selectedTag,selectedTagId,serverDate,repeatStr;

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
    
    tvTaskDesc.text = @"Task Description";
    tvTaskDesc.textColor = [UIColor lightGrayColor];
    
    tvTaskDesc.layer.borderWidth = 1.0f;
    tvTaskDesc.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.5] CGColor];
    tvTaskDesc.clipsToBounds = YES;
    
    arrTagsD = [[NSMutableArray alloc] init];
    arrSelUsersD = [[NSMutableArray alloc] init];
    
    [tfTaskDate setUserInteractionEnabled:TRUE];
    [tfTaskAssoTags setUserInteractionEnabled:TRUE];
    [tfTaskAssoUsers setUserInteractionEnabled:TRUE];
    [btnAssociatedTag setHidden:FALSE];
    [btnAssociateUsers setHidden:FALSE];
    
    
    [self layoutLoginSubviews];
    
    if(self.isEditTask)
    {
        [self  fillTaskDetailsWhileEditing];
    }
    else
    {
        if (self.selectedDate==nil || self.selectedDate==(NSString*)[NSNull null] || [self.selectedDate isEqualToString:@""]) {
            
        }
        else
        {
            if (self.selectedTag==nil || self.selectedTag==(NSString*)[NSNull null] || [self.selectedTag isEqualToString:@""]) {
                
                tfTaskDate.text=self.selectedDate;
                
            }
            else
            {
                tfTaskDate.text=self.selectedDate;
                tfTaskAssoTags.text=self.selectedTag;
                [btnAssociatedTag setHidden:TRUE];
                
                [tfTaskAssoTags setUserInteractionEnabled:FALSE];
                
            }
        }
    }
    
    NSLog(@"%@",tfTaskDate.text);
    
    /*if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]) {
     
     [tfTaskAssoUsers setUserInteractionEnabled:TRUE];
     [btnAssociateUsers setHidden:FALSE];
     }
     else
     {
     [tfTaskAssoUsers setUserInteractionEnabled:FALSE];
     [btnAssociateUsers setHidden:TRUE];
     
     
     }*/
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 500)];
    
    [sharedAppDelegate startUpdatingLocation];
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
    [tfTaskDate resignFirstResponder];
    [tfTaskAssoTags resignFirstResponder];
    [tfTaskAssoUsers resignFirstResponder];
    [tfTaskTitle resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*-(void)dealloc
{
    NSLog(@"#$$#$# == %@== Dealloc",[self class]);
    tfTaskAssoTags = nil;
    tfTaskAssoUsers = nil;
    tfTaskDate = nil;
    tfTaskTitle = nil;
    [arrSelUsersD removeAllObjects];
    [arrTagsD removeAllObjects];
    
    [super dealloc];
}*/

#pragma mark- LayoutSubviews
-(void)layoutLoginSubviews
{
    for (id tempView in [self.view subviews]) {
        if([tempView isKindOfClass:[UITextField class]]){
            [self addPaddingOnTextFields:(UITextField*)tempView];
        }
    }
    
    lblRepeatOpt.font = [UIFont fontWithName:appfontName size:15.0f];
    tfTaskTitle.font = [UIFont fontWithName:appfontName size:15.0f];
    tfTaskDate.font = [UIFont fontWithName:appfontName size:15.0f];
    tfTaskAssoTags.font = [UIFont fontWithName:appfontName size:15.0f];
    tfTaskAssoUsers.font = [UIFont fontWithName:appfontName size:15.0f];
    tvTaskDesc.font = [UIFont fontWithName:appfontName size:15.0f];
    btnSubmitTask.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
}

-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark- IBActions & Custom Actions

-(void)fillTaskDetailsWhileEditing
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *tdate = [df dateFromString:self.taskDetails.taskDate];
    
    NSString *dateStr = [df stringFromDate:tdate]; // Convert date
    
    NSLog(@"%@",dateStr);
    
    self.serverDate=dateStr;
    
    tfTaskTitle.text = self.taskDetails.taskTitle;
    tfTaskDate.text = [self shortStyleDate:tdate];
    
    tfTaskAssoTags.text = [self getSelectedTagsTitles:self.taskDetails.arrTags];
    tfTaskAssoUsers.text = [self getSelectedUserNames:self.taskDetails.arrAssignUser];
    tvTaskDesc.text = self.taskDetails.taskDesc;
    
    if (self.taskDetails.taskReminder==nil || self.taskDetails.taskReminder==(NSString*)[NSNull null] || [self.taskDetails.taskReminder isEqualToString:@""]|| [self.taskDetails.taskReminder isEqualToString:@"0"]) {
        
        [btnOneHour setSelected:YES];
        [btnFifteenMin setSelected:NO];
    }
    else
    {
        if ([self.taskDetails.taskReminder isEqualToString:@"60"]) {
            
            [btnOneHour setSelected:YES];
            [btnFifteenMin setSelected:NO];
            
        }
        else
        {
            [btnOneHour setSelected:NO];
            [btnFifteenMin setSelected:YES];
            
        }
    }
    
    if (self.taskDetails.assignedToSelf==nil || self.taskDetails.assignedToSelf==(NSString*)[NSNull null] || [self.taskDetails.assignedToSelf isEqualToString:@""]|| [self.taskDetails.assignedToSelf isEqualToString:@"0"]) {
        
        [btnSelf setSelected:NO];
    }
    else
    {
        [btnSelf setSelected:YES];
    }
    
    if ([self.taskDetails.repeatStatus isEqualToString:@"1"]) {
        
        [switchRepeatOpt setOn:YES animated:YES];
    }
    else
    {
        [switchRepeatOpt setOn:NO animated:YES];
        
    }
    
    if(self.taskDetails.taskDesc.length>0){
        tvTaskDesc.textColor = [UIColor blackColor];
    }
    
    arrTagsD = arrSelUsersD = nil;
    
    arrTagsD = [[NSMutableArray alloc] initWithArray:self.taskDetails.arrTags];
    arrSelUsersD = [[NSMutableArray alloc] initWithArray:self.taskDetails.arrAssignUser];
    
    
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

-(void)selectDate:(id)sender
{
    [tfTaskDate resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *today  = [df2 dateFromString:[df2 stringFromDate:[NSDate date]]];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    //NSLog(@"compare srestult =%ld",[today compare:date]);
    
    if ([today compare:date]==NSOrderedDescending) {
        tfTaskDate.text = @"";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"You can only add future task" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    NSLog(@"%@",dateStr);
    
    self.serverDate=dateStr;
    
    NSString* strDate = [self shortStyleDate:date];
    tfTaskDate.text = strDate;
}

-(NSString*)getSelectedTags:(NSMutableArray*)tagsArray
{
    @try {
        NSString *ids = @"";
        unsigned long int i=0;
        for (Tags* t in tagsArray) {
            
            if(t.isSelected){
                ids = [ids stringByAppendingFormat:@"%@,",t.tagId];
            }
            i++;
        }
        if([ids length]>0){
            ids = [ids substringToIndex:([ids length]-1)];
        }
        NSLog(@"Selected Tags ids=%@",ids);
        return ids;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ::::::::: geting selected tags=%@",[exception debugDescription]);
    }
}

-(NSString*)getSelectedUser:(NSMutableArray*)usersArray
{
    @try {
        
        NSString *ids = @"";
        unsigned long int i=0;
        for (User* u in usersArray) {
            if(u.isSelected)
                ids = [ids stringByAppendingFormat:@"%@,",u.userId];
            
            i++;
        }
        if([ids length]>0){
            ids = [ids substringToIndex:([ids length]-1)];
            
            
        }
        
        if (ids.length>0) {
            
            if (btnSelf.selected) {
                
                ids=[ids stringByAppendingFormat:@",%@",sharedAppDelegate.userObj.userId];
            }
        }
        else
        {
            ids=[NSString stringWithFormat:@"%@",sharedAppDelegate.userObj.userId];
            
        }
        
        
        NSLog(@"Selected users ids=%@",ids);
        return ids;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ::::::::: geting selected Users=%@",[exception debugDescription]);
        
    }
}

-(NSString*)getSelectedTagsTitles:(NSMutableArray*)tagsArray
{
    @try {
        NSString *ids = @"";
        unsigned long int i=0;
        for (Tags* t in tagsArray) {
            
            if(t.isSelected){
                ids = [ids stringByAppendingFormat:@"%@,",t.tagTitle];
            }
            i++;
        }
        if([ids length]>0){
            ids = [ids substringToIndex:([ids length]-1)];
        }
        NSLog(@"Selected Tags ids=%@",ids);
        return ids;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ::::::::: geting selected tags=%@",[exception debugDescription]);
    }
}

-(NSString*)getSelectedUserNames:(NSMutableArray*)usersArray
{
    @try {
        
        NSString *ids = @"";
        unsigned long int i=0;
        for (User* u in usersArray) {
            if(u.isSelected)
                ids = [ids stringByAppendingFormat:@"%@,",u.username];
            
            i++;
        }
        if([ids length]>0){
            ids = [ids substringToIndex:([ids length]-1)];
        }
        
        NSLog(@"Selected users ids=%@",ids);
        return ids;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ::::::::: geting selected Users=%@",[exception debugDescription]);
        
    }
    
}
-(IBAction)btnSelfPressed:(id)sender
{
    if ([btnSelf isSelected]) {
        
        [btnSelf setSelected:NO];
    }
    else
    {
        [btnSelf setSelected:YES];
    }
}

-(IBAction)submitTaskAction:(id)sender
{
    [tfTaskTitle resignFirstResponder];
    [tfTaskDate resignFirstResponder];
    [tfTaskAssoTags resignFirstResponder];
    [tfTaskAssoUsers resignFirstResponder];
    [tvTaskDesc resignFirstResponder];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    if (tfTaskTitle.text.length ==0) {
        [ConfigManager showAlertMessage:Nil Message:@"Task title is required"];
        return;
    }
    else if (tfTaskDate.text.length == 0) {
        [ConfigManager showAlertMessage:Nil Message:@"Task Date & Time is required"];
        return;
    }
    else if (tfTaskAssoTags.text.length == 0) {
        [ConfigManager showAlertMessage:Nil Message:@"Tags required"];
        return;
    }
    else if (tfTaskAssoUsers.text.length == 0 && btnSelf.selected==NO) {
        [ConfigManager showAlertMessage:Nil Message:@"Assign Users for task"];
        return;
    }
    
    else if (tvTaskDesc.text.length == 0 || [tvTaskDesc.text isEqualToString:@"Task Description"]) {
        [ConfigManager showAlertMessage:Nil Message:@"Task description is required"];
        return;
    }
    
    NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init];
    [tDict setObject:sharedAppDelegate.userObj.userId forKey:@"manager_id"];
    [tDict setObject:tfTaskTitle.text forKey:@"title"];
    [tDict setObject:tvTaskDesc.text forKey:@"description"];
    
    if (switchRepeatOpt.isOn) {
        
        [tDict setObject:@"1" forKey:@"repeat_option"];
        
    }
    else
    {
        [tDict setObject:@"0" forKey:@"repeat_option"];
        
    }
    
    //[tDict setObject:[NSString stringWithFormat:@"%d",switchRepeatOpt.isOn] forKey:@"repeat_option"];
    
    
    if([ConfigManager isInternetAvailable]){
        if(self.isEditTask)
        {
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Saving task..." width:200];
            
            [tDict setObject:[self getSelectedTags:arrTagsD] forKey:@"tags"];
            
            [tDict setObject:[self getSelectedUser:arrSelUsersD] forKey:@"users"];
            
            [tDict setObject:self.taskDetails.taskId forKey:@"task_id"];
            
            [tDict setObject:self.serverDate forKey:@"taskCreatedDate"];
            
            if ([btnOneHour isSelected]) {
                
                [tDict setObject:@"60" forKey:@"reminder"];
                
            }
            else
            {
                [tDict setObject:@"15" forKey:@"reminder"];
                
            }
            
            
            [[AmityCareServices sharedService] editTaskInvocation:tDict delegate:self];
        }
        else{
            
            //Add New task
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Saving task..." width:200];
            
            if (self.selectedDate==nil || self.selectedDate==(NSString*)[NSNull null] || [self.selectedDate isEqualToString:@""]) {
                
                [tDict setObject:[self getSelectedTags:arrTagsD] forKey:@"tags"];
                [tDict setObject:[self getSelectedUser:arrSelUsersD] forKey:@"users"];
                
                
            }
            else
            {
                if (self.selectedTag==nil || self.selectedTag==(NSString*)[NSNull null] || [self.selectedTag isEqualToString:@""]) {
                    
                    [tDict setObject:[self getSelectedTags:arrTagsD] forKey:@"tags"];
                    [tDict setObject:[self getSelectedUser:arrSelUsersD] forKey:@"users"];
                    
                    // [tDict setObject:sharedAppDelegate.userObj.userId forKey:@"users"];
                    
                }
                else
                {
                    [tDict setObject:self.selectedTagId forKey:@"tags"];
                    [tDict setObject:[self getSelectedUser:arrSelUsersD] forKey:@"users"];
                    
                    // [tDict setObject:sharedAppDelegate.userObj.userId forKey:@"users"];
                    
                }
                
            }
            
            [tDict setObject:self.serverDate forKey:@"taskCreatedDate"];
            
            if ([btnOneHour isSelected]) {
                
                [tDict setObject:@"60" forKey:@"reminder"];
                
            }
            else
            {
                [tDict setObject:@"15" forKey:@"reminder"];
                
            }
            
            
            NSLog(@"%@",tDict);
            
            
            [[AmityCareServices sharedService] addNewTaskInvocation:tDict delegate:self];
            
            /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
             [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
             [formatter setDateStyle:NSDateFormatterShortStyle];
             [formatter setTimeStyle:NSDateFormatterShortStyle];
             [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
             
             NSDate *date = [formatter dateFromString:tfTaskDate.text];
             
             NSLog(@"%@",date);
             
             NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
             [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
             [dateformate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
             NSString *dateStr = [dateformate stringFromDate:date]; // Convert date to string
             [tDict setObject:dateStr forKey:@"taskCreatedDate"];
             
             NSLog(@"%@",dateStr);*/
            
        }
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)btnOneHourAction:(id)sender
{
    //if ([btnOneHour isSelected]) {
    
    [btnOneHour setSelected:YES];
    [btnFifteenMin setSelected:NO];
    
    /*}
     else
     {
     [btnOneHour setSelected:YES];
     [btnFifteenMin setSelected:NO];
     
     }*/
}
-(IBAction)btnFifteenMinAction:(id)sender
{
    // if ([btnFifteenMin isSelected]) {
    
    [btnFifteenMin setSelected:YES];
    [btnOneHour setSelected:NO];
    
    /* }
     else
     {
     [btnFifteenMin setSelected:YES];
     [btnOneHour setSelected:NO];
     
     }*/
}
#pragma mark- TagSelectionDelegate
-(void)didFinishAssignTags:(NSMutableArray *)arrSEL
{
    if(arrTagsD != nil)
    {
        [arrTagsD removeAllObjects];
        arrTagsD = nil;
    }
    
    arrTagsD = [[NSMutableArray alloc] initWithArray:arrSEL];
    
    NSString* strtags = @"";
    unsigned long int i=0;
    for (Tags *t in arrTagsD) {
        
        if(t.isSelected){
            strtags = [strtags stringByAppendingFormat:@"%@ ,",t.tagTitle];
        }
        
        if(i == [arrTagsD count]-1){
            strtags = [strtags substringToIndex:[strtags length]-1];
        }
        i++;
    }
    tfTaskAssoUsers.text=@"";
    
    tfTaskAssoTags.text = strtags;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (!IS_DEVICE_IPAD) {
        
        if ([text isEqualToString:@"\n"])
        {
            
            [textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            return NO;
            
        }
        
    }
    
    
    return YES;
    
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

-(void)userDidSelected:(NSMutableArray *)arrUser
{
    if(arrSelUsersD != nil)
    {
        [arrSelUsersD removeAllObjects];
        arrSelUsersD = nil;
    }
    
    arrSelUsersD = [[NSMutableArray alloc] initWithArray:arrUser];
    
    
    
    NSString* strtags = @"";
    
    for (User *u in arrSelUsersD) {
        if(u.isSelected)
        {
            strtags = [strtags stringByAppendingFormat:@"%@ ,",u.username];
        }
    }
    
    if([strtags length]>0){
        strtags = [strtags substringToIndex:[strtags length]-1];
    }
    tfTaskAssoUsers.text = strtags;
}


#pragma mark- TopNavigation Delegate
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- UITextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:tfTaskAssoTags] || [textField isEqual:tfTaskAssoUsers]|| [textField isEqual:tfTaskDate])
    {
        [tfTaskTitle resignFirstResponder];
        // [textField resignFirstResponder];
        
    }
    
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:tfTaskDate])
    {
        if (IS_DEVICE_IPAD) {
            
            [ActionSheetPicker displayActionPickerWithView:tfTaskDate datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(selectDate:) title:@"Select Date"];
            
        }
        else
        {
            
            [self showDatePicker];
            [textField resignFirstResponder];
            
            
        }
        
        
        //return FALSE;
    }
    else if([textField isEqual:tfTaskAssoTags]){
        
        [textField resignFirstResponder];
        
        if (IS_DEVICE_IPAD) {
            
            self.tagS = [[TagSelectionVC alloc] initWithNibName:@"TagSelectionVC" bundle:nil];
            
        }
        else
        {
            self.tagS = [[TagSelectionVC alloc] initWithNibName:@"TagSelectionVC_iphone" bundle:nil];
            
        }
        
        self.tagS.tagDelegate = self;
        self.tagS.arrTagData = arrTagsD;
        self.tagS.checkRecieptSelection=FALSE;
        
        [self.view addSubview:self.tagS.view];
        
        // [self.navigationController pushViewController:tagS animated:YES];
        
    }
    else if([textField isEqual:tfTaskAssoUsers])
    {
        if (tfTaskAssoTags.text.length>0) {
            
            [textField resignFirstResponder];
            
            if (IS_DEVICE_IPAD) {
                
                self.usvc = [[UserSelectionVC alloc] initWithNibName:@"UserSelectionVC" bundle:nil];
            }
            else
            {
                self.usvc = [[UserSelectionVC alloc] initWithNibName:@"UserSelectionVC_iphone" bundle:nil];
            }
            
            self.usvc.delegate = self;
            self.usvc.arrSelectedUser = arrSelUsersD;
            
            if ([arrTagsD count]>0) {
                
                self.usvc.tagId=[self getSelectedTags:arrTagsD];

            }
            else
            {
                self.usvc.tagId=self.selectedTagId;

            }
            [self.view addSubview:self.usvc.view];

        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Please select tag first"];
        }
        
        //[self.navigationController pushViewController:usvc animated:YES ];
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
        
        [toolbar setFrame:CGRectMake(0.0, 180.0+IPHONE_FIVE_FACTOR, 275.0, 44.0)];
        datePicker.frame=CGRectMake(0,224+IPHONE_FIVE_FACTOR,275.0, 216);
        
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 180.0, 275.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,224,275.0, 216);
        
    }
    
}
-(IBAction)cancel
{
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [tfTaskDate resignFirstResponder];
    
}
-(IBAction)done
{
    
    NSDate *date = datePicker.date;
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *today  = [df2 dateFromString:[df2 stringFromDate:[NSDate date]]];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    if ([today compare:date]==NSOrderedDescending) {
        tfTaskDate.text = @"";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"You can only add future task" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    NSLog(@"%@",dateStr);
    
    self.serverDate=dateStr;
    
    NSString* strDate = [self shortStyleDate:date];
    tfTaskDate.text = strDate;
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    [tfTaskDate resignFirstResponder];
    
    
}
#pragma mark- UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
    }
    if (tvTaskDesc.textColor == [UIColor lightGrayColor]) {
        tvTaskDesc.text = @"";
        tvTaskDesc.textColor = [UIColor blackColor];
    }
    
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(tvTaskDesc.text.length == 0)
    {
        tvTaskDesc.text = @"Task Description";
        tvTaskDesc.textColor = [UIColor lightGrayColor];
        [tvTaskDesc resignFirstResponder];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(!(textView.textColor == [UIColor lightGrayColor]))
    {
        // strAbtDesc = textView.text;
    }
}

#pragma mark- UIAlertView Delegate
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_TASK_ADDED_SUCCESSFULLY)
    {
        if([self.delegate respondsToSelector:@selector(taskStatusDidChanged:)]){
            [self.delegate taskStatusDidChanged:TRUE];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_ADD_TASK_UPDATE object:nil];
        
        
        
        [tfTaskTitle resignFirstResponder];
        [tfTaskDate resignFirstResponder];
        [tfTaskAssoTags resignFirstResponder];
        [tfTaskAssoUsers resignFirstResponder];
        [tvTaskDesc resignFirstResponder];
        
        [self.view removeFromSuperview];
    }
    else if(alertView.alertTag == AC_ALERTVIEW_TASK_UPDATED_SUCCESSFULLY){
        
        [tfTaskTitle resignFirstResponder];
        [tfTaskDate resignFirstResponder];
        [tfTaskAssoTags resignFirstResponder];
        [tfTaskAssoUsers resignFirstResponder];
        [tvTaskDesc resignFirstResponder];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_EDIT_TASK_UPDATE object:nil];
        
        
        if([self.delegate respondsToSelector:@selector(taskStatusDidChanged:)]){
            [self.delegate taskStatusDidChanged:TRUE];
        }
        [self.view removeFromSuperview];
    }
}

#pragma mark- Invocationn

-(void)editTaskInvocationDidFinish:(EditTaskInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        if (!error) {
            
            NSLog(@"editTaskInvocationDidFinish =%@",dict);
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                ACAlertView *successAlert = [ConfigManager alertView:nil message:@"Task updated successfully" del:self];
                successAlert.alertTag = AC_ALERTVIEW_TASK_UPDATED_SUCCESSFULLY;
                [successAlert show];
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
                [ConfigManager showAlertMessage:nil Message:@"Task not updated"];
                
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

-(void)addTaskInvocationDidFinish:(AddTaskInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"addTaskInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString *strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                ACAlertView *alert = [ConfigManager alertView:nil message:[response valueForKey:@"message"] del:self];
                alert.alertTag = AC_ALERTVIEW_TASK_ADDED_SUCCESSFULLY;
                [alert show];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
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
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}



@end
