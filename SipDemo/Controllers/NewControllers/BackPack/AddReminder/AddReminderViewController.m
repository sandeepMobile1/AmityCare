//
//  AddReminderViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import "AddReminderViewController.h"
#import "ActionSheetPicker.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

@synthesize serverDate;
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
    
    txtDesc.text = @"Description";
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
-(IBAction)btnAddReminderPressed:(id)sender
{
    txtTitle.text = [txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtDesc.text = [txtDesc.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtDate.text = [txtDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (txtTitle.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please enter title"];
    }
    else if (txtDate.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please select date"];
    }
    else if (txtDesc.text.length==0) {
        
        [ConfigManager showAlertMessage:nil Message:@"Please enter description"];
    }
    else
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Favorite list..." width:180];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dic setObject:txtTitle.text forKey:@"title"];
        [dic setObject:self.serverDate forKey:@"reminderTime"];
        [dic setObject:txtDesc.text forKey:@"description"];
        
        if (self.tagId==nil || self.tagId==(NSString*)[NSNull null] || [self.tagId isEqualToString:@""]) {
            
            
        }
        else
        {
            [dic setObject:self.tagId forKey:@"tag_id"];
            
        }
        [[AmityCareServices sharedService] AddReminderInvocation:dic delegate:self];
    }
    
    
}
-(void)AddReminderInvocationDidFinish:(AddReminderInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    if (!error) {
        
        NSDictionary *msgDic=[dict valueForKey:@"response"];
        NSLog(@"%@",msgDic);
        
        NSString* strSuccess = NULL_TO_NIL([msgDic objectForKey:@"success"]);
        
        NSString* strMessage = NULL_TO_NIL([msgDic objectForKey:@"message"]);
        
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
#pragma mark- UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:txtDate])
    {
        if (IS_DEVICE_IPAD) {
            
            [ActionSheetPicker displayActionPickerWithView:txtDate datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(selectDate:) title:@"Select Date"];
            
        }
        else
        {
            
            [self showDatePicker];
            [textField resignFirstResponder];
            
            
        }
        
        
        //return FALSE;
    }
    
}
-(void)showDatePicker
{
    [toolbar removeFromSuperview];
    [datePicker removeFromSuperview];
    
    toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(done)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    toolbar.items = toolbarItems;
    
    datePicker=[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    [self.view addSubview:datePicker];
    
    if (IS_IPHONE_5) {
        
        [toolbar setFrame:CGRectMake(0.0, 180.0+IPHONE_FIVE_FACTOR, 275.0, 44.0)];
        datePicker.frame=CGRectMake(0,224+IPHONE_FIVE_FACTOR,275.0, 216);
        
    }
    else
    {
        [toolbar setFrame:CGRectMake(0.0, 180.0, 275.0, 44.0)];
        
        datePicker.frame=CGRectMake(0,224,275.0, 216);
        
    }
    
}

-(IBAction)cancel
{
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    [txtDate resignFirstResponder];
    
}
-(IBAction)done
{
    
    
    NSDate *date = datePicker.date;
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    NSLog(@"%@",dateStr);
    
    self.serverDate=dateStr;
    
    NSString* strDate = [self shortStyleDate:date];
    txtDate.text = strDate;
    
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    [txtDate resignFirstResponder];
    
    
}
-(NSString*)shortStyleDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    NSString* shortDate = [df stringFromDate:date];
    return shortDate;
}

-(void)selectDate:(id)sender
{
    [txtDate resignFirstResponder];
    
    NSDate *date = (NSDate*)sender;
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date
    
    NSLog(@"%@",dateStr);
    
    self.serverDate=dateStr;
    
    NSString* strDate = [self shortStyleDate:date];
    txtDate.text = strDate;
}
#pragma mark- UITextView Delegate

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


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
    }
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [self scrollViewToCenterOfScreen:textView];
        
    }
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
        txtDesc.text = @"Task Description";
        txtDesc.textColor = [UIColor lightGrayColor];
        [txtDesc resignFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(!(textView.textColor == [UIColor lightGrayColor]))
    {
        // strAbtDesc = textView.text;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
