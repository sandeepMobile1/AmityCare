//
//  ScheduleUserDetailViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 02/03/15.
//
//

#import "ScheduleUserDetailViewController.h"
#import "ConfigManager.h"
#import "UIImageView+WebCache.h"
#import "PeopleData.h"
#import "AllContactTableViewCell.h"
#import "EditScheduleListViewController.h"
#import "ScheduleLocationVC.h"
#import "AllContactTableViewCell.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
@interface ScheduleUserDetailViewController ()<AllContactTableViewCellDelegate>


@end

@implementation ScheduleUserDetailViewController

@synthesize arrScheduleList,userIdStr,startDate,endDate,objEditScheduleListViewController,objScheduleLocationVC,popoverController,popoverContent,popoverView;

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
    UIImage *searchBg = [UIImage imageNamed:@"search_box.png"];
    [[UISearchBar appearance] setBackgroundImage:searchBg];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_box.png"] forState:UIControlStateNormal];
    
    self.arrScheduleList = [[NSMutableArray alloc] init];
    pageIndex=1;
    
    txtStartDate.text=@"";
    txtEndDate.text=@"";
    txtTagName.text=@"";
    
    [self.arrScheduleList removeAllObjects];
    
    [self performSelector:@selector(requestForScheduleList) withObject:nil afterDelay:0.1f];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForUpdateScheduleList) name: AC_SCHEDULE_UPDATE object:nil];
    
    
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
}
-(void)requestForUpdateScheduleList
{
    if([ConfigManager isInternetAvailable]){
        
        [self.arrScheduleList removeAllObjects];
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
        
        pageIndex=1;
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:self.userIdStr forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        [dic setObject:txtTagName.text forKey:@"search_name"];
        
        [[AmityCareServices sharedService] ScheduleUserDetailInvocation:dic delegate:self];
        
    }

}
-(void)requestForScheduleList
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:self.userIdStr forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        [dic setObject:txtTagName.text forKey:@"search_name"];

        [[AmityCareServices sharedService] ScheduleUserDetailInvocation:dic delegate:self];
        
    }
}
-(IBAction)btnSearchPressed:(id)sender
{
    [txtTagName resignFirstResponder];
    [txtStartDate resignFirstResponder];
    [txtEndDate resignFirstResponder];
    
    pageIndex=1;

    if([ConfigManager isInternetAvailable])
    {
        if (txtTagName.text==nil || txtTagName.text==(NSString*)[NSNull null]) {
            
            txtTagName.text=@"";
        }
        if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
            
            txtEndDate.text=@"";
        }
        if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
            
            txtStartDate.text=@"";
        }
        
        if (txtEndDate.text.length>0 && txtStartDate.text.length==0) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please Select Start date"];
            
            return;
        }
        else if (txtStartDate.text.length>0 && txtEndDate.text.length==0) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please Select End date"];
            
            return;
        }
        else
        {
            pageIndex=1;
            [self.arrScheduleList removeAllObjects];
            [self requestForScheduleList];
            
        }
        
        
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    /* if ((txtTagName.text.length==0 && txtStartDate.text.length==0) && txtEndDate.text.length==0) {
     if([ConfigManager isInternetAvailable])
     {
     if (txtTagName.text==nil || txtTagName.text==(NSString*)[NSNull null]) {
     
     txtTagName.text=@"";
     }
     if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
     
     txtEndDate.text=@"";
     }
     if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
     
     txtStartDate.text=@"";
     }
     pageIndex=1;
     [self.arrScheduleList removeAllObjects];
     [self requestForScheduleList];
     
     
     
     }
     else
     {
     [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
     }
     //[ConfigManager showAlertMessage:nil Message:@"Please select filter criteria"];
     }
     else
     {
     
     if (txtTagName.text.length>0) {
     
     if([ConfigManager isInternetAvailable])
     {
     if (txtTagName.text==nil || txtTagName.text==(NSString*)[NSNull null]) {
     
     txtTagName.text=@"";
     }
     if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
     
     txtEndDate.text=@"";
     }
     if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
     
     txtStartDate.text=@"";
     }
     pageIndex=1;
     [self.arrScheduleList removeAllObjects];
     
     [self requestForScheduleList];
     
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
     if (txtTagName.text==nil || txtTagName.text==(NSString*)[NSNull null]) {
     
     txtTagName.text=@"";
     }
     if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
     
     txtEndDate.text=@"";
     }
     if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
     
     txtStartDate.text=@"";
     }
     pageIndex=1;
     [self.arrScheduleList removeAllObjects];
     [self requestForScheduleList];
     
     
     
     }
     else
     {
     [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
     }
     }
     
     }
     
     
     }*/
}
#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if ([self.arrScheduleList count]>0) {
        
        if(recordCount > [self.arrScheduleList count])
            
            numberOfRows = [self.arrScheduleList count]+1;
        else
            
            numberOfRows = [self.arrScheduleList count];
        
    }
    return numberOfRows;
    
    
    // return isSearchEnable?[self.arrSearchContacts count]:[self.arrAppsContacts count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.arrScheduleList count])
    {
        if (IS_DEVICE_IPAD) {
            
            return 100;
        }
        else
        {
            return 120;
            
        }
        
    }
    else
    {
        return 60;
    }
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdenitifier = @"ContactsCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    
    if(indexPath.row < [self.arrScheduleList count])
    {
        AllContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
        
        if(!cell)
        {
            NSArray* arr;
            
            if (IS_DEVICE_IPAD) {
                
                arr = [[NSBundle mainBundle] loadNibNamed:@"AllContactTableViewCell" owner:self options:nil];
            }
            else
            {
                arr = [[NSBundle mainBundle] loadNibNamed:@"AllContactTableViewCell_iphone" owner:self options:nil];
            }
            
            cell = [arr objectAtIndex:0];
        }
        cell.delegate = self;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        PeopleData *pData = [self.arrScheduleList objectAtIndex:indexPath.row];
        
        [cell.btnClockInLocation setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        [cell.btnClockOutLocation setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        [cell.btnEditSchedule setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        
        
        [cell.btnClockInLocation addTarget:self action:@selector(btnClockInLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnClockOutLocation addTarget:self action:@selector(btnClockOutLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnEditSchedule addTarget:self action:@selector(btnEditSchedulePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            if ([pData.userClockOutTime isEqualToString:@""]) {
                
                [cell.btnEditSchedule setHidden:FALSE];
            }
            else
            {
                [cell.btnEditSchedule setHidden:TRUE];
                
            }
            
        }
        else
        {
            [cell.btnEditSchedule setHidden:TRUE];
            
        }
        
        [cell setPeople:pData];
        
        return cell;
        
    }
    else
    {
        UITableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:defaultCellIdentifier];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    [self requestForScheduleList];
}
-(void)ScheduleUserDetailInvocationDidFinish:(ScheduleUserDetailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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
                    
                    PeopleData *pData = [[PeopleData alloc] init];
                    
                    pData.userId = NULL_TO_NIL([cDict valueForKey:@"id"]);
                    pData.tagId=NULL_TO_NIL([cDict valueForKey:@"tag_id"]);
                    pData.userImage = NULL_TO_NIL([cDict valueForKey:@"userImg"]);
                    pData.userName = NULL_TO_NIL([cDict valueForKey:@"nickname"]);
                    pData.userClockInTime = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"clockInDate"])];
                    pData.userClockOutTime = NULL_TO_NIL([cDict valueForKey:@"clockOutDate"]);
                    pData.userClockInCreatedTime = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"clockInCreatedDate"])];
                    pData.userClockOutCreatedTime = NULL_TO_NIL([cDict valueForKey:@"clockOutCreatedDate"]);
                    
                    pData.userClockInHour = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"hours"])];
                    pData.userClockInTag = NULL_TO_NIL([cDict valueForKey:@"title"]);
                    
                    pData.postId = NULL_TO_NIL([cDict valueForKey:@"updateId"]);
                    pData.userClockInLatitude = NULL_TO_NIL([cDict valueForKey:@"clockInLatitude"]);
                    pData.userClockInLongitude = NULL_TO_NIL([cDict valueForKey:@"clockInLongitude"]);
                    pData.userClockOutLatitude = NULL_TO_NIL([cDict valueForKey:@"clockOutLatitude"]);
                    pData.userClockOutLongitude = NULL_TO_NIL([cDict valueForKey:@"clockInLongitude"]);
                    pData.userEditedClockOutTime = NULL_TO_NIL([cDict valueForKey:@"managerclockOutDate"]);

                    pData.userClockOutAddress=@"";

                    NSString *currentAddress=@"";
                    
                    if (pData.userClockOutTime==nil || pData.userClockOutTime==(NSString*)[NSNull null] || [pData.userClockOutTime isEqualToString:@""]) {
                        
                        
                        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",latitude,longitude];
                        
                        NSError*error = nil;
                        
                        NSLog(@"LOCATION URL @@@ = %@",url);
                        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
                        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                        NSString *formattedAddress=@"";
                        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                        
                        NSLog(@"JSON @@@@@@ ---- =%@",results);
                        currentAddress = @"";
                        
                        NSMutableArray *tempArray=[results objectForKey:@"results"];
                        
                        for (NSMutableDictionary *dict in tempArray)
                        {
                            formattedAddress=[dict objectForKey:@"formatted_address"];
                            if (![formattedAddress isEqualToString:@""])
                            {
                                currentAddress = formattedAddress;
                                break;
                            }
                        }
                        
                       // pData.userClockOutTime=[NSString stringWithFormat:@"%@",currentAddress];
                        
                        pData.userClockOutAddress=[NSString stringWithFormat:@"%@",currentAddress];
                        
                        if (pData.userClockOutAddress==nil || pData.userClockOutAddress==(NSString*)[NSNull null]) {
                            
                            pData.userClockOutAddress=@"";
                        }
                        
                        pData.userClockOutLatitude=[NSString stringWithFormat:@"%f",latitude];
                        
                        pData.userClockOutLongitude=[NSString stringWithFormat:@"%f",longitude];
                        
                    }
                    
                    
                    [self.arrScheduleList addObject:pData];
                }
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
            }
            
            int totalHour=0;
            
            for (int i=0; i<[self.arrScheduleList count]; i++) {
                
                PeopleData *pData = [self.arrScheduleList objectAtIndex:i];
                
                totalHour=totalHour+[pData.userClockInHour intValue];
                
            }
            
            lblTotalHour.text=[NSString stringWithFormat:@"Total hour: %d",totalHour];
            [tblView reloadData];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
        [tblView setContentOffset:CGPointMake(0, 0)];

    }
}

