//
//  TagInUserViewController.m
//  Amity-Care
//
//  Created by Om Prakash on 06/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TagInUserViewController.h"
#import "UIImageView+WebCache.h"
#import "TagsInUserListInvocation.h"
#import "AssignTagInvocation.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface TagInUserViewController ()<TagsInUserListInvocationDelegate,AssignTagInvocationDelegate>

@end

@implementation TagInUserViewController
@synthesize tag_id;
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
    
    /* if (!IS_DEVICE_IPAD) {
     
     if (DEVICE_OS_VERSION>=7) {
     
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     [tblUsersList setFrame:CGRectMake(0, 108, 320, 460)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [tblUsersList setFrame:CGRectMake(0, 108, 320, 460-IPHONE_FIVE_FACTOR)];
     
     }
     }
     else
     {
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     [searchBar setFrame:CGRectMake(0, 64, searchBar.frame.size.width, searchBar.frame.size.height)];
     
     [tblUsersList setFrame:CGRectMake(0, 108, 320, 445)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     [searchBar setFrame:CGRectMake(0, 64, searchBar.frame.size.width, searchBar.frame.size.height)];
     
     [tblUsersList setFrame:CGRectMake(0, 108, 320, 445-IPHONE_FIVE_FACTOR)];
     
     }
     }
     
     }
     
     
     TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
     navigation.lblTitle.text = @"Tags";
     [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     
     UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnDone setFrame:CGRectMake(465, CGRectGetMinY(navigation.rightBarButton.frame)+6, 50, 21)];
     [btnDone setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
     [btnDone addTarget:self action:@selector(btnDonePressed) forControlEvents:UIControlEventTouchUpInside];
     [navigation addSubview:btnDone];*/
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
    
    searchBar.layer.borderColor = [[UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:0.3f] CGColor];
    searchBar.layer.borderWidth = 1.0f;
    searchBar.clipsToBounds = YES;
    
    // [self.view addSubview:navigation];
    
    arrUsersData = [[NSMutableArray alloc]init];
    arrSearchList = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Loading..." width:200];
        [[AmityCareServices sharedService] tagInUsesrListInvocation:sharedAppDelegate.userObj.userId tag_id:tag_id delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
#pragma mark---------
#pragma mark- Custom

-(IBAction)btnDonePressed:(id)sender{
    
    NSMutableArray* arrIds = [[NSMutableArray alloc] init];
    
    for(User* usr in arrUsersData){
        if(usr.isSelected){
            
            NSLog(@"%@",usr.userId);
            [arrIds addObject:usr.userId];
        }
    }
    
    if([arrIds count]!=0)
    {
        NSString* joinedString = [arrIds componentsJoinedByString:@","];
        
        if([ConfigManager isInternetAvailable]){
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Loading..." width:200];
            [[AmityCareServices sharedService]assignTagsInvocation:sharedAppDelegate.userObj.userId tag_id:tag_id users:joinedString delegate:self];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }
    else{
        [ConfigManager showAlertMessage:nil Message:@"Select user to assign tags"];
        return;
    }
}


#pragma mark- UIAlertViewDelegate
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_USERS_ASSIGNED_IN_TAG_SUCCESSFULLY)
    {
        [self.view removeFromSuperview];
        
        // NSArray* array = [self.navigationController viewControllers];
        // [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    }
}

#pragma mark- UITableViewDelegate  & DataSource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenitifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenitifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    User * u = isSearchEnable?[arrSearchList objectAtIndex:indexPath.row]:[arrUsersData objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,u.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    cell.textLabel.textColor = TEXT_COLOR_GREEN;
    cell.textLabel.font = [UIFont fontWithName:appfontName size:15.0];
    cell.textLabel.text = u.username;
    
    if(u.isSelected){
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
    }
    else{
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck.png"]];
    }
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isSearchEnable?[arrSearchList count]:[arrUsersData count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *usr = isSearchEnable?[arrSearchList objectAtIndex:indexPath.row]:[arrUsersData objectAtIndex:indexPath.row];
    usr.isSelected = !usr.isSelected;
    
    [tblUsersList beginUpdates];
    [tblUsersList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [tblUsersList endUpdates];
    
}

#pragma mark- UISearchBarDelegate
-(void)filterContacts:(NSString*)text
{
    NSLog(@"filterContacts =%@",text);
    [arrSearchList removeAllObjects];
    for(User *data in arrUsersData)
    {
        NSString *strName = data.username;
        if([[strName lowercaseString] rangeOfString:[text lowercaseString]].length>0)
        {
            [arrSearchList addObject:data];
            NSLog(@"match found");
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    NSLog(@"searchBarSearchButtonClicked text =%@",search.text);
    isSearchEnable=TRUE;
    [self filterContacts:search.text];
    [tblUsersList reloadData];
    [search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    NSLog(@"searchBar =%@ textDidChange  =%@",search.text,searchText);
    
    if(searchText.length==0){
        isSearchEnable = FALSE;
        [tblUsersList reloadData];
    }
    else{
        isSearchEnable=TRUE;
        [self filterContacts:searchText];
        [tblUsersList reloadData];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)search
{
    NSLog(@"searchBarCancelButtonClicked text =%@",search.text);
    
    isSearchEnable=FALSE;
}

#pragma mark- TopNavigation Delegate

-(void)leftBarButtonDidClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)rightBarButtonDidClicked:(id)sender{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tagInUserDeleage

-(void)assignTagInvocationDidFinish:(AssignTagInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error{
    NSLog(@"assignTagInvocationDidFinish = %@",dict);
    
    @try {
        
        if (!error) {
            
            id response  =  [dict valueForKey:@"response"];
            NSString *strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess isEqualToString:@"true"])
            {
                ACAlertView* successAlert = [ConfigManager alertView:nil message:@"Users assigned in tag successfully" del:self];
                successAlert.alertTag = AC_ALERTVIEW_USERS_ASSIGNED_IN_TAG_SUCCESSFULLY;
                [successAlert show];
            }
            else{
                [ConfigManager showAlertMessage:nil Message:@"Users not assigned, try again later"];
                return;
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

-(void)tagsInUserListInvocationDidFinish:(TagsInUserListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error{
    
    NSLog(@"userListInvocationDidFinish = %@",dict);
    
    @try {
        
        if (!error) {
            
            id response  =  [dict valueForKey:@"response"];
            NSString *strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess isEqualToString:@"true"])
            {
                NSArray *arrUsr = NULL_TO_NIL([response valueForKey:@"users"]);
                
                for (NSDictionary *dic in arrUsr) {
                    
                    User *u = [[User alloc] init];
                    
                    u.fname = NULL_TO_NIL([dic valueForKey:@"first_name"]);
                    u.lname = NULL_TO_NIL([dic valueForKey:@"last_name"]);
                    u.userId = NULL_TO_NIL([dic valueForKey:@"id"]);
                    u.image = NULL_TO_NIL([dic valueForKey:@"userImg"]);
                    u.username = NULL_TO_NIL([dic valueForKey:@"nickname"]);
                    u.role = NULL_TO_NIL([dic valueForKey:@"user_type"]);
                    u.isSelected = [NULL_TO_NIL([dic valueForKey:@"tag"]) boolValue];
                    
                    [arrUsersData addObject:u];
                }
                [tblUsersList reloadData];
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
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

    
}


@end
