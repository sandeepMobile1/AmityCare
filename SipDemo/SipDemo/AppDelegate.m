//
//  AppDelegate.m
//  SipDemo
//
//  Created by Shweta Sharma on 09/06/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

//Notifications are not fixed for tagged user list that are selected

#import "AppDelegate.h"
#import "TestViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "MFSideMenuContainerViewController.h"
#import "Reachability.h"
#include "version.h"
#import "RecentCall.h"
#import "RWTItem.h"
#import "QSStrings.h"
#import "IBeaconD.h"
#import "AppSetting.h"
#import "UserTagsVC.h"

#import "ACAlertView.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "PinAlertViewController.h"
#import "Common.h"
#import "SqliteManager.h"
#import "UserHomeViewController.h"
#import "IphoneUserViewController.h"
#import "RightMenuViewController.h"
#import "RecentCall.h"
#include <unistd.h>
#import "Reachability.h"
#if defined(CYDIA) && (CYDIA == 1)
#import <CFNetwork/CFNetwork.h>
#include <sys/stat.h>
#endif
#define THIS_FILE "AppDelegate.m"
#define kDelayToCall 10.0

static NSString *kVoipOverEdge = @"siphonOverEDGE";

typedef enum ConnectionState {
    DISCONNECTED,
    IN_PROGRESS,
    CONNECTED,
    ERROR
} ConnectionState;

@interface UIApplication ()

- (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;
- (void)addStatusBarImageNamed:(NSString *)imageName removeOnExit:(BOOL)remove;
- (void)addStatusBarImageNamed:(NSString *)imageName;
- (void)removeStatusBarImageNamed:(NSString *)imageName;

@end
NSDictionary *launchDict;

@interface AppDelegate ()<SINManagedPushDelegate>

@property (nonatomic, readwrite, strong) id<SINManagedPush> push;

@end

NSString * const kRWTStoredItemsKey = @"storedItems";

@implementation AppDelegate

@synthesize objTestViewController,window,navigationController,callingView,tagNavigation,isConnected,globalNavigation,alertviw,objPinAlertViewController;

@synthesize selectedTag,launchDefault,isPortrait;
@synthesize savedAudioPath,strCheckUserAndTag,_hostReach,_phoneNumber;
@synthesize unreadContactCount,clockInStatus,dicRouteDetail,mapRouteData,checkSpecialGroupChat,strScheduleTagId,strScheduleTagName,strUpdatedTagIntro,recorderFilePath,startBackgroundLatitude,calendarVisibleStatus,
startBackgroundLongitude,
endBackgroundLatitude,
endBackgroundLongitude,isRecording,arrIBeaconsList,offlineMemberId,audioData,beaconsProximity,strCheckDrawLine,arrInRangeIbeacons,items,centralManager,unreadSpecialGroupChatCount,unreadGroupChatCount,unreadUserNotifiationCount,checkBlankSmoothLineView,dropBoxContentD,userObj,acContactsVC,objIphoneUserViewController,objUserHomeViewController,contactObj,locationManager,unreadMsgCount,recentsViewController,strSelectedTagId,unreadTagCount,unreadNotifications,strSelectedTag,strDeviceToken,checkSlideMenuAction,calenderCurrentDate,calenderServerDate,container,routeImage,strCallUserId,strCallUserName,uploadRecieptTagId,uploadRecieptTagName,selectedBeacon,fMinorValue,fMajorValue,fDeviceName,fDeviceId,uuid,beaconsArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"sssss");
    
    isConnected = FALSE;
    
#if defined(CYDIA) && (CYDIA == 1)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [NSString stringWithFormat:@"%@/Siphon", [paths objectAtIndex:0]];
    mkdir([libraryDirectory UTF8String], 0755);
#endif
    
    ///  self.client.callClient.delegate = self;
    
    
    [self handleLocalNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]];
    
    [self requestUserNotificationPermission];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UserDidLoginNotification"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) { [self initSinchClientWithUserId:note.userInfo[@"userId"]]; }];
    
    
    self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentAutomatic];
    self.push.delegate = self;
    [self.push setDesiredPushTypeAutomatically];
    [self.push registerUserNotificationSettings];
    
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation == 0)
    {
        isPortrait=YES;
    }
    else if(orientation == UIInterfaceOrientationPortrait || orientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        isPortrait=YES;
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        isPortrait=NO;
        
    }
    
    counterTask = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{ }];
    
    if (IS_DEVICE_IPAD) {
        
        self.objUserHomeViewController = [[UserHomeViewController alloc] initWithNibName:@"UserHomeViewController" bundle:nil];
        
        //self.objUserHomeViewController.phoneCallDelegate=self;
        
        self.acContactsVC = [[ACContactsVC alloc] initWithNibName:@"ACContactsVC" bundle:nil];
        
        self.acContactsVC.phoneCallDelegate=self;
        
        self.callingView = [[CallingView alloc] initWithNibName:@"CallingView" bundle:nil];
    }
    else
    {
        self.objIphoneUserViewController = [[IphoneUserViewController alloc] initWithNibName:@"IphoneUserViewController" bundle:nil];
        
        //self.objIphoneUserViewController.phoneCallDelegate=self;
        
        self.acContactsVC = [[ACContactsVC alloc] initWithNibName:@"ACContactsVC_iphone" bundle:nil];
        
        self.acContactsVC.phoneCallDelegate=self;
        
        self.callingView = [[CallingView alloc] initWithNibName:@"CallingView_iphone" bundle:nil];
    }
    
    
    isConnected = FALSE;
    
    [self initModel];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //[self initUserDefaults];
    
    {
        NSString *server = [userDef stringForKey: @"proxyServer"];
        NSArray *array = [server componentsSeparatedByString:@","];
        NSEnumerator *enumerator = [array objectEnumerator];
        while (server = [enumerator nextObject])
            if ([server length])break;// {[server retain]; break;}
        //[enumerator release];
        // [array release];
        if (!server || [server length] < 1)
            server = [userDef stringForKey: @"server"];
        
        NSRange range = [server rangeOfString:@":"
                                      options:NSCaseInsensitiveSearch|NSBackwardsSearch];
        if (range.length > 0)
        {
            // server = [server substringToIndex:range.location];
        }
        
        
        [NSThread sleepForTimeInterval:3];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveMemoryWarning) name:MEMORY_WARNING_RECIEVED object:nil];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)//change
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        }
        else
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
            
        }
        
        NSLog(@"%@",launchOptions);
        NSLog(@"%@",launchDict);
        
        launchDict = launchOptions;
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        
        //get the current location of user
        
        [self startUpdatingLocation];
        
        // self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        if(![CLLocationManager locationServicesEnabled] ||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Enabled"
                                                            message:@"To enable, please go to Settings and turn on Location Service for this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        // latitude = locationManager.location.coordinate.latitude;
        // longitude = locationManager.location.coordinate.longitude;
        
#if TARGET_IPHONE_SIMULATOR
        latitude = 26.852538;
        longitude = 75.817341;
#endif
        
        //        NSLog(@"latitude =%f \t longitude =%f ",latitude,longitude);
        //
        //        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        //        [dateformatter setDateFormat:DATE_FORMAT_LOGIN];
        //        NSDate * newdate = [dateformatter dateFromString:[AppSetting getLastLoginTime]];
        //
        //        unsigned long int lastLoginHrs =0;
        //
        //        if(newdate!=nil)
        //        {
        //            lastLoginHrs = [ConfigManager timeDifferenceInHrs:[NSDate date] previousDate:newdate];
        //        }
        
        strSelectedTagId = @"";
        unreadNotifications = 0;
        
        if(![standardUserDefault boolForKey:IS_FIRST_RUN] || UNARCHIEVE_USER_DATA == nil)
        {
            
            if (IS_DEVICE_IPAD) {
                
                _viewController = [[HomeViewController alloc ]  initWithNibName:@"HomeViewController" bundle:nil];
                
            }
            else
            {
                _viewController = [[HomeViewController alloc ]  initWithNibName:@"HomeViewController_iphone" bundle:nil];
                
            }
            navigationController = [[UINavigationController alloc] initWithRootViewController:_viewController];
            self.window.rootViewController = navigationController;
            
            [standardUserDefault setBool:TRUE forKey:IS_FIRST_RUN];
        }
        
        else{
            
            if (IS_DEVICE_IPAD) {
                
                _viewController = [[HomeViewController alloc]  initWithNibName:@"HomeViewController" bundle:nil];
                
            }
            else
            {
                _viewController = [[HomeViewController alloc ]  initWithNibName:@"HomeViewController_iphone" bundle:nil];
                
            }
            
            //Auto Login
            NSLog(@"UNARCHIEVE_USER_DATA =============== %@",UNARCHIEVE_USER_DATA);
            self.userObj = UNARCHIEVE_USER_DATA;
            
            NSLog(@"SIP DETAILS:::: %@ %@ %@",self.userObj.sip.ipAddress,self.userObj.sip.username,self.userObj.sip.password);
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]||[sharedAppDelegate.userObj.role isEqualToString:@"5"]){
                
                [self showManagerDashBoard:nil];
                
            }
            else{
                
                [self showEmployeeDashBoard:nil];
                
            }
            
            //[self initUserDefaults];
            //[self initSipServices];
        }
        
        [SqliteManager sharedManager];
        
        
        [self.window makeKeyAndVisible];
        
        /*
         if ([userDef boolForKey:@"keepAwake"])
         [self keepAwakeEnabled];
         */
    }
    return TRUE;
    
}

