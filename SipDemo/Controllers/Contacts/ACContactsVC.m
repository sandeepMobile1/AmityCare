//
//  ACContactsVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ACContactsVC.h"
#import "ContactDetailVC.h"
#import "AddContactsVC.h"
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "ChatDetailVC.h"
#import "TopNavigationView.h"
#import "UIImageView+WebCache.h"
#import "ContactD.h"
#import "SqliteManager.h"
#import "MFSideMenu.h"
#import "QSStrings.h"
#import "Common.h"
#import <Sinch/Sinch.h>
#import "ProfileDetailVC.h"


@interface ACContactsVC ()<TopNavigationViewDelegate,ABPeoplePickerNavigationControllerDelegate,OptionsPopOverVCDelegate,GetAmityContactsListDelegate,DeleteContactInvocationDelegate,SINCallClientDelegate>

@property (nonatomic,strong) UIActionSheet *activeSheet;
@property (nonatomic, strong) NormalActionSheetDelegate *normalActionSheetDelegate;
@property (nonatomic, strong) UIPopoverController* popover;

@end

@implementation ACContactsVC
@synthesize popover;
@synthesize phoneCallDelegate,arrContactsList,arrSearchList,chatView,objProfileDetailVC;

UIButton *actionSheetbutton =nil;

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A",@"B",@"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil]
#define HEADER_HEIGHT 20.0F

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id<SINClient>)client {
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] client];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
    [navigation.rightBarButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    if (!IS_DEVICE_IPAD) {
        
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
        
        
    }
    
    self.client.callClient.delegate = self;
    
    
    navigation.lblTitle.text = @"Contacts";
    //  [self.view addSubview:navigation];
    
    self.arrSearchList =[[NSMutableArray alloc ] init];
    
    UIImage *searchBg = [UIImage imageNamed:@"search_box.png"];
    [[UISearchBar appearance] setBackgroundImage:searchBg];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_box.png"] forState:UIControlStateNormal];
    
    searchBar.layer.borderColor = [[UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:0.3f] CGColor];
    searchBar.layer.borderWidth = 1.0f;
    searchBar.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requetForContactDetails) name:AC_USER_CONTACT_RECIEVE object:nil];
    
}
-(void)requetForContactDetails{
    
    
    if([ConfigManager isInternetAvailable]){
        
        [self getContactList];
        
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    /*if (!IS_DEVICE_IPAD) {
     
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
     }*/
    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    [self getContactList];
}

/*- (void)viewDidLayoutSubviews
 {
 if (!IS_DEVICE_IPAD) {
 
 if (IS_IPHONE_5) {
 
 [self.view setFrame:CGRectMake(0, 0, 320, 568)];
 [tblViewContacts setFrame:CGRectMake(0, 54, 320,380+IPHONE_FIVE_FACTOR)];
 }
 else
 {
 [self.view setFrame:CGRectMake(0, 0, 320, 480)];
 
 [tblViewContacts setFrame:CGRectMake(0, 64, 320, 370)];
 
 }
 }
 }*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- --------
-(void)getContactList
{
    if([ConfigManager isInternetAvailable]){
        
        tblViewContacts.delegate=nil;
        tblViewContacts.dataSource=nil;
        
        [self.arrContactsList removeAllObjects];
        [self.arrSearchList removeAllObjects];
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
        [[AmityCareServices sharedService] getAmityContactListInvocation:sharedAppDelegate.userObj.userId delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

#pragma mark- TopNavigationDelegate

-(void)rightBarButtonDidClicked:(id)sender
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
    [self.activeSheet showFromRect:((UIButton*)sender).frame inView:[sender superview] animated:YES];
    
}

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
-(void)leftBarButtonDidClicked:(id)sender{
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
#pragma mark- NormalActionSheetDelegate
-(void)normalActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeSheet = nil;
    
    if(actionSheet.tag == AC_ACTIONSHEET_INVITE_CONTACTS)
    {
        
        if(buttonIndex==0){
            //DEVICE CONTACTS
            
            ABPeoplePickerNavigationController *picker =
            [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;
            
            //[self presentModalViewController:picker animated:YES];
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }
        else if(buttonIndex==1){
            //APPPS CONTACTS
            AddContactsVC *addContacts;
            
            if (IS_DEVICE_IPAD) {
                
                addContacts = [[AddContactsVC alloc] initWithNibName:@"AddContactsVC" bundle:nil];
            }
            else
            {
                addContacts = [[AddContactsVC alloc] initWithNibName:@"AddContactsVC_iphone" bundle:nil];
            }
            
            
            [self.navigationController pushViewController:addContacts animated:YES];
        }
    }
    else if(actionSheet.tag == AC_ACTIONSHEET_INVITE_VIA_IMESSAGE)
    {
        [self openMessageComposer:[arrEmail objectAtIndex:buttonIndex]];
    }
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
            
            
            if(!phoneNumber)
            {
                [self performSelector:@selector(openMessageComposer:) withObject:phoneNumber afterDelay:0.0f];
            }
            
            CFRelease(phoneNumbers);

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
                
                OptionsPopOverVC * opt = [[OptionsPopOverVC alloc] initWithTitleLabel:[UIColor clearColor] textColor:TEXT_COLOR_BLUE title:@"Select E-mail for iMessage" data:arrEmail delegate:self];
                popover = [[UIPopoverController alloc] initWithContentViewController:opt];
                [popover presentPopoverFromRect:CGRectMake(120, 350, 250, 230) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                [popover setPopoverContentSize:CGSizeMake(250, 230)];
                
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
    
    if(popover)
    {
        [popover dismissPopoverAnimated:YES];
    }
    [self performSelector:@selector(openMessageComposer:) withObject:value afterDelay:0.1f];
}

#pragma mark- -----------

-(void)openMessageComposer:(NSString*)strPhone
{
    if(msgComposer!=nil){
        msgComposer = nil;
    }
    msgComposer = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        msgComposer.body = @"Hey!! I am using Amity Care for free calling and text. Download Amity-Care and enjoy.";
        msgComposer.recipients = [NSArray arrayWithObjects:strPhone, nil];
        msgComposer.messageComposeDelegate = self;
        [self presentViewController:msgComposer animated:YES completion:^{
            
        }];
    }
}

#pragma mark- UIALERTVIEW

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView==offlineAlert) {
        
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
    return YES;
    
}
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==offlineAlert) {
        
        if (buttonIndex==1) {
            
            NSString *inputText = [[offlineAlert textFieldAtIndex:0] text];
            
            if ([inputText length]>0) {
                
                if([ConfigManager isInternetAvailable]){
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    NSString *encodedString=[QSStrings encodeBase64WithString:inputText];
                    
                    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                    [dic setObject:self.memberId forKey:@"member_id"];
                    [dic setObject:encodedString forKey:@"message"];
                    [dic setObject:@"offline" forKey:@"type"];

                    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
                    [[AmityCareServices sharedService] OfflineMessageInvocation:dic delegate:self];
                    
                    
                }
                else{
                    [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
                }
            }
            
        }
    }
    else
    {
        if(alertView.alertTag == AC_ALERTVIEW_CONFIRM_DELETE_CONTACT)
        {
            if(buttonIndex==0){
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                ContactD* cData = isSearchEnable?[arrSearchList objectAtIndex:selectedIndxpath.row]:[[self.arrContactsList objectAtIndex:selectedIndxpath.section] objectAtIndex:selectedIndxpath.row];
                
                [[AmityCareServices sharedService] deleteContactInvocation:sharedAppDelegate.userObj.userId memberID:cData.contact_id delegate:self];
            }
        }
        
    }
    
}

#pragma mark- User Acceptance Data

- (void)userAcceptanceInvocationDidFinish:(AcceptanceInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"Response Dic %@",dict);
    
    [DSBezelActivityView removeView];
    
    if (!error) {
        
        [self getContactList];
        
    }
    else
    {
        
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
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

-(void)hello
{
    //[_callingView removeFromSuperview];
    _callingView = nil;
}

-(void)callEndDidClicked:(id)sender
{
    [self performSelector:@selector(hello) withObject:nil afterDelay:0.3f];
}


#pragma mark- MessageControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [ConfigManager showAlertMessage:nil Message:@"Message Cancelled"];
            break;
            
        case MessageComposeResultSent:
            [ConfigManager showAlertMessage:nil Message:@"Message Sent Successfully"];
            break;
            
        case MessageComposeResultFailed:
            [ConfigManager showAlertMessage:nil Message:@"Message sending failed"];
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

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
        
        NSLog(@"%@",data.userName);

       if(![data.userName isEqualToString:@""])

        word=data.userName;
        
//        if(![data.userName isEqualToString:@""])
//            
//            word =((ContactD*)[wordArray objectAtIndex:k]).userName;
//        
        
        
        NSLog(@"%d",k);
        NSLog(@"%@",wordArray);

        NSLog(@"%@",word);
        
        if ([word length] == 0) continue;
        @try {
            range = [ALPHA rangeOfString:[[word substringToIndex:1] uppercaseString]];
            
            if(range.length>0)
                [[self.arrContactsList objectAtIndex:range.location] addObject:[wordArray objectAtIndex:k]];
            else
                [[self.arrContactsList objectAtIndex:26] addObject:[wordArray objectAtIndex:k]];
        }
        @catch (NSException * e) {
            [[self.arrContactsList objectAtIndex:26] addObject:[wordArray objectAtIndex:k]];
            NSLog(@"error");
        }
    }
    
    tblViewContacts.delegate=self;
    tblViewContacts.dataSource=self;
    [tblViewContacts reloadData];
}


#pragma mark- UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(UIView *view in [tableView subviews])
    {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
        {
            
        }
    }
    
    static NSString* cellIdenitifier = @"ContactsCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenitifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(DEVICE_OS_VERSION_7_0){
        
        for (UIView *view in [cell.contentView subviews])
        {
            if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UISwitch class]])
            {
                [view removeFromSuperview];
            }
        }
    }
    else
    {
        for (UIView *view in [cell subviews])
        {
            if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UISwitch class]])
            {
                [view removeFromSuperview];
            }
        }
    }
    
    ContactD *c = isSearchEnable?(ContactD*)[self.arrSearchList objectAtIndex:indexPath.row]:(ContactD*)[[self.arrContactsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = c.userName;
    cell.textLabel.textColor = TEXT_COLOR_GREEN;
    if (IS_DEVICE_IPAD) {
        
        cell.textLabel.font = [UIFont fontWithName:appfontName size:15.0];
        
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:appfontName size:13.0];
        
    }
    
    
    NSString* imgStatus = c.isOnline?@"online.png":@"offline.png";
    
    UIImageView *imgOnline=[[UIImageView alloc] init];
    [imgOnline setImage:[UIImage imageNamed:imgStatus]];
    
    
    
    UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCall addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMsg addTarget:self action:@selector(msgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UISwitch *notificationSwitch = [[UISwitch alloc] init];
    
    [notificationSwitch addTarget:self action:@selector(switchValueChagned:) forControlEvents:UIControlEventValueChanged];
    notificationSwitch.tag = indexPath.row;
    
    if (IS_DEVICE_IPAD) {
        
        cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 210, cell.textLabel.frame.size.height);
        
        [notificationSwitch setFrame:CGRectMake(220, 5, 51, 31)];
        [btnCall setFrame:CGRectMake(280, 5, 28, 28)];
        [btnMsg setFrame:CGRectMake(325, 5, 28, 28)];
        
        [imgOnline setFrame:CGRectMake(370, 15,10, 10)];
        
    }
    else
    {
        
        if (DEVICE_OS_VERSION>=7) {
            
            cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 115, cell.textLabel.frame.size.height);
            
            [notificationSwitch setFrame:CGRectMake(135, 5, 51, 31)];
            [btnCall setFrame:CGRectMake(184, 5, 28, 28)];
            [btnMsg setFrame:CGRectMake(212, 5, 28, 28)];
            [imgOnline setFrame:CGRectMake(245, 15, 10, 10)];
            
        }
        else
        {
            cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 120, cell.textLabel.frame.size.height);
            
            [notificationSwitch setFrame:CGRectMake(140, 5, 51, 31)];
            [btnCall setFrame:CGRectMake(193, 5, 28, 28)];
            [btnMsg setFrame:CGRectMake(227, 5, 28, 28)];
            [imgOnline setFrame:CGRectMake(260, 15, 10, 10)];
            
        }
        
    }
    
    
    BOOL status = NO;
    
    if ([c.notificationStatus isEqualToString:@"1"])
        status = YES;
    
    [notificationSwitch setOn:status];
    
    if ([c.status isEqualToString:@"1"])
    {
        [btnCall setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
        [btnMsg setImage:[UIImage imageNamed:@"decline.png"] forState:UIControlStateNormal];
        
        [btnCall setTitle:@"request" forState:UIControlStateApplication];
        [btnMsg setTitle:@"request" forState:UIControlStateApplication];
    }
    else
    {
        [btnCall setImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
        [btnMsg setImage:[UIImage imageNamed:@"msg.png"] forState:UIControlStateNormal];
        
        [btnCall setTitle:@"call" forState:UIControlStateApplication];
        [btnMsg setTitle:@"call" forState:UIControlStateApplication];
    }
    
    btnCall.tag = indexPath.row;
    btnMsg.tag = indexPath.row;
    
    [btnCall setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.section] forState:UIControlStateReserved];
    [btnMsg setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.section] forState:UIControlStateReserved];
    
    if(DEVICE_OS_VERSION_7_0){
        
        [cell.contentView addSubview:btnCall];
        [cell.contentView addSubview:btnMsg];
        [cell.contentView addSubview:notificationSwitch];
        [cell.contentView addSubview:imgOnline];
    }
    else{
        [cell addSubview:btnCall];
        [cell addSubview:btnMsg];
        [cell addSubview:notificationSwitch];
        [cell addSubview:imgOnline];
        
    }
    
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return isSearchEnable?[self.arrSearchList count]:[[self.arrContactsList objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return isSearchEnable?1:[ALPHA_ARRAY count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return isSearchEnable?nil:ALPHA_ARRAY;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return isSearchEnable?@"":[ALPHA_ARRAY objectAtIndex:section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndxpath = indexPath;
    
    ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Contact?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    deleteAlert.alertTag = AC_ALERTVIEW_CONFIRM_DELETE_CONTACT;
    [deleteAlert show];
}

#pragma mark- UITableViewDelegate

- (void)switchValueChagned:(UISwitch *)localSwitch
{
    NSLog(@"%@",self.arrContactsList);
    NSLog(@"%@",self.arrSearchList);
    
    NSIndexPath* indexPath = nil;
    
    if (DEVICE_OS_VERSION_8_0)
        indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)localSwitch.superview.superview)];
    
    else if(DEVICE_OS_VERSION_7_0)
        indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)localSwitch.superview.superview.superview)];
    else
        indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)localSwitch.superview)];
    
    ContactD* c = isSearchEnable?[self.arrSearchList objectAtIndex:localSwitch.tag]:[[self.arrContactsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    /* ContactD* c;
     if (isSearchEnable) {
     
     c=[self.arrSearchList objectAtIndex:localSwitch.tag];
     }
     else
     {
     c= [[self.arrContactsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     }*/
    
    NSLog(@"Section %ld",(long)indexPath.section);
    NSLog(@"Section %ld",(long)indexPath.row);
    
    if([ConfigManager isInternetAvailable])
    {
        NSString *str = @"0";
        
        if (localSwitch.isOn)
        {
            str = @"1";
        }
        else
            str = @"0";
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:c.contact_id forKey:@"contact_id"];
        [dict setObject:str forKey:@"notification_status"];
        
        tblViewContacts.userInteractionEnabled = NO;
        
        [DSBezelActivityView newActivityViewForView:self.view withLabel:LOADING_VIEW_DEFAULT_HEADING width:200];
        
        AmityCareServices *service = [[AmityCareServices alloc] init];
        [service updateContactNotificationInvocation:dict delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

-(void)callBtnAction:(UIButton*)sender
{
    
    //[self.phoneCallDelegate dialup:@"2946214217" number:NO];

    
    NSLog(@"Title %@",[sender titleForState:UIControlStateApplication]);
    if ([[sender titleForState:UIControlStateApplication] isEqualToString:@"call"])
    {
        NSIndexPath* indexPath = nil;
        
        if (DEVICE_OS_VERSION_8_0)
            indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)sender.superview.superview)];
        
        else if(DEVICE_OS_VERSION_7_0)
            indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)sender.superview.superview.superview)];
        
        else
            indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)sender.superview)];
        
        NSLog(@"Section %ld & index %ld",(long)indexPath.section,(long)indexPath.row);
        
        ContactD* c = isSearchEnable?[self.arrSearchList objectAtIndex:sender.tag]:[[self.arrContactsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if(c.isOnline){
            NSLog(@"usrname =%@\t ipaddr=%@",c.sip.username,c.sip.ipAddress);
            if (([c.sip username]!=nil) && ([c.sip ipAddress]!=nil)) {
                
                [sharedAppDelegate.callingView setUserImage:c.image];
                              
                NSLog(@"c.userid %@",c.userid);
                
                NSLog(@"c.firstName = %@",c.userName);
                
                NSString *str_name_string = [c.userName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                NSString *str_key = [NSString stringWithFormat:@"%@_%@",c.userid,str_name_string];
                
                sharedAppDelegate.strCallUserId=c.userid;
                sharedAppDelegate.strCallUserName=c.userName;

                id<SINCall> call = [self.client.callClient callUserWithId:str_key];

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
            else{
                [ConfigManager showAlertMessage:nil Message:[NSString stringWithFormat:@"%@ has not assigned any calling extension",c.userName]];
            }
        }
        else{
            
            self.memberId=c.userid;
            
            NSString *strUserName=[NSString stringWithFormat:@"%@ is offline !",c.userName];
            
            
            offlineAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:strUserName
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Continue", nil];
            [offlineAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField * alertTextField =nil;
            alertTextField=[offlineAlert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeDefault;
            [offlineAlert show];
            
            
        }
        
    }
    else
    {
        if([ConfigManager isInternetAvailable]){
            //
            int clickedSection = [[sender titleForState:UIControlStateReserved] intValue];
            
            ContactD *c = (ContactD*)[[self.arrContactsList objectAtIndex:clickedSection] objectAtIndex:sender.tag];
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"userId"];
            [dic setObject:c.userid forKey:@"memberId"];
            [dic setObject:@"2" forKey:@"status"];
            [dic setObject:c.contact_id forKey:@"contactId"];
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
            [[AmityCareServices sharedService] userAcceptanceRecieveNotification:dic delegate:self];
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }
    
}

#pragma mark - SINCallClientDelegate



- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    
    NSLog(@"didReceiveIncomingCall callview");
    
    if (IS_DEVICE_IPAD) {
        
        self.callingView=[[CallingView alloc] initWithNibName:@"CallingView" bundle:nil];
        
        
    }
    else
    {
        self.callingView=[[CallingView alloc] initWithNibName:@"CallingView_iphone" bundle:nil];
        
    }    self.callingView.call = call;
    [sharedAppDelegate.window addSubview:self.callingView.view];
}

- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    
    NSArray *foo = [[call remoteUserId] componentsSeparatedByString: @"_"];
    
    NSString* str_name = [foo objectAtIndex: 1];
    
    NSString *finalString = [str_name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    
    NSLog(@"didReceiveIncomingCall callview");
    
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", finalString];
    return notification;
}



#pragma mark - SINClientDelegate

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
        NSLog(@"%@", message);
    }
}


-(void)msgBtnAction:(UIButton*)sender
{
    NSLog(@" Class -=%@ %@ %@ ",[sender.superview class],[sender.superview.superview class],[sender.superview.superview.superview class]);
    
    NSLog(@"Title %@",[sender titleForState:UIControlStateApplication]);
    
    if ([[sender titleForState:UIControlStateApplication] isEqualToString:@"call"])
    {
        [self.view endEditing:YES];
        
        NSIndexPath* indexPath = nil;
        
        if (DEVICE_OS_VERSION_8_0)
            indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)sender.superview.superview)];
        
        else if(DEVICE_OS_VERSION_7_0)
            indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)sender.superview.superview.superview)];
        
        else
            indexPath = [tblViewContacts indexPathForCell:((UITableViewCell*)sender.superview)];
        
        NSLog(@"Section %ld & index %ld",(long)indexPath.section,(long)indexPath.row);
        
        
        
        if (IS_DEVICE_IPAD) {
            
            self.chatView = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC" bundle:nil];
        }
        else
        {
            self.chatView = [[ChatDetailVC alloc] initWithNibName:@"ChatDetailVC_iphone" bundle:nil];
        }
        
        self.chatView.msgListSelected = FALSE;
        self.chatView.backBtnVisibility=@"YES";
        self.chatView.cData = isSearchEnable?((ContactD*)[self.arrSearchList objectAtIndex:sender.tag]):((ContactD*)[[self.arrContactsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
        
        [self.view addSubview:self.chatView.view];
        //[self.navigationController pushViewController:chatView animated:YES];
        
    
    }
    else
    {
        if([ConfigManager isInternetAvailable]){
            
            int clickedSection = [[sender titleForState:UIControlStateReserved] intValue];
            ContactD *c = (ContactD*)[[self.arrContactsList objectAtIndex:clickedSection] objectAtIndex:sender.tag];
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"userId"];
            [dic setObject:c.userid forKey:@"memberId"];
            [dic setObject:@"3" forKey:@"status"];
            [dic setObject:c.contact_id forKey:@"contactId"];
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
            [[AmityCareServices sharedService] userAcceptanceRecieveNotification:dic delegate:self];
            
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return isSearchEnable?0.0:(([[self.arrContactsList objectAtIndex:section] count]==0)?0.0:HEADER_HEIGHT);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 525, HEADER_HEIGHT)];
    headerView.backgroundColor = [ UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0f];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 500, HEADER_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:appfontName size:15.0f];
    label.text = [ALPHA_ARRAY objectAtIndex:section];
    [headerView addSubview:label];
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] || [sharedAppDelegate.userObj.role isEqualToString:@"5"]) {

    if (IS_DEVICE_IPAD) {
        
        self.objProfileDetailVC=[[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC" bundle:nil];
        
    }
    else
    {
        self.objProfileDetailVC=[[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC_iphone" bundle:nil];
        
    }
    
    ContactD *c = isSearchEnable?(ContactD*)[self.arrSearchList objectAtIndex:indexPath.row]:(ContactD*)[[self.arrContactsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    self.objProfileDetailVC.userid=c.userid;
    self.objProfileDetailVC.isAvailable=c.isOnline;
    self.objProfileDetailVC.checkLocationProfile=TRUE;
    
    [self.view addSubview:self.objProfileDetailVC.view];
        
    }
    /*
     if (isSearchEnable) {
     ContactDetailVC *cDetail = [[ContactDetailVC alloc ]  initWithNibName:@"ContactDetailVC" bundle:nil];
     cDetail.cObj = [arrSearchList objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:cDetail animated:YES];
     }
     else{
     ContactDetailVC *cDetail = [[ContactDetailVC alloc ]  initWithNibName:@"ContactDetailVC" bundle:nil];
     cDetail.cObj = [[arrContactsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:cDetail animated:YES];
     }
     */
}

#pragma mark- UISearchBarDelegate
-(void)filterContacts:(NSString*)text
{
    NSLog(@"filterContacts =%@",text);
    NSMutableArray *array = [[NSMutableArray alloc] init] ;
    for(id data in self.arrContactsList)
    {
        if([data isKindOfClass:[NSMutableArray class]])
        {
            for(int i=0; i<[data count]; i++)
                [array addObject:[data objectAtIndex:i]];
        }
    }
    
    [self.arrSearchList removeAllObjects];
    
    for(ContactD *data in array)
    {
        NSString *strName = data.userName;
        if([[strName lowercaseString] rangeOfString:[text lowercaseString]].length>0)
        {
            [self.arrSearchList addObject:data];
            NSLog(@"match found");
        }
    }
}
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
    [tblViewContacts reloadData];
    [search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    NSLog(@"searchBar =%@ textDidChange  =%@",search.text,searchText);
    
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
    NSLog(@"searchBarCancelButtonClicked text =%@",search.text);
    
    isSearchEnable=FALSE;
    [searchBar resignFirstResponder];
    
}

#pragma mark- Invocation
-(void)deleteContactInvocationDidFinish:(DeleteContactInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"deleteContactInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                NSString* sip_uname = ((ContactD*)[[self.arrContactsList objectAtIndex:selectedIndxpath.section] objectAtIndex:selectedIndxpath.row]).sip.username;
                
                BOOL status = [[SqliteManager sharedManager] deleteContact:sip_uname];
                NSLog(@"Contact delte status = %d",status);
                
                [((NSMutableArray*)[self.arrContactsList objectAtIndex:selectedIndxpath.section]) removeObjectAtIndex:selectedIndxpath.row];
                
                [tblViewContacts beginUpdates];
                [tblViewContacts deleteRowsAtIndexPaths:[NSArray arrayWithObjects:selectedIndxpath, nil] withRowAnimation:UITableViewRowAnimationLeft];
                [tblViewContacts endUpdates];
                
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

-(void)getAmityContactsListDidFinish:(GetAmityContactsList *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [self.arrContactsList removeAllObjects];
    [self.arrSearchList removeAllObjects];
    
    NSLog(@"getAmityContactsListDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
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
                    
                    c.userName= [c.userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                    if (c.userName.length>0) {
                        
                        [contactArr addObject:c];

                    }
                    
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
        
        tblViewContacts.userInteractionEnabled = YES;
        
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

- (void)updateContactNotificationInvocationDidFinish:(UpdateContactNotificationInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"Response Dic %@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        
        if([strSuccess rangeOfString:@"true"].length>0){
            
            [self getContactList];
        }
        else
            tblViewContacts.userInteractionEnabled = YES;
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    [DSBezelActivityView removeView];
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
