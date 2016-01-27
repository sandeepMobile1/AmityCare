//
//  UserCompletedFormViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import "UserCompletedFormViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
@interface UserCompletedFormViewController ()

@end

@implementation UserCompletedFormViewController

@synthesize arrUserList,selectedIndxpath,objUserCompletedFormDetailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrUserList=[[NSMutableArray alloc] init];
    pageIndex=1;
    
    searchBar.text=@"";
    
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
-(void)fetchAppsContacts
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        //[dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:searchBar.text forKey:@"search_name"];
        
        [[AmityCareServices sharedService] UserCompletedFormListInvocation:dic delegate:self];
        
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
    
    
    if ([self.arrUserList count]>0) {
        
        if(recordCount > [self.arrUserList count])
            
            numberOfRows = [self.arrUserList count]+1;
        else
            
            numberOfRows = [self.arrUserList count];
        
    }
    
    return numberOfRows;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdenitifier = @"ContactsCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    
    if(indexPath.row < [self.arrUserList count])
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
        
        ContactD *cData = [self.arrUserList objectAtIndex:indexPath.row];
        
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
        
        if (recordCount>[self.arrUserList count]) {
            
            [headerbutton setHidden:FALSE];
        }
        else
        {
            [headerbutton setHidden:TRUE];
            
        }
        
        return loadMoreCell;
    }
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactD *data=[self.arrUserList objectAtIndex:indexPath.row];
    
    
    if (IS_DEVICE_IPAD) {
        
        self.objUserCompletedFormDetailViewController=[[UserCompletedFormDetailViewController alloc] initWithNibName:@"UserCompletedFormDetailViewController" bundle:nil];
        
    }
    else
    {
        self.objUserCompletedFormDetailViewController=[[UserCompletedFormDetailViewController alloc] initWithNibName:@"UserCompletedFormDetailViewController_iphone" bundle:nil];
        
    }
    self.objUserCompletedFormDetailViewController.userIdStr=data.contact_id;
    [self.view addSubview:self.objUserCompletedFormDetailViewController.view];
    
}

-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    [self fetchAppsContacts];
}
#pragma mark- UISearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
    
    tblView.delegate=self;
    tblView.dataSource=self;
    [tblView reloadData];
    [search resignFirstResponder];
    [self.arrUserList removeAllObjects];
    
    pageIndex=1;
    
    [self fetchAppsContacts];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    if (searchText.length==0) {
        
        tblView.delegate=nil;
        tblView.dataSource=nil;
        
        tblView.delegate=self;
        tblView.dataSource=self;
        [tblView reloadData];
        
        
        [tblView reloadData];
        
        
        [search resignFirstResponder];
        [self.arrUserList removeAllObjects];
        
        pageIndex=1;
        
        [self fetchAppsContacts];
        
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)search
{
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}
#pragma mark- Invocation

-(void)UserCompletedFormListInvocationDidFinish:(UserCompletedFormListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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
                    cData.image = NULL_TO_NIL([cDict valueForKey:@"user_img"]);
                    cData.userName = NULL_TO_NIL([cDict valueForKey:@"username"]);
                    cData.introduction = NULL_TO_NIL([cDict valueForKey:@"intro"]);
                    
                    if (cData.userName.length>0) {
                        
                        [self.arrUserList addObject:cData];

                    }
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
