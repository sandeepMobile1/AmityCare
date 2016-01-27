//
//  UserLocationVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 13/05/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Feeds.h"
#import "ProfileDetailVC.h"
@interface UserLocationVC : UIViewController<MKMapViewDelegate>{
    IBOutlet MKMapView* _mapView;
    NSString* usrAddress;
    
    IBOutlet UIButton *btnBack;
}
@property(nonatomic,strong)ProfileDetailVC *profileDetailVc;

@property(nonatomic,strong)Feeds* feed;

@property(nonatomic,strong)NSString *checkLocationView;

-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnDoneAction:(id)sender;

@end
