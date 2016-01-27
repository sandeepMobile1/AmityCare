//
//  IphoneTagHomeViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 06/01/15.
//
//

#import "IphoneTagHomeViewController.h"
#import "Feeds.h"
#import "FeedListTableViewCell.h"
#import "ConfigManager.h"
#import "UIImageExtras.h"
#import "UserFeedCell.h"
#import "UIImageExtras.h"
#import "ClockOutVC.h"
#import "UserLocationVC.h"
#import "ActionSheetPicker.h"
#import "PasswordView.h"
#import "SortFeedsVC.h"
#import "HMSideMenu.h"
#import "Form.h"
#import "FormsField.h"
#import "FormListVC.h"
#import "UIImageView+WebCache.h"
#import "FormValues.h"
#import "PasswordViewIphone.h"
#import "EditTagIntroViewController.h"
#import "InboxData.h"
#import "NSString+urlDecode.h"
#import "TagCell.h"
#import "ClockInView.h"
#import "IphoneTagHomeViewController.h"
#import "NotificationCell.h"
#import "NotificationD.h"
#import "ContactD.h"
#import "SqliteManager.h"
#import <QuartzCore/QuartzCore.h>
#import "OptionsPopOverVC.h"
#import "AddContactsVC.h"
#import "InboxDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "FeedDetailViewController.h"
#import "FormFeedDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "IphoneUserViewController.h"
#import "Keywords.h"
#import "MFSideMenu.h"
#import "ChatDetailVC.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "RouteFeedDetailViewController.h"
#import "RecieptFeedDetailViewController.h"

@interface IphoneTagHomeViewController ()

@end

@implementation IphoneTagHomeViewController

@synthesize arrFeedList,tagImgView,tagTitleLbl,descriptionTxtView,arrTagsList,arrInboxListing,arrStatusList,arrNotificationList,selectedIndxpath,tagLblDate,tenHashTagArr,lblTitle,arrTaggedKeywords,contactEmailArr,popoverController,popover,hashTagPopoverView,objInboxDetailViewController,objEditTagIntroViewController,objFeedDetailViewController,objFormFeedDetailViewController,objStatusFeedDetailViewController,tblViewTagList,tagPopoverView,shareContactView,selectedIndex,objRouteFeedDetailViewController,objRecieptFeedDetailViewController;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (sharedAppDelegate.userObj.clockInTagId==nil || sharedAppDelegate.userObj.clockInTagId==(NSString*)[NSNull null] || [sharedAppDelegate.userObj.clockInTagId isEqualToString:@""]) {
        
    }
    else
    {
        sharedAppDelegate.strSelectedTagId=sharedAppDelegate.userObj.clockInTagId;
        sharedAppDelegate.strSelectedTag=sharedAppDelegate.userObj.clockInTagTitle;
        
        Tags *objTag=[[Tags alloc] init];
        
        objTag.tagId=sharedAppDelegate.userObj.clockInTagId;
        objTag.tagTitle=sharedAppDelegate.userObj.clockInTagTitle;
        
        sharedAppDelegate.selectedTag=objTag;
        
    }
    
    
    [btnSpecialChatCount setHidden:TRUE];
    [btnGroupChatCount setHidden:TRUE];
    [btnTagNotificationCount setHidden:TRUE];
    
    sharedAppDelegate.unreadGroupChatCount=0;
    sharedAppDelegate.unreadSpecialGroupChatCount=0;
    sharedAppDelegate.unreadNotifications=0;
    
    if (!IS_DEVICE_IPAD) {
        
        [self.menuContainerViewController setPanMode:MFSideMenuPanModeSideMenu];
        
        
        self.menuContainerViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
        
    }
    
    checkClockOutTimer=@"";
    
    checkHashSearch=FALSE;
    [btnClearAll setHidden:TRUE];
    
    [txtSearch setValue:[UIColor colorWithRed:0.8588235 green:0.8588235 blue:0.8588235 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [txtStartDate setValue:[UIColor colorWithRed:0.8588235 green:0.8588235 blue:0.8588235 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [txtEndDate setValue:[UIColor colorWithRed:0.8588235 green:0.8588235 blue:0.8588235 alpha:1.0]  forKeyPath:@"_placeholderLabel.textColor"];
    
    [leftMainSegment setTitle:[[NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname] capitalizedString] forSegmentAtIndex:0];
    
    
    tagImgView.layer.cornerRadius = floor(tagImgView.frame.size.width/2);
    tagImgView.clipsToBounds = YES;
    
    [tagImgView setHidden:TRUE];
    [tagLblDate setHidden:TRUE];
    [descriptionTxtView setHidden:TRUE];
    [tagTitleLbl setHidden:TRUE];
    [btnEditIntro setHidden:TRUE];
    [btnTopHashTag setHidden:TRUE];
    [imgDate setHidden:TRUE];
    [btnShare setHidden:TRUE];
    [btnMesssage setHidden:TRUE];
    [btnSpecialMesssage setHidden:TRUE];
    
    
   // NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], UITextAttributeFont,[UIColor colorWithRed:0.27843137 green:0.69411764 blue:0.92156862 alpha:1.0], UITextAttributeTextColor,nil];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,[UIColor colorWithRed:0.27843137 green:0.69411764 blue:0.92156862 alpha:1.0], NSForegroundColorAttributeName, nil];

    
    [leftMainSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [leftSecondSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    //NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], UITextAttributeFont,[UIColor whiteColor], UITextAttributeTextColor,nil];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];

    
    [leftMainSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    [leftSecondSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
#pragma mark User Feeds --------
    
    self.arrFeedList=[[NSMutableArray alloc] init];
    self.arrTagsList=[[NSMutableArray alloc] init];
    self.arrInboxListing=[[NSMutableArray alloc] init];
    self.normalSearchDic = [NSMutableDictionary new];
    self.arrNotificationList= [[NSMutableArray alloc] init];
    self.arrStatusList= [[NSMutableArray alloc] init];
    self.tenHashTagArr= [[NSMutableArray alloc] init];
    self.arrTaggedKeywords=[[NSMutableArray alloc] init];
    self.contactEmailArr=[[NSMutableArray alloc] init];
    
    recordCount = 0;
    pageIndex = 1;
    userInRadiusRange = TRUE;
    isNormalSearch = NO;
    isTopHashTag = NO;
    isTwentyHoursUpdate = YES;
    
    self.strHashTag=@"";
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    txtSearch.text=@"";
    
    if(sharedAppDelegate.userObj.isEmployee)
        descriptionTxtView.userInteractionEnabled = NO;
    else
        descriptionTxtView.userInteractionEnabled = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isKeywordSearched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.selectedTag=sharedAppDelegate.selectedTag;
    
    //sharedAppDelegate.strSelectedTagId = self.selectedTag.tagId;
    //sharedAppDelegate.strSelectedTag = self.selectedTag.tagTitle;
    
    if([ConfigManager isInternetAvailable])
    {
        if (sharedAppDelegate.strSelectedTagId==nil || sharedAppDelegate.strSelectedTagId==(NSString*)[NSNull null] || [sharedAppDelegate.strSelectedTagId isEqualToString:@""]) {
            
            [self reqeustForTagList];
            
        }
        else
        {
            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
        }
        
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    sharedAppDelegate.strCheckUserAndTag=@"Tag";
    
    
    [backTagView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_list_bg.png"]]];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        [lblClockIn setHidden:TRUE];
        [lblClockOut setHidden:TRUE];
        [clockInSwitch setHidden:TRUE];
        [imgSwitch setHidden:TRUE];
        [btnShare setHidden:TRUE];
        
        [backTagView setFrame:CGRectMake(backTagView.frame.origin.x, 222-40, backTagView.frame.size.width, 50)];
        
        [btnMesssage setFrame:CGRectMake(btnMesssage.frame.origin.x, btnMesssage.frame.origin.y-30, btnMesssage.frame.size.width, btnMesssage.frame.size.height)];
        
        
        [btnGroupChatCount setFrame:CGRectMake(btnGroupChatCount.frame.origin.x, btnGroupChatCount.frame.origin.y-30, btnGroupChatCount.frame.size.width, btnGroupChatCount.frame.size.height)];
        
        
        [tblLeftFeedView setFrame:CGRectMake(tblLeftFeedView.frame.origin.x, 346-110, tblLeftFeedView.frame.size.width, tblLeftFeedView.frame.size.height+110)];
        
    }
    else
    {
        [lblClockIn setHidden:FALSE];
        [lblClockOut setHidden:FALSE];
        [clockInSwitch setHidden:FALSE];
        [imgSwitch setHidden:FALSE];
        [btnShare setHidden:FALSE];
        
        [backTagView setFrame:CGRectMake(backTagView.frame.origin.x, 222, backTagView.frame.size.width, backTagView.frame.size.height)];
        
        [btnMesssage setFrame:CGRectMake(btnMesssage.frame.origin.x, btnMesssage.frame.origin.y, btnMesssage.frame.size.width, btnMesssage.frame.size.height)];
        
        [btnGroupChatCount setFrame:CGRectMake(btnGroupChatCount.frame.origin.x, btnGroupChatCount.frame.origin.y, btnGroupChatCount.frame.size.width, btnGroupChatCount.frame.size.height)];
        
        [tblLeftFeedView setFrame:CGRectMake(tblLeftFeedView.frame.origin.x, 346, tblLeftFeedView.frame.size.width, tblLeftFeedView.frame.size.height)];
        
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForNotificationList) name:AC_UPDATE_NOTIFICATION_TABLE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTagNotification:) name:AC_USER_UNREAD_NOTIFICATION_UPDATE object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeValue:) name: AC_USER_UNREAD_BADGE_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusList) name: AC_STATUS_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePostList) name: AC_POST_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clockoutFromNotification) name:AC_UPDATE_NOTIFICATION_CLOCKOUT object:nil];

}
-(void)clockoutFromNotification
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        pageIndex=1;
        
        [self.arrFeedList removeAllObjects];
        
        [tblLeftFeedView reloadData];
        
        [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
        
        leftSecondSegment.selectedSegmentIndex=0;
        
        
    }
}
-(void)updateStatusList
{
    isClockInFeedAdded = FALSE;
    [self.arrFeedList removeAllObjects];
    
    [btnClearAll setHidden:TRUE];
    
    pageIndex=1;
    
    leftSecondSegment.selectedSegmentIndex=2;
    
    [self requestForTagStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
    
}
-(void)updatePostList
{
    if ([checkPN isEqualToString:@"YES"]) {

    isClockInFeedAdded = FALSE;
    [self.arrFeedList removeAllObjects];
    
    [btnClearAll setHidden:TRUE];
    
    pageIndex=1;
    
    leftSecondSegment.selectedSegmentIndex=0;
    
    [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    checkPN=@"YES";
    
    clockInPress=TRUE;

    if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
        
        descriptionTxtView.text=sharedAppDelegate.strUpdatedTagIntro;
        
    }
    else
    {
        descriptionTxtView.text = @"";
        
    }
    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    [tblLeftFeedView setBackgroundColor:[UIColor clearColor]];
    
    if ([checkClockOutTimer isEqualToString:@"clockout"]) {
        
        if([ConfigManager isInternetAvailable])
        {
            checkClockOutTimer=@"";
            
            pageIndex=1;
            
            leftSecondSegment.selectedSegmentIndex=0;
            
            [self.arrFeedList removeAllObjects];
            
            [tagImgView setHidden:TRUE];
            [tagLblDate setHidden:TRUE];
            [descriptionTxtView setHidden:TRUE];
            [tagTitleLbl setHidden:TRUE];
            [btnEditIntro setHidden:TRUE];
            [btnTopHashTag setHidden:TRUE];
            [imgDate setHidden:TRUE];
            
            tblLeftFeedView.delegate=nil;
            tblLeftFeedView.dataSource=nil;
            
            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
    
    
}
-(void)updateTagNotification:(NSNotification*) note
{
    NSLog(@"updateTagNotification");

    
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        if (nTagId==nil || nTagId==(NSString*)[NSNull null] || [nTagId isEqualToString:@""]) {
            
        }
        else
        {
            if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                
                if (leftSecondSegment.selectedSegmentIndex==2) {
                    
                    [self.arrNotificationList removeAllObjects];
                    [self requestForNotificationList];
                    
                }
                
            }
            
        }
    }
}
-(void)updateFeedFromNotification:(NSNotification*) note
{
    NSLog(@"updateFeedFromNotification");
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        NSLog(@"nTagId %@",nTagId);
        NSLog(@"sharedAppDelegate.strSelectedTagId %@",sharedAppDelegate.strSelectedTagId);
        
        if (nTagId==nil || nTagId==(NSString*)[NSNull null] || [nTagId isEqualToString:@""]) {
            
        }
        else
        {
            if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                
                if (leftSecondSegment.selectedSegmentIndex==0) {
                    
                    pageIndex=1;
                    
                    [self.arrFeedList removeAllObjects];
                    
                    [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
                    
                }
                
            }
            
        }
    }
}
-(void)updateStatusFromNotification:(NSNotification*) note
{
    NSLog(@"updateStatusFromNotification");
    
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        NSLog(@"nTagId %@",nTagId);
        NSLog(@"sharedAppDelegate.strSelectedTagId %@",sharedAppDelegate.strSelectedTagId);
        
        if (nTagId==nil || nTagId==(NSString*)[NSNull null] || [nTagId isEqualToString:@""]) {
            
        }
        else
        {
            if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                
                if(leftSecondSegment.selectedSegmentIndex==0)
                {
                    pageIndex=1;
                    
                    [self.arrFeedList removeAllObjects];
                    
                    [self requestForTagStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
                    
                }
                
            }
            
        }
    }
}
-(void)setBadgeValue:(NSNotification*) note
{
    NSLog(@"setBadgeValue");
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        if (nTagId==nil || nTagId==(NSString*)[NSNull null] || [nTagId isEqualToString:@""]) {
            
        }
        else
        {
            if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                
                if (sharedAppDelegate.unreadTagCount>0) {
                    
                    [btnTagNotificationCount setHidden:FALSE];
                    [btnTagNotificationCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadTagCount] forState:UIControlStateNormal];
                }
                else
                {
                    [btnTagNotificationCount setHidden:TRUE];
                    
                }
                
                NSString* nType = [notification valueForKeyPath:@"aps.type"];
                
                if ([nType isEqualToString:@"specialchat"]) {
                    
                    if (sharedAppDelegate.unreadSpecialGroupChatCount>0) {
                        
                        if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                            
                            [btnSpecialChatCount setHidden:FALSE];
                            
                            [btnSpecialChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadSpecialGroupChatCount] forState:UIControlStateNormal];
                            
                        }
                        else
                        {
                            [btnSpecialChatCount setHidden:TRUE];
                        }
                        
                    }
                    else
                    {
                        [btnSpecialChatCount setHidden:TRUE];
                        
                    }
                    
                }
                
                else if ([nType isEqualToString:@"groupchat"]) {
                    
                    if (sharedAppDelegate.unreadGroupChatCount>0) {
                        
                        [btnGroupChatCount setHidden:FALSE];
                        [btnGroupChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btnGroupChatCount setHidden:TRUE];
                        
                    }
                    
                }
                
                
            }
            
        }
        
    }
    
    
}
-(IBAction)menuButtonAction:(id)sender
{
    if (sharedAppDelegate.strSelectedTagId==nil || sharedAppDelegate.strSelectedTagId==(NSString*)[NSNull null] || [sharedAppDelegate.strSelectedTagId isEqualToString:@""]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        
        sharedAppDelegate.checkSlideMenuAction=@"Menu";
        sharedAppDelegate.strCheckUserAndTag=@"Tag";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_RIGHT_MENU_NOTIFICATION_UPDATE object:nil];
        
        // sharedAppDelegate.strSelectedTagId = self.selectedTag.tagId;
        // sharedAppDelegate.strSelectedTag = self.selectedTag.tagTitle;
        
        [self.menuContainerViewController toggleRightSideMenuCompletion:^{
            
        }];
        
    }
}
#pragma mark Get webservice Mehtods--------

