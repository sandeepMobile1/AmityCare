//
//  UpdateStatusView.h
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomRadioControl.h"

@class Status;

@protocol UpdateStatusViewDelegate <NSObject>
-(void)statusDidUpdate:(UIView*)statusView newStatus:(Status*)status status:(BOOL)isUpdated;
@end

@interface UpdateStatusView : UIView<UITextViewDelegate,CustomRadioControlDelegate>
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
@property (nonatomic,unsafe_unretained)id<UpdateStatusViewDelegate>delegate;
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

//@property (nonatomic, strong)NSMutableDictionary *tagStatusDic;

- (id)initWithStatusArray:(NSMutableArray*)arrStatus withDelegate:(id)del;

-(IBAction)whichPromptsWereUsed:(id)sender;

-(IBAction)cancelStatus:(id)sender;
-(IBAction)submitStatus:(id)sender;

@end
