//
//  TagHomeViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 03/12/14.
//
//

#import "TagHomeViewController.h"
#import "Feeds.h"
#import "FeedListTableViewCell.h"
#import "ConfigManager.h"
#import "UIImageExtras.h"
#import "UserFeedCell.h"
#import "TopNavigationView.h"
#import "UpdateStatusView.h"
#import "ClockOutVC.h"
#import "UploadDocVC.h"
#import "Status.h"
#import "ProfileDetailVC.h"
#import "ZoomInOutView.h"
#import "DocZoomVC.h"
#import "UserLocationVC.h"
#import "ActionSheetPicker.h"
#import "PasswordView.h"
#import "SortFeedsVC.h"
#import "HMSideMenu.h"
#import "Keywords.h"
#import "Form.h"
#import "FormsField.h"
#import "FormListVC.h"
#import "UIImageView+WebCache.h"
#import "FormValues.h"
#import "UserFeedCell_iphone.h"
#import "UpdateStatusView_iphone.h"
#import "PasswordViewIphone.h"
#import "EditTagIntroViewController.h"
#import "InboxListingViewController.h"
#import "InboxData.h"
#import "NSString+urlDecode.h"
#import "Task.h"
#import "TagCell.h"
#import "ClockInView.h"
#import "UserHomeViewController.h"
#import "TaskCalenderViewController.h"
#import "InboxData.h"
#import "NotificationCell.h"
#import "NotificationD.h"
#import <QuartzCore/QuartzCore.h>
#import "FormListViewController.h"
#import "SadSmileViewController.h"
#import "SmileViewController.h"
#import "FavoriteViewController.h"
#import "SettingViewController.h"
#import "FeedDetailViewController.h"
#import "AddNewTaskVC.h"
#import "TagStatusListInvocation.h"
#import "FormFeedDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "InboxDetailViewController.h"
#import "ChatDetailVC.h"
#import "ReimbursementsViewController.h"
#import "FormButtonViewController.h"
#import "SchedulButtonViewController.h"
#import "AllPeopleViewController.h"
#import "AllTagsViewController.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "AddScheduleViewController.h"
#import "AllHappyFacePostViewController.h"
#import "AllSadFacePostViewController.h"

#import "ManagerAssignedTagViewController.h"
#import "ManagerReimbursementViewController.h"
#import "UserCompletedFormViewController.h"
#import "CompletedTagFormViewController.h"
#import "UpdateSharePostViewController.h"
#import "DeletePostViewController.h"
#import "UploadDropBoxFileViewController.h"
#import "MadFormViewController.h"
#import "EditMadFormViewController.h"
#import "BackPackViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "FormFolderListViewController.h"
#import "RouteFeedDetailViewController.h"
#import "RecieptFeedDetailViewController.h"

@interface TagHomeViewController ()

@end

@implementation TagHomeViewController

@synthesize arrFeedList,tagImgView,tagTitleLbl,descriptionTxtView,arrTagsList,arrInboxListing,arrStatusList,arrNotificationList,selectedIndxpath,tagLblDate,tenHashTagArr,lblTitle,arrTaggedKeywords,contactEmailArr,strHashTag,selectedIndex;

