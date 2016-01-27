//
//  HomeViewController.h
//  Amity-Care
//
//  Created by Vijay Kumar on 28/03/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface HomeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,CBCentralManagerDelegate>
{
    IBOutlet UITextField* tfEmail;
    IBOutlet UITextField* tfPassword;
    IBOutlet UIButton* btnRememberMe;
    
    IBOutlet UIButton* btnLogin,*btnRegister;
    IBOutlet UILabel *lblTitle,*lblRememberMe;
    
    int forgotPasswordCount;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
    int movementDistance;
    float movementDuration;

}

-(IBAction)LoginAction:(id)sender;
-(IBAction)RegistartionAction:(id)sender;
-(IBAction)RememberMeAction:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(void)resignTextField;


@end
