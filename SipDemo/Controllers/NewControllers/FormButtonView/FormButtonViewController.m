//
//  FormButtonViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "FormButtonViewController.h"
#import "Form.h"
#import "FormsField.h"
#import "FormListVC.h"
#import "InboxData.h"
#import "Feeds.h"
#import "FormButtonTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ConfigManager.h"
#import "FormValues.h"
#import "NSString+urlDecode.h"
#import "FormButtonEmailTableViewCell.h"
#import "InboxDetailViewController.h"
#import "FormFeedDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "FeedDetailViewController.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface FormButtonViewController ()

@end

@implementation FormButtonViewController

@synthesize arrStatusList,arrFeedList,arrEmailList,selectedIndex,startDate,endDate,permissionInnerView,permissionView,objStatusFeedDetailViewController,objFormFeedDetailViewController,objFeedDetailViewController,popoverController,permissionPopoverContent;

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
    
    self.permissionView.layer.cornerRadius=5;
    self.permissionView.clipsToBounds=YES;
    
    self.permissionInnerView.layer.cornerRadius=5;
    self.permissionInnerView.clipsToBounds=YES;
    
    
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
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    
    pageIndex=1;
    
    self.arrEmailList=[[NSMutableArray alloc] init];
    self.arrFeedList=[[NSMutableArray alloc] init];
    self.arrStatusList=[[NSMutableArray alloc] init];
    searchBar.text=@"";
    
    [searchBar setHidden:TRUE];
    
    [self requestForForm];
    
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    
}
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
-(IBAction)segmentAction:(id)sender
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
        
        [self requestForForm];
    }
    else if (segment.selectedSegmentIndex==1) {
        
        [self requestForStatus];
    }
    else if (segment.selectedSegmentIndex==2) {
        
        [self requestForEmail];
    }
}
#pragma Mark Webservice Request methods------

-(void)requestForForm
{
    [btnSearch setHidden:FALSE];
    [searchBar setHidden:TRUE];

    [txtEndDate setHidden:FALSE];
    [txtStartDate setHidden:FALSE];
    [imgStartDate setHidden:FALSE];
    [imgEndDate setHidden:FALSE];
    
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching form data..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        
        [[AmityCareServices sharedService] ScheduleFormListInvocation:dic delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)requestForStatus
{
    [btnSearch setHidden:FALSE];
    [searchBar setHidden:TRUE];
   
    [txtEndDate setHidden:FALSE];
    [txtStartDate setHidden:FALSE];
    [imgStartDate setHidden:FALSE];
    [imgEndDate setHidden:FALSE];
    
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
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
        [dic setObject:searchBar.text forKey:@"search_name"];
        
        // [dic setObject:txtStartDate.text forKey:@"start_date"];
        // [dic setObject:txtEndDate.text forKey:@"end_date"];
        
        [[AmityCareServices sharedService] ScheduleEmailListInvocation:dic delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(IBAction)btnSearchAction:(id)sender
{
    if (txtStartDate.text.length>0 && txtEndDate.text.length>0) {
        
        tblView.delegate=nil;
        tblView.dataSource=nil;
        
        [tblView reloadData];
        
        tblView.delegate=self;
        tblView.dataSource=self;
        
        pageIndex=1;
        [self.arrFeedList removeAllObjects];
        [self.arrEmailList removeAllObjects];
        
        [tblView reloadData];
        
        if (segment.selectedSegmentIndex==0) {
            
            [self requestForForm];
        }
        else if (segment.selectedSegmentIndex==1) {
            
            [self requestForStatus];
        }
        else if (segment.selectedSegmentIndex==2) {
            
            [self requestForEmail];
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Please select start date or end date"];
    }
    
}
- (IBAction)btnClosePressed:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [self.permissionView removeFromSuperview];
        
    }
}
- (IBAction)employeeBtnPressed:(id)sender
{
    
    InboxData *data=[self.arrEmailList objectAtIndex:selectedIndex];
    
    NSString *statusStr;
    
    if ([data.employeeStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioEmployeeBtn setSelected:YES];
        
    }
    else
    {
        statusStr=@"0";
        [radioEmployeeBtn setSelected:NO];
        
    }
    
    data.employeeStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:data.bsStatusStr forKey:@"BS"];
    [dict setObject:data.managerStatusStr forKey:@"manager"];
    [dict setObject:data.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:data.familyStatusStr forKey:@"family"];
    [dict setObject:statusStr forKey:@"employee"];
    [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dict setObject:data.mailId forKey:@"tag_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] EmailPermissionInvocation:dict delegate:self];
    
}

- (IBAction)teamLeaderBtnPressed:(id)sender
{
    InboxData *data=[self.arrEmailList objectAtIndex:selectedIndex];
    
    NSString *statusStr;
    
    if ([data.teamLeaderStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioTLBtn setSelected:YES];
        
    }
    else
    {
        statusStr=@"0";
        [radioTLBtn setSelected:NO];
        
    }
    data.teamLeaderStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:data.bsStatusStr forKey:@"BS"];
    [dict setObject:data.managerStatusStr forKey:@"manager"];
    [dict setObject:statusStr forKey:@"teamleader"];
    [dict setObject:data.familyStatusStr forKey:@"family"];
    [dict setObject:data.employeeStatusStr forKey:@"employee"];
    [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dict setObject:data.mailId forKey:@"tag_id"];
    
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] EmailPermissionInvocation:dict delegate:self];
}

