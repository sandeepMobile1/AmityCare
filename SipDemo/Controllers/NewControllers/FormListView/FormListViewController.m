//
//  FormListViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
// new admin password = Mgh3294831

#import "FormListViewController.h"
#import "Form.h"
#import "FormsField.h"
#import "FormListVC.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface FormListViewController ()

@end

@implementation FormListViewController

@synthesize formNameArr,formsArr,tagId,arrTotalFormList,flvc,folderName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        
        
        if (sharedAppDelegate.isPortrait) {
            
            if ([sharedAppDelegate.userObj.role isEqualToString:@"5"]) {
                
                if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                    
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                    
                }
                else
                {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 886)];
                    
                }
            }
            else if([sharedAppDelegate.userObj.role isEqualToString:@"3"])
            {
                if ([sharedAppDelegate.strCheckUserAndTag isEqualToString:@"User"]) {
                    
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                    
                }
                else
                {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 855)];
                    
                }
            }
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                
            }
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
   // [tblView reloadData];
    
    self.formsArr=[[NSMutableArray alloc] init];
    self.formNameArr=[[NSMutableArray alloc] init];
    self.arrTotalFormList=[[NSMutableArray alloc] init];
//    
    [self requestForGetFormList];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
        
    }
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)requestForGetFormList
{
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching form data..." width:200];
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        [tempDic setObject:self.tagId forKey:@"tag_id"];
        
        [[AmityCareServices sharedService] getFormNameInvocation:tempDic delegate:self];
    }
    else
    {
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    
    
}

