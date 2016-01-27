//
//  AddScheduleViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import "AddScheduleViewController.h"
#import "ActionSheetPicker.h"
#import "TagAsignViewController.h"
#import "ScheduleData.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "UserSelectionVC.h"

@interface AddScheduleViewController ()

@end

@implementation AddScheduleViewController

@synthesize arrWeekList,shiftArray,startShiftTextFieldArray,endShiftTextFieldArray,startTime,endTime,sData,tagVC,usvc,arrSelUsersD;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
        }
    }
    checkAddPressed=FALSE;
    self.shiftArray=[[NSMutableArray alloc] init];
    self.startShiftTextFieldArray=[[NSMutableArray alloc] init];
    self.endShiftTextFieldArray=[[NSMutableArray alloc] init];
    self.arrSelUsersD=[[NSMutableArray alloc] init];
    
    self.arrWeekList=[[NSMutableArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    
    txtTempEndTime.text=@"";
    txtTempStartTime.text=@"";
    txtStartTime.text=@"";
    txtEndTime.text=@"";
    txtUserName.text=@"";
    
    sharedAppDelegate.strScheduleTagName=@"";
    sharedAppDelegate.strScheduleTagId=@"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTagName) name:AC_SELECT_TAG_FOR_SCHEDULE object:nil];
    
    txtTempStartTime=txtStartTime;
    txtTempEndTime=txtEndTime;
    
    [startShiftTextFieldArray addObject:txtTempStartTime];
    [endShiftTextFieldArray addObject:txtTempEndTime];
    
    if (self.sData==nil) {
        
    }
    else
    {
        [self createEditVIew];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}

-(void)createEditVIew
{
    unsigned long int y=imgTagName.frame.origin.y;
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    [btnAddSchedule setTitle:@"Edit Schedule" forState:UIControlStateNormal];
    
    [array addObjectsFromArray:sData.ScheduleArray];
    
    txtStartTime.text=[[array objectAtIndex:0] objectForKey:@"start_time"];
    txtEndTime.text=[[array objectAtIndex:0] objectForKey:@"end_time"];
    sharedAppDelegate.strScheduleTagId=sData.ScheduleTagId;
    txtStartWeek.text=sData.ScheduleStartWeek;
    txtEndWeek.text=sData.ScheduleEndWeek;
    txtTagName.text=sData.ScheduleTagName;
    txtUserName.text = [self getSelectedUserNames:sData.ScheduleUserArray];
    
    txtTempStartTime=txtStartTime;
    txtTempEndTime=txtEndTime;
    
    [startShiftTextFieldArray removeAllObjects];
    [endShiftTextFieldArray removeAllObjects];
    
    [startShiftTextFieldArray addObject:txtTempStartTime];
    [endShiftTextFieldArray addObject:txtTempEndTime];
    
    if ([array count]>1) {
        
        for (int i=1; i<[array count]; i++) {
            
            
            UIImageView *imgTxt=[[UIImageView alloc] init];
            [imgTxt setImage:[UIImage imageNamed:@"start_date_big"]];
            [imgTxt setUserInteractionEnabled:YES];
            [scrollView addSubview:imgTxt];
            
            UITextField *txt=[[UITextField alloc] init];
            [txt setText:[[array objectAtIndex:i] objectForKey:@"start_time"]];
            [txt setUserInteractionEnabled:TRUE];
            [txt setDelegate:self];
            [txt setFont:[UIFont systemFontOfSize:14]];
            [txt setBorderStyle:UITextBorderStyleNone];
            [scrollView addSubview:txt];
            
            UIImageView *imgEndTxt=[[UIImageView alloc] init];
            [imgEndTxt setImage:[UIImage imageNamed:@"start_date_big"]];
            [imgEndTxt setUserInteractionEnabled:YES];
            [scrollView addSubview:imgEndTxt];
            
            UITextField *txtEnd=[[UITextField alloc] init];
            [txtEnd setText:[[array objectAtIndex:i] objectForKey:@"end_time"]];
            
            [txtEnd setUserInteractionEnabled:TRUE];
            [txtEnd setDelegate:self];
            [txtEnd setFont:[UIFont systemFontOfSize:14]];
            
            if (IS_DEVICE_IPAD) {
                
                [imgTxt setFrame:CGRectMake(9, y, 183, 34)];
                [txt setFrame:CGRectMake(15, y+2, 170, 30)];
                [imgEndTxt setFrame:CGRectMake(200, y, 183, 34)];
                [txtEnd setFrame:CGRectMake(206, y+2, 170, 30)];
            }
            else
            {
                [imgTxt setFrame:CGRectMake(2,y,120,34)];
                [txt setFrame:CGRectMake(8, y+2, 93, 30)];
                [imgEndTxt setFrame:CGRectMake(134, y, 120, 34)];
                [txtEnd setFrame:CGRectMake(140, y+2, 93, 30)];
            }
            
            
            [txtEnd setBorderStyle:UITextBorderStyleNone];
            [scrollView addSubview:txtEnd];
            
            txtTempStartTime=txt;
            txtTempEndTime=txtEnd;
            
            [startShiftTextFieldArray addObject:txtTempStartTime];
            [endShiftTextFieldArray addObject:txtTempEndTime];
            
            
            y=y+55;
        }
        
        
    }
    [btnAddTime setFrame:CGRectMake(btnAddTime.frame.origin.x, y-50, btnAddTime.frame.size.width, btnAddTime.frame.size.height)];
    
    
    [imgTagName setFrame:CGRectMake(imgTagName.frame.origin.x, y, imgTagName.frame.size.width, imgTagName.frame.size.height)];
    
    
    [txtTagName setFrame:CGRectMake(txtTagName.frame.origin.x, y+2, txtTagName.frame.size.width, txtTagName.frame.size.height)];
    
    y=y+55;
    
    [imgUserName setFrame:CGRectMake(imgUserName.frame.origin.x, y, imgUserName.frame.size.width, imgUserName.frame.size.height)];
    
    
    [txtUserName setFrame:CGRectMake(txtUserName.frame.origin.x, y+2, txtUserName.frame.size.width, txtUserName.frame.size.height)];
    
    y=y+55;
    
    [btnAddSchedule setFrame:CGRectMake(btnAddSchedule.frame.origin.x, y, btnAddSchedule.frame.size.width, btnAddSchedule.frame.size.height)];
    
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, y+70)];
    
}
-(void)updateTagName
{
    txtTagName.text=sharedAppDelegate.strScheduleTagName;
}

