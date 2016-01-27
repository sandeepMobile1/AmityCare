//
//  ProfileDetailVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 10/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "ProfileDetailVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "MFSideMenu.h"
#import "TaskCalenderViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "GetProfileInvocation.h"

@interface ProfileDetailVC ()<GetProfileInvocationDelegate>

@end

@implementation ProfileDetailVC
@synthesize userPhotoClicked;
@synthesize userid,objTaskCalenderViewController,isAvailable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        
        if (sharedAppDelegate.isPortrait) {
            
            if (self.checkLocationProfile==TRUE) {

            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                
            }
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 450, 929)];

            }
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        
       // [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    
    else
    {
        if (self.checkLocationProfile==TRUE) {
          
            if (!IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
                
                
            }
        }
        else
        {
            if (!IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320, 568-IPHONE_FIVE_FACTOR)];
                
                
            }
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320, 568)];

            }
        }
        
    }
    
   
    
    
    //[self.view addSubview:navigation];
    
    [self layoutProfileSubviews];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //   [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    self.navigationController.navigationBarHidden = YES;
    
    
    [self performSelector:@selector(requestForProfileDetails) withObject:nil afterDelay:0.1f];
    
    //[self setUserDetails:nil];
    
}

- (IBAction)calederBtnPressed:(id)sender
{
    /* CalenderViewController *objCalenderViewController;
     
     if (IS_DEVICE_IPAD) {
     
     objCalenderViewController=[[CalenderViewController alloc] initWithNibName:@"CalenderViewController" bundle:nil];
     }
     else
     {
     objCalenderViewController=[[CalenderViewController alloc] initWithNibName:@"CalenderViewController_iphone" bundle:nil];
     }
     
     objCalenderViewController.tagId=@"";
     [self.navigationController pushViewController:objCalenderViewController animated:YES];*/
    
    
    if (IS_DEVICE_IPAD) {
        
        self.objTaskCalenderViewController=[[TaskCalenderViewController alloc] initWithNibName:@"TaskCalenderViewController" bundle:nil];
    }
    else
    {
        self.objTaskCalenderViewController=[[TaskCalenderViewController alloc] initWithNibName:@"TaskCalenderViewController" bundle:nil];
    }
    
    self.objTaskCalenderViewController.tagId=@"";
    
    [self.view addSubview:self.objTaskCalenderViewController.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark------------
#pragma mark- Others Methods
-(void)requestForProfileDetails
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching profile details..." width:200];
    [[AmityCareServices sharedService] GetProfileInvocation:self.userid delegate:self];
}

-(void)layoutProfileSubviews
{
    for (id tempView in [self.view subviews]) {
        if([tempView isKindOfClass:[UIScrollView class]])
        {
            for ( id innerView in [tempView subviews]) {
                if([innerView isKindOfClass:[UITextField class]]){
                    [self addPaddingOnTextFields:(UITextField*)innerView];
                }
            }
        }
    }
    
    if (IS_DEVICE_IPAD) {
        
        imgProfilePic.layer.cornerRadius = 67.0f;
        imgProfilePic.layer.borderWidth=1.0f;
        
    }
    else
    {
        imgProfilePic.layer.cornerRadius = 50.0f;
        imgProfilePic.layer.borderWidth=1.0f;
        
    }
    imgProfilePic.layer.borderColor = [[UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:0.5f] CGColor];
    
    imgProfilePic.clipsToBounds = YES;
    
    tfFirstName.font = [UIFont fontWithName:appfontName size:15.0f];
    tfLastName.font = [UIFont fontWithName:appfontName size:15.0f];
    tfEmail.font = [UIFont fontWithName:appfontName size:15.0f];
    tfPhoneNo.font = [UIFont fontWithName:appfontName size:15.0f];
    tfAddress.font = [UIFont fontWithName:appfontName size:15.0f];
    lblAboutMe.font = [UIFont fontWithName:appfontName size:15.0f];
    
    lblFname.font = [UIFont fontWithName:appfontName size:15.0f];
    lblLname.font = [UIFont fontWithName:appfontName size:15.0f];
    lblEmail.font = [UIFont fontWithName:appfontName size:15.0f];
    lblPhone.font = [UIFont fontWithName:appfontName size:15.0f];
    lblAddr.font = [UIFont fontWithName:appfontName size:15.0f];
    lblAbt.font = [UIFont fontWithName:appfontName size:15.0f];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
            
            if (IS_IPHONE_5) {
                
                [scrollView setFrame:CGRectMake(0, 54, 320, 530)];
            }
            else
            {
                
                [scrollView setFrame:CGRectMake(0, 54, 320, 530-IPHONE_FIVE_FACTOR)];
                
            }
        }
        else
        {
            if (IS_IPHONE_5) {
                
                [scrollView setFrame:CGRectMake(0, 54, 320, 530)];
            }
            else
            {
                [scrollView setFrame:CGRectMake(0, 54, 320, 530-IPHONE_FIVE_FACTOR)];
                
            }
        }
        
        
    }
    
}
/*- (void)viewDidLayoutSubviews
 {
 if (!IS_DEVICE_IPAD) {
 
 if (IS_IPHONE_5) {
 
 [self.view setFrame:CGRectMake(0, 0, 320, 568)];
 [scrollView setFrame:CGRectMake(0, 54, 320, 510)];
 [scrollView setContentSize:CGSizeMake(100,650)];
 
 }
 else
 {
 [self.view setFrame:CGRectMake(0, 0, 320, 480)];
 [scrollView setFrame:CGRectMake(0, 64, 320, 400)];
 [scrollView setContentSize:CGSizeMake(100,550)];
 
 }
 }
 }*/