@synthesize objUserCompletedFormViewController,objUploadDropBoxFileViewController,objUploadDocVC,objUpdateStatusView,objUpdateSharePostViewController,objSmileViewController,objSettingViewController,objSchedulButtonViewController,objSadSmileViewController,objReimbursementsViewController,objManagerAssignedTagViewController,objMadFormViewController,objFormListViewController,objFormButtonViewController,objFavoriteViewController,objDeletePostViewController,objCompletedTagFormViewController,objChatDetailVC,objAllTagsViewController,objAllSadFacePostViewController,objAllPeopleViewController,objAllHappyFacePostViewController,objAddNewTaskVC,objAddScheduleViewController,objBackPackViewCOntroller,objEditMadFormViewController,objEditTagIntroViewController,objTaskCalenderView,locationVC,popoverView,popoverContent,popoverController,clockOutPopoverController,leftView,rightInnerView,rightView,objFeedDetailViewController,objFormFeedDetailViewController,objFormFolderListViewController,objInboxDetailViewController,objStatusFeedDetailViewController,objRouteFeedDetailViewController,objRecieptFeedDetailViewController,objManagerReimbursementViewController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    sharedAppDelegate.calendarVisibleStatus=@"1";
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"]) {
        
        
        sharedAppDelegate.strSelectedTagId=nil;
    }
    else
    {
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

    }
    
    
    checkClockOutPopoverView=FALSE;
    
    [btnChatCount setHidden:TRUE];
    [btnSpecialChatCount setHidden:TRUE];
    [btnGroupChatCount setHidden:TRUE];
    [btnTagNotificationCount setHidden:TRUE];
    
    sharedAppDelegate.unreadGroupChatCount=0;
    sharedAppDelegate.unreadSpecialGroupChatCount=0;
    sharedAppDelegate.unreadNotifications=0;
    
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"HH:mm:ss"];
    [dateformater setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDate *tempStartDate = [dateformater dateFromString:@"18:43:08"];
    
    NSLog(@"tempStartDate is %@",[dateformater stringFromDate:tempStartDate]);
    
    
    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    checkHashSearch=FALSE;
    [btnClearAll setHidden:TRUE];
    [btnShare setHidden:TRUE];
    [btnMesssage setHidden:TRUE];
    [btnSpecialMesssage setHidden:TRUE];
    
    [self.leftView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"left_bg"]]];
    
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
    
    tblLeftFeedView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,
                                [UIColor colorWithRed:0.27843137 green:0.69411764 blue:0.92156862 alpha:1.0], NSForegroundColorAttributeName, nil];
    
    [leftMainSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [leftSecondSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    

    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
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
    
    // [leftMainSegment setTitle:sharedAppDelegate.userObj.username forSegmentAtIndex:0];
    
    [rightMainSegment setBackgroundImage:[UIImage imageNamed:@"2_active"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    if(sharedAppDelegate.userObj.isEmployee)
        descriptionTxtView.userInteractionEnabled = NO;
    else
        descriptionTxtView.userInteractionEnabled = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isKeywordSearched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.selectedTag=sharedAppDelegate.selectedTag;
    
    NSLog(@"%@",sharedAppDelegate.strSelectedTagId);
    
    if([ConfigManager isInternetAvailable])
    {
        if (sharedAppDelegate.strSelectedTagId==nil || sharedAppDelegate.strSelectedTagId==(NSString*)[NSNull null] || [sharedAppDelegate.strSelectedTagId isEqualToString:@""]) {
            
            [self reqeustForTagList];
            
        }
        else
        {
            checkCaledarLoad=TRUE;

            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
            
        }    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForNotificationList) name:AC_UPDATE_NOTIFICATION_TABLE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusFromNotification:) name:AC_UPDATE_STATUS_LIST object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFeedFromNotification:) name:AC_UPDATE_TAG_LIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTagNotification:) name:AC_USER_UNREAD_NOTIFICATION_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tagIntroUpdated) name:AC_TAG_INTRO_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clockoutFromNotification) name:AC_UPDATE_NOTIFICATION_CLOCKOUT object:nil];

    
    
    sharedAppDelegate.strCheckUserAndTag=@"Tag";
    
    // [SupervisiorRightMainSegment setHidden:TRUE];
    
    NSLog(@"%@",sharedAppDelegate.userObj.role);
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]) {
        
        CGRect f = self.rightInnerView.frame;
        f.origin.x = 0; // new x
        f.origin.y = 172; // new y
        f.size.height=852;
        
        self.rightInnerView.frame = f;
        
        [rightMainSegment setHidden:FALSE];
        [FamilyTopRightMainSegment setHidden:TRUE];
        [SupervisiorRightMainSegment setHidden:FALSE];
        [FamilyRightMainSegment setHidden:TRUE];
        [ManagerRightMainSegment setHidden:FALSE];
        
    }
    else if ([sharedAppDelegate.userObj.role isEqualToString:@"5"])
    {
        CGRect f = self.rightInnerView.frame;
        f.origin.x = 0; // new x
        f.origin.y = 138; // new y
        f.size.height=866;
        
        self.rightInnerView.frame = f;
        
        [rightMainSegment setHidden:FALSE];
        [FamilyTopRightMainSegment setHidden:TRUE];
        
        [SupervisiorRightMainSegment setHidden:FALSE];
        [FamilyRightMainSegment setHidden:TRUE];
        [ManagerRightMainSegment setHidden:TRUE];
        
    }
    else
    {
        CGRect f = self.rightInnerView.frame;
        f.origin.x = 0; // new x
        f.origin.y = 102; // new y
        f.size.height=929;
        self.rightInnerView.frame = f;
        
        [rightMainSegment setHidden:FALSE];
        [FamilyTopRightMainSegment setHidden:TRUE];
        
        
        [SupervisiorRightMainSegment setHidden:TRUE];
        [FamilyRightMainSegment setHidden:TRUE];
        [ManagerRightMainSegment setHidden:TRUE];
        
        
    }
    [backTagView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_list_bg.png"]]];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        [lblClockIn setHidden:TRUE];
        [lblClockOut setHidden:TRUE];
        [clockInSwitch setHidden:TRUE];
        [imgSwitch setHidden:TRUE];
        [btnShare setHidden:TRUE];
        
        [rightMainSegment setHidden:TRUE];
        [FamilyTopRightMainSegment setHidden:FALSE];
        
        [btnChatCount setFrame:CGRectMake(390,39,btnChatCount.frame.size.width,btnChatCount.frame.size.height )];
        
        [backTagView setFrame:CGRectMake(backTagView.frame.origin.x, 222-60, backTagView.frame.size.width, 60)];
        
        [btnMesssage setFrame:CGRectMake(btnMesssage.frame.origin.x, btnMesssage.frame.origin.y-40, btnMesssage.frame.size.width, btnMesssage.frame.size.height)];
        
        
        [btnGroupChatCount setFrame:CGRectMake(btnGroupChatCount.frame.origin.x, btnGroupChatCount.frame.origin.y-40, btnGroupChatCount.frame.size.width, btnGroupChatCount.frame.size.height)];
        
        [btnClearAll setFrame:CGRectMake(btnClearAll.frame.origin.x, btnClearAll.frame.origin.y+17, btnClearAll.frame.size.width, btnClearAll.frame.size.height)];

        
        [tblLeftFeedView setFrame:CGRectMake(tblLeftFeedView.frame.origin.x, 331-90, tblLeftFeedView.frame.size.width, tblLeftFeedView.frame.size.height+40)];
        
        
        
    }
    else
    {
        [lblClockIn setHidden:FALSE];
        [lblClockOut setHidden:FALSE];
        [clockInSwitch setHidden:FALSE];
        [imgSwitch setHidden:FALSE];
        [btnShare setHidden:FALSE];
        
        [rightMainSegment setHidden:FALSE];
        [FamilyTopRightMainSegment setHidden:TRUE];
        
        [btnChatCount setFrame:CGRectMake(358,52,btnChatCount.frame.size.width,btnChatCount.frame.size.height )];
        
        [backTagView setFrame:CGRectMake(backTagView.frame.origin.x, 194, backTagView.frame.size.width, backTagView.frame.size.height)];
        
        [btnMesssage setFrame:CGRectMake(btnMesssage.frame.origin.x, btnMesssage.frame.origin.y, btnMesssage.frame.size.width, btnMesssage.frame.size.height)];
        
        [btnGroupChatCount setFrame:CGRectMake(btnGroupChatCount.frame.origin.x, btnGroupChatCount.frame.origin.y, btnGroupChatCount.frame.size.width, btnGroupChatCount.frame.size.height)];
        
        
        [tblLeftFeedView setFrame:CGRectMake(tblLeftFeedView.frame.origin.x, 331, tblLeftFeedView.frame.size.width, tblLeftFeedView.frame.size.height)];
        
        
    }
    
    
    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMadForms) name: AC_MADFORM_CREATED_UPDATES object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeValue:) name: AC_USER_UNREAD_BADGE_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusList) name: AC_STATUS_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePostList) name: AC_POST_UPDATE object:nil];
    
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null]|| [self.selectedTag.tagId isEqualToString:@""]) {
            
            [rightMainSegment setEnabled:NO forSegmentAtIndex:3];
            [rightMainSegment setEnabled:NO forSegmentAtIndex:4];
        }
        else
        {
            [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
        }
       
    }
    

}
-(void)clockoutFromNotification
{
    if ([checkPN isEqualToString:@"YES"]) {

        pageIndex=1;
        [self.arrFeedList removeAllObjects];
        
        [tblLeftFeedView reloadData];
        checkCaledarLoad=TRUE;

        [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
        
        rightMainSegment.selectedSegmentIndex=0;
        leftSecondSegment.selectedSegmentIndex=0;
        
       // [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];


    }
}
-(void)updateStatusList
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        isClockInFeedAdded = FALSE;
        [self.arrFeedList removeAllObjects];
        
        [btnClearAll setHidden:TRUE];
        
        pageIndex=1;
        leftSecondSegment.selectedSegmentIndex=0;
        
        [self requestForTagStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
        
    }
    
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
-(void)updateMadForms
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSLog(@"00000000");
        
        [self.popoverController dismissPopoverAnimated:YES];
        
        self.objEditMadFormViewController=nil;
        
        NSLog(@"11111111");
        
        self.objEditMadFormViewController=[[EditMadFormViewController alloc] initWithNibName:@"EditMadFormViewController" bundle:nil];
        
        self.objEditMadFormViewController.preferredContentSize = CGSizeMake(768, 1024);
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objEditMadFormViewController];
        self.popoverController.delegate=self;
        self.popoverController.popoverContentSize= CGSizeMake(768, 1024);
        
        NSLog(@"22222222");
        
        [self.popoverController presentPopoverFromRect:CGRectMake(380, 0, 40, 40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        NSLog(@"333333333");
        
    }
    
    
}
-(void)tagIntroUpdated
{
    if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
        
        descriptionTxtView.text=sharedAppDelegate.strUpdatedTagIntro;
        
    }
    else
    {
        descriptionTxtView.text = @"";
        
    }
    
    [self.popoverController dismissPopoverAnimated:YES];
    [self.clockOutPopoverController dismissPopoverAnimated:YES];
}
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    checkPN=@"YES";
    
    clockInPress=TRUE;
    
    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    [tblLeftFeedView setBackgroundColor:[UIColor clearColor]];
    
}
-(void)updateTagNotification:(NSNotification*) note
{
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
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        if (nTagId==nil || nTagId==(NSString*)[NSNull null] || [nTagId isEqualToString:@""]) {
            
        }
        else
        {
            if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                
                if (leftSecondSegment.selectedSegmentIndex==0) {
                    
                    [self.arrFeedList removeAllObjects];
                    
                    pageIndex=1;
                    
                    [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
                    
                    
                }
            }
            
        }
    }
}
-(void)updateStatusFromNotification:(NSNotification*) note
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSDictionary* notification = (NSDictionary*)[note object];
        
        NSString* nTagId = [notification valueForKeyPath:@"aps.tagId"];
        
        if (nTagId==nil || nTagId==(NSString*)[NSNull null] || [nTagId isEqualToString:@""]) {
            
        }
        else
        {
            if ([nTagId isEqualToString:sharedAppDelegate.strSelectedTagId]) {
                
                if(leftSecondSegment.selectedSegmentIndex==0)
                {
                    [self.arrFeedList removeAllObjects];
                    pageIndex=1;
                    
                    [self requestForTagStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
                    
                }
                
            }
            
        }
    }
}
-(void)setBadgeValue:(NSNotification*) note
{
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
                
                else if ([nType isEqualToString:@"groupchat"]) {
                    
                    if (sharedAppDelegate.unreadGroupChatCount>0) {
                        
                        [btnChatCount setHidden:FALSE];
                        [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btnChatCount setHidden:TRUE];
                        
                    }
                    
                }
                
            }
        }
        
        
    }
    
}
#pragma mark Get webservice Mehtods--------

-(void)requestGetTagFeeds:(NSNumber*)index
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
        
        NSString* strIndex = [NSString stringWithFormat:@"%d",[index intValue]];
        
        NSLog(@"user Id %@",sharedAppDelegate.userObj.role_id);
        NSLog(@"User update notification received");
        
        [[AmityCareServices sharedService] getTagFeedsInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"one" delegate:self];
        
        /* if (sharedAppDelegate.checkClockIn==FALSE)
         {
         [clockInSwitch setOn:FALSE];
         
         [[AmityCareServices sharedService] getTagFeedsInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"one" delegate:self];
         
         }
         else
         {
         [clockInSwitch setOn:TRUE];
         
         [[AmityCareServices sharedService] getTagFeedsInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"all" delegate:self];
         } */
        
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    
}
-(void)requestForTagSearchFeeds:(NSMutableDictionary*)dict
{
    if([ConfigManager isInternetAvailable]) {
        
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
        
        [self.arrNotificationList removeAllObjects];
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
            
            pageIndex=1;
            
            NSString *pageIndexStr=[NSString stringWithFormat:@"%lu",pageIndex];
            
            [[AmityCareServices sharedService] TagNotificationListInvocation:sharedAppDelegate.userObj.userId tagId:self.selectedTag.tagId page_index:pageIndexStr  delegate:self];
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }
    
    
    
}

#pragma mark add views --------

