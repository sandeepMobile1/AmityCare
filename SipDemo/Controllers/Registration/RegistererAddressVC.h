//
//  RegistererAddressVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 02/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistererAddressVC : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField* tfPhoneNo;
    IBOutlet UITextField* tfAddress;
    IBOutlet UIButton* btnBack;
    IBOutlet UIButton* btnRegister;
    IBOutlet UILabel* lblTitle;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
    int movementDistance;
    float movementDuration;
}
@property(nonatomic,strong) NSMutableDictionary* userInfo;
-(IBAction)backBtnPressed:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(void)resignTextField;


@end