-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setUserDetails:(User*)user
{
    
    @try {
        tfFirstName.text = user.fname;
        tfLastName.text = user.lname;
        tfEmail.text = user.email;
        tfPhoneNo.text = user.phoneNo;
        tfAddress.text = user.address;
        tfDefaultEmail.text=user.default_email;
        tfUserId.text=self.userid;
        
        if (self.isAvailable==YES) {
            
            [imgAvailableStatus setImage:[UIImage imageNamed:@"online.png"]];
        }
        else
        {
            [imgAvailableStatus setImage:[UIImage imageNamed:@"offline.png"]];

        }
        
        NSString *strDesc = [user.aboutMe stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        lblAboutMe.text =strDesc;
        
        [imgProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,user.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [imgProfilePic.layer addAnimation:transition forKey:nil];
        
        CGRect textRect = [strDesc boundingRectWithSize:CGSizeMake(lblAboutMe.frame.size.width, 1500)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:appfontName size:15.0]}
                                                       context:nil];
        
        CGSize size = textRect.size;

        int height=size.height;
        
      //  int height = ceil([strDesc sizeWithFont:[UIFont fontWithName:appfontName size:15.0] constrainedToSize:CGSizeMake(lblAboutMe.frame.size.width, 1500) lineBreakMode:NSLineBreakByWordWrapping].height);
        int factor = (height/15.0)/2;
        CGRect frame = lblAboutMe.frame;
        lblAboutMe.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height+factor);
        lblAboutMe.numberOfLines = 0;
        lblAboutMe.text =strDesc;//[user.aboutMe stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        
        if (IS_DEVICE_IPAD) {
            
            [scrollView setContentSize:CGSizeMake(400, CGRectGetMaxY(lblAboutMe.frame)+factor)];
            
        }
        else
        {
            NSLog(@"%f",CGRectGetMaxY(lblAboutMe.frame)+factor);
            
            
            [scrollView setContentSize:CGSizeMake(320, CGRectGetMaxY(lblAboutMe.frame)+factor+120)];
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark- InvocationDelegate
-(void)getProfileInvocationDidFinish:(GetProfileInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    NSLog(@"getProfileInvocationDidFinish =%@",dict);
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                NSDictionary * uDict = [response valueForKey:@"User"];
                
                User * u = [[User alloc] init];
                u.fname = NULL_TO_NIL([uDict valueForKey:@"first_name"]);
                u.lname = NULL_TO_NIL([uDict valueForKey:@"last_name"]);
                u.username = NULL_TO_NIL([uDict valueForKey:@"username"]);
                
                u.email = ([uDict valueForKey:@"email"]);
                u.phoneNo = NULL_TO_NIL([uDict valueForKey:@"phone_number"]);
                u.address = NULL_TO_NIL([uDict valueForKey:@"address"]);
                u.image = NULL_TO_NIL([uDict valueForKey:@"image"]);
                u.aboutMe = NULL_TO_NIL([uDict valueForKey:@"description"]);
                u.default_email = NULL_TO_NIL([uDict valueForKey:@"default_email"]);
                
                [self setUserDetails:u];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:@"Unable to get profile details."];
            }
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
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
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self.view removeFromSuperview];

    
    [super viewDidDisappear:YES];

}

@end
