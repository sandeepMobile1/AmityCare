//
//  UserFeedCell_iphone.h
//  Amity-Care
//
//  Created by Shweta Sharma on 20/10/14.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "FormValues.h"

@protocol UserFeedCell_iphoneDelegate <NSObject>

-(void)userProfileActionClicked_iphone:(UIButton*)sender;
-(void)docThumbnailDidClicked_iphone:(UIButton*)sender;
-(void)userLocationDidClicked_iphone:(UIButton*)sender;
-(void)formImageDidClicked_iphone:(UIButton*)sender;

@end



@interface UserFeedCell_iphone : UITableViewCell<UIScrollViewDelegate>
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

@property (nonatomic, unsafe_unretained)id<UserFeedCell_iphoneDelegate>delegate;
@property (nonatomic,strong)Feeds *feed;
+ (CGFloat)heightForCellWithPost:(Feeds *)post ;
-(IBAction)userProfileAction:(id)sender;
-(IBAction)docThumbnailAction:(id)sender;
-(IBAction)userLocationBtnAction:(id)sender;
-(IBAction)btnFormImagePressed:(id)sender;

@end