- (IBAction)familyBtnPressed:(id)sender
{
    InboxData *data=[self.arrEmailList objectAtIndex:selectedIndex];
    
    NSString *statusStr;
    
    
    if ([data.familyStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioFamilyBtn setSelected:YES];
        
    }
    else
    {
        statusStr=@"0";
        [radioFamilyBtn setSelected:NO];
        
    }
    data.familyStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:data.bsStatusStr forKey:@"BS"];
    [dict setObject:data.managerStatusStr forKey:@"manager"];
    [dict setObject:data.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:statusStr forKey:@"family"];
    // [dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:data.employeeStatusStr forKey:@"employee"];
    [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dict setObject:data.mailId forKey:@"tag_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] EmailPermissionInvocation:dict delegate:self];
    
}
- (IBAction)bSBtnPressed:(id)sender
{
    InboxData *data=[self.arrEmailList objectAtIndex:selectedIndex];
    
    NSString *statusStr;
    
    
    if ([data.bsStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioBSBtn setSelected:YES];
        
    }
    else
    {
        statusStr=@"0";
        [radioBSBtn setSelected:NO];
        
    }
    data.bsStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:statusStr forKey:@"BS"];
    [dict setObject:data.managerStatusStr forKey:@"manager"];
    [dict setObject:data.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:data.familyStatusStr forKey:@"family"];
    [dict setObject:data.employeeStatusStr forKey:@"employee"];
    [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dict setObject:data.mailId forKey:@"tag_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] EmailPermissionInvocation:dict delegate:self];
}