// Sinch

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"didReceiveLocalNotification sinch");
    
    [self handleLocalNotification:notification];
}

- (void)requestUserNotificationPermission {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
#pragma mark -

- (void)managedPush:(id<SINManagedPush>)unused
didReceiveIncomingPushWithPayload:(NSDictionary *)payload
            forType:(NSString *)pushType {
    
    NSLog(@"didReceiveIncomingPushWithPayload");
    
    // id<SINClient> client; // get previously created client
    //  [client relayRemotePushNotification:userInfo];
}

- (void)initSinchClientWithUserId:(NSString *)userId {
    if (!_client) {
        _client = [Sinch clientWithApplicationKey:@"b17216ab-b361-46f9-9df4-d7146c1ededc"
                                applicationSecret:@"0Iyb8gFIkkenRpQjO37pRA=="
                                  environmentHost:@"sandbox.sinch.com"
                                           userId:userId];
        
        
        _client.delegate = self;
        _client.callClient.delegate = self;
        
        [_client setSupportCalling:YES];
        [_client setSupportActiveConnectionInBackground:YES];
        [_client enableManagedPushNotifications];
        [_client start];
        [_client startListeningOnActiveConnection];
    }
}

- (void)handleLocalNotification:(UILocalNotification *)notification {
    if (notification) {
        id<SINNotificationResult> result = [self.client relayLocalNotification:notification];
        if ([result isCall] && [[result callResult] isTimedOut]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Missed call"
                                  message:[NSString stringWithFormat:@"Missed call from %@", [[result callResult] remoteUserId]]
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

#pragma mark - SINClientDelegate



- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    
    NSLog(@"didReceiveIncomingCall callview");
    
    
    if (IS_DEVICE_IPAD) {
        
        self.callingView=[[CallingView alloc] initWithNibName:@"CallingView" bundle:nil];
        
        
    }
    else
    {
        self.callingView=[[CallingView alloc] initWithNibName:@"CallingView_iphone" bundle:nil];
        
    }
    self.callingView.call = call;
    [sharedAppDelegate.window addSubview:self.callingView.view];
}

- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    
    NSLog(@"didReceiveIncomingCall callview");
    
    NSArray *foo = [[call remoteUserId] componentsSeparatedByString: @"_"];
    
    NSString* str_name = [foo objectAtIndex: 1];
    
    NSString *finalString = [str_name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", finalString];
    return notification;
}

///

- (void)clientDidStart:(id<SINClient>)client {
    NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
    NSLog(@"Sinch client error: %@", [error localizedDescription]);
}

- (void)client:(id<SINClient>)client
    logMessage:(NSString *)message
          area:(NSString *)area
      severity:(SINLogSeverity)severity
     timestamp:(NSDate *)timestamp {
    if (severity == SINLogSeverityCritical) {
        NSLog(@"message = %@", message);
    }
}

/////
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"centralManagerDidUpdateState");
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        //Do what you intend to do
        
        
    } else if(central.state == CBCentralManagerStatePoweredOff) {
        
        
        //Bluetooth is disabled. ios pops-up an alert automatically
    }
}

-(UINavigationController*)userTagNavi
{
    if(!self.tagNavigation){
        
        if (IS_DEVICE_IPAD) {
            
            UserTagsVC* userTag = [[UserTagsVC alloc ] initWithNibName:@"UserTagsVC" bundle:nil];
            self.tagNavigation = [[UINavigationController alloc] initWithRootViewController:userTag];
            
        }
        else
        {
            UserTagsVC* userTag = [[UserTagsVC alloc ] initWithNibName:@"UserTagsVC_iphone" bundle:nil];
            self.tagNavigation = [[UINavigationController alloc] initWithRootViewController:userTag];
        }
    }
    
    return self.tagNavigation;
}

-(void)showEmployeeDashBoard:(UIViewController*)navigation
{
    if (![sharedAppDelegate.userObj.userId isEqualToString:@""]) {
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        
        [[AmityCareServices sharedService] GetRecordingDetailInvocation:dic delegate:self];
        
    }
    
    /*if(IS_DEVICE_IPAD){
     
     LeftMenuVC *masterViewController = [[LeftMenuVC alloc ] initWithNibName:@"LeftMenuVC" bundle:nil];
     UINavigationController *navigationMasterView = [[UINavigationController alloc] initWithRootViewController:masterViewController];
     
     self.splitView = [[UISplitViewController alloc] init];
     self.splitView.viewControllers = @[navigationMasterView,[self userTagNavi]];
     self.splitView.delegate = nil;
     [self.splitView setValue:[NSNumber numberWithBool:NO] forKey:@"hidesMasterViewInPortrait"];
     [self.splitView setValue:[NSNumber numberWithFloat:243] forKey:@"_masterColumnWidth"];
     
     [self.window setRootViewController:self.splitView];
     
     [masterViewController release];
     }
     else
     {
     
     MenuListViewController *leftMenuViewController = [[MenuListViewController alloc] initWithNibName:@"MenuListViewController" bundle:nil];
     
     
     UserTagsVC *tagsViewController = [[UserTagsVC alloc ] initWithNibName:@"UserTagsVC_iphone" bundle:nil];
     
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tagsViewController];
     
     
     container = [MFSideMenuContainerViewController
     containerWithCenterViewController:navigationController
     leftMenuViewController:leftMenuViewController
     rightMenuViewController:nil];
     [container.shadow setEnabled:NO];
     // [navigation.navigationController pushViewController:container animated:YES];
     [self.window setRootViewController:container];
     
     }*/
    
    //self.objUserHomeViewController = [[UserHomeViewController alloc] initWithNibName:@"UserHomeViewController" bundle:nil];
    
    isRecording=FALSE;
    
    if (IS_DEVICE_IPAD) {
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.objUserHomeViewController];
        [self.window setRootViewController: self.navigationController];
        
    }
    else
    {
        
        RightMenuViewController *rightMenuViewController = [[RightMenuViewController alloc] initWithNibName:@"RightMenuViewController" bundle:nil];
        
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.objIphoneUserViewController];
        
        
        container = [MFSideMenuContainerViewController
                     containerWithCenterViewController:self.navigationController
                     leftMenuViewController:nil
                     rightMenuViewController:rightMenuViewController];
        
        
        [container.shadow setEnabled:NO];
        
        [self.window setRootViewController:container];
        
        
    }
    
    
}

-(void)showManagerDashBoard:(UIViewController*)navigation
{
    isRecording=FALSE;
    
    if (![sharedAppDelegate.userObj.userId isEqualToString:@""]) {
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        
        [[AmityCareServices sharedService] GetRecordingDetailInvocation:dic delegate:self];
        
    }
    
    // self.objUserHomeViewController = [[UserHomeViewController alloc] initWithNibName:@"UserHomeViewController" bundle:nil];
    
    if (IS_DEVICE_IPAD) {
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.objUserHomeViewController];
        [self.window setRootViewController:self.navigationController];
        
    }
    else
    {
        RightMenuViewController *rightMenuViewController = [[RightMenuViewController alloc] initWithNibName:@"RightMenuViewController" bundle:nil];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.objIphoneUserViewController];
        
        
        container = [MFSideMenuContainerViewController
                     containerWithCenterViewController:self.navigationController
                     leftMenuViewController:nil
                     rightMenuViewController:rightMenuViewController];
        
        
        [container.shadow setEnabled:NO];
        
        [self.window setRootViewController:container];
        
    }
    
    
    
    /* if(IS_DEVICE_IPAD){
     
     LeftMenuVC *masterViewController = [[LeftMenuVC alloc ] initWithNibName:@"LeftMenuVC" bundle:nil];
     UINavigationController *navigationMasterView = [[UINavigationController alloc] initWithRootViewController:masterViewController];
     
     self.splitView = [[UISplitViewController alloc] init];
     self.splitView.viewControllers = @[navigationMasterView,[self userTagNavi]];
     self.splitView.delegate = nil;
     [self.splitView setValue:[NSNumber numberWithBool:NO] forKey:@"hidesMasterViewInPortrait"];
     [self.splitView setValue:[NSNumber numberWithFloat:243] forKey:@"_masterColumnWidth"];
     
     [self.window setRootViewController:self.splitView];
     
     [masterViewController release];
     
     }
     else{
     
     
     MenuListViewController *leftMenuViewController = [[MenuListViewController alloc] initWithNibName:@"MenuListViewController" bundle:nil];
     
     
     UserTagsVC  *tagsViewController = [[UserTagsVC alloc ] initWithNibName:@"UserTagsVC_iphone" bundle:nil];
     
     
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tagsViewController];
     
     
     container = [MFSideMenuContainerViewController
     containerWithCenterViewController:navigationController
     leftMenuViewController:leftMenuViewController
     rightMenuViewController:nil];
     [container.shadow setEnabled:NO];
     [self.window setRootViewController:container];
     
     
     }*/
}

