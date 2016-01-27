//
//  MapRouteViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 18/02/15.
//
//

#import "MapRouteViewController.h"
#import "Annotation.h"
#import "PlaceMark.h"
#import <QuartzCore/QuartzCore.h>
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface MapRouteViewController ()

@end

@implementation MapRouteViewController

@synthesize tagId;
@synthesize startLatitude;
@synthesize startLongitude;
@synthesize endLatitude;
@synthesize endLongitude;
@synthesize distance,lineColor,delegate,checkRouteView,startAddress,endAddress,startTime,endTime,checkMapView,strDistance;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    
    [self showUserLocationOnMap];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removePopUpView)];
    panGesture.delegate = self;
    [mapView addGestureRecognizer:panGesture];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)removePopUpView
{
    [detailView removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
}
-(IBAction)btnBackAction:(id)sender
{
    
    [self.view removeFromSuperview];
    
    
}

-(void) showUserLocationOnMap
{
    routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
    routeView.userInteractionEnabled = NO;
    [mapView addSubview:routeView];
    
//    self.startLatitude=[NSString stringWithFormat:@"%f",26.8571264];
//    self.startLongitude=[NSString stringWithFormat:@"%f",75.8127199];
//    self.endLatitude=[NSString stringWithFormat:@"%f",26.9159729];
//    self.endLongitude=[NSString stringWithFormat:@"%f",75.7400563];
//
    
//    self.startLatitude=[NSString stringWithFormat:@"%f",39.92559800];
//    self.startLongitude=[NSString stringWithFormat:@"%f",-75.30924200];
//    self.endLatitude=[NSString stringWithFormat:@"%f",39.92559800];
//    self.endLongitude=[NSString stringWithFormat:@"%f",75.21147120];
    
//    self.startLatitude=[NSString stringWithFormat:@"%f",29.733303];
//    self.startLongitude=[NSString stringWithFormat:@"%f",-94.978134];
//    self.endLatitude=[NSString stringWithFormat:@"%f",29.807112];
//    self.endLongitude=[NSString stringWithFormat:@"%f",-94.973381];

//   self.startLatitude=[NSString stringWithFormat:@"%f",39.886795];
//   self.startLongitude=[NSString stringWithFormat:@"%f",-75.245277];
//  self.endLatitude=[NSString stringWithFormat:@"%f",39.920364];
//  self.endLongitude=[NSString stringWithFormat:@"%f",-75.225655];
 

    float startLat=[self.startLatitude floatValue];
    float startLong=[self.startLongitude floatValue];
    float endLat=[self.endLatitude floatValue];
    float endLong=[self.endLongitude floatValue];
    
    NSLog(@"%f,%f",startLat,startLong);
    NSLog(@"%f,%f",endLat,endLong);
    
    self.startAddress=[self getAdrressFromLatLong:startLat lon:startLong];
    
    self.endAddress=[self getAdrressFromLatLong:endLat lon:endLong];
    
    NSLog(@"%@",startAddress);
    NSLog(@"%@",endAddress);
    
    self.strDistance=[self calculateRoutesFrom:self.startAddress to:self.endAddress];
    
    if(routes)
    {
        [mapView removeAnnotations:[mapView annotations]];
    }
    
    [mapView setDelegate:self];
    mapView.showsUserLocation = NO;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = startLat;
    zoomLocation.longitude= startLong;
    
    CLLocationCoordinate2D zoomEndLocation;
    zoomEndLocation.latitude = endLat;
    zoomEndLocation.longitude= endLong;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = zoomLocation;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    [mapView setRegion:mapRegion animated: YES];
    
    mapView.showsUserLocation = NO;
    
    [mapView setCenterCoordinate:zoomLocation animated:YES];
    
   NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", zoomLocation.latitude,  zoomLocation.longitude, zoomEndLocation.latitude,zoomEndLocation.longitude];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([result count]>0) {
            
            NSLog(@"%@",result);
            
            if ([[result objectForKey:@"routes"] count]>0) {
                
                NSArray *routesArr = [result objectForKey:@"routes"];
                
                NSDictionary *firstRoute = [routesArr objectAtIndex:0];
                
                NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
                
                
                NSDictionary *end_location = [leg objectForKey:@"end_location"];
                NSDictionary *start_location = [leg objectForKey:@"start_location"];
                
                
                NSLog(@"%@",start_location);
                
                NSLog(@"%@",end_location);
                
                
                CLLocationCoordinate2D startLocation;
                startLocation.latitude = [[start_location objectForKey:@"lat"]doubleValue];
                startLocation.longitude= [[start_location objectForKey:@"lng"] doubleValue];
                
                
                CLLocationCoordinate2D EndLocation;
                EndLocation.latitude = [[end_location objectForKey:@"lat"]doubleValue];
                EndLocation.longitude= [[end_location objectForKey:@"lng"] doubleValue];
                
                
                Annotation *annotation = [[Annotation alloc] init];
                annotation.title = @"Start Address";
                annotation.subtitle = self.startAddress;
                annotation.coordinate = startLocation;
                
                [mapView addAnnotation:annotation];
                
                Annotation *endAnnotation = [[Annotation alloc] init];
                endAnnotation.title = @"End Address";
                endAnnotation.subtitle = self.endAddress;
                endAnnotation.coordinate = EndLocation;
                
                [mapView addAnnotation:endAnnotation];
                
                
                NSArray *steps = [leg objectForKey:@"steps"];
                
                NSLog(@"%@",steps);
                
                int stepIndex = 0;
                
                CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
                
                stepCoordinates[stepIndex] = zoomLocation;
                
                for (NSDictionary *step in steps) {
                    
                    NSDictionary *start_location = [step objectForKey:@"start_location"];
                    stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];
                    
                    if ([steps count] == stepIndex){
                        NSDictionary *end_location = [step objectForKey:@"end_location"];
                        stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
                    }
                }
                
                MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
                [mapView addOverlay:polyLine];
                
                
                
            }

            }
            
            
        
    }];
    
    
    if ([checkRouteView isEqualToString:@"Post"]) {
        
        [self captureImageOfRoute];
        
    }
    
}
/*-(void) showUserLocationOnMap
{
    routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
    routeView.userInteractionEnabled = NO;
    [mapView addSubview:routeView];
    
//    float startLat=[self.startLatitude floatValue];
//    float startLong=[self.startLongitude floatValue];
//    float endLat=[self.endLatitude floatValue];
//    float endLong=[self.endLongitude floatValue];
    
    float startLat=26.8571264;
    float startLong=75.8127199;
    float endLat=26.9159729;
    float endLong=75.7400563;

    
    self.startAddress=[self getAdrressFromLatLong:startLat lon:startLong];
    
    self.endAddress=[self getAdrressFromLatLong:endLat lon:endLong];
    
    NSLog(@"%@",startAddress);
    NSLog(@"%@",endAddress);
    
    self.strDistance=[self calculateRoutesFrom:self.startAddress to:self.endAddress];
    
    if(routes)
    {
        [mapView removeAnnotations:[mapView annotations]];
    }
    
    [mapView setDelegate:self];
    mapView.showsUserLocation = NO;
    
   
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = startLat;
    zoomLocation.longitude= startLong;
    
    
    CLLocationCoordinate2D zoomEndLocation;
    zoomEndLocation.latitude = endLat;
    zoomEndLocation.longitude= endLong;
    
    
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = zoomLocation;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    [mapView setRegion:mapRegion animated: YES];
    
    mapView.showsUserLocation = NO;
    
    //MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    //MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation, span);
    
    //[mapView setRegion:region];
    
    [mapView setCenterCoordinate:zoomLocation animated:YES];
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", zoomLocation.latitude,  zoomLocation.longitude, zoomEndLocation.latitude,zoomEndLocation.longitude];
  
  //  NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true", self.startAddress,self.endAddress];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSArray *routesArr = [result objectForKey:@"routes"];
        
        NSDictionary *firstRoute = [routesArr objectAtIndex:0];
        
        NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
        
        
        NSDictionary *end_location = [leg objectForKey:@"end_location"];
        NSDictionary *start_location = [leg objectForKey:@"start_location"];

        
        NSLog(@"%@",start_location);

        NSLog(@"%@",end_location);

        
        CLLocationCoordinate2D startLocation;
        startLocation.latitude = [[start_location objectForKey:@"lat"]doubleValue];
        startLocation.longitude= [[start_location objectForKey:@"lng"] doubleValue];
        
        
        CLLocationCoordinate2D EndLocation;
        EndLocation.latitude = [[end_location objectForKey:@"lat"]doubleValue];
        EndLocation.longitude= [[end_location objectForKey:@"lng"] doubleValue];
        
        
        Annotation *annotation = [[Annotation alloc] init];
        annotation.title = @"Start Address";
        annotation.subtitle = self.startAddress;
        annotation.coordinate = startLocation;
        
        [mapView addAnnotation:annotation];
        
        Annotation *endAnnotation = [[Annotation alloc] init];
        endAnnotation.title = @"End Address";
        endAnnotation.subtitle = self.endAddress;
        endAnnotation.coordinate = EndLocation;
        
        [mapView addAnnotation:endAnnotation];
        
        
        NSMutableDictionary *startDic=[[NSMutableDictionary alloc] init];
        NSMutableDictionary *endDic=[[NSMutableDictionary alloc] init];
        
        [startDic setObject:[NSString stringWithFormat:@"%f",startLat] forKey:@"lat"];
        [startDic setObject:[NSString stringWithFormat:@"%f",startLong] forKey:@"lng"];
        
        [endDic setObject:[NSString stringWithFormat:@"%f",endLat] forKey:@"lat"];
        [endDic setObject:[NSString stringWithFormat:@"%f",endLong] forKey:@"lng"];

        NSMutableDictionary *totalDic=[[NSMutableDictionary alloc] init];
        
        [totalDic setObject:startDic forKey:@"start_location"];
        [totalDic setObject:endDic forKey:@"end_location"];

        //NSArray *steps = [leg objectForKey:@"steps"];
        
        NSMutableArray *steps=[[NSMutableArray alloc] initWithObjects:totalDic, nil];
        
        NSLog(@"%@",steps);
        
        int stepIndex = 0;
        
        CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
        
        stepCoordinates[stepIndex] = zoomLocation;
        
        for (NSDictionary *step in steps) {
            
            NSDictionary *start_location = [step objectForKey:@"start_location"];
            stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];
            
            if ([steps count] == stepIndex){
                NSDictionary *end_location = [step objectForKey:@"end_location"];
                stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
            }
        }
        
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
        [mapView addOverlay:polyLine];
        
        
        
    }];
    
    
    if ([checkRouteView isEqualToString:@"Post"]) {
        
        [self captureImageOfRoute];
        
    }
    
   
    
}*/

