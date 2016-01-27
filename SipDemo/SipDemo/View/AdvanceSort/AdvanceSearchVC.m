//
//  AdvanceSearchVC.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 23/09/14.
//
//

#import "AdvanceSearchVC.h"
#import "ActionSheetPicker.h"
#import "ConfigManager.h"

@implementation AdvanceSearchVC

@synthesize tfEndDate,tfHashTag,tfStartDate,title,lblHeading;
@synthesize btnSearch,btnCancel;

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
-(IBAction)submitBtnAdvSortFeedAction:(id)sender
{
    if(tfHashTag.text.length==0)
    {
        [ConfigManager showAlertMessage:nil Message:@"Please enter hash tag"];
        return;
    }
    else if(tfStartDate.text.length==0 || tfEndDate.text.length==0){
        [ConfigManager showAlertMessage:nil Message:@"Please enter start and end date"];
        return;
    }
    
    
    if([self.delegate respondsToSelector:@selector(submitBtnAdvSortFeedAction:)]){
        [self.delegate submitBtnAdvSortFeedAction:self];
    }
}
-(IBAction)cancelBtnAdvSortFeedAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(cancelBtnAdvSortFeedAction:)]){
        [self.delegate cancelBtnAdvSortFeedAction:self];
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
        [ActionSheetPicker displayActionPickerWithView:self.view datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(startDateSelected:) title:@"Start Date:"];
    }
    else if([textField isEqual:tfEndDate]){
        
        if(tfStartDate.text.length ==0){
            [ConfigManager showAlertMessage:nil Message:@"Please select start date first"];
            return FALSE;
        }
        [ActionSheetPicker displayActionPickerWithView:self.view datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(endDateSelected:) title:@"End Date:"];
    }
    else if([textField isEqual:tfHashTag])
    {
        return YES;
    }
    
    return FALSE;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return TRUE;
}

@end