-(void)showChangePasswordAlertAfter90Days{
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:DATE_FORMAT_LOGIN];
    
    NSLog(@"[AppSetting getLastPasswordChnageTime] =%@",[AppSetting getLastPasswordChnageTime]);
    NSDate * changeDate = [dateformatter dateFromString:[AppSetting getLastPasswordChnageTime]];
    
    if(changeDate!=nil)
    {
        
        
        unsigned long int lastPassChngTime = [ConfigManager timeDifferenceInDays:[NSDate date] previousDate:changeDate];
        
        if(abs(lastPassChngTime)>90){
            ACAlertView* passChangeAlert = [[ACAlertView alloc ] initWithTitle:@"" message:@"Please change password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Change",@"Ask Later", nil];
            passChangeAlert.alertTag = AC_ALERTVIEW_CHANGE_PASSWORD_ALERT;
            [passChangeAlert show];
        }
    }
}


-(void)recieveMemoryWarning
{
    ARCHIEVE_USER_DATA;
}

-(void)saveUserCredentials{
    
    ARCHIEVE_USER_DATA;
    [standardUserDefault synchronize];
}

-(void)aGlobalNavigation:(UINavigationController*)navigation
{
    if(self.globalNavigation != nil){
        self.globalNavigation = nil;
    }
    self.globalNavigation = navigation;
}

-(void)logoutFromApp
{
    //Clear DropBox credential or earlier session
    [[DBSession sharedSession] unlinkAll];
    
    self.userObj = nil;
    ARCHIEVE_USER_DATA;
    
    [standardUserDefault setBool:FALSE forKey:IS_FIRST_RUN];
    
    [standardUserDefault synchronize];
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_LOGOUT object:nil userInfo:nil];
    
    NSLog(@"%@",launchDict);
    
    
    [self application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:launchDict];
}


//////////////////// SIP START ///////////////////

- (void)reachabilityChanged:(NSNotification *)notification
{
    // FIXME on doit pouvoir faire plus intelligent !!
    //NSLog(@"reachabilityChanged");
    // SCNetworkReachabilityFlags flags = [[[ notification userInfo ]
    //                                     objectForKey: @"Flags"] intValue];
    Reachability* curReach = [notification object];
    if ([curReach currentReachabilityStatus] == NotReachable)
    {
        //[phoneViewController reachabilityChanged:notification];
    }
    else
    {
    }
}
-(void)initSipServices
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *server = [userDef stringForKey: @"proxyServer"];
    NSArray *array = [server componentsSeparatedByString:@","];
    NSEnumerator *enumerator = [array objectEnumerator];
    while (server = [enumerator nextObject])
        if ([server length])break;
    if (!server || [server length] < 1)
        server = [userDef stringForKey: @"server"];
    
    NSRange range = [server rangeOfString:@":"
                                  options:NSCaseInsensitiveSearch|NSBackwardsSearch];
    if (range.length > 0)
    {
        server = [server substringToIndex:range.location];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self._hostReach = [Reachability reachabilityWithHostName: server];
    [self._hostReach startNotifer];
    
    //[self performSelector:@selector(sipConnect) withObject:nil afterDelay:0.2];
}

-(void)displayParameterError:(NSString *)msg
{
    NSString *message = NSLocalizedString(msg, msg);
    NSString *error = [message stringByAppendingString:NSLocalizedString(
                                                                         @"\nTo correct this parameter, select \"Settings\" from your Home screen, "
                                                                         "and then tap the \"Siphon\" entry.", @"SiphonApp")];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:error
#if defined(CYDIA) && (CYDIA == 1)
                                                   delegate:self
#else
                                                   delegate:nil
#endif
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"SiphonApp")
                                          otherButtonTitles:NSLocalizedString(@"Settings", @"SiphonApp"), nil ];
    [alert show];
    //[alert release];
}

#if defined(CYDIA) && (CYDIA == 1)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    (buttonIndex == 1)
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.Preferences"
                                                             suspended:NO];
}


#endif

-(void)displayError:(NSString *)error withTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:error
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"SiphonApp")
                                          otherButtonTitles:nil];
    [alert show];
    //[alert release];
}


#if defined(CYDIA) && (CYDIA == 1)
#pragma mark -
#pragma mark Power Management
// Technical Q&A QA1340 : Registering and unregistering for sleep and wake notifications
// http://developer.apple.com/mac/library/qa/qa2004/qa1340.html
void powerCallback( void * refCon, io_service_t service, natural_t messageType,
                   void * messageArgument )
{
    [(AppDelegate *)refCon powerMessageReceived: messageType
                                   withArgument: messageArgument];
}

- (void)powerMessageReceived:(natural_t)messageType withArgument:(void *) messageArgument
{
    /*printf( "messageType %08lx, arg %08lx\n",
     (long unsigned int)messageType,
     (long unsigned int)messageArgument );*/
    
    switch ( messageType )
    {
            
        case kIOMessageCanSystemSleep:
            /* Idle sleep is about to kick in. This message will not be sent for forced sleep.
             Applications have a chance to prevent sleep by calling IOCancelPowerChange.
             Most applications should not prevent idle sleep.
             
             Power Management waits up to 30 seconds for you to either allow or deny idle sleep.
             If you don't acknowledge this power change by calling either IOAllowPowerChange
             or IOCancelPowerChange, the system will wait 30 seconds then go to sleep.
             */
            
            //Uncomment to cancel idle sleep
            IOCancelPowerChange( root_port, (long)messageArgument );
            // we will allow idle sleep
            //IOAllowPowerChange( root_port, (long)messageArgument );
            break;
            
        case kIOMessageSystemWillSleep:
            /* The system WILL go to sleep. If you do not call IOAllowPowerChange or
             IOCancelPowerChange to acknowledge this message, sleep will be
             delayed by 30 seconds.
             
             NOTE: If you call IOCancelPowerChange to deny sleep it returns kIOReturnSuccess,
             however the system WILL still go to sleep.
             */
            
            IOAllowPowerChange( root_port, (long)messageArgument );
            break;
            
        case kIOMessageSystemWillPowerOn:
            //System has started the wake up process...
            break;
            
        case kIOMessageSystemHasPoweredOn:
            //System has finished waking up...
            break;
            
        default:
            break;
    }
}

- (void)keepAwakeEnabled
{
    NSLog(@"keepAwakeEnabled");
    root_port = IORegisterForSystemPower(self, &notifyPortRef, powerCallback,
                                         &notifierObject);
    if ( root_port == 0 )
    {
        NSLog(@"IORegisterForSystemPower failed\n");
        return;
    }
    
    // add the notification port to the application runloop
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       IONotificationPortGetRunLoopSource(notifyPortRef),
                       kCFRunLoopCommonModes );
    
    [super addStatusBarImageNamed:@"Siphon" removeOnExit: YES];
}

- (void)keepAwakeDisabled
{
    NSLog(@"keepAwakeDisabled");
    if (root_port == 0)
        return;
    
    [self removeStatusBarImageNamed:@"Siphon"];
    
    // remove the sleep notification port from the application runloop
    CFRunLoopRemoveSource( CFRunLoopGetCurrent(),
                          IONotificationPortGetRunLoopSource(notifyPortRef),
                          kCFRunLoopCommonModes );
    
    // deregister for system sleep notifications
    IODeregisterForSystemPower( &notifierObject );
    
    // IORegisterForSystemPower implicitly opens the Root Power Domain IOService
    // so we close it here
    IOServiceClose( root_port );
    
    // destroy the notification port allocated by IORegisterForSystemPower
    IONotificationPortDestroy( notifyPortRef );
}
#endif

#if 1
- (void) activateWWAN
{
    self.networkActivityIndicatorVisible = YES;
    //NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithCString:"http://www.google.com"]];
    //  NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithUTF8String:"http://www.google.com"]];
    
    //  NSData * data = [NSData dataWithContentsOfURL:url];
    // self.networkActivityIndicatorVisible = NO;
}
- (BOOL)wakeUpNetwork
{
    BOOL overEDGE = FALSE;
    if (isIpod == FALSE)
    {
        overEDGE = [[NSUserDefaults standardUserDefaults] boolForKey:kVoipOverEdge];
    }
    
    NetworkStatus netStatus = [self._hostReach currentReachabilityStatus];
    BOOL connectionRequired = [self._hostReach connectionRequired];
    if ((overEDGE && netStatus == NotReachable) ||
        (!overEDGE && netStatus != ReachableViaWiFi))
        return NO;
    //if (overEDGE && netStatus == ReachableViaWWAN)
    if (connectionRequired)
    {
        [self activateWWAN];
    }
    
    return YES;
}

