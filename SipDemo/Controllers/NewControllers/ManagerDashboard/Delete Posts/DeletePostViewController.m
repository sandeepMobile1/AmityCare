//
//  DeletePostViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import "DeletePostViewController.h"
#import "ConfigManager.h"
#import "UIImageView+WebCache.h"
#import "Feeds.h"
#import "InboxData.h"
#import "QSStrings.h"
#import "FormDetailTableViewCell.h"
#import "FormButtonEmailTableViewCell.h"
#import "InboxDetailViewController.h"
#import "FormFeedDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "FeedDetailViewController.h"
#import "FormButtonTableViewCell.h"
#import "CommentValues.h"
#import "FormValues.h"
#import "FormsField.h"
#import "NSString+urlDecode.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "RouteFeedDetailViewController.h"
#import "RecieptFeedDetailViewController.h"

@interface DeletePostViewController ()

@end

@implementation DeletePostViewController

@synthesize arrEmailList,arrFeedList,startDate,endDate,selectedIndxpath,objStatusFeedDetailViewController,objFormFeedDetailViewController,objFeedDetailViewController,objInboxDetailViewController,popoverView,popoverContent,popoverController,objRouteFeedDetailViewController,objRecieptFeedDetailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndex=1;
    
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
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    searchBar.text=@"";
    
    self.arrFeedList=[[NSMutableArray alloc] init];
    self.arrEmailList=[[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    
    [self requestForPost];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma Mark Webservice Request methods------

-(void)requestForPost
{
    [txtEndDate setHidden:FALSE];
    [txtStartDate setHidden:FALSE];
    [imgStartDate setHidden:FALSE];
    [imgEndDate setHidden:FALSE];
    [btnSearch setHidden:FALSE];
    [searchBar setHidden:TRUE];
    
    
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching form data..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        
        [[AmityCareServices sharedService] AllPostListInvocation:dic delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)requestForStatus
{
    
    [txtEndDate setHidden:FALSE];
    [txtStartDate setHidden:FALSE];
    [imgStartDate setHidden:FALSE];
    [imgEndDate setHidden:FALSE];
    [btnSearch setHidden:FALSE];
    [searchBar setHidden:TRUE];
    
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching form data..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        
        [[AmityCareServices sharedService] ScheduleStatusListInvocation:dic delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)requestForEmail
{
    [searchBar setHidden:FALSE];
    [btnSearch setHidden:TRUE];
    
    [txtEndDate setHidden:TRUE];
    [txtStartDate setHidden:TRUE];
    [imgStartDate setHidden:TRUE];
    [imgEndDate setHidden:TRUE];
    
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching form data..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        //[dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
        [dic setObject:searchBar.text forKey:@"search_name"];
        
        [[AmityCareServices sharedService] DeleteEmailListInvocation:dic delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(IBAction)btnSearchPressed:(id)sender
{
    if (txtStartDate.text.length>0 && txtEndDate.text.length>0) {
        
        tblView.delegate=nil;
        tblView.dataSource=nil;
        
        [tblView reloadData];
        
        tblView.delegate=self;
        tblView.dataSource=self;
        
        [self.arrFeedList removeAllObjects];
        [self.arrEmailList removeAllObjects];
        pageIndex=1;

        [tblView reloadData];
        
        if (segment.selectedSegmentIndex==0) {
            
            [self requestForPost];
        }
        
        else if (segment.selectedSegmentIndex==2) {
            
            [self requestForStatus];
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Please select start date or end date"];
    }
    
}
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}

-(IBAction)segmentPressed:(id)sender
{
    txtStartDate.text=@"";
    txtEndDate.text=@"";
    
    tblView.delegate=nil;
    tblView.dataSource=nil;
    
    [tblView reloadData];
    
    tblView.delegate=self;
    tblView.dataSource=self;
    
    [self.arrFeedList removeAllObjects];
    [self.arrEmailList removeAllObjects];
    
    [tblView reloadData];
    
    pageIndex=1;
    
    if (segment.selectedSegmentIndex==0) {
        
        [self requestForPost];
    }
    else if (segment.selectedSegmentIndex==1) {
        
        [self requestForEmail];
    }
    else if (segment.selectedSegmentIndex==2) {
        
        [self requestForStatus];
    }
    
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    if (segment.selectedSegmentIndex==0) {
        
        [self requestForPost];
        
    }
    else if (segment.selectedSegmentIndex==1) {
        
        [self requestForEmail];
        
    }
    else
    {
        [self requestForStatus];
        
    }
}

#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount=0;
    
    if (segment.selectedSegmentIndex==1) {
        
        NSInteger numberOfRows = 0;
        
        NSLog(@"%d",recordCount);
        NSLog(@"%lu",(unsigned long)[self.arrEmailList count]);
        
        if ([self.arrEmailList count]>0) {
            
            if(recordCount > [self.arrEmailList count])
                
                numberOfRows = [self.arrEmailList count]+1;
            else
                
                numberOfRows = [self.arrEmailList count];
            
            
            rowCount=numberOfRows;
            
            
        }
    }
    else{
        
        NSInteger numberOfRows = 0;
        
        NSLog(@"%d",recordCount);
        NSLog(@"%lu",(unsigned long)[self.arrFeedList count]);
        
        if ([self.arrFeedList count]>0) {
            
            if(recordCount > [self.arrFeedList count])
                
                numberOfRows = [self.arrFeedList count]+1;
            else
                
                numberOfRows = [self.arrFeedList count];
            
            
            rowCount=numberOfRows;
        }
        
        
        
    }
    
    return rowCount;
    
    // return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==1)
    {
        if (indexPath.row<[self.arrEmailList count]) {
            
            return 90;
            
        }
        else
        {
            return 60;
            
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
    static NSString* feedCellIdentifier = @"FeedListCell";
    static NSString* emailCellIdentifier = @"EmailListCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    
    if (segment.selectedSegmentIndex==1) {
        
        if (indexPath.row<[self.arrEmailList count]) {
            
            inboxCell = (DeleteEmailTableViewCell*)[tblView dequeueReusableCellWithIdentifier:emailCellIdentifier];
            
            if (Nil == inboxCell)
            {
                inboxCell = [DeleteEmailTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            inboxCell.cellDelegate=self;
            
            InboxData *data=[self.arrEmailList objectAtIndex:indexPath.row];
            
            inboxCell.lblDate.text=data.mailDate;
            inboxCell.lblSubject.text=data.mailSubject;
            inboxCell.lblTitle.text=data.mailFrom;
            
            [inboxCell.lblTitle setTextColor:[UIColor blackColor]];
            inboxCell.lblMessage.attributedText=data.mail_short_desc;
            
            [inboxCell.lblMessage setTextColor:[UIColor lightGrayColor]];
            
            [inboxCell.lblMessage setFont:[UIFont systemFontOfSize:13]];
            
            
            if(data.mailAttechment!=nil )
            {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attachment.png"]] ;
                imageView.frame =CGRectMake(0, 0, 18, 18);
                inboxCell.accessoryView = imageView;
            }
            
            [inboxCell setBackgroundColor:[UIColor clearColor]];
            return inboxCell;
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
            
            if (recordCount>[self.arrFeedList count]) {
                
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
        if(indexPath.row < [self.arrFeedList count])
        {
            feedCell = (FormButtonTableViewCell*)[tblView dequeueReusableCellWithIdentifier:feedCellIdentifier];
            
            if (Nil == feedCell)
            {
                feedCell = [FormButtonTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            feedCell.delegate=self;
            
            Feeds *data=[self.arrFeedList objectAtIndex:indexPath.row];
            
            feedCell.lblName.text=data.postUserName;
            feedCell.lblIntro.text=data.postDesc;
            feedCell.lbldate.text=data.postTime;
            feedCell.lblTagName.text=[NSString stringWithFormat:@"Tag: %@",data.tagTitle];
            
            feedCell.imgView.layer.cornerRadius = floor(feedCell.imgView.frame.size.width/2);
            feedCell.imgView.clipsToBounds = YES;
            
            [feedCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,data.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
            
            [feedCell setBackgroundColor:[UIColor clearColor]];
            
            feedCell.lblName.font = [UIFont fontWithName:boldfontName size:15.0];
            feedCell.lblIntro.font = [UIFont fontWithName:appfontName size:11.0f];
            
            return feedCell;
            
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
            
            if (recordCount>[self.arrFeedList count]) {
                
                [headerbutton setHidden:FALSE];
            }
            else
            {
                [headerbutton setHidden:TRUE];
                
            }
            
            return loadMoreCell;
        }
        
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    
    if (segment.selectedSegmentIndex==0) {
        
        Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
        
        if (IS_DEVICE_IPAD) {
            
            if ([feed.postType isEqualToString:@"6"]) {
                
                [self dissmissView];
                
                
                self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController" bundle:nil];
                
                self.objFormFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                
                self.objFormFeedDetailViewController.feedDetails=feed;
                self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objFormFeedDetailViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                
                [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else if([feed.postType isEqualToString:@"4"])
            {
                [self dissmissView];
                
                self.objStatusFeedDetailViewController=[[StatusFeedDetailViewController alloc] initWithNibName:@"StatusFeedDetailViewController" bundle:nil];
                
                self.objStatusFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                self.objStatusFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objStatusFeedDetailViewController.feedDetails=feed;
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objStatusFeedDetailViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                
                [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else if([feed.postType isEqualToString:@"7"])
            {
                if ([feed.routeType isEqualToString:@"1"]) {
                    
                    if (IS_DEVICE_IPAD) {
                        
                        [self.popoverController dismissPopoverAnimated:YES];
                        
                        self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController" bundle:nil];
                        
                        self.objRouteFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                        
                        self.objRouteFeedDetailViewController.feedDetails=feed;
                        self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRouteFeedDetailViewController];
                        
                        self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                        
                        [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                    else
                    {
                        self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController_iphone" bundle:nil];
                        
                        self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.objRouteFeedDetailViewController.feedDetails=feed;
                        
                        [sharedAppDelegate.window addSubview:self.objRouteFeedDetailViewController.view];
                    }
                    
                }
                else
                {
                    if (IS_DEVICE_IPAD) {
                        
                        [self.popoverController dismissPopoverAnimated:YES];
                        
                        self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController" bundle:nil];
                        
                        self.objRecieptFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                        
                        self.objRecieptFeedDetailViewController.feedDetails=feed;
                        self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRecieptFeedDetailViewController];
                        
                        self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                        
                        [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                    else
                    {
                        self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController_iphone" bundle:nil];
                        
                        self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.objRecieptFeedDetailViewController.feedDetails=feed;
                        
                        [sharedAppDelegate.window addSubview:self.objRecieptFeedDetailViewController.view];
                    }
                    
                }
                
                
            }
            else
            {
                [self dissmissView];
                
                self.objFeedDetailViewController=[[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
                
                self.objFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                
                self.objFeedDetailViewController.feedDetails=feed;
                self.objFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objFeedDetailViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                
                [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
        }
        else
        {
            if ([feed.postType isEqualToString:@"6"]) {
                
                self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController_iphone" bundle:nil];
                
                self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objFormFeedDetailViewController.feedDetails=feed;
                
                [sharedAppDelegate.window addSubview:self.objFormFeedDetailViewController.view];
            }
            else if([feed.postType isEqualToString:@"4"])
            {
                self.objStatusFeedDetailViewController=[[StatusFeedDetailViewController alloc] initWithNibName:@"StatusFeedDetailViewController_iphone" bundle:nil];
                
                self.objStatusFeedDetailViewController.feedDetails=feed;
                self.objStatusFeedDetailViewController.checkBSAndFamily=@"NO";
                
                [sharedAppDelegate.window addSubview:self.objStatusFeedDetailViewController.view];
            }
            else if([feed.postType isEqualToString:@"7"])
            {
                self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController_iphone" bundle:nil];
                self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objRouteFeedDetailViewController.feedDetails=feed;
                
                [sharedAppDelegate.window addSubview:self.objRouteFeedDetailViewController.view];
            }
            else
            {
                self.objFeedDetailViewController=[[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController_iphone" bundle:nil];
                self.objFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objFeedDetailViewController.feedDetails=feed;
                
                [sharedAppDelegate.window addSubview:self.objFeedDetailViewController.view];
            }
            
        }
        
    }
    
    else if(segment.selectedSegmentIndex==2)
    {
        Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
        
        if (IS_DEVICE_IPAD) {
            
            [self dissmissView];
            
            self.objStatusFeedDetailViewController=[[StatusFeedDetailViewController alloc] initWithNibName:@"StatusFeedDetailViewController" bundle:nil];
            
            self.objStatusFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
            self.objStatusFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.objStatusFeedDetailViewController.feedDetails=feed;
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objStatusFeedDetailViewController];
            
            self.popoverController.popoverContentSize= CGSizeMake(450, 780);
            
            [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            
            self.objStatusFeedDetailViewController=[[StatusFeedDetailViewController alloc] initWithNibName:@"StatusFeedDetailViewController_iphone" bundle:nil];
            self.objStatusFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.objStatusFeedDetailViewController.feedDetails=feed;
            [sharedAppDelegate.window addSubview:self.objStatusFeedDetailViewController.view];
        }
    }
    else
    {
        
        if (IS_DEVICE_IPAD) {
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
            
            self.objInboxDetailViewController=[[InboxDetailViewController alloc] init];
            
            self.objInboxDetailViewController.arrMailData=[[NSMutableArray alloc] initWithArray:self.arrEmailList];
            self.objInboxDetailViewController.selectedIndex=indexPath.row;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objInboxDetailViewController];
            
            self.popoverController.popoverContentSize= CGSizeMake(450, 700);
            
            [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        else
        {
            self.objInboxDetailViewController=[[InboxDetailViewController alloc] initWithNibName:@"InboxDetailViewController_iphone" bundle:nil];
            
            
            self.objInboxDetailViewController.arrMailData=[[NSMutableArray alloc] initWithArray:self.arrEmailList];
            self.objInboxDetailViewController.selectedIndex=indexPath.row;
            
            
            [sharedAppDelegate.window addSubview:self.objInboxDetailViewController.view];
            
        }
        
    }
    
}
/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return TRUE;
 
 }
 
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 self.selectedIndxpath = indexPath;
 
 NSLog(@"%d",self.selectedIndxpath.row);
 
 if (segment.selectedSegmentIndex==0) {
 
 ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Post ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
 deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
 [deleteAlert show];
 
 
 }
 else if(segment.selectedSegmentIndex==1)
 {
 ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Mail ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
 deleteAlert.alertTag = AC_ALERTVIEW_DELETE_MAIL_CONFIRMATION;
 [deleteAlert show];
 
 
 }
 else
 {
 ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Post ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
 deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
 [deleteAlert show];
 
 
 }
 }*/
-(void)ScheduleStatusListInvocationDidFinish:(ScheduleStatusListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                // pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]>0)
                {
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        Feeds *feed = [[Feeds alloc] init];
                        
                        NSDictionary *fDict = [post objectAtIndex:i];
                        
                        feed.postUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.postUserName = NULL_TO_NIL([fDict valueForKey:@"username"]);
                        feed.postUserImgURL = NULL_TO_NIL([fDict valueForKey:@"user_img"]);
                        feed.postId = NULL_TO_NIL([fDict valueForKey:@"post_id"]);
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]
                                         stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
                        feed.employeeStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"employee"])];
                        feed.managerStatusStr    = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"manager"])];
                        feed.teamLeaderStatusStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"teamleader"])];
                        feed.familyStatusStr     = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"family"])];
                        //  feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        feed.tagTitle         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"tagName"])];
                        
                        feed.arrSimiliarTags = [[NSMutableArray alloc ]  init];
                        
                        NSArray *fTags = NULL_TO_NIL([fDict valueForKey:@"similar_tags"]);
                        
                        for (int j = 0; j <[fTags count]; j++) {
                            
                            NSDictionary *inner = [fTags objectAtIndex:j];
                            
                            Tags *t = [[Tags alloc] init];
                            
                            t.tagId = NULL_TO_NIL([inner valueForKey:@"tag_id"]);
                            t.tagTitle = NULL_TO_NIL([inner valueForKey:@"tag_title"]);
                            
                            [feed.arrSimiliarTags addObject:t];
                        }
                        
                        feed.arrCommentValues = [[NSMutableArray alloc ]  init];
                        
                        NSArray *fCommentValues = NULL_TO_NIL([fDict valueForKey:@"comment"]);
                        
                        for (int j = 0; j <[fCommentValues count]; j++) {
                            
                            NSDictionary *inner = [fCommentValues objectAtIndex:j];
                            
                            CommentValues *t = [[CommentValues alloc] init];
                            
                            t.commentId = NULL_TO_NIL([inner valueForKey:@"id"]);
                            t.commentUserId = NULL_TO_NIL([inner valueForKey:@"userId"]);
                            t.commentUserName = NULL_TO_NIL([inner valueForKey:@"username"]);
                            t.commentUserImage = NULL_TO_NIL([inner valueForKey:@"user_img"]);
                            t.commentDate = NULL_TO_NIL([inner valueForKey:@"time"]);
                            
                            NSString *msgStr=NULL_TO_NIL([inner valueForKey:@"comment"]);
                            
                            msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                            
                            t.commentMsg = [[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                            
                            [feed.arrCommentValues addObject:t];
                        }
                        NSDictionary *tDict = NULL_TO_NIL([fDict valueForKey:@"rootPath"]);
                        
                        feed.routeId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                        feed.routeCreated=NULL_TO_NIL([tDict valueForKey:@"created"]);
                        feed.routeStartLatitude=NULL_TO_NIL([tDict valueForKey:@"start_latitude"]);
                        feed.routeStartLongitude=NULL_TO_NIL([tDict valueForKey:@"start_longitude"]);
                        feed.routeEndLatitude=NULL_TO_NIL([tDict valueForKey:@"end_latitude"]);
                        feed.routeEndLongitude=NULL_TO_NIL([tDict valueForKey:@"end_longitude"]);
                        feed.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);
                        feed.routeImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                        feed.routeStartAdd=NULL_TO_NIL([tDict valueForKey:@"start_address"]);
                        feed.routeEndAdd=NULL_TO_NIL([tDict valueForKey:@"end_address"]);
                        feed.routeStartTime=NULL_TO_NIL([tDict valueForKey:@"start_time"]);
                        feed.routeEndTime=NULL_TO_NIL([tDict valueForKey:@"end_time"]);
                        feed.routeWeekDay=NULL_TO_NIL([tDict valueForKey:@"day"]);
                        feed.routeShareByUser=NULL_TO_NIL([tDict valueForKey:@"senderName"]);
                        feed.routeType=NULL_TO_NIL([tDict valueForKey:@"type"]);
                        feed.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);

                        feed.recieptMerchantName=NULL_TO_NIL([tDict valueForKey:@"merchant_name"]);
                        feed.recieptAmount=NULL_TO_NIL([tDict valueForKey:@"amount"]);
                        feed.recieptDescription=NULL_TO_NIL([tDict valueForKey:@"description"]);
                        feed.recieptDate=NULL_TO_NIL([tDict valueForKey:@"date"]);
                        feed.recieptImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                        feed.recieptReimbursementStatus=NULL_TO_NIL([tDict valueForKey:@"reimbursment"]);
                        
                        [self.arrFeedList addObject:feed];
                        
                    }
                }
                else
                {
                    [self.arrFeedList removeAllObjects];
                    recordCount = 0;
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found"];
                }
                
                NSLog(@"%lu",(unsigned long)[arrFeedList count]);
                
                tblView.delegate=self;
                tblView.dataSource=self;
                [tblView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    // pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                    
                }
                
                tblView.delegate=self;
                tblView.dataSource=self;
                [tblView reloadData];
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
        [DSBezelActivityView removeView];
    }
}
-(void)AllPostListInvocationDidFinish:(AllPostListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                // pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]>0)
                {
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        Feeds *feed = [[Feeds alloc] init];
                        
                        NSDictionary *fDict = [post objectAtIndex:i];
                        
                        feed.postUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.postUserName = NULL_TO_NIL([fDict valueForKey:@"username"]);
                        feed.postUserImgURL = NULL_TO_NIL([fDict valueForKey:@"user_img"]);
                        feed.postId = NULL_TO_NIL([fDict valueForKey:@"post_id"]);
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]
                                         stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
                        feed.employeeStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"employee"])];
                        feed.managerStatusStr    = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"manager"])];
                        feed.teamLeaderStatusStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"teamleader"])];
                        feed.familyStatusStr     = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"family"])];
                        //  feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        feed.tagTitle         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"tagName"])];
                        
                        feed.arrSimiliarTags = [[NSMutableArray alloc ]  init];
                        
                        NSArray *fTags = NULL_TO_NIL([fDict valueForKey:@"similar_tags"]);
                        
                        for (int j = 0; j <[fTags count]; j++) {
                            
                            NSDictionary *inner = [fTags objectAtIndex:j];
                            
                            Tags *t = [[Tags alloc] init];
                            
                            t.tagId = NULL_TO_NIL([inner valueForKey:@"tag_id"]);
                            t.tagTitle = NULL_TO_NIL([inner valueForKey:@"tag_title"]);
                            
                            [feed.arrSimiliarTags addObject:t];
                        }
                        
                        feed.arrFormValues = [[NSMutableArray alloc ]  init];
                        
                        if ([feed.postType isEqualToString:@"6"]) {
                            
                            NSArray *fFormValues = NULL_TO_NIL([fDict valueForKey:@"formVal"]);
                            
                            for (int j = 0; j <[fFormValues count]; j++) {
                                
                                NSDictionary *inner = [fFormValues objectAtIndex:j];
                                
                                FormValues *t = [[FormValues alloc] init];
                                
                                t.strFormQueStr = NULL_TO_NIL([inner valueForKey:@"label"]);
                                t.strFormAnsStr = NULL_TO_NIL([inner valueForKey:@"value"]);
                                
                                t.strFormTypeStr = NULL_TO_NIL([inner valueForKey:@"label_type"]);
                                t.strFormImageStr = NULL_TO_NIL([inner valueForKey:@"answerimage"]);
                                t.strFormVideoStr = NULL_TO_NIL([inner valueForKey:@"answerurl"]);
                                t.strFormUrlTypeStr = NULL_TO_NIL([inner valueForKey:@"imageUrlType"]);
                                
                                [feed.arrFormValues addObject:t];
                            }
                            
                            
                        }
                        
                        feed.arrCommentValues = [[NSMutableArray alloc ]  init];
                        
                        NSArray *fCommentValues = NULL_TO_NIL([fDict valueForKey:@"comment"]);
                        
                        for (int j = 0; j <[fCommentValues count]; j++) {
                            
                            NSDictionary *inner = [fCommentValues objectAtIndex:j];
                            
                            CommentValues *t = [[CommentValues alloc] init];
                            
                            t.commentId = NULL_TO_NIL([inner valueForKey:@"id"]);
                            t.commentUserId = NULL_TO_NIL([inner valueForKey:@"userId"]);
                            t.commentUserName = NULL_TO_NIL([inner valueForKey:@"username"]);
                            t.commentUserImage = NULL_TO_NIL([inner valueForKey:@"user_img"]);
                            t.commentDate = NULL_TO_NIL([inner valueForKey:@"time"]);
                            
                            NSString *msgStr=NULL_TO_NIL([inner valueForKey:@"comment"]);
                            
                            msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                            
                            t.commentMsg = [[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                            
                            [feed.arrCommentValues addObject:t];
                        }
                        NSDictionary *tDict = NULL_TO_NIL([fDict valueForKey:@"rootPath"]);
                        
                        feed.routeId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                        feed.routeCreated=NULL_TO_NIL([tDict valueForKey:@"created"]);
                        feed.routeStartLatitude=NULL_TO_NIL([tDict valueForKey:@"start_latitude"]);
                        feed.routeStartLongitude=NULL_TO_NIL([tDict valueForKey:@"start_longitude"]);
                        feed.routeEndLatitude=NULL_TO_NIL([tDict valueForKey:@"end_latitude"]);
                        feed.routeEndLongitude=NULL_TO_NIL([tDict valueForKey:@"end_longitude"]);
                        feed.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);
                        feed.routeImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                        feed.routeStartAdd=NULL_TO_NIL([tDict valueForKey:@"start_address"]);
                        feed.routeEndAdd=NULL_TO_NIL([tDict valueForKey:@"end_address"]);
                        feed.routeStartTime=NULL_TO_NIL([tDict valueForKey:@"start_time"]);
                        feed.routeEndTime=NULL_TO_NIL([tDict valueForKey:@"end_time"]);
                        feed.routeWeekDay=NULL_TO_NIL([tDict valueForKey:@"day"]);
                        feed.routeShareByUser=NULL_TO_NIL([tDict valueForKey:@"senderName"]);
                        feed.routeType=NULL_TO_NIL([tDict valueForKey:@"type"]);
                        feed.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);

                        feed.recieptMerchantName=NULL_TO_NIL([tDict valueForKey:@"merchant_name"]);
                        feed.recieptAmount=NULL_TO_NIL([tDict valueForKey:@"amount"]);
                        feed.recieptDescription=NULL_TO_NIL([tDict valueForKey:@"description"]);
                        feed.recieptDate=NULL_TO_NIL([tDict valueForKey:@"date"]);
                        feed.recieptImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                        feed.recieptReimbursementStatus=NULL_TO_NIL([tDict valueForKey:@"reimbursment"]);
                        
                        [self.arrFeedList addObject:feed];
                        
                    }
                }
                else
                {
                    [self.arrFeedList removeAllObjects];
                    recordCount = 0;
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found"];
                }
                
                tblView.delegate=self;
                tblView.dataSource=self;
                [tblView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    // pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                    
                }
                
                tblView.delegate=self;
                tblView.dataSource=self;
                [tblView reloadData];
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
        [DSBezelActivityView removeView];
    }
}
-(void)DeleteEmailListInvocationDidFinish:(DeleteEmailListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    @try {
        if(!error)
        {
            
            NSArray* mail = [dict valueForKey:@"email"];
            
            if ([mail count]>0) {
                
                for (int i=0; i < [mail count]; i++) {
                    
                    NSDictionary *tDict = [mail objectAtIndex:i];
                    
                    InboxData *inbox=[[InboxData alloc] init];
                    
                    inbox.mailId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                    inbox.mailTitle=NULL_TO_NIL([tDict valueForKey:@"email"]);
                    inbox.mailSubject=NULL_TO_NIL([tDict valueForKey:@"subject"]);
                    inbox.mailAttechment=NULL_TO_NIL([tDict valueForKey:@"attachement"]);
                    inbox.mailTo=NULL_TO_NIL([tDict valueForKey:@"to"]);
                    inbox.mailFrom=NULL_TO_NIL([tDict valueForKey:@"from"]);
                    inbox.mailDate=NULL_TO_NIL([tDict valueForKey:@"date"]);
                    
                    NSString *msgStr=NULL_TO_NIL([tDict valueForKey:@"message"]);
                    
                    inbox.mailMessage = [msgStr stringByDecodingURLFormat] ;
                    
                    
                    msgStr= [msgStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSMutableString *tempStr= [NSMutableString stringWithFormat:@"%@",[msgStr stringByDecodingURLFormat]];
                    
                    [tempStr replaceOccurrencesOfString:@"img src" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[tempStr length]}];
                    
                    if (DEVICE_OS_VERSION>=7) {
                        
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[tempStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        
                        inbox.mail_short_desc=attributedString;
                    }
                    else
                    {
                        inbox.mail_short_desc=[[NSAttributedString alloc] initWithString:tempStr attributes:nil];
                    }
                    
                    
                    
                    [self.arrEmailList addObject:inbox];
                    
                }
            }
            tblView.delegate=self;
            tblView.dataSource=self;
            
            [tblView reloadData];
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
        
        [DSBezelActivityView removeView];
    }
    
}
-(void)DeleteEmailInvocationDidFinish:(DeleteEmailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    {
        NSLog(@"deleteContactInvocationDidFinish =%@",dict);
        @try {
            
            if (!error) {
                
                id response = [dict valueForKey:@"email"];
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                    
                    [ConfigManager showAlertMessage:nil Message:@"Mail not deleted"];
                }
                else
                    [self.arrEmailList removeObjectAtIndex:self.selectedIndxpath.row];
                
                
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
            [tblView setContentOffset:CGPointMake(0, 0)];

        }
        
    }
    
}
-(void)DeletePostInvocationDidFinish:(DeletePostInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    {
        NSLog(@"deleteContactInvocationDidFinish =%@",dict);
        @try {
            
            if (!error) {
                
                id response = [dict valueForKey:@"response"];
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                    
                    [ConfigManager showAlertMessage:nil Message:@"Post not deleted"];
                }
                else
                {
                    NSLog(@"%lu",(unsigned long)[self.arrFeedList count]);
                    
                    NSLog(@"%ld",(long)self.selectedIndxpath.row);
                    
                    [self.arrFeedList removeObjectAtIndex:self.selectedIndxpath.row];
                    
                }
                
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
            [tblView setContentOffset:CGPointMake(0, 0)];

        }
        
    }
    
    
}
-(void) buttonDeleteClick:(FormButtonTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    self.selectedIndxpath = indexPath;
    
    NSLog(@"%ld",(long)self.selectedIndxpath.row);
    
    if (segment.selectedSegmentIndex==0) {
        
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Post ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
        [deleteAlert show];
        
        
    }
    else
    {
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Post ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
        [deleteAlert show];
        
        
    }
    
    
}
-(void) buttonEmailDeleteClick:(DeleteEmailTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    self.selectedIndxpath = indexPath;
    
    NSLog(@"%ld",(long)self.selectedIndxpath.row);
    
    if (segment.selectedSegmentIndex==1) {
        
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Mail ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_DELETE_MAIL_CONFIRMATION;
        [deleteAlert show];
        
        
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
#pragma mark- UISearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
    
    [tblView reloadData];
    
    [search resignFirstResponder];
    [self.arrEmailList removeAllObjects];
    
    pageIndex=1;
    
    [self requestForEmail];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    if (searchText.length==0) {
        
        [tblView reloadData];
        [search resignFirstResponder];
        [self.arrEmailList removeAllObjects];
        
        pageIndex=1;
        
        [self requestForEmail];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)search
{
}


-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                NSLog(@"%ld",(long)self.selectedIndxpath.row);
                
                Feeds* feed = [self.arrFeedList objectAtIndex:self.selectedIndxpath.row];
                
                NSMutableDictionary *dic = [NSMutableDictionary new];
                
                [dic setObject:feed.postId forKey:@"post_id"];
                
                if (segment.selectedSegmentIndex==0) {
                    
                    [dic setObject:@"notes" forKey:@"type"];
                    
                }
                else
                {
                    [dic setObject:@"statuses" forKey:@"type"];
                    
                }
                
                [[AmityCareServices sharedService] DeletePostInvocation:dic delegate:self];
                
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
        }
    }
    
    else if(alertView.alertTag == AC_ALERTVIEW_DELETE_MAIL_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
                InboxData* inbox = [self.arrEmailList objectAtIndex:self.selectedIndxpath.row];
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                NSMutableDictionary *dic = [NSMutableDictionary new];
                
                [dic setObject:inbox.mailId forKey:@"id"];
                
                [[AmityCareServices sharedService] DeleteEmailInvocation:dic delegate:self];
                
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
        }
    }
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
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