-(void)requestGetTagFeeds:(NSNumber*)index
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
        
        NSString* strIndex = [NSString stringWithFormat:@"%d",[index intValue]];
        
        NSLog(@"user Id %@",sharedAppDelegate.userObj.role_id);
        NSLog(@"User update notification received");
        
        [[AmityCareServices sharedService] getTagFeedsInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"one" delegate:self];
        
        
        //  if (isTwentyHoursUpdate)
        /* if (sharedAppDelegate.checkClockIn==FALSE)
         {
         [clockInSwitch setOn:FALSE];
         
         [[AmityCareServices sharedService] getTagFeedsInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"one" delegate:self];
         
         }
         else
         {
         [clockInSwitch setOn:TRUE];
         
         [[AmityCareServices sharedService] getTagFeedsInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"all" delegate:self];
         }*/
        
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    
}
-(void)requestForTagSearchFeeds:(NSMutableDictionary*)dict
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Searching feeds..." width:200];
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            [[AmityCareServices sharedService] getKeywordsFeedsInvocation:dict delegate:self];
            
        }
        else
        {
            [[AmityCareServices sharedService] GetKeywordStatusInvocation:dict delegate:self];
            
        }
    }
    
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(void)reqeustForTagList
{
    [self.arrTagsList removeAllObjects];
    
    if([ConfigManager isInternetAvailable]){
        
        [self fetchAssignedTags];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(void)fetchAssignedTags
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
        [[AmityCareServices sharedService] tagInvocation:sharedAppDelegate.userObj.userId delegate:self];
        
    }
    
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        
    }
}

-(void)requestForTagEmailList
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching inbox list Please wait..." width:220];
        
        [[AmityCareServices sharedService] InboxListInvocation:sharedAppDelegate.userObj.userId tagId:self.selectedTag.tagId delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(void)requestForTagStatusList:(NSNumber*)index
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
        
        NSString* strIndex = [NSString stringWithFormat:@"%d",[index intValue]];
        
        NSLog(@"user Id %@",sharedAppDelegate.userObj.role_id);
        NSLog(@"User update notification received");
        
        if (isTwentyHoursUpdate)
        {
            [[AmityCareServices sharedService] TagStatusListInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"one" delegate:self];
            
            
        }
        else
        {
            
            [[AmityCareServices sharedService] TagStatusListInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"all" delegate:self];
        }
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(void)requestForNotificationList
{
    
    if (leftSecondSegment.selectedSegmentIndex==2) {
        
        sharedAppDelegate.unreadNotifications = 0;
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView removeView];

            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
            
            pageIndex=1;
            [self.arrNotificationList removeAllObjects];

            NSString *pageIndexStr=[NSString stringWithFormat:@"%lu",pageIndex];
            
            [[AmityCareServices sharedService] TagNotificationListInvocation:sharedAppDelegate.userObj.userId tagId:self.selectedTag.tagId page_index:pageIndexStr delegate:self];
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
    
}

#pragma mark Show Tag List on Popoverview--------

- (void)showTagView
{
    
    [self.tagPopoverView setFrame:CGRectMake(0,90, self.tagPopoverView.frame.size.width, self.tagPopoverView.frame.size.height)];
    self.tagPopoverView.layer.cornerRadius=5;
    self.tagPopoverView.clipsToBounds=YES;
    
    self.tblViewTagList.layer.cornerRadius=5;
    self.tblViewTagList.clipsToBounds=YES;
    
    [self.view addSubview:self.tagPopoverView];
    
}


#pragma mark IBAction Mehtods--------

-(IBAction)btnFirstSearchPressed:(id)sender
{
    if (btnFirstSearch.tag==0) {
        
        txtSearch.text=@"";
        txtSearch.placeholder=@"# Search";
        [btnFirstSearch setTag:1];
        
    }
    else
    {
        txtSearch.text=@"";
        txtSearch.placeholder=@"Search";
        [btnFirstSearch setTag:0];
    }
    
}
-(IBAction)btnSecondSearchPressed:(id)sender
{
    if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        txtStartDate.text= [txtStartDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        txtEndDate.text= [txtEndDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        txtSearch.text= [txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (txtStartDate.text.length==0 || txtEndDate.text.length==0) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please enter start and end date"];
            return;
        }
        else
        {
            isNormalSearch = NO;
            isTopHashTag = YES;
            [self.arrFeedList removeAllObjects];
            pageIndex=1;
            [self.normalSearchDic removeAllObjects];
            
            tblLeftFeedView.delegate=nil;
            tblLeftFeedView.dataSource=nil;
            
            NSString* startDate = txtStartDate.text;
            NSString* endDate   = txtEndDate.text;
            
            if (txtSearch.text.length>0) {
                
                self.strHashTag=txtSearch.text;
            }
            
            [self.normalSearchDic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [self.normalSearchDic setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
            [self.normalSearchDic setObject:startDate forKey:@"start_date"];
            [self.normalSearchDic setObject:endDate forKey:@"end_date"];
            [self.normalSearchDic setObject:self.strHashTag forKey:@"has_tag"];
            [self.normalSearchDic setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];
            [self.normalSearchDic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
            
            [self.normalSearchDic setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
            [self.normalSearchDic setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            
            if([ConfigManager isInternetAvailable]){
                
                [DSBezelActivityView removeView];

                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
                
                if (leftSecondSegment.selectedSegmentIndex==0) {
                    
                    [[AmityCareServices sharedService] sortFeedsByDate:self.normalSearchDic delegate:self];
                    
                }
                else
                {
                    [[AmityCareServices sharedService] SortTagStatusDateWiseInvocation:self.normalSearchDic delegate:self];
                    
                }
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
            
            /* if (btnFirstSearch.tag==1) {
             
             if (txtSearch.text.length>0) {
             
             isNormalSearch = YES;
             isTopHashTag = NO;
             [self.arrFeedList removeAllObjects];
             pageIndex=1;
             [self.normalSearchDic removeAllObjects];
             
             tblLeftFeedView.delegate=nil;
             tblLeftFeedView.dataSource=nil;
             
             NSString* startDate = txtStartDate.text;
             NSString* endDate   = txtEndDate.text;
             NSString* hashTag   = txtSearch.text;
             
             [self.normalSearchDic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
             [self.normalSearchDic setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
             [self.normalSearchDic setObject:startDate forKey:@"start_date"];
             [self.normalSearchDic setObject:endDate forKey:@"end_date"];
             [self.normalSearchDic setObject:hashTag forKey:@"has_tag"];
             
             // [self.normalSearchDic setObject:@"all" forKey:@"time"];
             [self.normalSearchDic setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];//Dharmbir140903
             [self.normalSearchDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
             
             if([ConfigManager isInternetAvailable]){
             
             [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
             
             if (leftSecondSegment.selectedSegmentIndex==0) {
             
             [[AmityCareServices sharedService] sortFeedsByDate:self.normalSearchDic delegate:self];
             
             }
             else
             {
             [[AmityCareServices sharedService] SortTagStatusDateWiseInvocation:self.normalSearchDic delegate:self];
             
             }
             }
             else{
             
             [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
             }
             
             }
             else
             {
             [ConfigManager showAlertMessage:nil Message:@"Please enter hash tag"];
             return;
             }
             }
             else
             {
             isNormalSearch = YES;
             isTopHashTag = NO;
             
             NSString* startDate = txtStartDate.text;
             NSString* endDate = txtEndDate.text;
             
             [popover dismissPopoverAnimated:YES];
             
             [self.arrFeedList removeAllObjects];
             
             [self.normalSearchDic removeAllObjects];
             
             pageIndex = 1;
             
             [self.normalSearchDic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
             [self.normalSearchDic setObject:self.selectedTag.tagId forKey:@"tag_id"];
             [self.normalSearchDic setObject:startDate forKey:@"start_date"];
             [self.normalSearchDic setObject:endDate forKey:@"end_date"];
             // [self.normalSearchDic setObject:@"all" forKey:@"time"];
             [self.normalSearchDic setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];//Dharmbir140903
             [self.normalSearchDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
             
             if([ConfigManager isInternetAvailable]){
             
             [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
             
             if (leftSecondSegment.selectedSegmentIndex==0) {
             
             [[AmityCareServices sharedService] sortFeedsByDate:self.normalSearchDic delegate:self];
             
             }
             else
             {
             [[AmityCareServices sharedService] SortTagStatusDateWiseInvocation:self.normalSearchDic delegate:self];
             
             }
             
             }
             else{
             
             [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
             }
             
             }*/
            
        }
        
        
    }
    
}
-(IBAction)leftMainSegmentAction:(id)sender
{
    if (leftMainSegment.selectedSegmentIndex==0) {
        
        leftMainSegment.selectedSegmentIndex=0;
        IphoneUserViewController *objIphoneUserViewController=[[IphoneUserViewController alloc] initWithNibName:@"IphoneUserViewController" bundle:nil];
        objIphoneUserViewController.phoneCallDelegate=sharedAppDelegate.objIphoneUserViewController.phoneCallDelegate;
        
        [self.navigationController pushViewController:objIphoneUserViewController animated:NO];
    }
    else
    {
        if([ConfigManager isInternetAvailable])
        {
            [self reqeustForTagList];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }
    
    
    
}
-(IBAction)btnTagsAction:(id)sender
{
    leftMainSegment.selectedSegmentIndex=1;
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"]) {
        
        pageIndex=1;
        
        leftSecondSegment.selectedSegmentIndex=0;
        
        [self.arrFeedList removeAllObjects];
        
        tblLeftFeedView.delegate=nil;
        tblLeftFeedView.dataSource=nil;
        
        if (sharedAppDelegate.strSelectedTagId==nil || sharedAppDelegate.strSelectedTagId==(NSString*)[NSNull null] || [sharedAppDelegate.strSelectedTagId isEqualToString:@""]) {
            
            
        }
        else
        {
        [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
        
        }
        
        
    }
    else
    {
        if([ConfigManager isInternetAvailable])
        {
            [self reqeustForTagList];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
    
}
-(IBAction)btnClearAllAction:(id)sender
{
    if ([self.arrNotificationList count] == 0)
    {
        [ConfigManager showAlertMessage:nil Message:@"Notification not found"];
    }
    else
    {
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete All Notification ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_ALL_DELETE_NOTIFICATION_CONFIRMATION;
        [deleteAlert show];
    }
    
    
}

-(IBAction)leftSecondSegmentAction:(id)sender
{
    checkHashSearch=FALSE;
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    txtSearch.text=@"";
    [self.normalSearchDic removeAllObjects];
    
    
    if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null] || [self.selectedTag.tagId isEqualToString:@""]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        tblLeftFeedView.delegate=nil;
        tblLeftFeedView.dataSource=nil;
        [tblLeftFeedView reloadData];
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            [btnClearAll setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [btnShare setHidden:TRUE];
                [btnTopHashTag setHidden:TRUE];
                
            }
            else
            {
                [btnShare setHidden:FALSE];
                [btnTopHashTag setHidden:FALSE];
                
            }
            
            [btnMesssage setHidden:FALSE];
            if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                [btnSpecialMesssage setHidden:FALSE];
                
            }
            else
            {
                [btnSpecialMesssage setHidden:TRUE];
            }
            [txtEndDate setEnabled:TRUE];
            [txtStartDate setEnabled:TRUE];
            [txtSearch setEnabled:TRUE];
            [btnSearch setEnabled:TRUE];
            [btnSecondSearch setEnabled:TRUE];
            
            pageIndex=1;
            [self.arrFeedList removeAllObjects];
            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
        }
        else if(leftSecondSegment.selectedSegmentIndex==1)
        {
            [btnTopHashTag setHidden:TRUE];
            [btnClearAll setHidden:TRUE];
            [btnShare setHidden:TRUE];
            [btnMesssage setHidden:FALSE];
            if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                [btnSpecialMesssage setHidden:FALSE];
                
            }
            else
            {
                [btnSpecialMesssage setHidden:TRUE];
            }
            [txtEndDate setEnabled:FALSE];
            [txtStartDate setEnabled:FALSE];
            [txtSearch setEnabled:FALSE];
            [btnSearch setEnabled:FALSE];
            [btnSecondSearch setEnabled:FALSE];
            
            [self requestForTagEmailList];
        }
        else if(leftSecondSegment.selectedSegmentIndex==2)
        {
            [btnTopHashTag setHidden:TRUE];
            [btnClearAll setHidden:FALSE];
            [btnShare setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [btnClearAll setFrame:CGRectMake(btnClearAll.frame.origin.x, btnClearAll.frame.origin.y+15, btnClearAll.frame.size.width, btnClearAll.frame.size.height)];
                
                [btnMesssage setFrame:CGRectMake(btnMesssage.frame.origin.x, btnMesssage.frame.origin.y-5, btnMesssage.frame.size.width, btnMesssage.frame.size.height)];
                
            }
            
            [txtEndDate setEnabled:FALSE];
            [txtStartDate setEnabled:FALSE];
            [txtSearch setEnabled:FALSE];
            [btnSearch setEnabled:FALSE];
            [btnSecondSearch setEnabled:FALSE];
            
            [btnTagNotificationCount setHidden:TRUE];
            sharedAppDelegate.unreadTagCount=0;
            
            [self.arrNotificationList removeAllObjects];
            [self requestForNotificationList];
        }
      
        
    }
    
}

-(IBAction)clockInSwitchAction:(id)sender
{
    if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null] || [self.selectedTag.tagId isEqualToString:@""]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        isNormalSearch = NO;
        isTopHashTag = NO;
        
        isTwentyHoursUpdate = NO;
        
        UISwitch *switchSlider = (UISwitch *)sender;
        
        if([ConfigManager isInternetAvailable])
        {
            if (switchSlider.isOn)
            {
                [clockInSwitch setOn:YES];
                
                
                if (clockInPress==TRUE) {
                    
                    clockInPress=FALSE;
                
                    [DSBezelActivityView removeView];

                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Verifying ClockIn Please wait..." width:220];
                
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                
                [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                [dict setObject:self.selectedTag.tagId forKey:@"tagId"];
                [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
                [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
                
                [[AmityCareServices sharedService] clockInUserInvocation:dict delegate:self];
                    
                }
            }
            else
            {
                recordCount = 0;
                
                [clockInView stopTimer1];
                
                moveToKeywordSearch = FALSE;
                [sharedAppDelegate startUpdatingLocation];
                ClockOutVC *clockOutVc = [[ClockOutVC alloc] initWithNibName:@"ClockOutVC_iphone" bundle:nil];
                
                [clockInSwitch setOn:YES];
                
                //clockOutVc.delegate=self;
                
                [self.navigationController pushViewController:clockOutVc animated:YES];
            }
        }
        
        else
        {
            [switchSlider setOn:NO animated:YES];
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
}
- (IBAction)hashTagBtnPressed:(id)sender
{
    if ([self.tenHashTagArr count] == 0)
    {
        [ConfigManager showAlertMessage:nil Message:@"No hash tag found"];
    }
    else
    {
        [self.hashTagPopoverView setFrame:CGRectMake(50,230, self.tagPopoverView.frame.size.width, self.tagPopoverView.frame.size.height)];
        self.hashTagPopoverView.layer.cornerRadius=5;
        self.hashTagPopoverView.clipsToBounds=YES;
        
        hashTagTblView.layer.cornerRadius=5;
        hashTagTblView.clipsToBounds=YES;
        
        [self.view addSubview:self.hashTagPopoverView];
        
        
    }
}
-(IBAction)editIntroAction:(id)sender
{
    if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null] || [self.selectedTag.tagId isEqualToString:@""]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            self.objEditTagIntroViewController=[[EditTagIntroViewController alloc] initWithNibName:@"EditTagIntroViewController_iphone" bundle:nil];
            
            self.objEditTagIntroViewController.tagId=self.selectedTag.tagId;
            self.objEditTagIntroViewController.intro=self.descriptionTxtView.text;
            
            [self.navigationController pushViewController:self.objEditTagIntroViewController animated:YES];
        }
        else
        {
            
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                self.objEditTagIntroViewController=[[EditTagIntroViewController alloc] initWithNibName:@"EditTagIntroViewController_iphone" bundle:nil];
                
                self.objEditTagIntroViewController.tagId=self.selectedTag.tagId;
                self.objEditTagIntroViewController.intro=self.descriptionTxtView.text;
                
                [self.navigationController pushViewController:self.objEditTagIntroViewController animated:YES];
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:@"Please clockin first"];
            }
        }
        
        
    }
    
}
-(IBAction)btnCloseTagView:(id)sender
{
    [self.tagPopoverView removeFromSuperview];
}
-(IBAction)btnCloseHashTagView:(id)sender
{
    [self.hashTagPopoverView removeFromSuperview];
}
-(IBAction)btnCloseShareView:(id)sender
{
    [self.shareContactView removeFromSuperview];
    
}
-(IBAction)btnMessageAction:(id)sender
{
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        sharedAppDelegate.checkSlideMenuAction=@"Message";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_RIGHT_MENU_NOTIFICATION_UPDATE object:nil];
        
        sharedAppDelegate.strSelectedTagId = self.selectedTag.tagId;
        sharedAppDelegate.strCheckUserAndTag=@"Tag";
        sharedAppDelegate.checkSpecialGroupChat=@"0";
        
        [self.menuContainerViewController toggleRightSideMenuCompletion:^{
            
        }];
        
    }
    else
    {
        if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
            
            sharedAppDelegate.checkSlideMenuAction=@"Message";
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AC_RIGHT_MENU_NOTIFICATION_UPDATE object:nil];
            
            sharedAppDelegate.strSelectedTagId = self.selectedTag.tagId;
            sharedAppDelegate.strCheckUserAndTag=@"Tag";
            sharedAppDelegate.checkSpecialGroupChat=@"0";
            
            sharedAppDelegate.unreadGroupChatCount=0;
            [btnGroupChatCount setHidden:TRUE];
            
            
            [self.menuContainerViewController toggleRightSideMenuCompletion:^{
                
            }];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
}
-(IBAction)btnSpecialMessageAction:(id)sender
{
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        sharedAppDelegate.checkSlideMenuAction=@"Message";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_RIGHT_MENU_NOTIFICATION_UPDATE object:nil];
        
        sharedAppDelegate.strSelectedTagId = self.selectedTag.tagId;
        sharedAppDelegate.strCheckUserAndTag=@"Tag";
        sharedAppDelegate.checkSpecialGroupChat=@"1";
        
        sharedAppDelegate.unreadSpecialGroupChatCount=0;
        [btnSpecialChatCount setHidden:TRUE];
        
        
        [self.menuContainerViewController toggleRightSideMenuCompletion:^{
            
        }];
    }
    else
    {
        if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
            
            sharedAppDelegate.checkSlideMenuAction=@"Message";
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AC_RIGHT_MENU_NOTIFICATION_UPDATE object:nil];
            
            sharedAppDelegate.strSelectedTagId = self.selectedTag.tagId;
            sharedAppDelegate.strCheckUserAndTag=@"Tag";
            sharedAppDelegate.checkSpecialGroupChat=@"1";
            sharedAppDelegate.unreadSpecialGroupChatCount=0;
            [btnSpecialChatCount setHidden:TRUE];
            
            
            [self.menuContainerViewController toggleRightSideMenuCompletion:^{
                
            }];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
}
-(NSString*)shortStyleDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString* shortDate = [df stringFromDate:date];
    return shortDate;
}
#pragma mark FeedListTableViewCellDelegate Mehtods--------