#pragma mark UITableView delegate Mehtods--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)[self.arrTotalFormList count]);
    
    return [self.formsArr count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 44;
    Form *data=[self.formsArr objectAtIndex:indexPath.row];
    
    NSLog(@"%@",data.strNumber);
    
   /* CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBounds.size;
    
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",data.strNumber]];
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:aString];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(screenSize.width, FLT_MAX)];
    
    
    NSAttributedString *aStringName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",data.strFormTitleStr]];
    UITextView *calculationViewName = [[UITextView alloc] init];
    [calculationViewName setAttributedText:aStringName];
    CGSize sizeName = [calculationViewName sizeThatFits:CGSizeMake(screenSize.width, FLT_MAX)];
*/
    int height=0;

    if (IS_DEVICE_IPAD) {
        
        //CGSize size = [data.strNumber sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,130000)lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [data.strNumber boundingRectWithSize:CGSizeMake(200,130000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                                       context:nil];
        
        CGSize size = textRect.size;
        
        data.strFormTitleStr= [data.strFormTitleStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        CGSize sizeName;
        if (data.strNumber.length>0) {
          
            CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(200,130000)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                     context:nil];
            
            sizeName = textRectName.size;

        }
        else
        {
            CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(400,130000)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                     context:nil];
            
            sizeName = textRectName.size;
        }
        
        NSLog(@"%f",sizeName.height);
        NSLog(@"%f",size.height);
        
        if (sizeName.height> size.height) {
            
            height=sizeName.height;
        }
        else
        {
            height=size.height;
            
        }

        
        
    }
    else
    {
        // CGSize size = [data.strNumber sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(130,130000)lineBreakMode:NSLineBreakByWordWrapping];
        data.strFormTitleStr= [data.strFormTitleStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        CGRect textRect = [data.strNumber boundingRectWithSize:CGSizeMake(130,130000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                                       context:nil];
        
        CGSize size = textRect.size;
        
        
        
        CGSize sizeName;
        if (data.strNumber.length>0) {

        CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(130,130000)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                                                 context:nil];
        
        sizeName = textRectName.size;
            
        }
        else
        {
            CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(250,130000)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                     context:nil];
            
            sizeName = textRectName.size;
        }
        
        NSLog(@"%f",sizeName.height);
        NSLog(@"%f",size.height);
        
        if (sizeName.height> size.height) {
            
            height=sizeName.height;
        }
        else
        {
            height=size.height;
            
        }

        
    }
    
       return height+20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* formCellIdentifier = @"FeedListCell";
    
    UITableViewCell *formCell = [tableView dequeueReusableCellWithIdentifier:formCellIdentifier];
    Form *data=[self.formsArr objectAtIndex:indexPath.row];
    
    [formCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    if(!formCell)
    {
        formCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:formCellIdentifier];
        
        [formCell setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lblName=[[UILabel alloc] init];
       
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setTag:5];
        lblName.numberOfLines=0;

        if(DEVICE_OS_VERSION_7_0)
            [formCell.contentView addSubview:lblName];
        else
            [formCell addSubview:lblName];
        
        
        UILabel *lblNumber=[[UILabel alloc] init];
        [lblNumber setBackgroundColor:[UIColor clearColor]];
        [lblNumber setTag:3];
        lblNumber.numberOfLines=0;
        
        if(DEVICE_OS_VERSION_7_0)
            [formCell.contentView addSubview:lblNumber];
        else
            [formCell addSubview:lblNumber];
        
        
    }
    
    
    
    UILabel *lbl=(UILabel*)[formCell viewWithTag:5];
    
    [lbl setText:data.strFormTitleStr];
    
    UILabel *lbl2=(UILabel*)[formCell viewWithTag:3];
    
    [lbl2 setText:[NSString stringWithFormat:@"%@",data.strNumber]];
    
    if (IS_DEVICE_IPAD) {
        
        //CGSize size = [data.strNumber sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,130000)lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [data.strNumber boundingRectWithSize:CGSizeMake(200,130000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                                       context:nil];
        
        CGSize size = textRect.size;
        
        [lbl2 setFrame:CGRectMake(215, 7,200,size.height)];
        [lbl2 setFont:[UIFont systemFontOfSize:11]];
        [lbl2 setTextAlignment:NSTextAlignmentLeft];
        
        data.strFormTitleStr= [data.strFormTitleStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (lbl2.text.length>0) {
            
            CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(200,130000)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                     context:nil];
            
            CGSize sizeName = textRectName.size;
            
            [lbl setFrame:CGRectMake(10, 7,200,sizeName.height)];
            [lbl setFont:[UIFont systemFontOfSize:15]];
            [lbl setTextAlignment:NSTextAlignmentLeft];
        }
        else
        {
            CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(400,130000)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                     context:nil];
            
            CGSize sizeName = textRectName.size;
            
            [lbl setFrame:CGRectMake(10, 7,400,sizeName.height)];
            [lbl setFont:[UIFont systemFontOfSize:15]];
            [lbl setTextAlignment:NSTextAlignmentLeft];
        }
        
    }
    else
    {
        // CGSize size = [data.strNumber sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(130,130000)lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect textRect = [data.strNumber boundingRectWithSize:CGSizeMake(130,130000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                                       context:nil];
        
        CGSize size = textRect.size;
        
        
        [lbl2 setFrame:CGRectMake(140, 7,130,size.height)];
        [lbl2 setFont:[UIFont systemFontOfSize:11]];
        [lbl2 setTextAlignment:NSTextAlignmentLeft];
        
        data.strFormTitleStr= [data.strFormTitleStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (lbl2.text.length>0) {
            
            CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(130,130000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            
            CGSize sizeName = textRectName.size;
            
            NSLog(@"%f",sizeName.height);
            
            [lbl setFrame:CGRectMake(5, 7,130,sizeName.height)];
            [lbl setFont:[UIFont systemFontOfSize:15]];
            [lbl setTextAlignment:NSTextAlignmentLeft];

        }
        else
        {
            CGRect textRectName = [data.strFormTitleStr boundingRectWithSize:CGSizeMake(250,130000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            
            CGSize sizeName = textRectName.size;
            
            NSLog(@"%f",sizeName.height);
            
            [lbl setFrame:CGRectMake(5, 7,250,sizeName.height)];
            [lbl setFont:[UIFont systemFontOfSize:15]];
            [lbl setTextAlignment:NSTextAlignmentLeft];

        }
        
        
    }
    
    

    //[lbl setText:[self.formNameArr objectAtIndex:indexPath.row]];
    
    
    return formCell;
    
}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 25.0)];
    [customView setBackgroundColor:[UIColor grayColor]];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.frame = CGRectMake(5.0, 2, 300.0, 20.0);
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    [customView addSubview:headerLabel];
    
    if (section==0) {
        
        [headerLabel setText:@"Single Forms"];
        
    }
    else if(section==1)
    {
        [headerLabel setText:@"Multiple Forms"];
        
    }
    else
    {
        [headerLabel setText:@"Dynamic Forms"];
    }
    
    return customView;
}*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IS_DEVICE_IPAD) {
        
        self.flvc= [[FormListVC alloc] initWithNibName:@"FormListVC" bundle:nil];
        
    }
    else
    {
        self.flvc= [[FormListVC alloc] initWithNibName:@"FormListVC_iphone" bundle:nil];
        
    }
    
  self.flvc.formData=[self.formsArr objectAtIndex:indexPath.row];

    self.flvc.formNameStr=self.flvc.formData.strFormTitleStr;
    
    if (IS_DEVICE_IPAD) {
     
       // [self.view addSubview:self.flvc.view];
        
        [sharedAppDelegate.window addSubview:self.flvc.view];


    }
    else
    {
        [sharedAppDelegate.window addSubview:self.flvc.view];

    }
}
#pragma mark - Form List Invocation Delegates

