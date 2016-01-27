//
//  RouteCommentViewController.m
//  SipDemo
//
//  Created by Octal on 14/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "RouteCommentViewController.h"
#import "UIImageExtras.h"
#import "HMSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "QSStrings.h"
#import "MileageCommentTableViewCell.h"

@interface RouteCommentViewController ()

@end

@implementation RouteCommentViewController

@synthesize arrCommentList,rootId,selectedIndxpath;

- (void)viewDidLoad {
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
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                
            }
            
            
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
    
    self.arrCommentList=[[NSMutableArray alloc] init];
    
    [self requestForGetComments];
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)requestForGetComments
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Favorite list..." width:180];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:self.rootId forKey:@"postId"];
        
        [[AmityCareServices sharedService] RouteCommentListInvocation:dic delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)btnDeleteClick:(MileageCommentTableViewCell*)cellValue
{
    NSInteger row=cellValue.btnDelete.tag;
    
    self.selectedIndxpath=[NSIndexPath indexPathForRow:row inSection:1];
    
    ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Post ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
    [deleteAlert show];
    
    
    
}
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                NSLog(@"%ld",(long)self.selectedIndxpath.row);
                
                CommentValues* comment = [self.arrCommentList objectAtIndex:self.selectedIndxpath.row];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setObject:comment.commentId forKey:@"commentId"];
                
                [[AmityCareServices sharedService] DeleteRouteCommentInvocation:dic delegate:self];
                
                
            }
            else{
                
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
        }
    }
}
#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrCommentList count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentValues *comment=[self.arrCommentList objectAtIndex:indexPath.row];
    
    int sizeToFit=0;
    
    CGRect textRect;
    
    if (IS_DEVICE_IPAD) {
        
        textRect= [comment.commentMsg boundingRectWithSize:CGSizeMake(320.0f, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                   context:nil];
        
        sizeToFit = textRect.size.height+45;
    }
    else
    {
        textRect= [comment.commentMsg boundingRectWithSize:CGSizeMake(200.0f, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                   context:nil];
        
        sizeToFit = textRect.size.height+70;
        
    }
    
    
    return sizeToFit;
    //return 90;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"FeedListCell";
    
    cell = (MileageCommentTableViewCell*)[tblView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (Nil == cell)
    {
        cell = [MileageCommentTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    CommentValues *data=[self.arrCommentList objectAtIndex:indexPath.row];
    cell.lblComment.numberOfLines=0;
    
    
    [cell.btnDelete setTag:indexPath.row];
    cell.lblUname.text=data.commentUserName;
    cell.lblCommentTime.text=data.commentDate;
    
    CGRect textRect= [data.commentMsg boundingRectWithSize:CGSizeMake(cell.lblComment.frame.size.width, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                   context:nil];
    
    
    //CGRect labelFrame = cell.lblComment.frame;
    //labelFrame.size.height = textRect.size.height;
    //cell.lblComment.frame = labelFrame;
    
    [cell.lblComment setFrame:CGRectMake(cell.lblComment.frame.origin.x, cell.lblComment.frame.origin.y, cell.lblComment.frame.size.width, textRect.size.height)];
    
    
    
    NSLog(@"%f",textRect.size.height);
    
    cell.lblComment.text=data.commentMsg;
    
    cell.profileImage.layer.cornerRadius = floor(cell.profileImage.frame.size.width/2);
    cell.profileImage.clipsToBounds = YES;
    
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,data.commentUserImage]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
    
}
-(void)RouteCommentListInvocationDidFinish:(RouteCommentListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    NSLog(@"error %@",error);
    
    [self.arrCommentList removeAllObjects];
    
    @try {
        if(!error)
        {
            
            NSDictionary* dic = [dict valueForKey:@"response"];
            
            NSArray *routeArray= [dic valueForKey:@"rootComment"];
            
            if ([routeArray count]>0) {
                
                for (int i=0; i < [routeArray count]; i++) {
                    
                    NSDictionary *tDict = [routeArray objectAtIndex:i];
                    
                    CommentValues *comment=[[CommentValues alloc] init];
                    
                    comment.commentId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                    comment.commentDate=NULL_TO_NIL([tDict valueForKey:@"commentDate"]);
                    comment.commentUserId=NULL_TO_NIL([tDict valueForKey:@"userId"]);
                    comment.commentUserName=NULL_TO_NIL([tDict valueForKey:@"userName"]);
                    comment.commentUserImage=NULL_TO_NIL([tDict valueForKey:@"commentUserImage"]);
                    
                    NSString *msgStr=NULL_TO_NIL([tDict valueForKey:@"comment"]);
                    
                    msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                    
                    NSString *commentStr=[[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                    
                    comment.commentMsg=commentStr;
                    
                    [self.arrCommentList addObject:comment];
                    
                }
            }
            tblView.delegate=self;
            tblView.dataSource=self;
            
            [tblView reloadData];
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
-(void)DeleteRouteCommentInvocationDidFinish:(DeleteRouteCommentInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    {
        NSLog(@"deleteContactInvocationDidFinish =%@",dict);
        @try {
            
            if (!error) {
                
                id response = [dict valueForKey:@"response"];
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if([strSuccess rangeOfString:@"true"].length>0){
                    
                    NSLog(@"%lu",(unsigned long)[self.arrCommentList count]);
                    
                    NSLog(@"%ld",(long)self.selectedIndxpath.row);
                    
                    [self.arrCommentList removeObjectAtIndex:self.selectedIndxpath.row];
                    
                }
                else
                {
                    [ConfigManager showAlertMessage:nil Message:@"Comment not deleted"];
                    
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
            [tblView setContentOffset:CGPointMake(0, 0)];
            
        }
        
    }
    
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
