//
//  TaskCalenderViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "TaskCalenderViewController.h"
#import "NSDate+convenience.h"
#import "Task.h"
#import "TaskDetailVC.h"
#import "AddNewTaskVC.h"
#import "Tags.h"
#import "AddNewTaskVC.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface TaskCalenderViewController () <TaskDelegate>

@end

@implementation TaskCalenderViewController

@synthesize arrDateList,tagId,arrSelectedDateList,tagName,editTask,objTaskDetailVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 680)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    sharedAppDelegate.calenderCurrentDate=@"";
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.arrDateList=[[NSMutableArray alloc] init];
    self.arrSelectedDateList=[[NSMutableArray alloc] init];
    
   // NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], UITextAttributeFont,[UIColor colorWithRed:0.27843137 green:0.69411764 blue:0.92156862 alpha:1.0], UITextAttributeTextColor,nil];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,[UIColor colorWithRed:0.27843137 green:0.69411764 blue:0.92156862 alpha:1.0], NSForegroundColorAttributeName, nil];
    
    [calenderSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
   // NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], UITextAttributeFont,[UIColor whiteColor], UITextAttributeTextColor, nil];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];

    
    [calenderSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForMyTask) name:AC_ADD_TASK_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForAssignTask) name:AC_EDIT_TASK_UPDATE object:nil];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //   [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    
    service=[[AmityCareServices alloc] init];
    
    [self requestForMyTask];
}
-(void)requestForMyTask
{
    calenderSegment.selectedSegmentIndex=0;
    
    if([ConfigManager isInternetAvailable]) {
        
       // [DSBezelActivityView removeView];

        //[DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching task list Please wait..." width:220];
        
        if ([self.tagId isEqualToString:@""]) {
            
            [service UserCalenderListInvocation:sharedAppDelegate.userObj.userId delegate:self];
        }
        else
        {
            [service TagCalenderListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId delegate:self];
            
        }
        
    }
}
-(void)requestForAssignTask
{
    calenderSegment.selectedSegmentIndex=1;
    
    if([ConfigManager isInternetAvailable]) {
        
        //[DSBezelActivityView removeView];

       // [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching task list Please wait..." width:220];
        
        if ([self.tagId isEqualToString:@""]) {
            
            [service UserAssignCalandarListInvocation:sharedAppDelegate.userObj.userId delegate:self];
        }
        else
        {
            [service TagAssignCalendarListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId delegate:self];
            
        }
        
    }
    
}
-(IBAction)calenderSegmentAction:(id)sender
{
    if (calenderSegment.selectedSegmentIndex==0) {
        
        [self requestForMyTask];
    }
    else
    {
        [self requestForAssignTask];
    }
}

