//
//  RouteFeedDetailViewController.m
//  SipDemo
//
//  Created by Octal on 31/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "RouteFeedDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "NSString+urlDecode.h"
#import "UserLocationVC.h"
#import "PasswordView.h"
#import "DocZoomVC.h"
#import "PasswordViewIphone.h"
#import "CommentValues.h"
#import "QSStrings.h"
#import "AppDelegate.h"
#import "DSActivityView.h"
#import "AlertMessage.h"
#import "Annotation.h"
#import "MapRouteViewController.h"

@interface RouteFeedDetailViewController ()

@end

@implementation RouteFeedDetailViewController

@synthesize lblStartAdd;
@synthesize lblEndAdd;
@synthesize lblWeekDay;
@synthesize lblDate;
@synthesize lblStartTime;
@synthesize lblEndTime;
@synthesize MKStartMapView;
@synthesize MKEndMapView;
@synthesize btnStartMapView;
@synthesize btnEndMapView;
@synthesize btnDelete;
@synthesize btnCheckMark;
@synthesize checkBSAndFamily;
@synthesize feedDetails;
@synthesize locationVC;


#define timefontsize    12.0f
#define descfontsize    13.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgUser.layer.cornerRadius = floor(imgUser.frame.size.width/2);
    imgUser.clipsToBounds = YES;
    
    imgView.layer.cornerRadius = 5;
    imgView.clipsToBounds = YES;
    
    scrollView.layer.cornerRadius = 5;
    scrollView.clipsToBounds = YES;
    
    scrollView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    scrollView.layer.borderWidth= 3.0f;
    
    if (IS_DEVICE_IPAD) {
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    NSLog(@"%@",feedDetails.postTagId);
    
    [self setFeedDetailsValues];

    // Do any additional setup after loading the view from its nib.
}
-(void)setFrame
{
    
    lblDate.font= [UIFont fontWithName:appfontName size:timefontsize];
    [lblUserName setFont:AC_FONT_GOTHIC_BOLD];
    [lblFeedTitle setFont:AC_FONT_GOTHIC_BOLD];
    [lblViewInmap setFont:[UIFont fontWithName:appfontName size:12.0]];
    [lblTags setFont:AC_FONT_GOTHIC_BOLD];
    
    
    [lblTags setFrame:CGRectMake(lblTags.frame.origin.x,lblTags.frame.origin.y,lblTags.frame.size.width, lblTags.frame.size.height)];
    
    int y=CGRectGetMaxY(lblTags.frame)+10;
    
    if ([feedDetails.arrSimiliarTags count]>0) {
        
        
        [tagScroll setFrame:CGRectMake(tagScroll.frame.origin.x, y, tagScroll.frame.size.width, tagScroll.frame.size.height)];
        
        y=CGRectGetMaxY(tagScroll.frame)+10;
    }
    
    NSLog(@"%@",feedDetails.postId);
    
    if (![feedDetails.postId isEqualToString:@"-1"]) {
        
        if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
        {
            [permissionView setFrame:CGRectMake(permissionView.frame.origin.x, y, permissionView.frame.size.width, permissionView.frame.size.height)];
            
            y=CGRectGetMaxY(permissionView.frame)+10;
            
            
            if (![sharedAppDelegate.userObj.userId isEqualToString:feedDetails.postUserId]) {
                
                [btnSadSmile setHidden:FALSE];
                [btnSmile setHidden:FALSE];
                [btnFav setHidden:FALSE];
                
                [btnFav setFrame:CGRectMake(btnFav.frame.origin.x, y, btnFav.frame.size.width, btnFav.frame.size.height)];
                
                [btnSadSmile setFrame:CGRectMake(btnSadSmile.frame.origin.x, y, btnSadSmile.frame.size.width, btnSadSmile.frame.size.height)];
                [btnSmile setFrame:CGRectMake(btnSmile.frame.origin.x, y, btnSmile.frame.size.width, btnSmile.frame.size.height)];
                
                y=CGRectGetMaxY(btnFav.frame)+10;
                
                
                if ([feedDetails.postStatus isEqualToString:@"1"]) {
                    
                    [btnSmile setImage:[UIImage imageNamed:@"smiley_tick"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setEnabled:FALSE];
                    [btnSmile setEnabled:FALSE];
                    
                }
                else if ([feedDetails.postStatus isEqualToString:@"2"]) {
                    
                    [btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley_tick"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setEnabled:FALSE];
                    [btnSmile setEnabled:FALSE];
                    
                }
                else
                {
                    [btnSmile setImage:[UIImage imageNamed:@"smiley"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley"] forState:UIControlStateNormal];
                    
                    [btnSadSmile setEnabled:TRUE];
                    [btnSmile setEnabled:TRUE];
                    
                }
                
            }
            else
            {
                [btnFav setFrame:CGRectMake(btnFav.frame.origin.x+60, y, btnFav.frame.size.width, btnFav.frame.size.height)];
                
                
                [btnSadSmile setHidden:TRUE];
                [btnSmile setHidden:TRUE];
                [btnFav setHidden:TRUE];
                
            }
            
            if ([feedDetails.postFavStatus isEqualToString:@"1"]) {
                
                [btnFav setImage:[UIImage imageNamed:@"star_tick"] forState:UIControlStateNormal];
            }
            else
            {
                [btnFav setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                
            }
            
            
            
            
        }
        else
        {
            [permissionView setHidden:TRUE];
            [btnFav setHidden:TRUE];
            [btnSadSmile setHidden:TRUE];
            [btnSmile setHidden:TRUE];
            
        }
        
    }
    else
    {
        [permissionView setHidden:TRUE];
        
        [btnFav setHidden:TRUE];
        [btnSadSmile setHidden:TRUE];
        [btnSmile setHidden:TRUE];
        
    }
    
    
    
    if (feedDetails.postTagId==nil || feedDetails.postTagId==(NSString*)[NSNull null]) {
        
    }
    else
    {
        if (![feedDetails.postId isEqualToString:@"-1"]) {
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]||[sharedAppDelegate.userObj.role isEqualToString:@"5"] || [sharedAppDelegate.userObj.role isEqualToString:@"6"] || [sharedAppDelegate.userObj.role isEqualToString:@"8"]) {
                
                [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y];
                
                [scrollView addSubview:commentView];
                
                y=CGRectGetMaxY(commentView.frame)+10;
                
            }
            else
            {
                
                if ([sharedAppDelegate.userObj.role isEqualToString:@"6"]|| [sharedAppDelegate.userObj.role isEqualToString:@"8"])
                {
                    if ([self.checkBSAndFamily isEqualToString:@"YES"]) {
                        
                        [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y+5];
                        
                        [scrollView addSubview:commentView];
                        
                        y=CGRectGetMaxY(commentView.frame)+10;
                    }
                    else
                    {
                        if (feedDetails.arrCommentValues==nil) {
                            
                        }
                        else
                        {
                            if ([feedDetails.arrCommentValues count]>0) {
                                
                                [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y+5];
                                
                                [scrollView addSubview:commentView];
                                
                                y=CGRectGetMaxY(commentView.frame)+10;
                            }
                            
                        }
                        
                    }
                }
                else
                {
                    if (feedDetails.arrCommentValues==nil) {
                        
                    }
                    else
                    {
                        if ([feedDetails.arrCommentValues count]>0) {
                            
                            [self addCommentsOnScrollView:feedDetails.arrCommentValues yView:y+5];
                            
                            [scrollView addSubview:commentView];
                            
                            y=CGRectGetMaxY(commentView.frame)+10;
                        }
                        
                    }
                }
            }
        }
    }
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, y+30)];
    
}
-(void)setFeedDetailsValues
{
    NSLog(@"%@",feedDetails.postUserName);
    
    [self setFrame];
    
    lblUserName.text=[feedDetails.postUserName capitalizedString];
    lblDate.text=self.feedDetails.postTime;
    lblFeedTitle.text=[self.feedDetails.postTitle capitalizedString];
    lblDistance.text=[NSString stringWithFormat:@"%@ Miles",[self.feedDetails.routeDistance capitalizedString]];

    [imgUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,self.feedDetails.postUserImgURL]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
        
        [permissionView setHidden: NO];
    else
        [permissionView setHidden:YES];
    
    if ([self.feedDetails.postId isEqualToString:@"-1"])
        [permissionView setHidden: YES];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"]|| [sharedAppDelegate.userObj.role isEqualToString:@"5"])
    {
        UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
        
        if([self.feedDetails.employeeStatusStr integerValue] == 1)
        {
            [radioEmployeeBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([self.feedDetails.managerStatusStr integerValue] == 1)
        {
            [radioManagerBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([self.feedDetails.teamLeaderStatusStr integerValue] == 1)
        {
            [radioTLBtn setImage:img forState:UIControlStateNormal];
        }
        
        if([self.feedDetails.familyStatusStr integerValue] == 1)
        {
            [radioFamilyBtn setImage:img forState:UIControlStateNormal];
        }
        
        
        if([self.feedDetails.bsStatusStr integerValue] == 1)
        {
            [radioBSBtn setImage:img forState:UIControlStateNormal];
        }
        
    }
    
    
    if([self.feedDetails.postType isEqualToString:@"7"]){
        
        self.MKStartMapView.delegate=self;
        self.MKEndMapView.delegate=self;
        
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake([feedDetails.routeStartLatitude floatValue], [feedDetails.routeStartLongitude floatValue]);
        
        Annotation *annotation = [[Annotation alloc] init];
        annotation.title = @"Start Address";
        annotation.coordinate = startCoord;
        [self.MKStartMapView addAnnotation:annotation];
        
        MKCoordinateRegion adjustedRegion;
        adjustedRegion.center = startCoord;
        adjustedRegion.span.latitudeDelta = 0.2;
        adjustedRegion.span.longitudeDelta = 0.2;
        
        [self.MKStartMapView setRegion:adjustedRegion animated:YES];
        
        self.MKStartMapView.showsUserLocation = NO;
        
        
        CLLocationCoordinate2D EndCoord = CLLocationCoordinate2DMake([feedDetails.routeEndLatitude floatValue], [feedDetails.routeEndLongitude floatValue]);
        
        Annotation *endAnnotation = [[Annotation alloc] init];
        endAnnotation.title = @"End Address";
        endAnnotation.coordinate = EndCoord;
        [self.MKEndMapView addAnnotation:endAnnotation];
        
        MKCoordinateRegion adjustedEndRegion;
        adjustedEndRegion.center = EndCoord;
        adjustedEndRegion.span.latitudeDelta = 0.2;
        adjustedEndRegion.span.longitudeDelta = 0.2;
        
        [self.MKEndMapView setRegion:adjustedEndRegion animated:YES];
        
        self.MKEndMapView.showsUserLocation = NO;
        
        self.lblWeekDay.text=[feedDetails.routeWeekDay capitalizedString];
        self.lblStartTime.text=feedDetails.routeStartTime;
        self.lblEndTime.text=feedDetails.routeEndTime;
        self.lblStartAdd.text=feedDetails.routeStartAdd;
        self.lblEndAdd.text=feedDetails.routeEndAdd;

    }
    
    
    
    [self addTagsOnScrollView:self.feedDetails.arrSimiliarTags];
    
    
}
-(void)addTagsOnScrollView:(NSMutableArray*)arrTag
{
    int startX = 0;
    
    for (int i = 0 ; i < [arrTag count]; i++) {
        
        Tags *tag = [arrTag objectAtIndex:i];
        
        UIButton* btnTag = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTag.titleLabel.font = [UIFont fontWithName:appfontName size:12.0f];
        btnTag.titleLabel.textColor = [UIColor whiteColor];
        [btnTag setBackgroundImage:[[UIImage imageNamed:@"tags.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0] forState:UIControlStateNormal];
        
        // int width = [tag.tagTitle sizeWithFont:[UIFont fontWithName:appfontName size:12.0] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:NSLineBreakByTruncatingTail].width+20;
        
        CGRect textRect = [tag.tagTitle boundingRectWithSize:CGSizeMake(200, 30)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:12.0]}
                                                     context:nil];
        
        CGSize size = textRect.size;
        int width=size.width+20;
        
        btnTag.frame = CGRectMake(startX, 5, width, 30);
        
        [btnTag setTitle:tag.tagTitle forState:UIControlStateNormal];
        [btnTag setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [btnTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTag setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [tagScroll addSubview:btnTag];
        
        startX = startX+width+10;
    }
    
    [tagScroll setContentSize:CGSizeMake(startX+10, 0)];
    //NSLog(@"content size =%@",NSStringFromCGSize(self.scrlView.frame.size));
}
-(void)addCommentsOnScrollView:(NSMutableArray*)arrComment yView:(int)yView
{
    int y=0;
    
    NSArray *viewsToRemove = [commentView subviews];
    
    for (UIView *v in viewsToRemove) {
        
        if ([v isKindOfClass:[UILabel class]]) {
            
            [v removeFromSuperview];
            
        }
        
    }
    
    for (int i=0; i<[arrComment count]; i++) {
        
        CommentValues *comment = [arrComment objectAtIndex:i];
        
        NSString *commentStr=[NSString stringWithFormat:@"%@   %@",comment.commentUserName,comment.commentMsg];
        
        UILabel *lblName=[[UILabel alloc] init];
        
        CGSize size;
        
        if (IS_DEVICE_IPAD) {
            
            // size= [commentStr sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(400,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [commentStr boundingRectWithSize:CGSizeMake(400.0f, 130000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                       context:nil];
            
            size = textRect.size;
            
            [lblName setFrame:CGRectMake(6, y, 390, size.height+5)];
            
        }
        else
        {
            //size= [commentStr sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(285,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [commentStr boundingRectWithSize:CGSizeMake(285.0f, 130000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                       context:nil];
            
            size = textRect.size;
            [lblName setFrame:CGRectMake(6, y, 275, size.height+5)];
            
        }
        
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setTextAlignment:NSTextAlignmentLeft];
        [lblName setFont:[UIFont systemFontOfSize:15]];
        lblName.numberOfLines=0;
        //[lblName setText:[NSString stringWithFormat:@"%@",commentStr]];
        [commentView addSubview:lblName];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:commentStr];
        
        NSRange selectedRange = NSMakeRange(0, comment.commentUserName.length); // 4 characters, starting at index 22
        
        [string beginEditing];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont boldSystemFontOfSize:15]
                       range:selectedRange];
        
        [string endEditing];
        
        [lblName setAttributedText:string];
        
        y=y+size.height+15;
        
    }
    
    [txtCommentView setFrame:CGRectMake(txtCommentView.frame.origin.x, y+10, txtCommentView.frame.size.width, txtCommentView.frame.size.height)];
    
    y=CGRectGetMaxY(txtCommentView.frame)+10;
    
    [commentView setFrame:CGRectMake(3, yView, commentView.frame.size.width,y)];
    
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
-(IBAction)btnStartMapViewPressed:(UIButton*)sender
{
    if (IS_DEVICE_IPAD) {
        
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController" bundle:nil];
    }
    else
    {
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController_iphone" bundle:nil];
    }
    self.objMapRouteMapView.tagId=feedDetails.postTagId;
    self.objMapRouteMapView.startLatitude=feedDetails.routeStartLatitude;
    self.objMapRouteMapView.startLongitude=feedDetails.routeStartLongitude;
    self.objMapRouteMapView.endLatitude=feedDetails.routeEndLatitude;
    self.objMapRouteMapView.endLongitude=feedDetails.routeEndLongitude;
    self.objMapRouteMapView.startTime=feedDetails.routeStartTime;
    self.objMapRouteMapView.endTime=feedDetails.routeEndTime;
    self.objMapRouteMapView.checkMapView=@"start";
    
    self.objMapRouteMapView.checkRouteView=@"";
    
    [self.view addSubview:self.objMapRouteMapView.view];
}
-(IBAction)btnEndMapViewPressed:(UIButton*)sender
{
    
    if (IS_DEVICE_IPAD) {
        
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController" bundle:nil];
    }
    else
    {
        self.objMapRouteMapView=[[MapRouteViewController alloc] initWithNibName:@"MapRouteViewController_iphone" bundle:nil];
    }
    self.objMapRouteMapView.tagId=feedDetails.postTagId;
    self.objMapRouteMapView.startLatitude=feedDetails.routeStartLatitude;
    self.objMapRouteMapView.startLongitude=feedDetails.routeStartLongitude;
    self.objMapRouteMapView.endLatitude=feedDetails.routeEndLatitude;
    self.objMapRouteMapView.endLongitude=feedDetails.routeEndLongitude;
    self.objMapRouteMapView.startTime=feedDetails.routeStartTime;
    self.objMapRouteMapView.endTime=feedDetails.routeEndTime;
    self.objMapRouteMapView.checkMapView=@"end";
    
    self.objMapRouteMapView.checkRouteView=@"";
    
    [self.view addSubview:self.objMapRouteMapView.view];
}
#pragma mark - IBAction Methods
-(IBAction)btnCrossAction:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
        
    }
    else
    {
        [self.view removeFromSuperview];
        
    }
}
-(IBAction)btnCloseAction:(id)sender
{
    
}
-(IBAction)btnMapLocationAction:(id)sender
{
    //  if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
    
    if (self.feedDetails.latitude<=0 && self.feedDetails.longitude<=0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Location not available"];
    }
    else
    {
        
        
        if (IS_DEVICE_IPAD) {
            
            self.locationVC = [[UserLocationVC alloc] initWithNibName:@"UserLocationVC" bundle:nil];
        }
        else
        {
            self.locationVC = [[UserLocationVC alloc] initWithNibName:@"UserLocationVC_iphone" bundle:nil];
        }
        self.locationVC.feed = self.feedDetails;
        self.locationVC.checkLocationView=@"map";
        
        [self.view addSubview:self.locationVC.view];
        
    }
    
}
- (IBAction)employeeBtnPressed:(id)sender
{
    
    NSString *statusStr;
    
    NSLog(@"%@",feedDetails.employeeStatusStr);
    
    if ([feedDetails.employeeStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        // [radioEmployeeBtn setSelected:true];
        [radioEmployeeBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        //[radioEmployeeBtn setSelected:NO];
        
        [radioEmployeeBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
        
    }
    
    feedDetails.employeeStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
    // [dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:statusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
    
}
- (IBAction)managerBtnPressed:(id)sender
{
    NSString *statusStr;
    
    UIImage *img = [UIImage imageNamed:@"popup_checked.png"];
    
    if (radioManagerBtn.currentImage == img)
    {
        statusStr = @"0";
        [radioManagerBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
    }
    else
    {
        statusStr = @"1";
        
        [radioManagerBtn setImage:img forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:statusStr forKey:@"manager"];
    
    if(radioEmployeeBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"employee"];
    else
        [dic setObject:@"0" forKey:@"employee"];
    
    if(radioTLBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"teamleader"];
    else
        [dic setObject:@"0" forKey:@"teamleader"];
    
    if(radioFamilyBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"family"];
    else
        [dic setObject:@"0" forKey:@"family"];
    
    /* if(radioTrainingBtn.currentImage == img)
     [dic setObject:@"1" forKey:@"training"];
     else
     [dic setObject:@"0" forKey:@"training"];*/
    
    if(radioBSBtn.currentImage == img)
        [dic setObject:@"1" forKey:@"BS"];
    else
        [dic setObject:@"0" forKey:@"BS"];
    
    
    [dic setObject:feedDetails.postId forKey:@"post_id"];
    [dic setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dic delegate:self];
    
}
- (IBAction)teamLeaderBtnPressed:(id)sender
{
    
    NSString *statusStr;
    
    
    if ([feedDetails.teamLeaderStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioTLBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        [radioTLBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
    }
    feedDetails.teamLeaderStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:statusStr forKey:@"teamleader"];
    [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
    // [dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
}
/*- (IBAction)trainingBtnPressed:(id)sender
 {
 
 NSString *statusStr;
 
 if ([feedDetails.trainingStatusStr isEqualToString:@"0"]) {
 
 statusStr=@"1";
 [radioTrainingBtn setSelected:YES];
 
 }
 else
 {
 statusStr=@"0";
 [radioTrainingBtn setSelected:NO];
 
 }
 feedDetails.trainingStatusStr=statusStr;
 
 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
 [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
 [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
 [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
 [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
 [dict setObject:statusStr forKey:@"training"];
 [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
 [dict setObject:feedDetails.postId forKey:@"post_id"];
 [dict setObject:feedDetails.postUserId forKey:@"user_id"];
 
 [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
 
 [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
 
 
 }*/
- (IBAction)familyBtnPressed:(id)sender
{
    
    NSString *statusStr;
    
    
    if ([feedDetails.familyStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioFamilyBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        [radioFamilyBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
    }
    feedDetails.familyStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:feedDetails.bsStatusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:statusStr forKey:@"family"];
    // [dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
    
    
}
- (IBAction)bSBtnPressed:(id)sender
{
    
    NSString *statusStr;
    
    
    if ([feedDetails.bsStatusStr isEqualToString:@"0"]) {
        
        statusStr=@"1";
        [radioBSBtn setImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        statusStr=@"0";
        [radioBSBtn setImage:[UIImage imageNamed:@"popup_unchecked.png"] forState:UIControlStateNormal];
        
    }
    feedDetails.bsStatusStr=statusStr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:statusStr forKey:@"BS"];
    [dict setObject:feedDetails.managerStatusStr forKey:@"manager"];
    [dict setObject:feedDetails.teamLeaderStatusStr forKey:@"teamleader"];
    [dict setObject:feedDetails.familyStatusStr forKey:@"family"];
    // [dict setObject:feedDetails.trainingStatusStr forKey:@"training"];
    [dict setObject:feedDetails.employeeStatusStr forKey:@"employee"];
    [dict setObject:feedDetails.postId forKey:@"post_id"];
    [dict setObject:feedDetails.postUserId forKey:@"user_id"];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
    
    [[AmityCareServices sharedService] setFeedInocation:dict delegate:self];
}
-(IBAction)favButtonAction:(id)sender
{
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddFavoriteInvocation:sharedAppDelegate.userObj.userId tagId:feedDetails.postTagId feedId:feedDetails.postId delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}
-(IBAction)smileButtonAction:(id)sender
{
    
    if([ConfigManager isInternetAvailable]){
        
        checkSmile=TRUE;
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddSmileInvocation:feedDetails.postUserId tagId:feedDetails.postTagId feedId:feedDetails.postId status:@"0" delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(IBAction)sadSmileButtonAction:(id)sender
{
    if([ConfigManager isInternetAvailable]){
        
        checkSmile=FALSE;
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Notification list..." width:180];
        [[AmityCareServices sharedService] AddSmileInvocation:feedDetails.postUserId tagId:feedDetails.postTagId feedId:feedDetails.postId status:@"1" delegate:self];
    }
    else{
        
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
#pragma mark - Status Invocation Delegates

- (void)statusInvocationDidFinish:(StatusInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    
    NSLog(@"%@",dict);
    
    if(!error)
    {
        NSString* strSuccess = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            
        }
        else
        {
            [DSBezelActivityView removeView];
            
        }
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

#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 245;
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollViewToCenterOfScreen:commentView];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([str length] > 0){
        
        [self requestSendChatText:str];
    }
    
    return TRUE;
    
}

- (void)requestSendChatText:(NSString*)message{
    
    if([ConfigManager isInternetAvailable]){
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        NSLog(@"%@",feedDetails.postId);
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:feedDetails.postId forKey:@"post_id"];
        [dic setObject:feedDetails.postTagId forKey:@"tag_id"];
        
        if (![message isEqualToString:@""]) {
            
            [dic setValue:[QSStrings encodeBase64WithString:message] forKey:@"comment"];
            
        }
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"updating..." width:200];
        
        [[AmityCareServices sharedService] AddCommentInvocation:dic delegate:self];
        
    }
    else{
        [txtCommentView setText:nil];
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}
-(void)AddCommentInvocationDidFinish:(AddCommentInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    [DSBezelActivityView removeView];
    
    if(!error)
    {
        NSString* strSuccess = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"success"]);
        NSString* strCommentId = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"commentId"]);
        NSString* strCommentDate = NULL_TO_NIL([[dict valueForKey:@"response"] objectForKey:@"time"]);
        
        NSLog(@"%@",strSuccess);
        
        if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
            
            [ConfigManager showAlertMessage:nil Message:@"Comment has not submitted"];
            
        }
        else
        {
            CommentValues *t = [[CommentValues alloc] init];
            
            t.commentId=[NSString stringWithFormat:@"%@",strCommentId];
            t.commentUserId = sharedAppDelegate.userObj.userId;
            t.commentUserName = [NSString stringWithFormat:@"%@ %@",sharedAppDelegate.userObj.fname,sharedAppDelegate.userObj.lname];
            t.commentUserImage = @"";
            t.commentDate = [NSString stringWithFormat:@"%@",strCommentDate];
            t.commentMsg = txtCommentView.text;
            
            [feedDetails.arrCommentValues addObject:t];
            
            [self setFeedDetailsValues];
            
            [DSBezelActivityView removeView];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
    txtCommentView.text=@"";
    
}
#pragma mark- Add Favorite Invocation

-(void)AddFavoriteInvocationDidFinish:(AddFavoriteInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            
            feedDetails.postFavStatus=@"1";
            [btnFav setImage:[UIImage imageNamed:@"star_tick"] forState:UIControlStateNormal];
            
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
        }
        
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
}


#pragma mark- Add Smile Invocation

-(void)AddSmileInvocationDidFinish:(AddSmileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSString* strSuccess = NULL_TO_NIL([dict objectForKey:@"success"]);
        
        NSLog(@"%@",strSuccess);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            if (checkSmile==TRUE) {
                
                feedDetails.postStatus=@"1";
                
                [btnSmile setImage:[UIImage imageNamed:@"smiley_tick"] forState:UIControlStateNormal];
                
            }
            else
            {
                feedDetails.postStatus=@"2";
                
                [btnSadSmile setImage:[UIImage imageNamed:@"sad_smiley_tick"] forState:UIControlStateNormal];
                
            }
            
            
            [btnSadSmile setEnabled:FALSE];
            [btnSmile setEnabled:FALSE];
            
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:[dict objectForKey:@"message"]];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
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
