
//
//  UserHomeViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 03/12/14.
//
//

#import "UserHomeViewController.h"
#import "Feeds.h"
#import "FeedListTableViewCell.h"
#import "ConfigManager.h"
#import "UIImageExtras.h"
#import "UserFeedCell.h"
#import "TopNavigationView.h"
#import "UIImageExtras.h"
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
#import "TagHomeViewController.h"
#import "TaskCalenderViewController.h"
#import "NotificationCell.h"
#import "NotificationD.h"
#import "ContactD.h"
#import "SqliteManager.h"
#import "ChatDetailVC.h"
#import <QuartzCore/QuartzCore.h>
#import "OptionsPopOverVC.h"
#import "AddContactsVC.h"
#import "FormListViewController.h"
#import "SadSmileViewController.h"
#import "SmileViewController.h"
#import "FavoriteViewController.h"
#import "SettingViewController.h"
#import "MessagesListVC.h"
#import "AddNewTaskVC.h"
#import "FeedDetailViewController.h"
#import "FormFeedDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "InboxDetailViewController.h"
#import "ReimbursementsViewController.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "ACContactsVC.h"
#import "MadFormViewController.h"
#import "EditMadFormViewController.h"
#import "BackPackViewController.h"
#import "OCRReceiptListViewController.h"
#import "RouteFeedDetailViewController.h"
#import "RecieptFeedDetailViewController.h"

@interface UserHomeViewController ()

@end

@implementation UserHomeViewController

@synthesize arrFeedList,formNameArr,formsArr,arrTagsList,arrInboxListing,arrStatusList,arrNotificationList,arrContactsList,phoneCallDelegate,arrSearchList,selectedIndxpath,activeSheet,normalActionSheetDelegate,tenHashTagArr,contactEmailArr;
@synthesize objAddContactView,objTaskCalenderView,objEditMadFormViewController,objBackPackViewCOntroller,objAddNewTaskVC,objChatDetailVC,objFavoriteViewController,objFormListViewController,objMadFormViewController,objReimbursementsViewController,objSadSmileViewController,objSettingViewController,objSmileViewController,objUpdateStatusView,objUploadDocVC,objMessagesListVC,objFeedDetailViewController,objFormFeedDetailViewController,objInboxDetailViewController,objStatusFeedDetailViewController,opt,locationVC,popoverController,popoverContent,popoverView,leftView,rightView,rightInnerView,msgComposer,feedCell,inboxCell,objOCRReceiptListViewController,objRouteFeedDetailViewController,objRecieptFeedDetailViewController;

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A",@"B",@"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil]
#define HEADER_HEIGHT 20.0F

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [btnChatCount setHidden:TRUE];
    [btnContactNotificationCount setHidden:TRUE];
    [btnUserNotificationCount setHidden:TRUE];
    
    [self setBadgeValue:nil];
    
    checkSharePDF=FALSE;
    
    searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    searchBar.layer.borderWidth = 1.0f;
    searchBar.clipsToBounds = YES;
    
    [self.leftView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"left_bg"]]];
    
    lblUserTitle.text = [[NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname] capitalizedString];
    
    descriptionTxtView.text = [[NSString stringWithFormat:@"%@",sharedAppDelegate.userObj.aboutMe] capitalizedString];
    
    
    imgUserView.layer.cornerRadius = floor(imgUserView.frame.size.width/2);
    imgUserView.clipsToBounds = YES;
    
    [btnAddContact setHidden:TRUE];
    [btnClearAll setHidden:TRUE];
    [btnShare setHidden:TRUE];
    
    [imgUserView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,sharedAppDelegate.userObj.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    
    [leftMainSegment setTitle:[[NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname] capitalizedString] forSegmentAtIndex:0];
    [txtSearch setValue:[UIColor colorWithRed:0.8588235 green:0.8588235 blue:0.8588235 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [txtStartDate setValue:[UIColor colorWithRed:0.8588235 green:0.8588235 blue:0.8588235 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [txtEndDate setValue:[UIColor colorWithRed:0.8588235 green:0.8588235 blue:0.8588235 alpha:1.0]  forKeyPath:@"_placeholderLabel.textColor"];
    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIFont boldSystemFontOfSize:13], UITextAttributeFont,
//                                [UIColor colorWithRed:0.27843137 green:0.69411764 blue:0.92156862 alpha:1.0], UITextAttributeTextColor,
//                                nil];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,
                                [UIColor colorWithRed:0.27843137 green:0.69411764 blue:0.92156862 alpha:1.0], NSForegroundColorAttributeName, nil];
    
    [leftMainSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [leftSecondSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
   // NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont boldSystemFontOfSize:13], UITextAttributeFont,[UIColor whiteColor], UITextAttributeTextColor,nil];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];

    
    [leftMainSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    [leftSecondSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    tblLeftFeedView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
#pragma mark User Feeds --------
    
    self.arrFeedList=[[NSMutableArray alloc] init];
    self.arrTagsList=[[NSMutableArray alloc] init];
    self.formsArr=[[NSMutableArray alloc] init];
    self.formNameArr=[[NSMutableArray alloc] init];
    self.arrInboxListing=[[NSMutableArray alloc] init];
    self.normalSearchDic = [NSMutableDictionary new];
    self.arrNotificationList= [[NSMutableArray alloc] init];
    self.arrStatusList= [[NSMutableArray alloc] init];
    self.arrContactsList=[[NSMutableArray alloc] init];
    self.arrSearchList=[[NSMutableArray alloc] init];
    self.tenHashTagArr=[[NSMutableArray alloc] init];
    self.contactEmailArr=[[NSMutableArray alloc] init];
    
    recordCount = 0;
    pageIndex = 1;
    userInRadiusRange = TRUE;
    isNormalSearch = NO;
    isTopHashTag = NO;
    isTwentyHoursUpdate = YES;
    isSearchEnable=FALSE;
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        [btnShare setHidden:TRUE];
        [rightMainSegment setHidden:TRUE];
        [FamilyTopRightMainSegment setHidden:FALSE];
        
        [btnContactNotificationCount setFrame:CGRectMake(258,49 ,btnContactNotificationCount.frame.size.width,btnContactNotificationCount.frame.size.height)];
        
        
    }
    else
    {
        [btnShare setHidden:FALSE];
        [rightMainSegment setHidden:FALSE];
        [FamilyTopRightMainSegment setHidden:TRUE];
        
        [btnContactNotificationCount setFrame:CGRectMake(248,49 ,btnContactNotificationCount.frame.size.width,btnContactNotificationCount.frame.size.height)];
        
    }
    
    if(sharedAppDelegate.userObj.isEmployee)
        descriptionTxtView.userInteractionEnabled = NO;
    else
        descriptionTxtView.userInteractionEnabled = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isKeywordSearched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [segmentScroll setContentSize:CGSizeMake(450, segmentScroll.frame.size.height)];
    
    pageIndex=1;
    [self.arrFeedList removeAllObjects];
    [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForNotificationList) name:AC_UPDATE_NOTIFICATION_TABLE object:nil];
    
    sharedAppDelegate.strCheckUserAndTag=@"User";
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMadForms) name: AC_MADFORM_CREATED_UPDATES object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeValue:) name: AC_USER_UNREAD_BADGE_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusList) name: AC_STATUS_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePostList) name: AC_POST_UPDATE object:nil];
    
}


-(void)updateStatusList
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        isClockInFeedAdded = FALSE;
        [self.arrFeedList removeAllObjects];
        
        [btnClearAll setHidden:TRUE];
        
        pageIndex=1;
        
        leftSecondSegment.selectedSegmentIndex=0;
        
        [self requestForUserStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
        
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
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}
-(void)updateMadForms
{
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        NSLog(@"ssssssss");
        
        [self.popoverController dismissPopoverAnimated:YES];
        
        self.objEditMadFormViewController=[[EditMadFormViewController alloc] initWithNibName:@"EditMadFormViewController" bundle:nil];
        
        self.objEditMadFormViewController.preferredContentSize = CGSizeMake(768, 1024);
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objEditMadFormViewController];
        
        self.popoverController.popoverContentSize= CGSizeMake(768, 1024);
        
        [self.popoverController presentPopoverFromRect:CGRectMake(380, 0, 40, 40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    checkPN=@"YES";
    
    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadMessage) name:@"updateUnreadMessage" object:nil];

    
    self.navigationController.navigationBarHidden = YES;
    
    rightMainSegment.selectedSegmentIndex=0;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    [self performSelector:@selector(showCalenderView) withObject:nil afterDelay:0.3];
    
}




