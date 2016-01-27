//
//  ReimbursementsViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 17/02/15.
//
//

#import "ReimbursementsViewController.h"
#import "MapRouteViewController.h"
#import "RouteData.h"
#import "UIImageView+WebCache.h"
#import "ConfigManager.h"
#import "Annotation.h"
#import "TagCell.h"
#import "Tags.h"
#import "ContactD.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "RouteCommentViewController.h"
#import "QSStrings.h"
#import "UploadReceiptViewController.h"
#import "RecieptTableViewCell.h"

@interface ReimbursementsViewController ()

@end

@implementation ReimbursementsViewController
@synthesize tagId;
@synthesize startLatitude;
@synthesize startLongitude;
@synthesize endLatitude;
@synthesize endLongitude;
@synthesize distance,arrRouteList,startTime,endTime,selectedIndxpath,checkClockin,arrTagsList,shareTagId,arrCheckMarkList,arrContactList,objMapRouteMapView,popoverController,popoverContent,popoverContactContent,popoverView,contactView,tagView,objRootCommentViewController,objUploadReceiptViewController,totalAmount,popoverContentDatePicker,totalMileage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblTotalAmount setText:@"Total amount of reciept: 0.00"];
    [lblTotalMileage setText:@"Total mileage: 0.0 miles"];

    [imgMapView setHidden:TRUE];
    
    [btnReciept.layer setCornerRadius:5];
    btnReciept.clipsToBounds=YES;
    
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
    
    txtEndDate.text=@"";
    txtStartDate.text=@"";
    txtTag.text=@"";
    txtUser.text=@"";
    
    self.arrRouteList=[[NSMutableArray alloc] init];
    self.arrTagsList=[[NSMutableArray alloc] init];
    self.arrCheckMarkList=[[NSMutableArray alloc] init];
    self.arrContactList=[[NSMutableArray alloc] init];
    
    mapView.layer.cornerRadius=5;
    mapView.clipsToBounds=YES;
    
    imgMapView.layer.cornerRadius=5;
    imgMapView.clipsToBounds=YES;
    
    sharedAppDelegate.routeImage=nil;
    sharedAppDelegate.mapRouteData=nil;
    sharedAppDelegate.dicRouteDetail=nil;
    
    /* if (![sharedAppDelegate.userObj.role isEqualToString:@"3"]) {
     
     [txtTag setHidden:TRUE];
     [txtUser setHidden:TRUE];
     [imgTxtTagName setHidden:TRUE];
     [imgTxtUserName setHidden:TRUE];
     [btnSearch setFrame:CGRectMake(btnSearch.frame.origin.x, txtEndDate.frame.origin.y, btnSearch.frame.size.width, btnSearch.frame.size.height)];
     
     [lblTotalAmount setFrame:CGRectMake(lblTotalAmount.frame.origin.x, lblTotalAmount.frame.origin.y-40, lblTotalAmount.frame.size.width, lblTotalAmount.frame.size.height)];
     
     [tblView setFrame:CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y-40, tblView.frame.size.width, tblView.frame.size.height+40)];
     
     
     }*/
    
    
    [self requestForReimBursement];
    // Do any additional setup after loading the view from its nib.
}
-(void)RecieptDidUpdate
{
    [self.arrRouteList removeAllObjects];
    [self requestForReimBursement];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MapViewController delegate Mehtods--------

-(void)RootDidUpdate:(NSString*)rootDistance mapImage:(UIImage*)mapImage
{
    
    [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
    
    [[AmityCareServices sharedService] ReimembursementListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId startDate:txtStartDate.text endDate:txtEndDate.text userName:txtUser.text tagName:txtTag.text delegate:self];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
- (void)showTagView
{
    
    if (IS_DEVICE_IPAD) {
        
        if (self.popoverContent==nil) {
            
            self.popoverContent = [[UIViewController alloc]init];
            self.popoverContent.view = self.tagView;
            self.popoverContent.preferredContentSize = CGSizeMake(320, 414);
            
        }
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
        
        self.popoverController.popoverContentSize= CGSizeMake(320, 414);
        
        [self.popoverController  presentPopoverFromRect:btnStop.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        [tblViewTagList reloadData];
        
    }
    else
    {
        [self.tagView setFrame:CGRectMake(0,90, self.tagView.frame.size.width, self.tagView.frame.size.height)];
        self.tagView.layer.cornerRadius=5;
        self.tagView.clipsToBounds=YES;
        
        tblViewTagList.layer.cornerRadius=5;
        tblViewTagList.clipsToBounds=YES;
        
        [self.view addSubview:self.tagView];
        [tblViewTagList reloadData];
        
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
        [self.contactView setFrame:CGRectMake(0,90, self.tagView.frame.size.width, self.tagView.frame.size.height)];
        self.contactView.layer.cornerRadius=5;
        self.contactView.clipsToBounds=YES;
        
        tblViewContactList.layer.cornerRadius=5;
        tblViewContactList.clipsToBounds=YES;
        
        [self.view addSubview:self.contactView];
        [tblViewContactList reloadData];
        
    }
    
}
-(IBAction)btnTagCrossPressed:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [self.popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [tagView removeFromSuperview];
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
#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView) {
        
        return [self.arrRouteList count];
        
    }
    else if(tableView==tblViewTagList)
    {
        return [self.arrTagsList count];
        
    }
    else
    {
        return [self.arrContactList count];
    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView) {
        
        RouteData *data=[self.arrRouteList objectAtIndex:indexPath.row];
        
        if ([data.routType isEqualToString:@"2"]) {
            
            if (IS_DEVICE_IPAD) {
                
                if ([data.arrCommentList count]>0) {
                    
                    CGRect textRect= [data.recieptDescription boundingRectWithSize:CGSizeMake(362,130000)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                           context:nil];
                    
                    CGSize size = textRect.size;
                    
                    int height=size.height+440;
                    
                    return height;
                    
                }
                else
                {
                    CGRect textRect= [data.recieptDescription boundingRectWithSize:CGSizeMake(362,130000)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                           context:nil];
                    
                    CGSize size = textRect.size;
                    
                    int height=size.height+430;
                    
                    return height;
                    
                }
            }
            else
            {
                if ([data.arrCommentList count]>0) {
                    
                    CGRect textRect= [data.recieptDescription boundingRectWithSize:CGSizeMake(249,130000)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                           context:nil];
                    
                    CGSize size = textRect.size;
                    
                    int height=size.height+440;
                    
                    return height;
                    
                }
                else
                {
                    CGRect textRect= [data.recieptDescription boundingRectWithSize:CGSizeMake(249,130000)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                           context:nil];
                    
                    CGSize size = textRect.size;
                    
                    int height=size.height+430;
                    
                    return height;
                }
                
            }
            
        }
        else
        {
            if (IS_DEVICE_IPAD) {
                
                if ([data.arrCommentList count]>0) {
                    
                    return 413;
                    
                }
                else
                {
                    return 390;
                    
                }
            }
            else
            {
                if ([data.arrCommentList count]>0) {
                    
                    return 403;
                    
                }
                else
                {
                    return 380;
                }
                
            }
            
        }
        
    }
    else
    {
        return 44;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* routeCellIdentifier = @"RouteListCell";
    static NSString* recieptCellIdentifier = @"RecieptListCell";
    
    static NSString* tagCellIdentifier = @"TagListCell";
    static NSString* contactCellIdentifier = @"ContactListCell";
    
    if (tableView==tblView) {
        
        RouteData *data=[self.arrRouteList objectAtIndex:indexPath.row];
        
        if ([data.routType isEqualToString:@"1"]) {
            
            rootCell = (ReimbursementTableViewCell*)[tblView dequeueReusableCellWithIdentifier:routeCellIdentifier];
            
            if (Nil == rootCell)
            {
                rootCell = [ReimbursementTableViewCell createTextRowWithOwner:self withDelegate:self];
                rootCell.MKStartMapView.delegate=self;
                rootCell.MKEndMapView.delegate=self;
                
                CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake([data.routeStartLatitude floatValue], [data.routeStartLongitude floatValue]);
                
                Annotation *annotation = [[Annotation alloc] init];
                annotation.title = @"Start Address";
                annotation.coordinate = startCoord;
                [rootCell.MKStartMapView addAnnotation:annotation];
                
                MKCoordinateRegion adjustedRegion;
                adjustedRegion.center = startCoord;
                adjustedRegion.span.latitudeDelta = 0.2;
                adjustedRegion.span.longitudeDelta = 0.2;
                
                [rootCell.MKStartMapView setRegion:adjustedRegion animated:YES];
                
                rootCell.MKStartMapView.showsUserLocation = NO;
                
                
                CLLocationCoordinate2D EndCoord = CLLocationCoordinate2DMake([data.routeEndLatitude floatValue], [data.routeEndLongitude floatValue]);
                
                Annotation *endAnnotation = [[Annotation alloc] init];
                endAnnotation.title = @"End Address";
                endAnnotation.coordinate = EndCoord;
                [rootCell.MKEndMapView addAnnotation:endAnnotation];
                
                MKCoordinateRegion adjustedEndRegion;
                adjustedEndRegion.center = EndCoord;
                adjustedEndRegion.span.latitudeDelta = 0.2;
                adjustedEndRegion.span.longitudeDelta = 0.2;
                
                [rootCell.MKEndMapView setRegion:adjustedEndRegion animated:YES];
                
                rootCell.MKEndMapView.showsUserLocation = NO;
                
                
            }
            
            
            rootCell.lblDistance.text=data.routeDistance;
            
            rootCell.lblWeekDay.text=[data.routeWeekDay capitalizedString];
            rootCell.lblStartTime.text=data.routeStartTime;
            rootCell.lblEndTime.text=data.routeEndTime;
            rootCell.lblTagName.text=[NSString stringWithFormat:@"%@",data.rootTagName];

            if ([data.routeShareByUser isEqualToString:@""]) {
                
                
                [rootCell.lblShare setText:@"Posted by:"];
                
                [rootCell.lblShareValue setText:[data.routePostedByUser capitalizedString]];
                
            }
            else
            {
                [rootCell.lblShare setText:@"Share by:"];
              
                rootCell.lblShareValue.text=data.routeShareByUser;
                
            }
            
            NSString *dateStr=[data.routeCreated substringToIndex:2];
            
            rootCell.lblDate.text=dateStr;
            
            if ([data.routeEndAdd isEqualToString:@"(null)"]) {
                
                data.routeEndAdd=@"";
            }
            if ([data.routeStartAdd isEqualToString:@"(null)"]) {
                
                data.routeStartAdd=@"";
            }
            rootCell.lblStartAdd.text=[NSString stringWithFormat:@"Start Add: %@",data.routeStartAdd];
            rootCell.lblEndAdd.text=[NSString stringWithFormat:@"End Add: %@",data.routeEndAdd];;
            
            if ([data.arrCommentList count]>0) {
                
                [rootCell.btnMore setHidden:FALSE];
                [rootCell.lblComment setHidden:FALSE];
                
                [rootCell.commentView setFrame:CGRectMake(rootCell.commentView.frame.origin.x,rootCell.commentView.frame.origin.y, rootCell.commentView.frame.size.width, 73)];
                [rootCell.txtCommentView setFrame:CGRectMake(rootCell.txtCommentView.frame.origin.x, 36, rootCell.txtCommentView.frame.size.width, rootCell.txtCommentView.frame.size.height)];
                
                NSString *username=[[data.arrCommentList objectAtIndex:0] objectForKey:@"commentByUserName"];
                
                NSString *msgStr=[[data.arrCommentList objectAtIndex:0] objectForKey:@"comment"];
                
                msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                
                NSString *commentStr=[[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                
                // NSString *commentStr=[[data.arrCommentList objectAtIndex:0] objectForKey:@"comment"];
                
                
                [rootCell.lblComment setText:[NSString stringWithFormat:@"%@: %@",username,commentStr]];
                
                
                
            }
            else
            {
                [rootCell.btnMore setHidden:TRUE];
                [rootCell.lblComment setHidden:TRUE];
                
                [rootCell.commentView setFrame:CGRectMake(rootCell.commentView.frame.origin.x,rootCell.commentView.frame.origin.y, rootCell.commentView.frame.size.width, 50)];
                [rootCell.txtCommentView setFrame:CGRectMake(rootCell.txtCommentView.frame.origin.x, 10, rootCell.txtCommentView.frame.size.width, rootCell.txtCommentView.frame.size.height)];
            }
            [rootCell.txtCommentView setTag:indexPath.row];
            [rootCell.btnMore setTag:indexPath.row];
            rootCell.txtCommentView.delegate=self;
            
            [rootCell.btnStartMapView setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            
            [rootCell.btnStartMapView addTarget:self action:@selector(btnStartMapViewPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [rootCell.btnEndMapView setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            
            [rootCell.btnEndMapView addTarget:self action:@selector(btnEndMapViewPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [rootCell.btnDelete setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            
            [rootCell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [rootCell.btnCheckMark setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            //[rootCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [rootCell setBackgroundColor:[UIColor clearColor]];
            
            
            return rootCell;
        }
        else
        {
            recieptCell = (RecieptTableViewCell*)[tblView dequeueReusableCellWithIdentifier:recieptCellIdentifier];
            
            if (Nil == recieptCell)
            {
                recieptCell = [RecieptTableViewCell createTextRowWithOwner:self withDelegate:self];
                
            }
            recieptCell.delegate=self;
            
            recieptCell.lblWeekDay.text=[data.routeWeekDay capitalizedString];
            if ([data.routeShareByUser isEqualToString:@""]) {
                
                [recieptCell.lblShare setText:@"Posted by:"];
                
                [recieptCell.lblShareValue setText:[data.routePostedByUser capitalizedString]];
                
            }
            else
            {
                [recieptCell.lblShare setText:@"Share by:"];

                recieptCell.lblShareValue.text=data.routeShareByUser;
                
            }
            
            NSString *dateStr=[data.routeCreated substringToIndex:2];
            
            recieptCell.lblDate.text=dateStr;
            [recieptCell.txtDescription setText:data.recieptDescription];
            recieptCell.lblTagName.text=[NSString stringWithFormat:@"%@",data.rootTagName];

            [recieptCell.lblMerchant setText:[NSString stringWithFormat:@"Merchant Name: %@",data.recieptMerchantName]];
            
            NSNumber *totalNumber=[NSNumber numberWithFloat:[data.recieptAmount floatValue]]; // The old syntax
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            NSString *strTotal = [formatter stringFromNumber:totalNumber];
            
            [recieptCell.lblAmount setText:[NSString stringWithFormat:@"Total reciept amount: %@",strTotal]];
            
            [recieptCell.lblRecieptDate setText:@""];
            
            
            if (![data.recieptDate isEqualToString:@""]) {
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *tdate = [df dateFromString:data.recieptDate];
                
                recieptCell.lblRecieptDate.text=[self shortStyleDate:tdate];
                
            }
            
            
            
            if ([data.recieptReimbursementStatus isEqualToString:@"1"]) {
                
                recieptCell.lblReimbursement.text=@"Reimbursement: Yes";
            }
            else if ([data.recieptReimbursementStatus isEqualToString:@"0"]) {
                
                recieptCell.lblReimbursement.text=@"Reimbursement: No";
            }
            else
            {
                recieptCell.lblReimbursement.text=@"";
                
            }
            
            [recieptCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",recieptImageURL,data.recieptImage]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
            
            NSLog(@"%@",data.recieptDescription);
            
            CGRect textRect= [data.recieptDescription boundingRectWithSize:CGSizeMake(recieptCell.txtDescription.frame.size.width,130000)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:recieptCell.txtDescription.font}
                                                                   context:nil];
            
            CGSize size = textRect.size;
            
            int height=size.height+5;
            
            [recieptCell.txtDescription setFrame:CGRectMake(recieptCell.txtDescription.frame.origin.x, recieptCell.txtDescription.frame.origin.y, recieptCell.txtDescription.frame.size.width,height)];
            
            [recieptCell.backView setFrame:CGRectMake(recieptCell.backView.frame.origin.x, recieptCell.backView.frame.origin.y, recieptCell.backView.frame.size.width,height+358)];
            
            [recieptCell.commentView setFrame:CGRectMake(recieptCell.commentView.frame.origin.x, CGRectGetMaxY(recieptCell.backView.frame), recieptCell.commentView.frame.size.width,recieptCell.commentView.frame.size.height)];
            
            if ([data.arrCommentList count]>0) {
                
                [recieptCell.btnMore setHidden:FALSE];
                [recieptCell.lblComment setHidden:FALSE];
                
                [recieptCell.commentView setFrame:CGRectMake(recieptCell.commentView.frame.origin.x,recieptCell.commentView.frame.origin.y, recieptCell.commentView.frame.size.width, 73)];
                [recieptCell.txtCommentView setFrame:CGRectMake(recieptCell.txtCommentView.frame.origin.x, 36, recieptCell.txtCommentView.frame.size.width, recieptCell.txtCommentView.frame.size.height)];
                
                NSString *username=[[data.arrCommentList objectAtIndex:0] objectForKey:@"commentByUserName"];
                
                NSString *msgStr=[[data.arrCommentList objectAtIndex:0] objectForKey:@"comment"];
                
                msgStr=[msgStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                
                NSString *commentStr=[[NSString alloc] initWithData:[QSStrings decodeBase64WithString:msgStr] encoding:NSUTF8StringEncoding];
                
                // NSString *commentStr=[[data.arrCommentList objectAtIndex:0] objectForKey:@"comment"];
                
                
                [recieptCell.lblComment setText:[NSString stringWithFormat:@"%@: %@",username,commentStr]];
                
                
                
            }
            else
            {
                [recieptCell.btnMore setHidden:TRUE];
                [recieptCell.lblComment setHidden:TRUE];
                
                [recieptCell.commentView setFrame:CGRectMake(recieptCell.commentView.frame.origin.x,recieptCell.commentView.frame.origin.y, recieptCell.commentView.frame.size.width, 50)];
                [recieptCell.txtCommentView setFrame:CGRectMake(recieptCell.txtCommentView.frame.origin.x, 10, recieptCell.txtCommentView.frame.size.width, recieptCell.txtCommentView.frame.size.height)];
            }
            
            [recieptCell.txtCommentView setTag:indexPath.row];
            [recieptCell.btnMore setTag:indexPath.row];
            recieptCell.txtCommentView.delegate=self;
            
            [recieptCell.btnDelete setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            
            [recieptCell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [recieptCell.btnCheckMark setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateReserved];
            
            [recieptCell setBackgroundColor:[UIColor clearColor]];
            
            return recieptCell;
            
            
        }
        
    }
    else if(tableView==tblViewTagList)
    {
        TagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellIdentifier];
        
        if(!cell){
            cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tagCellIdentifier];
        }
        cell.tagData = [self.arrTagsList objectAtIndex:indexPath.row];
        
        return cell;
        
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
        
        [distanceTimer invalidate];
        distanceTimer=nil;
        
        RouteData *data=[self.arrRouteList objectAtIndex:indexPath.row];
        
        
        if (IS_DEVICE_IPAD) {
            
            self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController" bundle:nil];
        }
        else
        {
            self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController_iphone" bundle:nil];
        }
        self.objMapRouteMapView.tagId=self.tagId;
        self.objMapRouteMapView.startLatitude=data.routeStartLatitude;
        self.objMapRouteMapView.startLongitude=data.routeStartLongitude;
        self.objMapRouteMapView.endLatitude=data.routeEndLatitude;
        self.objMapRouteMapView.endLongitude=data.routeEndLongitude;
        self.objMapRouteMapView.startTime=data.routeStartTime;
        self.objMapRouteMapView.endTime=data.routeEndTime;
        
        self.objMapRouteMapView.checkRouteView=@"";
        
        self.objMapRouteMapView.delegate=self;
        
        [self.view addSubview:self.objMapRouteMapView.view];
    }
    else if(tableView==tblViewTagList)
    {
        if (IS_DEVICE_IPAD) {
            
            [self.popoverController dismissPopoverAnimated:YES];
            
        }
        else
        {
            [self.tagView removeFromSuperview];
        }
        
        NSString *strIndex=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        [self performSelector:@selector(sendData:) withObject:strIndex afterDelay:0.1];
        
    }
    else
    {
        NSString* joinedString=@"";
        
        if ([self.arrCheckMarkList count]>0) {
            
            NSMutableArray *array=[[NSMutableArray alloc] init];
            
            for (int i=0; i<[self.arrCheckMarkList count]; i++) {
                
                UIButton *btn=[self.arrCheckMarkList objectAtIndex:i];
                
                RouteData *data=[self.arrRouteList objectAtIndex:[[btn titleForState:UIControlStateReserved]intValue]];
                
                [array addObject:data.routeId];
            }
            
            joinedString = [array componentsJoinedByString:@","];
            
            if([ConfigManager isInternetAvailable]){
                
                ContactD *cData=[self.arrContactList objectAtIndex:indexPath.row];
                
                [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                [dic setObject:cData.userid forKey:@"member_id"];
                
                [dic setObject:joinedString forKey:@"rootTagId"];
                
                [[AmityCareServices sharedService] ShareRootListInvocation:dic delegate:self];
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
    
}
-(NSString*)shortStyleDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString* shortDate = [df stringFromDate:date];
    return shortDate;
}
-(void)sendData:(NSString*)index
{
    Tags *objTag=[self.arrTagsList objectAtIndex:[index intValue]];
    
    self.shareTagId=objTag.tagId;
    
    self.endLatitude=[NSString stringWithFormat:@"%f",latitude];
    self.endLongitude=[NSString stringWithFormat:@"%f",longitude];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm a"];
    self.endTime = [dateformate stringFromDate:date];
    
    [distanceTimer invalidate];
    distanceTimer=nil;
    
    NSLog(@"%@",self.startTime);
    NSLog(@"%@",self.endTime);
    
    
    
    if (IS_DEVICE_IPAD) {
        
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController" bundle:nil];
    }
    else
    {
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController_iphone" bundle:nil];
    }
    if ([self.checkClockin isEqualToString:@"0"]) {
        
        self.objMapRouteMapView.tagId=self.shareTagId;
        
    }
    else
    {
        self.objMapRouteMapView.tagId=self.tagId;
        
    }
    self.objMapRouteMapView.startLatitude=self.startLatitude;
    self.objMapRouteMapView.startLongitude=self.startLongitude;
    self.objMapRouteMapView.endLatitude=self.endLatitude;
    self.objMapRouteMapView.endLongitude=self.endLongitude;
    self.objMapRouteMapView.startTime=self.startTime;
    self.objMapRouteMapView.endTime=self.endTime;
    
    self.objMapRouteMapView.checkRouteView=@"Post";
    
    self.objMapRouteMapView.delegate=self;
    
    [self.view addSubview:self.objMapRouteMapView.view];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annView = (MKAnnotationView *)[mView
                                                     dequeueReusableAnnotationViewWithIdentifier: @"pin"];
    
    
    if (annView == nil)
    {
        annView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"pin"] ;
        
        annView.frame = CGRectMake(0, 0, 50, 50);
        
        UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([annotation.title isEqualToString:@"Start Address"]) {
            
            [pinButton setImage:[UIImage imageNamed:@"start_annotation.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            [pinButton setImage:[UIImage imageNamed:@"end_annotation.png"] forState:UIControlStateNormal];
            
        }
        pinButton.frame = CGRectMake(0, 0, 32, 32);
        
        [annView addSubview:pinButton];
    }
    
    annView.annotation = annotation;
    
    return annView;
}
-(void) buttonMoreClick:(ReimbursementTableViewCell*)cellValue
{
    long index=cellValue.btnMore.tag;
    
    RouteData *data=[self.arrRouteList objectAtIndex:index];
    
    NSString *routeIdStr=data.routePostId;
    
    if (IS_DEVICE_IPAD) {
        
        self.objRootCommentViewController=[[RouteCommentViewController alloc] initWithNibName:@"RouteCommentViewController" bundle:nil];
        
    }
    else
    {
        self.objRootCommentViewController=[[RouteCommentViewController alloc] initWithNibName:@"RouteCommentViewController_iphone" bundle:nil];
        
    }
    objRootCommentViewController.rootId=routeIdStr;
    
    [self.view addSubview:objRootCommentViewController.view];
    
}
#pragma mark IBAction Methods Mehtods--------

-(IBAction)btnStartPressed:(id)sender
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Reimbursements started" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    sharedAppDelegate.routeImage=nil;
    sharedAppDelegate.mapRouteData=nil;
    sharedAppDelegate.dicRouteDetail=nil;
    [imgMapView setHidden:TRUE];
    
    [distanceTimer invalidate];
    distanceTimer=nil;
    
    self.startLatitude=[NSString stringWithFormat:@"%f",latitude];
    self.startLongitude=[NSString stringWithFormat:@"%f",longitude];
    
    self.endLatitude=[NSString stringWithFormat:@"%f",latitude];
    self.endLongitude=[NSString stringWithFormat:@"%f",longitude];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm a"];
    self.startTime = [dateformate stringFromDate:date]; // Convert date
    
    NSLog(@"%@",self.startTime);
    
    distanceTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                     target:self
                                                   selector:@selector(updateDistance)
                                                   userInfo:nil
                                                    repeats:YES];
    [distanceTimer fire];
    
    
    
}
-(void)updateDistance
{
    NSLog(@"updateDistance");
    [sharedAppDelegate startUpdatingLocation];
    
    self.endLatitude=[NSString stringWithFormat:@"%f",latitude];
    self.endLongitude=[NSString stringWithFormat:@"%f",longitude];
    
    NSLog(@"self.endLatitude %@",self.endLatitude);
    NSLog(@"endLongitude %@",self.endLongitude);
    
    
    /* lbl1.text=[NSString stringWithFormat:@"%@",self.startLatitude];
     lbl2.text=[NSString stringWithFormat:@"%@",self.startLongitude];
     lbl3.text=[NSString stringWithFormat:@"%@",self.endLatitude];
     lbl4.text=[NSString stringWithFormat:@"%@",self.endLongitude];
     
     NSString *str=[NSString stringWithFormat:@"latitude %@ longitude %@",self.endLatitude,self.endLongitude];
     
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];*/
    
    // if (latitude>0 && longitude>0) {
    
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:[self.startLatitude floatValue] longitude:[self.startLongitude floatValue]];
    
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[self.endLatitude floatValue] longitude:[self.endLongitude floatValue]];
    
    CLLocationDistance totDistance = [startLocation distanceFromLocation:endLocation];
    
    NSLog(@"%g",totDistance);
    
    NSString *distanceInMiles=[NSString stringWithFormat:@"%.1fmi",(totDistance/1609.344)];
    
    lblDistance.text=[NSString stringWithFormat:@"%.02f mi", [distanceInMiles floatValue]];
    
    //lblDistance.text = [NSString stringWithFormat:@"%g", totDistance];
    
    //}
    
}
-(IBAction)btnStopPressed:(id)sender
{
    if (self.startLatitude==nil || self.startLatitude==(NSString*)[NSNull null] || self.startLongitude==nil || self.startLongitude==(NSString*)[NSNull null] ) {
        
    }
    else
    {
        
        //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Reimbursements stopped" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        
        if ([self.checkClockin isEqualToString:@"0"]) {
            
            [self.arrTagsList removeAllObjects];
            
            [self performSelectorOnMainThread:@selector(reqeustForTagList) withObject:nil waitUntilDone:YES];
        }
        else
        {
            
            [self performSelector:@selector(sendStopData) withObject:nil afterDelay:0.1];
            
        }
        
        
    }
    
}
-(void)sendStopData
{
    
    self.endLatitude=[NSString stringWithFormat:@"%f",latitude];
    self.endLongitude=[NSString stringWithFormat:@"%f",longitude];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm a"];
    self.endTime = [dateformate stringFromDate:date];
    
    [distanceTimer invalidate];
    distanceTimer=nil;
    
    NSLog(@"%@",self.startTime);
    NSLog(@"%@",self.endTime);
    
    
    if (IS_DEVICE_IPAD) {
        
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController" bundle:nil];
    }
    else
    {
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController_iphone" bundle:nil];
    }
    if ([self.checkClockin isEqualToString:@"0"]) {
        
        self.objMapRouteMapView.tagId=self.shareTagId;
        
    }
    else
    {
        self.objMapRouteMapView.tagId=self.tagId;
        
    }
    self.objMapRouteMapView.startLatitude=self.startLatitude;
    self.objMapRouteMapView.startLongitude=self.startLongitude;
    self.objMapRouteMapView.endLatitude=self.endLatitude;
    self.objMapRouteMapView.endLongitude=self.endLongitude;
    self.objMapRouteMapView.startTime=self.startTime;
    self.objMapRouteMapView.endTime=self.endTime;
    
    self.objMapRouteMapView.checkRouteView=@"Post";
    
    self.objMapRouteMapView.delegate=self;
    
    [self.view addSubview:self.objMapRouteMapView.view];
}
-(IBAction)btnSharePressed:(id)sender
{
    
    if ([self.arrCheckMarkList count]>0) {
        
        [self getContactList];
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Please select route"];
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
-(IBAction)btnSearchPressed:(id)sender
{
    if([ConfigManager isInternetAvailable]){
        
        self.totalAmount=0.00;
        self.totalMileage=0.00;
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching result please wait..." width:200];
        
        [[AmityCareServices sharedService] ReimembursementListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId startDate:txtStartDate.text endDate:txtEndDate.text userName:txtUser.text tagName:txtTag.text delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)btnStartMapViewPressed:(UIButton*)sender
{
    [distanceTimer invalidate];
    distanceTimer=nil;
    
    RouteData *data=[self.arrRouteList objectAtIndex:[[sender titleForState:UIControlStateReserved] intValue]];
    
    if (IS_DEVICE_IPAD) {
        
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController" bundle:nil];
    }
    else
    {
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController_iphone" bundle:nil];
    }
    self.objMapRouteMapView.tagId=self.tagId;
    self.objMapRouteMapView.startLatitude=data.routeStartLatitude;
    self.objMapRouteMapView.startLongitude=data.routeStartLongitude;
    self.objMapRouteMapView.endLatitude=data.routeEndLatitude;
    self.objMapRouteMapView.endLongitude=data.routeEndLongitude;
    self.objMapRouteMapView.startTime=data.routeStartTime;
    self.objMapRouteMapView.endTime=data.routeEndTime;
    self.objMapRouteMapView.checkMapView=@"start";
    
    self.objMapRouteMapView.checkRouteView=@"";
    
    self.objMapRouteMapView.delegate=self;
    
    [self.view addSubview:self.objMapRouteMapView.view];
}
-(IBAction)btnEndMapViewPressed:(UIButton*)sender
{
    [distanceTimer invalidate];
    distanceTimer=nil;
    
    RouteData *data=[self.arrRouteList objectAtIndex:[[sender titleForState:UIControlStateReserved] intValue]];
    
    
    if (IS_DEVICE_IPAD) {
        
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController" bundle:nil];
    }
    else
    {
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController_iphone" bundle:nil];
    }
    self.objMapRouteMapView.tagId=self.tagId;
    self.objMapRouteMapView.startLatitude=data.routeStartLatitude;
    self.objMapRouteMapView.startLongitude=data.routeStartLongitude;
    self.objMapRouteMapView.endLatitude=data.routeEndLatitude;
    self.objMapRouteMapView.endLongitude=data.routeEndLongitude;
    self.objMapRouteMapView.startTime=data.routeStartTime;
    self.objMapRouteMapView.endTime=data.routeEndTime;
    self.objMapRouteMapView.checkMapView=@"end";
    
    self.objMapRouteMapView.checkRouteView=@"";
    
    self.objMapRouteMapView.delegate=self;
    
    [self.view addSubview:self.objMapRouteMapView.view];
}
-(IBAction)btnDeletePressed:(UIButton*)sender
{
    
    self.selectedIndxpath=[[sender titleForState:UIControlStateReserved] intValue];
    
    ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Root ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
    [deleteAlert show];
}
-(IBAction)btnCheckMarkPressed:(UIButton*)sender
{
    if (sender.isSelected==NO) {
        
        [sender setSelected:YES];
        [arrCheckMarkList addObject:sender];
        
    }
    else
    {
        [sender setSelected:NO];
        [arrCheckMarkList removeObject:sender];
    }
}
-(void) buttonCheckMarkClick:(ReimbursementTableViewCell*)cellValue
{
    // NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    if (cellValue.btnCheckMark.isSelected==NO) {
        
        [cellValue.btnCheckMark setSelected:YES];
        [arrCheckMarkList addObject:cellValue.btnCheckMark];
        
    }
    else
    {
        [cellValue.btnCheckMark setSelected:NO];
        [arrCheckMarkList removeObject:cellValue.btnCheckMark];
    }
    
    
}
-(IBAction)btnReceiptPressed:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        self.objUploadReceiptViewController=[[UploadReceiptViewController alloc] initWithNibName:@"UploadReceiptViewController" bundle:nil];
        
    }
    else
    {    self.objUploadReceiptViewController=[[UploadReceiptViewController alloc] initWithNibName:@"UploadReceiptViewController_iphone" bundle:nil];
        
        
    }
    self.objUploadReceiptViewController.delegate=self;
    
    [self.view addSubview:self.objUploadReceiptViewController.view];
}
-(void)requestForReimBursement
{
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching result please wait..." width:200];
        
        [[AmityCareServices sharedService] ReimembursementListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId startDate:txtStartDate.text endDate:txtEndDate.text userName:txtUser.text tagName:txtTag.text delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)reqeustForTagList
{
    [self.arrTagsList removeAllObjects];
    
    if([ConfigManager isInternetAvailable]){
        
        [self fetchAssignedTags];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(void)fetchAssignedTags
{
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
        [[AmityCareServices sharedService] tagInvocation:sharedAppDelegate.userObj.userId delegate:self];
        
    }
    
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        
    }
}
-(void) buttonRecieptCheckMarkClick:(RecieptTableViewCell*)cellValue
{
    if (cellValue.btnCheckMark.isSelected==NO) {
        
        [cellValue.btnCheckMark setSelected:YES];
        [arrCheckMarkList addObject:cellValue.btnCheckMark];
        
    }
    else
    {
        [cellValue.btnCheckMark setSelected:NO];
        [arrCheckMarkList removeObject:cellValue.btnCheckMark];
    }
    
}
-(void) buttonRecieptMoreClick:(RecieptTableViewCell*)cellValue
{
    long index=cellValue.btnMore.tag;
    
    RouteData *data=[self.arrRouteList objectAtIndex:index];
    
    NSString *routeIdStr=data.routePostId;
    
    if (IS_DEVICE_IPAD) {
        
        self.objRootCommentViewController=[[RouteCommentViewController alloc] initWithNibName:@"RouteCommentViewController" bundle:nil];
        
    }
    else
    {
        self.objRootCommentViewController=[[RouteCommentViewController alloc] initWithNibName:@"RouteCommentViewController_iphone" bundle:nil];
        
    }
    objRootCommentViewController.rootId=routeIdStr;
    
    [self.view addSubview:objRootCommentViewController.view];
    
}
-(void)ReimembursementListInvocationDidFinish:(ReimembursementListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    NSLog(@"error %@",error);
    
    self.totalAmount=0.00;
    self.totalMileage=0.00;

    [self.arrRouteList removeAllObjects];
    
    @try {
        if(!error)
        {
            
            NSDictionary* dic = [dict valueForKey:@"response"];
            
            NSArray *routeArray= [dic valueForKey:@"rootPath"];
            
            if ([routeArray count]>0) {
                
                for (int i=0; i < [routeArray count]; i++) {
                    
                    NSDictionary *tDict = [routeArray objectAtIndex:i];
                    
                    RouteData *root=[[RouteData alloc] init];
                    
                    root.routeId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                    root.routeCreated=NULL_TO_NIL([tDict valueForKey:@"created"]);
                    root.routeStartLatitude=NULL_TO_NIL([tDict valueForKey:@"start_latitude"]);
                    root.routeStartLongitude=NULL_TO_NIL([tDict valueForKey:@"start_longitude"]);
                    root.routeEndLatitude=NULL_TO_NIL([tDict valueForKey:@"end_latitude"]);
                    root.routeEndLongitude=NULL_TO_NIL([tDict valueForKey:@"end_longitude"]);
                    root.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);
                    root.routeImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                    root.routeStartAdd=NULL_TO_NIL([tDict valueForKey:@"start_address"]);
                    root.routeEndAdd=NULL_TO_NIL([tDict valueForKey:@"end_address"]);
                    root.routeStartTime=NULL_TO_NIL([tDict valueForKey:@"start_time"]);
                    root.routeEndTime=NULL_TO_NIL([tDict valueForKey:@"end_time"]);
                    root.routeWeekDay=NULL_TO_NIL([tDict valueForKey:@"day"]);
                    root.routeShareByUser=NULL_TO_NIL([tDict valueForKey:@"senderName"]);
                    root.routePostedByUser=NULL_TO_NIL([tDict valueForKey:@"postedBy"]);

                    root.routePostId=NULL_TO_NIL([tDict valueForKey:@"postId"]);
                    root.rootTagId=NULL_TO_NIL([tDict valueForKey:@"rootTagId"]);
                    root.routType=NULL_TO_NIL([tDict valueForKey:@"type"]);
                    root.routeDistance=NULL_TO_NIL([tDict valueForKey:@"distance"]);
                    root.rootTagName=NULL_TO_NIL([tDict valueForKey:@"tag_name"]);

                    root.recieptDate=NULL_TO_NIL([tDict valueForKey:@"date"]);
                    root.recieptAmount=[NSString stringWithFormat:@"%@",NULL_TO_NIL([tDict valueForKey:@"amount"])];
                    
                    
                    root.recieptDescription=NULL_TO_NIL([tDict valueForKey:@"description"]);
                    root.recieptImage=NULL_TO_NIL([tDict valueForKey:@"image"]);
                    root.recieptMerchantName=NULL_TO_NIL([tDict valueForKey:@"merchant_name"]);
                    root.recieptReimbursementStatus=NULL_TO_NIL([tDict valueForKey:@"reimbursment"]);
                    
                    NSLog(@"%@",[tDict valueForKey:@"Comment"]);
                    //
                    root.arrCommentList=[[NSMutableArray alloc] init];
                    
                    NSArray *commentArray = NULL_TO_NIL([tDict valueForKey:@"Comment"]);
                    
                    NSLog(@"%@",commentArray);
                    NSLog(@"%ld",(unsigned long)[commentArray count]);
                    
                    [root.arrCommentList addObjectsFromArray:commentArray];
                    
                    // NSArray *array=[[NSArray alloc] initWithObjects:@"Test", nil];
                    // root.arrCommentList=[[NSMutableArray alloc] initWithArray:array];
                    
                    if (root.routeShareByUser==nil || root.routeShareByUser==(NSString*)[NSNull null]) {
                        
                        root.routeShareByUser=@"";
                    }
                    
                    if ([root.routType isEqualToString:@"2"]) {
                        
                        self.totalAmount=self.totalAmount+[root.recieptAmount floatValue];
                        
                    }
                    else
                    {
                        self.totalMileage=self.totalMileage+[root.routeDistance floatValue];

                    }
                    
                    [self.arrRouteList addObject:root];
                    
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
        
        NSNumber *totalNumber=[NSNumber numberWithFloat: self.totalAmount]; // The old syntax
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *strTotal = [formatter stringFromNumber:totalNumber];
        
        [lblTotalAmount setText:[NSString stringWithFormat:@"Total reciept amount: %@",strTotal]];
        [lblTotalMileage setText:[NSString stringWithFormat:@"Total mileage: %.02f miles",self.totalMileage]];

        [DSBezelActivityView removeView];
    }
    
}
-(void)ShareReimbursementInvocationDidFinish:(ShareReimbursementInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"ShareReimbursementInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            NSString* strmessage = NULL_TO_NIL([response valueForKey:@"message"]);
            
            lblDistance.text=@"0";
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                sharedAppDelegate.routeImage=nil;
                sharedAppDelegate.mapRouteData=nil;
                sharedAppDelegate.dicRouteDetail=nil;
                
                [ConfigManager showAlertMessage:nil Message:strmessage];
                
                [[AmityCareServices sharedService] ReimembursementListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId startDate:txtStartDate.text endDate:txtEndDate.text userName:txtUser.text tagName:txtTag.text delegate:self];
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:strmessage];
                
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
-(void)DeleteRootInvocationDidFinish:(DeleteRootInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"DeleteRootInvocation = %@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        
        if([strSuccess rangeOfString:@"true"].length>0){
            
            RouteData *data=[self.arrRouteList objectAtIndex:self.selectedIndxpath];
            
            if ([data.routType isEqualToString:@"2"]) {
                
                self.totalAmount=self.totalAmount-[data.recieptAmount floatValue];
                
                NSNumber *totalNumber=[NSNumber numberWithFloat: self.totalAmount]; // The old syntax
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                NSString *strTotal = [formatter stringFromNumber:totalNumber];
                
                [lblTotalAmount setText:[NSString stringWithFormat:@"Total reciept amount: %@",strTotal]];
                
                
            }
            else
            {
                self.totalMileage=self.totalMileage-[data.routeDistance floatValue];

                [lblTotalMileage setText:[NSString stringWithFormat:@"Total mileage: %.02f miles",self.totalMileage]];

            }
            
            [self.arrRouteList removeObjectAtIndex:self.selectedIndxpath];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Route not deleted"];
        }
        [tblView reloadData];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    
    [DSBezelActivityView removeView];
    
}
-(void)AddRouteCommentInvocationDidFinish:(AddRouteCommentInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"AddRouteCommentInvocationDidFinish = %@",dict);
    
    if (!error) {
        
        id response = [dict valueForKey:@"response"];
        NSString* strSuccess = [response valueForKey:@"success"];
        
        if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
            
            [ConfigManager showAlertMessage:nil Message:strSuccess];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:strSuccess];
            
            [self requestForReimBursement];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    
    
    [DSBezelActivityView removeView];
    
}
-(void)AddCommentInvocationDidFinish:(AddCommentInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    [DSBezelActivityView removeView];
    
    NSLog(@"%@",dict);
    
    if(!error)
    {
        NSString* strSuccess = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
            
            [ConfigManager showAlertMessage:nil Message:strSuccess];
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:strSuccess];
            
            [self requestForReimBursement];
            
        }
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
#pragma mark- Get Tag list Invocation

-(void)tagsInvocationDidFinish:(TagsInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        if(!error)
        {
            NSLog(@"Tags = %@",dict);
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                [self.arrTagsList removeAllObjects];
                NSString *strSuccess = [response valueForKey:@"success"];
                if([strSuccess rangeOfString:@"true"].length>0)
                {
                    NSArray *tags = NULL_TO_NIL([response valueForKey:@"Tag"]);
                    
                    for (int i = 0; i < [tags count]; i++) {
                        
                        NSDictionary *tDict = [tags objectAtIndex:i];
                        
                        Tags *tag = [[Tags alloc] init];
                        
                        tag.tagId = NULL_TO_NIL([tDict valueForKey:@"id"]);
                        tag.tagTitle = NULL_TO_NIL([tDict valueForKey:@"title"]);
                        
                        [self.arrTagsList addObject:tag];
                    }
                }
                else if([strSuccess rangeOfString:@"False"].length>0)
                {
                    [ConfigManager showAlertMessage:nil Message:@"You have not assigned any Tag"];
                }
                
                if ([self.arrTagsList count]>0) {
                    
                    [self showTagView];
                }
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
        [DSBezelActivityView removeView] ;
        
        sharedAppDelegate.unreadTagCount = 0;
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
#pragma mark- UIALERTVIEW

-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            if([ConfigManager isInternetAvailable]){
                
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
                
                RouteData *data=[self.arrRouteList objectAtIndex:self.selectedIndxpath];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                //[dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                
                [dic setObject:data.routeId forKey:@"root_id"];
                
                [[AmityCareServices sharedService] DeleteRootInvocation:dic delegate:self];
            }
            else{
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
        }
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
    
    if (textField==txtEndDate || textField==txtStartDate || textField==txtTag || textField==txtUser) {
        
    }
    else
    {
        if (textField.text.length>0) {
            
            long index=textField.tag;
            
            RouteData *data=[self.arrRouteList objectAtIndex:index];
            
            NSString *routeIdStr=data.routePostId;
            
            NSLog(@"%@",routeIdStr);
            
            /* if([ConfigManager isInternetAvailable]) {
             
             [DSBezelActivityView newActivityViewForView:self.view withLabel:@"Fetching Assigned Tags..." width:200];
             
             NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
             
             [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
             [dict setObject:self.tagId forKey:@"tag_id"];
             
             [dict setObject:routeIdStr forKey:@"root_id"];
             [dict setObject:textField.text forKey:@"comment"];
             
             [[AmityCareServices sharedService] AddRouteCommentInvocation:dict delegate:self];
             
             textField.text=@"";
             
             }
             
             else{
             
             [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
             
             }*/
            
            if([ConfigManager isInternetAvailable]){
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                
                [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
                [dic setObject:data.routePostId forKey:@"post_id"];
                [dic setObject:data.rootTagId forKey:@"tag_id"];
                
                if (![textField.text isEqualToString:@""]) {
                    
                    [dic setValue:[QSStrings encodeBase64WithString:textField.text] forKey:@"comment"];
                    
                }
                
                textField.text=@"";
                [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
                
                [[AmityCareServices sharedService] AddCommentInvocation:dic delegate:self];
                
            }
            else{
                [textField setText:nil];
                [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
            }
            
            
        }
        
        
    }
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
