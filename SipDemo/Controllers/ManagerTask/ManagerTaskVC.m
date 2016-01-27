//
//  ManagerTaskVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 10/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ManagerTaskVC.h"
#import "AddNewTaskVC.h"
#import "TaskDetailVC.h"
#import "TaskCell.h"
#import "Tags.h"
#import "MFSideMenu.h"
#import "GetAssignTaskInvocation.h"
#import "DeleteTaskInvocation.h"
#import "GetTaskListInvocation.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface ManagerTaskVC ()<GetTaskListInvocationDelegate,GetAssignTaskInvocationDelegate,
DeleteTaskInvocationDelegate,TaskDelegate>

@end

@implementation ManagerTaskVC
@synthesize arrMyTask,arrAssignedTask;

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
    
    if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
            
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [tblViewTaskList setFrame:CGRectMake(0, 55, 320, 445)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [tblViewTaskList setFrame:CGRectMake(0, 55, 320, 445-IPHONE_FIVE_FACTOR)];
                
            }
            
        }
        else
        {
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, 64, containerView.frame.size.width, containerView.frame.size.height)];
                
                [tblViewTaskList setFrame:CGRectMake(0, 55, 320, 440)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, 64, containerView.frame.size.width, containerView.frame.size.height)];
                
                
                [tblViewTaskList setFrame:CGRectMake(0, 55, 320, 440-IPHONE_FIVE_FACTOR)];
                
            }
            
            
        }
        
    }
    
    
    
      
    if (IS_DEVICE_IPAD) {
        
        [segmentCtrl setFrame:CGRectMake(111, 6, 302, 34)];
        
    }
    else
    {
        [segmentCtrl setFrame:CGRectMake(8, 6, 302, 34)];
        
    }
    
    if(DEVICE_OS_VERSION_7_0)
    {
        [segmentCtrl setImage:[[UIImage imageNamed:@"my_task_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [segmentCtrl setImage:[[UIImage imageNamed:@"assign_task.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    }
    else
    {
        [segmentCtrl setImage:[UIImage imageNamed:@"my_task_active.png"]  forSegmentAtIndex:0];
        [segmentCtrl setImage:[UIImage imageNamed:@"assign_task.png"] forSegmentAtIndex:1];
    }
    [segmentCtrl setSelectedSegmentIndex:0];
    
    
    self.arrMyTask = [[NSMutableArray alloc] init];
    
    self.arrAssignedTask = [[NSMutableArray alloc] init];
    
    [tblViewTaskList reloadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)leftBarButtonDidClicked:(id)sender{
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    if([ConfigManager isInternetAvailable])
    {
        if(segmentCtrl.selectedSegmentIndex==0)
        {
            [self requestForTaskList];
        }
        else{
            [self requestForManagerAssignTasks];
        }
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

#pragma mark--------------
#pragma mark---- Other


-(void)requestForTaskList
{
    [arrMyTask removeAllObjects];
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching task..." width:200];
    [[AmityCareServices sharedService] getTaskListInvocation:sharedAppDelegate.userObj.userId role:sharedAppDelegate.userObj.role delegate:self];
}

-(void)requestForManagerAssignTasks
{
    [arrAssignedTask removeAllObjects];
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Assigned task..." width:200];
    [[AmityCareServices sharedService] getAssignMngrTasksInvocation:sharedAppDelegate.userObj.userId role:sharedAppDelegate.userObj.role delegate:self];
}


#pragma mark- TopNavigation Delegate
-(void)rightBarButtonDidClicked:(id)sender
{
    //add new task
    AddNewTaskVC* addTask;
    
    if (IS_DEVICE_IPAD) {
        
        addTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
        
    }
    else
    {
        addTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
        
    }
    addTask.delegate = self;
    [self.navigationController pushViewController:addTask animated:YES];
}

#pragma mark- TaskStatusDelegate
-(void)taskStatusDidChanged:(BOOL)status
{
    if(status){
        
        [segmentCtrl setSelectedSegmentIndex:1];
        
        [self segmentAction:segmentCtrl];
    }
}

#pragma mark- UIAlertView

-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_CONFIRMATION_TASK_DELETE){
        
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
                Task* t = [arrAssignedTask objectAtIndex:selectedCellIndex];
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:150];
                [[AmityCareServices sharedService] deleteTaskInvocation:t.taskId userId:sharedAppDelegate.userObj.userId delegate:self];
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
        }
    }
}

#pragma mark- IBActions
-(IBAction)segmentAction:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    NSLog(@"segmentAction SelectedIndex=%ld",(long)segment.selectedSegmentIndex);
    if(segment.selectedSegmentIndex==0)
    {
        if(DEVICE_OS_VERSION_7_0){
            [segmentCtrl setImage:[[UIImage imageNamed:@"my_task_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
            [segmentCtrl setImage:[[UIImage imageNamed:@"assign_task.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        }
        else{
            [segmentCtrl setImage:[UIImage imageNamed:@"my_task_active.png"]  forSegmentAtIndex:0];
            [segmentCtrl setImage:[UIImage imageNamed:@"assign_task.png"] forSegmentAtIndex:1];
        }
        
        [self requestForTaskList];
        [segment setDividerImage:nil forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    else
    {
        
        if(DEVICE_OS_VERSION_7_0){
            [segmentCtrl setImage:[[UIImage imageNamed:@"my_task"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
            [segmentCtrl setImage:[[UIImage imageNamed:@"assign_task_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        }
        else{
            [segmentCtrl setImage:[UIImage imageNamed:@"my_task"]  forSegmentAtIndex:0];
            [segmentCtrl setImage:[UIImage imageNamed:@"assign_task_active"] forSegmentAtIndex:1];
        }
        
        [self requestForManagerAssignTasks];
        [segment setDividerImage:nil forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    [tblViewTaskList reloadData];
}

#pragma mark- UITableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* myTaskcellIdentifier = @"myTaskcellIdentifier";
    static NSString* assignTAskCellIdentifier = @"assignTAskCellIdentifier";
    NSArray *array = (!segmentCtrl.selectedSegmentIndex)?self.arrMyTask:self.arrAssignedTask;
    Task * tsk =[array objectAtIndex:indexPath.row ];
    
    TaskCell *cell = nil;
    if(segmentCtrl.selectedSegmentIndex==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:myTaskcellIdentifier];
        if(cell != nil)
        {
            cell = nil;
        }
        cell =  [[TaskCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myTaskcellIdentifier];
        
        if([tsk.taskStatus isEqualToString:@"complete"]){
            [cell setBackgroundColor:[UIColor colorWithRed:188.0/255 green:255.0/255 blue:126.0/255 alpha:0.25]];
        }
        [cell setTask:tsk];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:assignTAskCellIdentifier];
        if(cell != nil)
        {
            cell = nil;
        }
        cell =  [[TaskCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:assignTAskCellIdentifier];
        
        if([tsk.taskStatus isEqualToString:@"complete"]){
            [cell setBackgroundColor:[UIColor colorWithRed:188.0/255 green:255.0/255 blue:126.0/255 alpha:0.25]];
        }
        
        [cell setTask:tsk];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"index =%lu",(unsigned long)(!segmentCtrl.selectedSegmentIndex? [self.arrMyTask count]:[self.arrAssignedTask count]));
    return (!segmentCtrl.selectedSegmentIndex)? [self.arrMyTask count]:[self.arrAssignedTask count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(segmentCtrl.selectedSegmentIndex==0){
        
        Task *t = [self.arrMyTask objectAtIndex:indexPath.row];
        
        TaskDetailVC *objTaskDetailVC;
        
        if (IS_DEVICE_IPAD) {
            
            objTaskDetailVC=[[TaskDetailVC alloc] initWithNibName:@"TaskDetailVC" bundle:nil];
        }
        else
        {
            objTaskDetailVC=[[TaskDetailVC alloc] initWithNibName:@"TaskDetailVC_iphone" bundle:nil];
        }
        objTaskDetailVC.taskObj = t;
        objTaskDetailVC.checkView=@"";
        
        [self.navigationController pushViewController:objTaskDetailVC animated:YES];
    }
    else
    {
        Task *t = [self.arrAssignedTask objectAtIndex:indexPath.row];
        if([t.taskStatus isEqualToString:@"complete"]){
            [ConfigManager showAlertMessage:nil Message:@"Task has been completed"];
        }
        else{
            AddNewTaskVC* editTask;
            
            if (IS_DEVICE_IPAD) {
                
                editTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
                
            }
            else
            {
                editTask = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
                
            }
            
            editTask.delegate = self;
            editTask.isEditTask = YES;
            editTask.taskDetails = t;
            [self.navigationController pushViewController:editTask animated:YES];
        }
    }
}
#pragma mark- TableViewEditing

//tableview datasource method
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(segmentCtrl.selectedSegmentIndex==1){
        return TRUE;
    }
    return FALSE;
}

//tableview delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(segmentCtrl.selectedSegmentIndex==1){
        
        selectedCellIndex = indexPath.row;
        
        ACAlertView* deleteConfimationAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Task" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteConfimationAlert.alertTag = AC_ALERTVIEW_CONFIRMATION_TASK_DELETE;
        [deleteConfimationAlert show];
        
    }
}


#pragma mark- Invocation

-(void)deleteTaskInvocationDidFinish:(DeleteTaskInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getTaskListInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                [arrAssignedTask removeObjectAtIndex:selectedCellIndex];
                
                [tblViewTaskList beginUpdates];
                [tblViewTaskList deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [tblViewTaskList endUpdates];
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
                [ConfigManager showAlertMessage:nil Message:@"Task not deleted"];
                
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

-(void)getAssignTaskInvocationDidFinish:(GetAssignTaskInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getAssignListInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                [arrAssignedTask removeAllObjects];
                
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
                    
                    [arrAssignedTask addObject:tsk];
                    
                    [tblViewTaskList reloadData];
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

-(void)getTaskListInvocationDidFinish:(GetTaskListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getTaskListInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                [arrMyTask removeAllObjects];
                
                NSArray *taskArr = NULL_TO_NIL([response valueForKey:@"task"]);
                
                for (int i=0; i < [taskArr count]; i++) {
                    
                    Task *tsk = [[Task alloc ] init];
                    
                    NSDictionary *taskD = [taskArr objectAtIndex:i];
                    
                    tsk.taskId = NULL_TO_NIL([taskD valueForKey:@"task_id"]);
                    tsk.taskTitle = [NULL_TO_NIL([taskD valueForKey:@"title"]) stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
                    tsk.taskDesc = [NULL_TO_NIL([taskD valueForKey:@"description"]) stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
                    tsk.taskDate = NULL_TO_NIL([taskD valueForKey:@"taskAssignDateTime"]);
                    tsk.taskCreatedOn = NULL_TO_NIL([taskD valueForKey:@"taskCretaedDateTime"]);
                    tsk.mngrID = NULL_TO_NIL([taskD valueForKey:@"manager_id"]);
                    tsk.mngrName = NULL_TO_NIL([taskD valueForKey:@"manager_name"]);
                    tsk.repeatStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([taskD valueForKey:@"repeat_option"])];
                    
                    NSArray *arrTags = NULL_TO_NIL([taskD valueForKey:@"tags"]);
                    
                    tsk.arrTags = [[NSMutableArray alloc ] init];
                    
                    for (int j=0; j<[arrTags count]; j++ ) {
                        
                        NSDictionary* tagD = [arrTags objectAtIndex:j];
                        
                        Tags *t = [[Tags alloc] init];
                        
                        t.tagId = NULL_TO_NIL([tagD valueForKey:@"tag_id"]);
                        t.tagTitle = NULL_TO_NIL([tagD valueForKey:@"title"]);
                        
                        [tsk.arrTags addObject:t];
                    }
                    
                    [arrMyTask addObject:tsk];
                    [tblViewTaskList reloadData];
                    
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


@end

