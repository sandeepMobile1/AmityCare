//
//  RegistrationVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 28/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegistrationVC : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UITextField* tfFname;
    IBOutlet UITextField* tfLname;
    IBOutlet UITextField* tfEmail;
    IBOutlet UITextField* tfPassword;
    IBOutlet UITextField* tfConfirmPassword;
    IBOutlet UITextField* txtUserRole;

    IBOutlet UIButton* btnBack;
    IBOutlet UIButton* btnNext;
    IBOutlet UILabel* lblTitle;
    UIPopoverController* popover;
    
    IBOutlet UIScrollView *scrollView;
    
    UIPickerView *myPicker;
    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
    int movementDistance;
    float movementDuration;
    
}

@property(nonatomic,strong)NSMutableArray *arrRoleList;
@property(nonatomic,strong)NSString *strRole;
@property(nonatomic,strong)UIView *masterView;

-(void)resignTextField;
-(void)showRolePicker;
-(IBAction)backBtnPressed:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;

@end
