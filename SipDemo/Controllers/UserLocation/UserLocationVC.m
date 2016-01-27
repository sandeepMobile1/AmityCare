//
//  UserLocationVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 13/05/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "UserLocationVC.h"
#import "Annotation.h"
#import "ProfileDetailVC.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface UserLocationVC ()
@end

@implementation UserLocationVC
@synthesize feed,checkLocationView,profileDetailVc;

#define METERS_PER_MILE 1609.344

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
    
   /* if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
            
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [_mapView setFrame:CGRectMake(0, 54, 320, 500)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [_mapView setFrame:CGRectMake(0, 54, 320, 500-IPHONE_FIVE_FACTOR)];
                
            }

        }
        else
        {
            
        }
        
    }*/

    
    
    if([ConfigManager isInternetAvailable]){
        [self performSelector:@selector(showUserLocationOnMap) withObject:nil afterDelay:0.1f];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    if ([self.checkLocationView isEqualToString:@"feed"]) {
        
        [btnBack setHidden:TRUE];
    }
    else
    {
        [btnBack setHidden:FALSE];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (IS_DEVICE_IPAD) {
        
     //   [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
-(void)showUserLocationOnMap
{
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200.0];

    NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",self.feed.latitude,self.feed.longitude];
    NSError*error = nil;
    
    NSLog(@"LOCATION URL @@@ = %@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSString *formattedAddress=@"";
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    NSLog(@"JSON @@@@@@ ---- =%@",results);
    usrAddress = @"";
    
    NSMutableArray *tempArray=[results objectForKey:@"results"];
    
    for (NSMutableDictionary *dict in tempArray)
    {
        formattedAddress=[dict objectForKey:@"formatted_address"];
        if (![formattedAddress isEqualToString:@""])
        {
            usrAddress = formattedAddress;
            break;
        }
    }
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.feed.latitude;
    zoomLocation.longitude= self.feed.longitude;
    
    Annotation *annotation = [[Annotation alloc] init];
    annotation.title = self.feed.postUserName;
    annotation.subtitle = usrAddress;
    annotation.coordinate = zoomLocation;
    
    [_mapView addAnnotation:annotation];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = zoomLocation;
    mapRegion.span.latitudeDelta = 5.0;
    mapRegion.span.longitudeDelta = 5.0;
    
    [_mapView setRegion:mapRegion animated: YES];

    _mapView.showsUserLocation = NO;
    
    
//    CLLocationCoordinate2D loc = zoomLocation;
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
//    [_mapView setRegion:region animated:YES];
    
    
    [DSBezelActivityView removeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)btnDoneAction:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
        
    }
}
#pragma mark- TopNavigation Delegate
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- MKMapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

-(void)showDetails:(id)sender
{
    NSLog(@"sender =%@",[sender class]);
    
    
    if (IS_DEVICE_IPAD) {
        
        self.profileDetailVc = [[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC" bundle:nil];
        
    }
    else
    {
        self.profileDetailVc = [[ProfileDetailVC alloc] initWithNibName:@"ProfileDetailVC_iphone" bundle:nil];
        
    }
    self.profileDetailVc.userid = self.feed.postUserId;
    self.profileDetailVc.userPhotoClicked= TRUE;
    self.profileDetailVc.checkLocationProfile=FALSE;

    [self.view addSubview:self.profileDetailVc.view];
  //  [self.navigationController pushViewController:profileDetailVc animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *pinIdentifier = @"pinIndentifier";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)
    
    [_mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    
    if (pinView == nil)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        customPinView.pinColor = MKPinAnnotationColorGreen;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        return customPinView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
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
    
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}


@end
