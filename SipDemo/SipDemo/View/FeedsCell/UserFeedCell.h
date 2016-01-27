//
//  UserFeedCell.h
//  Amity-Care
//
//  Created by Vijay Kumar on 03/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "FormValues.h"

@protocol UserFeedCellDelegate <NSObject>

-(void)userProfileActionClicked:(UIButton*)sender;
-(void)docThumbnailDidClicked:(UIButton*)sender;
-(void)userLocationDidClicked:(UIButton*)sender;
-(void)formImageDidClicked:(UIButton*)sender;

@end

@interface UserFeedCell : UITableViewCell<UIScrollViewDelegate>
{
    MKMapView* mapView;
}
@property (nonatomic,strong)IBOutlet UIView *viewMainBg;
@property (nonatomic,strong)IBOutlet UIView *viewHearder;
@property (nonatomic,strong)IBOutlet UIImageView *imgPostUserImgBg;
@property (nonatomic,strong)IBOutlet UIImageView *imgPostUserImg;
@property (nonatomic,strong)IBOutlet UIButton *btnPostUserPic;
@property (nonatomic,strong)IBOutlet UIButton *btnPostUserName;
@property (nonatomic,strong)IBOutlet UILabel *lblPostUserName;
@property (nonatomic,strong)IBOutlet UILabel *lblTime;
@property (nonatomic,strong)IBOutlet UILabel *lblViewInmap;
@property (nonatomic,strong)IBOutlet UIButton* btnLocMap;

@property (nonatomic,strong)IBOutlet UIView *viewThumbnailDocument;
@property (nonatomic,strong)IBOutlet UIImageView *imgThumbnailOfDoc;
@property (nonatomic,strong)IBOutlet UIImageView *imgThumbnailBgOfDoc;
@property (nonatomic,strong)IBOutlet UIButton *btnThumbnail;
@property (retain, nonatomic) IBOutlet UIButton *customEmployeeBtn;
@property (retain, nonatomic) IBOutlet UIButton *customManagerBtn;
@property (retain, nonatomic) IBOutlet UIButton *customTLBtn;
@property (retain, nonatomic) IBOutlet UIButton *customFamlityBtn;
@property (retain, nonatomic) IBOutlet UIButton *customTrainingBtn;
@property (retain, nonatomic) IBOutlet UIButton *customBSBtn;
@property (retain, nonatomic) IBOutlet UIButton *radioEmployeeBtn;
@property (retain, nonatomic) IBOutlet UIButton *radioManagerBtn;
@property (retain, nonatomic) IBOutlet UIButton *radioTLBtn;
@property (retain, nonatomic) IBOutlet UIButton *radioFamilyBtn;
@property (retain, nonatomic) IBOutlet UIButton *radioBSBtn;
@property (retain, nonatomic) IBOutlet UIButton *radioTrainingBtn;

@property (nonatomic,strong)IBOutlet UIView *viewDocDesc;
@property (nonatomic,strong)IBOutlet UILabel *lblTitleOfDoc;
@property (nonatomic,strong)IBOutlet UILabel *lblDescOfDoc;

@property (nonatomic,strong)IBOutlet UIView* viewTags;
@property (nonatomic,strong)IBOutlet UILabel* lblTags;
@property (nonatomic,strong)IBOutlet UIScrollView* scrlView;
@property (retain, nonatomic) IBOutlet UIView *lowerView;

@property (nonatomic,strong)IBOutlet UIView  * viewForm;
//@property (nonatomic,strong)IBOutlet UILabel * lblQue;
//@property (nonatomic,strong)IBOutlet UILabel * lblAns;


@property (nonatomic, unsafe_unretained)id<UserFeedCellDelegate>delegate;
@property (nonatomic,strong)Feeds *feed;
+ (CGFloat)heightForCellWithPost:(Feeds *)post ;
-(IBAction)userProfileAction:(id)sender;
-(IBAction)docThumbnailAction:(id)sender;
-(IBAction)userLocationBtnAction:(id)sender;
-(IBAction)btnFormImagePressed:(id)sender;

@end
