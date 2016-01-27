//
//  PinAlertViewController.m
//  SipDemo
//
//  Created by Shweta Sharma on 09/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "PinAlertViewController.h"
#import "AppDelegate.h"

@interface PinAlertViewController ()

@end

@implementation PinAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnOK .layer.cornerRadius=10;
    btnOK.clipsToBounds = YES;

    btnSubmit.layer.cornerRadius=10;
    btnSubmit.clipsToBounds = YES;
    
    if (IS_DEVICE_IPAD) {
        
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_background.png"]]];
        
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_background_iphone.png"]]];
        
    }
    
    if (IS_DEVICE_IPAD) {
     
        [pinView setFrame:CGRectMake(224, 100, pinView.frame.size.width, pinView.frame.size.height)];
        
        [self.view addSubview:pinView];
        
        [wrongPinView setFrame:CGRectMake(224, 120, pinView.frame.size.width, pinView.frame.size.height)];
        
        [self.view addSubview:wrongPinView];
        
    }
    else
    {
        [pinView setFrame:CGRectMake(0, 0, pinView.frame.size.width, pinView.frame.size.height)];
        
        [self.view addSubview:pinView];
        
        [wrongPinView setFrame:CGRectMake(0, 0, pinView.frame.size.width, pinView.frame.size.height)];
        
        [self.view addSubview:wrongPinView];

    }

    [pinView setHidden:FALSE];
    [wrongPinView setHidden:TRUE];
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnSubmitPressed:(id)sender
{
    NSLog(@"PIN %@",sharedAppDelegate.userObj.appPin);
    
    if (![txtPin.text isEqualToString:sharedAppDelegate.userObj.appPin])
    {
        [pinView setHidden:TRUE];
        [wrongPinView setHidden:FALSE];
        [txtPin setText:@""];
    }
    else
    {
        [self.view removeFromSuperview];
    }

}
-(IBAction)btnOKPressed:(id)sender
{
    [pinView setHidden:FALSE];
    [wrongPinView setHidden:TRUE];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (resultStr.length > 4)
    {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