-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBarButtonDidClicked:(id)sender
{
    NSLog(@"%@",sharedAppDelegate.calenderCurrentDate);
    
    if (sharedAppDelegate.calenderCurrentDate==nil || sharedAppDelegate.calenderCurrentDate==(NSString*)[NSNull null] || [sharedAppDelegate.calenderCurrentDate isEqualToString:@""]) {
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
        sharedAppDelegate.calenderServerDate = [dateformate stringFromDate:[NSDate date]];
        sharedAppDelegate.calenderCurrentDate=[self shortStyleDate:[NSDate date]];
        
    }
    
    //add new task
    AddNewTaskVC* addTask
    ;
    
    if (IS_DEVICE_IPAD) {
        
        addTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
        
    }
    else
    {
        addTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
        
    }
    
    addTask.delegate = self;
    
    if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
        
        addTask.selectedDate=sharedAppDelegate.calenderCurrentDate;
        addTask.serverDate=sharedAppDelegate.calenderServerDate;
        
    }
    else
    {
        addTask.selectedTagId=self.tagId;
        addTask.selectedTag=self.tagName;
        addTask.selectedDate=sharedAppDelegate.calenderCurrentDate;
        addTask.serverDate=sharedAppDelegate.calenderServerDate;
        
    }
    
    [self.navigationController pushViewController:addTask animated:YES];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    //self.currentDate=@"";
    
    NSMutableArray *dateArray=[[NSMutableArray alloc] init];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"YYYY"]; // Date formater
    NSString *year = [dateformate stringFromDate:calendar.currentMonth]; // Convert date to string
    NSLog(@"date :%@",year);
    NSLog(@"%@",calendar.currentMonth);
    
    for (int i=0; i<[arrDateList count]; i++) {
        
        Task *task=[self.arrDateList objectAtIndex:i];
        
        NSString *subDate=[NSString stringWithFormat:@"%@",task.taskDate];
        
        NSLog(@"%@",subDate);
        
        NSString *fullDate=[subDate substringToIndex:10];
        
        NSString*strYear=[fullDate substringToIndex:4];
        
        NSLog(@"%@",strYear);
        
        NSString *tempMonthStr=[fullDate substringToIndex:7];
        
        NSString *monthStr=[tempMonthStr substringFromIndex:5];
        
        NSLog(@"%@",monthStr);
        
        NSString *tempDateStr=[fullDate substringToIndex:10];
        
        NSString *dateStr=[tempDateStr substringFromIndex:8];
        
        NSLog(@"%@",dateStr);
        
        if ([year isEqualToString:strYear]) {
            
            if (month==[monthStr intValue]) {
                
                [dateArray addObject:[NSNumber numberWithInt:[dateStr intValue]]];
                
            }
        }
        
    }
    [calendarView markDates:dateArray];
    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    
    [self.arrSelectedDateList removeAllObjects];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *selectDate = [dateformate stringFromDate:date]; // Convert date to string
    NSLog(@"date :%@",selectDate);
    NSLog(@"%@",calendar.selectedDate);
    
    
    NSDateFormatter *dateformate1=[[NSDateFormatter alloc]init];
    [dateformate1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    sharedAppDelegate.calenderServerDate = [dateformate1 stringFromDate:date]; // Co
    
    sharedAppDelegate.calenderCurrentDate=[self shortStyleDate:date];
    
    NSLog(@"%@",sharedAppDelegate.calenderServerDate);
    NSLog(@"%@",sharedAppDelegate.calenderCurrentDate);
    
    for (int i=0; i<[arrDateList count]; i++) {
        
        Task *task=[self.arrDateList objectAtIndex:i];
        
        NSString *subDate=[NSString stringWithFormat:@"%@",task.taskDate];
        
        NSString *fullDate=[subDate substringToIndex:10];
        
        NSLog(@"date :%@",fullDate);
        NSLog(@"selectDate :%@",selectDate);
        
        if ([fullDate isEqualToString:selectDate]) {
            
            [self.arrSelectedDateList addObject:[self.arrDateList objectAtIndex:i]];
            
            NSLog(@"fullDate %@",fullDate);
        }
        
    }
    
    [tblView reloadData];
    
    
}

-(void)calendarViewIphone:(VRGCalenderViewIphone *)calendarView switchedToMonth:(NSInteger)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    //self.currentDate=@"";
    
    NSMutableArray *dateArray=[[NSMutableArray alloc] init];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"YYYY"]; // Date formater
    NSString *year = [dateformate stringFromDate:calendar_iphone.currentMonth]; // Convert date to string
    NSLog(@"date :%@",year);
    NSLog(@"%@",calendar_iphone.currentMonth);
    
    for (int i=0; i<[arrDateList count]; i++) {
        
        Task *task=[self.arrDateList objectAtIndex:i];
        
        NSString *subDate=[NSString stringWithFormat:@"%@",task.taskDate];
        
        NSString *fullDate=[subDate substringToIndex:10];
        
        NSString*strYear=[fullDate substringToIndex:4];
        
        NSLog(@"%@",strYear);
        
        NSString *tempMonthStr=[fullDate substringToIndex:7];
        
        NSString *monthStr=[tempMonthStr substringFromIndex:5];
        
        NSLog(@"%@",monthStr);
        
        NSString *tempDateStr=[fullDate substringToIndex:10];
        
        NSString *dateStr=[tempDateStr substringFromIndex:8];
        
        NSLog(@"%@",dateStr);
        
        if ([year isEqualToString:strYear]) {
            
            if (month==[monthStr intValue]) {
                
                [dateArray addObject:[NSNumber numberWithInt:[dateStr intValue]]];
                
            }
        }
        
    }
    [calendarView markDates:dateArray];
    
}