-(void)removeView
{
    [self.objTaskCalenderView.view removeFromSuperview];
    [self.objUploadDocVC.view removeFromSuperview];
    [self.objFormListViewController.view removeFromSuperview];
    [self.objFavoriteViewController.view removeFromSuperview];
    [self.objSettingViewController.view removeFromSuperview];
    [self.objSadSmileViewController.view removeFromSuperview];
    [self.objUploadDocVC.view removeFromSuperview];
    [self.objUpdateStatusView setHidden:TRUE];
    [self.objSmileViewController.view removeFromSuperview];
    [self.objAddNewTaskVC.view removeFromSuperview];
    [self.objChatDetailVC.view removeFromSuperview];
    [self.objReimbursementsViewController.view removeFromSuperview];
    [self.objFormButtonViewController.view removeFromSuperview];
    [self.objAllPeopleViewController.view removeFromSuperview];
    [self.objAllTagsViewController.view removeFromSuperview];
    [self.objSchedulButtonViewController.view removeFromSuperview];
    [self.objAllHappyFacePostViewController.view removeFromSuperview];
    [self.objAllSadFacePostViewController.view removeFromSuperview];
    [self.objMadFormViewController.view removeFromSuperview];
    
    [self.objManagerAssignedTagViewController.view removeFromSuperview];
    [self.objManagerReimbursementViewController.view removeFromSuperview];
    [self.objUserCompletedFormViewController.view removeFromSuperview];
    [self.objCompletedTagFormViewController.view removeFromSuperview];
    [self.objUpdateSharePostViewController.view removeFromSuperview];
    [self.objDeletePostViewController.view removeFromSuperview];
    [self.objUploadDropBoxFileViewController.view removeFromSuperview];
    [self.objBackPackViewCOntroller.view removeFromSuperview];
    [self.objAddScheduleViewController.view removeFromSuperview];
    [sharedAppDelegate.acContactsVC.view removeFromSuperview];

}