-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)btnAddSchedulePressed:(id)sender
{
    if (txtStartWeek.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select start day of week"];
        
        return;
    }
    else if(txtEndWeek.text.length==0)
    {
        [ConfigManager showAlertMessage:nil Message:@"Please select end day of week"];
        
        return;
    }
    else if(txtTagName.text.length==0)
    {
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
        
        return;
    }
    else if (txtEndWeek.text.length==0 || txtTagName.text.length==0 || txtTempEndTime.text.length==0 || txtTempStartTime.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select start date and end date"];
        
    }
    else
    {
        for (int i=0; i<[startShiftTextFieldArray count]; i++) {
            
            
            NSMutableDictionary * mutDict = [[NSMutableDictionary alloc] init];
            
            UITextField *startTxt=[self.startShiftTextFieldArray objectAtIndex:i];
            UITextField *endTxt=[self.endShiftTextFieldArray objectAtIndex:i];
            
            [mutDict setObject:startTxt.text forKey:@"start_time"];
            [mutDict setObject:endTxt.text forKey:@"end_time"];
            
            [shiftArray addObject:mutDict];
        }
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dict setValue:txtStartWeek.text forKey:@"start_week"];
    [dict setValue:txtEndWeek.text forKey:@"end_week"];
    [dict setValue:shiftArray forKey:@"shift"];
    [dict setValue:sharedAppDelegate.strScheduleTagId forKey:@"tag_id"];
    [dict setObject:[self getSelectedUser:self.arrSelUsersD] forKey:@"users"];
    
    if (sData==nil) {
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Add Schedule..." width:200];
        [[AmityCareServices sharedService] AddSelfCreatedScheduleInvocation:dict delegate:self];
        
    }
    else
    {
        [dict setValue:sData.ScheduleId forKey:@"schedule_id"];
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
        [[AmityCareServices sharedService] UpdateSelfCreatedScheduleInvocation:dict delegate:self];
        
    }
    
    NSLog(@"%@",dict);
    
    
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
        
        NSLog(@"Selected users ids=%@",ids);
        return ids;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ::::::::: geting selected Users=%@",[exception debugDescription]);
        
    }
}
-(void)userDidSelected:(NSMutableArray *)arrUser
{
    if(arrSelUsersD != nil)
    {
        [arrSelUsersD removeAllObjects];
        arrSelUsersD = nil;
    }
    
    arrSelUsersD = [[NSMutableArray alloc] initWithArray:arrUser];
    
    
    
    NSString* strUsers = @"";
    
    for (User *u in arrSelUsersD) {
        if(u.isSelected)
        {
            strUsers = [strUsers stringByAppendingFormat:@"%@ ,",u.username];
        }
    }
    
    if([strUsers length]>0){
        strUsers = [strUsers substringToIndex:[strUsers length]-1];
    }
    txtUserName.text = strUsers;
}

