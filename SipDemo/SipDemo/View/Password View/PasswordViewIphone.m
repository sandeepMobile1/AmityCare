//
//  PasswordViewIphone.m
//  Amity-Care
//
//  Created by Shweta Sharma on 22/10/14.
//
//

#import "PasswordViewIphone.h"
#import "NSString+urlDecode.h"
#import "SecureLoginInvocation.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "AppDelegate.h"

@interface PasswordViewIphone ()<SecureLoginInvocationDelegate>

@end

@implementation PasswordViewIphone


@synthesize delegate,tagId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray* arrr = [[NSBundle mainBundle ] loadNibNamed:@"PasswordViewIphone" owner:self options:nil];
        self = [arrr objectAtIndex:0];
        
        [self setNeedsLayout];
    }
    return self;
}

-(void)addLeftPaddingOnTxtFld:(UITextField*)textfield{
    
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 21)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
}
-(IBAction)btnBackAction:(id)sender
{
    [self removeFromSuperview];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (id temp in [self subviews]) {
        
        if([temp isKindOfClass:[UIView class]]){
            
            for (id innerView in [temp subviews]) {
                
                if([innerView isKindOfClass:[UITextField class]]){
                    [self addLeftPaddingOnTxtFld:(UITextField*)innerView];
                }
            }
        }
    }
    
    lblTitle.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    tfEmail.font = [UIFont fontWithName:appfontName size:14.0f];
    tfPassword.font = [UIFont fontWithName:appfontName size:14.0f];
    btnSubmit.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    btnCancel.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];

}

-(IBAction)submitBtnAction:(id)sender
{
    
    if(tfEmail.text.length==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_PIN];
        return;
    }
    
      if([ConfigManager isInternetAvailable]){
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Verifying user..." width:150];
        
        [[AmityCareServices sharedService] secureLoginInvocation:[tfEmail.text trimmedString] password:sharedAppDelegate.strSelectedTagId delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(IBAction)cancelBtnAction:(id)sender;
{
    if([self.delegate respondsToSelector:@selector(secureCredentialDidCancel_Iphone:)]){
        
        [self.delegate secureCredentialDidCancel_Iphone:self];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Invocation
-(void)secureLoginInvocationDidFinish:(SecureLoginInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"secureLoginInvocationDidFinish =%@",dict);
    @try {
        
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSString* success = [response valueForKey:@"success"];
                if([success rangeOfString:@"true"].length>0)
                {
                    if([self.delegate respondsToSelector:@selector(secureCredentialDidSubmitted_Iphone:)]){
                        [self.delegate secureCredentialDidSubmitted_Iphone:self];
                    }
                }
                else if([success rangeOfString:@"false"].length>0){
                    [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                }
            }
        }
        else{
            [ConfigManager showAlertMessage:nil Message:@"Error!! Verifying user"];
            if([self.delegate respondsToSelector:@selector(secureCredentialDidCancel_Iphone:)]){
                [self.delegate secureCredentialDidCancel_Iphone:self];
            }
        }
    }
    @catch(NSException* exception)
    {
        NSLog(@"Exception =%@ %@",[self class],[exception debugDescription]);
    }
    @finally{
        [DSBezelActivityView removeView];
    }
}

@end
