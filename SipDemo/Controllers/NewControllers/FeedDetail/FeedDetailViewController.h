//
//  FeedDetailViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 17/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
#import "PasswordView.h"
#import "PasswordViewIphone.h"
#import "AddCommentInvocation.h"
#import "StatusInvocation.h"
#import "AddFavoriteInvocation.h"
#import "AddSmileInvocation.h"

@class FeedDetailViewController;
@class UserLocationVC;
@class PasswordView;
@class PasswordViewIphone;
@class DocZoomVC;

@protocol FeedDetailViewControllerDelegate <NSObject>

-(void)dissmissView;

@end


@interface FeedDetailViewController : UIViewController <StatusInvocationDelegate,PasswordViewDelegate,PasswordViewIphoneDelegate,AddCommentInvocationDelegate,AddFavoriteInvocationDelegate,AddSmileInvocationDelegate>
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
    
    IBOutlet UITextView *txtDesc;
    
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

}

@property(nonatomic,strong) Feeds *feedDetails;
@property(nonatomic,strong) NSString *checkBSAndFamily;
@property(nonatomic,strong) UserLocationVC* locationVC;
@property(nonatomic,strong) PasswordView* objPasswordView;
@property(nonatomic,strong) PasswordViewIphone* objPasswordViewIphone;
@property(nonatomic,strong) DocZoomVC *imgPhoto;

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
@end
