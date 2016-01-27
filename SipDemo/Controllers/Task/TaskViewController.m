//
//  TaskViewController.m
//  Amity-Care
//
//  Created by Vijay Kumar on 31/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskCell.h"
#import "TaskDetailVC.h"
#import "Tags.h"
#import "AddNewTaskVC.h"
#import "GetTaskListInvocation.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface TaskViewController ()<GetTaskListInvocationDelegate,TaskDelegate>
@property(nonatomic,strong) NSMutableArray *arrTaskList;
@end

@implementation TaskViewController
@synthesize arrTaskList;

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
    
    
    self.arrTaskList = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    if([ConfigManager isInternetAvailable ]){
        
        [self requestForTaskList];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------------
#pragma mark---- Other

-(void)fillWithDummyTask
{
    for (int i=0; i<20; i++) {
        Task *tsk = [[Task alloc] init];
        tsk.taskId = @"10332";
        tsk.taskTitle = @"Tahsi sdfisfasdf sdislkdfoiesl fjsidlasfndfeisl";
        tsk.taskDate = @"2014-05-09 04:23:59";
        tsk.mngrName = @"Vijay Kumar Yadav";
        tsk.taskDesc = @"TJkdfis lsidfal sdfI kdfijasldfl ajsdkf asjdflk al lksafd lasdfljlkdf alskdfjlkas dflksjdf lasdlkf slkdfjlk sdfjklsdfjlksjdflk jasldkfjals;dfjlaksdf jiejfljilsaksl'dkjfl a;lskjdf ;aklsjdfl;a sdfkjasfd klasjdf jdlfjlskdfjlsflsjdfk kjflksjkj kjsdlfkj sfasfsdfasfada sdfasfasfsfadfassdad d aff d sdfasf ";
        [self.arrTaskList addObject:tsk];
    }
}

-(void)requestForTaskList
{
    [arrTaskList removeAllObjects];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching task..." width:200];
    [[AmityCareServices sharedService] getTaskListInvocation:sharedAppDelegate.userObj.userId role:sharedAppDelegate.userObj.role delegate:self];
}

#pragma mark--------------


#pragma mark- UITableView & DataSource Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTaskList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* taskCellIdenifier = @"taskCellIdenifier";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdenifier];
    
    if (!cell) {
        cell = (TaskCell*)[[TaskCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:taskCellIdenifier];
    }
    
    [cell setTask:(Task*)[self.arrTaskList objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *t = [arrTaskList objectAtIndex:indexPath.row];
    
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

#pragma mark- Invocation
-(void)getTaskListInvocationDidFinish:(GetTaskListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getTaskListInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                [arrTaskList removeAllObjects];
                
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
                        //t.tagDesc = NULL_TO_NIL([tagD valueForKey:@"description"]);
                        
                        [tsk.arrTags addObject:t];
                    }
                    
                    [arrTaskList addObject:tsk];
                }
            }
            else{
                [arrTaskList removeAllObjects];
            }
            
            [tblViewTaskLst reloadData];
            
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
