//
//  UploadMediaFilesVc.m
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "UploadMediaFilesVc.h"
#import "TagSelectionVC.h"
#import "Tags.h"
#import  <QuartzCore/QuartzCore.h>
#import "UploadDocInvocation.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface UploadMediaFilesVc ()<TagSelectionDelegate,UploadDocInvocationDelegate>

@end

@implementation UploadMediaFilesVc
@synthesize uploadMedia;
@synthesize imageFile;
@synthesize videoURL;
@synthesize attachmentURL;
@synthesize dDropBoxContent,tagS;




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
    
    fieldsArray = [[NSArray alloc] initWithObjects:tfUploadTitle,tfUploadTags,txtVwUploadDesc,nil];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,750)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    /*  TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
     [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     navigation.lblTitle.text = @"Upload Media files";
     [self.view addSubview:navigation];*/
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPlayingVideo) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self layoutMediaSubviews];
    
    [self initArrayWithDefaultTag];
    
    tfUploadTags.text = sharedAppDelegate.strSelectedTag;
    
    txtVwUploadDesc.text = @"Enter description";
    txtVwUploadDesc.textColor = [UIColor lightGrayColor];
    
    txtVwUploadDesc.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:0.5] CGColor];
    txtVwUploadDesc.layer.borderWidth= 1.0f;
    txtVwUploadDesc.clipsToBounds = YES;
    
    //    [UIView animateWithDuration:0.5
    //                          delay:0.05
    //                        options: UIViewAnimationCurveEaseInOut
    //                     animations:^{
    //                         containerView.frame = CGRectMake(0, 70, 487, 700);
    //                     }
    //                     completion:^(BOOL finished){
    //                     }];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }
    self.navigationController.navigationBarHidden = YES;
    
    [sharedAppDelegate startUpdatingLocation];
    
    [sharedAppDelegate aGlobalNavigation:[self navigationController]];
    
    if(uploadMedia == uploadMeidaImageFile)
    {
        imgThumbnailMedia.image = imageFile;
    }
    else if(uploadMedia == uploadMeidaVideoFile)
    {
        
        mpPlayer  = [[MPMoviePlayerController alloc ] initWithContentURL:videoURL];
        UIImage *singleFrameImage = [mpPlayer thumbnailImageAtTime:0
                                                        timeOption:MPMovieTimeOptionExact];
        imgThumbnailMedia.image = singleFrameImage;
        [btnMedia setHidden:NO];
    }
    else if(uploadMedia == uploadMediaFromDropbox)
    {
        imgThumbnailMedia.image = [UIImage imageNamed:@"document_thumb.png"];
    }
    
}

-(void)initArrayWithDefaultTag
{
    arrTags = [[NSMutableArray alloc] init];
    
    Tags *t = [[Tags alloc] init];
    t.tagId = sharedAppDelegate.strSelectedTagId;
    t.tagTitle = sharedAppDelegate.strSelectedTag;
    t.isSelected = TRUE;
    
    [arrTags addObject:t];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)dealloc
{
    NSLog(@"=====%@==dealloc",[self class]);
    mpPlayer = nil;
    containerView = nil;
    tfUploadTags = nil;
    tfUploadTitle = nil;
    arrTags = nil;
    
    [super dealloc];
}
*/

#pragma mark- NavigationBtn Actions
-(void)leftBarButtonDidClicked:(id)sender
{
    if(mpPlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [mpPlayer stop];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}

#pragma mark- ---------
#pragma mark- MPMoviePlaybackFinish Notification
-(void)didFinishPlayingVideo
{
    [mpPlayer stop];
    [self hideMediaPlayerAnimation];
}

#pragma mark- Other Methods

-(void)showMediaPlayerAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [mpPlayer.view setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)hideMediaPlayerAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [mpPlayer.view setAlpha:0.0];
    [UIView commitAnimations];
    [mpPlayer.view removeFromSuperview];
}

#pragma mark------------

-(void)layoutMediaSubviews
{
    for (id tempView in [self.view subviews]) {
        if([tempView isKindOfClass:[UIView class]])
        {
            for ( id innerView in [tempView subviews]) {
                if([innerView isKindOfClass:[UITextField class]]){
                    [self addPaddingOnTextFields:(UITextField*)innerView];
                }
            }
        }
    }
    
    tfUploadTitle.font = [UIFont fontWithName:appfontName size:16.0f];
    tfUploadTags.font = [UIFont fontWithName:appfontName size:16.0f];
    txtVwUploadDesc.font = [UIFont fontWithName:appfontName size:16.0f];
    btnMedia.titleLabel.font = [UIFont fontWithName:TITLE_FONT_NAME size:22.0f];
    
}

