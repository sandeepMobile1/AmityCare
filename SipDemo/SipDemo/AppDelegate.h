//
//  AppDelegate.h
//  SipDemo
//
//  Created by Shweta Sharma on 09/06/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecentsViewController.h"
#import "PhoneCallDelegate.h"
#include <sys/stat.h>
#include <unistd.h>
#import "CallingView.h"
#import "Reachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>
#import "Tags.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "OfflineMessageInvocation.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "IBeaconD.h"
#import "AmityCareServices.h"
#import "ContactD.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "OfflineMessageInvocation.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "IBeaconD.h"
#import "User.h"
#import "ACContactsVC.h"
#import "HomeViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "GetRecordingDetailInvocation.h"

#import <Sinch/Sinch.h>


#define REACHABILITY_2_0 1

@class AVAudioRecorder;
@class AVAudioSession;
@class AVAudioPlayer;

@class UserHomeViewController;
@class IphoneUserViewController;
@class RWTItem;
@class PinAlertViewController;

extern NSString * const kRWTStoredItemsKey;


@class TestViewController;

@interface AppDelegate : UIApplication <UIApplicationDelegate,CallingViewDelegate,PhoneCallDelegate,CLLocationManagerDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UploadBackgroundRecordingInvocationDelegate,UIAlertViewDelegate,OfflineMessageInvocationDelegate,LogoutInvocationDelegate,CBCentralManagerDelegate,GetRecordingDetailInvocationDelegate,SINClientDelegate,SINCallClientDelegate>
{
    
   // NSString *kRWTStoredItemsKey;
    
    AVAudioRecorder * soundRecorder;
    AVAudioPlayer *audioPlayer;
    NSTimer *audioProgressTimer;
    NSTimer *audioIntervalTimer;
    unsigned long int durationCounter;
    
    NSTimer *beaconTimer;
    // UIAlertView *offlineAlert;
    
    UIBackgroundTaskIdentifier counterTask;
    UIWindow *window;
    // UINavigationController *navController;
    UITabBarController *tabBarController;

    
    BOOL isIpod;

    
#if defined(REACHABILITY_2_0) && REACHABILITY_2_0==1
#endif
    
#if defined(CYDIA) && (CYDIA == 1)
    io_connect_t  root_port; // a reference to the Root Power Domain IOService
    io_object_t   notifierObject; // notifier object, used to deregister later
    IONotificationPortRef  notifyPortRef; // notification port allocated by IORegisterForSystemPower
#endif
}

@property (strong, nonatomic) id<SINClient> client;


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ACContactsVC* acContactsVC;
@property (nonatomic, assign, readonly) RecentsViewController *recentsViewController;
@property (nonatomic, strong)Reachability *_hostReach;
@property (nonatomic, strong)NSString *_phoneNumber;

@property (strong, nonatomic) TestViewController *objTestViewController;
@property (strong, nonatomic) HomeViewController *viewController;
@property (strong, nonatomic) UserHomeViewController *objUserHomeViewController;
@property (strong, nonatomic) IphoneUserViewController *objIphoneUserViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property BOOL isConnected;
@property BOOL isPortrait;
@property BOOL launchDefault;
@property (strong, nonatomic) User *userObj;

@property (strong, nonatomic)UIView *alertviw;
@property (strong, nonatomic)PinAlertViewController *objPinAlertViewController;

@property (strong, nonatomic) ContactD *contactObj;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CallingView *callingView;

@property (strong, nonatomic) NSString *strSelectedTagId;
@property (strong, nonatomic) NSString *strSelectedTag;
@property (strong, nonatomic) NSString *strCheckUserAndTag;
@property(nonatomic,retain)NSString *strScheduleTagId;
@property(nonatomic,retain)NSString *strScheduleTagName;
@property(nonatomic,retain)NSString *strUpdatedTagIntro;
@property(nonatomic,strong)NSString *strCallUserId;
@property(nonatomic,strong)NSString *strCallUserName;

@property(nonatomic,retain)NSString *checkSpecialGroupChat;

@property(nonatomic,strong)Tags *selectedTag;
@property(nonatomic,strong)NSData * mapRouteData;
@property (strong, nonatomic) NSMutableDictionary *dicRouteDetail;

