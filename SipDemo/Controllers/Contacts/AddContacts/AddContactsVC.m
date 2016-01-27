//
//  AddContactsVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 21/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "AddContactsVC.h"
#import "UIImageView+WebCache.h"
#import "AppContactsCell.h"
#import <QuartzCore/QuartzCore.h>

#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "SendContactRequestInvocation.h"
#import "AppContactsCell.h"

@interface AddContactsVC ()<AppContactsInvoationDelegate,SendContactRequestInvocationDelegate,AppContactCellDelegate>

@end

@implementation AddContactsVC

@synthesize arrAppsContacts,arrSearchContacts;

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
     [tblViewContacts setFrame:CGRectMake(0, 108, 320, 460)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [tblViewContacts setFrame:CGRectMake(0, 108, 320, 460-IPHONE_FIVE_FACTOR)];
     
     }
     
     }
     else
     {
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     
     [searchBar setFrame:CGRectMake(0, 64, searchBar.frame.size.width, searchBar.frame.size.height)];
     
     [tblViewContacts setFrame:CGRectMake(0, 108, 320, 445)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [searchBar setFrame:CGRectMake(0, 64, searchBar.frame.size.width, searchBar.frame.size.height)];
     
     [tblViewContacts setFrame:CGRectMake(0, 108, 320, 445-IPHONE_FIVE_FACTOR)];
     
     }
     
     }
     
     }
     
     if (!IS_DEVICE_IPAD) {
     
     TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
     [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     navigation.lblTitle.text = @"Application Contacts";
     
     [self.view addSubview:navigation];
     }*/
    
    UIImage *searchBg = [UIImage imageNamed:@"search_box.png"];
    [[UISearchBar appearance] setBackgroundImage:searchBg];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_box.png"] forState:UIControlStateNormal];
    
    self.arrAppsContacts = [[NSMutableArray alloc] init];
    self.arrSearchContacts = [[NSMutableArray alloc] init];
    
    [self performSelector:@selector(fetchAppsContacts) withObject:nil afterDelay:0.1f];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)dealloc
{
    NSLog(@"+++++ %@ +++ DEALLOC ",[self class]);
    searchBar = nil;
    [self.arrAppsContacts removeAllObjects];
    [self.arrSearchContacts removeAllObjects];
    self.arrAppsContacts = nil;
    self.arrSearchContacts = nil;
    tblViewContacts = nil;
    
    [super dealloc];
}*/

#pragma mark- TopNavigationDelegate
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- ----------
-(void)fetchAppsContacts
{
    if([ConfigManager isInternetAvailable]){
        
        [self.arrAppsContacts removeAllObjects];
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching contact list..." width:200];
        [[AmityCareServices sharedService] appContactListInvocation:sharedAppDelegate.userObj.userId delegate:self];
        
    }
}

#pragma mark- AppContactCell Delegate

-(void)sendRequestButtonDidClick:(UIButton *)sender
{
    NSLog(@"sendRequestButtonDidClick  =%ld",(long)sender.tag);
    
    selectedCellIndex = sender.tag;
    
    ContactD* cData = isSearchEnable?[self.arrSearchContacts objectAtIndex:sender.tag]:[self.arrAppsContacts objectAtIndex:sender.tag];
    
    if([ConfigManager isInternetAvailable]){
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Sending Request..." width:150];
        [[AmityCareServices sharedService] sendContactRequestInvocation:sharedAppDelegate.userObj.userId memberID:cData.contact_id delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}


#pragma mark- UITableView DataSource0

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 55;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdenitifier = @"ContactsCell";
    
    AppContactsCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
    
    if(!cell)
    {
        NSArray* arr;
        
        if (IS_DEVICE_IPAD) {
            
            arr = [[NSBundle mainBundle] loadNibNamed:@"AppContactsCell" owner:self options:nil];
        }
        else
        {
            arr = [[NSBundle mainBundle] loadNibNamed:@"AppContactsCell_iphone" owner:self options:nil];
        }
        
        cell = [arr objectAtIndex:0];
    }
    cell.delegate = self;
    cell.btnRequest.tag = indexPath.row;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ContactD *cData = isSearchEnable?[self.arrSearchContacts objectAtIndex:indexPath.row]:[self.arrAppsContacts objectAtIndex:indexPath.row];
    
    [cell setContact:cData];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isSearchEnable?[self.arrSearchContacts count]:[self.arrAppsContacts count];
}

#pragma mark- UISearchBar Delegate
#pragma mark- UISearchBarDelegate

-(void)filterContacts:(NSString*)text
{
    [self.arrSearchContacts removeAllObjects];
    
    for(ContactD *data in self.arrAppsContacts)
    {
        NSString *strName = data.userName;
        if([[strName lowercaseString] rangeOfString:[text lowercaseString]].length>0)
        {
            [self.arrSearchContacts addObject:data];
            NSLog(@"match found");
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    isSearchEnable=TRUE;
    [self filterContacts:search.text];
    [tblViewContacts reloadData];
    [search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    if(searchText.length==0){
        isSearchEnable = FALSE;
        [tblViewContacts reloadData];
    }
    else{
        isSearchEnable=TRUE;
        [self filterContacts:searchText];
        [tblViewContacts reloadData];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)search
{
    isSearchEnable=FALSE;
}

#pragma mark- Invocation

-(void)appContactsInvoationDidFinish:(AppContactsInvoation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"appContactsInvoationDidFinish %@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                
                NSArray* array = [response valueForKey:@"contact"];
                
                for (int i=0; i< [array count]; i++) {
                    
                    NSDictionary* cDict = [array objectAtIndex:i];
                    
                    ContactD *cData = [[ContactD alloc] init];
                    
                    cData.contact_id = NULL_TO_NIL([cDict valueForKey:@"user_id"]);
                    cData.image = NULL_TO_NIL([cDict valueForKey:@"user_image"]);
                    cData.userName = NULL_TO_NIL([cDict valueForKey:@"user_name"]);
                    cData.introduction = NULL_TO_NIL([cDict valueForKey:@"intro"]);
                    
                    cData.userName= [cData.userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                    
                    if (cData.userName.length>0) {
                        
                        [self.arrAppsContacts addObject:cData];
                        
                    }
                }
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        [tblViewContacts reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
}

-(void)sendContactRequestInvocationDidFinish:(SendContactRequestInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"sendContactRequestInvocationDidFinish %@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                ContactD* c = isSearchEnable?(ContactD*)[self.arrSearchContacts objectAtIndex:selectedCellIndex]:(ContactD*)[self.arrAppsContacts objectAtIndex:selectedCellIndex];
                c.isConnected = TRUE;
                
                [tblViewContacts beginUpdates];
                [tblViewContacts reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tblViewContacts endUpdates];
            }
            else{
                id response = [dict valueForKey:@"response"];
                
                NSString* strMessage = [response valueForKey:@"error"];
                
                [ConfigManager showAlertMessage:nil Message:strMessage];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception =%@",[exception debugDescription]);
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