-(IBAction)btnAddTimePressed:(id)sender
{
    self.startTime=nil;
    self.endTime=nil;
    
    if (txtTempEndTime.text.length==0 || txtTempStartTime.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select start date and end date"];
    }
    else
    {
        unsigned long int y=txtTagName.frame.origin.y;
        
        UIImageView *imgTxt=[[UIImageView alloc] init];
        [imgTxt setImage:[UIImage imageNamed:@"start_date_big"]];
        [imgTxt setUserInteractionEnabled:YES];
        [scrollView addSubview:imgTxt];
        
        UITextField *txt=[[UITextField alloc] init];
        [txt setPlaceholder:@"Start time"];
        [txt setUserInteractionEnabled:TRUE];
        [txt setDelegate:self];
        [txt setFont:[UIFont systemFontOfSize:14]];
        
        [txt setBorderStyle:UITextBorderStyleNone];
        [scrollView addSubview:txt];
        
        UIImageView *imgEndTxt=[[UIImageView alloc] init];
        [imgEndTxt setImage:[UIImage imageNamed:@"start_date_big"]];
        [imgEndTxt setUserInteractionEnabled:YES];
        [scrollView addSubview:imgEndTxt];
        
        UITextField *txtEnd=[[UITextField alloc] init];
        [txtEnd setPlaceholder:@"End time"];
        [txtEnd setUserInteractionEnabled:TRUE];
        [txtEnd setDelegate:self];
        [txtEnd setFont:[UIFont systemFontOfSize:14]];
        
        if (IS_DEVICE_IPAD) {
            
            [imgTxt setFrame:CGRectMake(9, y, 183, 34)];
            [txt setFrame:CGRectMake(15, y+2, 170, 30)];
            [imgEndTxt setFrame:CGRectMake(200, y, 183, 34)];
            [txtEnd setFrame:CGRectMake(206, y+2, 170, 30)];
        }
        else
        {
            [imgTxt setFrame:CGRectMake(2,y,120,34)];
            [txt setFrame:CGRectMake(8, y+2, 93, 30)];
            [imgEndTxt setFrame:CGRectMake(134, y, 120, 34)];
            [txtEnd setFrame:CGRectMake(140, y+2, 93, 30)];
        }
        
        
        
        [txtEnd setBorderStyle:UITextBorderStyleNone];
        [scrollView addSubview:txtEnd];
        
        txtTempStartTime=txt;
        txtTempEndTime=txtEnd;
        
        [startShiftTextFieldArray addObject:txtTempStartTime];
        [endShiftTextFieldArray addObject:txtTempEndTime];
        
        [btnAddTime setFrame:CGRectMake(btnAddTime.frame.origin.x, y+4, btnAddTime.frame.size.width, btnAddTime.frame.size.height)];
        
        
        y=y+55;
        
        [imgTagName setFrame:CGRectMake(imgTagName.frame.origin.x, y, imgTagName.frame.size.width, imgTagName.frame.size.height)];
        
        
        [txtTagName setFrame:CGRectMake(txtTagName.frame.origin.x, y+2, txtTagName.frame.size.width, txtTagName.frame.size.height)];
        
        y=y+55;
        
        
        [imgUserName setFrame:CGRectMake(imgUserName.frame.origin.x, y, imgUserName.frame.size.width, imgUserName.frame.size.height)];
        
        
        [txtUserName setFrame:CGRectMake(txtUserName.frame.origin.x, y+2, txtUserName.frame.size.width, txtUserName.frame.size.height)];
        
        y=y+55;
        
        
        [btnAddSchedule setFrame:CGRectMake(btnAddSchedule.frame.origin.x, y, btnAddSchedule.frame.size.width, btnAddSchedule.frame.size.height)];
        
    }
    
}


