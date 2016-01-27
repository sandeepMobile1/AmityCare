//
//  SchedulButtonViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "SchedulButtonViewController.h"
#import "ConfigManager.h"
#import "ScheduleUserListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ScheduleUserDetailViewController.h"
#import "ScheduleData.h"
#import "SelfCreatedScheduleViewTableViewCell.h"
#import "AddScheduleViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface SchedulButtonViewController ()

@end

@implementation SchedulButtonViewController

@synthesize arrScheduleList,selectedIndxpath,startDate,endDate,popoverView,popoverContent,popoverController,objAddScheduleViewController,objScheduleUSerDetailViewController,deletedScheduleId;

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
            /*else if([sharedAppDelegate.userObj.role isEqualToString:@"6"]|| [sharedAppDelegate.userObj.role isEqualToString:@"8"])
             {
             [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 886)];
             
             }*/
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                
            }
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 675)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    self.arrScheduleList=[[NSMutableArray alloc] init];
    pageIndex=1;
    
    txtEmplyeeName.text=@"";
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    
    segment.selectedSegmentIndex=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScheduleList) name:AC_SCHEDULE_UPDATE object:nil];
    
    
    [self fetchAppsContacts];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateScheduleList
{
    [self.arrScheduleList removeAllObjects];
    
    if (segment.selectedSegmentIndex==0) {
        
        [self fetchAppsContacts];
    }
    else
    {
        [self fetchSelfCreatedScheduleList];
    }
}
-(void)fetchAppsContacts
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:txtEmplyeeName.text forKey:@"search_name"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        
        [[AmityCareServices sharedService] FilterScheduleListInvocation:dic delegate:self];
        
    }
}
-(void)fetchSelfCreatedScheduleList
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
       // [dic setObject:txtStartDate.text forKey:@"start_date"];
        //[dic setObject:txtEndDate.text forKey:@"end_date"];

        [[AmityCareServices sharedService] SelfCreatedScheduleListInvocation:dic delegate:self];
        
    }
    
}

