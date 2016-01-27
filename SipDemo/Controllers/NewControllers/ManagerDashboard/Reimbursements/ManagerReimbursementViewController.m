//
//  ManagerReimbursementViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import "ManagerReimbursementViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "ConfigManager.h"
#import "RouteData.h"
#import "UIImageView+WebCache.h"
#import "QSStrings.h"
#import "FormButtonTableViewCell.h"
#import "RouteFeedDetailViewController.h"
#import "RecieptFeedDetailViewController.h"
#import "FormValues.h"
#import "CommentValues.h"
#import "Feeds.h"
#import "ContactD.h"

@interface ManagerReimbursementViewController ()

@end

@implementation ManagerReimbursementViewController

@synthesize popoverContentDatePicker,popoverController,popoverView,arrRouteList,totalAmount,arrContactList,popoverContactContent,totalMileage,contactView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    txtTagName.text=@"";
    txtUserName.text=@"";
    
    recordCount=0;
    pageIndex=1;
    
    self.totalAmount=0;
    self.totalMileage=0;

    self.arrRouteList=[[NSMutableArray alloc] init];
    self.arrContactList=[[NSMutableArray alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];

    pageIndex=1;
    [self requestForReimBursement];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}
-(void)requestForReimBursement
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching result please wait..." width:200];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        [dic setObject:txtTagName.text forKey:@"tag_name"];
        [dic setObject:txtUserName.text forKey:@"user_name"];
        [dic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
        
        [[AmityCareServices sharedService] ManagerReimbursementListInvocation:dic delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [tblView setContentInset:edgeInsets];
        [tblView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [tblView setContentInset:edgeInsets];
        [tblView setScrollIndicatorInsets:edgeInsets];
    }];
}

