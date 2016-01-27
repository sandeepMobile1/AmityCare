//
//  UploadListViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 15/05/15.
//
//

#import "UploadListViewController.h"
#import "BackPackD.h"
#import "UIImageView+WebCache.h"
#import "AddReminderViewController.h"
#import "AddBackPackMessageViewController.h"
#import "UploadBackPackViewController.h"
#import "ContactD.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "BackpackZoomViewController.h"

@interface UploadListViewController ()

@end

@implementation UploadListViewController

@synthesize arrBackPackList,selectedIndxpath,arrCheckMarkList,tagId,checkUpload,folderId,folderTitle,popoverView,popoverController,popoverContent,popoverContactContent,contactView,imgPhoto;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrBackPackList=[[NSMutableArray alloc] init];
    self.arrCheckMarkList=[[NSMutableArray alloc] init];
    self.arrContactList=[[NSMutableArray alloc] init];
    
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
            /* else if([sharedAppDelegate.userObj.role isEqualToString:@"6"]|| [sharedAppDelegate.userObj.role isEqualToString:@"8"])
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
    
    [self showAllPicList];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)btnContactCrossPressed:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [self.contactView removeFromSuperview];
        
    }
}
-(IBAction)btnDeletePressed:(UIButton*)sender
{
    self.selectedIndxpath=[[sender titleForState:UIControlStateReserved] intValue];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Do you want to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
    
    
}
-(void)showAllPicList
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dic setObject:self.folderId forKey:@"folder_id"];
    
    if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
        
        
    }
    else
    {
        [dic setObject:self.tagId forKey:@"tag_id"];
        
    }
    [[AmityCareServices sharedService] AllBackpackPicListInvocation:dic delegate:self];
    
}
-(void)showAllFileList
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dic setObject:@"2" forKey:@"contentType"];
    [dic setObject:self.folderId forKey:@"folder_id"];
    
    if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
        
        
    }
    else
    {
        [dic setObject:self.tagId forKey:@"tag_id"];
        
    }
    
    [[AmityCareServices sharedService] AllBackPackFileListInvocation:dic delegate:self];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        BackPackD *bData=[self.arrBackPackList objectAtIndex:self.selectedIndxpath];
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Deleting Pic..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:bData.backPackPicId forKey:@"media_id"];
        [dic setObject:self.folderId forKey:@"folder_id"];
        
        [[AmityCareServices sharedService] DeleteBackpackPicInvocation:dic delegate:self];
        
    }
}
#pragma mark- UITableView Delegate
#pragma mark- UITableViewDataSource Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 10;
    if (tableView==tblView) {
        
        return [self.arrBackPackList count];
        
    }
    else
    {
        return [self.arrContactList count];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    float height=0;
    
    if (tableView==tblView) {
        
        if (IS_DEVICE_IPAD) {
            
            height=350;
        }
        else
        {
            height=250;
            
            
        }
        
        
    }
    else
    {
        height=44;
    }
    
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* picCellIdentifier = @"PicListCell";
    static NSString* contactCellIdentifier = @"ContactListCell";
    
    if (tableView==tblView) {
        
        picCell= (UploadPicTableViewCell*)[tblView dequeueReusableCellWithIdentifier:picCellIdentifier];
        
        if (Nil == picCell)
        {
            picCell = [UploadPicTableViewCell createTextRowWithOwner:self withDelegate:self];
        }
        [picCell setBackgroundColor:[UIColor clearColor]];
        
        BackPackD *bData=[self.arrBackPackList objectAtIndex:indexPath.row];
        
        [picCell.lblTitle setText:bData.backPackPicName];
        
        
        if ([bData.backPackType isEqualToString:@"1"]) {
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@/%@/%@",largeBackPackImageURL,sharedAppDelegate.userObj.role,self.folderTitle,bData.backPackPic]);
            
            [picCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/%@",largeBackPackImageURL,sharedAppDelegate.userObj.userId,self.folderTitle,bData.backPackPic]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
            
        }
        else if ([bData.backPackType isEqualToString:@"2"])
        {
            [picCell.imgView setImage:[UIImage imageNamed:@"video_thumb"]];
        }
        else
        {
            
            
            [picCell.imgView setImage:[UIImage imageNamed:@"document_thumb.png"]];
            
        }
        
        
        [picCell.btnDelete setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        [picCell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [picCell.btnCheckMark setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
        [picCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
        return picCell;
        
        
        
        
        
    }
    else
    {
        UITableViewCell *cell = [tblViewContactList dequeueReusableCellWithIdentifier:contactCellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCellIdentifier];
        }
        
        ContactD* c = [self.arrContactList objectAtIndex:indexPath.row];
        cell.textLabel.text = c.userName;
        
        return cell;
        
        
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==tblViewContactList) {
        
        NSString* joinedString=@"";
        
        if ([self.arrCheckMarkList count]>0) {
            
            NSMutableArray *array=[[NSMutableArray alloc] init];
            
            for (int i=0; i<[self.arrCheckMarkList count]; i++) {
                
                UIButton *btn=[self.arrCheckMarkList objectAtIndex:i];
                
                BackPackD *data=[self.arrBackPackList objectAtIndex:[[btn titleForState:UIControlStateReserved]intValue]];
                
                [array addObject:data.backPackPicId];
                
                
                
            }
            
            joinedString = [array componentsJoinedByString:@","];
            
            if([ConfigManager isInternetAvailable]){
                
                ContactD *cData=[self.arrContactList objectAtIndex:indexPath.row];
                
                [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                [dic setObject:cData.userid forKey:@"member_id"];
                [dic setObject:joinedString forKey:@"backpackId"];
                [dic setObject:@"media" forKey:@"type"];
                
                if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
                    
                    
                }
                else
                {
                    [dic setObject:self.tagId forKey:@"tag_id"];
                    
                }
                
                [[AmityCareServices sharedService] ShareBackpackInvocation:dic delegate:self];
            }
            else{
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Please select route"];
        }
    }
    else
    {
        BackPackD *bData=[self.arrBackPackList objectAtIndex:indexPath.row];
        
        if (IS_DEVICE_IPAD) {
            
            self.imgPhoto= [[BackpackZoomViewController alloc] initWithNibName:@"BackpackZoomViewController" bundle:nil];
            
        }
        else
        {
            self.imgPhoto= [[BackpackZoomViewController alloc] initWithNibName:@"BackpackZoomViewController_iphone" bundle:nil];
            
        }
        
        if([bData.backPackType isEqualToString:@"1"]){
            
            self.imgPhoto.imageURL = [NSString stringWithFormat:@"%@%@/%@/%@",largeBackPackImageURL,sharedAppDelegate.userObj.userId,self.folderTitle,bData.backPackPic];
            
            self.imgPhoto.docType = documentTypeImage;
        }
        else if([bData.backPackType isEqualToString:@"2"]){
            
            self.imgPhoto.docType = documentTypeVideo;
            self.imgPhoto.videoURL = [NSString stringWithFormat:@"%@%@/%@/%@",largeBackPackImageURL,sharedAppDelegate.userObj.userId,self.folderTitle,bData.backPackPic];
        }
        else if ([bData.backPackType isEqualToString:@"3"]){
            self.imgPhoto.docType = documentTypeFiles;
            self.imgPhoto.documentURL = [NSString stringWithFormat:@"%@%@/%@/%@",largeBackPackImageURL,sharedAppDelegate.userObj.userId,self.folderTitle,bData.backPackPic];
        }
        
        [self.view addSubview:self.imgPhoto.view];
    }
    
}
-(IBAction)btnCheckMarkPressed:(UIButton*)sender
{
    if (sender.isSelected==NO) {
        
        [sender setSelected:YES];
        
        [self.arrCheckMarkList addObject:sender];
        
    }
    else
    {
        [sender setSelected:NO];
        [self.arrCheckMarkList removeObject:sender];
    }
}
-(IBAction)btnSharePressed:(id)sender
{
    
    if ([self.arrCheckMarkList count]>0) {
        
        [self getContactList];
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Please select post"];
    }
    
    
}
-(void)getContactList
{
    if([ConfigManager isInternetAvailable]){
        
        [self.arrContactList removeAllObjects];
        
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching Contact" width:200];
        [[AmityCareServices sharedService] getAmityContactListInvocation:sharedAppDelegate.userObj.userId delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
- (void)showContactView
{
    
    if (IS_DEVICE_IPAD) {
        
        if (self.popoverContactContent==nil) {
            
            self.popoverContactContent = [[UIViewController alloc]init];
            self.popoverContactContent.view = self.contactView;
            self.popoverContactContent.preferredContentSize = CGSizeMake(320, 414);
            
        }
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContactContent];
        
        self.popoverController.popoverContentSize= CGSizeMake(320, 414);
        
        [self.popoverController  presentPopoverFromRect:btnShare.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        [tblViewContactList reloadData];
        
    }
    else
    {
        [self.contactView setFrame:CGRectMake(0,90, self.contactView.frame.size.width, self.contactView.frame.size.height)];
        self.contactView.layer.cornerRadius=5;
        self.contactView.clipsToBounds=YES;
        
        tblViewContactList.layer.cornerRadius=5;
        tblViewContactList.clipsToBounds=YES;
        
        [self.view addSubview:self.contactView];
        [tblViewContactList reloadData];
        
    }
    
}

-(void)AllBackpackPicListInvocationDidFinish:(AllBackpackPicListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* reminderArray = NULL_TO_NIL([response valueForKey:@"backpackMedia"]);
            
            NSLog(@"%@",reminderArray);
            
            for (int i=0; i< [reminderArray count]; i++) {
                
                NSDictionary *fDict = [reminderArray objectAtIndex:i];
                
                BackPackD *bData = [[BackPackD alloc] init];
                
                bData.backPackPicId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                bData.backPackPic = NULL_TO_NIL([fDict valueForKey:@"file"]);
                bData.backPackPicName = NULL_TO_NIL([fDict valueForKey:@"title"]);
                bData.backPackType = NULL_TO_NIL([fDict valueForKey:@"content_type"]);
                
                
                [self.arrBackPackList addObject:bData];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        
        tblView.delegate=self;
        tblView.dataSource=self;
        [tblView reloadData];
        
        [DSBezelActivityView removeView];
    }
}
-(void)AllBackPackFileListInvocationDidFinish:(AllBackPackFileListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* reminderArray = NULL_TO_NIL([response valueForKey:@"backpackMedia"]);
            
            NSLog(@"%@",reminderArray);
            
            for (int i=0; i< [reminderArray count]; i++) {
                
                NSDictionary *fDict = [reminderArray objectAtIndex:i];
                
                BackPackD *bData = [[BackPackD alloc] init];
                
                bData.backPackFileId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                bData.backPackFileName = NULL_TO_NIL([fDict valueForKey:@"file"]);
                
                
                [self.arrBackPackList addObject:bData];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        
        tblView.delegate=self;
        tblView.dataSource=self;
        [tblView reloadData];
        
        [DSBezelActivityView removeView];
    }
}
-(void)DeleteBackpackPicInvocationDidFinish:(DeleteBackpackPicInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"DeleteBackpackPicInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                
                [ConfigManager showAlertMessage:nil Message:@"Pic not deleted"];
            }
            else
            {
                NSLog(@"%lu",(unsigned long)[self.arrBackPackList count]);
                
                NSLog(@"%d",self.selectedIndxpath);
                
                [self.arrBackPackList removeObjectAtIndex:self.selectedIndxpath];
                
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
        [tblView reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception =%@",[exception description]);
    }
    @finally {
        [DSBezelActivityView removeView];
    }
    
}
-(void)DeleteBackpackFileInvocationDidFinish:(DeleteBackpackFileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error

{
    NSLog(@"DeleteBackpackFileInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                
                [ConfigManager showAlertMessage:nil Message:@"File not deleted"];
            }
            else
            {
                NSLog(@"%lu",(unsigned long)[self.arrBackPackList count]);
                
                NSLog(@"%d",self.selectedIndxpath);
                
                [self.arrBackPackList removeObjectAtIndex:self.selectedIndxpath];
                
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
        [tblView reloadData];
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
                        
                        [self.arrContactList addObject:c];
                        
                    }
                    
                }
                
                [self showContactView];
                
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
-(void)ShareBackpackInvocationDidFinish:(ShareBackpackInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        NSString* strMessage = [response valueForKey:@"message"];
        
        if([strSuccess rangeOfString:@"true"].length>0){
            
            [ConfigManager showAlertMessage:nil Message:strMessage];
            
        }
        else
            [ConfigManager showAlertMessage:nil Message:strMessage];
        
        if (IS_DEVICE_IPAD) {
            
            [self.popoverController dismissPopoverAnimated:YES];
            
        }
        else
        {
            [self.contactView removeFromSuperview];
            
        }
        [tblView reloadData];
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}
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