-(void)setValues{
    
    InboxData *data=[self.arrEmailList objectAtIndex:selectedIndex];
    
    UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
    
    if([data.employeeStatusStr integerValue] == 1)
    {
        [radioEmployeeBtn setImage:img forState:UIControlStateNormal];
    }
    else
    {
        [radioEmployeeBtn setImage:[UIImage imageNamed:@"popup_unchecked"] forState:UIControlStateNormal];
        
        
    }
    
    if([data.managerStatusStr integerValue] == 1)
    {
        [radioManagerBtn setImage:img forState:UIControlStateNormal];
    }
    else
    {
        [radioManagerBtn setImage:[UIImage imageNamed:@"popup_unchecked"] forState:UIControlStateNormal];
        
        
    }
    if([data.teamLeaderStatusStr integerValue] == 1)
    {
        [radioTLBtn setImage:img forState:UIControlStateNormal];
    }
    else
    {
        [radioTLBtn setImage:[UIImage imageNamed:@"popup_unchecked"] forState:UIControlStateNormal];
        
        
    }
    if([data.familyStatusStr integerValue] == 1)
    {
        [radioFamilyBtn setImage:img forState:UIControlStateNormal];
    }
    else
    {
        [radioFamilyBtn setImage:[UIImage imageNamed:@"popup_unchecked"] forState:UIControlStateNormal];
        
        
    }
    
    if([data.bsStatusStr integerValue] == 1)
    {
        [radioBSBtn setImage:img forState:UIControlStateNormal];
    }
    else
    {
        [radioBSBtn setImage:[UIImage imageNamed:@"popup_unchecked"] forState:UIControlStateNormal];
        
        
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
    
    if (segment.selectedSegmentIndex==2) {
        
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
    if (indexPath.row<[self.arrEmailList count]) {
        
        if (segment.selectedSegmentIndex==2) {
            
            return 55;
            
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
    
    if (segment.selectedSegmentIndex==2) {
        
        if (indexPath.row<[self.arrEmailList count]) {
            
            emailCell = (FormButtonEmailTableViewCell*)[tblView dequeueReusableCellWithIdentifier:emailCellIdentifier];
            
            if (Nil == emailCell)
            {
                emailCell = [FormButtonEmailTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            InboxData *data=[self.arrEmailList objectAtIndex:indexPath.row];
            
            emailCell.lblSubject.text=data.mailTitle;
            emailCell.lblTitle.text=data.mailTo;
            
            
            return emailCell;
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
            
            [feedCell.btnDelete setHidden:TRUE];
            
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
    if (segment.selectedSegmentIndex==2) {
        
        
        selectedIndex=indexPath.row;
        
        UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
        
        if (IS_DEVICE_IPAD) {
            
            
            if (self.permissionPopoverContent == nil )
            {
                self.permissionPopoverContent = [[UIViewController alloc]init];
                
                [self.permissionView setFrame:CGRectMake(0,0, 418, 200)];
                
                self.permissionPopoverContent.view=permissionView;
                
                self.permissionPopoverContent.preferredContentSize = CGSizeMake(418, 200);
                
            }
            
            [self setValues];
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.permissionPopoverContent];
            
            self.popoverController.popoverContentSize= CGSizeMake(418, 200);
            
            [self.popoverController  presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            
            [self.permissionView removeFromSuperview];
            
            [self.permissionView setFrame:CGRectMake(0,100, permissionView.frame.size.width, permissionView.frame.size.height)];
            
            self.permissionView.layer.cornerRadius=5;
            self.permissionView.clipsToBounds=YES;
            
            self.permissionInnerView.layer.cornerRadius=5;
            self.permissionInnerView.clipsToBounds=YES;
            
            [self setValues];
            
            [self.view addSubview:self.permissionView];
        }
        
        
        
        /*InboxDetailViewController *objInboxDetailViewController=[[InboxDetailViewController alloc] init];
         
         objInboxDetailViewController.arrMailData=[[NSMutableArray alloc] initWithArray:self.arrEmailList];
         objInboxDetailViewController.selectedIndex=indexPath.row;
         
         popoverController = [[UIPopoverController alloc] initWithContentViewController:objInboxDetailViewController];
         
         popoverController.popoverContentSize= CGSizeMake(450, 700);
         
         [popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
    }
    else
    {
        UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
        
        if (segment.selectedSegmentIndex==0) {
            
            Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
            
            if (IS_DEVICE_IPAD) {
                
                self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController" bundle:nil];
                
                self.objFormFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objFormFeedDetailViewController.feedDetails=feed;
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objFormFeedDetailViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                
                [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController_iphone" bundle:nil];
                self.objFormFeedDetailViewController.feedDetails=feed;
                self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
                
                [sharedAppDelegate.window addSubview:self.objFormFeedDetailViewController.view];
            }
            
        }
        
        else if(segment.selectedSegmentIndex==1)
        {
            Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
            
            if (IS_DEVICE_IPAD) {
                
                
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
        
    }
}

#pragma mark - get Feed List invocation Delegates
-(void)ScheduleFormListInvocationDidFinish:(ScheduleFormListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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
                
                NSArray* post = [response valueForKey:@"form"];
                
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
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
                        feed.employeeStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"employee"])];
                        feed.managerStatusStr    = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"manager"])];
                        feed.teamLeaderStatusStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"teamleader"])];
                        feed.familyStatusStr     = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"family"])];
                        // feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
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
                    pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) intValue];
                    
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

-(void)ScheduleEmailListInvocationDidFinish:(ScheduleEmailListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    @try {
        if(!error)
        {
            
            NSDictionary *dic=[dict valueForKey:@"response"];
            NSArray* mail = [dic valueForKey:@"tag"];
            recordCount = [NULL_TO_NIL([dic valueForKey:@"total_records"]) intValue];
            
            if ([mail count]>0) {
                
                for (int i=0; i < [mail count]; i++) {
                    
                    NSDictionary *tDict = [mail objectAtIndex:i];
                    
                    InboxData *inbox=[[InboxData alloc] init];
                    
                    inbox.mailId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                    inbox.mailTitle=NULL_TO_NIL([tDict valueForKey:@"email"]);
                    inbox.mailTo=NULL_TO_NIL([tDict valueForKey:@"title"]);
                    inbox.employeeStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"employee"])];
                    inbox.managerStatusStr    = [NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"manager"])];
                    inbox.teamLeaderStatusStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"teamleader"])];
                    inbox.familyStatusStr     = [NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"family"])];
                    inbox.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"BS"])];
                    
                    
                    
                    /* inbox.mailSubject=NULL_TO_NIL([tDict valueForKey:@"subject"]);
                     inbox.mailAttechment=NULL_TO_NIL([tDict valueForKey:@"attachement"]);
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
                     */
                    
                    
                    [self.arrEmailList addObject:inbox];
                    
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
        
        tblView.delegate=self;
        tblView.dataSource=self;
        
        [tblView reloadData];
        
        [DSBezelActivityView removeView];
    }
    
}
-(void)EmailPermissionInvocationDidFinish:(EmailPermissionInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [self.popoverController dismissPopoverAnimated:YES];
    
    [self.permissionView removeFromSuperview];
    
    [DSBezelActivityView removeView];
    
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    if (segment.selectedSegmentIndex==0) {
        
        [self requestForForm];
        
    }
    else if (segment.selectedSegmentIndex==1) {
        
        [self requestForStatus];
        
    }
    else
    {
        [self requestForEmail];
    }
}
#pragma mark- UITextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:txtStartDate]){
        
        if (IS_DEVICE_IPAD) {
            
            UIViewController* popoverContent = [[UIViewController alloc] init];
            
            UIView *popoverView = [[UIView alloc] init];
            popoverView.backgroundColor = [UIColor clearColor];
            
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
            [popoverView addSubview:toolbar];
            [popoverView addSubview:datePicker];
            
            popoverContent.view = popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
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
            
            UIViewController* popoverContent = [[UIViewController alloc] init];
            
            UIView *popoverView = [[UIView alloc] init];
            popoverView.backgroundColor = [UIColor clearColor];
            
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
            [popoverView addSubview:toolbar];
            [popoverView addSubview:datePicker];
            
            popoverContent.view = popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
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
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
    
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
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
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
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