-(IBAction)btnSearchPressed:(id)sender
{
    [txtEmplyeeName resignFirstResponder];
    pageIndex=1;

    if (segment.selectedSegmentIndex==0) {
        
    if ((txtEmplyeeName.text.length==0 && txtStartDate.text.length==0) && txtEndDate.text.length==0) {
        
        if([ConfigManager isInternetAvailable])
        {
            if (txtEmplyeeName.text==nil || txtEmplyeeName.text==(NSString*)[NSNull null]) {
                
                txtEmplyeeName.text=@"";
            }
            if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
                
                txtEndDate.text=@"";
            }
            if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
                
                txtStartDate.text=@"";
            }
            pageIndex=1;
            [self.arrScheduleList removeAllObjects];
            [self fetchAppsContacts];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        // [ConfigManager showAlertMessage:nil Message:@"Please select filter criteria"];
    }
    else
    {
        
        if (txtEmplyeeName.text.length>0) {
            
            if([ConfigManager isInternetAvailable])
            {
                if (txtEmplyeeName.text==nil || txtEmplyeeName.text==(NSString*)[NSNull null]) {
                    
                    txtEmplyeeName.text=@"";
                }
                if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
                    
                    txtEndDate.text=@"";
                }
                if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
                    
                    txtStartDate.text=@"";
                }
                pageIndex=1;
                [self.arrScheduleList removeAllObjects];
                [self fetchAppsContacts];
                
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
        }
        else
        {
            if (txtStartDate.text.length==0) {
                
            }
            else if(txtEndDate.text.length==0)
            {
                
            }
            else
            {
                if([ConfigManager isInternetAvailable])
                {
                    if (txtEmplyeeName.text==nil || txtEmplyeeName.text==(NSString*)[NSNull null]) {
                        
                        txtEmplyeeName.text=@"";
                    }
                    if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
                        
                        txtEndDate.text=@"";
                    }
                    if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
                        
                        txtStartDate.text=@"";
                    }
                    pageIndex=1;
                    [self.arrScheduleList removeAllObjects];
                    [self fetchAppsContacts];
                    
                    
                    
                }
                else
                {
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
            
        }
        
        
    }
        
    }
    else
    {
        if (txtStartDate.text.length==0 && txtEndDate.text.length==0) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please select start date and end date"];
        }
        else if(txtStartDate.text.length==0)
        {
            [ConfigManager showAlertMessage:nil Message:@"Please select start date"];

        }
        else if(txtEndDate.text.length==0)
        {
            [ConfigManager showAlertMessage:nil Message:@"Please select end date"];

        }
        else
        {
            [self fetchSelfCreatedScheduleList];

        }

    }
}
-(IBAction)btnSegmentPressed:(id)sender
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
    
    txtEmplyeeName.text=@"";
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    
    [self.arrScheduleList removeAllObjects];
    
    if (segment.selectedSegmentIndex==0) {
        
        [txtEmplyeeName setUserInteractionEnabled:TRUE];
        [txtStartDate setUserInteractionEnabled:TRUE];
        [txtEndDate setUserInteractionEnabled:TRUE];
        [btnSearch setEnabled:TRUE];
        
        [self fetchAppsContacts];
    }
    else
    {
        [txtEmplyeeName setUserInteractionEnabled:FALSE];
        [txtStartDate setUserInteractionEnabled:FALSE];
        [txtEndDate setUserInteractionEnabled:FALSE];
        [btnSearch setEnabled:FALSE];

        [self fetchSelfCreatedScheduleList];
    }
}
-(IBAction)deleteSchedulePressed:(UIButton*)sender
{
    self.deletedScheduleId=[sender titleForState:UIControlStateReserved];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Do you want to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
    
  
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dic setObject:self.deletedScheduleId forKey:@"schedule_id"];
            
            [[AmityCareServices sharedService] DeleteSelfCreatedScheduleINvocation:dic delegate:self];
            
        }

    }
}
#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (segment.selectedSegmentIndex==0) {
        
        if ([self.arrScheduleList count]>0) {
            
            if(recordCount > [self.arrScheduleList count])
                
                numberOfRows = [self.arrScheduleList count]+1;
            else
                
                numberOfRows = [self.arrScheduleList count];
            
        }
    }
    else
    {
        numberOfRows = [self.arrScheduleList count];
        
    }
    
    
    return numberOfRows;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        
        return 60;
    }
    else
    {
        if (IS_DEVICE_IPAD) {
            
            return 60;
        }
        else
        {
            return 75;
        }
    }
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdenitifier = @"ContactsCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    static NSString* scheduleCellIdentifier = @"ScheduleCell";
    
    if (segment.selectedSegmentIndex==0) {
        
        if(indexPath.row < [self.arrScheduleList count])
        {
            appCell = [tblView dequeueReusableCellWithIdentifier:cellIdenitifier];
            
            if(!appCell)
            {
                NSArray* arr;
                
                if (IS_DEVICE_IPAD) {
                    
                    arr = [[NSBundle mainBundle] loadNibNamed:@"ScheduleUserListTableViewCell" owner:self options:nil];
                }
                else
                {
                    arr = [[NSBundle mainBundle] loadNibNamed:@"ScheduleUserListTableViewCell_iphone" owner:self options:nil];
                }
                
                appCell = [arr objectAtIndex:0];
            }
            [appCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            ContactD *cData = [self.arrScheduleList objectAtIndex:indexPath.row];
            
            [appCell setContact:cData];
            
            return appCell;
            
        }
        else
        {
            UITableViewCell *loadMoreCell = [tblView dequeueReusableCellWithIdentifier:defaultCellIdentifier];
            
            if(!loadMoreCell)
            {
                loadMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:defaultCellIdentifier];
            }
            
            [loadMoreCell setBackgroundColor:[UIColor clearColor]];
            
            UIButton * headerbutton= [UIButton buttonWithType:UIButtonTypeCustom];
            [headerbutton setBackgroundImage:[UIImage imageNamed:@"green_btn.png"] forState:UIControlStateNormal];
            [headerbutton setTitle:@"Load more ..." forState:UIControlStateNormal];
            [headerbutton setTitle:@"Load more ..." forState:UIControlStateSelected];
            [headerbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [headerbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            headerbutton.titleLabel.font = [UIFont fontWithName:appfontName size:20.0f];
            
            if (IS_DEVICE_IPAD) {
                
                [headerbutton setFrame:CGRectMake(0, 0, 418, 60)];
                
            }
            else
            {
                [headerbutton setFrame:CGRectMake(0, 0, 275, 60)];
                
            }
            
            [headerbutton addTarget:self action:@selector(loadMoreRecords) forControlEvents:UIControlEventTouchUpInside];
            
            if(DEVICE_OS_VERSION_7_0)
                [loadMoreCell.contentView addSubview:headerbutton];
            else
                [loadMoreCell addSubview:headerbutton];
            
            if (recordCount>[self.arrScheduleList count]) {
                
                [headerbutton setHidden:FALSE];
            }
            else
            {
                [headerbutton setHidden:TRUE];
                
            }
            
            return loadMoreCell;
        }
        
    }
    else
    {
        
        scheduleCell = (SelfCreatedScheduleViewTableViewCell*)[tblView dequeueReusableCellWithIdentifier:scheduleCellIdentifier];
        
        if (Nil == scheduleCell)
        {
            scheduleCell = [SelfCreatedScheduleViewTableViewCell createTextRowWithOwner:self withDelegate:self];
        }
        
        ScheduleData *data=[self.arrScheduleList objectAtIndex:indexPath.row];
        
        scheduleCell.lblName.text=[[NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname] capitalizedString];
        scheduleCell.lblCreated.text=[NSString stringWithFormat:@"%@",data.ScheduleCreatedDate];
        scheduleCell.lblStartWeek.text=[NSString stringWithFormat:@"Start Week: %@",data.ScheduleStartWeek];
        scheduleCell.lblEndWeek.text=[NSString stringWithFormat:@"End Week: %@",data.ScheduleEndWeek];
        
        [scheduleCell.btnDelete setTitle:data.ScheduleId forState:UIControlStateReserved];
        
        [scheduleCell.btnDelete addTarget:self action:@selector(deleteSchedulePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [scheduleCell setBackgroundColor:[UIColor clearColor]];
        
        return scheduleCell;
        
        
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        
        ContactD *data=[self.arrScheduleList objectAtIndex:indexPath.row];
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objScheduleUSerDetailViewController=[[ScheduleUserDetailViewController alloc] initWithNibName:@"ScheduleUserDetailViewController" bundle:nil];
            
        }
        else
        {
            self.objScheduleUSerDetailViewController=[[ScheduleUserDetailViewController alloc] initWithNibName:@"ScheduleUserDetailViewController_iphone" bundle:nil];
            
        }
        self.objScheduleUSerDetailViewController.userIdStr=data.contact_id;
        [self.view addSubview:self.objScheduleUSerDetailViewController.view];
    }
    else
    {
        ScheduleData *data=[self.arrScheduleList objectAtIndex:indexPath.row];
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objAddScheduleViewController=[[AddScheduleViewController alloc] initWithNibName:@"AddScheduleViewController" bundle:nil];
            
        }
        else
        {
            self.objAddScheduleViewController=[[AddScheduleViewController alloc] initWithNibName:@"AddScheduleViewController_iphone" bundle:nil];
            
        }
        self.objAddScheduleViewController.sData=data;
        [self.view addSubview:self.objAddScheduleViewController.view];
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        
        return FALSE;
        
    }
    else
    {
        return TRUE;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedIndxpath = indexPath;
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Delete Schedule" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
    
    
}

-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    [self fetchAppsContacts];
}
#pragma mark- Invocation

-(void)FilterScheduleListInvocationDidFinish:(FilterScheduleListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"appContactsInvoationDidFinish %@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                NSArray* array = [response valueForKey:@"users"];
                
                for (int i=0; i< [array count]; i++) {
                    
                    NSDictionary* cDict = [array objectAtIndex:i];
                    
                    ContactD *cData = [[ContactD alloc] init];
                    
                    cData.contact_id = NULL_TO_NIL([cDict valueForKey:@"id"]);
                    cData.image = NULL_TO_NIL([cDict valueForKey:@"userImg"]);
                    cData.userName = NULL_TO_NIL([cDict valueForKey:@"nickname"]);
                    cData.introduction = NULL_TO_NIL([cDict valueForKey:@"intro"]);
                    cData.clockInTime = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"clockInDate"])];
                    
                    [self.arrScheduleList addObject:cData];
                }
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
            }
            
        }
        else
        {
            if (pageIndex>1) {
                
                pageIndex=pageIndex-1;
                
            }
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        
        tblView.delegate=self;
        tblView.dataSource=self;
        [tblView reloadData];
        
        [tblView setContentOffset:CGPointMake(0, 0)];
        [DSBezelActivityView removeView];
    }
}