-(void)showStartWeekPicker
{
    weekView = [[UIView alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [weekView setFrame:CGRectMake(0, 0, 300, 260)];
    }
    else
    {
        if (IS_IPHONE_5) {
            
            [weekView setFrame:CGRectMake(0, 180+IPHONE_FIVE_FACTOR, 275, 260)];
            
        }
        else
        {
            [weekView setFrame:CGRectMake(0, 180, 275, 260)];
            
        }
        
    }
    
    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:@"Week"];
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [weekView addSubview:pickerToolbar];
    
    CGRect pickerFrame ;
    
    if (IS_DEVICE_IPAD) {
        
        pickerFrame = CGRectMake(0, 40, 300, 216);
    }
    else
    {
        pickerFrame = CGRectMake(0, 40, 275, 216);
        
    }
    
    weekPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    [weekPickerView setDataSource: self];
    [weekPickerView setDelegate: self];
    weekPickerView.tag=1;
    [weekPickerView setBackgroundColor:[UIColor whiteColor]];
    [weekPickerView selectRow:0 inComponent:0 animated:NO];
    [weekPickerView setShowsSelectionIndicator:YES];
    [weekView addSubview:weekPickerView];
    
    if (IS_DEVICE_IPAD) {
        
        UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        viewController.view = weekView;
        viewController.preferredContentSize = viewController.view.frame.size;
        
        popoverController =[[UIPopoverController alloc] initWithContentViewController:viewController];
        
        popoverController.popoverContentSize= CGSizeMake(weekView.frame.size.width, weekView.frame.size.height);
        
        [popoverController presentPopoverFromRect:[txtStartWeek bounds]
                                           inView:txtStartWeek
                         permittedArrowDirections:UIPopoverArrowDirectionDown
                                         animated:YES];
    }
    else
    {
        [self.view addSubview:weekView];
    }
}
-(void)showEndWeekPicker
{
    weekView = [[UIView alloc] init];
    
    if (IS_DEVICE_IPAD) {
        
        [weekView setFrame:CGRectMake(0, 0, 300, 260)];
    }
    else
    {
        if (IS_IPHONE_5) {
            
            [weekView setFrame:CGRectMake(0, 180+IPHONE_FIVE_FACTOR, 320, 260)];
            
        }
        else
        {
            [weekView setFrame:CGRectMake(0, 180, 320, 260)];
            
        }
        
    }
    
    UIToolbar *pickerToolbar = [self createEndPickerToolbarWithTitle:@"Week"];
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [weekView addSubview:pickerToolbar];
    
    CGRect pickerFrame ;
    
    if (IS_DEVICE_IPAD) {
        
        pickerFrame = CGRectMake(0, 40, 300, 216);
    }
    else
    {
        pickerFrame = CGRectMake(0, 40, 320, 216);
        
    }
    
    
    weekPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    [weekPickerView setDataSource: self];
    [weekPickerView setDelegate: self];
    weekPickerView.tag=1;
    [weekPickerView setBackgroundColor:[UIColor whiteColor]];
    [weekPickerView selectRow:0 inComponent:0 animated:NO];
    [weekPickerView setShowsSelectionIndicator:YES];
    [weekView addSubview:weekPickerView];
    
    if (IS_DEVICE_IPAD) {
        
        UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        viewController.view = weekView;
        viewController.preferredContentSize = viewController.view.frame.size;
        
        popoverController =[[UIPopoverController alloc] initWithContentViewController:viewController];
        
        popoverController.popoverContentSize= CGSizeMake(weekView.frame.size.width, weekView.frame.size.height);
        
        [popoverController presentPopoverFromRect:[txtEndWeek bounds]
                                           inView:txtEndWeek
                         permittedArrowDirections:UIPopoverArrowDirectionDown
                                         animated:YES];
    }
    else
    {
        [self.view addSubview:weekView];
    }
}
- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    
    CGRect frame;
    
    if (IS_DEVICE_IPAD) {
        
        frame = CGRectMake(0, 0, 300, 44);
    }
    else
    {
        frame = CGRectMake(0, 0, 275, 44);
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
- (UIToolbar *)createEndPickerToolbarWithTitle:(NSString *)title  {
    
    CGRect frame;
    
    if (IS_DEVICE_IPAD) {
        
        frame = CGRectMake(0, 0, 300, 44);
    }
    else
    {
        frame = CGRectMake(0, 0, 275, 44);
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
    UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionEndPickerDone:)];
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
    
    
    [txtStartWeek setText:[self.arrWeekList objectAtIndex:[weekPickerView selectedRowInComponent:0]]];
    
    
    if (IS_DEVICE_IPAD) {
        
        if (popoverController && popoverController.popoverVisible)
            [popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        [weekView removeFromSuperview];
    }
    
}
-(IBAction)actionEndPickerDone:(id)sender
{
    
    
    [txtEndWeek setText:[self.arrWeekList objectAtIndex:[weekPickerView selectedRowInComponent:0]]];
    
    
    if (IS_DEVICE_IPAD) {
        
        if (popoverController && popoverController.popoverVisible)
            [popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        [weekView removeFromSuperview];
    }
    
}
- (IBAction)actionPickerCancel:(id)sender {
    
    if (IS_DEVICE_IPAD) {
        
        if (popoverController && popoverController.popoverVisible)
            [popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self resignTextField];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        [weekView removeFromSuperview];
    }
    
}

#pragma mark- UITextField Delegate

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
-(void)resignTextField
{
    [txtStartWeek resignFirstResponder];
    [txtEndWeek resignFirstResponder];
    [txtStartTime resignFirstResponder];
    [txtEndTime resignFirstResponder];
    [txtTagName resignFirstResponder];
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
        
    }
    
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField==txtStartWeek)
    {
        
        [self.view endEditing:YES];
        
        [self showStartWeekPicker];
        
        return NO;
    }
    else if(textField==txtEndWeek)
    {
        [self.view endEditing:YES];
        
        [self showEndWeekPicker];
        
        return NO;
        
    }
    else if(textField==txtTempStartTime)
    {
        if (IS_DEVICE_IPAD) {
            
            [ActionSheetPicker displayActionPickerWithView:txtTempStartTime datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(selectDate:) title:@"Select start time"];
            
        }
        else
        {
            [self showDatePicker];
        }
        
        return NO;
    }
    else if(textField==txtTempEndTime)
    {
        if (IS_DEVICE_IPAD) {
            
            [ActionSheetPicker displayActionPickerWithView:txtTempEndTime datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(selectEndDate:) title:@"Select end time "];
            
        }
        else
        {
            [self showEndDatePicker];
        }
        return NO;
    }
    
    else if(textField==txtTagName)
    {
        
        if (IS_DEVICE_IPAD) {
            
            self.tagVC = [[TagAsignViewController alloc]initWithNibName:@"TagAsignViewController" bundle:nil];
        }
        else
        {
            self.tagVC = [[TagAsignViewController alloc]initWithNibName:@"TagAsignViewController_iphone" bundle:nil];
        }
        self.tagVC.checkView=TRUE;
        [self.view addSubview:self.tagVC.view];
        
        return NO;
        
    }
    else if(textField==txtUserName)
    {
        
        if (IS_DEVICE_IPAD) {
            
            self.usvc = [[UserSelectionVC alloc]initWithNibName:@"UserSelectionVC" bundle:nil];
        }
        else
        {
            self.usvc = [[UserSelectionVC alloc]initWithNibName:@"UserSelectionVC_iphone" bundle:nil];
        }
        self.usvc.delegate = self;
        self.usvc.arrSelectedUser = self.arrSelUsersD;
        
        self.usvc.tagId=sharedAppDelegate.strScheduleTagId;
        
        [self.view addSubview:self.usvc.view];
        
        return NO;
        
    }
    else
    {
        if ([self.startShiftTextFieldArray count]>0) {
            
            for (int i=0; i<[self.startShiftTextFieldArray count]-1; i++) {
                
                UITextField *txtStart=[self.startShiftTextFieldArray objectAtIndex:i];
                UITextField *txtEnd=[self.endShiftTextFieldArray objectAtIndex:i];
                
                if (textField==txtStart) {
                    
                    txtTempStartTime=txtStart;
                    txtTempEndTime=txtEnd;
                    
                    
                    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
                    [dateformater setDateFormat:@"hh:mm a"];
                    [dateformater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    
                    self.startTime = [dateformater dateFromString:txtStart.text];
                    self.endTime = [dateformater dateFromString:txtEnd.text];
                    
                    
                    
                    if (IS_DEVICE_IPAD) {
                        
                        [ActionSheetPicker displayActionPickerWithView:txtStartTime datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(selectDate:) title:@"Select start time"];
                        
                    }
                    else
                    {
                        [self showDatePicker];
                    }
                    
                }
                else if (textField==txtEnd) {
                    
                    txtTempStartTime=txtStart;
                    txtTempEndTime=txtEnd;
                    
                    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
                    [dateformater setDateFormat:@"hh:mm a"];
                    [dateformater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    
                    self.startTime = [dateformater dateFromString:txtStart.text];
                    self.endTime = [dateformater dateFromString:txtEnd.text];
                    
                    
                    if (IS_DEVICE_IPAD) {
                        
                        [ActionSheetPicker displayActionPickerWithView:txtStartTime datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(selectEndDate:) title:@"Select end time "];
                        
                    }
                    else
                    {
                        [self showEndDatePicker];
                    }
                    
                }
                
            }
        }
        return NO;
    }
    
    
}
-(void)selectDate:(id)sender
{
    [txtStartTime resignFirstResponder];
    [txtTempStartTime resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSLog(@"%lu",(unsigned long)[self.startShiftTextFieldArray count]);
    NSLog(@"%lu",(unsigned long)[self.endShiftTextFieldArray count]);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm a"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    self.startTime = [dateformate dateFromString:dateStr];
    NSLog(@"currentDate is %@",[dateformate stringFromDate:self.startTime]);
    
    if ([self.startTime compare:self.endTime]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Start time should be less than end time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    if ([self.startShiftTextFieldArray count]>0) {
        
        for (int i=0; i<[self.startShiftTextFieldArray count]-1; i++) {
            
            UITextField *txtStart=[self.startShiftTextFieldArray objectAtIndex:i];
            UITextField *txtEnd=[self.endShiftTextFieldArray objectAtIndex:i];
            
            NSString *tempStartDateStr=txtStart.text;
            NSString *tempEndDateStr=txtEnd.text;
            
            NSLog(@"%@",tempStartDateStr);
            NSLog(@"%@",tempEndDateStr);
            
            NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
            [dateformater setDateFormat:@"hh:mm a"];
            [dateformater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            
            NSDate *tempStartDate = [dateformater dateFromString:tempStartDateStr];
            NSDate *tempEndDate = [dateformater dateFromString:tempEndDateStr];
            NSDate *currentDate = [dateformater dateFromString:dateStr];
            
            NSLog(@"tempStartDate is %@",[dateformater stringFromDate:tempStartDate]);
            
            NSLog(@"tempEndDate is %@",[dateformater stringFromDate:tempEndDate]);
            
            NSLog(@"currentDate is %@",[dateformater stringFromDate:currentDate]);
            
            
            if ([currentDate compare:tempStartDate]==NSOrderedSame || [currentDate compare:tempEndDate]==NSOrderedSame) {
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"This time is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            else if ([currentDate compare:tempStartDate]==NSOrderedDescending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            else if ([currentDate compare:tempStartDate]==NSOrderedAscending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                
            }
            else if ([currentDate compare:tempEndDate]==NSOrderedDescending) {
                
                
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
                
            }
            
        }
    }
    
    
    txtTempStartTime.text = dateStr;
    
}
-(void)selectEndDate:(id)sender
{
    [txtEndTime resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSLog(@"%lu",(unsigned long)[self.startShiftTextFieldArray count]);
    NSLog(@"%lu",(unsigned long)[self.endShiftTextFieldArray count]);
    
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm a"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    self.endTime = [dateformate dateFromString:dateStr];
    
    if ([self.startTime compare:self.endTime]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End time should be greater than end time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    if ([self.startShiftTextFieldArray count]>0) {
        
        for (int i=0; i<[self.startShiftTextFieldArray count]-1; i++) {
            
            UITextField *txtStart=[self.startShiftTextFieldArray objectAtIndex:i];
            UITextField *txtEnd=[self.endShiftTextFieldArray objectAtIndex:i];
            
            NSString *tempStartDateStr=txtStart.text;
            NSString *tempEndDateStr=txtEnd.text;
            
            NSLog(@"%@",tempStartDateStr);
            NSLog(@"%@",tempEndDateStr);
            
            NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
            [dateformater setDateFormat:@"hh:mm a"];
            [dateformater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            
            NSDate *tempStartDate = [dateformater dateFromString:tempStartDateStr];
            NSDate *tempEndDate = [dateformater dateFromString:tempEndDateStr];
            NSDate *currentDate = [dateformater dateFromString:dateStr];
            
            NSLog(@"tempStartDate is %@",[dateformater stringFromDate:tempStartDate]);
            
            NSLog(@"tempEndDate is %@",[dateformater stringFromDate:tempEndDate]);
            
            NSLog(@"currentDate is %@",[dateformater stringFromDate:currentDate]);
            
            
            if ([currentDate compare:tempStartDate]==NSOrderedSame || [currentDate compare:tempEndDate]==NSOrderedSame) {
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"This time is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            else if ([currentDate compare:tempStartDate]==NSOrderedDescending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            else if ([currentDate compare:tempStartDate]==NSOrderedAscending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                // txtTempEndTime.text = dateStr;
                
                //return;
                
            }
            else if ([currentDate compare:tempEndDate]==NSOrderedDescending) {
                
                //txtTempEndTime.text = dateStr;
                
                // return;
                
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
                
            }
            
            
        }
    }
    
    
    
    txtTempEndTime.text = dateStr;
    
    
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
    
    datePicker.datePickerMode = UIDatePickerModeTime;
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
    
    datePicker.datePickerMode = UIDatePickerModeTime;
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
    [txtStartTime resignFirstResponder];
    [txtEndTime resignFirstResponder];
    [txtTempStartTime resignFirstResponder];
    [txtTempEndTime resignFirstResponder];
    
}
-(IBAction)done
{
    
    [txtStartTime resignFirstResponder];
    [txtTempStartTime resignFirstResponder];
    
    NSDate *date = datePicker.date;
    
    NSLog(@"%lu",(unsigned long)[self.startShiftTextFieldArray count]);
    NSLog(@"%lu",(unsigned long)[self.endShiftTextFieldArray count]);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm a"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    self.startTime = [dateformate dateFromString:dateStr];
    NSLog(@"currentDate is %@",[dateformate stringFromDate:self.startTime]);
    
    
    if ([self.startTime compare:self.endTime]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Start time should be less than end time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    if ([self.startShiftTextFieldArray count]>0) {
        
        for (int i=0; i<[self.startShiftTextFieldArray count]-1; i++) {
            
            UITextField *txtStart=[self.startShiftTextFieldArray objectAtIndex:i];
            UITextField *txtEnd=[self.endShiftTextFieldArray objectAtIndex:i];
            
            NSString *tempStartDateStr=txtStart.text;
            NSString *tempEndDateStr=txtEnd.text;
            
            NSLog(@"%@",tempStartDateStr);
            NSLog(@"%@",tempEndDateStr);
            
            NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
            [dateformater setDateFormat:@"hh:mm a"];
            [dateformater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            
            NSDate *tempStartDate = [dateformater dateFromString:tempStartDateStr];
            NSDate *tempEndDate = [dateformater dateFromString:tempEndDateStr];
            NSDate *currentDate = [dateformater dateFromString:dateStr];
            
            NSLog(@"tempStartDate is %@",[dateformater stringFromDate:tempStartDate]);
            
            NSLog(@"tempEndDate is %@",[dateformater stringFromDate:tempEndDate]);
            
            NSLog(@"currentDate is %@",[dateformater stringFromDate:currentDate]);
            
            if ([currentDate compare:tempStartDate]==NSOrderedSame || [currentDate compare:tempEndDate]==NSOrderedSame) {
                
                [txtStartTime resignFirstResponder];
                [txtTempStartTime resignFirstResponder];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"This time is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            else if ([currentDate compare:tempStartDate]==NSOrderedDescending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                [txtStartTime resignFirstResponder];
                [txtTempStartTime resignFirstResponder];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            else if ([currentDate compare:tempStartDate]==NSOrderedAscending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                //txtTempStartTime.text = dateStr;
                
                //return;
                
            }
            else if ([currentDate compare:tempEndDate]==NSOrderedDescending) {
                
                //txtTempStartTime.text = dateStr;
                
                // return;
                
            }
            else
            {
                [txtStartTime resignFirstResponder];
                [txtTempStartTime resignFirstResponder];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
                
            }
            
        }
    }
    
    txtTempStartTime.text = dateStr;
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    
    [txtStartTime resignFirstResponder];
    [txtEndTime resignFirstResponder];
    [txtTempStartTime resignFirstResponder];
    [txtTempEndTime resignFirstResponder];
}
-(IBAction)EndDone
{
    
    NSDate *date = datePicker.date;
    
    [txtEndTime resignFirstResponder];
    
    NSLog(@"%lu",(unsigned long)[self.startShiftTextFieldArray count]);
    NSLog(@"%lu",(unsigned long)[self.endShiftTextFieldArray count]);
    
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm a"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    self.endTime = [dateformate dateFromString:dateStr];
    
    if ([self.startTime compare:self.endTime]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End time should be greater than end time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    if ([self.startShiftTextFieldArray count]>0) {
        
        for (int i=0; i<[self.startShiftTextFieldArray count]-1; i++) {
            
            UITextField *txtStart=[self.startShiftTextFieldArray objectAtIndex:i];
            UITextField *txtEnd=[self.endShiftTextFieldArray objectAtIndex:i];
            
            NSString *tempStartDateStr=txtStart.text;
            NSString *tempEndDateStr=txtEnd.text;
            
            NSLog(@"%@",tempStartDateStr);
            NSLog(@"%@",tempEndDateStr);
            
            NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
            [dateformater setDateFormat:@"hh:mm a"];
            [dateformater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            
            NSDate *tempStartDate = [dateformater dateFromString:tempStartDateStr];
            NSDate *tempEndDate = [dateformater dateFromString:tempEndDateStr];
            NSDate *currentDate = [dateformater dateFromString:dateStr];
            
            NSLog(@"tempStartDate is %@",[dateformater stringFromDate:tempStartDate]);
            NSLog(@"tempEndDate is %@",[dateformater stringFromDate:tempEndDate]);
            NSLog(@"currentDate is %@",[dateformater stringFromDate:currentDate]);
            
            if ([currentDate compare:tempStartDate]==NSOrderedSame || [currentDate compare:tempEndDate]==NSOrderedSame) {
                
                [txtStartTime resignFirstResponder];
                [txtTempStartTime resignFirstResponder];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"This time is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            
            else if ([currentDate compare:tempStartDate]==NSOrderedDescending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                [txtStartTime resignFirstResponder];
                [txtTempStartTime resignFirstResponder];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            else if ([currentDate compare:tempStartDate]==NSOrderedAscending && [currentDate compare:tempEndDate]==NSOrderedAscending) {
                
                //txtTempEndTime.text = dateStr;
                
                //return;
                
            }
            else if ([currentDate compare:tempEndDate]==NSOrderedDescending) {
                
                //txtTempEndTime.text = dateStr;
                
                //return;
                
            }
            else
            {
                [txtStartTime resignFirstResponder];
                [txtTempStartTime resignFirstResponder];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Shift is already added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
                
            }
            
            
        }
    }
    
    
    
    txtTempEndTime.text = dateStr;
    
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    [txtStartTime resignFirstResponder];
    [txtEndTime resignFirstResponder];
    [txtTempStartTime resignFirstResponder];
    [txtTempEndTime resignFirstResponder];
    
    
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
#pragma mark----------
#pragma mark- PickerView delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

{
    return [self.arrWeekList count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

{
    
    return [self.arrWeekList objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
}
-(void)AddSelfCreatedScheduleInvocationDidFinish:(AddSelfCreatedScheduleInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSDictionary *tempDic=[dict objectForKey:@"response"];
        
        NSString* strSuccess = NULL_TO_NIL([tempDic valueForKey:@"success"]);
        NSString* strMessage = NULL_TO_NIL([tempDic valueForKey:@"message"]);    NSLog(@"%@",strSuccess);
        
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: AC_SCHEDULE_UPDATE object:nil];
            
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
        
        [self.view removeFromSuperview];
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}
-(void)UpdateSelfCreatedScheduleInvocationDidFinish:(UpdateSelfCreatedScheduleInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSDictionary *tempDic=[dict objectForKey:@"response"];
        
        NSString* strSuccess = NULL_TO_NIL([tempDic valueForKey:@"success"]);
        NSString* strMessage = NULL_TO_NIL([tempDic valueForKey:@"message"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: AC_SCHEDULE_UPDATE object:nil];
            
            [self.view removeFromSuperview];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
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
    
    //  [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
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
