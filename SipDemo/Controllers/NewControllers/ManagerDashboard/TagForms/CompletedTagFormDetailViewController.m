//
//  CompletedTagFormDetailViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 23/03/15.
//
//

#import "CompletedTagFormDetailViewController.h"
#import "ConfigManager.h"
#import "UIImageView+WebCache.h"
#import "CompletedFormData.h"
#import "QSStrings.h"
#import "FormDetailTableViewCell.h"
#import "FormDetailTableViewCell.h"
#import "Feeds.h"
#import "Form.h"
#import "FormValues.h"
#import "FormsField.h"
#import "CommentValues.h"
#import "FormFeedDetailViewController.h"

@interface CompletedTagFormDetailViewController ()

@end

@implementation CompletedTagFormDetailViewController

@synthesize tagId,arrUserFormList,startDate,endDate,objFeedDetailViewController,objFormFeedDetailViewController,objStatusFeedDetailViewController,popoverController,popoverContent,popoverView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndex=1;
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    
    self.arrUserFormList=[[NSMutableArray alloc] init];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissView) name: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    
    
    [self requestForGetTagForm];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
-(void)requestForGetTagForm
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Form list..." width:180];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:self.tagId forKey:@"tag_id"];
        [dic setObject:[NSString stringWithFormat:@"%lu",pageIndex] forKey:@"index"];
        [dic setObject:txtStartDate.text forKey:@"start_date"];
        [dic setObject:txtEndDate.text forKey:@"end_date"];
        
        [[AmityCareServices sharedService] TagCompletedFormDetailInvocation:dic delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(void)dissmissView
{
    [self.popoverController dismissPopoverAnimated:YES];
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)btnSearchPressed:(id)sender;
{
    if (txtStartDate.text.length>0 && txtEndDate.text.length>0) {
        
        pageIndex=1;
        
        [self.arrUserFormList removeAllObjects];
        
        [self requestForGetTagForm];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Please select start date and end date"];
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
    
    if ([self.arrUserFormList count]>0) {
        
        if(recordCount > [self.arrUserFormList count])
            
            numberOfRows = [self.arrUserFormList count]+1;
        else
            
            numberOfRows = [self.arrUserFormList count];
        
    }
    return numberOfRows;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.arrUserFormList count])
    {
        if (IS_DEVICE_IPAD) {
            
            return 100;
            
        }
        else
        {
            return 120;
            
        }
    }
    else
    {
        return 60;
        
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* formCellIdentifier = @"FormListCell";
    static NSString* defaultCellIdentifier = @"loadMoreCellIdentifier";
    
    if(indexPath.row < [self.arrUserFormList count])
    {
        detailCell = [tblView dequeueReusableCellWithIdentifier:formCellIdentifier];
        
        if(!detailCell)
        {
            NSArray* arr;
            
            if (IS_DEVICE_IPAD) {
                
                arr = [[NSBundle mainBundle] loadNibNamed:@"FormDetailTableViewCell" owner:self options:nil];
            }
            else
            {
                arr = [[NSBundle mainBundle] loadNibNamed:@"FormDetailTableViewCell_iphone" owner:self options:nil];
            }
            
            detailCell = [arr objectAtIndex:0];
        }
        
        [detailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        Feeds *pData = [self.arrUserFormList objectAtIndex:indexPath.row];
        
        [detailCell setForm:pData];
        
        return detailCell;
        
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
        
        if (recordCount>[self.arrUserFormList count]) {
            
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
    UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    
    Feeds *feed=[self.arrUserFormList objectAtIndex:indexPath.row];
    
    
    if (IS_DEVICE_IPAD) {
        
        [self dissmissView];
        
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
-(void)loadMoreRecords
{
    pageIndex=pageIndex+1;
    
    [self requestForGetTagForm];
}
#pragma mark- UITextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:txtStartDate]){
        
        if (IS_DEVICE_IPAD) {
            
            self.popoverContent.view=nil;
            self.popoverContent=nil;
            [self.popoverView removeFromSuperview];
            self.popoverView=nil;
            
            if (self.popoverContent==nil) {
                
                self.popoverContent = [[UIViewController alloc] init];
                
                self.popoverView = [[UIView alloc] init];
                
                
            }
            
            
            self.popoverView.backgroundColor = [UIColor clearColor];
            
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
            [self.popoverView addSubview:toolbar];
            [self.popoverView addSubview:datePicker];
            
            self.popoverContent.view = self.popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
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
            
            
            self.popoverContent.view=nil;
            self.popoverContent=nil;
            [self.popoverView removeFromSuperview];
            self.popoverView=nil;
            
            if (self.popoverContent==nil) {
                
                self.popoverContent = [[UIViewController alloc] init];
                
                self.popoverView = [[UIView alloc] init];
                
                
            }
            
            self.popoverView.backgroundColor = [UIColor clearColor];
            
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
            [self.popoverView addSubview:toolbar];
            [self.popoverView addSubview:datePicker];
            
            self.popoverContent.view = self.popoverView;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
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

-(void)TagCompletedFormDetailInvocationDidFinish:(TagCompletedFormDetailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"appContactsInvoationDidFinish %@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            recordCount = [NULL_TO_NIL([response valueForKey:@"total_records"]) intValue];
            
            if (recordCount>0) {
                
                [lblTotalForm setHidden:FALSE];
                
                [lblTotalForm setText:[NSString stringWithFormat:@"Total Form: %lu",recordCount]];
            }
            else
            {
                [lblTotalForm setHidden:TRUE];

            }
            
            if([strSuccess rangeOfString:@"true"].length>0){
                
                
                /* NSArray* array = [response valueForKey:@"form"];
                 
                 for (int i=0; i< [array count]; i++) {
                 
                 NSDictionary* cDict = [array objectAtIndex:i];
                 
                 CompletedFormData *pData = [[CompletedFormData alloc] init];
                 
                 pData.formId = NULL_TO_NIL([cDict valueForKey:@"id"]);
                 pData.formTagId=NULL_TO_NIL([cDict valueForKey:@"tag_id"]);
                 pData.formUserId = NULL_TO_NIL([cDict valueForKey:@"user_id"]);
                 pData.formTitle = NULL_TO_NIL([cDict valueForKey:@"title"]);
                 pData.formUserName = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"user_name"])];
                 pData.formTag = NULL_TO_NIL([cDict valueForKey:@"tag_title"]);
                 pData.formCompletionTime = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"completion_time"])];
                 pData.formBadges = NULL_TO_NIL([cDict valueForKey:@"badges"]);
                 
                 pData.formType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([cDict valueForKey:@"form_type"])];
                 pData.formUserImage = NULL_TO_NIL([cDict valueForKey:@"user_image"]);
                 
                 [self.arrUserFormList addObject:pData];
                 }*/
                
                NSArray* post = [response valueForKey:@"form"];
                
                if([post count]>0)
                {
                    
                    for (int i=0; i < [post count]; i++) {
                        
                        Feeds *feed = [[Feeds alloc] init];
                        
                        NSDictionary *fDict = [post objectAtIndex:i];
                        
                        feed.postUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.postUserName = NULL_TO_NIL([fDict valueForKey:@"user_name"]);
                        feed.postUserImgURL = NULL_TO_NIL([fDict valueForKey:@"user_image"]);
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
                        feed.bsStatusStr         = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"BS"])];
                        
                        
                        feed.formId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                        feed.formTagId=NULL_TO_NIL([fDict valueForKey:@"tag_id"]);
                        feed.formUserId = NULL_TO_NIL([fDict valueForKey:@"user_id"]);
                        feed.formTitle = NULL_TO_NIL([fDict valueForKey:@"title"]);
                        feed.formUserName = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"user_name"])];
                        feed.formTag = NULL_TO_NIL([fDict valueForKey:@"tag_title"]);
                        feed.formCompletionTime = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"completion_time"])];
                        feed.formBadges = NULL_TO_NIL([fDict valueForKey:@"badges"]);
                        
                        feed.formType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"form_type"])];
                        feed.formUserImage = NULL_TO_NIL([fDict valueForKey:@"user_image"]);
                        
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
                        
                        
                        
                        [self.arrUserFormList addObject:feed];
                        
                    }
                }
                else
                {
                    [self.arrUserFormList removeAllObjects];
                    recordCount = 0;
                    [ConfigManager showAlertMessage:nil Message:@"No feeds were found"];
                }
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0){
                
            }
            [tblView reloadData];
            
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
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        [DSBezelActivityView removeView];
        [tblView setContentOffset:CGPointMake(0, 0)];
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