-(void)SelfCreatedScheduleListInvocationDidFinish:(SelfCreatedScheduleListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            [self.arrScheduleList removeAllObjects];
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* schduleArray = NULL_TO_NIL([response valueForKey:@"schedule"]);
            
            NSLog(@"%@",schduleArray);
            
            for (int i=0; i< [schduleArray count]; i++) {
                
                NSDictionary *fDict = [schduleArray objectAtIndex:i];
                
                ScheduleData *sData = [[ScheduleData alloc] init];
                
                NSLog(@"%@",[fDict valueForKey:@"start_week"]);
                
                sData.ScheduleId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                sData.ScheduleStartWeek = NULL_TO_NIL([fDict valueForKey:@"start_week"]);
                sData.ScheduleEndWeek = NULL_TO_NIL([fDict valueForKey:@"end_week"]);
                sData.ScheduleTagId = NULL_TO_NIL([fDict valueForKey:@"tag_id"]);
                sData.ScheduleTagName = NULL_TO_NIL([fDict valueForKey:@"tag_title"]);
                
                NSLog(@"%@",[fDict valueForKey:@"created"]);
                
                sData.ScheduleCreatedDate = NULL_TO_NIL([fDict valueForKey:@"created"]);
                
                sData.ScheduleArray=[[NSMutableArray alloc] init];
                sData.ScheduleArray = NULL_TO_NIL([fDict valueForKey:@"ScheduleShift"]);
                sData.ScheduleUserArray=[[NSMutableArray alloc] init];
                
                NSArray *arrUsers = NULL_TO_NIL([fDict valueForKey:@"user"]);
                
                sData.ScheduleUserArray = [[NSMutableArray alloc ] init];
                
                for (int k=0; k<[arrUsers count]; k++ ) {
                    
                    NSDictionary* userD = [arrUsers objectAtIndex:k];
                    
                    User *u = [[User alloc] init];
                    u.userId = NULL_TO_NIL([userD valueForKey:@"user_id"]);
                    u.username = NULL_TO_NIL([userD valueForKey:@"username"]);
                    u.isSelected = TRUE;
                    
                    [sData.ScheduleUserArray addObject:u];
                }

                
                [self.arrScheduleList addObject:sData];
            }
            
        }
        else
        {
            if (pageIndex>1) {
                
                pageIndex=pageIndex-1;
                
            }
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"AppContacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        
        tblView.delegate=self;
        tblView.dataSource=self;
        [tblView reloadData];
        [tblView setContentOffset:CGPointMake(0, 0)];

        [DSBezelActivityView removeView];
    }
}
-(void)DeleteSelfCreatedScheduleINvocationDidFinish:(DeleteSelfCreatedScheduleINvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    {
        NSLog(@"deleteContactInvocationDidFinish =%@",dict);
        @try {
            if (!error) {
                
                id response = [dict valueForKey:@"response"];
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                    
                    [ConfigManager showAlertMessage:nil Message:@"Schedule not deleted"];
                }
                else
                    [self.arrScheduleList removeObjectAtIndex:self.selectedIndxpath.row];
                
                [tblView reloadData];
                
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception =%@",[exception description]);
        }
        @finally {
            [DSBezelActivityView removeView];
        }
        
    }
    
}