#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount=0;
    
    NSInteger numberOfRows = 0;
    
    if (tableView==tblView) {
        
        if ([self.arrRouteList count]>0) {
            
            if(recordCount > [self.arrRouteList count])
                
                numberOfRows = [self.arrRouteList count]+1;
            else
                
                numberOfRows = [self.arrRouteList count];
            
            
            rowCount=numberOfRows;
            
            
        }

    }
    else
    {
        rowCount=[self.arrContactList count];
    }
    
    NSLog(@"%lu",(unsigned long)[self.arrContactList count]);
    
    return rowCount;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=0.0;
    
    if (tableView==tblView) {
        
        height=60.0;
    }
    else
    {
        height=44.0;

    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* feedCellIdentifier = @"FeedListCell";
    static NSString* contactCellIdentifier = @"ContactListCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    
    if (tableView==tblView) {
        
        if(indexPath.row < [self.arrRouteList count])
        {
            feedCell = (FormButtonTableViewCell*)[tblView dequeueReusableCellWithIdentifier:feedCellIdentifier];
            
            if (Nil == feedCell)
            {
                feedCell = [FormButtonTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            [feedCell.btnDelete setBackgroundImage:[UIImage imageNamed:@"share_route.png"] forState:UIControlStateNormal];
            
            [feedCell.btnDelete addTarget:self action:@selector(btnSharePressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [feedCell.btnDelete setTag:indexPath.row];
            
            Feeds *data=[self.arrRouteList objectAtIndex:indexPath.row];
            
            feedCell.lblName.text=data.postUserName;
            // feedCell.lblIntro.text=data.postDesc;
            feedCell.lbldate.text=data.postTime;
            feedCell.lblTagName.text=[NSString stringWithFormat:@"Tag: %@",data.tagTitle];
            
            
            
            
            if ([data.routeType isEqualToString:@"1"]) {
                
                [feedCell.lblIntro setText:[NSString stringWithFormat:@"Total mileage: %@",data.routeDistance]];
                
            }
            else
            {
                NSNumber *totalNumber=[NSNumber numberWithFloat:[data.recieptAmount floatValue]]; // The old syntax
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                NSString *strTotal = [formatter stringFromNumber:totalNumber];
                [feedCell.lblIntro setText:[NSString stringWithFormat:@"Total reciept amount: %@",strTotal]];
                
            }
            
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
            
            if (recordCount>[self.arrRouteList count]) {
                
                [headerbutton setHidden:FALSE];
            }
            else
            {
                [headerbutton setHidden:TRUE];
                
            }
            
            return loadMoreCell;
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
    if (tableView==tblView) {

        Feeds *feed=[self.arrRouteList objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
        
        [self.popoverController dismissPopoverAnimated:YES];
        
        if([feed.postType isEqualToString:@"7"])
        {
            if (IS_DEVICE_IPAD) {
                
                if ([feed.routeType isEqualToString:@"1"]) {
                    
                    self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController" bundle:nil];
                    
                    self.objRouteFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                    self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                    
                    self.objRouteFeedDetailViewController.feedDetails=feed;
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRouteFeedDetailViewController];
                    
                    self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                    
                    [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else
                {
                    self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController" bundle:nil];
                    
                    self.objRecieptFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                    self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                    
                    self.objRecieptFeedDetailViewController.feedDetails=feed;
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.objRecieptFeedDetailViewController];
                    
                    self.popoverController.popoverContentSize= CGSizeMake(450, 780);
                    
                    [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }

            }
            
            else
            {
                if ([feed.routeType isEqualToString:@"1"]) {
                    
                    self.objRouteFeedDetailViewController=[[RouteFeedDetailViewController alloc] initWithNibName:@"RouteFeedDetailViewController_iphone" bundle:nil];
                    self.objRouteFeedDetailViewController.checkBSAndFamily=@"NO";
                    
                    self.objRouteFeedDetailViewController.feedDetails=feed;
                    
                    [sharedAppDelegate.window addSubview:self.objRouteFeedDetailViewController.view];
                }
                else
                {
                    self.objRecieptFeedDetailViewController=[[RecieptFeedDetailViewController alloc] initWithNibName:@"RecieptFeedDetailViewController_iphone" bundle:nil];
                    
                    self.objRecieptFeedDetailViewController.preferredContentSize = CGSizeMake(450, 780);
                    self.objRecieptFeedDetailViewController.checkBSAndFamily=@"NO";
                    
                    self.objRecieptFeedDetailViewController.feedDetails=feed;
                    
                    [sharedAppDelegate.window addSubview:self.objRecieptFeedDetailViewController.view];
                }
                

            }
            
        }
    }
    else
    {
        
        Feeds *data=[self.arrRouteList objectAtIndex:selectedShareBtn.tag];
        
        
            if([ConfigManager isInternetAvailable]){
                
                ContactD *cData=[self.arrContactList objectAtIndex:indexPath.row];
                
                [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                [dic setObject:cData.userid forKey:@"member_id"];
                
                [dic setObject:data.routeId forKey:@"rootTagId"];
                
                [[AmityCareServices sharedService] ShareRootListInvocation:dic delegate:self];
            }
            else{
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
        
    }

}
-(void)ManagerReimbursementListInvocationDidFinish:(ManagerReimbursementListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
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
                    feed.postUserEmail = NULL_TO_NIL([fDict valueForKey:@"inbox_email"]);
                    
                    feed.postStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_status"])];
                    feed.postFavStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"favouriteStatus"])];
                    
                    feed.postTitle = [NULL_TO_NIL([fDict valueForKey:@"post_title"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    feed.postActualTime = NULL_TO_NIL([fDict valueForKey:@"actual_post_time"]);
                    feed.postDesc = [[NULL_TO_NIL([fDict valueForKey:@"post_desc"]) stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                    feed.postType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_type"])];
                    feed.postTagId   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"post_tag_id"])];
                    feed.tagTitle         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"tagName"])];

                    feed.postVideoURL = NULL_TO_NIL([fDict valueForKey:@"video"]);
                    feed.latitude = [NULL_TO_NIL([fDict valueForKey:@"latitude"]) floatValue];
                    feed.longitude = [NULL_TO_NIL([fDict valueForKey:@"longitude"]) floatValue];
                    
                    feed.employeeStatusStr   = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"employee"])];
                    feed.managerStatusStr    = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"manager"])];
                    feed.teamLeaderStatusStr = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"teamleader"])];
                    feed.familyStatusStr     = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"family"])];
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
                    
                    feed.arrFormValues = [[NSMutableArray alloc]  init];
                    
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
                    feed.recieptAmount=[NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"amount"])];
                    feed.recieptDescription=NULL_TO_NIL([tDict valueForKey:@"description"]);
                    feed.recieptDate=NULL_TO_NIL([tDict valueForKey:@"date"]);
                    feed.recieptImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                    feed.recieptReimbursementStatus=NULL_TO_NIL([tDict valueForKey:@"reimbursment"]);
                    
                    
                    
                    [self.arrRouteList addObject:feed];
                    
                }
            }
            else
            {
                recordCount = 0;
                [ConfigManager showAlertMessage:nil Message:@"No feeds were found"];
            }
            
            tblView.delegate=self;
            tblView.dataSource=self;
            
            for (int i=0; i<[self.arrRouteList  count]; i++) {
                
                Feeds *data=[self.arrRouteList objectAtIndex:i];
                
                if ([data.routeType isEqualToString:@"2"]) {
                    
                    self.totalAmount=self.totalAmount+[data.recieptAmount floatValue];
                    
                }
                else
                {
                    self.totalMileage=self.totalMileage+[data.routeDistance floatValue];

                }
            }
            
            NSNumber *totalNumber=[NSNumber numberWithFloat: self.totalAmount]; // The old syntax
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            NSString *strTotal = [formatter stringFromNumber:totalNumber];
            
            [lblTotalAmount setText:[NSString stringWithFormat:@"Total reciept amount: %@",strTotal]];
            
            
            [lblTotalMileage setText:[NSString stringWithFormat:@"Total mileage: %.02f miles",self.totalMileage]];

            [tblView reloadData];
        }
        else
        {
            [self.arrRouteList removeAllObjects];
            [tblView reloadData];
            
            self.totalAmount=0;
            
            [lblTotalAmount setText:[NSString stringWithFormat:@"Total reciept amount: $0.0"]];
            
            
            [lblTotalMileage setText:[NSString stringWithFormat:@"Total mileage: 0.0 miles"]];
        }
    
    }
    else
    {
        [self.arrRouteList removeAllObjects];
        [tblView reloadData];
        
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
-(void)ShareRootListInvocationDidFinish:(ShareRootListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
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
            [popoverController dismissPopoverAnimated:YES];
        }
        else
        {
            [contactView removeFromSuperview];
        }
        [tblView reloadData];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}
