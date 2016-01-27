//
//  RecieptFeedDetailViewController.h
//  SipDemo
//
//  Created by Octal on 04/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
#import "PasswordView.h"
#import "PasswordViewIphone.h"
#import "AddCommentInvocation.h"
#import "StatusInvocation.h"
#import "AddFavoriteInvocation.h"
#import "AddSmileInvocation.h"

@class RecieptFeedDetailViewController;
@class UserLocationVC;
@class PasswordView;
@class PasswordViewIphone;
@class DocZoomVC;

@protocol RecieptFeedDetailViewController <NSObject>

-(void)dissmissView;

@end

@interface RecieptFeedDetailViewController : UIViewController
<StatusInvocationDelegate,PasswordViewDelegate,PasswordViewIphoneDelegate,AddCommentInvocationDelegate,AddFavoriteInvocationDelegate,AddSmileInvocationDelegate>
{
    IBOutlet UIView *topView;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *tagScroll;
    
    IBOutlet UIImageView *imgView;
    IBOutlet UIImageView *imgUser;
    
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
    IBOutlet UIButton*   btnSadSmile;
    IBOutlet UILabel *   lblRecieptDate;
    IBOutlet UILabel *   lblMerchant;
    IBOutlet UILabel *   lblAmount;
    IBOutlet UILabel *   lblReimbursement;
    IBOutlet UILabel *   txtDescription;
    
    IBOutlet UIView *largeView;
    IBOutlet UIImageView *imgLargeView;
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
-(IBAction)btnRecieptImageAction:(id)sender;

-(IBAction)btnCloseImageAction:(id)sender;


@end