-(void)updateFeedFromNotification:(NSNotification*) note
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
            
        }
    }
    
    
    
}
-(void)updateStatusFromNotification:(NSNotification*) note
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        if(leftSecondSegment.selectedSegmentIndex==0)
        {
            [self requestForUserStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
            
        }
    }
}
-(void)setBadgeValue:(NSNotification*) note
{
    if (sharedAppDelegate.unreadUserNotifiationCount>0) {
        
        [btnUserNotificationCount setHidden:FALSE];
        [btnUserNotificationCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadUserNotifiationCount] forState:UIControlStateNormal];
    }
    else
    {
        [btnUserNotificationCount setHidden:TRUE];
        
    }
    
    if (sharedAppDelegate.unreadContactCount>0) {
        
        [btnContactNotificationCount setHidden:FALSE];
        [btnContactNotificationCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadContactCount] forState:UIControlStateNormal];
    }
    else
    {
        [btnContactNotificationCount setHidden:TRUE];
        
    }
    
    if (sharedAppDelegate.unreadMsgCount>0) {
        
        [btnChatCount setHidden:FALSE];
        [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadMsgCount] forState:UIControlStateNormal];
    }
    else
    {
        [btnChatCount setHidden:TRUE];
        
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
        
        [[AmityCareServices sharedService] UserFeedListInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"all" delegate:self];
        
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(void)requestForTagSearchFeeds:(NSMutableDictionary*)dict
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Searching feeds..." width:200];
        
        [[AmityCareServices sharedService] getKeywordsFeedsInvocation:dict delegate:self];
        
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(void)requestForEmailList
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching inbox list Please wait..." width:220];
        
        [[AmityCareServices sharedService] UserEmailListInvocation:sharedAppDelegate.userObj.userId delegate:self];
        
    }
    
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(void)requestForUserStatusList:(NSNumber*)index;
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
        
        NSString* strIndex = [NSString stringWithFormat:@"%d",[index intValue]];
        
        NSLog(@"user Id %@",sharedAppDelegate.userObj.role_id);
        NSLog(@"User update notification received");
        
        [[AmityCareServices sharedService] UserStatusListInvocation:sharedAppDelegate.userObj.userId tagID:self.selectedTag.tagId index:strIndex roleId:sharedAppDelegate.userObj.role_id time:@"all" delegate:self];
        
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)requestForNotificationList
{
    if (leftSecondSegment.selectedSegmentIndex==2) {
        
        sharedAppDelegate.unreadUserNotifiationCount = 0;
        
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
            
            pageIndex=1;
            [self.arrNotificationList removeAllObjects];
            NSString *pageIndexStr=[NSString stringWithFormat:@"%lu",pageIndex];
            
            [[AmityCareServices sharedService] getNotificationList:sharedAppDelegate.userObj.userId page_index:pageIndexStr delegate:self];
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }
    else
    {
        
    }
    
    
}