-(void)FavButtonDidClick:(UIButton*)sender
{
    //  NSIndexPath *indexPath = [tblLeftFeedView indexPathForCell:sender];
    
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    Feeds *feed=[self.arrFeedList objectAtIndex:index];
    
    NSLog(@"%@",feed.postId);
    
    self.selectedIndex=index;

    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddFavoriteInvocation:sharedAppDelegate.userObj.userId tagId:self.selectedTag.tagId feedId:feed.postId delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)SadSmileDidClick:(UIButton*)sender
{
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    Feeds *feed=[self.arrFeedList objectAtIndex:index];
    
    self.selectedIndex=index;
    
    checkSmile=FALSE;

    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddSmileInvocation:feed.postUserId tagId:self.selectedTag.tagId feedId:feed.postId status:@"0" delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)SmileDidClick:(UIButton*)sender
{
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    Feeds *feed=[self.arrFeedList objectAtIndex:index];
    
    self.selectedIndex=index;
    
    checkSmile=TRUE;

    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddSmileInvocation:feed.postUserId tagId:self.selectedTag.tagId feedId:feed.postId status:@"1" delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)LocationButtonDidClick:(UIButton*)sender
{
    //if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
    
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    Feeds *f = [self.arrFeedList objectAtIndex:index];
    
    if (f.latitude<=0 && f.longitude<=0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Location not available"];
    }
    else
    {
        
        if (IS_DEVICE_IPAD) {
            
            self.locationVC = [[UserLocationVC alloc] initWithNibName:@"UserLocationVC" bundle:nil];
            self.locationVC.feed = f;
            self.locationVC.checkLocationView=@"feed";
            
            self.popover = [[UIPopoverController alloc] initWithContentViewController:self.locationVC];
            
            self.popover.popoverContentSize= CGSizeMake(450, 780);
            
            [self.popover presentPopoverFromRect:tblLeftFeedView.frame inView:tblLeftFeedView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            
            self.locationVC = [[UserLocationVC alloc] initWithNibName:@"UserLocationVC_iphone" bundle:nil];
            
            self.locationVC.feed = f;
            // locationVC.checkLocationView=@"feed";
            self.locationVC.checkLocationView=@"map";
            
            [self.view addSubview:self.locationVC.view];
            
        }
        
    }
    
    
    //}
}
#pragma mark Share PDF delegate and methods--------

- (void)requestSendChatText
{
    ContactD *c = [self.contactEmailArr objectAtIndex:self.selectedIndex];
    
    NSString* strMemberId = c.userid;
    
    NSMutableDictionary* dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dictionary setValue:pdfNameStr forKey:@"file"];
    [dictionary setValue:@"2" forKey:@"textType"];
    [dictionary setValue:strMemberId forKey:@"member_id"];
    [dictionary setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [dictionary setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Sending..." width:150];
        [[AmityCareServices sharedService] SendMessageInvocation:dictionary delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

-(IBAction)btnShareAction:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self.contactEmailArr count] > 0)
    {
        if([self.arrFeedList count]>0)
        {
            [self showContactList];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"No Feeds Found"];
        }
    }
    else
    {
        if([self.arrFeedList count]>0)
        {
            [self getContactList];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"No Feeds Found"];
        }
    }
    
}
- (void)showContactList
{
    [shareContactView setFrame:CGRectMake(50,250, shareContactView.frame.size.width, shareContactView.frame.size.height)];
    shareContactView.layer.cornerRadius=5;
    shareContactView.clipsToBounds=YES;
    
    shareTblView.layer.cornerRadius=5;
    shareTblView.clipsToBounds=YES;
    
    [self.view addSubview:shareContactView];
}

-(void)getContactList
{
    if([ConfigManager isInternetAvailable]){
        [self.contactEmailArr removeAllObjects];
        
        [DSBezelActivityView removeView];

        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
        [[AmityCareServices sharedService] getAmityContactListInvocation:sharedAppDelegate.userObj.userId delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
- (void)generatePDFFromView:(UIView *)pdfView
{
    CGRect priorBounds = pdfView.bounds;
    CGSize fittedSize = [pdfView sizeThatFits:CGSizeMake(priorBounds.size.width, HUGE_VALF)];
    pdfView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
    
    CGRect pdfPageBounds = CGRectMake(0, 0, 612, 792);
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
        for (CGFloat pageOriginY = 0; pageOriginY < fittedSize.height; pageOriginY += pdfPageBounds.size.height) {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
            CGContextSaveGState(UIGraphicsGetCurrentContext()); {
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY);
                [pdfView.layer renderInContext:UIGraphicsGetCurrentContext()];
            } CGContextRestoreGState(UIGraphicsGetCurrentContext());
        }
    } UIGraphicsEndPDFContext();
    pdfView.bounds = priorBounds;
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Test%@",[NSDate date]]];
    
    if ([pdfData writeToFile:documentDirectoryFilename atomically:YES])
    {
        NSLog(@"Saved");
    }
    else
        NSLog(@"Not Saved");
    
    //    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
}

- (NSData *)pdfDataWithTableView:(UITableView *)tableView
{
    [tableView setBackgroundColor:[UIColor colorWithRed:0.03137254 green:0.32549019 blue:0.40784313 alpha:1.0]];
    
    CGRect pdfPageBounds = CGRectMake(0, 0, tableView.contentSize.width, tableView.contentSize.height);
    
    CGRect priorBounds = tableView.bounds;
    CGSize fittedSize = [tableView sizeThatFits:CGSizeMake(priorBounds.size.width, HUGE_VALF)];
    tableView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
    
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil);
    {
        for (CGFloat pageOriginY = 0; pageOriginY < fittedSize.height; pageOriginY += pdfPageBounds.size.height)
        {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
            CGContextSaveGState(UIGraphicsGetCurrentContext());
            {
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY);
                [tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
            } CGContextRestoreGState(UIGraphicsGetCurrentContext());
        }
    } UIGraphicsEndPDFContext();
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        tblLeftFeedView.frame = CGRectMake(tblLeftFeedView.frame.origin.x, 305, tblLeftFeedView.frame.size.width, self.view.frame.size.height-305);
        
    }
    else
    {
        tblLeftFeedView.frame = CGRectMake(tblLeftFeedView.frame.origin.x, 345, tblLeftFeedView.frame.size.width, self.view.frame.size.height-345);
        
    }
    [tblLeftFeedView setBackgroundColor:[UIColor clearColor]];

    return pdfData;
}

