//
//  RouteFeedDetailViewController.h
//  SipDemo
//
//  Created by Octal on 31/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AddFavoriteInvocation.h"
#import "AddSmileInvocation.h"
#import "Feeds.h"

@class UserLocationVC;
@class MapRouteViewController;

@interface RouteFeedDetailViewController : UIViewController <AddFavoriteInvocationDelegate,AddSmileInvocationDelegate,MKMapViewDelegate>
{
    IBOutlet UIView *topView;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *tagScroll;
    
    IBOutlet UIImageView *imgView;
    IBOutlet UIImageView *imgUser;
    
    IBOutlet UILabel *lblFeedTitle;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblTags;
    IBOutlet UILabel *lblViewInmap;
    
    IBOutlet UIView *permissionView;
    
    IBOutlet UIButton *customEmployeeBtn;
    IBOutlet UIButton *customManagerBtn;
    IBOutlet UIButton *customTLBtn;
    IBOutlet UIButton *customFamlityBtn;
    IBOutlet UIButton *customBSBtn;
    IBOutlet UIButton *radioEmployeeBtn;
    IBOutlet UIButton *radioManagerBtn;
    IBOutlet UIButton *radioTLBtn;
    IBOutlet UIButton *radioFamilyBtn;
    IBOutlet UIButton *radioBSBtn;
    
    IBOutlet UIButton *btnThumbnail;
    
    IBOutlet UIView *commentView;
    IBOutlet UITextField *txtCommentView;
    
    BOOL checkSmile;
    
    IBOutlet UIButton*   btnFav;
    IBOutlet UIButton*   btnSmile;
    IBOutlet  UIButton*  btnSadSmile;
    IBOutlet UILabel *lblDistance;


}

@property(nonatomic,strong)IBOutlet UILabel *   lblStartAdd;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndAdd;
@property(nonatomic,strong)IBOutlet UILabel *   lblWeekDay;
@property(nonatomic,strong)IBOutlet UILabel *   lblDate;
@property(nonatomic,strong)IBOutlet UILabel *   lblStartTime;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndTime;
@property(nonatomic,strong)MapRouteViewController *objMapRouteMapView;
@property(nonatomic,strong)IBOutlet MKMapView *  MKStartMapView;
@property(nonatomic,strong)IBOutlet MKMapView *  MKEndMapView;
@property(nonatomic,strong)IBOutlet UIButton  *  btnStartMapView;
@property(nonatomic,strong)IBOutlet UIButton  *  btnEndMapView;
@property(nonatomic,strong)IBOutlet UIButton  *  btnDelete;
@property(nonatomic,strong)IBOutlet UIButton  *  btnCheckMark;

@property(nonatomic,strong) Feeds *feedDetails;
@property(nonatomic,strong) NSString *checkBSAndFamily;
@property(nonatomic,strong) UserLocationVC* locationVC;

-(IBAction)btnCloseAction:(id)sender;
-(IBAction)btnMapLocationAction:(id)sender;
-(IBAction)btnThumbnilAction:(id)sender;
-(IBAction)btnCrossAction:(id)sender;

- (IBAction)employeeBtnPressed:(id)sender;
- (IBAction)managerBtnPressed:(id)sender;
- (IBAction)teamLeaderBtnPressed:(id)sender;
- (IBAction)familyBtnPressed:(id)sender;
- (IBAction)bSBtnPressed:(id)sender;

-(void)setFrame;
-(void)setFeedDetailsValues;
-(void)addTagsOnScrollView:(NSMutableArray*)arrTag;
-(void)addCommentsOnScrollView:(NSMutableArray*)arrComment yView:(int)yView;

-(IBAction)favButtonAction:(id)sender;
-(IBAction)smileButtonAction:(id)sender;
-(IBAction)sadSmileButtonAction:(id)sender;
-(IBAction)btnStartMapViewPressed:(UIButton*)sender;
-(IBAction)btnEndMapViewPressed:(UIButton*)sender;


@end