-(IBAction)btnClockInLocationPressed:(UIButton*)sender
{
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    PeopleData *data=[self.arrScheduleList objectAtIndex:index];
    
    if (data.userClockInLatitude==nil || data.userClockInLatitude==(NSString*)[NSNull null] || [data.userClockInLatitude isEqualToString:@""]) {
        
        data.userClockInLatitude=@"0";
    }
    if (data.userClockInLongitude==nil || data.userClockInLongitude==(NSString*)[NSNull null] || [data.userClockInLongitude isEqualToString:@""]) {
        
        data.userClockInLongitude=@"0";
    }
    
    if ([data.userClockInLatitude intValue]<=0 && [data.userClockInLongitude intValue]<=0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Location not available"];
    }
    else
    {

    if (IS_DEVICE_IPAD) {
        
        self.objScheduleLocationVC=[[ScheduleLocationVC alloc] initWithNibName:@"ScheduleLocationVC" bundle:nil];
        
    }
    else
    {
        self.objScheduleLocationVC=[[ScheduleLocationVC alloc] initWithNibName:@"ScheduleLocationVC_iphone" bundle:nil];
        
    }
    self.objScheduleLocationVC.pData=data;
    self.objScheduleLocationVC.checkLocationView=@"clockin";
    [self.view addSubview:self.objScheduleLocationVC.view];
    
    }
}
-(IBAction)btnClockOutLocationPressed:(UIButton*)sender
{
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    PeopleData *data=[self.arrScheduleList objectAtIndex:index];
    
    if (data.userClockOutLatitude==nil || data.userClockOutLatitude==(NSString*)[NSNull null] || [data.userClockOutLatitude isEqualToString:@""]) {
        
        data.userClockOutLatitude=@"0";
    }
    if (data.userClockOutLongitude==nil || data.userClockOutLongitude==(NSString*)[NSNull null] || [data.userClockInLongitude isEqualToString:@""]) {
        
        data.userClockOutLongitude=@"0";
    }
    
    if ([data.userClockOutLatitude intValue]<=0 && [data.userClockOutLongitude intValue]<=0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Location not available"];
    }
    else
    {

    if (IS_DEVICE_IPAD) {
        
        self.objScheduleLocationVC=[[ScheduleLocationVC alloc] initWithNibName:@"ScheduleLocationVC" bundle:nil];
        
    }
    else
    {
        self.objScheduleLocationVC=[[ScheduleLocationVC alloc] initWithNibName:@"ScheduleLocationVC_iphone" bundle:nil];
        
    }
    self.objScheduleLocationVC.pData=data;
    self.objScheduleLocationVC.checkLocationView=@"clockout";
    [self.view addSubview:self.objScheduleLocationVC.view];
        
    }
}
-(IBAction)btnEditSchedulePressed:(UIButton*)sender
{
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    PeopleData *data=[self.arrScheduleList objectAtIndex:index];
    
    if (IS_DEVICE_IPAD) {
        
        self.objEditScheduleListViewController=[[EditScheduleListViewController alloc] initWithNibName:@"EditScheduleListViewController" bundle:nil];
        
    }
    else
    {
        self.objEditScheduleListViewController=[[EditScheduleListViewController alloc] initWithNibName:@"EditScheduleListViewController_iphone" bundle:nil];
        
    }
    self.objEditScheduleListViewController.pData=data;
    [self.view addSubview:self.objEditScheduleListViewController.view];
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
    [txtTagName resignFirstResponder];
    
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
    [txtTagName resignFirstResponder];
    
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
    [txtTagName resignFirstResponder];
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
