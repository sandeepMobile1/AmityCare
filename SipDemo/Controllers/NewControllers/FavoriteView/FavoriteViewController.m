//
//  FavoriteViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "FavoriteViewController.h"
#import "Feeds.h"
#import "FavoriteTableViewCell.h"
#import "UIImageExtras.h"
#import "HMSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "FormValues.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "FeedDetailViewController.h"
#import "FormFeedDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "RouteFeedDetailViewController.h"
#import "RecieptFeedDetailViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

@synthesize arrFeedList,tagId,objFeedDetailViewController,objFormFeedDetailViewController,objStatusFeedDetailViewController,popoverController,objRouteFeedDetailViewController,objRecieptFeedDetailViewController;

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
    
    self.arrFeedList=[[NSMutableArray alloc] init];
    
    [self requestForGetTagFeeds];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    
}
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
        
    }
}
-(void)requestForGetTagFeeds
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Favorite list..." width:180];
        [[AmityCareServices sharedService] FavoriteFeedListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrFeedList count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* feedCellIdentifier = @"FeedListCell";
    
    feedCell = (FavoriteTableViewCell*)[tblLeftFeedView dequeueReusableCellWithIdentifier:feedCellIdentifier];
    
    if (Nil == feedCell)
    {
        feedCell = [FavoriteTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    Feeds *data=[self.arrFeedList objectAtIndex:indexPath.row];
    
    feedCell.lblName.text=data.postUserName;
    feedCell.lblIntro.text=data.postDesc;
    feedCell.lbldate.text=data.postTime;
    
    feedCell.imgView.layer.cornerRadius = floor(feedCell.imgView.frame.size.width/2);
    feedCell.imgView.clipsToBounds = YES;
    
    [feedCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,data.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    [feedCell setBackgroundColor:[UIColor clearColor]];
    
    feedCell.lblName.font = [UIFont fontWithName:boldfontName size:15.0];
    feedCell.lblIntro.font = [UIFont fontWithName:appfontName size:11.0f];
    
    return feedCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tblLeftFeedView cellForRowAtIndexPath:indexPath];
    
    if ([feed.postType isEqualToString:@"6"]) {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController" bundle:nil];
            
            self.objFormFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
            
            self.objFormFeedDetailViewController.feedDetails=feed;
            self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objFormFeedDetailViewController];
            
            self.popoverController.popoverContentSize= CGSizeMake(450, 780);
            
            [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController_iphone" bundle:nil];
            self.objFormFeedDetailViewController.feedDetails=feed;
            self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
            
            [sharedAppDelegate.window addSubview:self.objFormFeedDetailViewController.view];
        }
        
        
    }
    else if([feed.postType isEqualToString:@"4"])
    {
        
        if (IS_DEVICE_IPAD) {
            
            
            self.objStatusFeedDetailViewController=[[StatusFeedDetailViewController alloc] initWithNibName:@"StatusFeedDetailViewController" bundle:nil];
            
            self.objStatusFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
            
            self.objStatusFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.objStatusFeedDetailViewController.feedDetails=feed;
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objStatusFeedDetailViewController];
            
            self.popoverController.popoverContentSize= CGSizeMake(450, 780);
            
            [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            
            self.objStatusFeedDetailViewController=[[StatusFeedDetailViewController alloc] initWithNibName:@"StatusFeedDetailViewController_iphone" bundle:nil];
            self.objStatusFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.objStatusFeedDetailViewController.feedDetails=feed;
            [sharedAppDelegate.window addSubview:self.objStatusFeedDetailViewController.view];
        }
    }
    else if([feed.postType isEqualToString:@"7"])
    {
        if ([feed.routeType isEqualToString:@"1"]) {
            
            if (IS_DEVICE_IPAD) {
                
                [self.popoverController dismissPopoverAnimated:YES];
                
                self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController" bundle:nil];
                
                self.objRouteFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                
                self.objRouteFeedDetailViewController.feedDetails=feed;
                self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRouteFeedDetailViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                
                [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController_iphone" bundle:nil];
                
                self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objRouteFeedDetailViewController.feedDetails=feed;
                
                [sharedAppDelegate.window addSubview:self.objRouteFeedDetailViewController.view];
            }
            
        }
        else
        {
            if (IS_DEVICE_IPAD) {
                
                [self.popoverController dismissPopoverAnimated:YES];
                
                self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController" bundle:nil];
                
                self.objRecieptFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                
                self.objRecieptFeedDetailViewController.feedDetails=feed;
                self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRecieptFeedDetailViewController];
                
                self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                
                [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController_iphone" bundle:nil];
                
                self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                
                self.objRecieptFeedDetailViewController.feedDetails=feed;
                
                [sharedAppDelegate.window addSubview:self.objRecieptFeedDetailViewController.view];
            }
            
        }
        
        
    }


    else
    {
        
        if (IS_DEVICE_IPAD) {
            
            self.objFeedDetailViewController=[[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
            
            self.objFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
            
            self.objFeedDetailViewController.feedDetails=feed;
            self.objFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objFeedDetailViewController];
            
            self.popoverController.popoverContentSize= CGSizeMake(450, 780);
            
            [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            self.objFeedDetailViewController=[[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController_iphone" bundle:nil];
            
            self.objFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.objFeedDetailViewController.feedDetails=feed;
            
            [sharedAppDelegate.window addSubview:self.objFeedDetailViewController.view];
        }
    }
    
}
#pragma mark - get Feed List invocation Delegates

-(void)FavoriteFeedListInvocationDidFinish:(FavoriteFeedListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFeedsInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) intValue];
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]>0)
                {
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        Feeds *feed = [[Feeds alloc] init];
                        
                        NSDictionary *fDict = [post objectAtIndex:i];
                        
                        feed.postUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.postUserName = NULL_TO_NIL([fDict valueForKey:@"username"]);
                        feed.postUserImgURL = NULL_TO_NIL([fDict valueForKey:@"user_img"]);
                        feed.postId = NULL_TO_NIL([fDict valueForKey:@"post_id"]);
                        feed.postTime = NULL_TO_NIL([fDict valueForKey:@"time"]);
                        feed.postThumbnailURL = NULL_TO_NIL([fDict valueForKey:@"post_image"]);
                        feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        
                        feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                        feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                        
                        feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                        feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]
                                         stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                        feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                        
                        feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                        
                        feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                        feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                        feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                        
                        feed.employeeStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"employee"])];
                        feed.managerStatusStr    = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"manager"])];
                        feed.teamLeaderStatusStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"teamleader"])];
                        feed.familyStatusStr     = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"family"])];
                        // feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        
                        feed.arrSimiliarTags = [[NSMutableArray alloc ]  init];
                        
                        NSArray *fTags = NULL_TO_NIL([fDict valueForKey:@"similar_tags"]);
                        
                        for (int j = 0; j <[fTags count]; j++) {
                            
                            NSDictionary *inner = [fTags objectAtIndex:j];
                            
                            Tags *t = [[Tags alloc] init];
                            
                            t.tagId = NULL_TO_NIL([inner valueForKey:@"tag_id"]);
                            t.tagTitle = NULL_TO_NIL([inner valueForKey:@"tag_title"]);
                            
                            [feed.arrSimiliarTags addObject:t];
                        }
                        
                        feed.arrFormValues = [[NSMutableArray alloc ]  init];
                        
                        if ([feed.postType isEqualToString:@"6"]) {
                            
                            NSArray *fFormValues = NULL_TO_NIL([fDict valueForKey:@"formVal"]);
                            
                            for (int j = 0; j <[fFormValues count]; j++) {
                                
                                NSDictionary *inner = [fFormValues objectAtIndex:j];
                                
                                FormValues *t = [[FormValues alloc] init];
                                
                                t.strFormQueStr = NULL_TO_NIL([inner valueForKey:@"label"]);
                                t.strFormAnsStr = NULL_TO_NIL([inner valueForKey:@"value"]);
                                
                                t.strFormTypeStr = NULL_TO_NIL([inner valueForKey:@"label_type"]);
                                t.strFormImageStr = NULL_TO_NIL([inner valueForKey:@"answerimage"]);
                                t.strFormVideoStr = NULL_TO_NIL([inner valueForKey:@"answerurl"]);
                                t.strFormUrlTypeStr = NULL_TO_NIL([inner valueForKey:@"imageUrlType"]);
                                
                                [feed.arrFormValues addObject:t];
                            }
                            
                            
                        }
                        feed.arrCommentValues = [[NSMutableArray alloc ]  init];
                        
                        NSArray *fCommentValues = NULL_TO_NIL([fDict valueForKey:@"comment"]);
                        
                        for (int j = 0; j <[fCommentValues count]; j++) {
                            
                            NSDictionary *inner = [fCommentValues objectAtIndex:j];
                            
                            CommentValues *t = [[CommentValues alloc] init];
                            
                            t.commentId = NULL_TO_NIL([inner valueForKey:@"id"]);
                            t.commentUserId = NULL_TO_NIL([inner valueForKey:@"userId"]);
                            t.commentUserName = NULL_TO_NIL([inner valueForKey:@"username"]);
                            t.commentUserImage = NULL_TO_NIL([inner valueForKey:@"user_img"]);
                            t.commentDate = NULL_TO_NIL([inner valueForKey:@"time"]);
                            
                            NSString *msgStr=NULL_TO_NIL([inner valueForKey:@"comment"]);
                            
                            msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                            
                            t.commentMsg = [[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                            
                            [feed.arrCommentValues addObject:t];
                        }
                        
                        NSDictionary *tDict = NULL_TO_NIL([fDict valueForKey:@"rootPath"]);
                        
                        feed.routeId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                        feed.routeCreated=NULL_TO_NIL([tDict valueForKey:@"created"]);
                        feed.routeStartLatitude=NULL_TO_NIL([tDict valueForKey:@"start_latitude"]);
                        feed.routeStartLongitude=NULL_TO_NIL([tDict valueForKey:@"start_longitude"]);
                        feed.routeEndLatitude=NULL_TO_NIL([tDict valueForKey:@"end_latitude"]);
                        feed.routeEndLongitude=NULL_TO_NIL([tDict valueForKey:@"end_longitude"]);
                        feed.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);
                        feed.routeImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                        feed.routeStartAdd=NULL_TO_NIL([tDict valueForKey:@"start_address"]);
                        feed.routeEndAdd=NULL_TO_NIL([tDict valueForKey:@"end_address"]);
                        feed.routeStartTime=NULL_TO_NIL([tDict valueForKey:@"start_time"]);
                        feed.routeEndTime=NULL_TO_NIL([tDict valueForKey:@"end_time"]);
                        feed.routeWeekDay=NULL_TO_NIL([tDict valueForKey:@"day"]);
                        feed.routeShareByUser=NULL_TO_NIL([tDict valueForKey:@"senderName"]);
                        feed.routeType=NULL_TO_NIL([tDict valueForKey:@"type"]);
                        feed.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);

                        feed.recieptMerchantName=NULL_TO_NIL([tDict valueForKey:@"merchant_name"]);
                        feed.recieptAmount=NULL_TO_NIL([tDict valueForKey:@"amount"]);
                        feed.recieptDescription=NULL_TO_NIL([tDict valueForKey:@"description"]);
                        feed.recieptDate=NULL_TO_NIL([tDict valueForKey:@"date"]);
                        feed.recieptImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                        feed.recieptReimbursementStatus=NULL_TO_NIL([tDict valueForKey:@"reimbursment"]);
                        
                        [self.arrFeedList addObject:feed];
                        
                    }
                }
                else
                {
                    [self.arrFeedList removeAllObjects];
                    recordCount = 0;
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found"];
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                [tblLeftFeedView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) intValue];
                    
                }
                
                tblLeftFeedView.delegate=self;
                tblLeftFeedView.dataSource=self;
                [tblLeftFeedView reloadData];
            }
        }
        else
        {
            if (pageIndex>1) {
                
                pageIndex=pageIndex-1;
            }
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
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

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
