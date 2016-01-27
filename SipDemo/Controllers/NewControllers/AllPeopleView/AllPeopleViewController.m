//
//  AllPeopleViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 25/02/15.
//
//

#import "AllPeopleViewController.h"
#import "UIImageView+WebCache.h"
#import "PeopleData.h"
#import "AllContactTableViewCell.h"
#import "ScheduleLocationVC.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface AllPeopleViewController ()

@end

@implementation AllPeopleViewController

@synthesize arrAppsContacts,arrSearchContacts,objScheduleLocationVC;

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
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 630)];
            
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
    
    self.arrAppsContacts = [[NSMutableArray alloc] init];
    self.arrSearchContacts = [[NSMutableArray alloc] init];
    searchBar.text=@"";
    pageIndex=1;
    
    [self.arrAppsContacts removeAllObjects];
    
    [self performSelector:@selector(fetchAppsContacts) withObject:nil afterDelay:0.1f];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
        
    }
}
-(void)fetchAppsContacts
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:searchBar.text forKey:@"search_name"];
        
        [[AmityCareServices sharedService] AllUserListInvocation:dic delegate:self];
        
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
    
    if ([self.arrAppsContacts count]>0) {
        
        if(recordCount > [self.arrAppsContacts count])
            
            numberOfRows = [self.arrAppsContacts count]+1;
        else
            
            numberOfRows = [self.arrAppsContacts count];
        
    }
    return numberOfRows;
    
    
    // return isSearchEnable?[self.arrSearchContacts count]:[self.arrAppsContacts count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.arrAppsContacts count])
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
    
    if(indexPath.row < [self.arrAppsContacts count])
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
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        PeopleData *pData = [self.arrAppsContacts objectAtIndex:indexPath.row];
        
        
        [cell.btnClockInLocation setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        [cell.btnClockOutLocation setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        [cell.btnEditSchedule setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        
        [cell.btnEditSchedule setHidden:TRUE];
        
        [cell.btnClockInLocation addTarget:self action:@selector(btnClockInLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnClockOutLocation addTarget:self action:@selector(btnClockOutLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // [cell.btnEditSchedule addTarget:self action:@selector(btnEditSchedulePressed:) forControlEvents:UIControlEventTouchUpInside];
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
        
        if (recordCount>[self.arrAppsContacts count]) {
            
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
    
    [self fetchAppsContacts];
}
-(IBAction)btnClockInLocationPressed:(UIButton*)sender
{
    unsigned long int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    PeopleData *data=[self.arrAppsContacts objectAtIndex:index];
    
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
    unsigned long int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    PeopleData *data=[self.arrAppsContacts objectAtIndex:index];
    
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
#pragma mark- UISearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    isSearchEnable=TRUE;
    [tblViewContacts reloadData];
    [search resignFirstResponder];
    [self.arrAppsContacts removeAllObjects];
    
    pageIndex=1;
    
    [self fetchAppsContacts];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    if (searchText.length==0) {
        
        isSearchEnable=TRUE;
        [tblViewContacts reloadData];
        [search resignFirstResponder];
        [self.arrAppsContacts removeAllObjects];
        
        pageIndex=1;
        
        [self fetchAppsContacts];
        
    }
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)search
{
    isSearchEnable=FALSE;
}

#pragma mark - Contact List Invocation Delegates
-(void)AllUserListInvocationDidFinish:(AllUserListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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
                    pData.userClockInHour = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"hours"])];
                    pData.userClockInTag = NULL_TO_NIL([cDict valueForKey:@"title"]);
                    
                    pData.postId = NULL_TO_NIL([cDict valueForKey:@"updateId"]);
                    pData.userClockOutTime = NULL_TO_NIL([cDict valueForKey:@"clockOutDate"]);
                    pData.userClockInLatitude = NULL_TO_NIL([cDict valueForKey:@"clockInLatitude"]);
                    pData.userClockInLongitude = NULL_TO_NIL([cDict valueForKey:@"clockInLongitude"]);
                    pData.userClockOutLatitude = NULL_TO_NIL([cDict valueForKey:@"clockOutLatitude"]);
                    pData.userClockOutLongitude = NULL_TO_NIL([cDict valueForKey:@"clockInLongitude"]);
                    
                    [self.arrAppsContacts addObject:pData];
                }
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
            }
            [tblViewContacts reloadData];
            
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
        [DSBezelActivityView removeView];
        [tblViewContacts setContentOffset:CGPointMake(0, 0)];
    }
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
/*-(void)dealloc
 {
 NSLog(@"+++++ %@ +++ DEALLOC ",[self class]);
 searchBar = nil;
 [self.arrAppsContacts removeAllObjects];
 [self.arrSearchContacts removeAllObjects];
 self.arrAppsContacts = nil;
 self.arrSearchContacts = nil;
 tblViewContacts = nil;
 
 [super dealloc];
 }*/
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