-(NSString*)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    
    NSError *error;
   // int countLocation=0;
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",lat,lon];
    
    NSLog(@"%@",urlString);
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    
    NSDictionary *dictResults = [result JSONValue];
    
    NSString *isOk=[dictResults valueForKey:@"status"];
    
    NSString *address = @"";
    
    if ([isOk isEqualToString:@"OK"])
    {
        NSMutableArray *arrData=[dictResults valueForKey:@"results"];
        
        if ([arrData count]>0) {
            
            address = [[arrData objectAtIndex:0] valueForKey:@"formatted_address"];
        }
        
    }
    return address;
    
}
-(void)captureImageOfRoute
{
    
    sharedAppDelegate.dicRouteDetail = [[NSMutableDictionary alloc] init];
    
    [sharedAppDelegate.dicRouteDetail setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
    
    [sharedAppDelegate.dicRouteDetail setObject:self.tagId forKey:@"tag_id"];
    
  /*  CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:[self.startLatitude floatValue] longitude:[self.startLongitude floatValue]];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[self.endLatitude floatValue] longitude:[self.endLongitude floatValue]];
    CLLocationDistance totDistance = [startLocation distanceFromLocation:endLocation];
    
    NSLog(@"%g",totDistance);
    
    
    NSString *distanceInMiles=[NSString stringWithFormat:@"%.1fmi",(totDistance/1609.344)];
    
    self.distance=[NSString stringWithFormat:@"%.02f", [distanceInMiles floatValue]];*/
    
    
    NSString *distanceInMiles=[NSString stringWithFormat:@"%f",([self.strDistance intValue]*0.000621371)];

    self.distance=[NSString stringWithFormat:@"%.02f", [distanceInMiles floatValue]];
    
    
    NSLog(@"%@",self.strDistance);

    NSLog(@"%@",distanceInMiles);

    NSLog(@"%@",self.distance);
    
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.startLatitude] forKey:@"start_latitude"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.startLongitude] forKey:@"start_longitude"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.endLatitude] forKey:@"end_latitude"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.endLongitude] forKey:@"end_longitude"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.startAddress] forKey:@"start_address"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.endAddress] forKey:@"end_address"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.distance] forKey:@"distance"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%d",1] forKey:@"content_type"];
    [sharedAppDelegate.dicRouteDetail setObject:@"map" forKey:@"attachment_key"];
    [sharedAppDelegate.dicRouteDetail setObject:@"rootTagUser" forKey:@"request_path"];
    [sharedAppDelegate.dicRouteDetail setObject:@"image.jpg" forKey:@"filename"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.startTime] forKey:@"start_time"];
    [sharedAppDelegate.dicRouteDetail setObject:[NSString stringWithFormat:@"%@",self.endTime] forKey:@"end_time"];
    
    
    if([ConfigManager isInternetAvailable]){
        
        if (sharedAppDelegate.dicRouteDetail==nil) {
            
            [ConfigManager showAlertMessage:nil Message:@"Please select route"];
        }
        else
        {
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            
            [[AmityCareServices sharedService] ShareReimbursementInvocation:sharedAppDelegate.dicRouteDetail mapData:nil delegate:self];
        }
        
    }
    
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
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
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                sharedAppDelegate.routeImage=nil;
                sharedAppDelegate.mapRouteData=nil;
                sharedAppDelegate.dicRouteDetail=nil;
                
                //[ConfigManager showAlertMessage:nil Message:strmessage];
                
                successAlert=[[UIAlertView alloc] initWithTitle:nil message:strmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [successAlert show];
                
                
                
                
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        if (buttonIndex==0) {
            
            [self.delegate RootDidUpdate:self.distance mapImage:sharedAppDelegate.routeImage];
            
            [self.view removeFromSuperview];
        }
    }
}

