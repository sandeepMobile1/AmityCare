//
//  MessagesListVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "MessagesListVC.h"
#import "ChatDetailVC.h"
#import "MessageListCell.h"
#import "QSStrings.h"
#import "TopNavigationView.h"
#import "MFSideMenu.h"
#import "MessageD.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface MessagesListVC ()<ChatListInvocationDelegate,TopNavigationViewDelegate>

@end

@implementation MessagesListVC
@synthesize arrMessageData,chatView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    checkPN=@"YES";
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    if([ConfigManager isInternetAvailable]){
        [self requestForMessageList];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
    navigation.lblTitle.text = @"Messages";
    
    if (!IS_DEVICE_IPAD) {
        
        [navigation.leftBarButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        
    }
    //[self.view addSubview:navigation];
    
    self.arrMessageData = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForNotificationMessageList) name:AC_USER_MESSAGE_RECIEVE object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)leftBarButtonDidClicked:(id)sender{
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- custom methods
-(void)requestForNotificationMessageList
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching message list" width:200.0f];
        [[AmityCareServices sharedService] getChatListInvocation:sharedAppDelegate.userObj.userId delegate:self];
    }
    
}
-(void)requestForMessageList
{
    //    [self.arrMessageData removeAllObjects];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching message list" width:200.0f];
    [[AmityCareServices sharedService] getChatListInvocation:sharedAppDelegate.userObj.userId delegate:self];
    
    
}

#pragma mark- -----------
#pragma mark- UITableView Delegate
#pragma mark- UITableViewDataSource Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* chatCellIdentifier = @"ChatListCell";
    
    chatCell = (ChatListTableViewCell*)[tblMessageList dequeueReusableCellWithIdentifier:chatCellIdentifier];
    
    if (Nil == chatCell)
    {
        chatCell = [ChatListTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    chatCell.imgView.layer.cornerRadius = floor(chatCell.imgView.frame.size.width/2);
    chatCell.imgView.clipsToBounds = YES;
    
    chatCell.lblUserName.font= [UIFont fontWithName:boldfontName size:15.0f];
    chatCell.lblMessage.font= [UIFont fontWithName:appfontName size:12.0f];
    chatCell.lblDateTime.font= [UIFont fontWithName:appfontName size:12.0f];
    
    
    MessageD *mData=[self.arrMessageData objectAtIndex:indexPath.row];
    
    if(!mData.isRead){
        
        [chatCell setBackgroundColor:[UIColor colorWithRed:0.8823529411 green:0.8823529411 blue:0.8823529411 alpha:1.0]];
        
    }
    else{
        [chatCell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    [chatCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,mData.sender_image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    chatCell.lblUserName.text = mData.sender_uname;
    
    chatCell.lblDateTime.text = mData.msg_display_time;
    
    NSLog(@"%@",mData.msg_text);
    
    if ([mData.fileType isEqualToString:@"text"])
        chatCell.lblMessage.text = mData.msg_text;
    else if([mData.fileType isEqualToString:@"pdf"])
        chatCell.lblMessage.text = @"pdf";
    else if([mData.fileType isEqualToString:@"image"])
        chatCell.lblMessage.text = @"image";
    else if([mData.fileType isEqualToString:@"audio"])
        chatCell.lblMessage.text = @"audio";
    
    return chatCell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.arrMessageData count];
}

/*-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
 if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
 [tableView setSeparatorInset:UIEdgeInsetsZero];
 }
 
 if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
 [tableView setLayoutMargins:UIEdgeInsetsZero];
 }
 
 if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
 [cell setLayoutMargins:UIEdgeInsetsZero];
 }
 }*/


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
        NSLog(@"didSelectRowAtIndexPath > updateUnreadMessage");
        
        
        MessageD *mData=[self.arrMessageData objectAtIndex:indexPath.row];
        
        mData.isRead = TRUE;
        [tblMessageList reloadData];
        
        unsigned long int individualCount = [mData.individualCount integerValue];
        unsigned long int unreadMsgCount = sharedAppDelegate.unreadMsgCount - individualCount;
        
        sharedAppDelegate.unreadMsgCount = unreadMsgCount;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUnreadMessage" object:nil];
        

        
        if (IS_DEVICE_IPAD) {
            
            self.chatView = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
        }
        else
        {
            self.chatView = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
        }
        self.chatView.msgListSelected = TRUE;
        checkPN=@"NO";
        self.chatView.backBtnVisibility=@"YES";
        
        self.chatView.mData = (MessageD*)[self.arrMessageData objectAtIndex:indexPath.row];
        [self.view addSubview:self.chatView.view];
        //[self.navigationController pushViewController:chatView animated:YES];
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark- Invocation
-(void)chatListInvocationDidFinish:(ChatListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"chatListInvocationDidFinish =%@",dict);
    @try {
        
        if(!error){
            
            
            id response = NULL_TO_NIL([dict valueForKey:@"response"]);
            
            int unreadCount = [NULL_TO_NIL([response valueForKey:@"unreadCount"]) intValue];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                [self.arrMessageData removeAllObjects];
                
                NSArray* arrmsg = NULL_TO_NIL([response valueForKey:@"ChatDetail"]);
                
                if(arrmsg >0){
                    for (int i=0; i<[arrmsg count]; i++) {
                        
                        NSDictionary* mDict = [arrmsg objectAtIndex:i];
                        MessageD* m = [[MessageD alloc] init];
                        
                        m.msg_id = [mDict valueForKey:@"msgId"];
                        m.msg_date = [mDict valueForKey:@"date"];
                        m.msg_display_time = [mDict valueForKey:@"created"];
                        // m.msg_text = [[NSString alloc] initWithData:[QSStrings decodeBase64WithString:NULL_TO_NIL([mDict valueForKey:@"message"])] encoding:NSUTF8StringEncoding];
                        
                        NSString *msgStr=NULL_TO_NIL([mDict valueForKey:@"message"]);
                        
                        msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                        
                        m.msg_text = [[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                        
                        m.sender_uname = [mDict valueForKey:@"friend_name"];
                        m.sender_id = NULL_TO_NIL([mDict valueForKey:@"friend_id"]);
                        m.sender_image = [mDict valueForKey:@"friend_image"];
                        m.isRead = [NULL_TO_NIL([mDict valueForKey:@"status"]) isEqualToString:@"read"]?TRUE:FALSE;
                        m.fileType = NULL_TO_NIL([mDict valueForKey:@"text_type"]);
                        m.fileName= NULL_TO_NIL([mDict valueForKey:@"file"]);
                        m.individualCount= NULL_TO_NIL([mDict valueForKey:@"individualCount"]);

                        
                        [self.arrMessageData addObject:m];
                    }
                    
                }
            }
            else if ([strSuccess rangeOfString:@"false"].length>0){
                [ConfigManager showAlertMessage:nil Message:@"No messages"];
            }
            [tblMessageList reloadData];
            
            sharedAppDelegate.unreadMsgCount = unreadCount;

            if( sharedAppDelegate.unreadMsgCount >0){
                [[NSNotificationCenter defaultCenter] postNotificationName:AC_UPDATE_MESSAGE_COUNT object:nil userInfo:nil];
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
    
    checkPN=@"NO";
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}



@end
