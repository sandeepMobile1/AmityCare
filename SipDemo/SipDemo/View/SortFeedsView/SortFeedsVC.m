//
//  SortFeedsVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 09/06/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "SortFeedsVC.h"
#import "ActionSheetPicker.h"
#import "ConfigManager.h"

@interface SortFeedsVC ()

@end

@implementation SortFeedsVC
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutSubivews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- -----

-(void)leftPadding:(UITextField*)textField
{
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 21)];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void)layoutSubivews
{
    for (id temp in [self.view subviews]) {
        if([temp isKindOfClass:[UIView class]]){
            for (id inner in [temp subviews]) {
                if([inner isKindOfClass:[UITextField class]]){
                    [self leftPadding:inner];
                }
            }
        }
    }
    tfStartDate.font = [UIFont fontWithName:appfontName size:13.0];
    tfEndDate.font = [UIFont fontWithName:appfontName size:13.0];
    
    lblHeading.font = [UIFont fontWithName:appfontName size:20.0];
    btnSearch.titleLabel.font = [UIFont fontWithName:appfontName size:18.0];
    btnCancel.titleLabel.font = [UIFont fontWithName:appfontName size:18.0];
}

#pragma mark- 
-(IBAction)submitBtnSortFeedAction:(id)sender
{
    if(tfStartDate.text.length==0 || tfEndDate.text.length==0){
        [ConfigManager showAlertMessage:nil Message:@"Please enter start and end date"];
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(searchBtnAction:)]){
        [self.delegate searchBtnAction:self];
    }
}
-(IBAction)cancelBtnSortFeedAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(cancelBtnAction:)]){
        [self.delegate cancelBtnAction:self];
    }
}

#pragma mark- UITextField

-(void)startDateSelected:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    if(tfEndDate.text.length >0){
        
        NSDate *endDt = [dateFormatter dateFromString:tfEndDate.text];
        if([date compare:endDt]==NSOrderedDescending){
            tfStartDate.text = @"";
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End date can't be greater than start date" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
    }
    
    tfStartDate.text = strDate;
}

-(void)endDateSelected:(NSDate*)date
{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *preDate = [dateFormatter dateFromString:tfStartDate.text];
    
   // NSLog(@"compare srestult =%ld",[preDate compare:date]);
    
    if ([preDate compare:date]==NSOrderedDescending) {
        tfEndDate.text = @"";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"End date can't be greater than start date" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }

    NSString *strDate = [dateFormatter stringFromDate:date];
    tfEndDate.text = strDate;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:tfStartDate]){
        
        
        UIViewController* popoverContent = [[UIViewController alloc] init];
        
        UIView *popoverView = [[UIView alloc] init];
        popoverView.backgroundColor = [UIColor clearColor];
        
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
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
        datePicker.frame=CGRectMake(0,44,320, 216);
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        [datePicker setTag:10];
        [popoverView addSubview:toolbar];
        [popoverView addSubview:datePicker];

        popoverContent.view = popoverView;
       
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        popoverController.delegate=self;
        
        tfStartDate.inputView=datePicker;
        
        [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
        [popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if([textField isEqual:tfEndDate]){
        
        if(tfStartDate.text.length ==0){
            [ConfigManager showAlertMessage:nil Message:@"Please select start date first"];
            return FALSE;
        }
        
        UIViewController* popoverContent = [[UIViewController alloc] init];
        
        UIView *popoverView = [[UIView alloc] init];
        popoverView.backgroundColor = [UIColor clearColor];
        
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                      target: self
                                                                                      action: @selector(cancel)];
        UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                               target: nil
                                                                               action: nil];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                    target: self
                                                                                    action: @selector(endDone)];
        
        NSMutableArray* toolbarItems = [NSMutableArray array];
        [toolbarItems addObject:cancelButton];
        [toolbarItems addObject:space];
        [toolbarItems addObject:doneButton];
        toolbar.items = toolbarItems;
        
        datePicker=[[UIDatePicker alloc]init];
        datePicker.frame=CGRectMake(0,44,320, 216);
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        [datePicker setTag:10];
        [popoverView addSubview:toolbar];
        [popoverView addSubview:datePicker];
        
        popoverContent.view = popoverView;
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        popoverController.delegate=self;
        
        tfEndDate.inputView=datePicker;
        
        [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
        [popoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    return FALSE;
}
-(IBAction)cancel
{
    [popoverController dismissPopoverAnimated:YES];

}
-(IBAction)done
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    tfStartDate.text = [formatter stringFromDate:dateSelected];
    
    [popoverController dismissPopoverAnimated:YES];
}
-(IBAction)endDone
{
    NSDate * dateSelected = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    tfEndDate.text = [formatter stringFromDate:dateSelected];
  
    [popoverController dismissPopoverAnimated:YES];

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return TRUE;
}

@end
