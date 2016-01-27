//
//  UserTagsVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 31/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "UserTagsVC.h"
#import "TopNavigationView.h"
#import "TagCell.h"
#import "MBProgressWrapper.h"
#import "PasswordView.h"
#import "TagAsignViewController.h"
#import "MFSideMenu.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface UserTagsVC () <TagsInvocationDelegate,PasswordViewDelegate,TopNavigationViewDelegate>
@property (nonatomic,strong)NSMutableArray *arrTagsList;
@end

@implementation UserTagsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
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
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
    navigation.lblTitle.text = @"Tags";
    
    if (!IS_DEVICE_IPAD) {
        
        [navigation.leftBarButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        
    }
    
    NSLog(@"Role ID %@",sharedAppDelegate.userObj.role_id);
    
    if([sharedAppDelegate.userObj.role_id isEqualToString:@"3"])
    {
        UIButton *btnAsignTag = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAsignTag setFrame:CGRectMake(435, CGRectGetMinY(navigation.rightBarButton.frame)+6, 74, 21)];
        [btnAsignTag setBackgroundImage:[UIImage imageNamed:@"assign_tags.png"] forState:UIControlStateNormal];
        [btnAsignTag addTarget:self action:@selector(btnAsignTagsPressed) forControlEvents:UIControlEventTouchUpInside];
        [navigation addSubview:btnAsignTag];
    }
    
    [self.view addSubview:navigation];
    
    _arrTagsList = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTag) name:AC_UPDATE_TAG_LIST object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}
/*- (void)viewDidLayoutSubviews
 {
 if (!IS_DEVICE_IPAD) {
 
 if (IS_IPHONE_5) {
 
 [self.view setFrame:CGRectMake(0, 0, 320, 568)];
 [tblViewTagsList setFrame:CGRectMake(0, 54, 320, 510)];
 }
 else
 {
 [self.view setFrame:CGRectMake(0, 0, 320, 480)];
 
 [tblViewTagsList setFrame:CGRectMake(0, 64, 320, 400)];
 
 }
 }
 }*/
-(void)leftBarButtonDidClicked:(id)sender{
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
-(IBAction)backbtnpressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
-(void)updateTag
{
    [self.arrTagsList removeAllObjects];
    
    if([ConfigManager isInternetAvailable]){
        
        [self fetchAssignedTags];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET ];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
            
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [tblViewTagsList setFrame:CGRectMake(0, 54, 320, 510)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [tblViewTagsList setFrame:CGRectMake(0, 54, 320, 510-IPHONE_FIVE_FACTOR)];
                
            }
        }
        
        else
        {
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [tblViewTagsList setFrame:CGRectMake(0, 58, 320, 495)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [tblViewTagsList setFrame:CGRectMake(0, 58, 320, 495-IPHONE_FIVE_FACTOR)];
                
            }
        }
        
    }
    
    
    NSLog(@"Role ID %@",sharedAppDelegate.userObj.role_id);
    
    [sharedAppDelegate startUpdatingLocation];
    
    self.navigationController.navigationBarHidden = YES;
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    if([ConfigManager isInternetAvailable]){
        
        [self fetchAssignedTags];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET ];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------
#pragma mark- Custom

-(void)btnAsignTagsPressed{
    
    TagAsignViewController *tagVC;
    
    if (IS_DEVICE_IPAD) {
        
        tagVC = [[TagAsignViewController alloc]initWithNibName:@"TagAsignViewController" bundle:nil];
    }
    else
    {
        tagVC = [[TagAsignViewController alloc]initWithNibName:@"TagAsignViewController_iphone" bundle:nil];
    }
    tagVC.checkView=FALSE;
    
    [self.navigationController pushViewController:tagVC animated:YES];
}



-(void)fetchAssignedTags
{
    [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
    [[AmityCareServices sharedService] tagInvocation:sharedAppDelegate.userObj.userId delegate:self];
}


#pragma mark---------
#pragma mark- UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrTagsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    TagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.tagData = [_arrTagsList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
}

-(void)secureCredentialDidCancel:(PasswordView *)view
{
    [view removeFromSuperview];
}

-(void)secureCredentialDidSubmitted:(PasswordView *)view
{
    [view removeFromSuperview];
    
    
}

#pragma mark- Invocations

/*
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
 UserFeedsVC *feeds = [[UserFeedsVC alloc] initWithNibName:@"UserFeedsVC" bundle:nil];
 feeds.userDidClockedIn = TRUE;
 feeds.selectedTag = [_arrTagsList objectAtIndex:selectedIndex];
 [self.navigationController pushViewController:feeds animated:YES];
 
 }
 else
 {
 //                [ConfigManager showAlertMessage:nil Message:@"Clock Out\n You are not in range."];
 UserFeedsVC *feeds = [[UserFeedsVC alloc] initWithNibName:@"UserFeedsVC" bundle:nil];
 feeds.userDidClockedIn = FALSE;
 feeds.selectedTag = [_arrTagsList objectAtIndex:selectedIndex];
 [self.navigationController pushViewController:feeds animated:YES];
 
 }
 }
 else{
 //errror
 [ConfigManager showAlertMessage:nil Message:[error debugDescription]];
 }
 }
 @catch (NSException *exception) {
 
 }
 @finally {
 [DSBezelActivityView removeView];
 }
 }
 */

-(void)tagsInvocationDidFinish:(TagsInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        if(!error)
        {
            NSLog(@"Tags = %@",dict);
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                [_arrTagsList removeAllObjects];
                NSString *strSuccess = [response valueForKey:@"success"];
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSArray *tags = NULL_TO_NIL([response valueForKey:@"Tag"]);
                    
                    for (int i = 0; i < [tags count]; i++) {
                        
                        NSDictionary *tDict = [tags objectAtIndex:i];
                        
                        Tags *tag = [[Tags alloc] init];
                        
                        tag.tagId = NULL_TO_NIL([tDict valueForKey:@"id"]);
                        tag.tagTitle = NULL_TO_NIL([tDict valueForKey:@"title"]);
                        
                        [_arrTagsList addObject:tag];
                    }
                }
                else if([strSuccess rangeOfString:@"False"].length>0)
                {
                    [ConfigManager showAlertMessage:nil Message:@"You have not assigned any Tag"];
                }
                
                [tblViewTagsList reloadData];
                
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

@end