@property (strong, nonatomic) NSString *clockInStatus;

@property (nonatomic, strong) NSString* strDeviceToken;
@property(nonatomic,strong)NSString *calenderCurrentDate;
@property(nonatomic,strong)NSString *calenderServerDate;
@property (strong, nonatomic) NSString *checkSlideMenuAction;
@property (strong, nonatomic) NSString *savedAudioPath;
@property (strong, nonatomic) NSString *beaconsProximity;
@property (strong, nonatomic) NSString *checkBlankSmoothLineView;
@property (strong, nonatomic) MFSideMenuContainerViewController *container;
@property (strong, nonatomic) UINavigationController* tagNavigation;
@property (strong, nonatomic) UINavigationController *globalNavigation;


@property (strong, nonatomic) CBCentralManager *centralManager;

@property (nonatomic, assign) unsigned long int unreadNotifications;
@property (nonatomic, assign) unsigned long int unreadMsgCount;
@property (nonatomic, assign) unsigned long int unreadContactCount;
@property (nonatomic, assign) unsigned long int unreadTagCount;
@property (nonatomic, assign) unsigned long int unreadSpecialGroupChatCount;
@property (nonatomic, assign) unsigned long int unreadGroupChatCount;
@property (nonatomic, assign) unsigned long int unreadUserNotifiationCount;
@property(nonatomic,strong) NSDictionary *dropBoxContentD;
@property (strong, nonatomic)UIImage* routeImage;


@property(nonatomic,retain)NSString *recorderFilePath;
@property(nonatomic,strong)NSString *offlineMemberId;

@property(nonatomic,strong)NSString *startBackgroundLatitude;
@property(nonatomic,strong)NSString *startBackgroundLongitude;
@property(nonatomic,strong)NSString *endBackgroundLatitude;
@property(nonatomic,strong)NSString *endBackgroundLongitude;
@property(nonatomic,assign)BOOL isRecording;
@property (strong, nonatomic) NSMutableArray *arrIBeaconsList;

@property (strong, nonatomic) RWTItem *beaconItem;
@property (strong, nonatomic) RWTItem *selectedBeacon;

@property (strong, nonatomic) NSRegularExpression *uuidRegex;

@property (strong, nonatomic) NSData *audioData;
@property (strong, nonatomic) NSString *strCheckDrawLine;
@property (strong, nonatomic) NSString *uploadRecieptTagId;
@property (strong, nonatomic) NSString *uploadRecieptTagName;
@property (strong, nonatomic) NSString *calendarVisibleStatus;
@property (strong, nonatomic)NSString *fDeviceName;
@property (strong, nonatomic)NSString *fDeviceId;
@property (strong, nonatomic)NSString *fMajorValue;
@property (strong, nonatomic)NSString *fMinorValue;

@property (strong, nonatomic) NSMutableArray *arrInRangeIbeacons;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic)NSUUID *uuid;
@property (strong, nonatomic)NSArray *beaconsArray;

//@property (strong, nonatomic)RWTItem *rItem;
//@property (strong, nonatomic)CLBeaconRegion *beaconRegion;

- (void)loadIbeaconsItems:(NSMutableArray*)beaconArray;
-(void)initSipServices;
- (void)initUserDefaults:(NSMutableDictionary *)dict fromSettings:(NSString *)settings;
- (void)initUserDefaults;

-(void)showChangePasswordAlertAfter90Days;
-(void)showEmployeeDashBoard:(UIViewController*)navigation;
-(void)showManagerDashBoard:(UIViewController*)navigation;

-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

-(UINavigationController*)userTagNavi;
-(void)aGlobalNavigation:(UINavigationController*)navigation;
-(void)logoutFromApp;
-(void)startBackgroundRecording;
-(void)stopBackgroundRecording;
-(void)checkTimeIntervalTimer;
-(void)checkDurationTimer;
-(void)invalidateRecordingTimers;
- (void)showOfflineAlert:(NSString*)memberName memberId:(NSString*)memberId;
- (void)setItem:(RWTItem *)item;
- (void)startMonitoringItem:(RWTItem *)item;
- (void)stopMonitoringItem:(RWTItem *)item;
- (void)persistItems;

- (void)callDisconnecting;
-(void)displayParameterError:(NSString *)msg;
@end