#pragma mark- Get Contact List

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

-(IBAction)btnSharePressed:(UIButton*)sender
{
    selectedShareBtn=sender;
    
    if ([self.arrRouteList count]>0) {
        
        [self getContactList];
        
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
        
        [self.popoverController  presentPopoverFromRect:selectedShareBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        tblViewContactList.delegate=self;
        tblViewContactList.dataSource=self;

        [tblViewContactList performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
        
    }
    else
    {
        [self.contactView setFrame:CGRectMake(0,90, self.contactView.frame.size.width, self.contactView.frame.size.height)];
        self.contactView.layer.cornerRadius=5;
        self.contactView.clipsToBounds=YES;
        
        tblViewContactList.layer.cornerRadius=5;
        tblViewContactList.clipsToBounds=YES;
        
        [self.view addSubview:self.contactView];
        
        tblViewContactList.delegate=self;
        tblViewContactList.dataSource=self;
        
        [tblViewContactList performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
        
    }
    
}
-(IBAction)btnContactCrossPressed:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [contactView removeFromSuperview];
    }
}
#pragma mark- UITextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:txtStartDate]){
        
        if (IS_DEVICE_IPAD) {
            
            popoverContentDatePicker.view=nil;
            popoverContentDatePicker=nil;
            [popoverView removeFromSuperview];
            popoverView=nil;
            
            if (popoverContentDatePicker==nil) {
                popoverContentDatePicker = [[UIViewController alloc] init];
                popoverView = [[UIView alloc] init];
            }
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
            
            popoverContentDatePicker.view = popoverView;
            
            popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContentDatePicker];
            popoverController.delegate=self;
            
            txtStartDate.inputView=datePicker;
            
            [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
            [popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
            
            popoverContentDatePicker.view=nil;
            popoverContentDatePicker=nil;
            [popoverView removeFromSuperview];
            popoverView=nil;
            
            if (popoverContentDatePicker==nil) {
                
                popoverContentDatePicker = [[UIViewController alloc] init];
                
                popoverView = [[UIView alloc] init];
            }
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
            
            popoverContentDatePicker.view = popoverView;
            
            popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContentDatePicker];
            popoverController.delegate=self;
            
            txtEndDate.inputView=datePicker;
            
            [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
            [popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self showEndDatePicker];
            
        }
        
    }
    else
    {
        // [self scrollViewToCenterOfScreen:textField];
        
        return TRUE;
    }
    
    return FALSE;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return TRUE;
}
- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    
    CGRect textFieldRect = [theView frame];
    [tblView scrollRectToVisible:textFieldRect animated:YES];
    
    
    CGFloat viewCenterY = theView.frame.origin.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 245;
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [tblView setContentOffset:CGPointMake(0, y) animated:YES];
    
}
-(void)showStartDatePicker
{
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    toolbar = [[UIToolbar alloc]init];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self
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
        
        [toolbar setFrame:CGRectMake(0.0, 155.0+IPHONE_FIVE_FACTOR, 275, 44.0)];
        datePicker.frame=CGRectMake(0,200+IPHONE_FIVE_FACTOR,275, 216);
        [txtEndDate resignFirstResponder];
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 155.0, 275, 44.0)];
        
        datePicker.frame=CGRectMake(0,200,275, 216);
        [txtEndDate resignFirstResponder];
    }
    
}
-(IBAction)cancel
{
    if (IS_DEVICE_IPAD) {
        
        [popoverController dismissPopoverAnimated:YES];
        
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
    
    if(txtEndDate.text.length >0){
        
        NSDate *endDt = [formatter dateFromString:txtEndDate.text];
        
        NSLog(@"tempEndDate is %@",[formatter stringFromDate:endDt]);
        
        NSLog(@"tempStartDate is %@",[formatter stringFromDate:dateSelected]);
        
        if([dateSelected compare:endDt]==NSOrderedDescending){
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Start date can't be greater than end date" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
    }
    
    txtStartDate.text = [formatter stringFromDate:dateSelected];
    
    if (IS_DEVICE_IPAD) {
        [popoverController dismissPopoverAnimated:YES];
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
    
    NSDate *preDate = [formatter dateFromString:txtStartDate.text];
    
    NSLog(@"tempStartDate is %@",[formatter stringFromDate:preDate]);
    
    NSLog(@"tempEndDate is %@",[formatter stringFromDate:dateSelected]);
    
    if ([preDate compare:dateSelected]==NSOrderedDescending) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Start date can't be greater than end date" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    txtEndDate.text = [formatter stringFromDate:dateSelected];
    
    if (IS_DEVICE_IPAD) {
        [popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
        [txtStartDate resignFirstResponder];
        [txtEndDate resignFirstResponder];
    }
}
-(IBAction)btnSearchPressed:(id)sender
{
    pageIndex=1;
    
    self.totalAmount=0;
    self.totalMileage=0;
    
    [self.arrRouteList removeAllObjects];
    
    [self requestForReimBursement];
}
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    [self requestForReimBursement];
  
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