-(void)showCalenderView
{
    [self.objTaskCalenderView.view removeFromSuperview];
    self.objTaskCalenderView=[[TaskCalenderViewController alloc] initWithNibName:@"TaskCalenderViewController" bundle:nil];
    self.objTaskCalenderView.tagId=self.selectedTag.tagId;
    [self.rightInnerView addSubview:self.objTaskCalenderView.view];
    
}
-(void)showSadSmileView
{
    [self.objSadSmileViewController.view removeFromSuperview];
    self.objSadSmileViewController=[[SadSmileViewController alloc] initWithNibName:@"SadSmileViewController" bundle:nil];
    self.objSadSmileViewController.tagId=self.selectedTag.tagId;
    [self.rightInnerView addSubview:self.objSadSmileViewController.view];
}
-(void)showSmileView
{
    [self.objSmileViewController.view removeFromSuperview];
    self.objSmileViewController=[[SmileViewController alloc] initWithNibName:@"SmileViewController" bundle:nil];
    self.objSmileViewController.tagId=self.selectedTag.tagId;
    [self.rightInnerView addSubview:self.objSmileViewController.view];
    
}
-(void)showFavoriteView
{
    [self.objFavoriteViewController.view removeFromSuperview];
    self.objFavoriteViewController=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
    self.objFavoriteViewController.tagId=self.selectedTag.tagId;
    [self.rightInnerView addSubview:self.objFavoriteViewController.view];
    
}
-(void)showSettingView
{
    [self.objSettingViewController.view removeFromSuperview];
    self.objSettingViewController=[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objSettingViewController.view];
    
}
-(void)showFormListView
{
    [self.objFormListViewController.view removeFromSuperview];
    self.objFormListViewController=[[FormListViewController alloc] initWithNibName:@"FormListViewController" bundle:nil];
    self.objFormListViewController.tagId=self.selectedTag.tagId;
    [self.rightInnerView addSubview:self.objFormListViewController.view];
    
//    [self.objFormFolderListViewController.view removeFromSuperview];
//    self.objFormFolderListViewController=[[FormFolderListViewController alloc] initWithNibName:@"FormFolderListViewController" bundle:nil];
//    self.objFormFolderListViewController.tagId=self.selectedTag.tagId;
//    [self.rightInnerView addSubview:self.objFormFolderListViewController.view];
    
}
-(void)showUpdateStatusView
{
    [self.objUpdateStatusView removeFromSuperview];
    
    [self.objUpdateStatusView setHidden:FALSE];
    
    self.objUpdateStatusView =[[UpdateStatusView alloc] initWithStatusArray:nil withDelegate:self];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.objUpdateStatusView setFrame:CGRectMake(self.objUpdateStatusView.frame.origin.x, self.objUpdateStatusView.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.objUpdateStatusView setFrame:CGRectMake(self.objUpdateStatusView.frame.origin.x, self.objUpdateStatusView.frame.origin.y, 675, 670)];
            
        }
    }
    
    
    [self.rightInnerView addSubview:self.objUpdateStatusView];
    
}
-(void)showUploadView
{
    [self.objUploadDocVC.view removeFromSuperview];
    self.objUploadDocVC=[[UploadDocVC alloc] initWithNibName:@"UploadDocVC" bundle:nil];
    [self.rightInnerView addSubview:self.objUploadDocVC.view];
    
}
-(void)showReimbursementsView
{
    [self.objReimbursementsViewController.view removeFromSuperview];
    self.objReimbursementsViewController=[[ReimbursementsViewController alloc] initWithNibName:@"ReimbursementsViewController" bundle:nil];
    self.objReimbursementsViewController.tagId=self.selectedTag.tagId;
    
    if (clockInSwitch.isOn) {
        
        self.objReimbursementsViewController.checkClockin=@"1";
    }
    else
    {
        self.objReimbursementsViewController.checkClockin=@"0";
        
    }
    
    
    [self.rightInnerView addSubview:self.objReimbursementsViewController.view];
    
}
-(void)showFormButtonView
{
    [self.objFormButtonViewController.view removeFromSuperview];
    self.objFormButtonViewController=[[FormButtonViewController alloc] initWithNibName:@"FormButtonViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objFormButtonViewController.view];
    
}
-(void)showAllTagsView
{
    [self.objAllTagsViewController.view removeFromSuperview];
    self.objAllTagsViewController=[[AllTagsViewController alloc] initWithNibName:@"AllTagsViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objAllTagsViewController.view];
    
}
-(void)showScheduleButtonView
{
    [self.objSchedulButtonViewController.view removeFromSuperview];
    self.objSchedulButtonViewController=[[SchedulButtonViewController alloc] initWithNibName:@"SchedulButtonViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objSchedulButtonViewController.view];
    
}
-(void)showAllPeopleView
{
    [self.objAllPeopleViewController.view removeFromSuperview];
    self.objAllPeopleViewController=[[AllPeopleViewController alloc] initWithNibName:@"AllPeopleViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objAllPeopleViewController.view];
    
}
-(void)showAllHappyFacePostView
{
    [self.objAllHappyFacePostViewController.view removeFromSuperview];
    self.objAllHappyFacePostViewController=[[AllHappyFacePostViewController alloc] initWithNibName:@"AllHappyFacePostViewController" bundle:nil];
    self.objAllHappyFacePostViewController.tagId=self.selectedTag.tagId;
    [self.rightInnerView addSubview:self.objAllHappyFacePostViewController.view];
    
}
-(void)showAllSadFacePostView
{
    [self.objAllSadFacePostViewController.view removeFromSuperview];
    self.objAllSadFacePostViewController=[[AllSadFacePostViewController alloc] initWithNibName:@"AllSadFacePostViewController" bundle:nil];
    self.objAllSadFacePostViewController.tagId=self.selectedTag.tagId;
    
    [self.rightInnerView addSubview:self.objAllSadFacePostViewController.view];
    
}




-(void)showManagerReimbursementView
{
    [self.objManagerReimbursementViewController.view removeFromSuperview];
    self.objManagerReimbursementViewController=[[ManagerReimbursementViewController alloc] initWithNibName:@"ManagerReimbursementViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objManagerReimbursementViewController.view];
    
}
-(void)showUserFormListView
{
    [self.objUserCompletedFormViewController.view removeFromSuperview];
    self.objUserCompletedFormViewController=[[UserCompletedFormViewController alloc] initWithNibName:@"UserCompletedFormViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objUserCompletedFormViewController.view];
    
}
-(void)showTagFormListView
{
    [self.objCompletedTagFormViewController.view removeFromSuperview];
    self.objCompletedTagFormViewController=[[CompletedTagFormViewController alloc] initWithNibName:@"CompletedTagFormViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objCompletedTagFormViewController.view];
    
}
-(void)showAllPostToShareView
{
    [self.objUpdateSharePostViewController.view removeFromSuperview];
    self.objUpdateSharePostViewController=[[UpdateSharePostViewController alloc] initWithNibName:@"UpdateSharePostViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objUpdateSharePostViewController.view];
    
}
-(void)showAllDeletePostView
{
    [self.objDeletePostViewController.view removeFromSuperview];
    self.objDeletePostViewController=[[DeletePostViewController alloc] initWithNibName:@"DeletePostViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objDeletePostViewController.view];
    
}
-(void)showUploadManagerDocView
{
    [self.objUploadDropBoxFileViewController.view removeFromSuperview];
    self.objUploadDropBoxFileViewController=[[UploadDropBoxFileViewController alloc] initWithNibName:@"UploadDropBoxFileViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objUploadDropBoxFileViewController.view];
    
}
-(void)showMadFormView
{
    [self.objMadFormViewController.view removeFromSuperview];
    self.objMadFormViewController=[[MadFormViewController alloc] initWithNibName:@"MadFormViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objMadFormViewController.view];
    
}
-(void)showContactView
{
    [sharedAppDelegate.acContactsVC.view removeFromSuperview];
    
    sharedAppDelegate.unreadContactCount=0;
    
    [self.rightInnerView addSubview:sharedAppDelegate.acContactsVC.view];
}
#pragma mark Show Tag List on Popoverview--------

- (void)showTagView
{
    
    if (IS_DEVICE_IPAD) {
        
        self.popoverContent = [[UIViewController alloc]init];
        self.popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
        [self.popoverView setBackgroundColor:[UIColor clearColor]];
        tblViewTagList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 500) style:UITableViewStylePlain];
        [tblViewTagList setDataSource:self];
        [tblViewTagList setDelegate:self];
        [tblViewTagList setRowHeight:40];
        [tblViewTagList setBackgroundColor:[UIColor clearColor]];
        [self.popoverView addSubview:tblViewTagList];
        self.popoverContent.view = self.popoverView;
        self.popoverContent.preferredContentSize = CGSizeMake(300, 500);
        
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
        
        self.popoverController.popoverContentSize= CGSizeMake(300, 500);
        
        // [popover  presentPopoverFromRect:CGRectMake(50,20, 35, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        [self.popoverController  presentPopoverFromRect:btnTag.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        
    }
    
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
             
             if (self.strHashTag.length>0) {
             
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
             
             [popoverController dismissPopoverAnimated:YES];
             
             [self.arrFeedList removeAllObjects];
             
             [self.normalSearchDic removeAllObjects];
             
             pageIndex = 1;
             
             [self.normalSearchDic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
             [self.normalSearchDic setObject:self.selectedTag.tagId forKey:@"tag_id"];
             [self.normalSearchDic setObject:startDate forKey:@"start_date"];
             [self.normalSearchDic setObject:endDate forKey:@"end_date"];
             [self.normalSearchDic setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];                [self.normalSearchDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
             
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
        UserHomeViewController *objUserHomeViewController=[[UserHomeViewController alloc] initWithNibName:@"UserHomeViewController" bundle:nil];
        objUserHomeViewController.phoneCallDelegate=sharedAppDelegate.objUserHomeViewController.phoneCallDelegate;
        
        [self.navigationController pushViewController:objUserHomeViewController animated:NO];
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
        
        rightMainSegment.selectedSegmentIndex=0;
        leftSecondSegment.selectedSegmentIndex=0;
        [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        [btnClearAll setHidden:TRUE];
        
        [self.arrFeedList removeAllObjects];
        
        isClockInFeedAdded = FALSE;
        
        if (sharedAppDelegate.strSelectedTagId==nil || sharedAppDelegate.strSelectedTagId==(NSString*)[NSNull null] || [sharedAppDelegate.strSelectedTagId isEqualToString:@""]) {
            
            
        }
        else
        {
            checkCaledarLoad=TRUE;

            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
            //[self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];
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
    isClockInFeedAdded = FALSE;
    
    checkCaledarLoad=FALSE;
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    txtSearch.text=@"";
    self.strHashTag=@"";
    
    
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
            
            sharedAppDelegate.unreadTagCount=0;
            [btnTagNotificationCount setHidden:TRUE];
            
            
            [self.arrNotificationList removeAllObjects];
            [self requestForNotificationList];

        }
              
    }
    
}
-(IBAction)rightMainSegmentAction:(id)sender
{
    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    if (self.selectedTag==nil || self.selectedTag.tagId==(NSString*)[NSNull null]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        [self removeView];
        
        if (rightMainSegment.selectedSegmentIndex==0) {
            
            [btnAddTak setHidden:FALSE];
            
            [self showCalenderView];
            
            
        }
        else if (rightMainSegment.selectedSegmentIndex==1) {
            
            [btnAddTak setHidden:TRUE];
            
            
            [self showReimbursementsView];
            
            
        }
        else if (rightMainSegment.selectedSegmentIndex==2) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showFavoriteView];
                
            }
            else
            {

                    if (clockInSwitch.isOn) {
                        
                        [self showFavoriteView];
                        
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                
            }
            
            
        }
        else if (rightMainSegment.selectedSegmentIndex==3) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]|| [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                [self showSadSmileView];
                
            }
            else
            {
               
                if (clockInSwitch.isOn) {
                    
                    [self showSadSmileView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
        }
        else if (rightMainSegment.selectedSegmentIndex==4) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]|| [sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                [self showSmileView];
                
            }
            else
            {
                    if (clockInSwitch.isOn) {
                        
                        [self showSmileView];
                        
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }

                }
                
            
        }
        else if (rightMainSegment.selectedSegmentIndex==5) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showSettingView];
        }
        else if (rightMainSegment.selectedSegmentIndex==6) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showFormListView];
                
            }
            else
            {
                [self showFormListView];
                
            }
            
            
        }
        else if (rightMainSegment.selectedSegmentIndex==7) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showUpdateStatusView];
                
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self showUpdateStatusView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            
            
            
        }
        else if (rightMainSegment.selectedSegmentIndex==8) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showUploadView];
                
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self showUploadView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            
            
        }
        else if(rightMainSegment.selectedSegmentIndex==9)
        {
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self.objChatDetailVC.view removeFromSuperview];
                
                if (IS_DEVICE_IPAD) {
                    
                    self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
                }
                else
                {
                    self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
                }
                
                rightMainSegment.selectedSegmentIndex=9;
                self.objChatDetailVC.msgListSelected = FALSE;
                self.objChatDetailVC.backBtnVisibility=@"NO";
                sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
                sharedAppDelegate.checkSpecialGroupChat=@"0";
                
                
                sharedAppDelegate.unreadGroupChatCount=0;
                [btnChatCount setHidden:TRUE];
                
                [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                
                [self.rightInnerView addSubview:self.objChatDetailVC.view];
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self.objChatDetailVC.view removeFromSuperview];
                    
                    if (IS_DEVICE_IPAD) {
                        
                        self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
                    }
                    else
                    {
                        self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
                    }
                    
                    rightMainSegment.selectedSegmentIndex=9;
                    self.objChatDetailVC.msgListSelected = FALSE;
                    self.objChatDetailVC.backBtnVisibility=@"NO";
                    sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
                    sharedAppDelegate.checkSpecialGroupChat=@"0";
                    
                    sharedAppDelegate.unreadGroupChatCount=0;
                    sharedAppDelegate.unreadSpecialGroupChatCount=0;
                    
                    [btnChatCount setHidden:TRUE];
                    
                    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                    [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                    
                    [self.rightInnerView addSubview:self.objChatDetailVC.view];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
            
            
        }
        else if(rightMainSegment.selectedSegmentIndex==10)
        {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showMadFormView];
                
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self showMadFormView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            
            
        }
        else if(rightMainSegment.selectedSegmentIndex==11)
        {
            [self showContactView];

        }
        
        else
        {
            [self removeView];
            
        }
        
    }
    
    
}
-(IBAction)familyTopRightMainSegmentAction:(id)sender
{
    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    if (self.selectedTag==nil || self.selectedTag.tagId==(NSString*)[NSNull null]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        [self removeView];
        
        if (FamilyTopRightMainSegment.selectedSegmentIndex==0) {
            
            [btnAddTak setHidden:FALSE];
            
            //if (clockInSwitch.isOn) {
            
            [self showCalenderView];
            
            /*}
             else
             {
             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             }*/
            
        }
        else if (FamilyTopRightMainSegment.selectedSegmentIndex==1) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showSadSmileView];
                
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self showSadSmileView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            
        }
        else if (FamilyTopRightMainSegment.selectedSegmentIndex==2) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showSmileView];
                
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self showSmileView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
            
            
        }
        else if (FamilyTopRightMainSegment.selectedSegmentIndex==3) {
            
            [btnAddTak setHidden:TRUE];
            
            [self showSettingView];
        }
        else if (FamilyTopRightMainSegment.selectedSegmentIndex==4) {
            
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showUpdateStatusView];
                
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self showUpdateStatusView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            
        }
        else if (FamilyTopRightMainSegment.selectedSegmentIndex==5) {
            
            [btnAddTak setHidden:TRUE];
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self showUploadView];
                
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self showUploadView];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            
            
        }
        else if (FamilyTopRightMainSegment.selectedSegmentIndex==6) {
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self.objChatDetailVC.view removeFromSuperview];
                
                if (IS_DEVICE_IPAD) {
                    
                    self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
                }
                else
                {
                    self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
                }
                
                rightMainSegment.selectedSegmentIndex=9;
                self.objChatDetailVC.msgListSelected = FALSE;
                self.objChatDetailVC.backBtnVisibility=@"NO";
                sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
                sharedAppDelegate.checkSpecialGroupChat=@"0";
                
                
                sharedAppDelegate.unreadGroupChatCount=0;
                [btnChatCount setHidden:TRUE];
                
                [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                
                [self.rightInnerView addSubview:self.objChatDetailVC.view];
            }
            else
            {
                if (clockInSwitch.isOn) {
                    
                    [self.objChatDetailVC.view removeFromSuperview];
                    
                    if (IS_DEVICE_IPAD) {
                        
                        self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
                    }
                    else
                    {
                        self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
                    }
                    
                    rightMainSegment.selectedSegmentIndex=9;
                    self.objChatDetailVC.msgListSelected = FALSE;
                    self.objChatDetailVC.backBtnVisibility=@"NO";
                    sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
                    sharedAppDelegate.checkSpecialGroupChat=@"0";
                    
                    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                    [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                    
                    [self.rightInnerView addSubview:self.objChatDetailVC.view];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
            
        }
        else if(FamilyTopRightMainSegment.selectedSegmentIndex==7)
        {
            [self showFormListView];

        }
        else if(FamilyTopRightMainSegment.selectedSegmentIndex==8)
        {
            [self showContactList];
            
        }
        else
        {
            [self removeView];
            
        }
        
    }
    
}
-(IBAction)supervisiorRightMainSegmentAction:(id)sender
{
    [rightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [FamilyTopRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    
    [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    [self removeView];
    
    if (SupervisiorRightMainSegment.selectedSegmentIndex==0) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showAllTagsView];
    }
    else if(SupervisiorRightMainSegment.selectedSegmentIndex==1)
    {
        [btnAddTak setHidden:TRUE];
        
        [self showFormButtonView];
    }
    else if(SupervisiorRightMainSegment.selectedSegmentIndex==2)
    {
        [btnAddTak setHidden:FALSE];
        
        [self showScheduleButtonView];
    }
    else
    {
        [btnAddTak setHidden:TRUE];
        
        [self showAllPeopleView];
    }
}
-(IBAction)managerRightMainSegmentAction:(id)sender
{
    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [rightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [FamilyTopRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    [self removeView];
    
    if (ManagerRightMainSegment.selectedSegmentIndex==0) {
        
       // [self showManagerReimbursementView];
        
        [btnAddTak setHidden:TRUE];
        
        [self showUserFormListView];

    }
    else if(ManagerRightMainSegment.selectedSegmentIndex==1)
    {
        [btnAddTak setHidden:TRUE];

        [self showTagFormListView];

    }
    else if(ManagerRightMainSegment.selectedSegmentIndex==2)
    {
        [btnAddTak setHidden:TRUE];

        [self showAllDeletePostView];

    }
    else if(ManagerRightMainSegment.selectedSegmentIndex==3)
    {
        [btnAddTak setHidden:TRUE];

        [self showUploadView];

        //[self showAllPostToShareView];
    }
    else
    {
        [btnAddTak setHidden:TRUE];

        [self showManagerReimbursementView];
    }
   
}
-(IBAction)familyRightMainSegmentAction:(id)sender
{
    [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [rightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [FamilyTopRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    if (self.selectedTag==nil || self.selectedTag.tagId==(NSString*)[NSNull null]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        [self removeView];
        
        if (FamilyRightMainSegment.selectedSegmentIndex==0) {
            
            [self showAllHappyFacePostView];
        }
        else
        {
            [self showAllSadFacePostView];
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

                NSLog(@"switchSlider.isOn");
                
                if (clockInPress==TRUE) {
                    
                    clockInPress=FALSE;
                    
                    
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
                NSLog(@"not switchSlider.isOn");
                
                recordCount = 0;
                
                [clockInView stopTimer1];
                
                checkClockOutPopoverView=TRUE;
                moveToKeywordSearch = FALSE;
                [sharedAppDelegate startUpdatingLocation];
                ClockOutVC *clockOutVc;
                
                [clockInSwitch setOn:YES];

                
                if (IS_DEVICE_IPAD) {
                    
                    clockOutVc = [[ClockOutVC alloc ] initWithNibName:@"ClockOutVC" bundle:nil];
                }
                else
                {
                    clockOutVc = [[ClockOutVC alloc ] initWithNibName:@"ClockOutVC_iphone" bundle:nil];
                }
                
                clockOutVc.delegate=self;
                self.clockOutPopoverController = [[UIPopoverController alloc] initWithContentViewController:clockOutVc];
                
                self.clockOutPopoverController.popoverContentSize= CGSizeMake(418, 700);
                self.clockOutPopoverController.delegate=self;
                [self.clockOutPopoverController presentPopoverFromRect:btnTag.bounds inView:self.leftView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
        if (IS_DEVICE_IPAD) {
            
            self.popoverContent = [[UIViewController alloc]init];
            self.popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            
            hashTagTblView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];
            [hashTagTblView setDataSource:self];
            [hashTagTblView setDelegate:self];
            [hashTagTblView setRowHeight:40];
            [self.popoverView addSubview:hashTagTblView];
            self.popoverContent.view = self.popoverView;
            self.popoverContent.preferredContentSize = CGSizeMake(300, 300);
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
            self.popoverController.popoverContentSize= CGSizeMake(300, 300);
            
            [self.popoverController  presentPopoverFromRect:btnTopHashTag.frame inView:backTagView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        
    }
}
-(IBAction)editIntroAction:(id)sender
{
    
    if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null] || [self.selectedTag.tagId isEqualToString:@""]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        
        if (IS_DEVICE_IPAD) {
            
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                self.objEditTagIntroViewController=[[EditTagIntroViewController alloc] initWithNibName:@"EditTagIntroViewController" bundle:nil];
                
                self.objEditTagIntroViewController.tagId=self.selectedTag.tagId;
                self.objEditTagIntroViewController.intro=self.descriptionTxtView.text;
                
                self.objEditTagIntroViewController.preferredContentSize = CGSizeMake(350, 430);
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objEditTagIntroViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(350, 430);
                
                [self.popoverController presentPopoverFromRect:btnEditIntro.frame inView:backTagView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:@"Please clockin first"];
            }
        }
        
    }
    
}
-(IBAction)addTaskAction:(id)sender
{
    NSLog(@"%@",sharedAppDelegate.calenderCurrentDate);
    
    if (SupervisiorRightMainSegment.selectedSegmentIndex==2) {
        
        self.objAddScheduleViewController=[[AddScheduleViewController alloc] init];
        self.objAddScheduleViewController.sData=nil;
        [self.rightInnerView addSubview:self.objAddScheduleViewController.view];
    }
    else
    {
        if (self.selectedTag==nil || self.selectedTag.tagId==(NSString*)[NSNull null]) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
        }
        else
        {
            if (clockInSwitch.isOn) {
                
                if (sharedAppDelegate.calenderCurrentDate==nil || sharedAppDelegate.calenderCurrentDate==(NSString*)[NSNull null] || [sharedAppDelegate.calenderCurrentDate isEqualToString:@""]) {
                    
                    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
                    sharedAppDelegate.calenderServerDate = [dateformate stringFromDate:[NSDate date]];
                    sharedAppDelegate.calenderCurrentDate=[self shortStyleDate:[NSDate date]];
                    
                }
                ;
                rightMainSegment.selectedSegmentIndex=0;
                
                [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                
                [self.objAddNewTaskVC.view removeFromSuperview];
                
                if (IS_DEVICE_IPAD) {
                    
                    self.objAddNewTaskVC = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
                    
                }
                else
                {
                    self.objAddNewTaskVC = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
                    
                }
                if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null] || [self.selectedTag.tagId isEqualToString:@""]) {
                    
                    self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
                    self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
                    
                }
                else
                {
                    self.objAddNewTaskVC.selectedTagId=sharedAppDelegate.strSelectedTagId;
                    self.objAddNewTaskVC.selectedTag=sharedAppDelegate.strSelectedTag;
                    self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
                    self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
                    
                }
                
                [self.rightInnerView addSubview:self.objAddNewTaskVC.view];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
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
-(IBAction)btnMessageAction:(id)sender
{
    if (clockInSwitch.isOn) {
        
        [self.objChatDetailVC.view removeFromSuperview];
        
        if (IS_DEVICE_IPAD) {
            
            self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
        }
        else
        {
            self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
        }
        
        rightMainSegment.selectedSegmentIndex=9;
        FamilyTopRightMainSegment.selectedSegmentIndex=6;
        
        [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        self.objChatDetailVC.msgListSelected = FALSE;
        sharedAppDelegate.strCheckUserAndTag=@"Tag";
        self.objChatDetailVC.backBtnVisibility=@"NO";
        sharedAppDelegate.checkSpecialGroupChat=@"0";
        
        sharedAppDelegate.unreadGroupChatCount=0;
        [btnGroupChatCount setHidden:TRUE];
        
        sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
        [self.rightInnerView addSubview:self.objChatDetailVC.view];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
-(IBAction)btnSpecialMessageAction:(id)sender
{
    if (clockInSwitch.isOn) {
        
        [self.objChatDetailVC.view removeFromSuperview];
        
        if (IS_DEVICE_IPAD) {
            
            self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
        }
        else
        {
            self.objChatDetailVC = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
        }
        
        rightMainSegment.selectedSegmentIndex=9;
        
        [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        self.objChatDetailVC.msgListSelected = FALSE;
        sharedAppDelegate.strCheckUserAndTag=@"Tag";
        self.objChatDetailVC.backBtnVisibility=@"NO";
        sharedAppDelegate.checkSpecialGroupChat=@"1";
        
        sharedAppDelegate.unreadSpecialGroupChatCount=0;
        [btnSpecialChatCount setHidden:TRUE];
        
        sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
        [self.rightInnerView addSubview:self.objChatDetailVC.view];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
-(IBAction)btnBackPackPressed:(id)sender
{
    if (self.selectedTag==nil || self.selectedTag.tagId==(NSString*)[NSNull null]) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select tag"];
    }
    else
    {
        
        if (clockInSwitch.isOn) {
            
            self.objBackPackViewCOntroller=[[BackPackViewController alloc] init];
            self.objBackPackViewCOntroller.tagId=self.selectedTag.tagId;
            [self.rightInnerView addSubview:self.objBackPackViewCOntroller.view];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please clockin first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
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
    self.popoverContent = [[UIViewController alloc]init];
    self.popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];
    [table setDataSource:self];
    [table setDelegate:self];
    [table setRowHeight:40];
    [self.popoverView addSubview:table];
    self.popoverContent.view = self.popoverView;
    self.popoverContent.preferredContentSize = CGSizeMake(300, 300);
    
    int iOSVersion = [[[UIDevice currentDevice]systemVersion] intValue];
    if (iOSVersion >= 8) {
        self.popoverContent.preferredContentSize = CGSizeMake(300, 300);
    }
    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
    
    [self.popoverController  presentPopoverFromRect:CGRectMake(300,200, 35, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)getContactList
{
    if([ConfigManager isInternetAvailable]){
        [self.contactEmailArr removeAllObjects];
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
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"]||[sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        tblLeftFeedView.frame = CGRectMake(tblLeftFeedView.frame.origin.x, 329-40, tblLeftFeedView.frame.size.width, self.view.frame.size.height-400);
        
    }
    else
    {
        tblLeftFeedView.frame = CGRectMake(tblLeftFeedView.frame.origin.x, 329, tblLeftFeedView.frame.size.width, self.view.frame.size.height-400);
        
    }
    [tblLeftFeedView setBackgroundColor:[UIColor clearColor]];

    return pdfData;
}
#pragma mark FeedListTableViewCellDelegate Mehtods--------

-(void)FavButtonDidClick:(UIButton*)sender
{
    //  NSIndexPath *indexPath = [tblLeftFeedView indexPathForCell:sender];
    
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    Feeds *feed=[self.arrFeedList objectAtIndex:index];
    
    self.selectedIndex=index;
    
    NSLog(@"%@",feed.postId);
    
    
    if([ConfigManager isInternetAvailable]){
        
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
        }
        else
        {
            self.locationVC = [[UserLocationVC alloc] initWithNibName:@"UserLocationVC_iphone" bundle:nil];
        }
        self.locationVC.feed = f;
        
        self.locationVC.checkLocationView=@"feed";
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.locationVC];
        self.popoverController.popoverContentSize= CGSizeMake(450, 780);
        
        [self.popoverController presentPopoverFromRect:tblLeftFeedView.frame inView:tblLeftFeedView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
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
    
    NSLog(@"%ld",(long)rowCount);
    
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
                
                CGRect textRect= [nData.ntext boundingRectWithSize:CGSizeMake(330.0f, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:13.0]}
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
                        
                        
                        [feedCell.btnFav setFrame:CGRectMake(297, feedCell.btnFav.frame.origin.y, feedCell.btnFav.frame.size.width, feedCell.btnFav.frame.size.height)];
                        
                        [feedCell.btnLocation setFrame:CGRectMake(322, feedCell.btnLocation.frame.origin.y, feedCell.btnLocation.frame.size.width, feedCell.btnLocation.frame.size.height)];
                        
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

                            [feedCell.btnFav setFrame:CGRectMake(245, feedCell.btnFav.frame.origin.y, feedCell.btnFav.frame.size.width, feedCell.btnFav.frame.size.height)];
                            
                            [feedCell.btnLocation setFrame:CGRectMake(270, feedCell.btnLocation.frame.origin.y, feedCell.btnLocation.frame.size.width, feedCell.btnLocation.frame.size.height)];
                            
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
                            
                            [feedCell.btnFav setFrame:CGRectMake(297, feedCell.btnFav.frame.origin.y, feedCell.btnFav.frame.size.width, feedCell.btnFav.frame.size.height)];
                            
                            [feedCell.btnLocation setFrame:CGRectMake(322, feedCell.btnLocation.frame.origin.y, feedCell.btnLocation.frame.size.width, feedCell.btnLocation.frame.size.height)];
                            
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
                UITableViewCell *cell = [tblLeftFeedView cellForRowAtIndexPath:indexPath];
                
                [self.popoverController dismissPopoverAnimated:YES];
                
                if ([feed.postType isEqualToString:@"6"]) {
                    
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
                        
                        self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController" bundle:nil];
                        
                        self.objRouteFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                        self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.objRouteFeedDetailViewController.feedDetails=feed;
                        
                        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRouteFeedDetailViewController];
                        
                        self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                        
                        [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                    else
                    {
                        self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController" bundle:nil];
                        
                        self.objRecieptFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                        self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                        
                        self.objRecieptFeedDetailViewController.feedDetails=feed;
                        
                        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRecieptFeedDetailViewController];
                        
                        self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                        
                        [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                    
                    
                }
                else
                {
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
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            UITableViewCell *cell = [tblLeftFeedView cellForRowAtIndexPath:indexPath];
            
            self.objInboxDetailViewController=[[InboxDetailViewController alloc] init];
            
            self.objInboxDetailViewController.arrMailData=[[NSMutableArray alloc] initWithArray:self.arrInboxListing];
            self.objInboxDetailViewController.selectedIndex=indexPath.row;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objInboxDetailViewController];
            
            self.popoverController.popoverContentSize= CGSizeMake(450, 700);
            
            [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
            
        }
        
    }
    else if (tableView==tblViewTagList)
    {
        [popoverController dismissPopoverAnimated:YES];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            pageIndex=1;
            
            rightMainSegment.selectedSegmentIndex=0;
            leftSecondSegment.selectedSegmentIndex=0;
            [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
            [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
            [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
            
            [btnClearAll setHidden:TRUE];
            
            [self.arrFeedList removeAllObjects];
            
            self.selectedTag=nil;
            sharedAppDelegate.selectedTag=nil;
            sharedAppDelegate.strSelectedTagId=nil;
            sharedAppDelegate.strSelectedTag=nil;
            isClockInFeedAdded = FALSE;
            
            self.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
            sharedAppDelegate.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
            sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
            sharedAppDelegate.strSelectedTag=self.selectedTag.tagTitle;
            
            checkCaledarLoad=TRUE;
            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
           // [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];
            
        }
        else
        {
            if (clockInSwitch.isOn) {
                
                [popoverController dismissPopoverAnimated:YES];
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Please clockout first from %@",self.selectedTag.tagTitle] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                pageIndex=1;
                
                rightMainSegment.selectedSegmentIndex=0;
                leftSecondSegment.selectedSegmentIndex=0;
                [SupervisiorRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [FamilyRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                [ManagerRightMainSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                
                [btnClearAll setHidden:TRUE];
                
                [self.arrFeedList removeAllObjects];
                
                self.selectedTag=nil;
                sharedAppDelegate.selectedTag=nil;
                sharedAppDelegate.strSelectedTagId=nil;
                sharedAppDelegate.strSelectedTag=nil;
                isClockInFeedAdded = FALSE;
                
                self.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
                sharedAppDelegate.selectedTag=[self.arrTagsList objectAtIndex:indexPath.row];
                sharedAppDelegate.strSelectedTagId=self.selectedTag.tagId;
                sharedAppDelegate.strSelectedTag=self.selectedTag.tagTitle;
                
                sharedAppDelegate.unreadSpecialGroupChatCount=0;
                sharedAppDelegate.unreadGroupChatCount=0;
                
                [btnGroupChatCount setHidden:TRUE];
                [btnSpecialChatCount setHidden:TRUE];
                checkCaledarLoad=TRUE;
                [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
                
               // [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];
            }
            
        }
        
    }
    else if (tableView == hashTagTblView)
    {
        if (IS_DEVICE_IPAD) {
            
            [popoverController dismissPopoverAnimated:YES];
            
        }
        
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
         [bodyD setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
         [bodyD setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
         [bodyD setObject:[[self.tenHashTagArr valueForKey:@"id"] objectAtIndex:indexPath.row] forKey:@"keyword_id"];
         
         [self requestForTagSearchFeeds:bodyD];*/
        
        isNormalSearch = YES;
        isTopHashTag = YES;
        [self.arrFeedList removeAllObjects];
        pageIndex=1;
        [self.normalSearchDic removeAllObjects];
        
        tblLeftFeedView.delegate=nil;
        tblLeftFeedView.dataSource=nil;
        
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
        [popoverController dismissPopoverAnimated:YES];
        
        self.selectedIndex = indexPath.row;
        
        NSData *pdfData = [self pdfDataWithTableView:tblLeftFeedView];
        
        if([ConfigManager isInternetAvailable])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:@"attachment" forKey:@"attachment_key"];
            [dict setObject:@"uploadPdf" forKey:@"request_path"];
            
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
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController1
{
    if (popoverController1==clockOutPopoverController) {
        
        if (checkClockOutPopoverView==FALSE) {
            
            return YES;
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Please submit your signature"];
            return NO;
            
        }
    }
    
    return YES;
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController1
{
    NSLog(@"popoverController1234");
    
}
#pragma mark- UIALERTVIEW

-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
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
            
            /*ACAlertView * av = [[ACAlertView alloc ] initWithTitle:@"Please enter pin to see feeds" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Submit", nil];
             
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
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                NSMutableDictionary *dic = [NSMutableDictionary new];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"userId"];
                
                [[AmityCareServices sharedService] DeleteMailInvocation:sharedAppDelegate.userObj.userId tagId:sharedAppDelegate.strSelectedTagId mailId:inbox.mailId delegate:self];
                
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
                [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
                [[AmityCareServices sharedService] DeleteAllTagNotificationInvocation:sharedAppDelegate.userObj.userId tagId:sharedAppDelegate.strSelectedTagId delegate:self];
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

#pragma mark- UpdateStatusDelegate

-(void)statusDidUpdate:(UIView *)statusView newStatus:(Status *)status status:(BOOL)isUpdated
{
    /*if(isUpdated){
     
     isClockInFeedAdded = FALSE;
     [self.arrFeedList removeAllObjects];
     
     [btnClearAll setHidden:TRUE];
     
     pageIndex=1;
     
     leftSecondSegment.selectedSegmentIndex=2;
     
     [self performSelector:@selector(requestForTagStatusList:) withObject:[NSNumber numberWithInt:pageIndex] afterDelay:0.1f];
     }*/
}

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
            
            totalNumber = [NULL_TO_NIL([response valueForKey:@"totalNumber"]) intValue];
            sharedAppDelegate.calendarVisibleStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"calendar"])];

            lblNumber.text=[NSString stringWithFormat:@"Number: %lu",totalNumber];
            [lblNumber setHidden:FALSE];
            
            NSString *tagEmailStr=NULL_TO_NIL([response valueForKey:@"tagEmail"]);
            
            if (tagEmailStr.length==0) {
                
                lblEmail.text = @"Email:";
            }
            else
            {
                // lblEmail.text = [NSString stringWithFormat:@"Email:%@@amitycarecloud.com",NULL_TO_NIL([response valueForKey:@"tagEmail"])];
                
                lblEmail.text = [NSString stringWithFormat:@"Email: %@",NULL_TO_NIL([response valueForKey:@"tagEmail"])];
                
                
            }
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
                [btnChatCount setHidden:FALSE];
                
                [btnGroupChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
                
                [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadGroupChatCount] forState:UIControlStateNormal];
                
            }
            else
            {
                [btnGroupChatCount setHidden:TRUE];
                [btnChatCount setHidden:TRUE];
                
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
            
            self.tagTitleLbl.text = sharedAppDelegate.strSelectedTag;
            
            [self.tenHashTagArr removeAllObjects];
            
            self.tenHashTagArr = NULL_TO_NIL([[response valueForKey:@"topHasTag"] mutableCopy]);
            
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                if (clockInView.swClockin.isOn)
                {
                    TopNavigationView *navigation = (TopNavigationView *)[self.view viewWithTag:100];
                    navigation.leftBarButton.hidden = YES;
                }
                
                if (!isTwentyHoursUpdate)// timer will not start for 24 hours update
                {
                    [clockInView startTimer];
                }
                
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) intValue];
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                tagLblDate.text=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagCreated"])];
              
                NSString *tagCount=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagCount"])];
                
                sharedAppDelegate.unreadTagCount=[tagCount intValue];
                
                if (sharedAppDelegate.unreadTagCount>0) {
                    
                    [btnTagNotificationCount setHidden:FALSE];
                    
                    [btnTagNotificationCount setTitle:tagCount forState:UIControlStateNormal];
                }
                else
                {
                    [btnTagNotificationCount setHidden:TRUE];

                }
                
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
                        clockInFeed.postId = @"-1";
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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
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
                        
                        feed.arrSimiliarTags = [[NSMutableArray alloc ]  init];
                        
                        NSArray *fTags = NULL_TO_NIL([fDict valueForKey:@"similar_tags"]);
                        
                        for (int j = 0; j <[fTags count]; j++) {
                            
                            NSDictionary *inner = [fTags objectAtIndex:j];
                            
                            Tags *t = [[Tags alloc] init];
                            
                            t.tagId = NULL_TO_NIL([inner valueForKey:@"tag_id"]);
                            t.tagTitle = NULL_TO_NIL([inner valueForKey:@"tag_title"]);
                            
                            [feed.arrSimiliarTags addObject:t];
                        }
                        
                        feed.arrFormValues = [[NSMutableArray alloc]  init];
                        
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

                            /*
                             This block of code adds a new feed of ClockIn type manually in the feeds array. It checks if the clockin time is available
                             */
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
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
            
            if (clockInSwitch.isOn) {

                [rightMainSegment setEnabled:YES forSegmentAtIndex:6];

            }
            else
            {
                [rightMainSegment setEnabled:NO forSegmentAtIndex:6];

            }

        }
        else
        {
                [rightMainSegment setEnabled:NO forSegmentAtIndex:2];

            if (clockInSwitch.isOn) {
                
                [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:6];

            }
            else
            {
                [rightMainSegment setEnabled:NO forSegmentAtIndex:3];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:4];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:10];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:6];

            }
                
        }
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            if (checkCaledarLoad==TRUE) {
                
                [rightMainSegment setEnabled:YES forSegmentAtIndex:0];
                
                [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];
                
            }
            
        }
        else
        {
            if ([sharedAppDelegate.calendarVisibleStatus isEqualToString:@"1"]) {
                
                if (checkCaledarLoad==TRUE) {
                    
                    [rightMainSegment setEnabled:YES forSegmentAtIndex:0];
                    [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];
                    
                }
                
            }
            else
            {
                
                if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                    
                    [FamilyTopRightMainSegment setEnabled:NO forSegmentAtIndex:0];
                    FamilyTopRightMainSegment.selectedSegmentIndex=1;

                    [self showSadSmileView];
                }
                else
                {
                    [rightMainSegment setEnabled:NO forSegmentAtIndex:0];
                    rightMainSegment.selectedSegmentIndex=1;

                    [self showReimbursementsView];
                }
                
            }
            
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
                if (clockInView.swClockin.isOn)
                {
                    TopNavigationView *navigation = (TopNavigationView *)[self.view viewWithTag:100];
                    navigation.leftBarButton.hidden = YES;
                }
                
                if (!isTwentyHoursUpdate)// timer will not start for 24 hours update
                {
                    [clockInView startTimer];
                }
                
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                //  tagLblDate.text=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagCreated"])];
                
                
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
                
                
                // NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
                /*  if (clockinTime) {
                 recordCount = recordCount+1;
                 }
                 
                 if(clockinTime && !isClockInFeedAdded)
                 {
                 
                 Feeds *clockInFeed = [[Feeds alloc] init];
                 
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
                 }*/
                
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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
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
                            /*
                             This block of code adds a new feed of ClockIn type manually in the feeds array. It checks if the clockin time is available
                             */
                            
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
        [imgDate setHidden:FALSE];
        
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
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Verifying ClockIn Please wait..." width:220];
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dict setObject:self.selectedTag.tagId forKey:@"tagId"];
            [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
            [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            
            [[AmityCareServices sharedService] clockInUserInvocation:dict delegate:self];
        }
        else
        {
            /*  recordCount = 0;
             [self.arrFeedList removeAllObjects];
             
             tblLeftFeedView.delegate=self;
             tblLeftFeedView.dataSource=self;
             
             [tblLeftFeedView reloadData];
             [clockInView stopTimer1];
             
             moveToKeywordSearch = FALSE;
             [sharedAppDelegate startUpdatingLocation];
             ClockOutVC *clockOutVc;
             
             if (IS_DEVICE_IPAD) {
             
             clockOutVc = [[ClockOutVC alloc ] initWithNibName:@"ClockOutVC" bundle:nil];
             }
             else
             {
             clockOutVc = [[ClockOutVC alloc ] initWithNibName:@"ClockOutVC_iphone" bundle:nil];
             }
             [self.navigationController pushViewController:clockOutVc animated:YES];*/
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
                    TopNavigationView *navigation = (TopNavigationView *)[self.view viewWithTag:100];
                    UIButton *btnSearch1 = (UIButton *)[navigation viewWithTag:1];
                    btnSearch1.enabled = YES;
                    
                    userDidClockedIn = YES;
                    
                    //[self performSelector:@selector(requestGetTagFeeds:) withObject:[NSNumber numberWithInt:pageIndex] afterDelay:0.1f];
                    
                    [clockInSwitch setOn:YES];

                    [self performSelectorOnMainThread:@selector(requestGetTagFeeds:) withObject:[NSNumber numberWithUnsignedLong:pageIndex] waitUntilDone:YES];
                    
                    rightMainSegment.selectedSegmentIndex=0;
                    checkCaledarLoad=TRUE;
                  //  [self performSelectorOnMainThread:@selector(showCalenderView) withObject:nil waitUntilDone:YES];
                    
                }
                else{
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
            else
            {
                // ---------------- Disable back button when user is in range --------------
                TopNavigationView *navigation = (TopNavigationView *)[self.view viewWithTag:100];
                UIButton *btnSearch1 = (UIButton *)[navigation viewWithTag:1];
                btnSearch1.enabled = NO;
                
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
        

        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
            
            if (clockInSwitch.isOn) {
                
                [rightMainSegment setEnabled:YES forSegmentAtIndex:6];
                
            }
            else
            {
                [rightMainSegment setEnabled:NO forSegmentAtIndex:6];
                
            }
            
        }
        else
        {
            [rightMainSegment setEnabled:NO forSegmentAtIndex:2];

            if (clockInSwitch.isOn) {
                
                [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:6];

            }
            else
            {
                [rightMainSegment setEnabled:NO forSegmentAtIndex:3];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:4];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:10];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:6];

            }
            
        }


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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
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
                if (clockInView.swClockin.isOn)
                {
                    TopNavigationView *navigation = (TopNavigationView *)[self.view viewWithTag:100];
                    navigation.leftBarButton.hidden = YES;
                }
                
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
                    
                    /*  if (sharedAppDelegate.isRecording==FALSE) {
                     
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

                        /*
                         This block of code adds a new feed of ClockIn type manually in the feeds array. It checks if the clockin time is available
                         */
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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
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
                        //  feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
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
                            /*
                             This block of code adds a new feed of ClockIn type manually in the feeds array. It checks if the clockin time is available
                             */
                            
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
                if (clockInView.swClockin.isOn)
                {
                    TopNavigationView *navigation = (TopNavigationView *)[self.view viewWithTag:100];
                    navigation.leftBarButton.hidden = YES;
                }
                
                if (!isTwentyHoursUpdate)// timer will not start for 24 hours update
                {
                    [clockInView startTimer];
                }
                
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
                sharedAppDelegate.clockInStatus=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"clockIn"])];
                
                // tagLblDate.text=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagCreated"])];
                
                NSString *tagCount=[NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagCount"])];
                
                sharedAppDelegate.unreadTagCount=[tagCount intValue];
                
                if (sharedAppDelegate.unreadTagCount>0) {
                    
                    [btnTagNotificationCount setHidden:FALSE];
                    
                    [btnTagNotificationCount setTitle:tagCount forState:UIControlStateNormal];
                }
                else
                {
                    [btnTagNotificationCount setHidden:TRUE];
                    
                }
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
                        /*
                         This block of code adds a new feed of ClockIn type manually in the feeds array. It checks if the clockin time is available
                         */
                        
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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
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
                        //   feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
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
        //leftSecondSegment.selectedSegmentIndex=0;
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
                    TopNavigationView *navigation = (TopNavigationView *)[self.view viewWithTag:100];
                    UIButton *btnSearch1 = (UIButton *)[navigation viewWithTag:1];
                    btnSearch1.enabled = YES;
                    
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

#pragma mark- Task Invocations-------

#pragma mark- Delete Task Invocation


-(void)deleteTaskInvocationDidFinish:(DeleteTaskInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getTaskListInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                // [arrAssignedTask removeObjectAtIndex:selectedCellIndex];
                
                //[tblViewTaskList beginUpdates];
                //[tblViewTaskList deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                //[tblViewTaskList endUpdates];
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
                [ConfigManager showAlertMessage:nil Message:@"Task not deleted"];
                
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
                    
                    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"]) {

                        Tags *tag =[self.arrTagsList objectAtIndex:0];
                        
                        sharedAppDelegate.strSelectedTagId=tag.tagId;
                        sharedAppDelegate.strSelectedTag=tag.tagTitle;
                        
                        sharedAppDelegate.selectedTag=tag;
                        
                        self.selectedTag=tag;
                        
                        pageIndex=1;
                        checkCaledarLoad=TRUE;
                        [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
                        
                       // [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];


                    }
                    else
                    {
                        [self showTagView];

                    }
                    
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
            
            if ([sharedAppDelegate.clockInStatus isEqualToString:@"1"]) {
                
                [clockInSwitch setOn:YES];
            }
            else
            {
                [clockInSwitch setOn:NO];
                
            }
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
            //[self parseData];
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
           // pageIndex=1;
            //isClockInFeedAdded=FALSE;
            
           // [self parseData];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            //[self.arrFeedList removeAllObjects];
            //pageIndex=1;
            //isClockInFeedAdded=FALSE;
            
           // [self parseData];
            
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
            //pageIndex=1;
            //isClockInFeedAdded=FALSE;
            
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


#pragma mark- ClockOut Viewcontroller Delegate

-(void)ClockOutVCDidFinish:(NSDictionary*)dic
{
    checkClockOutPopoverView=FALSE;
    [clockOutPopoverController dismissPopoverAnimated:YES];
    
    if([ConfigManager isInternetAvailable]) {
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
            
            [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
            [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
            if (clockInSwitch.isOn) {
                
                [rightMainSegment setEnabled:YES forSegmentAtIndex:6];
                
            }
            else
            {
                [rightMainSegment setEnabled:NO forSegmentAtIndex:6];
                
            }
            
        }
        else
        {
            if (clockInSwitch.isOn) {
                
                [rightMainSegment setEnabled:YES forSegmentAtIndex:3];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:4];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:10];
                [rightMainSegment setEnabled:YES forSegmentAtIndex:6];

            }
            else
            {
                [rightMainSegment setEnabled:NO forSegmentAtIndex:3];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:4];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:10];
                [rightMainSegment setEnabled:NO forSegmentAtIndex:6];

            }
            
        }

        
        pageIndex=1;
        
        tblLeftFeedView.delegate=nil;
        tblLeftFeedView.dataSource=nil;
        [self.arrFeedList removeAllObjects];
        [tblLeftFeedView reloadData];
        
        sharedAppDelegate.userObj.clockInTagId=@"";
        sharedAppDelegate.userObj.clockInTagTitle=@"";
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Verifying ClockIn Please wait..." width:220];
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            checkCaledarLoad=TRUE;

            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
        }
        else if (leftSecondSegment.selectedSegmentIndex==1)
        {
            [self requestForTagEmailList];
        }
      
        else
        {
            [self requestForNotificationList];
        }
    }
    rightMainSegment.selectedSegmentIndex=0;
 //   [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:1.0];
    
    
}
-(void)ClockOutVCDidCancel:(NSDictionary*)dic
{
    checkClockOutPopoverView=FALSE;
    
    //  [clockInSwitch setOn:YES];
    [clockOutPopoverController dismissPopoverAnimated:YES];
}

#pragma mark- UITextField

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
        
        
        popoverContent.view=nil;
        popoverContent=nil;
        [popoverView removeFromSuperview];
        popoverView=nil;
        
        if (popoverContent==nil) {
            
            popoverContent = [[UIViewController alloc] init];
            
            popoverView = [[UIView alloc] init];
            
            
        }
        popoverView.backgroundColor = [UIColor clearColor];
        
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
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
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        // popoverController.delegate=self;
        
        txtStartDate.inputView=datePicker;
        
        [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
        [popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if([textField isEqual:txtEndDate]){
        
        if(txtStartDate.text.length ==0){
            [ConfigManager showAlertMessage:nil Message:@"Please select start date first"];
            return FALSE;
        }
        
        popoverContent.view=nil;
        popoverContent=nil;
        [popoverView removeFromSuperview];
        popoverView=nil;
        
        if (popoverContent==nil) {
            
            popoverContent = [[UIViewController alloc] init];
            
            popoverView = [[UIView alloc] init];
            
            
        }
        popoverView.backgroundColor = [UIColor clearColor];
        
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
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
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        // popoverController.delegate=self;
        
        txtEndDate.inputView=datePicker;
        
        [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
        [popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        return TRUE;
    }
    
    return FALSE;
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
    return TRUE;
}
-(IBAction)cancel
{
    [popoverController dismissPopoverAnimated:YES];
    
}
-(IBAction)done
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    txtStartDate.text = [formatter stringFromDate:dateSelected];
    
    [popoverController dismissPopoverAnimated:YES];
}
-(IBAction)endDone
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    txtEndDate.text = [formatter stringFromDate:dateSelected];
    
    [popoverController dismissPopoverAnimated:YES];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [txtSearch resignFirstResponder];
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
    
    checkPN=@"NO";
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}
#pragma mark- ----------------

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
