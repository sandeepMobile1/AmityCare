//
//  ReimbursementTableViewCell.h
//  Amity-Care
//
//  Created by Shweta Sharma on 20/04/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class  ReimbursementTableViewCell;

@protocol ReimbursementTableViewCellDelegate <NSObject>

-(void) buttonCheckMarkClick:(ReimbursementTableViewCell*)cellValue;
-(void) buttonMoreClick:(ReimbursementTableViewCell*)cellValue;

@end
@interface ReimbursementTableViewCell : UITableViewCell <MKMapViewDelegate>

@property(nonatomic,strong)IBOutlet UILabel *   lblStartAdd;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndAdd;
@property(nonatomic,strong)IBOutlet UILabel *   lblWeekDay;
@property(nonatomic,strong)IBOutlet UILabel *   lblDate;
@property(nonatomic,strong)IBOutlet UILabel *   lblStartTime;
@property(nonatomic,strong)IBOutlet UILabel *   lblEndTime;
@property(nonatomic,strong)IBOutlet UILabel *   lblDistance;
@property(nonatomic,strong)IBOutlet UILabel *   lblShare;
@property(nonatomic,strong)IBOutlet UILabel *   lblShareValue;
@property(nonatomic,strong)IBOutlet UILabel *   lblTagName;

@property(nonatomic,strong)IBOutlet MKMapView *  MKStartMapView;
@property(nonatomic,strong)IBOutlet MKMapView *  MKEndMapView;
@property(nonatomic,strong)IBOutlet UIButton  *  btnStartMapView;
@property(nonatomic,strong)IBOutlet UIButton  *  btnEndMapView;
@property(nonatomic,strong)IBOutlet UIButton  *  btnDelete;
@property(nonatomic,strong)IBOutlet UIButton  *  btnCheckMark;

@property(nonatomic,strong)IBOutlet UIView  *  backView;
@property(nonatomic,strong)IBOutlet UIImageView  * imgView;
@property(nonatomic,strong)IBOutlet UIView *commentView;
@property(nonatomic,strong)IBOutlet UITextField *txtCommentView;
@property(nonatomic,strong)IBOutlet UILabel *lblComment;
@property(nonatomic,strong)IBOutlet UIButton *btnMore;

@property(nonatomic,assign) id<ReimbursementTableViewCellDelegate>delegate;

+(ReimbursementTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnCheckMarkPressed:(id)sender;
-(IBAction)btnMorePressed:(id)sender;

@end
