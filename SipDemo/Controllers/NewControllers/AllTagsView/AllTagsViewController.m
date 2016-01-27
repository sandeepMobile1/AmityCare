//
//  AllTagsViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "AllTagsViewController.h"
#import "Tags.h"
#import "ConfigManager.h"
#import "AllFeedListViewController.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface AllTagsViewController ()

@end

@implementation AllTagsViewController

@synthesize arrAllTagList,objAllFeedListViewController;

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
    self.arrAllTagList=[[NSMutableArray alloc] init];
    
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
        
        [[AmityCareServices sharedService] tagListInvocation:sharedAppDelegate.userObj.userId delegate:self];
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
    return [self.arrAllTagList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    return 44;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tagCellIdentifier = @"TagListCell";
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Tags *tag=[self.arrAllTagList objectAtIndex:indexPath.row];
    
    
    if (IS_DEVICE_IPAD) {
        
        self.objAllFeedListViewController=[[AllFeedListViewController alloc] initWithNibName:@"AllFeedListViewController" bundle:nil];
        
    }
    else
    {
        self.objAllFeedListViewController=[[AllFeedListViewController alloc] initWithNibName:@"AllFeedListViewController_iphone" bundle:nil];
        
    }
    self.objAllFeedListViewController.tagId=tag.tagId;
    [self.view addSubview:self.objAllFeedListViewController.view];
}
#pragma mark - Form List Invocation Delegates

- (void)AllTagsListInvocationDidFinish:(AllTagsListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        if(!error)
        {
            NSLog(@"Tags = %@",dict);
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                [self.arrAllTagList removeAllObjects];
                NSString *strSuccess = [response valueForKey:@"success"];
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSArray *tags = NULL_TO_NIL([response valueForKey:@"Tag"]);
                    
                    for (int i = 0; i < [tags count]; i++) {
                        
                        NSDictionary *tDict = [tags objectAtIndex:i];
                        
                        Tags *tag = [[Tags alloc] init];
                        
                        tag.tagId = NULL_TO_NIL([tDict valueForKey:@"id"]);
                        tag.tagTitle = NULL_TO_NIL([tDict valueForKey:@"title"]);
                        
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
            
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView] ;
        
        
        [tblView reloadData];
        
        sharedAppDelegate.unreadTagCount = 0;
        
    }
    
}
-(void)tagsListInvocationDidFinish:(TagsListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        if(!error)
        {
            NSLog(@"Tags = %@",dict);
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                [self.arrAllTagList removeAllObjects];
                NSString *strSuccess = [response valueForKey:@"success"];
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSArray *tags = NULL_TO_NIL([response valueForKey:@"Tag"]);
                    
                    for (int i = 0; i < [tags count]; i++) {
                        
                        NSDictionary *tDict = [tags objectAtIndex:i];
                        
                        Tags *tag = [[Tags alloc] init];
                        
                        tag.tagId = NULL_TO_NIL([tDict valueForKey:@"id"]);
                        tag.tagTitle = NULL_TO_NIL([tDict valueForKey:@"title"]);
                        
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
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView] ;
        
        
        [tblView reloadData];
        
        sharedAppDelegate.unreadTagCount = 0;
        
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
    
    
    // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
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