-(void)calendarViewIphone:(VRGCalenderViewIphone *)calendarView dateSelected:(NSDate *)date {
    
    [self.arrSelectedDateList removeAllObjects];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
    NSString *selectDate = [dateformate stringFromDate:date]; // Convert date to string
    NSLog(@"date :%@",selectDate);
    
    
    NSDateFormatter *dateformate1=[[NSDateFormatter alloc]init];
    [dateformate1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    sharedAppDelegate.calenderServerDate = [dateformate1 stringFromDate:date]; // Co
    
    sharedAppDelegate.calenderCurrentDate=[self shortStyleDate:date];
    
    for (int i=0; i<[arrDateList count]; i++) {
        
        Task *task=[self.arrDateList objectAtIndex:i];
        
        NSString *subDate=[NSString stringWithFormat:@"%@",task.taskDate];
        
        NSString *fullDate=[subDate substringToIndex:10];
        
        NSLog(@"date :%@",fullDate);
        
        if ([fullDate isEqualToString:selectDate]) {
            
            [self.arrSelectedDateList addObject:[self.arrDateList objectAtIndex:i]];
            
            NSLog(@"fullDate %@",fullDate);
        }
        
    }
    
    [tblView reloadData];
    
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSelectedDateList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_DEVICE_IPAD) {
        
        return 65;
        
    }
    else
    {
        return 50;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (CalenderTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (Nil == cell)
    {
        cell = [CalenderTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    Task *data=[self.arrSelectedDateList objectAtIndex:indexPath.row];
    
    cell.lblTitle.text= data.taskTitle;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *tdate = [df dateFromString:data.taskDate];
    
    cell.lblDate.text= [self shortStyleDate:tdate];
    
    if([data.taskStatus isEqualToString:@"complete"]){
        
        [cell setBackgroundColor:[UIColor colorWithRed:188.0/255 green:255.0/255 blue:126.0/255 alpha:0.25]];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *task=[self.arrSelectedDateList objectAtIndex:indexPath.row];
    
    if (calenderSegment.selectedSegmentIndex==0) {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objTaskDetailVC=[[TaskDetailVC alloc] initWithNibName:@"TaskDetailVC" bundle:nil];
        }
        else
        {
            self.objTaskDetailVC=[[TaskDetailVC alloc] initWithNibName:@"TaskDetailVC_iphone" bundle:nil];
        }
        
        self.objTaskDetailVC.taskObj=task;
        self.objTaskDetailVC.checkView=@"calender";
        
        [self.view addSubview:self.objTaskDetailVC.view];
    }
    else
    {
        if([task.taskStatus isEqualToString:@"complete"]){
            [ConfigManager showAlertMessage:nil Message:@"Task has been completed"];
        }
        else{
            
            if (IS_DEVICE_IPAD) {
                
                self.editTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
                
            }
            else
            {
                self.editTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
                
            }
            
            self.editTask.delegate = self;
            self.editTask.isEditTask = YES;
            self.editTask.taskDetails = task;
            [self.view addSubview:self.editTask.view];
        }
        
    }
    
    // [self.navigationController pushViewController:objTaskDetailVC animated:YES];
}

-(void)TagCalenderListInvocationDidFinish:(TagCalenderListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [self.arrDateList removeAllObjects];
    [self.arrSelectedDateList removeAllObjects];
    
    [tblView reloadData];
    
    NSLog(@"%@",dict);
    
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                NSArray* post = [response valueForKey:@"task"];
                
                if ([post count]>0) {
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        NSDictionary *tDict = [post objectAtIndex:i];
                        
                        Task *task=[[Task alloc] init];
                        
                        task.taskId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                        task.taskTitle=NULL_TO_NIL([tDict valueForKey:@"title"]);
                        task.taskDesc=NULL_TO_NIL([tDict valueForKey:@"description"]);
                        
                        task.taskDate=NULL_TO_NIL([tDict valueForKey:@"taskAssignDateTime"]);
                        
                        task.taskCreatedOn = NULL_TO_NIL([tDict valueForKey:@"taskCretaedDateTime"]);
                        task.mngrName = NULL_TO_NIL([tDict valueForKey:@"manager_name"]);
                        task.repeatStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"repeat_option"])];
                        task.taskStatus = NULL_TO_NIL([tDict valueForKey:@"taskStatus"]);
                        
                        
                        [self.arrDateList addObject:task];
                        
                    }
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
    
    if (IS_DEVICE_IPAD) {
        
        calendar = [[VRGCalendarView alloc] init];
        
        calendar.delegate=self;
        
        [calView addSubview:calendar];
        
    }
    else
    {
        calendar_iphone = [[VRGCalenderViewIphone alloc] init];
        
        calendar_iphone.delegate=self;
        
        [calView addSubview:calendar_iphone];
        
    }
    
}
-(void)UserCalenderListInvocationDidFinish:(UserCalenderListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    [self.arrDateList removeAllObjects];
    [self.arrSelectedDateList removeAllObjects];
    [tblView reloadData];
    
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                NSArray* post = [response valueForKey:@"task"];
                
                if ([post count]>0) {
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        NSDictionary *tDict = [post objectAtIndex:i];
                        
                        Task *task=[[Task alloc] init];
                        
                        task.taskId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                        task.taskTitle=NULL_TO_NIL([tDict valueForKey:@"title"]);
                        task.taskDesc=NULL_TO_NIL([tDict valueForKey:@"description"]);
                        
                        task.taskCreatedOn = NULL_TO_NIL([tDict valueForKey:@"taskCretaedDateTime"]);
                        task.mngrName = NULL_TO_NIL([tDict valueForKey:@"manager_name"]);
                        task.taskDate=NULL_TO_NIL([tDict valueForKey:@"taskAssignDateTime"]);
                        task.repeatStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"repeat_option"])];
                        task.taskStatus = NULL_TO_NIL([tDict valueForKey:@"taskStatus"]);
                        
                        [self.arrDateList addObject:task];
                        
                    }
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
        [DSBezelActivityView removeView];
    }
    
    if (IS_DEVICE_IPAD) {
        

        NSLog(@"%@",self.arrDateList);
        
        calendar = [[VRGCalendarView alloc] init];
        
        calendar.delegate=self;
        
        [calView addSubview:calendar];
        
    }
    else
    {
        calendar_iphone = [[VRGCalenderViewIphone alloc] init];
        
        calendar_iphone.delegate=self;
        
        [calView addSubview:calendar_iphone];
        
    }
    
    

    [DSBezelActivityView removeView];
   

    
}