- (void)initUserDefaults
{
#if defined(CYDIA) && (CYDIA == 1)
    // TODO Franchement pas beau ;-)
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt: 1800], @"regTimeout",
                          [NSNumber numberWithBool:NO], @"enableNat",
                          [NSNumber numberWithBool:NO], @"enableMJ",
                          [NSNumber numberWithInt: 5060], @"localPort",
                          [NSNumber numberWithInt: 4000], @"rtpPort",
                          [NSNumber numberWithInt: 15], @"kaInterval",//15
                          [NSNumber numberWithBool:NO], @"enableEC",
                          [NSNumber numberWithBool:YES], @"disableVad",
                          [NSNumber numberWithInt: 0], @"codec",
                          [NSNumber numberWithBool:NO], @"dtmfWithInfo",
                          [NSNumber numberWithBool:NO], @"enableICE",
                          [NSNumber numberWithInt: 0], @"logLevel",
                          [NSNumber numberWithBool:YES],  @"enableG711u",
                          [NSNumber numberWithBool:YES],  @"enableG711a",
                          [NSNumber numberWithBool:NO],   @"enableG722",
                          [NSNumber numberWithBool:NO],   @"enableG7221",
                          [NSNumber numberWithBool:NO],   @"enableG729",
                          [NSNumber numberWithBool:YES],  @"enableGSM",
                          [NSNumber numberWithBool:NO], @"keepAwake",
                          nil];
    
    [userDef registerDefaults:dict];
    [userDef synchronize];
#else
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity: 10];
    
    [self initUserDefaults:dict fromSettings:@"Advanced.plist"];
    [self initUserDefaults:dict fromSettings:@"Network.plist"];
    [self initUserDefaults:dict fromSettings:@"Phone.plist"];
    [self initUserDefaults:dict fromSettings:@"Codec.plist"];
    
    [userDef registerDefaults:dict];
    [userDef synchronize];
    //[dict release];
#endif // CYDIA
    
    [userDef setObject:self.userObj.sip.username forKey:@"username"];
    [userDef setObject:self.userObj.sip.password forKey:@"password"];
    [userDef setObject:self.userObj.sip.ipAddress forKey:@"server"];
    
    
    //    [userDef setObject:@"2946214217" forKey:@"username"];
    //    [userDef setObject:@"ymvwtj" forKey:@"password"];
    //    [userDef setObject:@"209.208.125.225" forKey:@"server"];
    
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"enableNat"];
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"enableMJ"];
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"keepAwake"];
    
    [userDef setObject:[NSNumber numberWithInt: 5060] forKey:@"localPort"];
    [userDef setObject:[NSNumber numberWithInt: 4000] forKey:@"rtpPort"];
    [userDef setObject:[NSNumber numberWithInt: 15] forKey:@"kaInterval"];
    
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"enableEC"];
    [userDef setObject:[NSNumber numberWithBool:YES] forKey:@"disableVad"];
    [userDef setObject:[NSNumber numberWithInt: 0] forKey:@"codec"];
    
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"dtmfWithInfo"];
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"enableICE"];
    [userDef setObject:[NSNumber numberWithInt: 0] forKey:@"logLevel"];
    
    [userDef setObject:[NSNumber numberWithBool:YES] forKey:@"enableG711u"];
    [userDef setObject:[NSNumber numberWithBool:YES] forKey:@"enableG711a"];
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"enableG722"];
    
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"enableG7221"];
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:@"enableG729"];
    [userDef setObject:[NSNumber numberWithBool:YES] forKey:@"enableGSM"];
    
    [userDef setObject:[NSNumber numberWithInt: 1800] forKey:@"regTimeout"];
    
    [userDef synchronize];
}

- (void)initModel
{
    NSString *model = [[UIDevice currentDevice] model];
    isIpod = [model hasPrefix:@"iPod"];
    //NSLog(@"%@", model);
}



- (UIView *)applicationStartWithoutSettings
{
    // TODO: go to settings immediately
    UIView *mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]
                                                      applicationFrame]];
    mainView.backgroundColor = [UIColor whiteColor];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    [navBar setFrame:CGRectMake(0, 0, 320,45)];
    navBar.barStyle = UIBarStyleBlackOpaque;
    [navBar pushNavigationItem: [[UINavigationItem alloc] initWithTitle:@"2.4"]
                      animated: NO];
    [mainView addSubview:navBar];
    
    UIImageView *background = [[UIImageView alloc]
                               initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, 185.0f)];
    [background setImage:[UIImage imageNamed:@"settings.png"]];
    [mainView addSubview:background];
    
    UILabel *text = [[UILabel alloc] initWithFrame: CGRectMake(0, 220, 320, 200.0f)];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.numberOfLines = 0;
    text.lineBreakMode = NSLineBreakByCharWrapping;
    text.font = [UIFont systemFontOfSize: 18];
    text.text = NSLocalizedString(@"Siphon requires a valid\nSIP account.\n\nTo enter this information, select \"Settings\" from your Home screen, and then tap the \"Siphon\" entry.", @"SiphonApp");
    [mainView addSubview:text];
    
    text = [[UILabel alloc] initWithFrame: CGRectMake(0, 420, 320, 40.0f)];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize: 16];
    text.text = NSLocalizedString(@"Press the Home button", @"SiphonApp");
    [mainView addSubview:text];
    
    return mainView;
}

- (UIView *)applicationStartWithSettings
{
    
    return nil;
}



#endif

/***** SIP ********/
/* */

/* */

/* */

/* */

- (void)initUserDefaults:(NSMutableDictionary *)dict fromSettings:(NSString *)settings
{
    NSDictionary *prefItem;
    
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:settings];
    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
    
    
    NSLog(@"pathStr %@",pathStr);
    NSLog(@"settingsBundlePath %@",settingsBundlePath);
    NSLog(@"finalPath %@",finalPath);
    NSLog(@"settingsDict %@",settingsDict);
    NSLog(@"prefSpecifierArray %@",prefSpecifierArray);
    
    for (prefItem in prefSpecifierArray)
    {
        NSString *keyValueStr = [prefItem objectForKey:@"Key"];
        if (keyValueStr)
        {
            id defaultValue = [prefItem objectForKey:@"DefaultValue"];
            if (defaultValue)
            {
                [dict setObject:defaultValue forKey: keyValueStr];
            }
        }
    }
}
-(void)callEndDidClicked:(id)sender
{
    [self callDisconnecting];
}
#if 1 //ndef __IPHONE_3_0
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil];
        
        return YES;
    }
    
    
    if (!url)
    {
        // The URL is nil. There's nothing more to do.
        return NO;
    }
    
    NSString *URLString = [url absoluteString];
    if (!URLString)
    {
        // The URL's absoluteString is nil. There's nothing more to do.
        return NO;
    }
    
    return YES;
}
#endif

- (void)outOfTimeToCall
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dateOfCall"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"callURL"];
}


/************ **************/
//- (void)prefsHaveChanged:(NSNotification *)notification
//{
//  NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//  [self displayError:[userDef objectForKey: @"sip_user"] withTitle:@"username"];
//}

- (NSString *)normalizePhoneNumber:(NSString *)number
{
    const char *phoneDigits = "22233344455566677778889999",
    *nb = [[number uppercaseString] UTF8String];
    unsigned long int i, len = [number length];
    char *u, *c, *utf8String = (char *)calloc(sizeof(char), len+1);
    c = (char *)nb; u = utf8String;
    for (i = 0; i < len; ++c, ++i)
    {
        if (*c == ' ' || *c == '(' || *c == ')' || *c == '/' || *c == '-' || *c == '.')
            continue;
        /*    if (*c >= '0' && *c <= '9')
         {
         *u = *c;
         u++;
         }
         else*/ if (*c >= 'A' && *c <= 'Z')
         {
             *u = phoneDigits[*c - 'A'];
         }
         else
             *u = *c;
        u++;
    }
    NSString * norm = [[NSString alloc] initWithUTF8String:utf8String];
    free(utf8String);
    return norm;
}

-(void)addCalingView:(CallingView*)callingView
{
    
}

/** FIXME plutôt à mettre dans l'objet qui gère les appels **/



- (void) disconnected:(id)fp8
{
    // self.statusBarStyle = UIStatusBarStyleDefault;
    //[tabBarController dismissModalViewControllerAnimated: YES];
    [self.callingView.view removeFromSuperview];
    //[self.callingView release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url;
    NSString *urlStr;
    switch (buttonIndex)
    {
        case 0: // Call with GSM
            urlStr = [NSString stringWithFormat:@"tel://%@",self._phoneNumber,nil];
            url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL: url];
            break;
        default:
            break;
    }
}

-(RecentsViewController *)recentsViewController
{
    return recentsViewController;
}



//////////////////// SIP END ///////////////////

#pragma mark------------
#pragma mark- CLLocationManger

-(CLLocationManager*)ClocationManager{
    
    //Creats and return a CLLocationManger Instance
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startMonitoringSignificantLocationChanges];
        
        NSLog(@"%f",[[UIDevice currentDevice].systemVersion floatValue]);
        
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
            
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationManager requestAlwaysAuthorization];
            }
        }
        
    }
    return self.locationManager;
}

-(void)startUpdatingLocation
{
    
    CLLocationManager *manager = [self ClocationManager];
    [manager startUpdatingLocation];
    
}

-(void)stopUpdatingLocation{
    
    CLLocationManager *manager = [self ClocationManager];
    [manager stopUpdatingLocation];
    
}