-(NSString*) calculateRoutesFrom:(NSString*) from to: (NSString*) to {
    
    NSError *error;
    

    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&mode=driving&language=fr-FR",from,to];
    
    NSLog(@"%@",urlString);
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    
    NSDictionary *dictResults = [result JSONValue];
    
    NSLog(@"%@",dictResults);
    
    
    NSString *isOk=[dictResults valueForKey:@"status"];
    
    NSString *disatnceStr=@"";
    
    if ([isOk isEqualToString:@"OK"])
    {
        NSArray *arrDic=[dictResults objectForKey:@"rows"];

        NSArray *arrelements=[arrDic valueForKey:@"elements"];
        
       
        NSLog(@"%@",[arrelements valueForKey:@"status"]);
        
        NSArray *arrStatus=[arrelements valueForKey:@"status"];
        
        NSString *strStatus=[NSString stringWithFormat:@"%@",[[arrStatus objectAtIndex:0] objectAtIndex:0]];

        NSLog(@"%@",strStatus);
        
        if ([strStatus isEqualToString:@"ZERO_RESULTS"]) {
         
            disatnceStr=@"";
        }
        else
        {
            NSArray *arrDistance=[arrelements valueForKey:@"distance"];
            
            NSArray *arrvalue=[arrDistance valueForKey:@"value"];
            
            NSLog(@"%@",arrDistance);
            
            disatnceStr=[NSString stringWithFormat:@"%@",[[arrvalue objectAtIndex:0] objectAtIndex:0]];

        }
        
        
        
    }
    
    NSLog(@"%@",disatnceStr);
    
    return disatnceStr;

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
        
        annView.frame = CGRectMake(0, 0, 200, 50);
        
        UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        pinButton.frame = CGRectMake(0, 0, 32, 32);
        pinButton.tag = 10;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(handlePinButtonTap:)];
        tap.numberOfTapsRequired = 1;
        [pinButton addGestureRecognizer:tap];
        
        [annView addSubview:pinButton];
        
        if ([annotation.title isEqualToString:@"Start Address"]) {
            
            [pinButton setImage:[UIImage imageNamed:@"start_annotation.png"] forState:UIControlStateNormal];
            
            if ([checkMapView isEqualToString:@"start"]) {
                
                [detailView removeFromSuperview];
                
                if (IS_DEVICE_IPAD) {
                    
                    detailView=[[UIView alloc] initWithFrame:CGRectMake(annView.frame.origin.x-10, annView.frame.origin.y-60, 300, 60)];
                    
                }
                else
                {
                    detailView=[[UIView alloc] initWithFrame:CGRectMake(5, annView.frame.origin.y-60, 265, 60)];
                    
                }
                [detailView setBackgroundColor:[UIColor whiteColor]];
                
                UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 190, 20)];
                [lblTitle setFont:[UIFont systemFontOfSize:12]];
                [lblTitle setBackgroundColor:[UIColor clearColor]];
                [lblTitle setTextAlignment:NSTextAlignmentLeft];
                [lblTitle setTextColor:[UIColor blackColor]];
                [lblTitle setText:annotation.title];
                [detailView addSubview:lblTitle];
                
                UILabel *lblSubTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 20, 290, 40)];
                [lblSubTitle setFont:[UIFont systemFontOfSize:10]];
                lblSubTitle.numberOfLines=2;
                [lblSubTitle setBackgroundColor:[UIColor clearColor]];
                [lblSubTitle setTextAlignment:NSTextAlignmentLeft];
                [lblSubTitle setTextColor:[UIColor blackColor]];
                [lblSubTitle setText:annotation.subtitle];
                [detailView addSubview:lblSubTitle];
                
                detailView.clipsToBounds=YES;
                detailView.layer.cornerRadius = 5;
                
                [annView addSubview:detailView];
                
            }
            
        }
        else
        {
            [pinButton setImage:[UIImage imageNamed:@"end_annotation.png"] forState:UIControlStateNormal];
            
            if ([checkMapView isEqualToString:@"end"]) {
                
                [detailView removeFromSuperview];
                
                if (IS_DEVICE_IPAD) {
                    
                    detailView=[[UIView alloc] initWithFrame:CGRectMake(annView.frame.origin.x-10, annView.frame.origin.y-60, 300, 60)];
                    
                }
                else
                {
                    detailView=[[UIView alloc] initWithFrame:CGRectMake(5, annView.frame.origin.y-60, 265, 60)];
                    
                }
                [detailView setBackgroundColor:[UIColor whiteColor]];
                
                UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 190, 20)];
                [lblTitle setFont:[UIFont systemFontOfSize:12]];
                [lblTitle setBackgroundColor:[UIColor clearColor]];
                [lblTitle setTextAlignment:NSTextAlignmentLeft];
                [lblTitle setTextColor:[UIColor blackColor]];
                [lblTitle setText:annotation.title];
                [detailView addSubview:lblTitle];
                
                UILabel *lblSubTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 20, 290, 40)];
                [lblSubTitle setFont:[UIFont systemFontOfSize:10]];
                lblSubTitle.numberOfLines=2;
                [lblSubTitle setBackgroundColor:[UIColor clearColor]];
                [lblSubTitle setTextAlignment:NSTextAlignmentLeft];
                [lblSubTitle setTextColor:[UIColor blackColor]];
                [lblSubTitle setText:annotation.subtitle];
                [detailView addSubview:lblSubTitle];
                
                detailView.clipsToBounds=YES;
                detailView.layer.cornerRadius = 5;
                
                [annView addSubview:detailView];
                
            }
            
        }
        
        
    }
    
    annView.annotation = annotation;
    
    UIButton *pb = (UIButton *)[annView viewWithTag:10];
    [pb setTitle:annotation.title forState:UIControlStateNormal];
    
    
    
    return annView;
}