#pragma mark- UITextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:txtStartDate]){
        
        if (IS_DEVICE_IPAD) {
            
            self.popoverContent.view=nil;
            self.popoverContent=nil;
            [self.popoverView removeFromSuperview];
            self.popoverView=nil;
            
            if (self.popoverContent==nil) {
                
                self.popoverContent = [[UIViewController alloc] init];
                
                self.popoverView = [[UIView alloc] init];
                
                
            }
            self.popoverView.backgroundColor = [UIColor clearColor];
            
            toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
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
            datePicker.frame=CGRectMake(0,44,320, 216);
            datePicker.datePickerMode = UIDatePickerModeDate;
            
            [datePicker setTag:10];
            [self.popoverView addSubview:toolbar];
            [self.popoverView addSubview:datePicker];
            
            self.popoverContent.view = self.popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
            self.popoverController.delegate=self;
            
            txtStartDate.inputView=datePicker;
            
            [self.popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
            [self.popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self showStartDatePicker];
            
        }
        
        
    }
    else if([textField isEqual:txtEndDate]){
        
        
        if(txtStartDate.text.length ==0){
            [ConfigManager showAlertMessage:nil Message:@"Please select start date first"];
            return FALSE;
        }
        if (IS_DEVICE_IPAD) {
            
            self.popoverContent.view=nil;
            self.popoverContent=nil;
            [self.popoverView removeFromSuperview];
            self.popoverView=nil;
            
            if (self.popoverContent==nil) {
                
                self.popoverContent = [[UIViewController alloc] init];
                
                self.popoverView = [[UIView alloc] init];
                
                
            }
            self.popoverView.backgroundColor = [UIColor clearColor];
            
            toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                          target: self
                                                                                          action: @selector(cancel)];
            UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                   target: nil
                                                                                   action: nil];
            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                        target: self
                                                                                        action: @selector(endDone)];
            
            NSMutableArray* toolbarItems = [NSMutableArray array];
            [toolbarItems addObject:cancelButton];
            [toolbarItems addObject:space];
            [toolbarItems addObject:doneButton];
            
            toolbar.items = toolbarItems;
            
            datePicker=[[UIDatePicker alloc]init];
            datePicker.frame=CGRectMake(0,44,320, 216);
            datePicker.datePickerMode = UIDatePickerModeDate;
            
            [datePicker setTag:10];
            [self.popoverView addSubview:toolbar];
            [self.popoverView addSubview:datePicker];
            
            self.popoverContent.view = self.popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
            self.popoverController.delegate=self;
            
            txtEndDate.inputView=datePicker;
            
            [self.popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
            [self.popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self showEndDatePicker];
            
        }
        
    }
    else
    {
        return TRUE;
    }
    
    return FALSE;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return TRUE;
}
-(void)showStartDatePicker
{
    [txtEmplyeeName resignFirstResponder];
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    toolbar = [[UIToolbar alloc]init];
    
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
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:datePicker];
    [self.view addSubview:toolbar];
    
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 165.0+IPHONE_FIVE_FACTOR, 275, 44.0)];
        
        datePicker.frame=CGRectMake(0,200+IPHONE_FIVE_FACTOR,275, 216);
        [txtStartDate resignFirstResponder];
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 165.0, 320.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,200,275, 216);
        [txtStartDate resignFirstResponder];
    }
    
    
}
-(void)showEndDatePicker
{
    [txtEmplyeeName resignFirstResponder];
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    toolbar = [[UIToolbar alloc] init];
    
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(endDone)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
   
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    [self.view addSubview:datePicker];
    
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 165.0+IPHONE_FIVE_FACTOR, 275, 44.0)];
        datePicker.frame=CGRectMake(0,200+IPHONE_FIVE_FACTOR,275, 216);
        [txtEndDate resignFirstResponder];
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 165.0, 275, 44.0)];
        
        datePicker.frame=CGRectMake(0,200,275, 216);
        [txtEndDate resignFirstResponder];
    }
    
}
-(IBAction)cancel
{
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
        [txtStartDate resignFirstResponder];
        [txtEndDate resignFirstResponder];
    }
    
}
-(IBAction)done
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *dateStr = [formatter stringFromDate:dateSelected]; // Convert date
    
    self.startDate = [formatter dateFromString:dateStr];
    
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Start time should be less than end time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    txtStartDate.text = [formatter stringFromDate:dateSelected];
    
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
        [txtStartDate resignFirstResponder];
        [txtEndDate resignFirstResponder];
    }
}
-(IBAction)endDone
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *dateStr = [formatter stringFromDate:dateSelected]; // Convert date
    NSLog(@"%@",dateStr);
    
    self.endDate = [formatter dateFromString:dateStr];
    
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End time should be greater than start time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    txtEndDate.text = [formatter stringFromDate:dateSelected];
    
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
        [txtStartDate resignFirstResponder];
        [txtEndDate resignFirstResponder];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [txtEmplyeeName resignFirstResponder];
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
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

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
