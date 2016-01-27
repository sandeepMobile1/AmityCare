//
//  CompletedTagFormViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import "CompletedTagFormViewController.h"
#import "Tags.h"
#import "ConfigManager.h"
#import "CompletedTagFormDetailViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface CompletedTagFormViewController ()

@end

@implementation CompletedTagFormViewController

@synthesize arrAllTagList,objCompletedTagFormDetailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrAllTagList=[[NSMutableArray alloc] init];
    
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
    
    pageIndex=1;
    
    [self requestForGetTagList];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}

-(void)requestForGetTagList
{
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching form data..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];

        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:searchBar.text forKey:@"search_name"];
        // [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        
        [[AmityCareServices sharedService] TagCompletedFormListInvocation:dic delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
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
    
    if ([self.arrAllTagList count]>0) {
        
        if(recordCount > [self.arrAllTagList count])
            
            numberOfRows = [self.arrAllTagList count]+1;
        else
            
            numberOfRows = [self.arrAllTagList count];
    }
    
    return numberOfRows;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.arrAllTagList count])
    {
        
        return 44;
        
    }
    else
    {
        return 60;
    }
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tagCellIdentifier = @"TagListCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    
    if(indexPath.row < [self.arrAllTagList count])
    {
        UITableViewCell *tagCell = [tableView dequeueReusableCellWithIdentifier:tagCellIdentifier];
        
        if(!tagCell)
        {
            tagCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:tagCellIdentifier];
            
            [tagCell setBackgroundColor:[UIColor clearColor]];
            
            UILabel *lblName=[[UILabel alloc] init];
            [lblName setFrame:CGRectMake(10, 5,400,35)];
            [lblName setBackgroundColor:[UIColor clearColor]];
            [lblName setFont:[UIFont systemFontOfSize:14]];
            [lblName setTag:2];
            
            if(DEVICE_OS_VERSION_7_0)
                [tagCell.contentView addSubview:lblName];
            else
                [tagCell addSubview:lblName];
            
        }
        
        Tags *tag=[self.arrAllTagList objectAtIndex:indexPath.row];
        
        UILabel *lbl=(UILabel*)[tagCell viewWithTag:2];
        [lbl setText:tag.tagTitle];
        
        return tagCell;
        
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
        headerbutton.titleLabel.font = [UIFont fontWithName:appfontName size:16.0f];
        
        if (IS_DEVICE_IPAD) {
            
            [headerbutton setFrame:CGRectMake(0, 0, 418, 44)];
            
        }
        else
        {
            [headerbutton setFrame:CGRectMake(0, 0, 275, 44)];
            
        }
        
        [headerbutton addTarget:self action:@selector(loadMoreRecords) forControlEvents:UIControlEventTouchUpInside];
        
        if(DEVICE_OS_VERSION_7_0)
            [loadMoreCell.contentView addSubview:headerbutton];
        else
            [loadMoreCell addSubview:headerbutton];
        
        if (recordCount>[self.arrAllTagList count]) {
            
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
    NSLog(@"%ld",(long)indexPath.row);
    
    Tags *tag=[self.arrAllTagList objectAtIndex:indexPath.row];
    
    
    if (IS_DEVICE_IPAD) {
        
        self.objCompletedTagFormDetailViewController=[[CompletedTagFormDetailViewController alloc] initWithNibName:@"CompletedTagFormDetailViewController" bundle:nil];
        
    }
    else
    {
        self.objCompletedTagFormDetailViewController=[[CompletedTagFormDetailViewController alloc] initWithNibName:@"CompletedTagFormDetailViewController_iphone" bundle:nil];
        
    }
    self.objCompletedTagFormDetailViewController.tagId=tag.tagId;
    [self.view addSubview:self.objCompletedTagFormDetailViewController.view];
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    [self requestForGetTagList];
}
#pragma mark- UISearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    [tblView reloadData];
    [search resignFirstResponder];
    [self.arrAllTagList removeAllObjects];
    
    pageIndex=1;
    
    [self requestForGetTagList];
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
        [self.arrAllTagList removeAllObjects];
        
        pageIndex=1;
        
        [self requestForGetTagList];
        
    }
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)search
{
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}
#pragma mark - Form List Invocation Delegates

- (void)TagCompletedFormListInvocationDidFinish:(TagCompletedFormListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        if(!error)
        {
            NSLog(@"Tags = %@",dict);
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString *strSuccess = [response valueForKey:@"success"];
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                
                
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSArray *tags = NULL_TO_NIL([response valueForKey:@"tag"]);
                    
                    for (int i = 0; i < [tags count]; i++) {
                        
                        NSDictionary *tDict = [tags objectAtIndex:i];
                        
                        Tags *tag = [[Tags alloc] init];
                        
                        tag.tagId = NULL_TO_NIL([tDict valueForKey:@"tag_id"]);
                        tag.tagTitle = NULL_TO_NIL([tDict valueForKey:@"tag_title"]);
                        
                        [self.arrAllTagList addObject:tag];
                    }
                }
                else if([strSuccess rangeOfString:@"False"].length>0)
                {
                    [ConfigManager showAlertMessage:nil Message:@"You have not assigned any Tag"];
                }
                
                
                
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
        
    }
    @finally {
        [DSBezelActivityView removeView] ;
        
        NSLog(@"%lu",(unsigned long)[self.arrAllTagList count]);
        
        [tblView reloadData];
        [tblView setContentOffset:CGPointMake(0, 0)];

        sharedAppDelegate.unreadTagCount = 0;
        
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