- (void) handlePinButtonTap:(UITapGestureRecognizer *)gestureRecognizer
{
    UIButton *btn = (UIButton *) gestureRecognizer.view;
    MKAnnotationView *av = (MKAnnotationView *)[btn superview];
    id<MKAnnotation> ann = av.annotation;
    NSLog(@"handlePinButtonTap: ann.title=%@", ann.title);
    
    [detailView removeFromSuperview];
    
    if (IS_DEVICE_IPAD) {
        
        detailView=[[UIView alloc] initWithFrame:CGRectMake(av.frame.origin.x-10, av.frame.origin.y-60, 300, 60)];
        
    }
    else
    {
        detailView=[[UIView alloc] initWithFrame:CGRectMake(5, av.frame.origin.y-60, 265, 60)];
        
    }    [detailView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 190, 20)];
    [lblTitle setFont:[UIFont systemFontOfSize:12]];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setText:ann.title];
    [detailView addSubview:lblTitle];
    
    UILabel *lblSubTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 20, 290, 40)];
    [lblSubTitle setFont:[UIFont systemFontOfSize:10]];
    lblSubTitle.numberOfLines=2;
    [lblSubTitle setBackgroundColor:[UIColor clearColor]];
    [lblSubTitle setTextAlignment:NSTextAlignmentLeft];
    [lblSubTitle setTextColor:[UIColor blackColor]];
    [lblSubTitle setText:ann.subtitle];
    [detailView addSubview:lblSubTitle];
    
    detailView.clipsToBounds=YES;
    detailView.layer.cornerRadius = 5;
    
    [mapView addSubview:detailView];
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}
- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
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


#pragma mark MKPolyline delegate functions

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