-(void)requestForContactList
{
    if (leftSecondSegment.selectedSegmentIndex==4) {
        
        if([ConfigManager isInternetAvailable]){
            
            tblLeftFeedView.delegate=nil;
            tblLeftFeedView.dataSource=nil;
            
            [self.arrContactsList removeAllObjects];
            [self.arrSearchList removeAllObjects];
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
            [[AmityCareServices sharedService] getAmityContactListInvocation:sharedAppDelegate.userObj.userId delegate:self];
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
    [self.objMessagesListVC.view removeFromSuperview];
    [self.objChatDetailVC.view removeFromSuperview];
    [self.objAddNewTaskVC.view removeFromSuperview];
    [self.objReimbursementsViewController.view removeFromSuperview];
    [sharedAppDelegate.acContactsVC.view removeFromSuperview];
    [self.objMadFormViewController.view removeFromSuperview];
    [self.objBackPackViewCOntroller.view removeFromSuperview];
}

-(void)showCalenderView
{
    
    [self.objTaskCalenderView.view removeFromSuperview];
    
    rightMainSegment.selectedSegmentIndex=0;
    
    self.objTaskCalenderView=[[TaskCalenderViewController alloc] initWithNibName:@"TaskCalenderViewController" bundle:nil];
    self.objTaskCalenderView.tagId=@"";
    
    [self.rightInnerView addSubview:self.objTaskCalenderView.view];
    
    
}

-(void)showSadSmileView
{
    [self.objSadSmileViewController.view removeFromSuperview];
    self.objSadSmileViewController=[[SadSmileViewController alloc] initWithNibName:@"SadSmileViewController" bundle:nil];
    self.objSadSmileViewController.tagId=@"";
    [self.rightInnerView addSubview:self.objSadSmileViewController.view];
}
-(void)showSmileView
{
    [self.objSmileViewController.view removeFromSuperview];
    self.objSmileViewController=[[SmileViewController alloc] initWithNibName:@"SmileViewController" bundle:nil];
    self.objSmileViewController.tagId=@"";
    [self.rightInnerView addSubview:self.objSmileViewController.view];
    
}
-(void)showFavoriteView
{
    [self.objFavoriteViewController.view removeFromSuperview];
    self.objFavoriteViewController=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
    self.objFavoriteViewController.tagId=@"";
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
    self.objFormListViewController.tagId=@"";
    [self.rightInnerView addSubview:self.objFormListViewController.view];
    
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

-(void)updateUnreadMessage{
    
    NSLog(@"updateUnreadMessage");
    
    if(sharedAppDelegate.unreadMsgCount > 0){
        [btnChatCount setTitle:[NSString stringWithFormat:@"%lu",sharedAppDelegate.unreadMsgCount] forState:UIControlStateNormal];
        [btnChatCount setHidden:FALSE];
    }
    else{
        sharedAppDelegate.unreadMsgCount = 0;
        [btnChatCount setTitle:@"" forState:UIControlStateNormal];
        [btnChatCount setHidden:TRUE];

    }
}

-(void)showMessageView
{
    [self.objMessagesListVC.view removeFromSuperview];
    
//    [btnChatCount setHidden:TRUE];
//    sharedAppDelegate.unreadMsgCount=0;
    
    self.objMessagesListVC=[[MessagesListVC alloc] initWithNibName:@"MessagesListVC" bundle:nil];
    [self.rightInnerView addSubview:self.objMessagesListVC.view];
    
}
-(void)showReimbursementsView
{
    [self.objReimbursementsViewController.view removeFromSuperview];
    self.objReimbursementsViewController=[[ReimbursementsViewController alloc] initWithNibName:@"ReimbursementsViewController" bundle:nil];
    self.objReimbursementsViewController.tagId=@"";
    self.objReimbursementsViewController.checkClockin=@"0";
    
    [self.rightInnerView addSubview:self.objReimbursementsViewController.view];
    
}
-(void)showContactView
{
    [sharedAppDelegate.acContactsVC.view removeFromSuperview];
    
    [btnContactNotificationCount setHidden:TRUE];
    sharedAppDelegate.unreadContactCount=0;
    
    [self.rightInnerView addSubview:sharedAppDelegate.acContactsVC.view];
}
-(void)showMadFormView
{
    [self.objMadFormViewController.view removeFromSuperview];
    self.objMadFormViewController=[[MadFormViewController alloc] initWithNibName:@"MadFormViewController" bundle:nil];
    [self.rightInnerView addSubview:self.objMadFormViewController.view];
    
}
#pragma mark Create contact section List on Popoverview--------

- (void)createSectionList:(NSMutableArray*)wordArray
{
    if(self.arrContactsList)
    {
        [self.arrContactsList removeAllObjects];
        self.arrContactsList = nil;
    }
    
    self.arrContactsList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 27; i++)
        [self.arrContactsList addObject:[[NSMutableArray alloc] init]];
    int k=0;
    for (k=0; k<[wordArray count]; k++) {
        NSString *word ;
        
        ContactD *data = [wordArray objectAtIndex:k];
        
        if(![data.userName isEqualToString:@""])
            word =((ContactD*)[wordArray objectAtIndex:k]).userName;
        
        if ([word length] == 0) continue;
        @try {
            contactRange = [ALPHA rangeOfString:[[word substringToIndex:1] uppercaseString]];
            
            if(contactRange.length>0)
                [[self.arrContactsList objectAtIndex:contactRange.location] addObject:[wordArray objectAtIndex:k]];
            else
                [[self.arrContactsList objectAtIndex:26] addObject:[wordArray objectAtIndex:k]];
        }
        @catch (NSException * e) {
            [[self.arrContactsList objectAtIndex:26] addObject:[wordArray objectAtIndex:k]];
            NSLog(@"error");
        }
    }
    
    tblLeftFeedView.delegate=self;
    tblLeftFeedView.dataSource=self;
    [tblLeftFeedView reloadData];
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
        
        [self.popoverController  presentPopoverFromRect:CGRectMake(50,20, 35, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma FeedList TableViewCellDelegate Mehtods--------

#pragma mark FeedListTableViewCellDelegate Mehtods--------

-(void)FavButtonDidClick:(UIButton*)sender
{
    int index=[[sender titleForState:UIControlStateReserved] intValue];
    
    Feeds *feed=[self.arrFeedList objectAtIndex:index];
    
    NSLog(@"%@",feed.postTagId);
    
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddFavoriteInvocation:sharedAppDelegate.userObj.userId tagId:feed.postTagId feedId:feed.postId delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

-(void)LocationButtonDidClick:(UIButton*)sender
{
    // if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
    
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
    
    txtStartDate.text= [txtStartDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtEndDate.text= [txtEndDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtSearch.text= [txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (txtStartDate.text.length==0 || txtEndDate.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please enter start and end date"];
        return;
    }
    else
    {
        if (btnFirstSearch.tag==1) {
            
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
                [self.normalSearchDic setObject:startDate forKey:@"start_date"];
                [self.normalSearchDic setObject:endDate forKey:@"end_date"];
                [self.normalSearchDic setObject:hashTag forKey:@"has_tag"];
                [self.normalSearchDic setObject:@"all" forKey:@"time"];
                [self.normalSearchDic setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];//Dharmbir140903
                [self.normalSearchDic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
                
                if([ConfigManager isInternetAvailable]) {
                    
                    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
                    
                    
                    if (leftSecondSegment.selectedSegmentIndex==0) {
                        
                        [[AmityCareServices sharedService] SortUserFeedsDateWiseInvocation:self.normalSearchDic delegate:self];
                        
                    }
                    else
                    {
                        [[AmityCareServices sharedService] SortUserStatusDateWiseInvocation:self.normalSearchDic delegate:self];
                        
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
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            [self.arrFeedList removeAllObjects];
            
            [self.normalSearchDic removeAllObjects];
            
            pageIndex = 1;
            
            [self.normalSearchDic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            // [self.normalSearchDic setObject:self.selectedTag.tagId forKey:@"tag_id"];
            [self.normalSearchDic setObject:startDate forKey:@"start_date"];
            [self.normalSearchDic setObject:endDate forKey:@"end_date"];
            [self.normalSearchDic setObject:@"all" forKey:@"time"];
            [self.normalSearchDic setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];//Dharmbir140903
            [self.normalSearchDic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
            
            
            if([ConfigManager isInternetAvailable]) {
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
                
                if (leftSecondSegment.selectedSegmentIndex==0) {
                    
                    [[AmityCareServices sharedService] SortUserFeedsDateWiseInvocation:self.normalSearchDic delegate:self];
                    
                }
                else
                {
                    [[AmityCareServices sharedService] SortUserStatusDateWiseInvocation:self.normalSearchDic delegate:self];
                    
                }
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
            
        }
        
    }
    
}
-(IBAction)leftMainSegmentAction:(id)sender
{
    if (leftMainSegment.selectedSegmentIndex==0) {
        
        leftMainSegment.selectedSegmentIndex=0;
        
    }
    else
    {
        
        leftMainSegment.selectedSegmentIndex=1;
        TagHomeViewController *objTagHomeViewController=[[TagHomeViewController alloc] initWithNibName:@"TagHomeViewController" bundle:nil];
        [self.navigationController pushViewController:objTagHomeViewController animated:NO];
    }
    
    
    
}
-(IBAction)leftSecondSegmentAction:(id)sender
{
    [self.normalSearchDic removeAllObjects];
    
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    txtSearch.text=@"";
    
    tblLeftFeedView.delegate=nil;
    tblLeftFeedView.dataSource=nil;
    
    [tblLeftFeedView reloadData];
    
    if (leftSecondSegment.selectedSegmentIndex==0) {
        
        pageIndex=1;
        [self.arrFeedList removeAllObjects];
        [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [btnShare setHidden:TRUE];
            
        }
        else
        {
            [btnShare setHidden:FALSE];
            
        }
        
        [txtEndDate setEnabled:TRUE];
        [txtStartDate setEnabled:TRUE];
        [txtSearch setEnabled:TRUE];
        [btnSearch setEnabled:TRUE];
        [btnSecondSearch setEnabled:TRUE];
        
        [btnAddContact setHidden:TRUE];
        [btnClearAll setHidden:TRUE];
        
    }
    else if(leftSecondSegment.selectedSegmentIndex==1)
    {
        [btnAddContact setHidden:TRUE];
        [btnClearAll setHidden:TRUE];
        [btnShare setHidden:TRUE];
        
        [txtEndDate setEnabled:FALSE];
        [txtStartDate setEnabled:FALSE];
        [txtSearch setEnabled:FALSE];
        [btnSearch setEnabled:FALSE];
        [btnSecondSearch setEnabled:FALSE];
        
        [self requestForEmailList];
    }
    else if(leftSecondSegment.selectedSegmentIndex==2)
    {
        [btnAddContact setHidden:TRUE];
        [btnClearAll setHidden:FALSE];
        [btnShare setHidden:TRUE];
        
        [txtEndDate setEnabled:FALSE];
        [txtStartDate setEnabled:FALSE];
        [txtSearch setEnabled:FALSE];
        [btnSearch setEnabled:FALSE];
        [btnSecondSearch setEnabled:FALSE];
        
        [btnUserNotificationCount setHidden:TRUE];
        sharedAppDelegate.unreadUserNotifiationCount=0;
        
        [self requestForNotificationList];

    }
        
    
}
-(IBAction)rightMainSegmentAction:(id)sender
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
        
        [self showSadSmileView];
    }
    else if (rightMainSegment.selectedSegmentIndex==3) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSmileView];
    }
    else if (rightMainSegment.selectedSegmentIndex==4) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSettingView];
    }
    else if (rightMainSegment.selectedSegmentIndex==5) {
        
        [btnAddTak setHidden:FALSE];
        
        [self showContactView];
    }
    else if (rightMainSegment.selectedSegmentIndex==6) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUpdateStatusView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==7) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUploadView];
        
    }
    else if (rightMainSegment.selectedSegmentIndex==8) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showMessageView];
        
    }
    else
    {
        [self removeView];
        
    }
}
-(IBAction)familyTopRightMainSegmentAction:(id)sender
{
    [self removeView];
    
    if (FamilyTopRightMainSegment.selectedSegmentIndex==0) {
        
        [btnAddTak setHidden:FALSE];
        [self showCalenderView];
    }
    else if (FamilyTopRightMainSegment.selectedSegmentIndex==1) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSadSmileView];
    }
    else if (FamilyTopRightMainSegment.selectedSegmentIndex==2) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSmileView];
    }
    else if (FamilyTopRightMainSegment.selectedSegmentIndex==3) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showSettingView];
    }
    else if (FamilyTopRightMainSegment.selectedSegmentIndex==4) {
        
        [btnAddTak setHidden:FALSE];
        
        [self showContactView];
    }
    else if (FamilyTopRightMainSegment.selectedSegmentIndex==5) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUpdateStatusView];
        
    }
    else if (FamilyTopRightMainSegment.selectedSegmentIndex==6) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showUploadView];
        
    }
    else if (FamilyTopRightMainSegment.selectedSegmentIndex==7) {
        
        [btnAddTak setHidden:TRUE];
        
        [self showMessageView];
        
    }
    else
    {
        [self removeView];
        
    }
}
-(IBAction)clockInSwitchAction:(id)sender
{
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
-(IBAction)btnAddContactAction:(id)sender
{
    actionSheetbutton = (UIButton *)sender;
    [self dismissActionSheets];
    
    if (nil == self.normalActionSheetDelegate)
    {
        self.normalActionSheetDelegate = [[NormalActionSheetDelegate alloc] init];
        self.normalActionSheetDelegate.normalDelegate = self;
    }
    
    if (nil == self.activeSheet)
    {
        UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Invite Contacts:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Device Contacts", @"App Contacts", nil];
        self.activeSheet = normalActionSheet;
        self.activeSheet.tag = AC_ACTIONSHEET_INVITE_CONTACTS;
    }
    [self.activeSheet showFromRect:((UIButton*)sender).frame inView:self.view animated:YES];
    
    
}
-(IBAction)addTaskAction:(id)sender
{
    NSLog(@"%@",sharedAppDelegate.calenderCurrentDate);
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
        
        if (FamilyTopRightMainSegment.selectedSegmentIndex==0) {
            
            if (sharedAppDelegate.calenderCurrentDate==nil || sharedAppDelegate.calenderCurrentDate==(NSString*)[NSNull null] || [sharedAppDelegate.calenderCurrentDate isEqualToString:@""]) {
                
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
                sharedAppDelegate.calenderServerDate = [dateformate stringFromDate:[NSDate date]];
                sharedAppDelegate.calenderCurrentDate=[self shortStyleDate:[NSDate date]];
                
            }
            
            FamilyTopRightMainSegment.selectedSegmentIndex=0;
            [self.objAddNewTaskVC.view removeFromSuperview];
            
            if (IS_DEVICE_IPAD) {
                
                self.objAddNewTaskVC = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
                
            }
            else
            {
                self.objAddNewTaskVC = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
                
            }
            
            //addTask.delegate = self;
            
            if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null] || [self.selectedTag.tagId isEqualToString:@""]) {
                
                self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
                self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
                
            }
            else
            {
                self.objAddNewTaskVC.selectedTagId=self.selectedTag.tagId;
                self.objAddNewTaskVC.selectedTag=self.selectedTag.tagTitle;
                self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
                self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
                
            }
            
            [self.rightInnerView addSubview:self.objAddNewTaskVC.view];
            
        }
        else
        {
            actionSheetbutton = (UIButton *)sender;
            [self dismissActionSheets];
            
            if (nil == self.normalActionSheetDelegate)
            {
                self.normalActionSheetDelegate = [[NormalActionSheetDelegate alloc] init];
                self.normalActionSheetDelegate.normalDelegate = self;
            }
            
            if (nil == self.activeSheet)
            {
                UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Invite Contacts:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Device Contacts", @"App Contacts", nil];
                self.activeSheet = normalActionSheet;
                self.activeSheet.tag = AC_ACTIONSHEET_INVITE_CONTACTS;
            }
            [self.activeSheet showFromRect:((UIButton*)sender).frame inView:self.rightInnerView animated:YES];
            
        }

    }
    else
    {
        if (rightMainSegment.selectedSegmentIndex==0) {
            
            if (sharedAppDelegate.calenderCurrentDate==nil || sharedAppDelegate.calenderCurrentDate==(NSString*)[NSNull null] || [sharedAppDelegate.calenderCurrentDate isEqualToString:@""]) {
                
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
                sharedAppDelegate.calenderServerDate = [dateformate stringFromDate:[NSDate date]];
                sharedAppDelegate.calenderCurrentDate=[self shortStyleDate:[NSDate date]];
                
            }
            
            rightMainSegment.selectedSegmentIndex=0;
            [self.objAddNewTaskVC.view removeFromSuperview];
            
            if (IS_DEVICE_IPAD) {
                
                self.objAddNewTaskVC = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC" bundle:nil];
                
            }
            else
            {
                self.objAddNewTaskVC = [[AddNewTaskVC alloc] initWithNibName:@"AddNewTaskVC_iphone" bundle:nil];
                
            }
            
            //addTask.delegate = self;
            
            if (self.selectedTag.tagId==nil || self.selectedTag.tagId==(NSString*)[NSNull null] || [self.selectedTag.tagId isEqualToString:@""]) {
                
                self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
                self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
                
            }
            else
            {
                self.objAddNewTaskVC.selectedTagId=self.selectedTag.tagId;
                self.objAddNewTaskVC.selectedTag=self.selectedTag.tagTitle;
                self.objAddNewTaskVC.selectedDate=sharedAppDelegate.calenderCurrentDate;
                self.objAddNewTaskVC.serverDate=sharedAppDelegate.calenderServerDate;
                
            }
            
            [self.rightInnerView addSubview:self.objAddNewTaskVC.view];
            
        }
        else
        {
            actionSheetbutton = (UIButton *)sender;
            [self dismissActionSheets];
            
            if (nil == self.normalActionSheetDelegate)
            {
                self.normalActionSheetDelegate = [[NormalActionSheetDelegate alloc] init];
                self.normalActionSheetDelegate.normalDelegate = self;
            }
            
            if (nil == self.activeSheet)
            {
                UIActionSheet *normalActionSheet = [[UIActionSheet alloc] initWithTitle:@"Invite Contacts:" delegate:self.normalActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Device Contacts", @"App Contacts", nil];
                self.activeSheet = normalActionSheet;
                self.activeSheet.tag = AC_ACTIONSHEET_INVITE_CONTACTS;
            }
            [self.activeSheet showFromRect:((UIButton*)sender).frame inView:self.rightInnerView animated:YES];
            
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
-(IBAction)btnBackPackPressed:(id)sender
{
    self.objBackPackViewCOntroller=[[BackPackViewController alloc] init];
    [self.rightInnerView addSubview:self.objBackPackViewCOntroller.view];
}
-(IBAction)btnOCRAction:(id)sender
{
    self.objOCRReceiptListViewController=[[OCRReceiptListViewController alloc] initWithNibName:@"OCRReceiptListViewController" bundle:nil];
    [rightInnerView addSubview:self.objOCRReceiptListViewController.view];
}

#pragma mark Share PDF delegate and methods--------

- (void)requestSendChatText
{
    ContactD *c = [self.contactEmailArr objectAtIndex:selectedIndex];
    
    NSString* strMemberId = c.userid;
    
    NSMutableDictionary* dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dictionary setValue:pdfNameStr forKey:@"file"];
    [dictionary setValue:@"2" forKey:@"textType"];
    [dictionary setValue:strMemberId forKey:@"member_id"];
    
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
    
    [self.popoverController  presentPopoverFromRect:CGRectMake(300,185, 35, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)getContactList
{
    if([ConfigManager isInternetAvailable]){
        
        [self.contactEmailArr removeAllObjects];
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
        checkSharePDF=TRUE;
        
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
    
    tblLeftFeedView.frame = CGRectMake(tblLeftFeedView.frame.origin.x, 244, tblLeftFeedView.frame.size.width, self.view.frame.size.height-385);
    [tblLeftFeedView setBackgroundColor:[UIColor clearColor]];

    return pdfData;
}


#pragma mark- NormalActionSheetDelegate

-(void)dismissActionSheets
{
    if (self.activeSheet)
    {
        if ([self.activeSheet isVisible])
        {
            [self.activeSheet dismissWithClickedButtonIndex:-1 animated:YES];
        }
        self.activeSheet = nil;
    }
}

-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_INVITE_CONTACTS)
    {
        
        if(buttonIndex==0){
            
            [self performSelector:@selector(showDeviceContact) withObject:nil afterDelay:0.2];
            
        }
        else if(buttonIndex==1){
            
            /* AddContactsVC *addContacts;
             
             if (IS_DEVICE_IPAD) {
             
             addContacts = [[AddContactsVC alloc] initWithNibName:@"AddContactsVC" bundle:nil];
             }
             else
             {
             addContacts = [[AddContactsVC alloc] initWithNibName:@"AddContactsVC_iphone" bundle:nil];
             }
             
             
             [self.navigationController pushViewController:addContacts animated:YES];*/
            
            [self performSelector:@selector(showAddContactPopOver) withObject:nil afterDelay:0.5];
            
        }
    }
    else if(actionSheet.tag == AC_ACTIONSHEET_INVITE_VIA_IMESSAGE)
    {
        [self openMessageComposer:[arrEmail objectAtIndex:buttonIndex]];
    }
}
-(void)showDeviceContact
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)showAddContactPopOver
{
    if (IS_DEVICE_IPAD) {
        
        self.objAddContactView=[[AddContactsVC alloc] initWithNibName:@"AddContactsVC" bundle:nil];
        
        self.objAddContactView.preferredContentSize = CGSizeMake(350, 700);
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objAddContactView];
        
        self.popoverController.popoverContentSize= CGSizeMake(350, 700);
        
        [self.popoverController presentPopoverFromRect:btnAddTak.frame inView:self.rightInnerView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        
    }
    
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    
}
#pragma mark- ABAddressBookDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    //[self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:^{
        
        if(!IS_DEVICE_IPAD)
        {
            // open message composer with phone number
            ABMultiValueRef phoneNumbers = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSString* phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            
            CFRelease(phoneNumbers);

            if(!phoneNumber)
            {
                [self performSelector:@selector(openMessageComposer:) withObject:phoneNumber afterDelay:0.0f];
            }
            
        }
        else{
            // open message composer with email
            if(arrEmail!=nil){
                [arrEmail removeAllObjects];
                arrEmail = nil;
            }
            arrEmail = [[NSMutableArray alloc] init];
            
            ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
            if (ABMultiValueGetCount(multi) > 0) {
                // collect all emails in array
                for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
                    CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, i);
                    [arrEmail addObject:(__bridge NSString *)emailRef];
                    CFRelease(emailRef);
                }
            }
            
            if([arrEmail count]>0)
            {
                
                self.opt = [[OptionsPopOverVC alloc] initWithTitleLabel:[UIColor clearColor] textColor:TEXT_COLOR_BLUE title:@"Select E-mail for iMessage" data:arrEmail delegate:self];
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.opt];
                [self.popoverController presentPopoverFromRect:CGRectMake(120, 350, 250, 230) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                [self.popoverController setPopoverContentSize:CGSizeMake(250, 230)];
                
            }
            else {
                [ConfigManager showAlertMessage:nil Message:@"No E-mail configured with this contact"];
            }
        }
    }];
    
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark- ------
-(void)popoverOptionDidSelected:(NSString*)value
{
    
    if(self.popoverController)
    {
        [self.popoverController dismissPopoverAnimated:YES];
    }
    [self performSelector:@selector(openMessageComposer:) withObject:value afterDelay:0.1f];
}

