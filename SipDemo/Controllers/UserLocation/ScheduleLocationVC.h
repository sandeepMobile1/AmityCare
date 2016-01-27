//
//  ScheduleLocationVC.h
//  Amity-Care
//
//  Created by Shweta Sharma on 13/03/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PeopleData.h"

@interface ScheduleLocationVC : UIViewController
{
    IBOutlet MKMapView* _mapView;
    NSString* usrAddress;

}
@property(nonatomic,strong)PeopleData* pData;
@property(nonatomic,strong)NSString *checkLocationView;

-(IBAction)btnBackAction:(id)sender;

@end