#pragma mark------------
#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
    {
        [self stopUpdatingLocation];
        
        
    }
    
    else if (status == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"%f",[[UIDevice currentDevice].systemVersion floatValue]);
        
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
            
            [self.locationManager requestAlwaysAuthorization];
            
        }
        
        [self startUpdatingLocation];
    }
    else if (status == kCLAuthorizationStatusAuthorized)
    {
        [self startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error)
    {
        sharedAppDelegate.beaconsProximity=@"NO";
        
        NSLog(@"locationManager => didFailWithError %@",[error debugDescription]);
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Your GPS location cannot be traced" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        //        [alert show];
    }
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"LATITUDE =%f \t LONGITUDE =%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    longitude = newLocation.coordinate.longitude;
    latitude = newLocation.coordinate.latitude;
    [self stopUpdatingLocation];
    
    if((newLocation.coordinate.longitude == oldLocation.coordinate.longitude) && (newLocation.coordinate.latitude == oldLocation.coordinate.latitude)){
        //[self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    NSLog(@"LATITUDE =%f \t LONGITUDE =%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    longitude = newLocation.coordinate.longitude;
    latitude = newLocation.coordinate.latitude;
    [self stopUpdatingLocation];
    
    
}

#pragma mark------------
#pragma mark- Application Delegate Methods
/*
 -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 // NSLog(@"URL = =======  %@",[NSURL URLWithString:@"http://maps.googleapis.com/maps/api/staticmap?size=600x600&maptype=roadmap&markers=size:461x307"]);
 
 [NSThread sleepForTimeInterval:3];
 
 [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveMemoryWarning) name:MEMORY_WARNING_RECIEVED object:nil];
 
 [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];
 
 launchDict = launchOptions;
 
 self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 self.window.backgroundColor = [UIColor whiteColor];
 
 //get the current location of user
 
 [self startUpdatingLocation];
 
 latitude = locationManager.location.coordinate.latitude;
 longitude = locationManager.location.coordinate.longitude;
 
 NSLog(@"latitude =%f \t longitude =%f ",latitude,longitude);
 
 NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
 [dateformatter setDateFormat:DATE_FORMAT_LOGIN];
 NSDate * newdate = [dateformatter dateFromString:[AppSetting getLastLoginTime]];
 
 int lastLoginHrs =0;
 
 if(newdate!=nil)
 {
 lastLoginHrs = [Config timeDifferenceInHrs:[NSDate date] previousDate:newdate];
 }
 
 strSelectedTagId = @"";
 unreadNotifications = 0;
 
 if(![standardUserDefault boolForKey:IS_FIRST_RUN] || UNARCHIEVE_USER_DATA == nil)
 {
 NSLog(@" ---- >>>>>>>>>>>>>>>>> case 1 ---- >>>>>>>>>>>>>>>>> ");
 
 
 _viewController = [[HomeViewController alloc ]  initWithNibName:@"HomeViewController" bundle:nil];
 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_viewController];
 self.window.rootViewController = navigationController;
 
 [standardUserDefault setBool:TRUE forKey:IS_FIRST_RUN];
 }
 else if(lastLoginHrs >= 24){
 //last login time exceeds 24hrs. Ask for credentials
 NSLog(@" ---- >>>>>>>>>>>>>>>>> case 2 ---- >>>>>>>>>>>>>>>>> ");
 _viewController = [[HomeViewController alloc ]  initWithNibName:@"HomeViewController" bundle:nil];
 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_viewController];
 self.window.rootViewController = navigationController;
 
 }
 else{
 NSLog(@" ---- >>>>>>>>>>>>>>>>> case 3 ---- >>>>>>>>>>>>>>>>> ");
 
 _viewController = [[HomeViewController alloc ]  initWithNibName:@"HomeViewController" bundle:nil];
 
 
 //Auto Login
 NSLog(@"UNARCHIEVE_USER_DATA =============== %@",UNARCHIEVE_USER_DATA);
 self.userObj = UNARCHIEVE_USER_DATA;
 
 if(self.userObj.isEmployee){
 [self showEmployeeDashBoard:nil];
 }
 else{
 [self showManagerDashBoard:nil];
 }
 
 NSLog(@"email =%@, pass =%@",self.userObj.email,self.userObj.password);
 }
 
 NSLog(@"[AppSetting getLastPasswordChnageTime] =%@",[AppSetting getLastPasswordChnageTime]);
 NSDate * changeDate = [dateformatter dateFromString:[AppSetting getLastPasswordChnageTime]];
 if(changeDate!=nil)
 {
 int lastPassChngTime = [Config timeDifferenceInDays:[NSDate date] previousDate:changeDate];
 
 if(abs(lastPassChngTime)>90){
 ACAlertView* passChangeAlert = [[ACAlertView alloc ] initWithTitle:@"" message:@"Please change password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Change",@"Ask Later", nil];
 passChangeAlert.alertTag = AC_ALERTVIEW_CHANGE_PASSWORD_ALERT;
 [passChangeAlert show];
 }
 }
 [self.window makeKeyAndVisible];
 return YES;
 }
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    ARCHIEVE_USER_DATA;
    [standardUserDefault synchronize];
    
    /* if ([sharedAppDelegate.userObj.role isEqualToString:@"2"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
     
     [sharedAppDelegate invalidateRecordingTimers];
     
     }*/
    
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    isRecording=FALSE;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation == 0)
    {
        isPortrait=YES;
    }
    else if(orientation == UIInterfaceOrientationPortrait || orientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        isPortrait=YES;
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        isPortrait=NO;
        
    }
    
    [self startUpdatingLocation];
    
    if(![CLLocationManager locationServicesEnabled] ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Enabled"
                                                        message:@"To enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    // latitude = 26.852538;
    //longitude = 75.817341;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    //    [dateformatter setDateFormat:DATE_FORMAT_LOGIN];
    //    NSDate * newdate = [dateformatter dateFromString:[AppSetting getLastLoginTime]];
    //
    //    unsigned long int lastLoginHrs =0;
    //
    //    if(newdate!=nil)
    //    {
    //        lastLoginHrs = [ConfigManager timeDifferenceInHrs:[NSDate date] previousDate:newdate];
    //    }
    
    
    if(![standardUserDefault boolForKey:IS_FIRST_RUN] || UNARCHIEVE_USER_DATA == nil){
        
    }
    
    else
    {
        [self showPinAlert];
        
    }
    
    
    if (sharedAppDelegate.userObj.userId==nil || sharedAppDelegate.userObj.userId==(NSString*)[NSNull null] || [sharedAppDelegate.userObj.userId isEqualToString:@""]) {
        
    }
    else
    {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        
        [[AmityCareServices sharedService] GetRecordingDetailInvocation:dic delegate:self];
    }
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/*
 - (void)applicationWillTerminate:(UIApplication *)application
 {
 ARCHIEVE_USER_DATA;
 [standardUserDefault synchronize];
 // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 }
 
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
 {
 if ([[DBSession sharedSession] handleOpenURL:url]) {
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil];
 
 return YES;
	}
	
	return NO;
 }
 */

#pragma mark- UIAlertView
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
     ChangePassword Alert: Here if user select change then a notification will fire, a corresponding observer is added to left menu view controller
     which will redirect to change password screen where user can enter new password details.
     */
    if(alertView.alertTag == AC_ALERTVIEW_CHANGE_PASSWORD_ALERT){
        if(buttonIndex==0){
            [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_CHANGE_PASS_NOTIFICATION object:nil];
        }
    }
    else if(alertView.alertTag==AC_ALERTVIEW_OFFLINE_MESSAGE_SUCCESSFULLY)
    {
        if (buttonIndex==1) {
            
            NSString *inputText = [[alertView textFieldAtIndex:0] text];
            
            if ([inputText length]>0) {
                
                if([ConfigManager isInternetAvailable]){
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    NSString *encodedString=[QSStrings encodeBase64WithString:inputText];
                    
                    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                    [dic setObject:self.offlineMemberId forKey:@"member_id"];
                    [dic setObject:encodedString forKey:@"message"];
                    
                    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
                    [[AmityCareServices sharedService] OfflineMessageInvocation:dic delegate:self];
                    
                    
                }
                else{
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
            
        }
    }
    
}

#pragma mark- PushNotification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    //Removing the brackets from the device token
    NSLog(@"deviceToken = %@",deviceToken);
    
    NSString *tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *str_token = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.strDeviceToken = str_token;
    
    gDeviceToke=self.strDeviceToken;
    
    [_client registerPushNotificationData:deviceToken];
    
    [self.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    NSLog(@"Push Notification tokenstring is %@",str_token);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    NSLog(@"didReceiveRemoteNotification");
    
    
    NSLog(@"userInfo = %@ ",userInfo);
    
    [self.push application:application didReceiveRemoteNotification:userInfo];
    
    
    [self handleRemoteNotifications:userInfo];
    
}

-(void)handleRemoteNotifications:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    
    sharedAppDelegate.unreadTagCount = [NULL_TO_NIL([[userInfo valueForKey:@"aps"] valueForKey:@"tagCount"]) integerValue];
    
    sharedAppDelegate.unreadContactCount = [NULL_TO_NIL([[userInfo valueForKey:@"aps"] valueForKey:@"contactCount"]) integerValue];
    
    sharedAppDelegate.unreadMsgCount = [NULL_TO_NIL([[userInfo valueForKey:@"aps"] valueForKey:@"chatCount"]) integerValue];
    
    sharedAppDelegate.unreadUserNotifiationCount = [NULL_TO_NIL([[userInfo valueForKey:@"aps"] valueForKey:@"callCount"]) integerValue];
    
    
    if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"task"].length>0){
        
        [standardUserDefault synchronize];
        
        NSNotification* notification = [NSNotification notificationWithName:AC_USER_UNREAD_NOTIFICATION_UPDATE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"happyFace"].length>0){
        
        
        [standardUserDefault synchronize];
        
        NSNotification* notification = [NSNotification notificationWithName:AC_USER_UNREAD_NOTIFICATION_UPDATE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"sadFace"].length>0){
        
        
        [standardUserDefault synchronize];
        
        NSNotification* notification = [NSNotification notificationWithName:AC_USER_UNREAD_NOTIFICATION_UPDATE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        // [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_UNREAD_NOTIFICATION_UPDATE object:nil];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"chat"].length>0){
        
        [standardUserDefault synchronize];
        
        NSNotification* notification = [NSNotification notificationWithName:AC_USER_MESSAGE_RECIEVE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"groupchat"].length>0){
        
        [standardUserDefault synchronize];
        
        NSNotification* notification = [NSNotification notificationWithName:AC_USER_MESSAGE_RECIEVE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_MESSAGE_RECIEVE object:nil];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"specialchat"].length>0){
        
        
        [standardUserDefault synchronize];
        
        NSNotification* notification = [NSNotification notificationWithName:AC_USER_MESSAGE_RECIEVE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_MESSAGE_RECIEVE object:nil];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"contact"].length>0){
        
        
        
        [standardUserDefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_CONTACT_RECIEVE object:nil];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"feed"].length>0)// Update feeds list
    {
        NSLog(@"========================== AC_UPDATE_STATUS_LIST =================== ");
        
        
        NSNotification* notification = [NSNotification notificationWithName:AC_UPDATE_TAG_LIST object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
        [standardUserDefault synchronize];
        
        NSNotification* notification1 = [NSNotification notificationWithName:AC_USER_UNREAD_NOTIFICATION_UPDATE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"tag"].length>0)// Update feeds list
    {
        NSLog(@"========================== AC_UPDATE_STATUS_LIST =================== ");
        
        
        [standardUserDefault synchronize];
        
        
        NSNotification* notification = [NSNotification notificationWithName:AC_UPDATE_TAG_LIST object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
        [standardUserDefault synchronize];
        
        NSNotification* notification1 = [NSNotification notificationWithName:AC_USER_UNREAD_NOTIFICATION_UPDATE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        
        //  [[NSNotificationCenter defaultCenter] postNotificationName:AC_UPDATE_TAG_LIST object:nil];
        
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"call"].length>0)
    {
        
        NSLog(@"========================== AC_UPDATE_CALL_NOTIFICATION =================== ");
        
        
        [standardUserDefault synchronize];
        
        NSNotification* notification1 = [NSNotification notificationWithName:AC_UPDATE_NOTIFICATION_TABLE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        
    }
   
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"reminder_task_notification"].length>0)
    {
        [standardUserDefault synchronize];
        
        NSNotification* notification1 = [NSNotification notificationWithName:AC_UPDATE_NOTIFICATION_TABLE object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] rangeOfString:@"clockout"].length>0)
    {
        [standardUserDefault synchronize];
        
        NSNotification* notification1 = [NSNotification notificationWithName:AC_UPDATE_NOTIFICATION_CLOCKOUT object:userInfo userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    }
    else if([[[userInfo valueForKey:@"aps"] valueForKey:@"type"] isEqualToString:@"cron"])
    {
        if([ConfigManager isInternetAvailable])
        {
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Logging Out..." width:150];
            AmityCareServices *service = [[AmityCareServices alloc] init];
            [service logoutInvocation:sharedAppDelegate.userObj.userId delegate:self];
        }
        
        else
        {
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }

    [standardUserDefault synchronize];
    
    
    NSNotification* notification = [NSNotification notificationWithName:AC_USER_UNREAD_BADGE_UPDATE object:userInfo userInfo:userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Fail to register remove notification");
    
}

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (resultStr.length > 4)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark - Other Method

- (void)showPinAlert
{
    //self.alertviw=customalertview(@"", @"Please enter pin to unlock the app", self,self, @selector(okbtnpressed:));
    //[self.window addSubview:self.alertviw];
    
    [self.objPinAlertViewController.view removeFromSuperview];
    
    if (IS_DEVICE_IPAD) {
        
        self.objPinAlertViewController=[[PinAlertViewController alloc] initWithNibName:@"PinAlertViewController" bundle:nil];
        
    }
    else
    {
        self.objPinAlertViewController=[[PinAlertViewController alloc] initWithNibName:@"PinAlertViewController_iphone" bundle:nil];
        
    }
    [self.window addSubview:self.objPinAlertViewController.view];
    
}

- (void)showWrongPinAlert
{
    //self.alertviw=customalertview1(@"Please enter correct pin", self, @selector(okbtnpressed1:));
    //[self.window addSubview:self.alertviw];
    
}

- (IBAction)okbtnpressed:(id)sender
{
    NSLog(@"PIN %@",sharedAppDelegate.userObj.appPin);
    
    UITextField *tf=nil;
    
    for(UIView *aView in self.alertviw.subviews)
    {
        for(UIView *aView1 in aView.subviews)
        {
            if([aView1 isKindOfClass:[UITextField class]])
            {
                tf = (UITextField *)aView1;
                break;
            }
        }
    }
    
    [self.alertviw removeFromSuperview];
    
    if (![tf.text isEqualToString:sharedAppDelegate.userObj.appPin])
    {
        [self showWrongPinAlert];
    }
    
    
}

-(IBAction)okbtnpressed1:(id)sender
{
    [self.alertviw removeFromSuperview];
    
    [self showPinAlert];
}

#pragma Send offline message methods -------------

- (void)showOfflineAlert:(NSString*)memberName memberId:(NSString*)memberId
{
    NSString *strUserName=[NSString stringWithFormat:@"%@ is offline !",memberName];
    
    self.offlineMemberId=memberId;
    
    ACAlertView *offlineAlert = [[ACAlertView alloc] initWithTitle:nil
                                                           message:strUserName
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Continue", nil];
    [offlineAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    offlineAlert.alertTag=AC_ALERTVIEW_OFFLINE_MESSAGE_SUCCESSFULLY;
    UITextField * alertTextField =nil;
    alertTextField=[offlineAlert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    [offlineAlert show];
    
}

-(void)OfflineMessageInvocationDidFinish:(OfflineMessageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        NSString* strMessage = [response valueForKey:@"message"];
        
        if([strSuccess rangeOfString:@"true"].length>0){
            
            [ConfigManager showAlertMessage:nil Message:strMessage];
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}
-(void)GetRecordingDetailInvocationDidFinish:(GetRecordingDetailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSDictionary *recordDic=[dict objectForKey:@"record"];
        NSMutableArray *beacon = [dict valueForKey:@"Ibeacon"];
        NSMutableArray *response = [dict valueForKey:@"response"];
        
        NSString* strSuccess = NULL_TO_NIL([recordDic valueForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            NSString* strInterval = [NSString stringWithFormat:@"%@",NULL_TO_NIL([recordDic valueForKey:@"recording_interval"])];
            NSString* strStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([recordDic valueForKey:@"recording_status"])];
            NSString* strTimeLimit = [NSString stringWithFormat:@"%@",NULL_TO_NIL([recordDic valueForKey:@"recording_time_limit"])];
            NSString* strLoginStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([recordDic valueForKey:@"login_status"])];
            
            sharedAppDelegate.userObj.recordingLength = strTimeLimit;
            sharedAppDelegate.userObj.recordingStatus = strStatus;
            sharedAppDelegate.userObj.recordingTimeInterval = strInterval;
            sharedAppDelegate.userObj.loginStatus = strLoginStatus;
            
            NSLog(@"%@",sharedAppDelegate.userObj.recordingLength);
            NSLog(@"%@",sharedAppDelegate.userObj.recordingStatus);
            NSLog(@"%@",sharedAppDelegate.userObj.recordingTimeInterval);
            NSLog(@"%@",sharedAppDelegate.userObj.loginStatus);
            
            NSLog(@"sharedAppDelegate.userObj.fname = %@ , %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname);
            
            
            NSString *str_name_string = [NSString stringWithFormat:@"%@_%@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
            NSString *str_key = [NSString stringWithFormat:@"%@_%@",sharedAppDelegate.userObj.userId,str_name_string];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification"
                                                                object:nil
                                                              userInfo:@{@"userId" :str_key}];
            
            
        }
        if ([beacon count]>0) {
            
            [sharedAppDelegate loadIbeaconsItems:beacon];
        }
        if ([response count]>0) {
            
            
            sharedAppDelegate.unreadMsgCount = [NULL_TO_NIL([response valueForKey:@"chatCount"]) integerValue];
            
            sharedAppDelegate.unreadTagCount = [NULL_TO_NIL([response valueForKey:@"tagCount"]) integerValue];
            
            sharedAppDelegate.unreadUserNotifiationCount = [NULL_TO_NIL([response valueForKey:@"callCount"]) integerValue];
            
            sharedAppDelegate.unreadContactCount = [NULL_TO_NIL([response valueForKey:@"contactCount"]) integerValue];
            
            
            sharedAppDelegate.userObj.clockInTagId = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagId"])];
            
            sharedAppDelegate.userObj.clockInTagTitle = [NSString stringWithFormat:@"%@",NULL_TO_NIL([response valueForKey:@"tagTitle"])];
            
            NSLog(@"%@",sharedAppDelegate.userObj.clockInTagId);
            NSLog(@"%@",sharedAppDelegate.userObj.clockInTagTitle);
            
            
        }
        
        if (sharedAppDelegate.userObj.loginStatus==nil || sharedAppDelegate.userObj.loginStatus==(NSString*)[NSNull null] || [sharedAppDelegate.userObj.loginStatus isEqualToString:@""]) {
            
        }
        else
        {
            if ([sharedAppDelegate.userObj.loginStatus isEqualToString:@"0"]) {
                
                if([ConfigManager isInternetAvailable])
                {
                    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Logging Out..." width:150];
                    AmityCareServices *service = [[AmityCareServices alloc] init];
                    [service logoutInvocation:sharedAppDelegate.userObj.userId delegate:self];
                }
                
                else
                {
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
                
            }
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
}
-(void)UploadBackgroundRecordingInvocationDidFinish:(UploadBackgroundRecordingInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
}
#pragma mark- Invocation Delegates
-(void)logoutInvocationDidFinish:(LogoutInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        if(!error)
        {
            NSLog(@"Logout response=%@", dict);
            
            id response = [dict objectForKey:@"response"];
            
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    [sharedAppDelegate logoutFromApp];
                }
                else if([strSuccess rangeOfString:@"false"].length>0){
                    [ConfigManager showAlertMessage:nil Message:@"Logout Failed"];
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
        [DSBezelActivityView removeView];
    }
}
#pragma mark- UIALERTVIEW

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma upload background recording methods-------------

-(void)checkTimeIntervalTimer
{
    NSLog(@"checkTimeIntervalTimer");
    
    [self startBackgroundRecording];
    
    unsigned long int timeInterval=[sharedAppDelegate.userObj.recordingTimeInterval intValue]*60;
    
    if (audioIntervalTimer==nil) {
        
        audioIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                              target:self
                                                            selector:@selector(startBackgroundRecording)
                                                            userInfo:nil
                                                             repeats:YES];
    }
    
    
    [audioIntervalTimer fire];
}
-(void)checkDurationTimer
{
    NSLog(@"checkDurationTimer");
    
    unsigned long int timeDuraion=[sharedAppDelegate.userObj.recordingLength intValue];
    
    NSLog(@"%@",sharedAppDelegate.userObj.recordingLength);
    NSLog(@"%@",sharedAppDelegate.userObj.recordingStatus);
    NSLog(@"%@",sharedAppDelegate.userObj.recordingTimeInterval);
    
    NSLog(@"%lu",timeDuraion);
    NSLog(@"%lu",durationCounter);
    
    
    if (timeDuraion==durationCounter) {
        
        NSLog(@"timeDuraion==durationCounter");
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        [self stopBackgroundRecording];
    }
    
    durationCounter=durationCounter+1;
    
}
-(void)startBackgroundRecording
{
    NSLog(@"startBackgroundRecording");
    
    isRecording=TRUE;
    
    [sharedAppDelegate startUpdatingLocation];
    
    // self.startBackgroundLatitude=[NSString stringWithFormat:@"%f",latitude];
    // self.startBackgroundLongitude=[NSString stringWithFormat:@"%f",longitude];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    // Create a new dated file
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    self.recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [self documentsDirectoryPath ], caldate];
    
    NSURL *url = [NSURL fileURLWithPath:self.recorderFilePath];
    err = nil;
    soundRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    soundRecorder.delegate=self;
    soundRecorder.meteringEnabled = YES;
    if(!soundRecorder){
        
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [soundRecorder prepareToRecord];
    [soundRecorder record];
    
    durationCounter=1;
    
    if (audioProgressTimer==nil) {
        
        audioProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(checkDurationTimer)
                                                            userInfo:nil
                                                             repeats:YES];
        [audioProgressTimer fire];
    }
    
    
}
-(void)stopBackgroundRecording
{
    NSLog(@"stopBackgroundRecording");
    
    isRecording=FALSE;
    
    [soundRecorder stop];
    
    [sharedAppDelegate startUpdatingLocation];
    
    
    NSURL *url = [NSURL fileURLWithPath: self.recorderFilePath];
    NSError *err = nil;
    self.audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    
    if(!self.audioData)
        NSLog(@"audio data: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
    
    NSLog(@"%lu",(unsigned long)[self.audioData length]);
    
    self.startBackgroundLatitude=[NSString stringWithFormat:@"%f",latitude];
    self.startBackgroundLongitude=[NSString stringWithFormat:@"%f",longitude];
    
    
    if (self.audioData.length==0 || self.audioData==nil) {
        
        
    }
    else
    {
        
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        //AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        NSError* error;
        
        [audioSession setPreferredIOBufferDuration:audioRouteOverride error:&error];
        
        [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
        [audioSession setActive:YES error: nil];
        
        if([ConfigManager isInternetAvailable]){
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue,
                           ^{
                               
                               dispatch_sync(dispatch_get_main_queue(),
                                             ^{
                                                 
                                                 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                                 [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                                                 
                                                 [dict setObject:@"attachment" forKey:@"attachment_key"];
                                                 [dict setObject:@"uploadRecording" forKey:@"request_path"];
                                                 [dict setObject:self.startBackgroundLatitude forKey:@"latitude"];
                                                 [dict setObject:self.startBackgroundLongitude forKey:@"longitude"];
                                                 
                                                 [dict setObject:@"audio.mp3" forKey:@"filename"];
                                                 [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
                                                 
                                                 NSLog(@"%@",dict);
                                                 
                                                 [[AmityCareServices sharedService] UploadBackgroundRecordingInvocation:dict data:self.audioData delegate:self];
                                                 
                                             });
                           });
            
            
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
        
    }
}

-(NSString *)documentsDirectoryPath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [dirPaths objectAtIndex:0];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    return documentPath;
}
-(void)invalidateRecordingTimers
{
    NSLog(@"invalidateRecordingTimers");
    
    [audioIntervalTimer invalidate];
    audioIntervalTimer=nil;
    
    [audioProgressTimer invalidate];
    audioProgressTimer=nil;
    
    if (isRecording==TRUE) {
        
        [sharedAppDelegate stopBackgroundRecording];
        
    }
    isRecording=FALSE;
    
    
}

#pragma mark iBeacons methods-

/////////////////// ibeacon start //////////////////////


- (void)loadIbeaconsItems:(NSMutableArray*)beaconArray
{
    [self CanDeviceSupportAppBackgroundRefresh];
    
    self.arrIBeaconsList=[[NSMutableArray alloc] init];
    self.arrInRangeIbeacons=[[NSMutableArray alloc] init];
    
    
    
    
    for (int i=0; i<[beaconArray count]; i++) {
        
        
        self.uuidRegex=nil;
        self.selectedBeacon=nil;
        self.uuid=nil;
        
        self.fMinorValue=nil;
        self.fMajorValue=nil;
        self.fDeviceId=nil;
        self.fDeviceName=nil;
        
        NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
        self.uuidRegex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
        
        
        self.fMinorValue=[NSString stringWithFormat:@"%@",[[beaconArray objectAtIndex:i] objectForKey:@"minor"]];
        
        self.fMajorValue=[NSString stringWithFormat:@"%@",[[beaconArray objectAtIndex:i] objectForKey:@"major"]];
        
        self.fDeviceId=[NSString stringWithFormat:@"%@",[[beaconArray objectAtIndex:i] objectForKey:@"uuid"]];
        
        self.fDeviceName=[NSString stringWithFormat:@"%@",[[beaconArray objectAtIndex:i] objectForKey:@"device_name"]];
        
        if (self.fMinorValue==nil || self.fMinorValue==(NSString*)[NSNull null]) {
            
            self.fMinorValue=@"";
        }
        if (self.fMajorValue==nil || self.fMajorValue==(NSString*)[NSNull null]) {
            
            self.fMajorValue=@"";
        }
        
        if (self.fDeviceId==nil || self.fDeviceId==(NSString*)[NSNull null]) {
            
            self.fDeviceId=@"";
        }
        if (self.fDeviceName==nil || self.fDeviceName==(NSString*)[NSNull null]) {
            
            self.fDeviceName=@"";
        }
        
        NSInteger numberOfMatches = [self.uuidRegex numberOfMatchesInString:self.fDeviceId
                                                                    options:kNilOptions
                                                                      range:NSMakeRange(0, self.fDeviceId.length)];
        
       // NSLog(@"numberOfMatches %ld",(long)numberOfMatches);
        
        if (numberOfMatches > 0) {
            
          //  NSLog(@"numberOfMatches>0");
            
            
            if (self.fMinorValue.length>0 && self.fMajorValue.length>0 && self.fDeviceId.length>0 && self.fDeviceName.length>0) {
                
                
                self.uuid = [[NSUUID alloc] initWithUUIDString:self.fDeviceId];
                
                self.selectedBeacon= [[RWTItem alloc] initWithName:self.fDeviceName
                                                              uuid:self.uuid
                                                             major:[self.fMajorValue intValue]
                                                             minor:[self.fMinorValue intValue]];
                
                self.selectedBeacon.currentBeaconName=self.fDeviceName;
                
                
                self.selectedBeacon.currentProximity=@"";
                
                [self.arrIBeaconsList addObject:self.selectedBeacon];
                
                [self setItem:self.selectedBeacon];
                
                [self startMonitoringItem:self.selectedBeacon];
                
                [self persistItems];
            }
            
        }
        
    }
    
    [self.arrIBeaconsList copy];
    
    
    //    [self.arrIBeaconsList addObject:self.selectedBeacon];
    //
    //    [self setItem:self.selectedBeacon];
    //
    //    [self startMonitoringItem:self.selectedBeacon];
    //
    //    [self persistItems];
    
    
    BOOL monitoringAvailable = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    
//    NSLog(@"Monitoring available: %@", [NSNumber numberWithBool:monitoringAvailable]);
    NSArray *locationServicesAuthStatuses = @[@"Not determined",@"Restricted",@"Denied",@"Authorized"];
    NSArray *backgroundRefreshAuthStatuses = @[@"Restricted",@"Denied",@"Available"];
    
    unsigned long int lsAuth = (int)[CLLocationManager authorizationStatus];
  //  NSLog(@"Location services authorization status: %@", [locationServicesAuthStatuses objectAtIndex:lsAuth]);
    
    unsigned long int brAuth = (int)[[UIApplication sharedApplication] backgroundRefreshStatus];
   // NSLog(@"Background refresh authorization status: %@", [backgroundRefreshAuthStatuses objectAtIndex:brAuth]);
    
    
   // NSLog(@"%lu",(unsigned long)[self.arrIBeaconsList count]);
    
}

- (void)persistItems {
    
    NSMutableArray *itemsDataArray = [NSMutableArray array];
    //   for (RWTItem *item in self.arrIBeaconsList) {
    NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:self.selectedBeacon];
    [itemsDataArray addObject:itemData];
    // }
    [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:kRWTStoredItemsKey];
}
- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    
  //  NSLog(@"beaconRegionWithItem");
    
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.selectedBeacon.uuid
                                                                           major:self.selectedBeacon.majorValue
                                                                           minor:self.selectedBeacon.minorValue
                                                                      identifier:self.selectedBeacon.name];
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        NSLog(@"I'm looking for a beacon");
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    } else {
        NSLog(@"Device doesn't support beacons ranging");
    }
    
    return beaconRegion;
}

- (void)startMonitoringItem:(RWTItem *)item {
    
   // NSLog(@"startMonitoringItem");
    
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:self.selectedBeacon];
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    
}

- (void)stopMonitoringItem:(RWTItem *)item {
    
   // NSLog(@"stopMonitoringItem");
    
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:self.selectedBeacon];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}
- (void)setItem:(RWTItem *)item {
    
  //  NSLog(@"setItem");
    
    if (_beaconItem) {
        [_beaconItem removeObserver:self forKeyPath:@"lastSeenBeacon"];
        
       // NSLog(@"setItem1");
        
    }
    
    _beaconItem = self.selectedBeacon;
    [_beaconItem addObserver:self forKeyPath:@"lastSeenBeacon" options:NSKeyValueObservingOptionNew context:NULL];
    
   // NSLog(@"item.name %@",item.name);
    
    // NSLog(@"fgsdgkhdjk %@",[self nameForProximity:self.beaconItem.lastSeenBeacon.proximity]);
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //  NSLog(@"observeValueForKeyPath");
    
    
}

- (NSString *)nameForProximity:(CLProximity)proximity {
    
    // NSLog(@"proximity %d",proximity);
    
    switch (proximity) {
        case CLProximityUnknown:
            return @"Unknown";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityFar:
            return @"Far";
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
   // NSLog(@"didExitRegion");
    
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
    }
}
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
    
    
    sharedAppDelegate.beaconsProximity=@"NO";
    
   // NSLog(@"monitoringDidFailForRegion %@ %@", region, error.localizedDescription);
    
    for (CLRegion *monitoredRegion in manager.monitoredRegions) {
        
       // NSLog(@"monitoredRegion: %@", monitoredRegion);
    }
    if ((error.domain != kCLErrorDomain || error.code != 5) &&
        [manager.monitoredRegions containsObject:region]) {
        NSString *message = [NSString stringWithFormat:@"%@ %@",
                             region, error.localizedDescription];
        
        [ConfigManager showAlertMessage:@"monitoringDidFailForRegion" Message:message];
    }
}
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    
   // NSLog(@"didRangeBeacons:(NSArray *)beacons");
    
    
    for (CLBeacon *beacon in beacons) {
        
        for (RWTItem *item in self.arrIBeaconsList) {
            
            
//            NSLog(@"majorValue %d",item.majorValue);
//            NSLog(@"minorValue %d",item.minorValue);
//            NSLog(@"name %@",item.name);
//            NSLog(@"uuid %@",item.uuid);
            
            
            if ([item isEqualToCLBeacon:beacon]) {
                
                item.lastSeenBeacon=nil;
                
                item.lastSeenBeacon = beacon;
                
               // NSLog(@"%d",item.majorValue);
                
               // NSLog(@"%@",[self nameForProximity:item.lastSeenBeacon.proximity]);
                
                NSString *strProximity=[self nameForProximity:item.lastSeenBeacon.proximity];
                
                if ([strProximity isEqualToString:@"Immediate"] ||[strProximity isEqualToString:@"Near"] || [strProximity isEqualToString:@"Far"])
                    
                {
                    
                    
                    if ([self.arrInRangeIbeacons containsObject:item]) {
                        
                    }
                    else
                    {
                        
                        [self.arrInRangeIbeacons addObject:item];
                        
                    }
                    
                    
                    
                    
                    sharedAppDelegate.beaconsProximity=@"YES";
                    
                }
                
                else
                {
                    
                    [standardUserDefault synchronize];
                    
                    
                    
                    if ([self.arrInRangeIbeacons containsObject:item]) {
                        
                        [self.arrInRangeIbeacons removeObject:item];
                    }
                    
                }
                
                
                
                item.currentProximity=strProximity;
                
                
            }
            
            else
            {
                
                sharedAppDelegate.beaconsProximity=@"NO";
                
            }
            
            
        }
        
        
    }
    
    /*  for (CLBeacon *beacon in beacons) {
     
     for (int i=0; i<[self.arrIBeaconsList count]; i++) {
     
     self.selectedBeacon=nil;
     
     self.selectedBeacon=[self.arrIBeaconsList objectAtIndex:i];
     
     self.selectedBeacon.lastSeenBeacon=nil;
     
     NSLog(@"majorValue %d",self.selectedBeacon.majorValue);
     NSLog(@"minorValue %d",self.selectedBeacon.minorValue);
     NSLog(@"name %@",self.selectedBeacon.name);
     NSLog(@"uuid %@",self.selectedBeacon.uuid);
     
     
     
     
     if ([self.selectedBeacon isEqualToCLBeacon:beacon]) {
     
     self.selectedBeacon.lastSeenBeacon = beacon;
     
     NSString *strProximity=[self nameForProximity:self.selectedBeacon.lastSeenBeacon.proximity];
     
     if ([strProximity isEqualToString:@"Immediate"] ||[strProximity isEqualToString:@"Near"] || [strProximity isEqualToString:@"Far"])
     
     {
     
     
     if ([self.arrInRangeIbeacons containsObject:self.selectedBeacon]) {
     
     }
     else
     {
     
     [self.arrInRangeIbeacons addObject:self.selectedBeacon];
     
     }
     
     
     
     
     sharedAppDelegate.beaconsProximity=@"YES";
     
     }
     
     else
     {
     
     if ([self.arrInRangeIbeacons containsObject:self.selectedBeacon]) {
     
     [self.arrInRangeIbeacons removeObject:self.selectedBeacon];
     }
     
     }
     
     self.selectedBeacon.currentProximity=strProximity;
     }
     
     }
     
     
     }*/
    
}


- (void)beaconManager:(id)manager didStartMonitoringForRegion:(CLBeaconRegion *)region
{
    NSLog(@"didStartMonitoringForRegion");
    
}
-(BOOL)CanDeviceSupportAppBackgroundRefresh
{
    // Override point for customization after application launch.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        NSLog(@"Background updates are available for the app.");
        return YES;
    }
    else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
        return NO;
    }
    else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
        return NO;
    }
    
    return YES;
}


@end
