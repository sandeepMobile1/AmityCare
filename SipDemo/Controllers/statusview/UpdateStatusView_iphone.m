//
//  UpdateStatusView_iphone.m
//  Amity-Care
//
//  Created by Shweta Sharma on 21/10/14.
//
//

#import "UpdateStatusView_iphone.h"
#import "StatusCell.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface UpdateStatusView_iphone ()<SetStatusInvocationDelegate>

@end

@implementation UpdateStatusView_iphone

@synthesize delegate;
@synthesize tagView;

@synthesize customEmployeeBtn,customManagerBtn,customTLBtn,customFamlityBtn,customTrainingBtn,customBSBtn,radioEmployeeBtn,radioManagerBtn,radioTLBtn,radioFamilyBtn,radioBSBtn,radioTrainingBtn;

#define ANIMATION_DURATION 0.5
#define PARTICIPANTS_MOOD_OPTION_COUNT       37

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}



- (id)initWithStatusArray:(NSMutableArray*)arrStatus withDelegate:(id)del
{
    NSArray *array;
    
    array= [[NSBundle mainBundle] loadNibNamed:@"UpdateStatusView_iphone" owner:self options:nil];
    
    if (DEVICE_OS_VERSION>=7) {
        
        [viewStatus setFrame:CGRectMake(0,0,viewStatus.frame.size.width,viewStatus.frame.size.height)];
        
    }
    else
    {
        [viewStatus setFrame:CGRectMake(0,20,viewStatus.frame.size.width,viewStatus.frame.size.height)];
        
    }
    
    self = [array objectAtIndex:0];
    self.delegate = del;
    _arrStatusList =arrStatus;
    
    strPromptUsed = @"";
    arrOptMoods = [[NSMutableArray alloc] init];
    txtViewStatus.layer.borderColor = [[UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:0.3] CGColor];
    txtViewStatus.layer.borderWidth = 1.0f;
    txtViewStatus.clipsToBounds = YES;
    [self configureSubviews];
    [self showAddNewStatusView];
    //[self addCustomRadioControls];
    
    return self;
}

-(void)addCustomRadioControls
{
    
    int startX =5;
    int startY = 405;
    int tag = 0;
    
    for (int i=0; i<PARTICIPANTS_MOOD_OPTION_COUNT/3 + 1; i++) {
        
        for (int j=0; (j<3 && tag< PARTICIPANTS_MOOD_OPTION_COUNT) ; j++)
        {
            CustomRadioControl * crc = [[CustomRadioControl alloc] initWithFrame:CGRectZero];
            [crc setFrame:CGRectMake(startX, startY, 140, 22)];
            [crc setOptionTitle:tag];
            crc.delegate = self;
            
            crc.tag = tag;
            tag++;
            startX = startX+140+25;
            
            [viewStatus addSubview:crc];
            
            [arrOptMoods addObject:crc];
        }
        
        startX = 5;
        startY = startY+22+5;
    }
}

