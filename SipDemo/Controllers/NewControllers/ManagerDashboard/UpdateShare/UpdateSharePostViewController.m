//
//  UpdateSharePostViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import "UpdateSharePostViewController.h"
#import "ConfigManager.h"
#import "Feeds.h"
#import "UIImageView+WebCache.h"
#import "FavoriteTableViewCell.h"
#import "FormValues.h"
#import "FormFeedDetailViewController.h"
#import "FeedDetailViewController.h"
#import "StatusFeedDetailViewController.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "RouteFeedDetailViewController.h"
#import "RecieptFeedDetailViewController.h"

@interface UpdateSharePostViewController ()

@end

@implementation UpdateSharePostViewController

@synthesize startDate,endDate,objFeedDetailViewController,objFormFeedDetailViewController,objStatusFeedDetailViewController,popoverController,objRouteFeedDetailViewController,objRecieptFeedDetailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndex=1;
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
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
    
    self.arrFeedList=[[NSMutableArray alloc] init];
    
    // [self requestForGetTagFeeds];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
-(void)requestForGetTagFeeds
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Share list..." width:180];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        [dic setObject:txtTagName.text forKey:@"tag_name"];
        
        [[AmityCareServices sharedService] ManagerSharePostListInvocation:dic delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)btnSearchPressed:(id)sender
{
    [txtTagName resignFirstResponder];
    [txtStartDate resignFirstResponder];
    [txtEndDate resignFirstResponder];
    pageIndex=1;

    if([ConfigManager isInternetAvailable])
    {
        if (txtTagName.text==nil || txtTagName.text==(NSString*)[NSNull null]) {
            
            txtTagName.text=@"";
        }
        if (txtEndDate.text==nil || txtEndDate.text==(NSString*)[NSNull null]) {
            
            txtEndDate.text=@"";
        }
        if (txtStartDate.text==nil || txtStartDate.text==(NSString*)[NSNull null]) {
            
            txtStartDate.text=@"";
        }
        
        if (txtEndDate.text.length>0 && txtStartDate.text.length==0) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please Select Start date"];
            
            return;
        }
        else if (txtStartDate.text.length>0 && txtEndDate.text.length==0) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please Select End date"];
            
            return;
        }
        else
        {
            pageIndex=1;
            [self.arrFeedList removeAllObjects];
            [self requestForGetTagFeeds];
            
        }
        
        
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if ([self.arrFeedList count]>0) {
        
        if(recordCount > [self.arrFeedList count])
            
            numberOfRows = [self.arrFeedList count]+1;
        else
            
            numberOfRows = [self.arrFeedList count];
        
    }
    return numberOfRows;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* feedCellIdentifier = @"FeedListCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    
    if(indexPath.row < [self.arrFeedList count])
    {
        FavoriteTableViewCell *feedCell = (FavoriteTableViewCell*)[tblView dequeueReusableCellWithIdentifier:feedCellIdentifier];
        
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
    else
    {
        UITableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:defaultCellIdentifier];
        
        if(!loadMoreCell)
        {
            loadMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:defaultCellIdentifier];
        }
        
        [loadMoreCell setBackgroundColor:[UIColor clearColor]];
        
        UIButton * headerbutton= [UIButton buttonWithType:UIButtonTypeCustom];
        [headerbutton setBackgroundImage:[UIImage imageNamed:@"green_btn.png"] forState:UIControlStateNormal];
        [headerbutton setTitle:@"Load more ..." forState:UIControlStateNormal];
        [headerbutton setTitle:@"Load more ..." forState:UIControlStateSelected];
        [headerbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [headerbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        headerbutton.titleLabel.font = [UIFont fontWithName:appfontName size:20.0f];
        
        if (IS_DEVICE_IPAD) {
            
            [headerbutton setFrame:CGRectMake(0, 0, 418, 60)];
            
        }
        else
        {
            [headerbutton setFrame:CGRectMake(0, 0, 275, 60)];
            
        }
        
        [headerbutton addTarget:self action:@selector(loadMoreRecords) forControlEvents:UIControlEventTouchUpInside];
        
        if(DEVICE_OS_VERSION_7_0)
            [loadMoreCell.contentView addSubview:headerbutton];
        else
            [loadMoreCell addSubview:headerbutton];
        
        if (recordCount>[self.arrFeedList count]) {
            
            [headerbutton setHidden:FALSE];
        }
        else
        {
            [headerbutton setHidden:TRUE];
            
        }
        
        return loadMoreCell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feeds *feed=[self.arrFeedList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    
    if ([feed.postType isEqualToString:@"6"]) {
        
        
        if (IS_DEVICE_IPAD) {
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            self.objFormFeedDetailViewController=[[FormFeedDetailViewController alloc] initWithNibName:@"FormFeedDetailViewController" bundle:nil];
            
            self.objFormFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
            self.objFormFeedDetailViewController.checkBSAndFamily=@"NO";
            
            self.objFormFeedDetailViewController.feedDetails=feed;
            
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
            
            [self.popoverController dismissPopoverAnimated:YES];
            
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
            
            [self.popoverController dismissPopoverAnimated:YES];
            
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

-(void)AllTagPostInvocationFinish:(AllTagPostInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
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
                pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                
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
                        //  feed.trainingStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"training"])];
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
                
                [tblView reloadData];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [self.arrFeedList removeAllObjects];
                recordCount = 0;
                
                NSArray* post = [response valueForKey:@"post"];
                
                if([post count]==0)
                {
                    recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
                    pageIndex = [NULL_TO_NIL([response valueForKey:@"page"]) integerValue];
                    
                }
                
                
                [tblView reloadData];
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
-(void)ManagerSharePostListInvocationDidFinish:(ManagerSharePostListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
}
#pragma mark- UITextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:txtStartDate]){
        
        if (IS_DEVICE_IPAD) {
            
            UIViewController* popoverContent = [[UIViewController alloc] init];
            
            UIView *popoverView = [[UIView alloc] init];
            popoverView.backgroundColor = [UIColor clearColor];
            
            toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                          target: self
                                                                                          action: @selector(cancel)];
            UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                   target: nil
                                                                                   action: nil];
            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                        target: self
                                                                                        action: @selector(done)];
            
            NSMutableArray* toolbarItems = [NSMutableArray array];
            [toolbarItems addObject:cancelButton];
            [toolbarItems addObject:space];
            [toolbarItems addObject:doneButton];
          
            toolbar.items = toolbarItems;
            
            datePicker=[[UIDatePicker alloc]init];
            datePicker.frame=CGRectMake(0,44,320, 216);
            datePicker.datePickerMode = UIDatePickerModeDate;
            
            [datePicker setTag:10];
            [popoverView addSubview:toolbar];
            [popoverView addSubview:datePicker];
            
            popoverContent.view = popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
            self.popoverController.delegate=self;
            
            txtStartDate.inputView=datePicker;
            
            [self.popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
            [self.popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self showStartDatePicker];
            
        }
        
        
    }
    else if([textField isEqual:txtEndDate]){
        
        
        if(txtStartDate.text.length ==0){
            [ConfigManager showAlertMessage:nil Message:@"Please select start date first"];
            return FALSE;
        }
        if (IS_DEVICE_IPAD) {
            
            UIViewController* popoverContent = [[UIViewController alloc] init];
            
            UIView *popoverView = [[UIView alloc] init];
            popoverView.backgroundColor = [UIColor clearColor];
            
            toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                          target: self
                                                                                          action: @selector(cancel)];
            UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                   target: nil
                                                                                   action: nil];
            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                        target: self
                                                                                        action: @selector(endDone)];
            
            NSMutableArray* toolbarItems = [NSMutableArray array];
            [toolbarItems addObject:cancelButton];
            [toolbarItems addObject:space];
            [toolbarItems addObject:doneButton];
           
            toolbar.items = toolbarItems;
            
            datePicker=[[UIDatePicker alloc]init];
            datePicker.frame=CGRectMake(0,44,320, 216);
            datePicker.datePickerMode = UIDatePickerModeDate;
            
            [datePicker setTag:10];
            [popoverView addSubview:toolbar];
            [popoverView addSubview:datePicker];
            
            popoverContent.view = popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
            self.popoverController.delegate=self;
            
            txtEndDate.inputView=datePicker;
            
            [self.popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
            [self.popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self showEndDatePicker];
            
        }
        
    }
    else
    {
        return TRUE;
    }
    
    return FALSE;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return TRUE;
}
-(void)showStartDatePicker
{
    [txtTagName resignFirstResponder];
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    toolbar = [[UIToolbar alloc]init];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(done)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:datePicker];
    [self.view addSubview:toolbar];
    
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 165.0+IPHONE_FIVE_FACTOR, 275, 44.0)];
        
        datePicker.frame=CGRectMake(0,200+IPHONE_FIVE_FACTOR,275, 216);
        [txtStartDate resignFirstResponder];
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 165.0, 320.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,200,275, 216);
        [txtStartDate resignFirstResponder];
    }
    
    
}
-(void)showEndDatePicker
{
    [txtTagName resignFirstResponder];
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    toolbar = [[UIToolbar alloc] init];
    
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(endDone)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    [self.view addSubview:datePicker];
    
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 165.0+IPHONE_FIVE_FACTOR, 275, 44.0)];
        datePicker.frame=CGRectMake(0,200+IPHONE_FIVE_FACTOR,275, 216);
        [txtEndDate resignFirstResponder];
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 165.0, 275, 44.0)];
        
        datePicker.frame=CGRectMake(0,200,275, 216);
        [txtEndDate resignFirstResponder];
    }
    
}
-(IBAction)cancel
{
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
        [txtStartDate resignFirstResponder];
        [txtEndDate resignFirstResponder];
    }
    
}
-(IBAction)done
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *dateStr = [formatter stringFromDate:dateSelected]; // Convert date
    
    self.startDate = [formatter dateFromString:dateStr];
    
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Start time should be less than end time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    txtStartDate.text = [formatter stringFromDate:dateSelected];
    
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
        [txtStartDate resignFirstResponder];
        [txtEndDate resignFirstResponder];
    }
}
-(IBAction)endDone
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *dateStr = [formatter stringFromDate:dateSelected]; // Convert date
    NSLog(@"%@",dateStr);
    
    self.endDate = [formatter dateFromString:dateStr];
    
    
    if ([self.startDate compare:self.endDate]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End time should be greater than start time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    
    txtEndDate.text = [formatter stringFromDate:dateSelected];
    
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    }
    else
    {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
        [txtStartDate resignFirstResponder];
        [txtEndDate resignFirstResponder];
    }
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    
    [self requestForGetTagFeeds];
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
