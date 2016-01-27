//
//  EditTagIntroViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/10/14.
//
//

#import "EditTagIntroViewController.h"
#import "TopNavigationView.h"
#import "UIImageExtras.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface EditTagIntroViewController ()

@end

@implementation EditTagIntroViewController

@synthesize tagId,intro;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
            
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [scrollView setFrame:CGRectMake(0, 0, 320, 568)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [scrollView setFrame:CGRectMake(0, 0, 320, 568-IPHONE_FIVE_FACTOR)];
                
            }
        }
        else
        {
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [scrollView setFrame:CGRectMake(0, 0, 320, 558)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [scrollView setFrame:CGRectMake(0, 0, 320, 558-IPHONE_FIVE_FACTOR)];
                
            }
        }
        
    }
    
    if (!IS_DEVICE_IPAD) {
        
        TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
        navigation.lblTitle.text = @"Edit Intro";
        [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        navigation.tag = 100;
        // [self.view addSubview:navigation];
        
    }
    
    
    btnSubmit.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    
    btnCancel.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    
    //txtView.layer.borderWidth = 10.0f;
    // txtView.clipsToBounds = YES;
    
    txtView.text=self.intro;
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnDoneAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
    
    
    
}
-(IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)leftBarButtonDidClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark IBAction methods---------

-(IBAction)btnSubmitPressed:(id)sender
{
    [txtView resignFirstResponder];
    
    if (!IS_DEVICE_IPAD) {
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
    }
    
    
    
    if (txtView.text.length ==0) {
        [ConfigManager showAlertMessage:Nil Message:@"Tag intro is required"];
        return;
    }
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Updating intro..." width:200];
        
        [[AmityCareServices sharedService] EditTagIntroInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId intro:txtView.text delegate:self];
    }
}
-(IBAction)btnCancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (!IS_DEVICE_IPAD) {
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
    }
    [txtView resignFirstResponder];
}

#pragma mark textview delegate---------

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (!IS_DEVICE_IPAD) {
        
        if ([text isEqualToString:@"\n"])
        {
            
            [textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            return NO;
            
        }
        
    }
    
    
    return YES;
    
}
- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 245;
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)EditTagIntroInvocationDidFinish:(EditTagIntroInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"EditTagIntroInvocationDidFinish =%@",dict);
    @try {
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSString *strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                
                ACAlertView *alert = [ConfigManager alertView:nil message:@"Intro has been updated successfully" del:self];
                alert.alertTag = AC_ALERTVIEW_TASK_ADDED_SUCCESSFULLY;
                [alert show];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"success"]];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView];
    }
    
}

#pragma mark- UIAlertView Delegate
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_TASK_ADDED_SUCCESSFULLY)
    {
        sharedAppDelegate.strUpdatedTagIntro=txtView.text;
        
        checkClockOutTimer=@"intro";
        
        if (!IS_DEVICE_IPAD) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: AC_TAG_INTRO_UPDATE object:nil];
            
        }
    }
    
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