-(void)addPaddingOnTextFields:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}


#pragma mark- ---------
#pragma mark- IBActions

-(IBAction)playMediaBtnAction:(id)sende
{
    mpPlayer.view.frame = imgThumbnailMedia.frame;
    mpPlayer.view.backgroundColor = [UIColor whiteColor];
    mpPlayer.controlStyle =MPMovieControlStyleDefault;
    [mpPlayer.view setAlpha:0.0f];
    [containerView addSubview:mpPlayer.view];
    [self showMediaPlayerAnimation];
    [mpPlayer play];
    
}

-(IBAction)uploadButtonAction:(id)sender
{
    @try {
        [tfUploadTitle resignFirstResponder];
        [txtVwUploadDesc resignFirstResponder];
        
        if(tfUploadTitle.text.length ==0)
        {
            [ConfigManager showAlertMessage:nil Message:@"Title required"];
            return;
        }
        else if([ConfigManager stringContainsSpecialCharacters:tfUploadTitle.text]){
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_SPECIAL_CHARACTERS];
            return;
        }
        else if(tfUploadTags.text.length == 0 )
        {
            [ConfigManager showAlertMessage:nil Message:@"Tags required"];
            return;
        }
        else if(txtVwUploadDesc.text.length == 0 || [txtVwUploadDesc.text isEqualToString:@"Enter description"])
        {
            [ConfigManager showAlertMessage:nil Message:@"Description required"];
            return;
        }
        else if([ConfigManager stringContainsSpecialCharacters:txtVwUploadDesc.text]){
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_SPECIAL_CHARACTERS];
            return;
        }
        
        NSString* strTags = @"";
        
        for (int i=0; i<[arrTags count]; i++) {
            
            Tags *t = (Tags*)[arrTags objectAtIndex:i];
            if(t.isSelected)
            {
                //[arrSelectedTags addObject:t.tagId];
                strTags=[strTags stringByAppendingFormat:@"%@",t.tagId];
                
                if(i<[arrTags count])
                {
                    strTags = [strTags stringByAppendingString:@","];
                }
            }
        }
        
        
        
        strTags = [strTags substringToIndex:([strTags length]-1)];
        
        if([ConfigManager isInternetAvailable])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[ConfigManager trimmedString:tfUploadTitle.text] forKey:@"title"];
            [dict setObject:strTags forKey:@"tags"];
            [dict setObject:[ConfigManager trimmedString:txtVwUploadDesc.text] forKey:@"description"];
            [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
            
            if (sharedAppDelegate.strSelectedTagId==nil || sharedAppDelegate.strSelectedTagId==(NSString*)[NSNull null]) {
                
                [dict setObject:@"" forKey:@"tag_id"];
                
            }
            else
            {
                [dict setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
                
            }
            [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
            [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            [dict setObject:@"attachment" forKey:@"attachment_key"];
            [dict setObject:@"upload_doc" forKey:@"request_path"];
            
            NSLog(@"%@",dict);
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
            
            if(uploadMedia == uploadMeidaImageFile){
                [dict setObject:@"image.jpg" forKey:@"filename"];
                [dict setObject:[NSString stringWithFormat:@"%ld",uploadMedia] forKey:@"content_type"];
                [[AmityCareServices sharedService] uploadDocInvocation:dict uploadData:(UIImageJPEGRepresentation(imgThumbnailMedia.image, 0.50)) delegate:self];
            }
            else if(uploadMedia == uploadMeidaVideoFile){
                
                [dict setObject:@"video.mp4" forKey:@"filename"];
                [dict setObject:[NSString stringWithFormat:@"%ld",uploadMedia] forKey:@"content_type"];
                NSLog(@"videoURL %@",videoURL);
                NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
                [[AmityCareServices sharedService] uploadDocInvocation:dict uploadData:videoData delegate:self];
            }
            else if(uploadMedia == uploadMediaFromDropbox)
            {
                
                NSString* strExtension = [self.dDropBoxContent valueForKey:@"extension"];
                
                NSLog(@"Extension =%@",strExtension);
                
                if([DROPBOX_IMAGE_EXTENSION rangeOfString:strExtension].length>0 ){
                    [dict setObject:@"1" forKey:@"content_type"];
                }
                else if ([DROPBOX_VIDEO_EXTENSION rangeOfString:strExtension].length>0){
                    [dict setObject:@"2" forKey:@"content_type"];
                }
                else if([DROPBOX_DOC_EXTENSION rangeOfString:strExtension].length>0 || [DROPBOX_TEXT_EXTENSION rangeOfString:strExtension].length>0){
                    [dict setObject:@"3" forKey:@"content_type"];
                }
                
                NSLog(@"option via dropbox..." );
                //[dict setObject:@"image.jpg" forKey:@"filename"];
                [dict setObject:[self.dDropBoxContent valueForKey:@"url"] forKey:@"attachmentUrl"];
                [[AmityCareServices sharedService] uploadDocInvocation:dict uploadData:nil delegate:self];
            }
        }
        else{
            [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Class =%@ \nNSException =%@",[self class],[exception debugDescription]);
    }
}


#pragma mark- TagSelectionVC Delegate
-(void)didFinishAssignTags:(NSMutableArray *)arrSEL
{
    tfUploadTags.text = @"";
    
    NSString *strTags = @"";
    
    for (int i=0; i< [arrSEL count]; i++) {
        
        Tags *t  = [arrSEL objectAtIndex:i];
        
        if(t.isSelected){
            strTags = [strTags stringByAppendingFormat:@"%@, ",t.tagTitle];
        }
    }
    
    if(strTags.length>0)
    {
        strTags = [strTags substringToIndex:([strTags length]-2)]; //remove space and comma
    }
    
    if(arrTags != nil)
    {
        arrTags = [[NSMutableArray alloc] initWithArray:arrSEL];
    }
    
    //[tfUploadTags performSelector:@selector(setText:) withObject:strTags afterDelay:0.1];
    tfUploadTags.text = strTags;
    
    /*
     for (int i=0; i< [arrTags count]; i++) {
     
     Tags *t1 = [arrTags objectAtIndex:i];
     
     for (int j =0; j < [arrSEL count]; j++) {
     
     Tags *t2 = [arrSEL objectAtIndex:j];
     
     if([t1.tagId isEqualToString:t2.tagId])
     {
     t1.isSelected = TRUE;
     }
     }
     }
     */
    
}
#pragma mark- ACAlertView
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DOC_UPDATED_SUCCESSFULLY)
    {
        /* id controller = [self.navigationController viewControllers];
         
         for (id temp  in controller) {
         if([temp isKindOfClass:[UserFeedsVC class]])
         {
         [self.navigationController popToViewController:temp animated:YES];
         }
         }*/
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_POST_UPDATE object:nil];
        
        [self.view removeFromSuperview];
    }
    
}
#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