-(void)configureSubviews
{
    lblStatusTitle.font = [UIFont fontWithName:boldfontName size:22.0f];
    lblCurrStatus.font = [UIFont fontWithName:appfontName size:16.0f];
    lblNewStatus.font = [UIFont fontWithName:appfontName size:16.0f];
    btnSubmit.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    btnCancel.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    txtViewStatus.font =[UIFont fontWithName:appfontName size:16.0f];
    
    if ([sharedAppDelegate.userObj.role isEqualToString:@"3"] ||[sharedAppDelegate.userObj.role isEqualToString:@"5"])
    {
        //        viewStatus.frame = CGRectMake(viewStatus.frame.origin.x, viewStatus.frame.origin.y-50, viewStatus.frame.size.width, 508);
        
        // --------------- set initial value --------------
        
        // btnSubmit.frame = CGRectMake(15, 414, 140, 43);
        // btnCancel.frame = CGRectMake(165, 414, 140, 43);
        
        // viewStatus.frame = CGRectMake(viewStatus.frame.origin.x, viewStatus.frame.origin.y, viewStatus.frame.size.width, 508);
        
        if (tagStatusDic) {
            tagStatusDic = nil;
        }
        
        tagStatusDic = [[NSMutableDictionary alloc] init];
        [tagStatusDic setObject:@"0" forKey:@"BS"];
        [tagStatusDic setObject:@"0" forKey:@"manager"];
        [tagStatusDic setObject:@"0" forKey:@"teamleader"];
        [tagStatusDic setObject:@"0" forKey:@"family"];
        // [tagStatusDic setObject:@"0" forKey:@"training"];
        [tagStatusDic setObject:@"1" forKey:@"employee"];
        
        NSLog(@"Dic %@",tagStatusDic);
        
        btnSubmit.frame = CGRectMake(btnSubmit.frame.origin.x, 330, btnSubmit.frame.size.width, btnSubmit.frame.size.height);
        
    }
    else
    {
        tagView.hidden = YES;
        btnSubmit.frame = CGRectMake(btnSubmit.frame.origin.x, 230, btnSubmit.frame.size.width, btnSubmit.frame.size.height);
        
    }
    
    
    //btnSubmit.frame = CGRectMake(15, 324, 140, 43);
    //btnCancel.frame = CGRectMake(165, 324, 140, 43);
    
    viewStatus.frame = CGRectMake(viewStatus.frame.origin.x, viewStatus.frame.origin.y, viewStatus.frame.size.width, 568);
    
    
    
}


-(NSMutableArray*)getSelectedMoods
{
    NSMutableArray *arrSelectedMoods = [[NSMutableArray alloc] init];
    
    for (CustomRadioControl *crc in arrOptMoods) {
        if(crc.btnRadio.selected){
            [arrSelectedMoods addObject:crc->lblOptTitle.text];
        }
    }
    return arrSelectedMoods;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [UIView commitAnimations];
        
        return NO;
        
    }
    
    return YES;
}

//Add new status
#pragma mark----------
#pragma mark- IBActions-


- (IBAction)employeeBtnPressed:(id)sender
{
    NSString *statusStr;
    
    if (radioEmployeeBtn.selected) {
        
        statusStr=@"0";
        
        radioEmployeeBtn.selected=NO;
        
    }
    else
    {
        radioEmployeeBtn.selected=YES;
        
        statusStr=@"1";
        
    }
    
    [tagStatusDic setObject:statusStr forKey:@"employee"];
    
    
    
    
}
- (IBAction)managerBtnPressed:(id)sender
{
    
}
- (IBAction)teamLeaderBtnPressed:(id)sender
{
    NSString *statusStr;
    
    if (radioTLBtn.selected) {
        
        statusStr=@"0";
        
        radioTLBtn.selected=NO;
        
    }
    else
    {
        radioTLBtn.selected=YES;
        
        statusStr=@"1";
        
    }
    
    [tagStatusDic setObject:statusStr forKey:@"teamleader"];
    
    
    
}
/*- (IBAction)trainingBtnPressed:(id)sender
 {
 NSString *statusStr;
 
 if (radioTrainingBtn.selected) {
 
 statusStr=@"0";
 
 radioTrainingBtn.selected=NO;
 
 }
 else
 {
 radioTrainingBtn.selected=YES;
 
 statusStr=@"1";
 
 }
 
 //  [tagStatusDic setObject:statusStr forKey:@"training"];
 
 
 
 }*/
- (IBAction)familyBtnPressed:(id)sender
{
    NSString *statusStr;
    
    if (radioFamilyBtn.selected) {
        
        statusStr=@"0";
        
        radioFamilyBtn.selected=NO;
        
    }
    else
    {
        radioFamilyBtn.selected=YES;
        
        statusStr=@"1";
        
    }
    
    [tagStatusDic setObject:statusStr forKey:@"family"];
    
    
}
- (IBAction)bSBtnPressed:(id)sender
{
    NSString *statusStr;
    
    if (radioBSBtn.selected) {
        
        statusStr=@"0";
        
        radioBSBtn.selected=NO;
        
    }
    else
    {
        radioBSBtn.selected=YES;
        
        statusStr=@"1";
        
    }
    
    [tagStatusDic setObject:statusStr forKey:@"BS"];
    
    
    
    
    
}

