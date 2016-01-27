//
//  AddBackPackMessageViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import "AddBackPackMessageViewController.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface AddBackPackMessageViewController ()

@end

@implementation AddBackPackMessageViewController

@synthesize tagId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (IS_DEVICE_IPAD) {
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    
    txtDesc.textColor = [UIColor lightGrayColor];
    
    txtDesc.layer.borderWidth = 1.0f;
    txtDesc.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.5] CGColor];
    txtDesc.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(IBAction)AddMessagePressed:(id)sender
{
    txtDesc.text = [txtDesc.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (txtDesc.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please enter message"];
    }
    else
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Favorite list..." width:180];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:txtDesc.text forKey:@"message"];
        
        if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
            
            
        }
        else
        {
            [dic setObject:self.tagId forKey:@"tag_id"];
            
        }
        [[AmityCareServices sharedService] AddMessageInvocation:dic delegate:self];
    }
    
}
-(void)AddMessageInvocationDidFinish:(AddMessageInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        NSDictionary *msgDic=[dict valueForKey:@"response"];
        NSLog(@"%@",msgDic);
        
        NSString* strSuccess = NULL_TO_NIL([msgDic objectForKey:@"success"]);
        
        NSString* strMessage = NULL_TO_NIL([msgDic objectForKey:@"message"]);
        
        NSLog(@"%@",strSuccess);
        NSLog(@"%@",strMessage);
        
        if([strSuccess rangeOfString:@"true"].length>0)
        {
            
            successAlert=[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:strMessage];
            
        }
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
    }
    [DSBezelActivityView removeView];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        
        [textField resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
    }
    
    return YES;
}

#pragma mark- UITextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        [textView resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        return NO;
        
    }
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return YES;
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    
    if (txtDesc.textColor == [UIColor lightGrayColor]) {
        txtDesc.text = @"";
        txtDesc.textColor = [UIColor blackColor];
    }
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(txtDesc.text.length == 0)
    {
        txtDesc.text = @"Enter description";
        txtDesc.textColor = [UIColor lightGrayColor];
        [txtDesc resignFirstResponder];
    }
}

#pragma mark- UITextField Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        if (buttonIndex==0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName: AC_BACKPACK_UPDATE object:nil];
            
            [self.view removeFromSuperview];
        }
    }
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
