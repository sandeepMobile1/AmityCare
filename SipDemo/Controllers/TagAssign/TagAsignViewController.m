//
//  TagAsignViewController.m
//  Amity-Care
//
//  Created by Om Prakash on 06/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TagAsignViewController.h"
#import "TagInUserViewController.h"
#import "TagsListInvocation.h"
#import "Tags.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface TagAsignViewController ()<TagsListInvocationDelegate>

@end

@implementation TagAsignViewController

@synthesize arrayTags,arrSearchList,checkView,tagUser;

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
 
    self.arrayTags = [[NSMutableArray alloc]init];
    self.arrSearchList = [[NSMutableArray alloc]init];
    
    
    UIImage *searchBg = [UIImage imageNamed:@"search_box.png"];
    [[UISearchBar appearance] setBackgroundImage:searchBg];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_box.png"] forState:UIControlStateNormal];
    
    searchBar.layer.borderColor = [[UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:0.3f] CGColor];
    searchBar.layer.borderWidth = 1.0f;
    searchBar.clipsToBounds = YES;
    
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
    
    /*if (!IS_DEVICE_IPAD) {
     
     if (DEVICE_OS_VERSION>=7) {
     
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     [tblData setFrame:CGRectMake(0, 108, 320, 460)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [tblData setFrame:CGRectMake(0, 1088, 320, 460-IPHONE_FIVE_FACTOR)];
     
     }
     }
     else
     {
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     
     [searchBar setFrame:CGRectMake(0, 64, searchBar.frame.size.width, searchBar.frame.size.height)];
     
     [tblData setFrame:CGRectMake(0, 108, 320, 445)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     [searchBar setFrame:CGRectMake(0, 64, searchBar.frame.size.width, searchBar.frame.size.height)];
     
     [tblData setFrame:CGRectMake(0, 108, 320, 445-IPHONE_FIVE_FACTOR)];
     
     }
     }
     
     }*/
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Loading..." width:200];
        [[AmityCareServices sharedService] tagListInvocation:sharedAppDelegate.userObj.userId delegate:self];    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
#pragma mark - TagsList Invocation Delegate

-(void)tagsListInvocationDidFinish:(TagsListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error{
    
    NSLog(@"TagsInvocationDidFinish = %@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                [self.arrayTags removeAllObjects];
                
                NSArray *tagsArr = NULL_TO_NIL([response valueForKey:@"Tag"]);
                
                for (int i=0; i < [tagsArr count]; i++) {
                    
                    Tags *tagData = [[Tags alloc ] init];
                    
                    NSDictionary *tagsD = [tagsArr objectAtIndex:i];
                    
                    tagData.tagId = NULL_TO_NIL([tagsD valueForKey:@"id"]);
                    tagData.tagTitle = NULL_TO_NIL([tagsD valueForKey:@"title"]);
                    
                    [self.arrayTags addObject:tagData];
                }
                
                NSLog(@"ArrayDAta = %@",self.arrayTags);
                [tblData reloadData];
                
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
                [ConfigManager showAlertMessage:nil Message:@"Tags not found."];
                
            }
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :::::: %@",exception);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
    
}

#pragma mark- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return isSearchEnable?[self.arrSearchList count]:[self.arrayTags count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString* cellIdenitifier = @"TagsCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenitifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Tags *c = isSearchEnable?(Tags*)[self.arrSearchList objectAtIndex:indexPath.row]:(Tags*)[self.arrayTags objectAtIndex:indexPath.row];
    
    cell.textLabel.text = c.tagTitle;
    cell.textLabel.textColor = TEXT_COLOR_GREEN;
    cell.textLabel.font = [UIFont fontWithName:appfontName size:15.0];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (checkView==FALSE) {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.tagUser = [[TagInUserViewController alloc ]  initWithNibName:@"TagInUserViewController" bundle:nil];
            
        }
        else
        {
            self.tagUser = [[TagInUserViewController alloc ]  initWithNibName:@"TagInUserViewController_iphone" bundle:nil];
            
        }
        
        Tags *data = isSearchEnable?(Tags*)[self.arrSearchList objectAtIndex:indexPath.row]:(Tags*)[self.arrayTags objectAtIndex:indexPath.row];
        self.tagUser.tag_id = data.tagId;
        
        [self.view addSubview:self.tagUser.view];
        
    }
    else
    {
        Tags *data = isSearchEnable?(Tags*)[self.arrSearchList objectAtIndex:indexPath.row]:(Tags*)[self.arrayTags objectAtIndex:indexPath.row];
        
        sharedAppDelegate.strScheduleTagId=data.tagId;
        sharedAppDelegate.strScheduleTagName=data.tagTitle;
        
        NSNotification* notification = [NSNotification notificationWithName:AC_SELECT_TAG_FOR_SCHEDULE object:nil userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self.view removeFromSuperview];
    }
    
    
    //  [self.navigationController pushViewController:tagUser animated:YES];
}


#pragma mark- UISearchBarDelegate
-(void)filterContacts:(NSString*)text
{
    NSLog(@"filterContacts =%@",text);
    
    [self.arrSearchList removeAllObjects];
    for(Tags *data in self.arrayTags)
    {
        NSString *strName = data.tagTitle;
        if([[strName lowercaseString] rangeOfString:[text lowercaseString]].length>0)
        {
            [self.arrSearchList addObject:data];
            NSLog(@"match found");
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    NSLog(@"searchBarSearchButtonClicked text =%@",search.text);
    isSearchEnable=TRUE;
    [self filterContacts:search.text];
    [tblData reloadData];
    [search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    NSLog(@"searchBar =%@ textDidChange  =%@",search.text,searchText);
    
    if(searchText.length==0){
        isSearchEnable = FALSE;
        [tblData reloadData];
    }
    else{
        isSearchEnable=TRUE;
        [self filterContacts:searchText];
        [tblData reloadData];
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
    
    
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