#pragma mark UITableView delegate Mehtods--------


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount=0;
    
    if (tableView==tblLeftFeedView) {
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            if (checkHashSearch==FALSE) {
                
                NSInteger numberOfRows = 0;
                
                NSLog(@"%lu",recordCount);
                NSLog(@"%lu",(unsigned long)[self.arrFeedList count]);
                
                if(recordCount > [self.arrFeedList count])
                    
                    numberOfRows = [self.arrFeedList count]+1;
                else
                    
                    numberOfRows = [self.arrFeedList count];
                
                rowCount=numberOfRows;
            }
            else
            {
                rowCount=[self.arrTaggedKeywords count];
            }
            
        }
        else if (leftSecondSegment.selectedSegmentIndex==1)
        {
            rowCount=[self.arrInboxListing count];
        }
       
        else if (leftSecondSegment.selectedSegmentIndex==2)
        {
            NSInteger numberOfRows = 0;
            
            NSLog(@"%lu",recordCount);
            NSLog(@"%lu",(unsigned long)[self.arrNotificationList count]);
            
            if(recordCount > [self.arrNotificationList count])
                
                numberOfRows = [self.arrNotificationList count]+1;
            else
                
                numberOfRows = [self.arrNotificationList count];
            
            rowCount=numberOfRows;
        }
        
    }
    else if(tableView==tblViewTagList)
    {
        rowCount=[self.arrTagsList count];
    }
    else if(tableView==hashTagTblView)
    {
        rowCount=[self.tenHashTagArr count];
    }
    else
    {
        rowCount= [self.contactEmailArr count];
        
    }
    return rowCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height=0;
    
    if (tableView==tblLeftFeedView) {
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            if (checkHashSearch==FALSE) {
                
                height=60;
                
            }
            else
            {
                height=44;
                
            }
            
        }
        else if (leftSecondSegment.selectedSegmentIndex==1)
        {
            height=90;
        }
        else if (leftSecondSegment.selectedSegmentIndex==2)
        {
            if(indexPath.row < [self.arrNotificationList count]){
                
                NotificationD* nData = (NotificationD*)[self.arrNotificationList objectAtIndex:indexPath.row];
                
                CGRect textRect= [nData.ntext boundingRectWithSize:CGSizeMake(310.0f, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:11.0]}
                                                           context:nil];
            
            CGSize sizeToFit = textRect.size;
            
            height=sizeToFit.height+40;
                
            }
            
            else
            {
            height=60;
            
            }

        }
    
    }
    else if(tableView==tblViewTagList || tableView==hashTagTblView)
    {
        height=44;
    }
    else
    {
        height=44;
    }
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* feedCellIdentifier = @"FeedListCell";
    static NSString* tagCellIdentifier = @"TagListCell";
    static NSString *emailCellIdentifier=@"EmailCell";
    static NSString *statusCellIdentifier=@"StatusCell";
    static NSString *notificationCellIdentifier=@"NotificationCell";
    static NSString *hashCellIdenitifier = @"hashCellIdentifier";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    static NSString* hashCellIdentifier = @"hashCellIdentifier";
    static NSString *cellIdenitifier = @"ContactEmail";
    
    if (tableView==tblLeftFeedView) {
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            if (checkHashSearch==FALSE) {
                
                if(indexPath.row < [self.arrFeedList count])
                {
                    feedCell = (FeedListTableViewCell*)[tblLeftFeedView dequeueReusableCellWithIdentifier:feedCellIdentifier];
                    
                    if (Nil == feedCell)
                    {
                        feedCell = [FeedListTableViewCell createTextRowWithOwner:self withDelegate:self];
                    }
                    
                    Feeds *data=[self.arrFeedList objectAtIndex:indexPath.row];
                    
                    feedCell.lblName.text=data.postUserName;
                    feedCell.lblIntro.text=data.postDesc;
                    feedCell.lbldate.text=data.postTime;
                    feedCell.lblEmail.text=data.postUserEmail;
                    
                    if ([sharedAppDelegate.userObj.userId isEqualToString:data.postUserId]) {
                        
                        [feedCell.btnFav setHidden:TRUE];
                        [feedCell.btnLocation setHidden:FALSE];
                        [feedCell.btnSadSmile setHidden:TRUE];
                        [feedCell.btnSmile setHidden:TRUE];
                        
                        [feedCell.btnFav setFrame:CGRectMake(267, feedCell.btnFav.frame.origin.y, feedCell.btnFav.frame.size.width, feedCell.btnFav.frame.size.height)];
                        
                        [feedCell.btnLocation setFrame:CGRectMake(292, feedCell.btnLocation.frame.origin.y, feedCell.btnLocation.frame.size.width, feedCell.btnLocation.frame.size.height)];
                        
                    }
                    else
                    {
                        
                        [feedCell.btnFav setHidden:FALSE];
                        [feedCell.btnLocation setHidden:FALSE];
                        [feedCell.btnSadSmile setHidden:FALSE];
                        [feedCell.btnSmile setHidden:FALSE];
                        
                        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                            
                            [feedCell.btnSadSmile setHidden:FALSE];
                            [feedCell.btnSmile setHidden:FALSE];
                            [feedCell.btnFav setHidden:FALSE];

                            [feedCell.btnFav setFrame:CGRectMake(215, feedCell.btnFav.frame.origin.y, feedCell.btnFav.frame.size.width, feedCell.btnFav.frame.size.height)];
                            
                            [feedCell.btnLocation setFrame:CGRectMake(240, feedCell.btnLocation.frame.origin.y, feedCell.btnLocation.frame.size.width, feedCell.btnLocation.frame.size.height)];
                            
                            
                            if ([data.postStatus isEqualToString:@"1"]) {
                                
                                [feedCell.btnSmile setImage:[UIImage imageNamed:@"smiley_tick"] forState:UIControlStateNormal];
                                
                                [feedCell.btnSadSmile setEnabled:FALSE];
                                [feedCell.btnSmile setEnabled:FALSE];
                                
                                
                            }
                            else if ([data.postStatus isEqualToString:@"2"]) {
                                
                                [feedCell.btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley_tick"] forState:UIControlStateNormal];
                                
                                [feedCell.btnSadSmile setEnabled:FALSE];
                                [feedCell.btnSmile setEnabled:FALSE];
                                
                            }
                            else
                            {
                                
                                [feedCell.btnSmile setImage:[UIImage imageNamed:@"smiley"] forState:UIControlStateNormal];
                                
                                [feedCell.btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley"] forState:UIControlStateNormal];
                                
                                [feedCell.btnSadSmile setEnabled:TRUE];
                                [feedCell.btnSmile setEnabled:TRUE];
                            }
                            
                        }
                        else
                        {
                            [feedCell.btnSadSmile setHidden:TRUE];
                            [feedCell.btnSmile setHidden:TRUE];
                            [feedCell.btnFav setHidden:TRUE];
                            
                            [feedCell.btnFav setFrame:CGRectMake(267, feedCell.btnFav.frame.origin.y, feedCell.btnFav.frame.size.width, feedCell.btnFav.frame.size.height)];
                            
                            [feedCell.btnLocation setFrame:CGRectMake(292, feedCell.btnLocation.frame.origin.y, feedCell.btnLocation.frame.size.width, feedCell.btnLocation.frame.size.height)];
                            
                        }
                    }
                    
                    feedCell.imgView.layer.cornerRadius = floor(feedCell.imgView.frame.size.width/2);
                    feedCell.imgView.clipsToBounds = YES;
                    
                    [feedCell.btnFav setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                    
                    [feedCell.btnSadSmile setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                    
                    [feedCell.btnSmile setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                    
                    [feedCell.btnLocation setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                    
                    [feedCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,data.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
                    
                    [feedCell setBackgroundColor:[UIColor clearColor]];
                    
                    feedCell.lblName.font = [UIFont fontWithName:boldfontName size:15.0];
                    feedCell.lblIntro.font = [UIFont fontWithName:appfontName size:11.0f];
                    
                    if ([data.postFavStatus isEqualToString:@"1"]) {
                        
                        [feedCell.btnFav setImage:[UIImage imageNamed:@"star_tick"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [feedCell.btnFav setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                        
                    }
                    if ([data.postId isEqualToString:@"-1"]) {
                        
                        [feedCell.btnFav setHidden:TRUE];
                        [feedCell.btnSadSmile setHidden:TRUE];
                        [feedCell.btnSmile setHidden:TRUE];
                        
                    }
                    
                    return feedCell;
                }
                else
                {
                    //load more option
                    
                    
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
                    
                    [headerbutton setFrame:CGRectMake(0, 0, 350, 60)];
                    
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
                UITableViewCell* cell = [tblLeftFeedView dequeueReusableCellWithIdentifier:hashCellIdentifier];
                
                if(cell != nil)
                {
                    cell = nil;
                }
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:hashCellIdentifier];
                
                Keywords* keyword = [arrTaggedKeywords objectAtIndex:indexPath.row];
                
                cell.textLabel.text = [NSString stringWithFormat:@"#%@",keyword.title];
                cell.textLabel.font = [UIFont fontWithName:appfontName size:14.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                
                cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@ Posts",keyword.count];
                cell.detailTextLabel.font = [UIFont fontWithName:appfontName size:11.0];
                cell.detailTextLabel.textColor = TEXT_COLOR_BLUE;
                
                return cell;
                
            }
            
        }
        else if(leftSecondSegment.selectedSegmentIndex==1)
        {
            inboxCell = (InboxListTableViewCell*)[tblLeftFeedView dequeueReusableCellWithIdentifier:emailCellIdentifier];
            
            if (Nil == inboxCell)
            {
                inboxCell = [InboxListTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            InboxData *data=[self.arrInboxListing objectAtIndex:indexPath.row];
            
            inboxCell.lblDate.text=data.mailDate;
            inboxCell.lblSubject.text=data.mailSubject;
            inboxCell.lblTitle.text=data.mailFrom;
            
            
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
       
        else if(leftSecondSegment.selectedSegmentIndex==2)
        {
            
            if(indexPath.row < [self.arrNotificationList count]){
                
                NotificationD* nData = (NotificationD*)[self.arrNotificationList objectAtIndex:indexPath.row];
                
                NotificationCell *cell = nil;
                
                cell = [tblLeftFeedView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
                @try {
                    if(cell != nil)
                    {
                        cell = nil;
                    }
                    cell =  [[NotificationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:notificationCellIdentifier];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    
                    cell.textLabel.numberOfLines=0;
                    
                    
                    CGRect textRect = [nData.ntext boundingRectWithSize:CGSizeMake(cell.textLabel.frame.size.width, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:cell.textLabel.font}
                                                                context:nil];
                    
                    CGSize sizeToFit = textRect.size;
                    
                    
                    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, sizeToFit.height)];
                    
                    [cell setNotificationData:nData];
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    return cell;
                }

            }
            else
            {
                //load more option
                
                
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
                
                [headerbutton setFrame:CGRectMake(0, 0, 350, 60)];
                
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
    }
    else if(tableView==tblViewTagList)
    {
        TagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellIdentifier];
        
        if(!cell){
            cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tagCellIdentifier];
        }
        cell.tagData = [self.arrTagsList objectAtIndex:indexPath.row];
        
        return cell;
        
    }
    else if (tableView == hashTagTblView)
    {
        UITableViewCell *cell = [tblLeftFeedView dequeueReusableCellWithIdentifier:hashCellIdenitifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hashCellIdenitifier];
        }
        
        cell.textLabel.text = [[[self.tenHashTagArr valueForKey:@"title"] objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        if (!IS_DEVICE_IPAD) {
            
            cell.textLabel.font=[UIFont systemFontOfSize:13.0];
            cell.textLabel.backgroundColor=[UIColor clearColor];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tblLeftFeedView dequeueReusableCellWithIdentifier:cellIdenitifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenitifier];
        }
        
        ContactD* c = [self.contactEmailArr objectAtIndex:indexPath.row];
        cell.textLabel.text = c.userName;
        
        return cell;
        
    }
    return nil;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblLeftFeedView) {
        
        if (leftSecondSegment.selectedSegmentIndex==0)
        {
            if (checkHashSearch==FALSE) {
                
                Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
                
                if ([feed.postType isEqualToString:@"6"]) {
                    
                    self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController_iphone" bundle:nil];
                    
                    self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
                    
                    self.objFormFeedDetailViewController.feedDetails=feed;
                    
                    [self.view addSubview:self.objFormFeedDetailViewController.view];
                }
                else if([feed.postType isEqualToString:@"4"])
                {
                    self.objStatusFeedDetailViewController=[[StatusFeedDetailViewController alloc] initWithNibName:@"StatusFeedDetailViewController_iphone" bundle:nil];
                    
                    self.objStatusFeedDetailViewController.feedDetails=feed;
                    self.objStatusFeedDetailViewController.checkBSAndFamily=@"NO";
                    
                    [self.view addSubview:self.objStatusFeedDetailViewController.view];
                }
                else if([feed.postType isEqualToString:@"7"])
                {
                    if ([feed.routeType isEqualToString:@"1"]) {
                        
                        self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController_iphone" bundle:nil];
                        self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.objRouteFeedDetailViewController.feedDetails=feed;
                        
                        [self.view addSubview:self.objRouteFeedDetailViewController.view];
                    }
                    else
                    {
                        self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController_iphone" bundle:nil];
                        
                        self.objRecieptFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                        self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.objRecieptFeedDetailViewController.feedDetails=feed;
                        
                        [self.view addSubview:self.objRecieptFeedDetailViewController.view];
                    }
                    
                    
                    
                    
                }
                
                else
                {
                    self.objFeedDetailViewController=[[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController_iphone" bundle:nil];
                    self.objFeedDetailViewController.checkBSAndFamily=@"NO";
                    
                    self.objFeedDetailViewController.feedDetails=feed;
                    
                    [self.view addSubview:self.objFeedDetailViewController.view];
                }
            }
            else
            {
                Keywords *keyword=[self.arrTaggedKeywords objectAtIndex:indexPath.row];
                self.strHashTag=keyword.title;
                
                checkHashSearch=FALSE;
                
                pageIndex = 1;
                
                tblLeftFeedView.delegate=nil;
                tblLeftFeedView.dataSource=nil;
                
                [self.arrFeedList removeAllObjects];
                NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
                
                [bodyD setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                [bodyD setObject:self.selectedTag.tagId forKey:@"tag_id"];
                [bodyD setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
                [bodyD setObject:keyword.ide forKey:@"keyword_id"];
                [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
                [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
                
                [self requestForTagSearchFeeds:bodyD];
            }
            
        }
        else if (leftSecondSegment.selectedSegmentIndex==1) {
            
           self.objInboxDetailViewController =[[InboxDetailViewController alloc] initWithNibName:@"InboxDetailViewController_iphone" bundle:nil];
            
            
            self.objInboxDetailViewController.arrMailData=[[NSMutableArray alloc] initWithArray:self.arrInboxListing];
            self.objInboxDetailViewController.selectedIndex=indexPath.row;
            
            
            [self.view addSubview:self.objInboxDetailViewController.view];
            
        }
        
        
    }
    else if (tableView==tblViewTagList)
    {
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            pageIndex=1;
            
            leftSecondSegment.selectedSegmentIndex=0;
            
            [self.arrFeedList removeAllObjects];
            
            [tagPopoverView removeFromSuperview];
            
            tblLeftFeedView.delegate=nil;
            tblLeftFeedView.dataSource=nil;
            
            self.selectedTag=nil;
            sharedAppDelegate.selectedTag=nil;
            sharedAppDelegate.strSelectedTagId=nil;
            sharedAppDelegate.strSelectedTag=nil;
            
            self.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
            sharedAppDelegate.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
            
            sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
            sharedAppDelegate.strSelectedTag=self.selectedTag.tagTitle;
            
            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
        }
        else
        {
            if (clockInSwitch.isOn) {
                
                [tagPopoverView removeFromSuperview];
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Please clockout first from %@",self.selectedTag.tagTitle] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                pageIndex=1;
                
                leftSecondSegment.selectedSegmentIndex=0;
                
                [self.arrFeedList removeAllObjects];
                
                [tagPopoverView removeFromSuperview];
                
                tblLeftFeedView.delegate=nil;
                tblLeftFeedView.dataSource=nil;
                
                self.selectedTag=nil;
                sharedAppDelegate.selectedTag=nil;
                sharedAppDelegate.strSelectedTagId=nil;
                sharedAppDelegate.strSelectedTag=nil;
                
                self.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
                sharedAppDelegate.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
                
                sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
                sharedAppDelegate.strSelectedTag=self.selectedTag.tagTitle;
                
                
                [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            }
            
        }
        
    }
    else if (tableView == hashTagTblView)
    {
        
        /* isTopHashTag = YES;
         isNormalSearch = NO;
         
         selectedHashTagIndex = indexPath.row;
         
         pageIndex = 1;
         [self.arrFeedList removeAllObjects];
         
         tblLeftFeedView.delegate=nil;
         tblLeftFeedView.dataSource=nil;
         
         [tblLeftFeedView reloadData];
         
         NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
         
         [bodyD setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
         [bodyD setObject:self.selectedTag.tagId forKey:@"tag_id"];
         [bodyD setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
         [bodyD setObject:[[self.tenHashTagArr valueForKey:@"id"] objectAtIndex:indexPath.row] forKey:@"keyword_id"];
         
         [hashTagPopoverView removeFromSuperview];
         
         [self requestForTagSearchFeeds:bodyD];*/
        
        isNormalSearch = YES;
        isTopHashTag = YES;
        [self.arrFeedList removeAllObjects];
        pageIndex=1;
        [self.normalSearchDic removeAllObjects];
        
        tblLeftFeedView.delegate=nil;
        tblLeftFeedView.dataSource=nil;
        
        [hashTagPopoverView removeFromSuperview];
        
        
        selectedHashTagIndex = indexPath.row;
        
        NSString* startDate = txtStartDate.text;
        NSString* endDate   = txtEndDate.text;
        
        self.strHashTag=[[self.tenHashTagArr valueForKey:@"title"] objectAtIndex:indexPath.row];
        
        [self.normalSearchDic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [self.normalSearchDic setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
        [self.normalSearchDic setObject:startDate forKey:@"start_date"];
        [self.normalSearchDic setObject:endDate forKey:@"end_date"];
        [self.normalSearchDic setObject:self.strHashTag forKey:@"has_tag"];
        [self.normalSearchDic setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];
        [self.normalSearchDic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [self.normalSearchDic setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [self.normalSearchDic setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView removeView];

            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
            
            if (leftSecondSegment.selectedSegmentIndex==0) {
                
                [[AmityCareServices sharedService] sortFeedsByDate:self.normalSearchDic delegate:self];
                
            }
            else
            {
                [[AmityCareServices sharedService] SortTagStatusDateWiseInvocation:self.normalSearchDic delegate:self];
                
            }
        }
    }
    else
    {
        [shareContactView removeFromSuperview];
        
        self.selectedIndex = indexPath.row;
        
        NSData *pdfData = [self pdfDataWithTableView:tblLeftFeedView];
        
        if([ConfigManager isInternetAvailable])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:@"attachment" forKey:@"attachment_key"];
            [dict setObject:@"uploadPdf" forKey:@"request_path"];
            
            [DSBezelActivityView removeView];

            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            
            [dict setObject:@"test.pdf" forKey:@"filename"];
            [dict setObject:@"pdf" forKey:@"content_type"];
            
            [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
            [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            
            [[AmityCareServices sharedService] uploadDocInvocation:dict uploadData:pdfData delegate:self];
        }
        
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (leftSecondSegment.selectedSegmentIndex==2) {
        
        return TRUE;
        
    }
    else
    {
        return FALSE;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(leftSecondSegment.selectedSegmentIndex==2)
    {
        self.selectedIndxpath = indexPath;
        
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Notification ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
        [deleteAlert show];
    }
    else if(leftSecondSegment.selectedSegmentIndex==1)
    {
        self.selectedIndxpath = indexPath;
        
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Mail ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_DELETE_MAIL_CONFIRMATION;
        [deleteAlert show];
    }
    
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    if (leftSecondSegment.selectedSegmentIndex==2) {
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView removeView];

            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
            
            pageIndex=1;
            
            NSString *pageIndexStr=[NSString stringWithFormat:@"%lu",pageIndex];
            
            [[AmityCareServices sharedService] TagNotificationListInvocation:sharedAppDelegate.userObj.userId tagId:self.selectedTag.tagId page_index:pageIndexStr  delegate:self];
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
        
        
    }
    else
    {
        [self parseData];
        
    }
}

-(void)parseData
{
    if(isNormalSearch)
    {
        NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
        
        [bodyD setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [bodyD setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
        [bodyD setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [bodyD setObject:[[self.tenHashTagArr valueForKey:@"id"] objectAtIndex:selectedHashTagIndex] forKey:@"keyword_id"];
        [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        
        [self requestForTagSearchFeeds:bodyD];
        
        
    }
    else if(isTopHashTag)
    {
        [self.normalSearchDic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView removeView];

            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
            
            if (leftSecondSegment.selectedSegmentIndex==0) {
                
                [[AmityCareServices sharedService] sortFeedsByDate:self.normalSearchDic delegate:self];
                
            }
            else
            {
                [[AmityCareServices sharedService] SortTagStatusDateWiseInvocation:self.normalSearchDic delegate:self];
                
            }
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
        
        
    }
    else
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
        }
        else
        {
            [self requestForTagStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
        }
    
}
/*-(void)parseData
 {
 if(isNormalSearch)
 {
 [self.normalSearchDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
 
 if([ConfigManager isInternetAvailable]){
 
 [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
 
 if (leftSecondSegment.selectedSegmentIndex==0) {
 
 [[AmityCareServices sharedService] sortFeedsByDate:self.normalSearchDic delegate:self];
 
 }
 else
 {
 [[AmityCareServices sharedService] SortTagStatusDateWiseInvocation:self.normalSearchDic delegate:self];
 
 }
 }
 else{
 
 [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
 }
 
 }
 else if(isTopHashTag)
 {
 NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
 
 [bodyD setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
 [bodyD setObject:self.selectedTag.tagId forKey:@"tag_id"];
 [bodyD setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
 [bodyD setObject:[[self.tenHashTagArr valueForKey:@"id"] objectAtIndex:selectedHashTagIndex] forKey:@"keyword_id"];
 
 [self requestForTagSearchFeeds:bodyD];
 }
 else
 
 if (leftSecondSegment.selectedSegmentIndex==0) {
 
 [self requestGetTagFeeds:[NSNumber numberWithInt:pageIndex]];
 
 }
 else
 {
 [self requestForTagStatusList:[NSNumber numberWithInt:pageIndex]];
 }
 
 }*/

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [txtSearch resignFirstResponder];
}
#pragma mark- UIALERTVIEW

-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
                [DSBezelActivityView removeView];

                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                NSLog(@"%ld",(long)self.selectedIndxpath.row);
                NotificationD* nD = [self.arrNotificationList objectAtIndex:self.selectedIndxpath.row];
                [[AmityCareServices sharedService] deleteNotificationInvocation:sharedAppDelegate.userObj.userId notificationID:nD.nid delegate:self];
            }
            else{
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
        }
    }
    
    else if (alertView.alertTag == AC_ALERTVIEW_STATUS_SUCCESSFULLY){
        
        [self viewWillAppear:YES];
    }
    
    else if(alertView.alertTag == AC_ALERTVIEW_CLOCKIN_CLOCKOUT)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    else if(alertView.alertTag == AC_ALERTVIEW_OUT_OF_RANGE)
    {
        if(buttonIndex==0)
        {
            [clockInSwitch setOn:NO];
            
            /*  ACAlertView * av = [[ACAlertView alloc] initWithTitle:@"Please enter pin to see feeds" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Submit", nil];
             
             av.alertViewStyle = UIAlertViewStyleSecureTextInput;
             [av textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
             [av textFieldAtIndex:0].placeholder = @"PIN";
             [av textFieldAtIndex:0].delegate = self;
             av.alertTag = AC_ALERTVIEW_PIN;
             
             [av show];*/
        }
    }
    else if(alertView.alertTag == AC_ALERTVIEW_PIN)
    {
        [self.view endEditing:YES];
        
        if(buttonIndex==0)
        {
            UITextField *tf = [alertView textFieldAtIndex:0];
            
            if (![tf.text isEqualToString:sharedAppDelegate.userObj.appPin])
            {
                [clockInView.swClockin setOn:NO];
                
                [self showWrongPinAlert];
            }
            else
            {
                
                if([ConfigManager isInternetAvailable])
                {
                    [DSBezelActivityView removeView];

                    
                    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:220];
                    
                    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                    
                    [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                    [dict setObject:tf.text forKey:@"secret_pin"];
                    
                    [[AmityCareServices sharedService] checkPinInvocation:dict delegate:self];
                    
                }
                else
                {
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
        }
        
    }
    else if(alertView.alertTag == AC_ALERTVIEW_WRONG_PIN)
    {
    }
    else if(alertView.alertTag == AC_ALERTVIEW_DELETE_MAIL_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
                InboxData* inbox = [self.arrNotificationList objectAtIndex:self.selectedIndxpath.row];
                
                [DSBezelActivityView removeView];

                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                NSMutableDictionary *dic = [NSMutableDictionary new];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"userId"];
                
                [[AmityCareServices sharedService] DeleteMailInvocation:sharedAppDelegate.userObj.userId tagId:self.selectedTag.tagId mailId:inbox.mailId delegate:self];
                
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
        }
    }
    
    else if(alertView.alertTag == AC_ALERTVIEW_ALL_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable])
            {
                [DSBezelActivityView removeView];

                [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
                [[AmityCareServices sharedService] DeleteAllTagNotificationInvocation:sharedAppDelegate.userObj.userId tagId:self.selectedTag.tagId delegate:self];
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
        }
    }
    
}

- (void)showWrongPinAlert
{
    ACAlertView * av = [[ACAlertView alloc ] initWithTitle:@"Please enter correct pin" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    av.alertTag = AC_ALERTVIEW_WRONG_PIN;
    [clockInSwitch setOn:FALSE];
    [av show];
}
#pragma mark -Invocation Delegates

#pragma mark - get Feed List invocation Delegates

-(void)getFeedsInvocationDidFinish:(GetFeedsInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            NSString* imgURL = NULL_TO_NIL([response valueForKey:@"tagImage"]);
            
            totalNumber = [NULL_TO_NIL([response valueForKey:@"totalNumber"]) integerValue];
            sharedAppDelegate.calendarVisibleStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"calendar"])];

            lblNumber.text=[NSString stringWithFormat:@"Number: %lu",totalNumber];
            
            NSString *tagEmailStr=NULL_TO_NIL([response valueForKey:@"tagEmail"]);
            
            if (tagEmailStr.length==0) {
                
                lblEmail.text = @"Email:";
            }
            else
            {
                // lblEmail.text = [NSString stringWithFormat:@"Email:%@@amitycarecloud.com",NULL_TO_NIL([response valueForKey:@"tagEmail"])];
                
                lblEmail.text = [NSString stringWithFormat:@"Email: %@",NULL_TO_NIL([response valueForKey:@"tagEmail"])];
                
                
            }
            
            
            
            [lblNumber setHidden:FALSE];
            
            sharedAppDelegate.unreadGroupChatCount = [NULL_TO_NIL([response valueForKey:@"groupCount"]) integerValue];
            
            sharedAppDelegate.unreadSpecialGroupChatCount = [NULL_TO_NIL([response valueForKey:@"specialGroupCount"]) integerValue];
            
            sharedAppDelegate.unreadTagCount = [NULL_TO_NIL([response valueForKey:@"tagCount"]) integerValue];
            
            
            if (sharedAppDelegate.unreadSpecialGroupChatCount>0) {
                
                if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                    
                    [btnSpecialChatCount setHidden:FALSE];
                    
                    [btnSpecialChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadSpecialGroupChatCount] forState:UIControlStateNormal];
                }
                else
                {
                    [btnSpecialChatCount setHidden:TRUE];
                }
            }
            else
            {
                [btnSpecialChatCount setHidden:TRUE];
                
            }
            if (sharedAppDelegate.unreadGroupChatCount>0) {
                
                [btnGroupChatCount setHidden:FALSE];
                [btnGroupChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
            }
            else
            {
                [btnGroupChatCount setHidden:TRUE];
                
            }
            
            if (sharedAppDelegate.unreadTagCount>0) {
                
                [btnTagNotificationCount setHidden:FALSE];
                [btnTagNotificationCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadTagCount] forState:UIControlStateNormal];
            }
            else
            {
                [btnTagNotificationCount setHidden:TRUE];
                
            }
            
            if([imgURL length] > 0)
                [self.tagImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]] placeholderImage:[UIImage imageNamed:@"imageNoAvailable"]];
            
            NSLog(@"Imaeg URL %@",[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]);
            
            // self.tagTitleLbl.text = self.selectedTag.tagTitle;
            self.tagTitleLbl.text = sharedAppDelegate.strSelectedTag;
            
            [self.tenHashTagArr removeAllObjects];
            
            self.tenHashTagArr = NULL_TO_NIL([[response valueForKey:@"topHasTag"] mutableCopy]);
            
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                
                if (!isTwentyHoursUpdate)// timer will not start for 24 hours update
                {
                    [clockInView startTimer];
                }
                
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                tagLblDate.text=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagCreated"])];
                
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
                    
                    /*if (sharedAppDelegate.isRecording==FALSE) {
                     
                     if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     
                     if ([sharedAppDelegate.userObj.recordingStatus isEqualToString:@"1"]) {
                     
                     [sharedAppDelegate checkTimeIntervalTimer];
                     }
                     }
                     
                     
                     }*/
                    
                    
                }
                else
                {
                    descriptionTxtView.text = @"";
                    
                    /* if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     
                     [sharedAppDelegate invalidateRecordingTimers];
                     
                     }*/
                    
                }
                
                NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
               
                
                if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                    
                }
                else
                {
                    if(clockinTime && !isClockInFeedAdded)
                    {
                        recordCount = recordCount+1;

                        Feeds *clockInFeed = [[Feeds alloc] init];
                        
                        clockInFeed.postUserEmail = sharedAppDelegate.userObj.default_email;
                        
                        clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                        clockInFeed.postUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
                        clockInFeed.postUserImgURL = sharedAppDelegate.userObj.image;
                        clockInFeed.postId = @"-1";//Dharmbir
                        //                    clockInFeed.postId = NULL_TO_NIL([response valueForKey:@"post_id"]);
                        clockInFeed.postTime = clockinTime;
                        clockInFeed.postThumbnailURL = NULL_TO_NIL([response valueForKey:@"clock_in_image"]);
                        clockInFeed.postTitle = [NSString stringWithFormat:@"Clock in on : %@",clockinTime];
                        clockInFeed.postActualTime = clockinTime;
                        clockInFeed.postDesc = @"";
                        clockInFeed.postType = @"5";
                        clockInFeed.postVideoURL = NULL_TO_NIL([response valueForKey:@"clock_in_url"]);
                        clockInFeed.latitude = [NULL_TO_NIL([response valueForKey:@"clock_in_latitude"]) floatValue];
                        clockInFeed.longitude = [NULL_TO_NIL([response valueForKey:@"clock_in_longitude"]) floatValue];
                        clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                        
                        [self.arrFeedList insertObject:clockInFeed atIndex:0];
                        
                        isClockInFeedAdded = !isClockInFeedAdded;
                    }
                }
                
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
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
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
                        //feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        
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
                                t.strFormQueStr = NULL_TO_NIL([inner valueForKey:@"label"]);
                                t.strFormAnsStr = NULL_TO_NIL([inner valueForKey:@"value"]);
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
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                [tblLeftFeedView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                    
                    sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                    
                    NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                        
                    }
                    else
                    {
                        if(clockinTime && !isClockInFeedAdded)
                        {
                            recordCount = recordCount+1;

                            Feeds *clockInFeed = [[Feeds alloc] init];
                            clockInFeed.postUserEmail = sharedAppDelegate.userObj.default_email;
                            
                            clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                            clockInFeed.postUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
                            clockInFeed.postUserImgURL = sharedAppDelegate.userObj.image;
                            //                        clockInFeed.postId = @"-1";//Dharmbir
                            clockInFeed.postId = @"-1";
                            clockInFeed.postTime = clockinTime;
                            clockInFeed.postThumbnailURL = NULL_TO_NIL([response valueForKey:@"clock_in_image"]);
                            clockInFeed.postTitle = [NSString stringWithFormat:@"Clock in on : %@",clockinTime];
                            clockInFeed.postActualTime = clockinTime;
                            clockInFeed.postDesc = nil;
                            clockInFeed.postType = @"5";
                            clockInFeed.postVideoURL = NULL_TO_NIL([response valueForKey:@"clock_in_url"]);
                            clockInFeed.latitude = [NULL_TO_NIL([response valueForKey:@"clock_in_latitude"]) floatValue];
                            clockInFeed.longitude = [NULL_TO_NIL([response valueForKey:@"clock_in_longitude"]) floatValue];
                            
                            clockInFeed.employeeStatusStr   = NULL_TO_NIL([response valueForKey:@"employee"]);
                            clockInFeed.managerStatusStr    = NULL_TO_NIL([response valueForKey:@"manager"]);
                            clockInFeed.teamLeaderStatusStr = NULL_TO_NIL([response valueForKey:@"teamleader"]);
                            clockInFeed.familyStatusStr     = NULL_TO_NIL([response valueForKey:@"family"]);
                            //clockInFeed.trainingStatusStr   = NULL_TO_NIL([response valueForKey:@"training"]);
                            clockInFeed.bsStatusStr         = NULL_TO_NIL([response valueForKey:@"BS"]);
                            
                            NSLog(@"EMployee %@",clockInFeed.employeeStatusStr);
                            
                            NSLog(@"EMployee %@",clockInFeed.managerStatusStr);
                            
                            clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                            
                            [self.arrFeedList insertObject:clockInFeed atIndex:0];
                            
                            isClockInFeedAdded = !isClockInFeedAdded;
                        }
                        
                    }
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                }
                
                [tblLeftFeedView reloadData];
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
        
        [tagImgView setHidden:FALSE];
        [tagTitleLbl setHidden:FALSE];
        [btnMesssage setHidden:FALSE];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [btnShare setHidden:TRUE];
            [descriptionTxtView setHidden:TRUE];
            [btnEditIntro setHidden:TRUE];
            [btnTopHashTag setHidden:TRUE];
            [tagLblDate setHidden:TRUE];
            [imgDate setHidden:TRUE];
            [lblNumber setHidden:TRUE];
            [lblEmail setHidden:TRUE];
        }
        else
        {
            [btnShare setHidden:FALSE];
            [descriptionTxtView setHidden:FALSE];
            [btnEditIntro setHidden:FALSE];
            [btnTopHashTag setHidden:FALSE];
            [tagLblDate setHidden:FALSE];
            [imgDate setHidden:FALSE];
            [lblNumber setHidden:FALSE];
            [lblEmail setHidden:FALSE];
        }
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [btnSpecialMesssage setHidden:FALSE];
        }
        else
        {
            [btnSpecialMesssage setHidden:TRUE];
        }
        [DSBezelActivityView removeView];
        
    }
}
-(void)TagStatusListInvocationDidFinish:(TagStatusListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            NSString* imgURL = NULL_TO_NIL([response valueForKey:@"tagImage"]);
            
            totalNumber = [NULL_TO_NIL([response valueForKey:@"totalNumber"]) integerValue];
            
            lblNumber.text=[NSString stringWithFormat:@"Number: %lu",totalNumber];
            [lblNumber setHidden:FALSE];
            
            if([imgURL length] > 0)
                [self.tagImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]] placeholderImage:[UIImage imageNamed:@"imageNoAvailable"]];
            
            NSLog(@"Imaeg URL %@",[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]);
            
            // self.tagTitleLbl.text = self.selectedTag.tagTitle;
            self.tagTitleLbl.text = sharedAppDelegate.strSelectedTag;
            
            [self.tenHashTagArr removeAllObjects];
            
            self.tenHashTagArr = NULL_TO_NIL([[response valueForKey:@"topHasTag"] mutableCopy]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                if (!isTwentyHoursUpdate)// timer will not start for 24 hours update
                {
                    [clockInView startTimer];
                }
                
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
                    
                    /* if (sharedAppDelegate.isRecording==FALSE) {
                     
                     if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     
                     if ([sharedAppDelegate.userObj.recordingStatus isEqualToString:@"1"]) {
                     
                     [sharedAppDelegate checkTimeIntervalTimer];
                     }
                     }
                     
                     }*/                  
                }
                else
                {
                    descriptionTxtView.text = @"";
                    
                    /*if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     [sharedAppDelegate invalidateRecordingTimers];
                     }*/
                }
                
                
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
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
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
                        // feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        
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
                        
                        [self.arrFeedList addObject:feed];
                        
                    }
                }
                else
                {
                    [self.arrFeedList removeAllObjects];
                    recordCount = 0;
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found"];
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                [tblLeftFeedView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                    
                    
                    
                    sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                    
                    
                    NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                    
                   
                    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                        
                    }
                    else
                    {
                        if(clockinTime && !isClockInFeedAdded)
                        {
                            recordCount = recordCount+1;

                            Feeds *clockInFeed = [[Feeds alloc] init];
                            clockInFeed.postUserEmail = sharedAppDelegate.userObj.default_email;
                            
                            clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                            clockInFeed.postUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
                            clockInFeed.postUserImgURL = sharedAppDelegate.userObj.image;
                            //                        clockInFeed.postId = @"-1";//Dharmbir
                            clockInFeed.postId = @"-1";
                            clockInFeed.postTime = clockinTime;
                            clockInFeed.postThumbnailURL = NULL_TO_NIL([response valueForKey:@"clock_in_image"]);
                            clockInFeed.postTitle = [NSString stringWithFormat:@"Clock in on : %@",clockinTime];
                            clockInFeed.postActualTime = clockinTime;
                            clockInFeed.postDesc = nil;
                            clockInFeed.postType = @"5";
                            clockInFeed.postVideoURL = NULL_TO_NIL([response valueForKey:@"clock_in_url"]);
                            clockInFeed.latitude = [NULL_TO_NIL([response valueForKey:@"clock_in_latitude"]) floatValue];
                            clockInFeed.longitude = [NULL_TO_NIL([response valueForKey:@"clock_in_longitude"]) floatValue];
                            
                            
                            clockInFeed.employeeStatusStr   = NULL_TO_NIL([response valueForKey:@"employee"]);
                            clockInFeed.managerStatusStr    = NULL_TO_NIL([response valueForKey:@"manager"]);
                            clockInFeed.teamLeaderStatusStr = NULL_TO_NIL([response valueForKey:@"teamleader"]);
                            clockInFeed.familyStatusStr     = NULL_TO_NIL([response valueForKey:@"family"]);
                            //  clockInFeed.trainingStatusStr   = NULL_TO_NIL([response valueForKey:@"training"]);
                            clockInFeed.bsStatusStr         = NULL_TO_NIL([response valueForKey:@"BS"]);
                            
                            NSLog(@"EMployee %@",clockInFeed.employeeStatusStr);
                            
                            NSLog(@"EMployee %@",clockInFeed.managerStatusStr);
                            
                            
                            clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                            
                            //[self.arrFeedList insertObject:clockInFeed atIndex:0];
                            
                            isClockInFeedAdded = !isClockInFeedAdded;
                        }
                    }
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                [tblLeftFeedView reloadData];
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
        
        [tagImgView setHidden:FALSE];
        [tagTitleLbl setHidden:FALSE];
        [btnMesssage setHidden:FALSE];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [btnShare setHidden:TRUE];
            [descriptionTxtView setHidden:TRUE];
            [btnEditIntro setHidden:TRUE];
            [btnTopHashTag setHidden:TRUE];
            [tagLblDate setHidden:TRUE];
            [imgDate setHidden:TRUE];
            [lblNumber setHidden:TRUE];
            [lblEmail setHidden:TRUE];
        }
        else
        {
            [btnShare setHidden:FALSE];
            [descriptionTxtView setHidden:FALSE];
            [btnEditIntro setHidden:FALSE];
            [btnTopHashTag setHidden:FALSE];
            [tagLblDate setHidden:FALSE];
            [imgDate setHidden:FALSE];
            [lblNumber setHidden:FALSE];
            [lblEmail setHidden:FALSE];
            
        }
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [btnSpecialMesssage setHidden:FALSE];
            
        }
        else
        {
            [btnSpecialMesssage setHidden:TRUE];
        }
        [DSBezelActivityView removeView];
    }
    
}
- (void)switchValueChanged:(id)sender
{
    isNormalSearch = NO;
    isTopHashTag = NO;
    
    isTwentyHoursUpdate = NO;
    
    UISwitch *switchSlider = (UISwitch *)sender;
    
    if([ConfigManager isInternetAvailable])
    {
        if (switchSlider.isOn)
        {
            [DSBezelActivityView removeView];

            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Verifying ClockIn Please wait..." width:220];
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dict setObject:self.selectedTag.tagId forKey:@"tagId"];
            [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
            [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            
            [[AmityCareServices sharedService] clockInUserInvocation:dict delegate:self];
        }
        
    }
    
    else
    {
        [switchSlider setOn:NO animated:YES];
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

#pragma mark - ClockIn Delegates

-(void)clockInInvocationDidFinish:(ClockInInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"clockInInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                pageIndex = 1;
                
                isClockInFeedAdded = FALSE;
                
                [self.arrFeedList removeAllObjects];
                
                if([ConfigManager isInternetAvailable])
                {
                    // ---------------- Enable when user is in range --------------
                    
                    userDidClockedIn = YES;
                    
                    [clockInSwitch setOn:YES];

                    
                    [self performSelector:@selector(requestGetTagFeeds:) withObject:[NSNumber numberWithUnsignedLong:pageIndex] afterDelay:0.1f];
                }
                else{
                    
                    
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
            else
            {
                // ---------------- Disable back button when user is in range --------------
                
                id response = [dict valueForKey:@"response"];
                
                if ([[response valueForKey:@"message"] isEqualToString:@"User is out of range."])
                {
                    [clockInSwitch setOn:NO];

                    ACAlertView* alertSuccess = [ConfigManager alertView:nil message:[response valueForKey:@"message"] del:self];
                    alertSuccess.alertTag = AC_ALERTVIEW_OUT_OF_RANGE;
                    [alertSuccess show];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                    [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                }
            }
        }
        else
        {
            [clockInSwitch setOn:NO];

            
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
        clockInPress=TRUE;

        [DSBezelActivityView removeView];
    }
}


#pragma mark - Feed Invocation Delegates

- (void)statusInvocationDidFinish:(StatusInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    NSLog(@"%@",dict);
    
    if(!error)
    {
        NSString* strSuccess = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            recordCount = 0;
            isClockInFeedAdded = FALSE;
            [self.arrFeedList removeAllObjects];
            
            [self requestGetTagFeeds:[NSNumber numberWithInt:0]];
        }
        else
        {
            [DSBezelActivityView removeView];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}

#pragma mark - Keyword feed List Invocation Delegates

-(void)getKeywordFeedsInvocationDidFinish:(GetKeywordFeedsInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"tagSearchInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            moveToKeywordSearch = FALSE;
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]>0){
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        Feeds *feed = [[Feeds alloc] init];
                        
                        NSDictionary *fDict = [post objectAtIndex:i];
                        
                        feed.postUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.postUserName = NULL_TO_NIL([fDict valueForKey:@"username"]);
                        feed.postUserImgURL = NULL_TO_NIL([fDict valueForKey:@"user_img"]);
                        feed.postId = NULL_TO_NIL([fDict valueForKey:@"post_id"]);
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
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
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found with the search keyword"];
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                
                [tblLeftFeedView reloadData];
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

-(void)GetKeywordStatusInvocationDidFinish:(GetKeywordStatusInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"tagSearchInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            moveToKeywordSearch = FALSE;
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]>0){
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        Feeds *feed = [[Feeds alloc] init];
                        
                        NSDictionary *fDict = [post objectAtIndex:i];
                        
                        feed.postUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.postUserName = NULL_TO_NIL([fDict valueForKey:@"username"]);
                        feed.postUserImgURL = NULL_TO_NIL([fDict valueForKey:@"user_img"]);
                        feed.postId = NULL_TO_NIL([fDict valueForKey:@"post_id"]);
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
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
                                t.strFormQueStr = NULL_TO_NIL([inner valueForKey:@"label"]);
                                t.strFormAnsStr = NULL_TO_NIL([inner valueForKey:@"value"]);
                                
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
                        
                        [self.arrFeedList addObject:feed];
                    }
                }
                else
                {
                    [self.arrFeedList removeAllObjects];
                    recordCount = 0;
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found with the search keyword"];
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                
                [tblLeftFeedView reloadData];
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

#pragma mark - Get Sort feed Invocation

-(void)sortFeedsDateWiseInvocationDidFinish:(SortFeedsDateWiseInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            NSString* imgURL = NULL_TO_NIL([response valueForKey:@"tagImage"]);
            
            totalNumber = [NULL_TO_NIL([response valueForKey:@"totalNumber"]) integerValue];
            
            lblNumber.text=[NSString stringWithFormat:@"Number: %lu",totalNumber];
            [lblNumber setHidden:FALSE];
            
            if([imgURL length] > 0)
                [tagImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]] placeholderImage:[UIImage imageNamed:@"imageNoAvailable"]];
            
            NSLog(@"Imaeg URL %@",[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]);
            
            // self.tagTitleLbl.text = self.selectedTag.tagTitle;
            self.tagTitleLbl.text = sharedAppDelegate.strSelectedTag;
            
            
            [self.tenHashTagArr removeAllObjects];
            
            self.tenHashTagArr = NULL_TO_NIL([[response valueForKey:@"topHasTag"] mutableCopy]);
            
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                if (!isTwentyHoursUpdate)// timer will not start for 24 hours update
                {
                    [clockInView startTimer];
                }
                
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
                    
                    /* if (sharedAppDelegate.isRecording==FALSE) {
                     
                     if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     
                     if ([sharedAppDelegate.userObj.recordingStatus isEqualToString:@"1"]) {
                     
                     [sharedAppDelegate checkTimeIntervalTimer];
                     }
                     }
                     
                     
                     }*/
                    
                    
                }
                else
                {
                    descriptionTxtView.text = @"";
                    
                    /* if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     
                     [sharedAppDelegate invalidateRecordingTimers];
                     
                     }*/
                    
                }
                
                NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
                
                if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                    
                }
                else
                {
                    if(clockinTime && !isClockInFeedAdded)
                    {
                        recordCount = recordCount+1;

                        Feeds *clockInFeed = [[Feeds alloc] init];
                        
                        clockInFeed.postUserEmail = sharedAppDelegate.userObj.default_email;
                        
                        clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                        clockInFeed.postUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
                        clockInFeed.postUserImgURL = sharedAppDelegate.userObj.image;
                        clockInFeed.postId = @"-1";//Dharmbir
                        //                    clockInFeed.postId = NULL_TO_NIL([response valueForKey:@"post_id"]);
                        clockInFeed.postTime = clockinTime;
                        clockInFeed.postThumbnailURL = NULL_TO_NIL([response valueForKey:@"clock_in_image"]);
                        clockInFeed.postTitle = [NSString stringWithFormat:@"Clock in on : %@",clockinTime];
                        clockInFeed.postActualTime = clockinTime;
                        clockInFeed.postDesc = @"";
                        clockInFeed.postType = @"5";
                        clockInFeed.postVideoURL = NULL_TO_NIL([response valueForKey:@"clock_in_url"]);
                        clockInFeed.latitude = [NULL_TO_NIL([response valueForKey:@"clock_in_latitude"]) floatValue];
                        clockInFeed.longitude = [NULL_TO_NIL([response valueForKey:@"clock_in_longitude"]) floatValue];
                        clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                        
                        [self.arrFeedList insertObject:clockInFeed atIndex:0];
                        
                        isClockInFeedAdded = !isClockInFeedAdded;
                    }
                }
                
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
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
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
                        //feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        
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
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                
                [tblLeftFeedView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                    
                    
                    
                    
                    sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                    
                    
                    NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                    
                   
                    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                        
                    }
                    else
                    {
                        if(clockinTime && !isClockInFeedAdded)
                        {
                            recordCount = recordCount+1;

                            Feeds *clockInFeed = [[Feeds alloc] init];
                            clockInFeed.postUserEmail = sharedAppDelegate.userObj.default_email;
                            
                            clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                            clockInFeed.postUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
                            clockInFeed.postUserImgURL = sharedAppDelegate.userObj.image;
                            //                        clockInFeed.postId = @"-1";//Dharmbir
                            clockInFeed.postId = @"-1";
                            clockInFeed.postTime = clockinTime;
                            clockInFeed.postThumbnailURL = NULL_TO_NIL([response valueForKey:@"clock_in_image"]);
                            clockInFeed.postTitle = [NSString stringWithFormat:@"Clock in on : %@",clockinTime];
                            clockInFeed.postActualTime = clockinTime;
                            clockInFeed.postDesc = nil;
                            clockInFeed.postType = @"5";
                            clockInFeed.postVideoURL = NULL_TO_NIL([response valueForKey:@"clock_in_url"]);
                            clockInFeed.latitude = [NULL_TO_NIL([response valueForKey:@"clock_in_latitude"]) floatValue];
                            clockInFeed.longitude = [NULL_TO_NIL([response valueForKey:@"clock_in_longitude"]) floatValue];
                            
                            
                            clockInFeed.employeeStatusStr   = NULL_TO_NIL([response valueForKey:@"employee"]);
                            clockInFeed.managerStatusStr    = NULL_TO_NIL([response valueForKey:@"manager"]);
                            clockInFeed.teamLeaderStatusStr = NULL_TO_NIL([response valueForKey:@"teamleader"]);
                            clockInFeed.familyStatusStr     = NULL_TO_NIL([response valueForKey:@"family"]);
                            // clockInFeed.trainingStatusStr   = NULL_TO_NIL([response valueForKey:@"training"]);
                            clockInFeed.bsStatusStr         = NULL_TO_NIL([response valueForKey:@"BS"]);
                            
                            NSLog(@"Employee %@",clockInFeed.employeeStatusStr);
                            
                            NSLog(@"Employee %@",clockInFeed.managerStatusStr);
                            
                            
                            clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                            
                            [self.arrFeedList insertObject:clockInFeed atIndex:0];
                            
                            isClockInFeedAdded = !isClockInFeedAdded;
                        }
                        
                    }
                }
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                
                [tblLeftFeedView reloadData];
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
-(void)SortTagStatusDateWiseInvocationDidFinish:(SortTagStatusDateWiseInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            NSString* imgURL = NULL_TO_NIL([response valueForKey:@"tagImage"]);
            
            totalNumber = [NULL_TO_NIL([response valueForKey:@"totalNumber"]) integerValue];
            
            lblNumber.text=[NSString stringWithFormat:@"Number: %lu",totalNumber];
            [lblNumber setHidden:FALSE];
            
            if([imgURL length] > 0)
                [tagImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]] placeholderImage:[UIImage imageNamed:@"imageNoAvailable"]];
            
            NSLog(@"Imaeg URL %@",[NSString stringWithFormat:@"%@%@",tagThumbImageURL,imgURL]);
            
            //self.tagTitleLbl.text = self.selectedTag.tagTitle;
            self.tagTitleLbl.text = sharedAppDelegate.strSelectedTag;
            
            
            [self.tenHashTagArr removeAllObjects];
            
            self.tenHashTagArr = NULL_TO_NIL([[response valueForKey:@"topHasTag"] mutableCopy]);
            
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                if (!isTwentyHoursUpdate)// timer will not start for 24 hours update
                {
                    [clockInView startTimer];
                }
                
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
                    
                    /*if (sharedAppDelegate.isRecording==FALSE) {
                     
                     if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     
                     if ([sharedAppDelegate.userObj.recordingStatus isEqualToString:@"1"]) {
                     
                     [sharedAppDelegate checkTimeIntervalTimer];
                     }
                     }
                     
                     
                     }*/
                    
                    
                }
                else
                {
                    descriptionTxtView.text = @"";
                    
                    /*if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                     
                     [sharedAppDelegate invalidateRecordingTimers];
                     
                     }*/
                }
                
                
                NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
             
                if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                    
                }
                else
                {
                    if(clockinTime && !isClockInFeedAdded)
                    {
                        recordCount = recordCount+1;

                        Feeds *clockInFeed = [[Feeds alloc] init];
                        clockInFeed.postUserEmail = sharedAppDelegate.userObj.default_email;
                        
                        clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                        clockInFeed.postUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
                        clockInFeed.postUserImgURL = sharedAppDelegate.userObj.image;
                        clockInFeed.postId = @"-1";//Dharmbir
                        //                    clockInFeed.postId = NULL_TO_NIL([response valueForKey:@"post_id"]);
                        clockInFeed.postTime = clockinTime;
                        clockInFeed.postThumbnailURL = NULL_TO_NIL([response valueForKey:@"clock_in_image"]);
                        clockInFeed.postTitle = [NSString stringWithFormat:@"Clock in on : %@",clockinTime];
                        clockInFeed.postActualTime = clockinTime;
                        clockInFeed.postDesc = @"";
                        clockInFeed.postType = @"5";
                        clockInFeed.postVideoURL = NULL_TO_NIL([response valueForKey:@"clock_in_url"]);
                        clockInFeed.latitude = [NULL_TO_NIL([response valueForKey:@"clock_in_latitude"]) floatValue];
                        clockInFeed.longitude = [NULL_TO_NIL([response valueForKey:@"clock_in_longitude"]) floatValue];
                        clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                        
                        [self.arrFeedList insertObject:clockInFeed atIndex:0];
                        
                        isClockInFeedAdded = !isClockInFeedAdded;
                    }
                    
                }
                
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
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
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
                        // feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        
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
                        
                        [self.arrFeedList addObject:feed];
                        
                    }
                }
                else
                {
                    [self.arrFeedList removeAllObjects];
                    recordCount = 0;
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found"];
                }
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                [tblLeftFeedView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                    
                    
                    
                    
                    sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                    
                    
                    /* NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                     
                     if (clockinTime) {
                     recordCount = recordCount+1;
                     }
                     
                     if(clockinTime && !isClockInFeedAdded)
                     {
                     
                     Feeds *clockInFeed = [[Feeds alloc] init];
                     
                     clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                     clockInFeed.postUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
                     clockInFeed.postUserImgURL = sharedAppDelegate.userObj.image;
                     //                        clockInFeed.postId = @"-1";//Dharmbir
                     clockInFeed.postId = NULL_TO_NIL([response valueForKey:@"post_id"]);
                     clockInFeed.postTime = clockinTime;
                     clockInFeed.postThumbnailURL = NULL_TO_NIL([response valueForKey:@"clock_in_image"]);
                     clockInFeed.postTitle = [NSString stringWithFormat:@"Clock in on : %@",clockinTime];
                     clockInFeed.postActualTime = clockinTime;
                     clockInFeed.postDesc = nil;
                     clockInFeed.postType = @"5";
                     clockInFeed.postVideoURL = NULL_TO_NIL([response valueForKey:@"clock_in_url"]);
                     clockInFeed.latitude = [NULL_TO_NIL([response valueForKey:@"clock_in_latitude"]) floatValue];
                     clockInFeed.longitude = [NULL_TO_NIL([response valueForKey:@"clock_in_longitude"]) floatValue];
                     
                     
                     clockInFeed.employeeStatusStr   = NULL_TO_NIL([response valueForKey:@"employee"]);
                     clockInFeed.managerStatusStr    = NULL_TO_NIL([response valueForKey:@"manager"]);
                     clockInFeed.teamLeaderStatusStr = NULL_TO_NIL([response valueForKey:@"teamleader"]);
                     clockInFeed.familyStatusStr     = NULL_TO_NIL([response valueForKey:@"family"]);
                     clockInFeed.trainingStatusStr   = NULL_TO_NIL([response valueForKey:@"training"]);
                     clockInFeed.bsStatusStr         = NULL_TO_NIL([response valueForKey:@"BS"]);
                     
                     NSLog(@"Employee %@",clockInFeed.employeeStatusStr);
                     
                     NSLog(@"Employee %@",clockInFeed.managerStatusStr);
                     
                     
                     clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                     
                     [self.arrFeedList insertObject:clockInFeed atIndex:0];
                     
                     isClockInFeedAdded = !isClockInFeedAdded;
                     }*/
                }
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
                if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                    
                    [clockInSwitch setOn:YES];
                }
                else
                {
                    [clockInSwitch setOn:NO];
                    
                }
                
                [tblLeftFeedView reloadData];
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
#pragma mark- Keyword search Invocation

