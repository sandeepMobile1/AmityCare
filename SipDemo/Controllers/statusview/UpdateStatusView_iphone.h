//
//  UpdateStatusView_iphone.h
//  Amity-Care
//
//  Created by Shweta Sharma on 21/10/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomRadioControl.h"

@class Status;

@protocol UpdateStatusView_iphoneDelegate <NSObject>
-(void)statusDidUpdate_iphone:(UIView*)statusView newStatus:(Status*)status status:(BOOL)isUpdated;
@end

@interface UpdateStatusView_iphone : UIView <UITextViewDelegate,CustomRadioControlDelegate>
{
    
    IBOutlet UIView * viewStatus;
    IBOutlet UILabel* lblStatusTitle;
    IBOutlet UILabel* lblCurrStatus;
    IBOutlet UILabel* lblNewStatus;
    
    IBOutlet UIButton* btnVervalPrmpt;
    IBOutlet UIButton* btnGesturePrmpt;
    IBOutlet UIButton* btnIndirectVrbal;
    IBOutlet UIButton* btnHandOverHand;
    IBOutlet UIButton* btnSubmit;
    IBOutlet UIButton* btnCancel;
        
    IBOutlet UITextView* txtViewStatus;
    
    NSMutableDictionary *tagStatusDic;
    
    NSMutableArray* arrOptMoods;
    
    NSString* strPromptUsed;
}
@property (nonatomic,unsafe_unretained)id<UpdateStatusView_iphoneDelegate>delegate;
@property(nonatomic,strong) NSMutableArray* arrStatusList;
@property (retain, nonatomic) IBOutlet UIView *tagView;

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


- (id)initWithStatusArray:(NSMutableArray*)arrStatus withDelegate:(id)del;

-(IBAction)whichPromptsWereUsed:(id)sender;

-(IBAction)cancelStatus:(id)sender;
-(IBAction)submitStatus:(id)sender;

@end
