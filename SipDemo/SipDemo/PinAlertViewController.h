//
//  PinAlertViewController.h
//  SipDemo
//
//  Created by Shweta Sharma on 09/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinAlertViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIView *pinView;
    IBOutlet UIView *wrongPinView;

    IBOutlet UITextField *txtPin;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UIButton *btnOK;

}
-(IBAction)btnSubmitPressed:(id)sender;
-(IBAction)btnOKPressed:(id)sender;

@end
