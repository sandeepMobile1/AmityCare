//
//  StatusFeedDetailViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 30/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
#import "StatusInvocation.h"
#import "AddCommentInvocation.h"
#import "AddFavoriteInvocation.h"
#import "AddSmileInvocation.h"

@class UserLocationVC;

@interface StatusFeedDetailViewController : UIViewController <StatusInvocationDelegate,UITextFieldDelegate,AddCommentInvocationDelegate,AddFavoriteInvocationDelegate,AddSmileInvocationDelegate>
{
    IBOutlet UIView *topView;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *tagScroll;
    
    IBOutlet UIImageView *imgUser;
    
    IBOutlet UILabel *lblFeedTitle;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblTags;
    
    IBOutlet UITextView *txtDesc;
    IBOutlet UIView *permissionView;
    IBOutlet UILabel *lblViewInmap;

    IBOutlet UIButton *customEmployeeBtn;
    IBOutlet UIButton *customManagerBtn;
    IBOutlet UIButton *customTLBtn;
    IBOutlet UIButton *customFamlityBtn;
    //IBOutlet UIButton *customTrainingBtn;
    IBOutlet UIButton *customBSBtn;
    IBOutlet UIButton *radioEmployeeBtn;
    IBOutlet UIButton *radioManagerBtn;
    IBOutlet UIButton *radioTLBtn;
    IBOutlet UIButton *radioFamilyBtn;
    IBOutlet UIButton *radioBSBtn;
    //IBOutlet UIButton *radioTrainingBtn;
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

-(IBAction)btnCloseAction:(id)sender;
-(IBAction)btnMapLocationAction:(id)sender;
-(IBAction)btnCrossAction:(id)sender;

- (IBAction)employeeBtnPressed:(id)sender;
- (IBAction)managerBtnPressed:(id)sender;
- (IBAction)teamLeaderBtnPressed:(id)sender;
//- (IBAction)trainingBtnPressed:(id)sender;
- (IBAction)familyBtnPressed:(id)sender;
- (IBAction)bSBtnPressed:(id)sender;

-(void)setFrame;
-(void)setFeedDetailsValues;
-(void)addTagsOnScrollView:(NSMutableArray*)arrTag;
//-(void)addCommentsOnScrollView:(NSMutableArray*)arrComment;

-(IBAction)favButtonAction:(id)sender;
-(IBAction)smileButtonAction:(id)sender;
-(IBAction)sadSmileButtonAction:(id)sender;
@end