- (void)getFormNameInvocationDidFinish:(GetFormNameInvacation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"getFormNameInvocationDidFinish =%@",dict);
    @try {
        if(!error)
        {
            [self.formNameArr removeAllObjects];
            [self.formsArr removeAllObjects];
            [self.arrTotalFormList removeAllObjects];
            
            NSString* strSuccess = NULL_TO_NIL([dict valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                NSArray* formTag = [dict valueForKey:@"FormTag"];
                
                if([formTag count]>0)
                {
                    for (int i=0; i < [formTag count]; i++)
                    {
                        Form *form = [[Form alloc] init];
                        
                        NSDictionary *fDict = [formTag objectAtIndex:i];
                        
                        form.strFormId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                        form.strFormTitleStr = NULL_TO_NIL([fDict valueForKey:@"title"]);
                        form.strFormType = NULL_TO_NIL([fDict valueForKey:@"form_type"]);
                        form.strNumberOfPages = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"numberOfPages"])];
                        form.strFormRoleId = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"roleId"])];
                        form.strBeaconStatus = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"ibeacons"])];
                        
                        form.strBeaconDeviceName = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"device_name"])];
                        form.strBeaconUuid = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"uuid"])];
                        form.strBeaconMajorValue = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"major"])];
                        form.strBeaconMinorValue = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"minor"])];
                        
                        //  form.strNumber = [NSString stringWithFormat:@"%@",NULL_TO_NIL([fDict valueForKey:@"number"])];
                        
                        NSMutableArray *numberArray=NULL_TO_NIL([fDict valueForKey:@"number"]);
                        
                        if ([numberArray count]>0) {
                            
                            NSMutableArray *numArray=[[NSMutableArray alloc] init];
                            
                            for (int i=0; i<[numberArray count]; i++) {
                                
                                NSString *strQue=[[numberArray objectAtIndex:i] objectForKey:@"label_name"];
                                NSString *strNum=[NSString stringWithFormat:@"%@",[[numberArray objectAtIndex:i] objectForKey:@"label_value"]];
                                
                                NSString *strTotalNumber=[NSString stringWithFormat:@"%@: %@",strQue,strNum];
                                
                                [numArray addObject:strTotalNumber];
                                
                            }
                            
                            NSString* joinedString = [numArray componentsJoinedByString:@"\n"];
                            
                            form.strNumber=[NSString stringWithFormat:@"%@",joinedString];
                            
                        }
                        else
                        {
                            form.strNumber=@"";
                        }
                        
                        NSString *audioStr=NULL_TO_NIL([fDict valueForKey:@"audio"]);
                        NSString *videoStr=NULL_TO_NIL([fDict valueForKey:@"video"]);
                        NSString *imageStr=NULL_TO_NIL([fDict valueForKey:@"image"]);
                        
                        if (audioStr.length>0) {
                            
                            NSString *audioUrl=[NSString stringWithFormat:@"%@%@",audioOutputUrl,audioStr];
                            
                            NSString* userAgent;
                            if (IS_DEVICE_IPAD) {
                                
                                userAgent=@"iPad";
                                
                            }
                            else
                            {
                                userAgent=@"iPhone";
                                
                                
                            }
                            
                            NSURL* url = [NSURL URLWithString:audioUrl];
                            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url]
                            ;
                            [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
                            
                            NSURLResponse* response = nil;
                            NSError* error = nil;
                            NSData* audioData = [NSURLConnection sendSynchronousRequest:request
                                                                      returningResponse:&response
                                                                                  error:&error];
                            
                            NSDate *date2 = [NSDate date];
                            time_t
                            interval1 = (time_t) [date2 timeIntervalSince1970];
                            NSTimeInterval timeInMiliseconds1 = [[NSDate date] timeIntervalSince1970];
                            
                            NSString *timestampStr1= [NSString stringWithFormat:@"%ld%f", interval1,timeInMiliseconds1];
                            NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                            
                            documentsDirectory1=[documentsDirectory1 stringByAppendingPathComponent:timestampStr1];
                            NSString *savedAudioLocalPath = [documentsDirectory1 stringByAppendingFormat:@"%@",@"savedAudio.m3u8"];
                            [audioData writeToFile:savedAudioLocalPath atomically:NO];
                            
                            form.strFormOutputAudio = savedAudioLocalPath;
                        }
                        else
                        {
                            form.strFormOutputAudio=@"";
                        }
                        
                        if (![imageStr isEqualToString:@""]) {
                            
                            form.strFormOutputImage=[NSString stringWithFormat:@"%@%@",originalOutputImageURL,imageStr];
                            
                        }
                        else
                        {
                            form.strFormOutputImage=@"";
                        }
                        
                        
                        form.strFormOutputVideo = videoStr;
                        
                        NSLog(@"%@",form.strFormOutputVideo);
                        NSLog(@"%@",form.strFormOutputImage);
                        
                        
                        [self.formNameArr addObject:NULL_TO_NIL([fDict valueForKey:@"title"])];
                        
                        [self.formsArr addObject:form];
                        
                        
                        
                    }
                    
                    
                }
                else
                {
                    [self.formNameArr removeAllObjects];
                    [self.formsArr removeAllObjects];
                    [ConfigManager showAlertMessage:nil Message:@"No Form found"];
                }
                
            }
            else
            {
                [self.formNameArr removeAllObjects];
                [self.formsArr removeAllObjects];
                [ConfigManager showAlertMessage:nil Message:@"No form found"];
            }
            
        }
        else
        {
            [self.formNameArr removeAllObjects];
            [self.formsArr removeAllObjects];
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
        
        for (int i = 0; i < 3; i++) [self.arrTotalFormList addObject:[[NSMutableArray alloc] init] ];
      /*
        
        for(int i=0;i<[self.formsArr count];i++)
        {
            Form *form=[self.formsArr objectAtIndex:i];
            
            if ([form.strFormType isEqualToString:@"1"]) {
                
                [[self.arrTotalFormList objectAtIndex:0]addObject:form];
                
            }
            else if([form.strFormType isEqualToString:@"2"])
            {
                [[self.arrTotalFormList objectAtIndex:1]addObject:form];
                
            }
            else
            {
                [[self.arrTotalFormList objectAtIndex:2]addObject:form];
                
            }
        }*/
        
        
        NSLog(@"%lu",(unsigned long)[self.arrTotalFormList count]);
        [tblView reloadData];
        
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
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
  
    [super viewDidDisappear:YES];

   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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
