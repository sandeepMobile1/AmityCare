//
//  MapRouteViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 18/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Place.h"
#import "ShareReimbursementInvocation.h"

@class MapRouteViewController;

@protocol MapRouteViewControllerDelegate <NSObject>

-(void)RootDidUpdate:(NSString*)distance mapImage:(UIImage*)mapImage;

@end

@interface MapRouteViewController : UIViewController<MKMapViewDelegate,UIGestureRecognizerDelegate,ShareReimbursementInvocationDelegate,UIAlertViewDelegate>
{
    IBOutlet MKMapView* mapView;
    NSArray* routes;
    BOOL isUpdatingRoutes;
    UIImageView* routeView;
    UIView *detailView;
    
    UIAlertView *successAlert;
    
}
-(IBAction)btnBackAction:(id)sender;

@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSString *startLatitude;
@property(nonatomic,strong)NSString *startLongitude;
@property(nonatomic,strong)NSString *endLatitude;
@property(nonatomic,strong)NSString *endLongitude;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *checkRouteView;
@property(nonatomic,strong)NSString *startAddress;
@property(nonatomic,strong)NSString *endAddress;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *strDistance;

@property(nonatomic,strong)NSString *checkMapView;

@property (nonatomic, retain) UIColor* lineColor;
@property (nonatomic,unsafe_unretained)id<MapRouteViewControllerDelegate>delegate;

//-(void) showRouteFrom: (Place*) f to:(Place*) t;
//-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded;
//-(void) updateRouteView;
//-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;
//-(void) centerMap;
@end
