//
//  PasswordView.m
//  Amity-Care
//
//  Created by Vijay Kumar on 29/05/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "PasswordView.h"
#import "NSString+urlDecode.h"
#import "SecureLoginInvocation.h"
#import "AlertMessage.h"
#import "ConfigManager.h"
#import "DSActivityView.h"
#import "AppDelegate.h"

@interface PasswordView ()<SecureLoginInvocationDelegate>

@end

@implementation PasswordView
@synthesize delegate,tagId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray* arrr = [[NSBundle mainBundle ] loadNibNamed:@"PasswordView" owner:self options:nil];
        self = [arrr objectAtIndex:0];
        
        [self setNeedsLayout];
    }
    return self;
}
-(IBAction)btnBackAction:(id)sender
{
    [self removeFromSuperview];
}
-(void)addLeftPaddingOnTxtFld:(UITextField*)textfield{
    
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 21)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
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
    btnSubmit.titleLabel.font = [UIFont fontWithName:appfontName size:18.0f];
    btnCancel.titleLabel.font = [UIFont fontWithName:appfontName size:18.0f];
    
}

-(IBAction)submitBtnAction:(id)sender
{
    
    if(tfEmail.text.length==0){
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_BLANK_PIN];
        return;
    }
 
    
    if([ConfigManager isInternetAvailable]){
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Verifying user..." width:150];
        
        [[AmityCareServices sharedService] secureLoginInvocation:[tfEmail.text trimmedString] password:self.tagId delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
}

-(IBAction)cancelBtnAction:(id)sender;
{
    if([self.delegate respondsToSelector:@selector(secureCredentialDidCancel:)]){
        
        [self.delegate secureCredentialDidCancel:self];
    }
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
                    if([self.delegate respondsToSelector:@selector(secureCredentialDidSubmitted:)]){
                        [self.delegate secureCredentialDidSubmitted:self];
                    }
                }
                else if([success rangeOfString:@"false"].length>0){
                    [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                }
            }
        }
        else{
            [ConfigManager showAlertMessage:nil Message:@"Error!! Verifying user"];
            if([self.delegate respondsToSelector:@selector(secureCredentialDidCancel:)]){
                [self.delegate secureCredentialDidCancel:self];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