-(void)TagAssignCalendarListInvocationDidFinish:(TagAssignCalendarListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    [self.arrDateList removeAllObjects];
    [self.arrSelectedDateList removeAllObjects];
    
    [tblView reloadData];
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                NSArray *taskArr = NULL_TO_NIL([response valueForKey:@"task"]);
                
                for (int i=0; i < [taskArr count]; i++) {
                    
                    Task *tsk = [[Task alloc ] init];
                    
                    NSDictionary *taskD = [taskArr objectAtIndex:i];
                    
                    tsk.taskId = NULL_TO_NIL([taskD valueForKey:@"id"]);
                    tsk.taskTitle = [NULL_TO_NIL([taskD valueForKey:@"title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    tsk.taskDesc = [NULL_TO_NIL([taskD valueForKey:@"description"]) stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
                    tsk.taskDate = NULL_TO_NIL([taskD valueForKey:@"taskAssignDateTime"]);
                    tsk.taskCreatedOn = NULL_TO_NIL([taskD valueForKey:@"taskCretaedDateTime"]);
                    tsk.mngrID = NULL_TO_NIL([taskD valueForKey:@"manager_id"]);
                    tsk.mngrName = NULL_TO_NIL([taskD valueForKey:@"manager_name"]);
                    tsk.taskStatus = NULL_TO_NIL([taskD valueForKey:@"taskStatus"]);
                    tsk.repeatStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([taskD valueForKey:@"repeat_option"])];
                    tsk.assignedToSelf=[NSString stringWithFormat:@"%@",NULL_TO_NIL([taskD valueForKey:@"assign_to_self"])];
                    tsk.taskReminder=[NSString stringWithFormat:@"%@",NULL_TO_NIL([taskD valueForKey:@"reminder"])];
                    
                    NSArray *arrTags = NULL_TO_NIL([taskD valueForKey:@"tags"]);
                    
                    tsk.arrTags = [[NSMutableArray alloc ] init];
                    
                    for (int j=0; j<[arrTags count]; j++ ) {
                        
                        NSDictionary* tagD = [arrTags objectAtIndex:j];
                        
                        Tags *t = [[Tags alloc] init];
                        t.tagId = NULL_TO_NIL([tagD valueForKey:@"tag_id"]);
                        t.tagTitle = NULL_TO_NIL([tagD valueForKey:@"tag_title"]);
                        t.isSelected = TRUE;
                        
                        [tsk.arrTags addObject:t];
                    }
                    
                    NSArray *arrUsers = NULL_TO_NIL([taskD valueForKey:@"user"]);
                    
                    tsk.arrAssignUser = [[NSMutableArray alloc ] init];
                    
                    for (int k=0; k<[arrUsers count]; k++ ) {
                        
                        NSDictionary* userD = [arrUsers objectAtIndex:k];
                        
                        User *u = [[User alloc] init];
                        u.userId = NULL_TO_NIL([userD valueForKey:@"user_id"]);
                        u.username = NULL_TO_NIL([userD valueForKey:@"username"]);
                        u.isSelected = TRUE;
                        
                        [tsk.arrAssignUser addObject:u];
                    }
                    
                    [self.arrDateList addObject:tsk];
                    
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
    
    if (IS_DEVICE_IPAD) {
        
        calendar = [[VRGCalendarView alloc] init];
        
        calendar.delegate=self;
        
        [calView addSubview:calendar];
        
    }
    else
    {
        calendar_iphone = [[VRGCalenderViewIphone alloc] init];
        
        calendar_iphone.delegate=self;
        
        [calView addSubview:calendar_iphone];
        
    }
    
    
}
-(void)UserAssignCalandarListInvocationDidFinish:(UserAssignCalandarListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    [self.arrDateList removeAllObjects];
    [self.arrSelectedDateList removeAllObjects];
    
    [tblView reloadData];
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                NSArray *taskArr = NULL_TO_NIL([response valueForKey:@"task"]);
                
                for (int i=0; i < [taskArr count]; i++) {
                    
                    Task *tsk = [[Task alloc ] init];
                    
                    NSDictionary *taskD = [taskArr objectAtIndex:i];
                    
                    tsk.taskId = NULL_TO_NIL([taskD valueForKey:@"task_id"]);
                    tsk.taskTitle = [NULL_TO_NIL([taskD valueForKey:@"title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    tsk.taskDesc = [NULL_TO_NIL([taskD valueForKey:@"description"]) stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
                    tsk.taskDate = NULL_TO_NIL([taskD valueForKey:@"taskAssignDateTime"]);
                    tsk.taskCreatedOn = NULL_TO_NIL([taskD valueForKey:@"taskCretaedDateTime"]);
                    tsk.mngrID = NULL_TO_NIL([taskD valueForKey:@"manager_id"]);
                    tsk.mngrName = NULL_TO_NIL([taskD valueForKey:@"manager_name"]);
                    tsk.taskStatus = NULL_TO_NIL([taskD valueForKey:@"taskStatus"]);
                    tsk.repeatStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([taskD valueForKey:@"repeat_option"])];
                    tsk.assignedToSelf=[NSString stringWithFormat:@"%@",NULL_TO_NIL([taskD valueForKey:@"assign_to_self"])];
                    tsk.taskReminder=[NSString stringWithFormat:@"%@",NULL_TO_NIL([taskD valueForKey:@"reminder"])];
                    
                    //
                    NSArray *arrTags = NULL_TO_NIL([taskD valueForKey:@"tags"]);
                    
                    tsk.arrTags = [[NSMutableArray alloc ] init];
                    
                    for (int j=0; j<[arrTags count]; j++ ) {
                        
                        NSDictionary* tagD = [arrTags objectAtIndex:j];
                        
                        Tags *t = [[Tags alloc] init];
                        t.tagId = NULL_TO_NIL([tagD valueForKey:@"tag_id"]);
                        t.tagTitle = NULL_TO_NIL([tagD valueForKey:@"tag_title"]);
                        t.isSelected = TRUE;
                        
                        [tsk.arrTags addObject:t];
                    }
                    
                    NSArray *arrUsers = NULL_TO_NIL([taskD valueForKey:@"user"]);
                    
                    tsk.arrAssignUser = [[NSMutableArray alloc ] init];
                    
                    for (int k=0; k<[arrUsers count]; k++ ) {
                        
                        NSDictionary* userD = [arrUsers objectAtIndex:k];
                        
                        User *u = [[User alloc] init];
                        u.userId = NULL_TO_NIL([userD valueForKey:@"user_id"]);
                        u.username = NULL_TO_NIL([userD valueForKey:@"username"]);
                        u.isSelected = TRUE;
                        
                        [tsk.arrAssignUser addObject:u];
                    }
                    
                    [self.arrDateList addObject:tsk];
                    
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
    
    if (IS_DEVICE_IPAD) {
        
        calendar = [[VRGCalendarView alloc] init];
        
        calendar.delegate=self;
        
        [calView addSubview:calendar];
        
    }
    else
    {
        calendar_iphone = [[VRGCalenderViewIphone alloc] init];
        
        calendar_iphone.delegate=self;
        
        [calView addSubview:calendar_iphone];
        
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
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 680)];
            
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