-(void)resignTextField
{
    [tfUploadTitle resignFirstResponder];
    [tfUploadTags resignFirstResponder];
    [txtVwUploadDesc resignFirstResponder];
    
}
- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self scrollViewToCenterOfScreen:textField];
    [textField setInputAccessoryView:keyboardtoolbar];
    
    if(DEVICE_OS_VERSION_7_0)
    {
        keyboardtoolbar.barStyle = UIBarStyleDefault;
        
    }
    
    for (int n=0; n<[fieldsArray count]; n++)
    {
        if ([fieldsArray objectAtIndex:n]==textField)
            
        {
            if (n==[fieldsArray count]-2)
            {
                [barButton setStyle:UIBarButtonItemStyleDone];
            }
        }
    }
    
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollViewToCenterOfScreen:textView];
    
}
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(IS_DEVICE_IPAD){
    }
    else
    {
        if (textField) {
            [textField resignFirstResponder];
            
            
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
        }
        
    }
    
    return YES;
}

- (IBAction) next
{
    for (int n=0; n<[fieldsArray count]; n++)
    {
        if ([[fieldsArray objectAtIndex:n] isEditing] && n!=[fieldsArray count]-1)
        {
            
            [[fieldsArray objectAtIndex:n+1] becomeFirstResponder];
            
            if (n+1==[fieldsArray count]-1)
            {
                [barButton setTitle:@"Done"];
                [barButton setStyle:UIBarButtonItemStyleDone];
            }else
            {
                [barButton setTitle:@"Done"];
                [barButton setStyle:UIBarButtonItemStyleDone];
            }
            
            break;
        }
        
    }
}

