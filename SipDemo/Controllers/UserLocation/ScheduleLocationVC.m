//
//  ScheduleLocationVC.m
//  Amity-Care
//
//  Created by Shweta Sharma on 13/03/15.
//
//

#import "ScheduleLocationVC.h"
#import "Annotation.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface ScheduleLocationVC ()

@end

@implementation ScheduleLocationVC

@synthesize pData,checkLocationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([ConfigManager isInternetAvailable]){
        [self performSelector:@selector(showUserLocationOnMap) withObject:nil afterDelay:0.1f];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
      //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
-(void)showUserLocationOnMap
{
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200.0];
    
    NSString *url;
    
    if ([checkLocationView isEqualToString:@"clockin"]) {
        
        url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",[self.pData.userClockInLatitude floatValue],[self.pData.userClockInLongitude floatValue]];

    }
    else
    {
        url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",[self.pData.userClockOutLatitude floatValue],[self.pData.userClockOutLongitude floatValue]];

    }
    
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
    Annotation *annotation = [[Annotation alloc] init];

    if ([checkLocationView isEqualToString:@"clockin"]) {
        
        zoomLocation.latitude = [self.pData.userClockInLatitude floatValue];
        zoomLocation.longitude= [self.pData.userClockInLongitude floatValue];
        annotation.title = self.pData.userName;
    }
    else
    {
        zoomLocation.latitude = [self.pData.userClockOutLatitude floatValue];
        zoomLocation.longitude= [self.pData.userClockOutLongitude floatValue];
        annotation.title = self.pData.userName;
    }
    
   
    annotation.subtitle = usrAddress;
    annotation.coordinate = zoomLocation;
    
    [_mapView addAnnotation:annotation];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = zoomLocation;
    mapRegion.span.latitudeDelta = 5.0;
    mapRegion.span.longitudeDelta = 5.0;
    
    [_mapView setRegion:mapRegion animated: YES];
    
    _mapView.showsUserLocation = NO;
    
    [DSBezelActivityView removeView];
}
/*-(void)dealloc
{
    NSLog(@"@@@@ == %@==dealloc== @@@@",[self class]);
    _mapView = nil;
    self.pData= nil;
    
    [super dealloc];
}*/

-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}

#pragma mark- MKMapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
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
        
        //UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
       /* [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];*/
       // customPinView.rightCalloutAccessoryView = rightButton;
        
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