#pragma mark- -----------

-(void)openMessageComposer:(NSString*)strPhone
{
    if(self.msgComposer!=nil){
        self.msgComposer = nil;
    }
    self.msgComposer = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        self.msgComposer.body = @"Hey!! I am using Amity Care for free calling and text. Download Amity-Care and enjoy.";
        self.msgComposer.recipients = [NSArray arrayWithObjects:strPhone, nil];
       // self.msgComposer.messageComposeDelegate = self;
        [self presentViewController:self.msgComposer animated:YES completion:^{
            
        }];
    }
}


#pragma mark- CallingViewDelegate
-(void)muteBtnDidClicked:(id)sender
{
    
}

-(void)transferCallBtnDidClicked:(id)sender
{
    
}

-(void)speakerBtnDidClicked:(id)sender
{
    
}

-(void)contactsBtnDidClicked:(id)sender
{
    
}



#pragma mark- UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
{
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1
{
    searchBar.showsCancelButton = NO;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    NSLog(@"searchBarSearchButtonClicked text =%@",search.text);
    isSearchEnable=TRUE;
    [self filterContacts:search.text];
    [tblLeftFeedView reloadData];
    [search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    NSLog(@"searchBar =%@ textDidChange  =%@",search.text,searchText);
    
    if(searchText.length==0){
        isSearchEnable = FALSE;
        [tblLeftFeedView reloadData];
    }
    else{
        isSearchEnable=TRUE;
        [self filterContacts:searchText];
        [tblLeftFeedView reloadData];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)search
{
    NSLog(@"searchBarCancelButtonClicked text =%@",search.text);
    
    isSearchEnable=FALSE;
    [searchBar resignFirstResponder];
    
}

#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sec=0;
    
    if (leftSecondSegment.selectedSegmentIndex==4) {
        
        return isSearchEnable?1:[ALPHA_ARRAY count];
    }
    else
    {
        sec=1;
    }
    return sec;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount=0;
    
    if (tableView==tblLeftFeedView) {
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            NSInteger numberOfRows = 0;
            
            NSLog(@"%lu",recordCount);
            NSLog(@"%lu",(unsigned long)[self.arrFeedList count]);
            
            if(recordCount > [self.arrFeedList count])
                
                numberOfRows = [self.arrFeedList count]+1;
            else
                
                numberOfRows = [self.arrFeedList count];
            
            rowCount=numberOfRows;
            
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
            
            height=60;
            
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
        else
        {
            height=44;
        }
        
    }
    else if(tableView==tblViewTagList)
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
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    static NSString *cellIdenitifier = @"ContactEmail";
    
    if (tableView==tblLeftFeedView) {
        
        if (leftSecondSegment.selectedSegmentIndex==0) {
            
            if(indexPath.row < [self.arrFeedList count])
            {
                self.feedCell = (FeedListTableViewCell*)[tblLeftFeedView dequeueReusableCellWithIdentifier:feedCellIdentifier];
                
                if (Nil == self.feedCell)
                {
                    self.feedCell = [FeedListTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                
                Feeds *data=[self.arrFeedList objectAtIndex:indexPath.row];
                
                self.feedCell.lblName.text=data.postUserName;
                self.feedCell.lblIntro.text=data.postDesc;
                self.feedCell.lbldate.text=data.postTime;
                self.feedCell.lblEmail.text=data.postUserEmail;
                
                [self.feedCell.btnFav setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                
                [self.feedCell.btnSadSmile setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                
                [self.feedCell.btnSmile setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                
                
                [self.feedCell.btnLocation setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
                
              /*  if ([sharedAppDelegate.userObj.userId isEqualToString:data.postUserId]) {
                    
                    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                        
                        [self.feedCell.btnFav setHidden:TRUE];
                        
                    }
                    else
                    {
                        [self.feedCell.btnFav setHidden:FALSE];
                        
                    }
                    [self.feedCell.btnLocation setHidden:FALSE];
                    
                    [self.feedCell.btnSadSmile setHidden:TRUE];
                    [self.feedCell.btnSmile setHidden:TRUE];
                    
                    
                    [self.feedCell.btnFav setFrame:CGRectMake(297, self.feedCell.btnFav.frame.origin.y, self.feedCell.btnFav.frame.size.width, self.feedCell.btnFav.frame.size.height)];
                    
                    [self.feedCell.btnLocation setFrame:CGRectMake(322, self.feedCell.btnLocation.frame.origin.y, self.feedCell.btnLocation.frame.size.width, self.feedCell.btnLocation.frame.size.height)];
                    
                }
                else
                {
                    if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                        
                        [self.feedCell.btnFav setHidden:TRUE];
                        
                    }
                    else
                    {
                        [self.feedCell.btnFav setHidden:FALSE];
                        
                    }
                    [self.feedCell.btnLocation setHidden:FALSE];
                    
                    [self.feedCell.btnSadSmile setHidden:FALSE];
                    [self.feedCell.btnSmile setHidden:FALSE];
                    
                    [self.feedCell.btnFav setFrame:CGRectMake(245, self.feedCell.btnFav.frame.origin.y, self.feedCell.btnFav.frame.size.width, self.feedCell.btnFav.frame.size.height)];
                    
                    [self.feedCell.btnLocation setFrame:CGRectMake(270, self.feedCell.btnLocation.frame.origin.y, self.feedCell.btnLocation.frame.size.width, self.feedCell.btnLocation.frame.size.height)];
                }
                */
                
                [self.feedCell.btnLocation setHidden:FALSE];
                
                [self.feedCell.btnSadSmile setHidden:TRUE];
                [self.feedCell.btnSmile setHidden:TRUE];
                [self.feedCell.btnFav setHidden:TRUE];

                                
                [self.feedCell.btnLocation setFrame:CGRectMake(322, self.feedCell.btnLocation.frame.origin.y, self.feedCell.btnLocation.frame.size.width, self.feedCell.btnLocation.frame.size.height)];
                

                self.feedCell.imgView.layer.cornerRadius = floor(self.feedCell.imgView.frame.size.width/2);
                self.feedCell.imgView.clipsToBounds = YES;
                
                
                [self.feedCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,data.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
                
                
                [self.feedCell setBackgroundColor:[UIColor clearColor]];
                
                self.feedCell.lblName.font = [UIFont fontWithName:boldfontName size:15.0];
                self.feedCell.lblIntro.font = [UIFont fontWithName:appfontName size:11.0f];
                
                if ([data.postFavStatus isEqualToString:@"1"]) {
                    
                    [self.feedCell.btnFav setImage:[UIImage imageNamed:@"star_tick"] forState:UIControlStateNormal];
                }
                else
                {
                    [self.feedCell.btnFav setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    
                }
                
                if ([data.postId isEqualToString:@"-1"]) {
                    
                    [self.feedCell.btnFav setHidden:TRUE];
                    [self.feedCell.btnSadSmile setHidden:TRUE];
                    [self.feedCell.btnSmile setHidden:TRUE];
                    
                }
                return self.feedCell;
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
        
        else if(leftSecondSegment.selectedSegmentIndex==1)
        {
            self.inboxCell = (InboxListTableViewCell*)[tblLeftFeedView dequeueReusableCellWithIdentifier:emailCellIdentifier];
            
            if (Nil == self.inboxCell)
            {
                self.inboxCell = [InboxListTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            InboxData *data=[self.arrInboxListing objectAtIndex:indexPath.row];
            
            self.inboxCell.lblDate.text=data.mailDate;
            self.inboxCell.lblSubject.text=data.mailSubject;
            self.inboxCell.lblTitle.text=data.mailFrom;
            
            self.inboxCell.lblMessage.attributedText=data.mail_short_desc;
            
            [self.inboxCell.lblMessage setFont:[UIFont systemFontOfSize:14]];
            
            [self.inboxCell.lblMessage setTextColor:[UIColor lightGrayColor]];
            
            if(data.mailAttechment!=nil )
            {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attachment.png"]] ;
                imageView.frame =CGRectMake(0, 0, 18, 18);
                self.inboxCell.accessoryView = imageView;
            }
            
            [self.inboxCell setBackgroundColor:[UIColor clearColor]];
            return self.inboxCell;
            
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
        
        if(leftSecondSegment.selectedSegmentIndex==0)
        {
            [self.popoverController dismissPopoverAnimated:YES];
            
            Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
            
            UITableViewCell *cell = [tblLeftFeedView cellForRowAtIndexPath:indexPath];
            
            
            if ([feed.postType isEqualToString:@"6"]) {
                
                self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController" bundle:nil];
                
                self.objFormFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objFormFeedDetailViewController.feedDetails=feed;
                
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
                self.objFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objFeedDetailViewController.feedDetails=feed;
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objFeedDetailViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                
                [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
        }
        else if (leftSecondSegment.selectedSegmentIndex==1) {
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            
            UITableViewCell * cell = [tblLeftFeedView cellForRowAtIndexPath:indexPath];
            
            self.objInboxDetailViewController=[[InboxDetailViewController alloc] init];
            
            self.objInboxDetailViewController.arrMailData=[[NSMutableArray alloc] initWithArray:self.arrInboxListing];
            self.objInboxDetailViewController.selectedIndex=indexPath.row;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objInboxDetailViewController];
            
            self.popoverController.popoverContentSize= CGSizeMake(450, 700);
            
            [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            
        }
       
        
    }
    else if (tableView==tblViewTagList)
    {
        [self.popoverController dismissPopoverAnimated:YES];
        [tblLeftFeedView reloadData];
    }
    else
    {
        [self.popoverController dismissPopoverAnimated:YES];
        
        selectedIndex = indexPath.row;
        
        NSData *pdfData = [self pdfDataWithTableView:tblLeftFeedView];
        
        if([ConfigManager isInternetAvailable])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:@"attachment" forKey:@"attachment_key"];
            [dict setObject:@"uploadPdf" forKey:@"request_path"];
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            
            [dict setObject:@"test.pdf" forKey:@"filename"];
            [dict setObject:@"pdf" forKey:@"content_type"];
            [[AmityCareServices sharedService] uploadDocInvocation:dict uploadData:pdfData delegate:self];
        }
        
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (leftSecondSegment.selectedSegmentIndex==4) {
        
        return isSearchEnable?nil:ALPHA_ARRAY;
        
    }
    else
    {
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
           return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 525, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0f];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 500, HEADER_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:appfontName size:15.0f];
    label.text = [ALPHA_ARRAY objectAtIndex:section];
    [headerView addSubview:label];
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (leftSecondSegment.selectedSegmentIndex==4) {
        
        return isSearchEnable?@"":[ALPHA_ARRAY objectAtIndex:section];
        
    }
    else
    {
        return nil;
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
    
    if(leftSecondSegment.selectedSegmentIndex==1)
    {
        self.selectedIndxpath = indexPath;
        
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Mail ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_DELETE_MAIL_CONFIRMATION;
        [deleteAlert show];
    }
    
    else if(leftSecondSegment.selectedSegmentIndex==2)
    {
        self.selectedIndxpath = indexPath;
        
        ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Notification ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
        [deleteAlert show];
    }
 
    
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    if (leftSecondSegment.selectedSegmentIndex==2) {
    
        if([ConfigManager isInternetAvailable]){
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
            
            NSString *pageIndexStr=[NSString stringWithFormat:@"%lu",pageIndex];
            
            [[AmityCareServices sharedService] getNotificationList:sharedAppDelegate.userObj.userId page_index:pageIndexStr delegate:self];
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
        [self.normalSearchDic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        
        if([ConfigManager isInternetAvailable]) {
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Processing please wait..." width:200];
            
            if (leftSecondSegment.selectedSegmentIndex==0) {
                
                [[AmityCareServices sharedService] SortUserFeedsDateWiseInvocation:self.normalSearchDic delegate:self];
                
            }
            else
            {
                [[AmityCareServices sharedService] SortUserStatusDateWiseInvocation:self.normalSearchDic delegate:self];
                
            }
        }
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
    else
    {
        if([ConfigManager isInternetAvailable]) {
            
            if (leftSecondSegment.selectedSegmentIndex==0) {
                
                [self requestGetTagFeeds:[NSNumber numberWithUnsignedLong:pageIndex]];
                
            }
            else
            {
                [self requestForUserStatusList:[NSNumber numberWithUnsignedLong:pageIndex]];
            }
        }
        
        else{
            
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
    
}
#pragma mark- UIALERTVIEW
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if(alertView.alertTag == AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]) {
                
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
    
    else if(alertView.alertTag == AC_ALERTVIEW_ALL_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]) {
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                NSMutableDictionary *dic = [NSMutableDictionary new];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"userId"];
                
                [[AmityCareServices sharedService] deleteAllNotificationDelegate:dic delegate:self];
                
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
        }
    }
    
    else if(alertView.alertTag == AC_ALERTVIEW_DELETE_MAIL_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]) {
                
                InboxData* inbox = [self.arrNotificationList objectAtIndex:self.selectedIndxpath.row];
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                NSMutableDictionary *dic = [NSMutableDictionary new];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"userId"];
                
                [[AmityCareServices sharedService] DeleteUserEmailInvocation:sharedAppDelegate.userObj.userId emailId:inbox.mailId delegate:self];
                
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
        }
    }
    
}

#pragma mark -Invocation Delegates

#pragma mark- UpdateStatusDelegate

-(void)statusDidUpdate:(UIView *)statusView newStatus:(Status *)status status:(BOOL)isUpdated
{
    /*if(isUpdated){
     
     isClockInFeedAdded = FALSE;
     [self.arrFeedList removeAllObjects];
     
     pageIndex=1;
     
     leftSecondSegment.selectedSegmentIndex=2;
     
     [self performSelector:@selector(requestForUserStatusList:) withObject:[NSNumber numberWithInt:pageIndex] afterDelay:0.1f];
     }*/
}

#pragma mark - get Feed List invocation Delegates

-(void)UserFeedListInvocationDidFinish:(UserFeedListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            // descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
            
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
                
                
                NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
                if(clockinTime && !isClockInFeedAdded)
                {
                    
                    recordCount = recordCount+1;

                    Feeds *clockInFeed = [[Feeds alloc] init];
                    
                    clockInFeed.postUserId = sharedAppDelegate.userObj.userId;
                    clockInFeed.postUserEmail = sharedAppDelegate.userObj.default_email;
                    
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
                        
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]       stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
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
                    
                    
                    NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                    
                    
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
                        // clockInFeed.trainingStatusStr   = NULL_TO_NIL([response valueForKey:@"training"]);
                        clockInFeed.bsStatusStr         = NULL_TO_NIL([response valueForKey:@"BS"]);
                        
                        NSLog(@"EMployee %@",clockInFeed.employeeStatusStr);
                        
                        NSLog(@"EMployee %@",clockInFeed.managerStatusStr);
                        
                        
                        clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                        
                        [self.arrFeedList insertObject:clockInFeed atIndex:0];
                        
                        isClockInFeedAdded = !isClockInFeedAdded;
                    }
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
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
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [btnShare setHidden:TRUE];
            
        }
        else
        {
            [btnShare setHidden:FALSE];
            
        }
        [DSBezelActivityView removeView];
    }
}
-(void)UserStatusListInvocationDidFinish:(UserStatusListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            // descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
            
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
                
                
                NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
               
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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]
                                         stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
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
                     
                     NSLog(@"EMployee %@",clockInFeed.employeeStatusStr);
                     
                     NSLog(@"EMployee %@",clockInFeed.managerStatusStr);
                     
                     
                     clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                     
                     [self.arrFeedList insertObject:clockInFeed atIndex:0];
                     
                     isClockInFeedAdded = !isClockInFeedAdded;
                     }*/
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
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
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
            
            [btnShare setHidden:TRUE];
            
        }
        else
        {
            [btnShare setHidden:FALSE];
            
        }
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


#pragma mark - Form List Invocation Delegates

- (void)getFormNameInvocationDidFinish:(GetFormNameInvacation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFormNameInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            [self.formNameArr removeAllObjects];
            [self.formsArr removeAllObjects];
            NSString* strSuccess = NULL_TO_NIL([dict valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                NSArray* formTag = [dict valueForKey:@"FormTag"];
                
                if([formTag count]>0)
                {
                    for (int i=0; i < [formTag count]; i++)
                    {
                        Form *form = [[Form alloc] init];
                        
                        NSDictionary *fDict = [formTag objectAtIndex:i];
                        
                        form.strFormId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                        form.strFormTitleStr = NULL_TO_NIL([fDict valueForKey:@"title"]);
                        
                        [self.formNameArr addObject:NULL_TO_NIL([fDict valueForKey:@"title"])];
                        
                        form.arrStructue = [[NSMutableArray alloc ]  init];
                        
                        NSArray *formStructure = NULL_TO_NIL([fDict valueForKey:@"structure"]);
                        
                        for (int j = 0; j <[formStructure count]; j++)
                        {
                            NSDictionary *inner = [formStructure objectAtIndex:j];
                            
                            FormsField *ff = [[FormsField alloc] init];
                            
                            ff.strFieldRequired = NULL_TO_NIL([inner valueForKey:@"required"]);
                            ff.strFieldType = NULL_TO_NIL([inner valueForKey:@"type"]);
                            
                            ff.strCSSClass = NULL_TO_NIL([inner valueForKey:@"cssClass"]);
                            
                            NSLog(@"Value %@",[inner valueForKey:@"values"]);
                            if ([ff.strFieldType caseInsensitiveCompare:@"checkbox"] == NSOrderedSame)
                            {
                                ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                            }
                            
                            else if ([ff.strFieldType caseInsensitiveCompare:@"radio"] == NSOrderedSame)
                            {
                                ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                            }
                            
                            else if ([ff.strFieldType caseInsensitiveCompare:@"select"] == NSOrderedSame)
                            {
                                ff.arrValues = NULL_TO_NIL([inner valueForKey:@"values"]);
                                ff.strTitle = NULL_TO_NIL([inner valueForKey:@"title"]);
                            }
                            
                            else
                                ff.strFieldValue = NULL_TO_NIL([inner valueForKey:@"values"]);
                            
                            NSLog(@"ff.arrValues %@",ff.arrValues);
                            NSLog(@"ff.strFieldValue %@",ff.strFieldValue);
                            NSLog(@"ff.strFieldValue %@",ff.strTitle);
                            
                            [form.arrStructue addObject:ff];
                        }
                        [self.formsArr addObject:form];
                    }
                    
                    if ([self.formNameArr count] == 1)
                    {
                        FormListVC *flvc;
                        
                        if (IS_DEVICE_IPAD) {
                            
                            flvc= [[FormListVC alloc] initWithNibName:@"FormListVC" bundle:nil];
                            
                        }
                        else
                        {
                            flvc= [[FormListVC alloc] initWithNibName:@"FormListVC_iphone" bundle:nil];
                            
                        }
                        flvc.formData = [self.formsArr objectAtIndex:0];
                        flvc.formNameStr = [self.formNameArr objectAtIndex:0];
                        [self.navigationController pushViewController:flvc animated:YES];
                    }
                    else if([self.formNameArr count] > 1)
                    {
                        // [self showFeedView];
                    }
                }
                else
                {
                    [self.formNameArr removeAllObjects];
                    [self.formsArr removeAllObjects];
                    [ConfigManager showAlertMessage:nil Message:@"No Form found"];
                }
                
            }
            else
            {
                [self.formNameArr removeAllObjects];
                [self.formsArr removeAllObjects];
                [ConfigManager showAlertMessage:nil Message:@"No form found"];
            }
            
        }
        else
        {
            [self.formNameArr removeAllObjects];
            [self.formsArr removeAllObjects];
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView];
    }
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
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]>0){
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        Feeds *feed = [[Feeds alloc] init];
                        
                        NSDictionary *fDict = [post objectAtIndex:i];
                        
                        feed.postUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.postUserName = NULL_TO_NIL([fDict valueForKey:@"username"]);
                        feed.postUserImgURL = NULL_TO_NIL([fDict valueForKey:@"user_img"]);
                        feed.postId = NULL_TO_NIL([fDict valueForKey:@"post_id"]);
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
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



-(void)SortUserFeedsDateWiseInvocationDidFinish:(SortUserFeedsDateWiseInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            [self.tenHashTagArr removeAllObjects];
            
            self.tenHashTagArr = NULL_TO_NIL([[response valueForKey:@"topHasTag"] mutableCopy]);
            
            // descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
            
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
                
                
                NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
              
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
                        feed.postTagId =[NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])] ;
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
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
                    
                    
                    NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                    
                    
                    
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
                        
                        NSLog(@"Employee %@",clockInFeed.employeeStatusStr);
                        
                        NSLog(@"Employee %@",clockInFeed.managerStatusStr);
                        
                        
                        clockInFeed.arrSimiliarTags = [NSMutableArray arrayWithObjects:self.selectedTag, nil];
                        
                        [self.arrFeedList insertObject:clockInFeed atIndex:0];
                        
                        isClockInFeedAdded = !isClockInFeedAdded;
                    }
                }
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                
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
-(void)SortUserStatusDateWiseInvocationDidFinish:(SortUserStatusDateWiseInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            [self.tenHashTagArr removeAllObjects];
            
            self.tenHashTagArr = NULL_TO_NIL([[response valueForKey:@"topHasTag"] mutableCopy]);
            
            // descriptionTxtView.text = NULL_TO_NIL([response valueForKey:@"tagIntro"]);
            
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
                
                
                NSString* clockinTime = NULL_TO_NIL([response valueForKey:@"clock_in_date"]);
                
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
                        feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                        
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]
                                         stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
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
                
                [tblLeftFeedView reloadData];
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

#pragma mark- Get Inbox list Invocation

-(void)UserEmailListInvocationDidFinish:(UserEmailListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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

-(void)getNotificationInvocationDidFinish:(GetNotificationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getNotificationInvocationDidFinish =%@",dict);
    @try {
        if(!error){
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = [response valueForKey:@"success"];
            recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];

            
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
        }    }
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

- (void)deleteAllInvocationDidFinish:(DeleteAllNotificationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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
#pragma mark- Get Amity Contacts list Invocation

-(void)getAmityContactsListDidFinish:(GetAmityContactsList *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    if (!error) {
        
        if (checkSharePDF==TRUE) {
            
            checkSharePDF=FALSE;
            
            NSLog(@"getAmityContactsListDidFinish =%@",dict);
            @try {
                
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
                        
                        [self.contactEmailArr addObject:c];
                        
                    }
                    
                    [self showContactList];
                    
                }
                else if ([strSuccess rangeOfString:@"false"].length>0){
                    [ConfigManager showAlertMessage:nil Message:@"No Contacts found"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"EXception Contact =%@",[exception debugDescription]);
            }
            @finally {
                [DSBezelActivityView removeView];
            }
            
        }
        else
        {
            [self.arrContactsList removeAllObjects];
            [self.arrSearchList removeAllObjects];
            
            NSLog(@"getAmityContactsListDidFinish =%@",dict);
            @try {
                
                id response = [dict valueForKey:@"response"];
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if([strSuccess rangeOfString:@"true"].length>0){
                    
                    NSMutableArray * contactArr = [[NSMutableArray alloc] init];
                    
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
                        id sDict = NULL_TO_NIL([cDict objectForKey:@"sip_details"]);
                        
                        if(sDict)
                        {
                            c.sip = [[SipAcDetails alloc] init];
                            c.sip.ipAddress = [sDict valueForKey:   @"sipipaddress"];
                            c.sip.password = [sDict valueForKey:    @"sippassword"];
                            c.sip.username = [sDict valueForKey:    @"sipusername"];
                        }
                        
                        [contactArr addObject:c];
                        
                        BOOL isExists = [[SqliteManager sharedManager] checkRecordExists:c];
                        
                        if(!isExists){
                            BOOL status = [[SqliteManager sharedManager] addContact:c];
                            NSLog(@"add contact status =%d",status);
                        }
                    }
                    
                    [self createSectionList:contactArr];
                    
                }
                else if ([strSuccess rangeOfString:@"false"].length>0){
                    [ConfigManager showAlertMessage:nil Message:@"No Contacts found"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"EXception Contact =%@",[exception debugDescription]);
            }
            @finally {
                [DSBezelActivityView removeView];
                
                tblLeftFeedView.userInteractionEnabled = YES;
                
                id response = [dict valueForKey:@"response"];
                NSString* strCount = [response valueForKey:@"unreadCount"];//Dharmbir210814
                
                sharedAppDelegate.unreadContactCount = [strCount integerValue];
                
                NSLog(@"Count %ld",(long)[strCount integerValue]);
                
                /*if(sharedAppDelegate.unreadContactCount>=0)
                 {
                 [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_CONTACT_RECIEVE object:nil];
                 }*/
            }
            
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
    
}

#pragma mark- Delete Contact Invocation

-(void)deleteContactInvocationDidFinish:(DeleteContactInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"deleteContactInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                NSString* sip_uname = ((ContactD*)[[self.arrContactsList objectAtIndex:self.selectedIndxpath.section] objectAtIndex:self.selectedIndxpath.row]).sip.username;
                
                BOOL status = [[SqliteManager sharedManager] deleteContact:sip_uname];
                NSLog(@"Contact delte status = %d",status);
                
                [((NSMutableArray*)[self.arrContactsList objectAtIndex:self.selectedIndxpath.section]) removeObjectAtIndex:self.selectedIndxpath.row];
                
                [tblLeftFeedView beginUpdates];
                [tblLeftFeedView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndxpath, nil] withRowAnimation:UITableViewRowAnimationLeft];
                [tblLeftFeedView endUpdates];
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                [ConfigManager showAlertMessage:nil Message:@"Cantact not deleted"];
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

#pragma mark- Update Contact Notification Invocation

- (void)updateContactNotificationInvocationDidFinish:(UpdateContactNotificationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"Response Dic %@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        
        if([strSuccess rangeOfString:@"true"].length>0){
            
            [self requestForContactList];
        }
        else
            tblLeftFeedView.userInteractionEnabled = YES;
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
}

- (void)userAcceptanceInvocationDidFinish:(AcceptanceInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"Response Dic %@",dict);
    
    [DSBezelActivityView removeView];
    
    if (!error) {
        
        [self requestForContactList];
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
}

#pragma mark- delete mail notification Invocation

-(void)DeleteUserEmailInvocationDidFinish:(DeleteUserEmailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    {
        NSLog(@"DeleteUserEmailInvocationDidFinish =%@",dict);
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
            [self.arrFeedList removeAllObjects];
            isClockInFeedAdded=FALSE;
            
            
            
            pageIndex=1;
            [self parseData];
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

-(void)OfflineMessageInvocationDidFinish:(OfflineMessageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    [DSBezelActivityView removeView];
    
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
        popoverController.delegate=self;
        
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
        popoverController.delegate=self;
        
        txtEndDate.inputView=datePicker;
        
        [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
        [popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        return TRUE;
    }
    
    return false;
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


-(void)filterContacts:(NSString*)text
{
  
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (leftMainSegment.selectedSegmentIndex==0) {
        
        if (leftSecondSegment.selectedSegmentIndex==4) {
            
            if (btnFirstSearch.tag==0) {
                
                isSearchEnable=TRUE;
                [self filterContacts:txtSearch.text];
                [tblLeftFeedView reloadData];
                [txtSearch resignFirstResponder];
                
            }
        }
    }
    return TRUE;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==txtEndDate ||textField==txtStartDate) {
        
    }
    else
    {
        if (leftMainSegment.selectedSegmentIndex==0) {
            
            if (leftSecondSegment.selectedSegmentIndex==4) {
                
                if (btnFirstSearch.tag==0) {
                    
                    NSLog(@"%@",textField.text);
                    NSLog(@"%lu",(unsigned long)textField.text.length);
                    
                    if(textField.text.length==0){
                        
                        isSearchEnable = FALSE;
                        [tblLeftFeedView reloadData];
                        
                    }
                    else if(textField.text.length==1 && ![textField.text isEqualToString:@""]){
                        
                        isSearchEnable = FALSE;
                        [tblLeftFeedView reloadData];
                    }
                    else{
                        isSearchEnable=TRUE;
                        [self filterContacts:textField.text];
                        [tblLeftFeedView reloadData];
                    }
                    
                }
                
            }
            
        }
        
    }
    
    return TRUE;
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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
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
