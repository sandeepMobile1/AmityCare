//
//  BackPackViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "BackPackViewController.h"
#import "BackPackD.h"
#import "UIImageView+WebCache.h"
#import "AddReminderViewController.h"
#import "AddBackPackMessageViewController.h"
#import "UploadBackPackViewController.h"
#import "ContactD.h"
#import "UploadListViewController.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface BackPackViewController ()

@end

@implementation BackPackViewController

@synthesize arrBackPackList,selectedIndxpath,arrCheckMarkList,tagId,objAddReminderViewController,objAddBackPackMessageViewController,objUploadBackPackViewController,contactView,objUploadListViewController,popoverView,popoverController,popoverContactContent,popoverContent;
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
    
    [self showAllReminderList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackPackList) name: AC_BACKPACK_UPDATE object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)btnAddPressed:(id)sender
{
    if (segment.selectedSegmentIndex==0) {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objAddReminderViewController=[[AddReminderViewController alloc] initWithNibName:@"AddReminderViewController" bundle:nil];
            
        }
        else
        {
            self.objAddReminderViewController=[[AddReminderViewController alloc] initWithNibName:@"AddReminderViewController_iphone" bundle:nil];
            
        }
        if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
            
        }
        else
        {
            self.objAddReminderViewController.tagId=self.tagId;
            
        }
        
        [self.view addSubview:self.objAddReminderViewController.view];
    }
    else if (segment.selectedSegmentIndex==1) {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objAddBackPackMessageViewController=[[AddBackPackMessageViewController alloc] initWithNibName:@"AddBackPackMessageViewController" bundle:nil];
            
        }
        else
        {
            self.objAddBackPackMessageViewController=[[AddBackPackMessageViewController alloc] initWithNibName:@"AddBackPackMessageViewController_iphone" bundle:nil];
            
        }
        if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
            
        }
        else
        {
            self.objAddBackPackMessageViewController.tagId=self.tagId;
            
        }
        
        [self.view addSubview:self.objAddBackPackMessageViewController.view];
    }
    else if (segment.selectedSegmentIndex==2) {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objUploadBackPackViewController=[[UploadBackPackViewController alloc] initWithNibName:@"UploadBackPackViewController" bundle:nil];
            
        }
        else
        {
            self.objUploadBackPackViewController=[[UploadBackPackViewController alloc] initWithNibName:@"UploadBackPackViewController_iphone" bundle:nil];
            
        }
        
        self.objUploadBackPackViewController.checkUpload=@"pic";
        if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
            
        }
        else
        {
            self.objUploadBackPackViewController.tagId=self.tagId;
            
        }
        
        [self.view addSubview:self.objUploadBackPackViewController.view];
    }
    else
    {
        
        if (IS_DEVICE_IPAD) {
            
            self.objUploadBackPackViewController=[[UploadBackPackViewController alloc] initWithNibName:@"UploadBackPackViewController" bundle:nil];
            
        }
        else
        {
            self.objUploadBackPackViewController=[[UploadBackPackViewController alloc] initWithNibName:@"UploadBackPackViewController_iphone" bundle:nil];
            
        }
        
        self.objUploadBackPackViewController.checkUpload=@"file";
        if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
            
        }
        else
        {
            self.objUploadBackPackViewController.tagId=self.tagId;
            
        }
        
        [self.view addSubview:self.objUploadBackPackViewController.view];
    }
}
-(IBAction)segmentPressed:(id)sender
{
    [self.arrCheckMarkList removeAllObjects];
    
    if (segment.selectedSegmentIndex==0) {
        
        [btnAdd setTitle:@"Add Reminder" forState:UIControlStateNormal];
        [btnAdd setHidden:FALSE];
        
        [self.arrBackPackList removeAllObjects];
        
        [tblView reloadData];
        
        tblView.delegate=nil;
        
        [btnShare setHidden:FALSE];
        
        [self showAllReminderList];
    }
    else if(segment.selectedSegmentIndex==1)
    {
        [btnAdd setTitle:@"Add Message" forState:UIControlStateNormal];
        
        [self.arrBackPackList removeAllObjects];
        [btnAdd setHidden:FALSE];
        
        [tblView reloadData];
        
        tblView.delegate=nil;
        tblView.dataSource=nil;
        [btnShare setHidden:FALSE];
        
        [self showAllMessageList];
    }
    else if(segment.selectedSegmentIndex==2)
    {
        [btnAdd setTitle:@"Upload Pic" forState:UIControlStateNormal];
        
        [self.arrBackPackList removeAllObjects];
        [btnAdd setHidden:FALSE];
        
        [tblView reloadData];
        
        tblView.delegate=nil;
        tblView.dataSource=nil;
        [btnShare setHidden:TRUE];
        
        [self showAllFolerList];
    }
    else
    {
        [btnAdd setTitle:@"Upload File" forState:UIControlStateNormal];
        [self.arrBackPackList removeAllObjects];
        [btnAdd setHidden:TRUE];
        
        [tblView reloadData];
        
        tblView.delegate=nil;
        tblView.dataSource=nil;
        
        [self showAllFolerList];
    }
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
-(void)updateBackPackList
{
    [self.arrBackPackList removeAllObjects];
    [tblView reloadData];
    
    if (segment.selectedSegmentIndex==0) {
        
        [btnAdd setTitle:@"Add Reminder" forState:UIControlStateNormal];
        [btnAdd setHidden:FALSE];
        
        [self showAllReminderList];
    }
    else if(segment.selectedSegmentIndex==1)
    {
        [btnAdd setTitle:@"Add Message" forState:UIControlStateNormal];
        [btnAdd setHidden:FALSE];
        
        [self showAllMessageList];
    }
    else if(segment.selectedSegmentIndex==2)
    {
        [btnAdd setTitle:@"Upload Pic" forState:UIControlStateNormal];
        [btnAdd setHidden:FALSE];
        
        [self showAllFolerList];
    }
    else
    {
        [btnAdd setTitle:@"Upload File" forState:UIControlStateNormal];
        
        [btnAdd setHidden:TRUE];
        
        [self showAllFolerList];
    }
    
}
-(void)showAllReminderList
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    
    if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
        
        
    }
    else
    {
        [dic setObject:self.tagId forKey:@"tag_id"];
        
    }
    
    [[AmityCareServices sharedService] AllReminderListInvocation:dic delegate:self];
    
}
-(void)showAllMessageList
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    
    if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
        
        
    }
    else
    {
        [dic setObject:self.tagId forKey:@"tag_id"];
        
    }
    [[AmityCareServices sharedService] AllBackpackMessageListInvocation:dic delegate:self];
    
}
-(void)showAllFolerList
{
    if([ConfigManager isInternetAvailable]){
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
            
            
        }
        else
        {
            [dic setObject:self.tagId forKey:@"tag_id"];
            
        }
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Creating Folder" width:200];
        [[AmityCareServices sharedService] FolderListInvocation:dic delegate:self];
        
        
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)showAllPicList
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating user details..." width:200];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    [dic setObject:@"1" forKey:@"contentType"];
    
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
        
        if (segment.selectedSegmentIndex==0) {
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Deleting Reminder..." width:200];
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dic setObject:bData.backPackReminderId forKey:@"reminder_id"];
            
            [[AmityCareServices sharedService] DeleteBackpackReminderInvocation:dic delegate:self];
        }
        else if(segment.selectedSegmentIndex==1)
        {
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Deleting Message..." width:200];
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dic setObject:bData.backPackMessageId forKey:@"message_id"];
            
            [[AmityCareServices sharedService] DeletebackpackMessageInvocation:dic delegate:self];
            
        }
        else if(segment.selectedSegmentIndex==2)
        {
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Deleting Pic..." width:200];
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dic setObject:bData.backPackPicId forKey:@"media_id"];
            
            [[AmityCareServices sharedService] DeleteBackpackPicInvocation:dic delegate:self];
            
        }
        else
        {
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Deleting File..." width:200];
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            [dic setObject:bData.backPackFileId forKey:@"file_id"];
            
            [[AmityCareServices sharedService] DeleteBackpackFileInvocation:dic delegate:self];
            
        }
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
        
        if (segment.selectedSegmentIndex==0) {
            
            //height=85;
            
            BackPackD *bData=[self.arrBackPackList objectAtIndex:indexPath.row];
            
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBounds.size;
            
            NSAttributedString *aString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",bData.backPackReminderDesc]];
            UITextView *calculationView = [[UITextView alloc] init];
            [calculationView setAttributedText:aString];
            CGSize size = [calculationView sizeThatFits:CGSizeMake(screenSize.width, FLT_MAX)];
            
            height= size.height+50;
            
        }
        else if(segment.selectedSegmentIndex==1)
        {
            //height=44;
            
            
            /*  CGRect screenBounds = [[UIScreen mainScreen] bounds];
             CGSize screenSize = screenBounds.size;
             
             NSAttributedString *aString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",bData.backPackMessage]];
             UITextView *calculationView = [[UITextView alloc] init];
             [calculationView setAttributedText:aString];
             CGSize size = [calculationView sizeThatFits:CGSizeMake(screenSize.width, FLT_MAX)];*/
            
            BackPackD *bData=[self.arrBackPackList objectAtIndex:indexPath.row];
            
            CGRect textRect;
            
            if (IS_DEVICE_IPAD) {
                
                textRect= [bData.backPackMessage boundingRectWithSize:CGSizeMake(364.0f, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:13.0]}
                                                              context:nil];
                
            }
            else
            {
                textRect= [bData.backPackMessage boundingRectWithSize:CGSizeMake(228.0f, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:13.0]}
                                                              context:nil];
                
            }
            
            CGSize size = textRect.size;
            
            
            if (size.height+20<70) {
                
                height=70;
            }
            else
            {
                height= size.height+20;
                
            }
        }
        else if(segment.selectedSegmentIndex==2 || segment.selectedSegmentIndex==3)
        {
            height=44;
            /*if (IS_DEVICE_IPAD) {
             
             height=350;
             }
             else
             {
             height=250;
             
             }*/
            
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
    static NSString* reminderCellIdentifier = @"ReminderListCell";
    static NSString* messageCellIdentifier = @"MessageListCell";
    //static NSString* picCellIdentifier = @"PicListCell";
    //static NSString* fileCellIdentifier = @"FileListCell";
    static NSString* contactCellIdentifier = @"ContactListCell";
    static NSString* folderCellIdentifier = @"FolderListCell";
    
    if (tableView==tblView) {
        
        if (segment.selectedSegmentIndex==0) {
            
            reminderCell= (ReminderTableViewCell*)[tblView dequeueReusableCellWithIdentifier:reminderCellIdentifier];
            
            if (Nil == reminderCell)
            {
                reminderCell = [ReminderTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            [reminderCell setBackgroundColor:[UIColor clearColor]];
            
            BackPackD *bData=[self.arrBackPackList objectAtIndex:indexPath.row];
            
            reminderCell.lblTitle.text = bData.backPackReminderTitle;
            reminderCell.lblDate.text = bData.backPackReminderDate;
            reminderCell.lblDesc.text = bData.backPackReminderDesc;
            
            // CGSize size = [bData.backPackReminderDesc sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(reminderCell.lblDesc.frame.size.width,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [bData.backPackReminderDesc boundingRectWithSize:CGSizeMake(reminderCell.lblDesc.frame.size.width,130000)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                                       context:nil];
            
            CGSize size = textRect.size;
            
            
            [reminderCell.lblDesc setFrame:CGRectMake(reminderCell.lblDesc.frame.origin.x, reminderCell.lblDesc.frame.origin.y,reminderCell.lblDesc.frame.size.width,size.height)];
            
            
            [reminderCell.btnDelete setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            [reminderCell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [reminderCell.btnCheckMark setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            [reminderCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            return reminderCell;
            
        }
        else if (segment.selectedSegmentIndex==1) {
            
            messageCell= (MessageTableViewCell*)[tblView dequeueReusableCellWithIdentifier:messageCellIdentifier];
            
            if (Nil == messageCell)
            {
                messageCell = [MessageTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            [messageCell setBackgroundColor:[UIColor clearColor]];
            
            BackPackD *bData=[self.arrBackPackList objectAtIndex:indexPath.row];
            
            messageCell.lblMessage.text = bData.backPackMessage;
            
            messageCell.lblMessage.numberOfLines=0;
            
            // CGSize size = [bData.backPackMessage sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(messageCell.lblMessage.frame.size.width,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [bData.backPackMessage boundingRectWithSize:CGSizeMake(messageCell.lblMessage.frame.size.width,130000)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                                  context:nil];
            
            CGSize size = textRect.size;
            
            
            [messageCell.lblMessage setFrame:CGRectMake(messageCell.lblMessage.frame.origin.x, messageCell.lblMessage.frame.origin.y,messageCell.lblMessage.frame.size.width,size.height)];
            
            [messageCell.btnDelete setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            [messageCell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [messageCell.btnCheckMark setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            [messageCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
            return messageCell;
            
        }
        else if (segment.selectedSegmentIndex==2) {
            
            /* picCell= (UploadPicTableViewCell*)[tblView dequeueReusableCellWithIdentifier:picCellIdentifier];
             
             if (Nil == picCell)
             {
             picCell = [UploadPicTableViewCell createTextRowWithOwner:self withDelegate:self];
             }
             [picCell setBackgroundColor:[UIColor clearColor]];
             
             BackPackD *bData=[self.arrBackPackList objectAtIndex:indexPath.row];
             
             [picCell.lblTitle setText:bData.backPackPicName];
             
             [picCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largeBackPackImageURL,bData.backPackPic]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
             
             [picCell.btnDelete setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateReserved];
             [picCell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
             
             [picCell.btnCheckMark setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateReserved];
             [picCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
             return picCell;*/
            
            UITableViewCell *folderCell = [tblView dequeueReusableCellWithIdentifier:folderCellIdentifier];
            
            if(!folderCell)
            {
                folderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:folderCellIdentifier];
                
                [folderCell setBackgroundColor:[UIColor clearColor]];
                
                UILabel *lblName=[[UILabel alloc] init];
                [lblName setFrame:CGRectMake(10, 5,400,35)];
                [lblName setBackgroundColor:[UIColor clearColor]];
                [lblName setFont:[UIFont systemFontOfSize:14]];
                [lblName setTag:2];
                
                if(DEVICE_OS_VERSION_7_0)
                    [folderCell.contentView addSubview:lblName];
                else
                    [folderCell addSubview:lblName];
                
            }
            
            
            UILabel *lbl=(UILabel*)[folderCell viewWithTag:2];
            [lbl setText:[[self.arrBackPackList objectAtIndex:indexPath.row]objectForKey:@"title"]];
            
            
            return folderCell;
            
            
            
        }
        else if (segment.selectedSegmentIndex==3) {
            
            /* fileCell= (UploadFileTableViewCell*)[tblView dequeueReusableCellWithIdentifier:fileCellIdentifier];
             
             if (Nil == fileCell)
             {
             fileCell = [UploadFileTableViewCell createTextRowWithOwner:self withDelegate:self];
             }
             
             [fileCell setBackgroundColor:[UIColor clearColor]];
             
             [fileCell.btnDelete setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateReserved];
             [fileCell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
             
             [fileCell.btnCheckMark setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateReserved];
             [fileCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
             return fileCell;*/
            
            UITableViewCell *folderCell = [tblView dequeueReusableCellWithIdentifier:folderCellIdentifier];
            
            if(!folderCell)
            {
                folderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:folderCellIdentifier];
                
                [folderCell setBackgroundColor:[UIColor clearColor]];
                
                UILabel *lblName=[[UILabel alloc] init];
                [lblName setFrame:CGRectMake(10, 5,400,35)];
                [lblName setBackgroundColor:[UIColor clearColor]];
                [lblName setFont:[UIFont systemFontOfSize:14]];
                [lblName setTag:2];
                
                if(DEVICE_OS_VERSION_7_0)
                    [folderCell.contentView addSubview:lblName];
                else
                    [folderCell addSubview:lblName];
                
            }
            
            
            UILabel *lbl=(UILabel*)[folderCell viewWithTag:2];
            [lbl setText:[[self.arrBackPackList objectAtIndex:indexPath.row]objectForKey:@"title"]];
            
            
            return folderCell;
            
        }
        
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
                
                if (segment.selectedSegmentIndex==0) {
                    
                    [array addObject:data.backPackReminderId];
                }
                else if(segment.selectedSegmentIndex==1)
                {
                    [array addObject:data.backPackMessageId];
                    
                }
                else if(segment.selectedSegmentIndex==2)
                {
                    [array addObject:data.backPackPicId];
                    
                }
                else
                {
                    [array addObject:data.backPackFileId];
                    
                }
                
            }
            
            joinedString = [array componentsJoinedByString:@","];
            
            if([ConfigManager isInternetAvailable]){
                
                ContactD *cData=[self.arrContactList objectAtIndex:indexPath.row];
                
                [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                [dic setObject:cData.userid forKey:@"member_id"];
                
                [dic setObject:joinedString forKey:@"backpackId"];
                
                if (segment.selectedSegmentIndex==0) {
                    
                    [dic setObject:@"reminder" forKey:@"type"];
                    
                }
                else if (segment.selectedSegmentIndex==1) {
                    
                    [dic setObject:@"message" forKey:@"type"];
                    
                }
                else if (segment.selectedSegmentIndex==2) {
                    
                    [dic setObject:@"media" forKey:@"type"];
                    
                }
                else if (segment.selectedSegmentIndex==3) {
                    
                    [dic setObject:@"media" forKey:@"type"];
                    
                }
                
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
        if (segment.selectedSegmentIndex==2) {
            
            
            if (IS_DEVICE_IPAD) {
                
                self.objUploadListViewController=[[UploadListViewController alloc] initWithNibName:@"UploadListViewController" bundle:nil];
                
            }
            else
            {
                self.objUploadListViewController=[[UploadListViewController alloc] initWithNibName:@"UploadListViewController_iphone" bundle:nil];
                
            }
            self.objUploadListViewController.tagId=self.tagId;
            self.objUploadListViewController.folderId=[[self.arrBackPackList objectAtIndex:indexPath.row] objectForKey:@"id"];
            self.objUploadListViewController.folderTitle=[[self.arrBackPackList objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            
            self.objUploadListViewController.checkUpload=@"Pic";
            [self.view addSubview:self.objUploadListViewController.view];
        }
        else if(segment.selectedSegmentIndex==3)
        {
            
            if (IS_DEVICE_IPAD) {
                
                self.objUploadListViewController=[[UploadListViewController alloc] initWithNibName:@"UploadListViewController" bundle:nil];
                
            }
            else
            {
                self.objUploadListViewController=[[UploadListViewController alloc] initWithNibName:@"UploadListViewController_iphone" bundle:nil];
                
            }
            self.objUploadListViewController.tagId=self.tagId;
            self.objUploadListViewController.folderId=[[self.arrBackPackList objectAtIndex:indexPath.row] objectForKey:@"id"];
            self.objUploadListViewController.checkUpload=@"File";
            self.objUploadListViewController.folderTitle=[[self.arrBackPackList objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            [self.view addSubview:self.objUploadListViewController.view];
        }
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
        
        [self.popoverController  presentPopoverFromRect:btnShare.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
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

-(void)AllReminderListInvocationDidFinish:(AllReminderListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* reminderArray = NULL_TO_NIL([response valueForKey:@"backpackReminder"]);
            
            NSLog(@"%@",reminderArray);
            
            for (int i=0; i< [reminderArray count]; i++) {
                
                NSDictionary *fDict = [reminderArray objectAtIndex:i];
                
                BackPackD *bData = [[BackPackD alloc] init];
                
                bData.backPackReminderId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                bData.backPackReminderTitle = NULL_TO_NIL([fDict valueForKey:@"title"]);
                bData.backPackReminderDate = NULL_TO_NIL([fDict valueForKey:@"reminder_time"]);
                bData.backPackReminderDesc = NULL_TO_NIL([fDict valueForKey:@"description"]);
                
                
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
-(void)AllBackpackMessageListInvocationDidFinish:(AllBackpackMessageListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* reminderArray = NULL_TO_NIL([response valueForKey:@"backpackMessage"]);
            
            NSLog(@"%@",reminderArray);
            
            for (int i=0; i< [reminderArray count]; i++) {
                
                NSDictionary *fDict = [reminderArray objectAtIndex:i];
                
                BackPackD *bData = [[BackPackD alloc] init];
                
                bData.backPackMessageId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                bData.backPackMessage = NULL_TO_NIL([fDict valueForKey:@"message"]);
                
                
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
-(void)DeleteBackpackReminderInvocationDidFinish:(DeleteBackpackReminderInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"DeleteBackpackReminderInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                
                [ConfigManager showAlertMessage:nil Message:@"Reminder not deleted"];
            }
            else
            {
                NSLog(@"%lu",(unsigned long)[self.arrBackPackList count]);
                
                NSLog(@"%lu",self.selectedIndxpath);
                
                [self.arrBackPackList removeObjectAtIndex:self.selectedIndxpath];
                
            }
            
            [tblView reloadData];
            
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
-(void)DeletebackpackMessageInvocationDidFinish:(DeletebackpackMessageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"DeletebackpackMessageInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            
            if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                
                [ConfigManager showAlertMessage:nil Message:@"Message not deleted"];
            }
            else
            {
                NSLog(@"%lu",(unsigned long)[self.arrBackPackList count]);
                
                NSLog(@"%lu",self.selectedIndxpath);
                
                [self.arrBackPackList removeObjectAtIndex:self.selectedIndxpath];
                
            }
            
            [tblView reloadData];
            
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
                
                NSLog(@"%lu",self.selectedIndxpath);
                
                [self.arrBackPackList removeObjectAtIndex:self.selectedIndxpath];
                
            }
            
            [tblView reloadData];
            
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
                
                NSLog(@"%lu",self.selectedIndxpath);
                
                [self.arrBackPackList removeObjectAtIndex:self.selectedIndxpath];
                
            }
            
            [tblView reloadData];
            
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
-(void)FolderListInvocationDidFinish:(FolderListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error{
    
    NSLog(@"%@",dict);
    [self.arrBackPackList removeAllObjects];
    [DSBezelActivityView removeView];
    
    NSLog(@"%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* folderArray = NULL_TO_NIL([response valueForKey:@"backpackFolder"]);
            
            NSLog(@"%@",folderArray);
            
            for (int i=0; i< [folderArray count]; i++) {
                
                NSDictionary *fDict = [folderArray objectAtIndex:i];
                
                NSString *folderIdStr =[NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"id"])];
                NSString *folderTitleStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"title"])];
                
                [self.arrBackPackList addObject:[NSDictionary dictionaryWithObjectsAndKeys:folderIdStr,@"id",folderTitleStr,@"title",nil]];
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
    
    
    //
    
    
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