-(IBAction)submitStatus:(id)sender
{
    if(txtViewStatus.text.length == 0){
        [ConfigManager showAlertMessage:nil Message:@"Status can't be blank"];
        return;
    }
    
    if([ConfigManager isInternetAvailable]){
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Status" forKey:@"title"];
        [dict setObject:[ConfigManager trimmedString:txtViewStatus.text] forKey:@"description"];
        [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        [dict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
        [dict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tags"];
        [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        [dict setObject:[NSString stringWithFormat:@"%d",4] forKey:@"content_type"];
        
        // ----------- tag status ---------------
        NSLog(@"Dic %@",tagStatusDic);
        
        if ([sharedAppDelegate.userObj.role_id isEqualToString:@"3"]) {
            
            [dict setObject:[tagStatusDic objectForKey:@"BS"] forKey:@"BS"];
            [dict setObject:[tagStatusDic objectForKey:@"manager"] forKey:@"manager"];
            [dict setObject:[tagStatusDic objectForKey:@"teamleader"] forKey:@"teamleader"];
            [dict setObject:[tagStatusDic objectForKey:@"family"] forKey:@"family"];
            [dict setObject:[tagStatusDic objectForKey:@"employee"] forKey:@"employee"];
            
        }
        else
        {
            if ([sharedAppDelegate.userObj.role_id isEqualToString:@"2"]) {
                
                NSLog(@"Dic %@",tagStatusDic);
                
                
                [dict setObject:@"0" forKey:@"BS"];
                [dict setObject:@"1" forKey:@"manager"];
                [dict setObject:@"1"forKey:@"teamleader"];
                [dict setObject:@"0" forKey:@"family"];
                [dict setObject:@"1" forKey:@"employee"];
                
            }
            else if ([sharedAppDelegate.userObj.role_id isEqualToString:@"5"]) {
                
                [dict setObject:@"0" forKey:@"BS"];
                [dict setObject:@"1" forKey:@"manager"];
                [dict setObject:@"1" forKey:@"teamleader"];
                [dict setObject:@"0" forKey:@"family"];
                [dict setObject:@"0" forKey:@"employee"];
                
            }
            else if ([sharedAppDelegate.userObj.role_id isEqualToString:@"6"]) {
                
                [dict setObject:@"0" forKey:@"BS"];
                [dict setObject:@"1" forKey:@"manager"];
                [dict setObject:@"1" forKey:@"teamleader"];
                [dict setObject:@"1"forKey:@"family"];
                [dict setObject:@"0" forKey:@"employee"];
                
            }
            else if ([sharedAppDelegate.userObj.role_id isEqualToString:@"7"]) {
                
                [dict setObject:@"0" forKey:@"BS"];
                [dict setObject:@"1" forKey:@"manager"];
                [dict setObject:@"1" forKey:@"teamleader"];
                [dict setObject:@"0" forKey:@"family"];
                [dict setObject:@"0" forKey:@"employee"];
                
            }
            else if ([sharedAppDelegate.userObj.role_id isEqualToString:@"8"]) {
                
                [dict setObject:@"1" forKey:@"BS"];
                [dict setObject:@"1" forKey:@"manager"];
                [dict setObject:@"1" forKey:@"teamleader"];
                [dict setObject:@"0" forKey:@"family"];
                [dict setObject:@"0" forKey:@"employee"];
                
            }
        }
        
        
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
        [[AmityCareServices sharedService] setStatusInvocation:dict delegate:self];
        
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

-(IBAction)cancelStatus:(id)sender
{
    [self hideAddNewStatusView];
    
    if([self.delegate respondsToSelector:@selector(statusDidUpdate_iphone: newStatus: status:)])
    {
        [self.delegate statusDidUpdate_iphone:self newStatus:nil status:FALSE];
    }
}

-(IBAction)whichPromptsWereUsed:(id)sender
{
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:btnVervalPrmpt]){
        btnVervalPrmpt.selected  = TRUE;
        btnGesturePrmpt.selected = FALSE;
        btnIndirectVrbal.selected = FALSE;
        btnHandOverHand.selected = FALSE;
        strPromptUsed = @"Direct Verbal Prompt? (i.e., bell ringing, state purchase total)";
    }
    else if([button isEqual:btnGesturePrmpt]){
        btnVervalPrmpt.selected  = FALSE;
        btnGesturePrmpt.selected = TRUE;
        btnIndirectVrbal.selected = FALSE;
        btnHandOverHand.selected = FALSE;
        strPromptUsed = @"Gesture Prompt (i.e., Pointing)";
        
    }
    else if ([button isEqual:btnIndirectVrbal]){
        btnVervalPrmpt.selected  = FALSE;
        btnGesturePrmpt.selected = FALSE;
        btnIndirectVrbal.selected = TRUE;
        btnHandOverHand.selected = FALSE;
        strPromptUsed = @"Indirect Verbal (i.e., ask participant what to do next)";
        
    }
    else if ([button isEqual:btnHandOverHand]){
        btnVervalPrmpt.selected  = FALSE;
        btnGesturePrmpt.selected = FALSE;
        btnIndirectVrbal.selected = FALSE;
        btnHandOverHand.selected = TRUE;
        strPromptUsed = @"Hand over Hand (i.e., Physically assist participant to push button)";
    }
}

#pragma mark- CustomRadioDelegate

-(void)radioBtnAction:(CustomRadioControl *)view
{
    CustomRadioControl* crc = [arrOptMoods objectAtIndex:view.tag];
    crc.btnRadio.selected = !crc.btnRadio.selected;
}
/*
 -(IBAction)submitNewStatus:(id)sender
 {
 if(tfAddNewStatus.text.length ==0){
 [ConfigManager showAlertMessage:nil Message:@"status required"];
 return;
 }
 else if([ConfigManager stringContainsSpecialCharacters:tfAddNewStatus.text]){
 [ConfigManager showAlertMessage:nil Message:ALERT_MSG_SPECIAL_CHARACTERS];
 return;
 }
 
 [tfAddNewStatus resignFirstResponder];
 [self hideAddNewStatusView];
 
 Status* newStatus = [[Status alloc] init];
 newStatus.statusId = nil;
 newStatus.statusDesc = tfAddNewStatus.text;
 
 [self performSelector:@selector(setStatus:) withObject:newStatus afterDelay:0.2f];
 }
 */

#pragma mark---------
-(void)hideAddNewStatusView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [viewStatus setAlpha:0.0];
    [UIView commitAnimations];
}

-(void)showAddNewStatusView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [viewStatus setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)setStatus:(Status*)status
{
    if([self.delegate respondsToSelector:@selector(statusDidUpdate_iphone: newStatus: status:)])
    {
        [self.delegate statusDidUpdate_iphone:self newStatus:status status:TRUE];
    }
}

-(void)setStatusInvocationDidFinish:(SetStatusInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    [DSBezelActivityView removeView];
    txtViewStatus.text=@"";
    [txtViewStatus resignFirstResponder];

    @try {
        if(!error){
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = [response valueForKey:@"success"];
            NSString* strMessage = [response valueForKey:@"message"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                //                [ConfigManager showAlertMessage:nil Message:@"Status updated successfully"];
                //if([self.delegate respondsToSelector:@selector(statusDidUpdate_iphone: newStatus: status:)])
                //  {
                [[NSNotificationCenter defaultCenter] postNotificationName:AC_STATUS_UPDATE object:nil];
                
                [ConfigManager showAlertMessage:nil Message:strMessage];
                
                // [self.delegate statusDidUpdate_iphone:self newStatus:nil status:TRUE];
                // }
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:strMessage];
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
