//
//  ChangePasswordVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 08/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField* tfOldPassword;
    IBOutlet UITextField* tfNewPassword;
    IBOutlet UITextField* tfConfirmPassword;
    IBOutlet UIButton* btnChangePass;
  
    IBOutlet UIScrollView *scrollView;

    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
    int movementDistance;
    float movementDuration;
}

-(IBAction)changePasswordAction:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(IBAction)btnBackAction:(id)sender;

@end
