//
//  OCRReceiptListViewController.m
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "OCRReceiptListViewController.h"
#import "OCRReaderViewController.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "ConfigManager.h"
#import "OcrData.h"
#import "DSActivityView.h"
#import "Common.h"
#import "OcrTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface OCRReceiptListViewController ()

@end

@implementation OCRReceiptListViewController

@synthesize objOCRReaderViewController;

@synthesize arrOcrRecieptList,selectedIndxpath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrOcrRecieptList=[[NSMutableArray alloc] init];
    
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
            /*else if([sharedAppDelegate.userObj.role isEqualToString:@"6"]|| [sharedAppDelegate.userObj.role isEqualToString:@"8"])
             {
             [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 886)];
             
             }*/
            else
            {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
                
            }
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 675)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForOcrList) name: AC_OCR_UPDATE object:nil];
    
    
    [self performSelector:@selector(requestForOcrList) withObject:nil afterDelay:0.1];
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnOcrReaderAction:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        self.objOCRReaderViewController=[[OCRReaderViewController alloc] initWithNibName:@"OCRReaderViewController" bundle:nil];
        
    }
    else
    {
        self.objOCRReaderViewController=[[OCRReaderViewController alloc] initWithNibName:@"OCRReaderViewController_iphone" bundle:nil];
        
    }
    
    [self.view addSubview:self.objOCRReaderViewController.view];
}
-(void)requestForOcrList
{
    
    
    if([ConfigManager isInternetAvailable]){
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Getting OCR reciept list..." width:200];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        
        [[AmityCareServices sharedService] OcrListInvocation:dic delegate:self];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
}

#pragma mark- UITableView Delegate
#pragma mark- UITableViewDataSource Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.arrOcrRecieptList count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    float height=0;
    
    if (IS_DEVICE_IPAD) {
        
        height=130;
    }
    else
    {
        height=170;
    }
    
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ocrCellIdentifier = @"OcrCell";
    
    
    ocrCell= (OcrTableViewCell*)[tblView dequeueReusableCellWithIdentifier:ocrCellIdentifier];
    
    
    if (Nil == ocrCell)
        
    {
        ocrCell = [OcrTableViewCell createTextRowWithOwner:self withDelegate:self];
        
    }
    [ocrCell setBackgroundColor:[UIColor clearColor]];
    
    OcrData *oData=[self.arrOcrRecieptList objectAtIndex:indexPath.row];
    
    ocrCell.lblTitle.text = oData.ocrTitle;
    ocrCell.lblDate.text = oData.ocrDate;
    //ocrCell.lblAddress.text = oData.ocrAddress;
    //ocrCell.lblAmount.text = oData.ocrAmount;
    //ocrCell.lblNumber.text = oData.ocrNumber;
    ocrCell.lblComment.text = oData.ocrComment;
    
    [ocrCell.imgViewOcr sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",largeBackPackImageURL,oData.ocrImage]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    return ocrCell;
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)OcrListInvocationDidFinish:(OcrListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    
    [self.arrOcrRecieptList removeAllObjects];
    
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            
            NSArray* reminderArray = NULL_TO_NIL([response valueForKey:@"OcrMedia"]);
            
            NSLog(@"%@",reminderArray);
            
            for (int i=0; i< [reminderArray count]; i++) {
                
                NSDictionary *fDict = [reminderArray objectAtIndex:i];
                
                OcrData *oData = [[OcrData alloc] init];
                
                oData.ocrId = NULL_TO_NIL([fDict valueForKey:@"id"]);
                oData.ocrTitle = NULL_TO_NIL([fDict valueForKey:@"title"]);
                oData.ocrImage = NULL_TO_NIL([fDict valueForKey:@"image"]);
                oData.ocrAmount = NULL_TO_NIL([fDict valueForKey:@"amount"]);
                oData.ocrComment = NULL_TO_NIL([fDict valueForKey:@"comment"]);
                oData.ocrAddress = NULL_TO_NIL([fDict valueForKey:@"address"]);
                oData.ocrNumber = NULL_TO_NIL([fDict valueForKey:@"number"]);
                oData.ocrDate = NULL_TO_NIL([fDict valueForKey:@"created"]);
                
                
                [self.arrOcrRecieptList addObject:oData];
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"AppCOntacts EXCEPTION: %@ ",[exception debugDescription]);
    }
    @finally {
        
        tblView.delegate=self;
        tblView.dataSource=self;
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