-(void)tagSearchInvocationDidFinish:(TagSearchInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [arrTaggedKeywords removeAllObjects];
    [DSBezelActivityView removeView];
    
    NSLog(@"tagSearchInvocationDidFinish %@",dict);
    @try {
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                NSArray* keyArray = [response valueForKey:@"keyword"];
                for (int i=0; i< [keyArray count]; i++) {
                    
                    NSDictionary* kDict = [keyArray objectAtIndex:i];
                    
                    Keywords* keyword = [[Keywords alloc] init];
                    
                    keyword.ide = NULL_TO_NIL([kDict valueForKey:@"id"]);
                    keyword.title = NULL_TO_NIL([kDict valueForKey:@"title"]);
                    keyword.count = NULL_TO_NIL([kDict valueForKey:@"totalPost"]);
                    
                    [arrTaggedKeywords addObject:keyword];
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
        leftSecondSegment.selectedSegmentIndex=0;
        checkHashSearch=TRUE;
        
        tblLeftFeedView.delegate=self;
        tblLeftFeedView.dataSource=self;
        
        [tblLeftFeedView reloadData];
    }
}
#pragma mark - Check Pin Invocation

-(void)checkPinInvocationDidFinish:(CheckPinInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error{
    
    NSLog(@"checkPinInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                if([ConfigManager isInternetAvailable])
                {
                    isClockInFeedAdded = FALSE;
                    [self.arrFeedList removeAllObjects];
                    
                    // ---------------- Enable when user is in range --------------
                   
                    
                    if (leftSecondSegment.selectedSegmentIndex==0) {
                        
                        [self requestGetTagFeeds:[NSNumber numberWithInt:1]];
                        
                    }
                    else if(leftSecondSegment.selectedSegmentIndex==1)
                    {
                        [self requestForTagEmailList];
                    }
                    
                    else if(leftSecondSegment.selectedSegmentIndex==2)
                    {
                        [self.arrNotificationList removeAllObjects];
                        [self requestForNotificationList];
                    }
                }
                
                else
                {
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [DSBezelActivityView removeView];
                
                [ConfigManager showAlertMessage:nil Message:@"Please enter correct pin"];
            }
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
        [DSBezelActivityView removeView];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


#pragma mark- Get Tag list Invocation

-(void)tagsInvocationDidFinish:(TagsInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        if(!error)
        {
            NSLog(@"Tags = %@",dict);
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                [self.arrTagsList removeAllObjects];
                NSString *strSuccess = [response valueForKey:@"success"];
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSArray *tags = NULL_TO_NIL([response valueForKey:@"Tag"]);
                    
                    for (int i = 0; i < [tags count]; i++) {
                        
                        NSDictionary *tDict = [tags objectAtIndex:i];
                        
                        Tags *tag = [[Tags alloc] init];
                        
                        tag.tagId = NULL_TO_NIL([tDict valueForKey:@"id"]);
                        tag.tagTitle = NULL_TO_NIL([tDict valueForKey:@"title"]);
                        
                        [self.arrTagsList addObject:tag];
                    }
                }
                else if([strSuccess rangeOfString:@"False"].length>0)
                {
                    [ConfigManager showAlertMessage:nil Message:@"You have not assigned any Tag"];
                }
                
                if ([self.arrTagsList count]>0) {
                    
                    [self showTagView];
                }
                
            }
            else
            {
                
            }//if response not nsdictionary
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
        
        
        sharedAppDelegate.unreadTagCount = 0;
        
    }
}

#pragma mark- Get Inbox list Invocation

-(void)InboxListInvocationDidFinish:(InboxListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    [self.arrInboxListing removeAllObjects];
    
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
                    
                    
                    
                    [self.arrInboxListing addObject:inbox];
                    
                }
            }
            tblLeftFeedView.delegate=self;
            tblLeftFeedView.dataSource=self;
            
            [tblLeftFeedView reloadData];
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

#pragma mark- Get Notification list Invocation

-(void)TagNotificationListInvocationDidFinish:(TagNotificationListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getNotificationInvocationDidFinish =%@",dict);
    @try {
        if(!error){
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = [response valueForKey:@"success"];
            recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];

            sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                NSArray* arrN = [response valueForKey:@"notification"];
                

                
                for (int i=0 ; i< [arrN count]; i++) {
                    
                    NSDictionary* nDict = [arrN objectAtIndex:i];
                    
                    NotificationD* nD = [[NotificationD alloc] init];
                    
                    nD.nid = NULL_TO_NIL([nDict valueForKey:@"id"]);
                    nD.ntext = NULL_TO_NIL([nDict valueForKey:@"message"]);
                    nD.isRead = [NULL_TO_NIL([nDict valueForKey:@"status"]) isEqualToString:@"read"]?TRUE:FALSE;
                    
                    NSString* strDate = NULL_TO_NIL([nDict valueForKey:@"created"]);
                    
                    NSDateFormatter* df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    NSDate* date = [df dateFromString:strDate];
                    
                    nD.createdTime = [ConfigManager shortStyleDate:date];
                    
                    [self.arrNotificationList addObject:nD];
                }
                sharedAppDelegate.unreadNotifications = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_UNREAD_NOTIFICATION_UPDATE object:nil];
            }
            else if ([strSuccess rangeOfString:@"false"].length>0){
                
            }
            
            tblLeftFeedView.delegate=self;
            tblLeftFeedView.dataSource=self;
            
            [tblLeftFeedView reloadData];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception=%@",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}

#pragma mark- delete notification Invocation

-(void)deleteNotificationDidFinish:(DeleteNotificationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"deleteContactInvocationDidFinish =%@",dict);
    @try {
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                [self.arrNotificationList removeObjectAtIndex:self.selectedIndxpath.row];
                
                [tblLeftFeedView reloadData];
                
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                [ConfigManager showAlertMessage:nil Message:@"Notification message not deleted"];
            }
            
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
#pragma mark- Delete All Notification

- (void)DeleteAllTagNotificationInvocationDidFinish:(DeleteAllTagNotificationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        if([strSuccess rangeOfString:@"true"].length>0){
            
            pageIndex=1;
            [self.arrNotificationList removeAllObjects];
            
            [tblLeftFeedView reloadData];
            
            [[[UIAlertView alloc] initWithTitle:@"Success" message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
}
#pragma mark- delete mail notification Invocation

-(void)DeleteMailInvocationDidFinish:(DeleteMailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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
                [self.arrInboxListing removeObjectAtIndex:self.selectedIndxpath.row];
            
            [tblLeftFeedView reloadData];
            
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


#pragma mark- Add Favorite Invocation

-(void)AddFavoriteInvocationDidFinish:(AddFavoriteInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            Feeds *feed=[self.arrFeedList objectAtIndex:self.selectedIndex];
            feed.postFavStatus=@"1";
            [tblLeftFeedView reloadData];
            
            //[self.arrFeedList removeAllObjects];
            //isClockInFeedAdded=FALSE;
            
           // pageIndex=1;
           // [self parseData];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
}

#pragma mark- Add Sad Smile Invocation

-(void)AddSadSmileInvocationDidFinish:(AddSadSmileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            
            Feeds *feed=[self.arrFeedList objectAtIndex:self.selectedIndex];
            
            if (checkSmile==TRUE) {
                
                feed.postStatus=@"1";
                
            }
            else
            {
                feed.postStatus=@"2";
                
            }
            [tblLeftFeedView reloadData];
            //[self.arrFeedList removeAllObjects];
            //isClockInFeedAdded=FALSE;
            
            //pageIndex=1;
            //[self parseData];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            //[self.arrFeedList removeAllObjects];
            //isClockInFeedAdded=FALSE;
            
            //pageIndex=1;
            //[self parseData];
            
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
}

#pragma mark- Add Smile Invocation

-(void)AddSmileInvocationDidFinish:(AddSmileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            
            Feeds *feed=[self.arrFeedList objectAtIndex:self.selectedIndex];
            
            if (checkSmile==TRUE) {
                
                feed.postStatus=@"1";
                
            }
            else
            {
                feed.postStatus=@"2";
                
            }
            [tblLeftFeedView reloadData];
            //[self.arrFeedList removeAllObjects];
           // isClockInFeedAdded=FALSE;
            
           // pageIndex=1;
           // [self parseData];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            //[self.arrFeedList removeAllObjects];
            //isClockInFeedAdded=FALSE;
            
           // pageIndex=1;
            //[self parseData];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
}
#pragma mark- UITextField

#pragma mark- Get Contact List

-(void)getAmityContactsListDidFinish:(GetAmityContactsList *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getAmityContactsListDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                NSArray* arr = NULL_TO_NIL([response valueForKey:@"contacts"]);
                
                for (int i= 0; i<[arr count]; i++) {
                    
                    NSDictionary* cDict =[arr objectAtIndex:i];
                    
                    ContactD* c = [[ContactD alloc] init];
                    
                    c.contact_id = NULL_TO_NIL([cDict valueForKey:@"contact_id"]);
                    c.request_status = NULL_TO_NIL([cDict valueForKey:@"request_status"]);
                    c.userName= NULL_TO_NIL([cDict valueForKey:@"username"]);
                    c.image = NULL_TO_NIL([cDict valueForKey:@"user_img"]);
                    c.isOnline = [NULL_TO_NIL([cDict valueForKey:@"online"]) boolValue];
                    c.userid = NULL_TO_NIL([cDict valueForKey:@"user_id"]);
                    c.status = NULL_TO_NIL([cDict valueForKey:@"request_status"]);
                    c.notificationStatus = NULL_TO_NIL([cDict valueForKey:@"notificationStatus"]);
                    
                    c.userName= [c.userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                    if (c.userName.length>0) {
                        
                        [self.contactEmailArr addObject:c];
                        
                    }
                    
                }
                
                [self showContactList];
                
            }
            else if ([strSuccess rangeOfString:@"false"].length>0){
                [ConfigManager showAlertMessage:nil Message:@"No Contacts found"];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EXception Contact =%@",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}

#pragma mark- Invocation

-(void)uploadDocInvocationDidFinish:(UploadDocInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"uploadDocInvocationDidFinish =%@",dict);
    
    @try {
        
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            
            NSString *strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                pdfNameStr = [response valueForKey:@"file"];
                
                [self requestSendChatText];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
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


#pragma mark- Send Message Invocation
-(void)sendMessageInvocationDidFinish:(SendMessageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"sendMessageInvocationDidFinish =%@",dict);
    @try {
        if(!error){
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:@"Data sent successfully"];
            }
            else if ([strSuccess rangeOfString:@"false"].length>0){
                [ConfigManager showAlertMessage:nil Message:@"Message not send"];
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


-(void)startDateSelected:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    if(txtStartDate.text.length >0){
        
        NSDate *endDt = [dateFormatter dateFromString:txtStartDate.text];
        if([date compare:endDt]==NSOrderedDescending){
            txtStartDate.text = @"";
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End date can't be greater than start date" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
    }
    
    txtStartDate.text = strDate;
}

-(void)endDateSelected:(NSDate*)date
{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *preDate = [dateFormatter dateFromString:txtEndDate.text];
    
   // NSLog(@"compare srestult =%ld",[preDate compare:date]);
    
    if ([preDate compare:date]==NSOrderedDescending) {
        txtEndDate.text = @"";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End date can't be greater than start date" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    txtEndDate.text = strDate;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:txtStartDate]){
        
        [self showStartDatePicker];
    }
    else if([textField isEqual:txtEndDate]){
        
        if(txtStartDate.text.length ==0){
            [ConfigManager showAlertMessage:nil Message:@"Please select start date first"];
            return FALSE;
        }
        
        [self showEndDatePicker];
    }
    else
    {
        return TRUE;
    }
    
    return false;
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
        
        [toolbar setFrame:CGRectMake(0.0, 220.0+IPHONE_FIVE_FACTOR, 320.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,264+IPHONE_FIVE_FACTOR,320, 216);
        [txtStartDate resignFirstResponder];
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 220.0, 320.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,264,320, 216);
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
        
        [toolbar setFrame:CGRectMake(0.0, 220.0+IPHONE_FIVE_FACTOR, 320.0, 44.0)];
        datePicker.frame=CGRectMake(0,264+IPHONE_FIVE_FACTOR,320, 216);
        [txtEndDate resignFirstResponder];
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 220.0, 320.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,264,320, 216);
        [txtEndDate resignFirstResponder];
    }
    
}
-(IBAction)cancel
{
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [txtStartDate resignFirstResponder];
    [txtEndDate resignFirstResponder];
    
}
-(IBAction)done
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    txtStartDate.text = [formatter stringFromDate:dateSelected];
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [txtEndDate resignFirstResponder];
    [txtStartDate resignFirstResponder];
}
-(IBAction)endDone
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    txtEndDate.text = [formatter stringFromDate:dateSelected];
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [txtEndDate resignFirstResponder];
    [txtStartDate resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==txtEndDate || textField==txtSearch || textField==txtStartDate) {
        
    }
    else
    {
        NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (resultStr.length > 4)
        {
            return NO;
        }
        
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        if (textField==txtSearch) {
            
            
            
            txtSearch.text= [txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (btnFirstSearch.tag==0) {
                
                if (txtSearch.text.length>0) {
                    
                    if([ConfigManager isInternetAvailable]){
                        
                        isNormalSearch=YES;
                        isTopHashTag=NO;
                        
                        tblLeftFeedView.delegate=nil;
                        tblLeftFeedView.dataSource=nil;
                        
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:txtSearch.text forKey:@"keyword"];
                        [dic setObject:sharedAppDelegate.selectedTag.tagId forKey:@"tag_id"];
                        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                        [dic setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
                        [dic setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
                        
                        [DSBezelActivityView removeView];

                        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Searching for hash tags" width:250.0f];
                        [[AmityCareServices sharedService] tagSearchFeedsInvocation:dic delegate:self];
                    }
                    else{
                        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                    }
                    
                }
                
                else
                {
                    tblLeftFeedView.delegate=self;
                    tblLeftFeedView.dataSource=self;
                    
                    checkHashSearch=FALSE;
                    
                    [tblLeftFeedView reloadData];
                }
            }
            
            
        }
        
    }
    
    [txtSearch resignFirstResponder];
    
    return TRUE;
}
-(void)viewDidDisappear:(BOOL)animated{
    
    checkPN=@"NO";
    
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
