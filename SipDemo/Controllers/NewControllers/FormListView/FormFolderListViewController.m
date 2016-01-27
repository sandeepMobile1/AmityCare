//
//  FormFolderListViewController.m
//  SipDemo
//
//  Created by Shweta Sharma on 16/06/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "FormFolderListViewController.h"
#import "Form.h"
#import "FormsField.h"
#import "FormListVC.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "FormListViewController.h"

@interface FormFolderListViewController ()

@end

@implementation FormFolderListViewController

@synthesize arrFolderList;
@synthesize formNameArr,formsArr,tagId,arrTotalFormList,objFormListViewController;

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
    self.arrFolderList=[[NSMutableArray alloc] initWithObjects:@"Single Form",@"Multiple Form",@"Dynamic Form",nil];

    
    self.formsArr=[[NSMutableArray alloc] init];
    self.formNameArr=[[NSMutableArray alloc] init];
    self.arrTotalFormList=[[NSMutableArray alloc] init];
    
    [self requestForGetFormList];

    // Do any additional setup after loading the view from its nib.
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
    return [self.arrFolderList count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* formCellIdentifier = @"FeedListCell";
    
    UITableViewCell *formCell = [tableView dequeueReusableCellWithIdentifier:formCellIdentifier];
    
    if(!formCell)
    {
        formCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:formCellIdentifier];
        
        [formCell setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lblName=[[UILabel alloc] init];
        if (IS_DEVICE_IPAD) {
            
            [lblName setFrame:CGRectMake(10, 5,200,35)];
            [lblName setFont:[UIFont systemFontOfSize:15]];
            
        }
        else
        {
            [lblName setFrame:CGRectMake(5, 5,130,35)];
            [lblName setFont:[UIFont systemFontOfSize:15]];
            
        }
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setTag:2];
        [lblName setFont:[UIFont systemFontOfSize:15]];

        if(DEVICE_OS_VERSION_7_0)
            [formCell.contentView addSubview:lblName];
        else
            [formCell addSubview:lblName];
        
        
    }
    
    UILabel *lbl=(UILabel*)[formCell viewWithTag:2];
    
    [lbl setText:[self.arrFolderList objectAtIndex:indexPath.row]];
    
        
    return formCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_DEVICE_IPAD) {
        
        self.objFormListViewController=[[FormListViewController alloc] initWithNibName:@"FormListViewController" bundle:nil];

    }
    else
    {
        self.objFormListViewController=[[FormListViewController alloc] initWithNibName:@"FormListViewController_iphone" bundle:nil];

    }
    self.objFormListViewController.arrTotalFormList=[[NSMutableArray alloc] init];
    self.objFormListViewController.formNameArr=[[NSMutableArray alloc] init];
    self.objFormListViewController.formsArr=[[NSMutableArray alloc] init];
    
    NSLog(@"%lu",(unsigned long)[self.arrTotalFormList count]);

    
    if (indexPath.row==0) {
        
        
        self.objFormListViewController.arrTotalFormList=[self.arrTotalFormList objectAtIndex:0];
    }
    else if(indexPath.row==1)
    {
        
        self.objFormListViewController.arrTotalFormList=[self.arrTotalFormList objectAtIndex:1];
    }
    else
    {
        self.objFormListViewController.arrTotalFormList=[self.arrTotalFormList objectAtIndex:2];
    }
    
   
    self.objFormListViewController.formNameArr=self.formNameArr;
    self.objFormListViewController.formsArr=self.formsArr;
    self.objFormListViewController.tagId=self.tagId;
    
    [self.view addSubview:self.objFormListViewController.view];
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
                            
                            form.strNumber=joinedString;
                            
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
        }
        
        
        NSLog(@"%lu",(unsigned long)[self.arrTotalFormList count]);
        [tblView reloadData];
        
        [DSBezelActivityView removeView];
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
