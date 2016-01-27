//
//  FormFeedDetailViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 30/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "StatusInvocation.h"
#import "AddFavoriteInvocation.h"
#import "AddSmileInvocation.h"
#import "AddCommentInvocation.h"

@class AVAudioPlayer;
@class AVAudioSession;
@class UserLocationVC;

@interface FormFeedDetailViewController : UIViewController <StatusInvocationDelegate,AVAudioPlayerDelegate,AddCommentInvocationDelegate,UITextFieldDelegate,AddFavoriteInvocationDelegate,AddSmileInvocationDelegate>
{
    IBOutlet UIView *topView;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *tagScroll;
    
    IBOutlet UIView *viewForm;
    IBOutlet UIImageView *imgUser;
    
    IBOutlet UILabel *lblFeedTitle;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblTags;
    
    BOOL checkSmile;

    
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

    
    IBOutlet UIImageView *largeImgView;
    
    AVAudioPlayer *audioPlayer;
    
   // IBOutlet UIView *outputAudioView;
   // IBOutlet UIButton *outputAudioButton;
   // IBOutlet UISlider *outputAudioSlider;
    NSTimer *audioProgressTimer;

    IBOutlet UIView *commentView;
    IBOutlet UITextField *txtCommentView;
    
    IBOutlet UIButton*   btnFav;
    IBOutlet UIButton*   btnSmile;
    IBOutlet  UIButton*  btnSadSmile;
    
}
@property(nonatomic,strong)UserLocationVC* locationVC;
@property(nonatomic,strong)IBOutlet UIView *zoomView;
@property(nonatomic,strong) Feeds *feedDetails;
@property(nonatomic,strong) NSString *audioLocalUrl;
@property(nonatomic,strong) NSString *checkBSAndFamily;

-(IBAction)btnCloseAction:(id)sender;
-(IBAction)btnMapLocationAction:(id)sender;
- (IBAction)employeeBtnPressed:(id)sender;
- (IBAction)managerBtnPressed:(id)sender;
- (IBAction)teamLeaderBtnPressed:(id)sender;
- (IBAction)familyBtnPressed:(id)sender;
- (IBAction)bSBtnPressed:(id)sender;
-(IBAction)btnCrossAction:(id)sender;
-(IBAction)btnCloseLargeImgViewAction:(id)sender;
-(IBAction)btnOutputAudioBtnAction:(UIButton*)sender;
//-(IBAction)btnAudioSliderMoveAction:(UISlider*)sender;

-(void)setFrame;
-(void)setFeedDetailsValues;
-(void)addTagsOnScrollView:(NSMutableArray*)arrTag;
-(void)addFormValuesOnScrollView:(NSMutableArray*)arrTag;
-(void)addCommentsOnScrollView:(NSMutableArray*)arrComment yView:(int)yView;

-(IBAction)favButtonAction:(id)sender;
-(IBAction)smileButtonAction:(id)sender;
-(IBAction)sadSmileButtonAction:(id)sender;


@end