- (IBAction) previous
{
    for (int n=0; n<[fieldsArray count]; n++)
    {
        
        if ([[fieldsArray objectAtIndex:n] isEditing]&& n!=0)
        {
            
            [[fieldsArray objectAtIndex:n-1] becomeFirstResponder];
            [barButton setTitle:@"Done"];
            [barButton setStyle:UIBarButtonItemStyleDone];
            
            break;
        }
        
    }
}

- (IBAction) dismissKeyboard:(id)sender
{
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    [self resignTextField];
    
}

-(IBAction) slideFrameUp:(UITextField *)textField
{
    if (textField.tag == 3) {
        value = 1;
    }
    else if(textField.tag == 4) {
        value = 2;
    }
    else if(textField.tag == 5) {
        value = 3;
    }
    [self slideFrame:YES];
}

-(IBAction) slideFrameDown
{
    [self slideFrame:NO];
}
-(void) slideFrame:(BOOL) up
{
    NSLog(@"11111");
    
    if(value == 1){
        
        NSLog(@"2222");
        
        
        movementDistance = 70;
        movementDuration = 0.3f;
    }
    else if(value == 2) {
        movementDistance = 120;
        movementDuration = 0.3f;
    }
    else if(value == 3){
        movementDistance = 210;
        movementDuration = 0.3f;
    }
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


#pragma mark- UITextField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:tfUploadTitle]){
        return TRUE;
    }
    else if([textField isEqual:tfUploadTags])
    {
        
        if (IS_DEVICE_IPAD) {
            
            self.tagS = [[TagSelectionVC alloc] initWithNibName:@"TagSelectionVC" bundle:nil];
            
        }
        else
        {
            self.tagS = [[TagSelectionVC alloc] initWithNibName:@"TagSelectionVC_iphone" bundle:nil];
            
        }
        
        [txtVwUploadDesc resignFirstResponder];
        [tfUploadTags resignFirstResponder];
        [tfUploadTags resignFirstResponder];
        
        self.tagS.multipleSelection = TRUE;
        self.tagS.tagDelegate = self;
        self.tagS.arrSelectedTags = arrTags;
        self.tagS.checkRecieptSelection=FALSE;

        [self.view addSubview:self.tagS.view];
        
        // [self.navigationController pushViewController:tagS animated:YES];
        return FALSE;
    }
    return TRUE;
}

#pragma mark- UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!IS_DEVICE_IPAD) {
        
        [textView setInputAccessoryView:keyboardtoolbar];
        
    }
    
    if (txtVwUploadDesc.textColor == [UIColor lightGrayColor]) {
        txtVwUploadDesc.text = @"";
        txtVwUploadDesc.textColor = [UIColor blackColor];
    }
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(txtVwUploadDesc.text.length == 0)
    {
        txtVwUploadDesc.text = @"Enter description";
        txtVwUploadDesc.textColor = [UIColor lightGrayColor];
        [txtVwUploadDesc resignFirstResponder];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(!(textView.textColor == [UIColor lightGrayColor]))
    {
        // strAbtDesc = textView.text;
    }
}

#pragma mark- Invocation

-(void)uploadDocInvocationDidFinish:(UploadDocInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"uploadDocInvocationDidFinish =%@",dict);
    
    @try {
        
        if(!error)
        {
            id response = [dict valueForKey:@"response"];
            
            NSString *strSuccess = [response valueForKey:@"success"];
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                checkClockOutTimer=@"upload";
                
                ACAlertView *alert = [ConfigManager alertView:nil message:NULL_TO_NIL([response valueForKey:@"message"]) del:self];
                alert.alertTag = AC_ALERTVIEW_DOC_UPDATED_SUCCESSFULLY;
                [alert show];
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
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

#pragma mark orientation delegates

- (BOOL)shouldAutorotate {
    
    if (IS_DEVICE_IPAD) {
        
        return YES;
        
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    if (IS_DEVICE_IPAD) {
        
        return UIInterfaceOrientationMaskAll;
        
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            sharedAppDelegate.isPortrait=YES;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            sharedAppDelegate.isPortrait=NO;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,750)];
            
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];
}

@end
