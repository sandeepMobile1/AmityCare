//
//  InboxListingViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import "InboxListingViewController.h"
#import "InboxData.h"
#import "InboxDetailViewController.h"
#import "NSString+urlDecode.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
@interface InboxListingViewController ()

@end

@implementation InboxListingViewController

@synthesize arrInboxListing,tagId,selectedRowIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.arrInboxListing=[[NSMutableArray alloc] init];
    
    if([ConfigManager isInternetAvailable]) {
        
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching inbox list Please wait..." width:220];
        
        [[AmityCareServices sharedService] InboxListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId delegate:self];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (!IS_DEVICE_IPAD) {
        
        if (DEVICE_OS_VERSION>=7) {
            
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [tblView setFrame:CGRectMake(0, 54, 320, 510)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [tblView setFrame:CGRectMake(0, 54, 320, 510-IPHONE_FIVE_FACTOR)];
                
            }
            
        }
        else
        {
            if (IS_IPHONE_5) {
                
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
                [tblView setFrame:CGRectMake(0, 54, 320, 500)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
                
                [tblView setFrame:CGRectMake(0, 54, 320, 500-IPHONE_FIVE_FACTOR)];
                
            }
            
        }
        
    }
    
}
-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"Edit"])
    {
        [tblView setEditing:YES animated:YES];
        
        [btn setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"Edit" forState:UIControlStateNormal];
        
        [tblView setEditing:NO animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrInboxListing count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (InboxListTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (Nil == cell)
    {
        cell = [InboxListTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    InboxData *data=[self.arrInboxListing objectAtIndex:indexPath.row];
    
    cell.lblDate.text=data.mailDate;
    cell.lblSubject.text=data.mailSubject;
    cell.lblTitle.text=data.mailFrom;
    
    
    cell.lblMessage.attributedText=data.mail_short_desc;
    
    [cell.lblMessage setFont:[UIFont systemFontOfSize:13]];
    
    
    if(data.mailAttechment!=nil )
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attachment.png"]] ;
        imageView.frame =CGRectMake(0, 0, 18, 18);
        cell.accessoryView = imageView;
    }
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InboxDetailViewController *objInboxDetailViewController=[[InboxDetailViewController alloc] init];
    
    objInboxDetailViewController.arrMailData=[[NSMutableArray alloc] initWithArray:self.arrInboxListing];
    objInboxDetailViewController.selectedIndex=indexPath.row;
    [self.navigationController pushViewController:objInboxDetailViewController animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowIndex = indexPath.row;
    
    ACAlertView* deleteAlert = [[ACAlertView alloc] initWithTitle:nil message:@"Delete Mail ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    deleteAlert.alertTag = AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION;
    [deleteAlert show];
}

#pragma mark- UIALERTVIEW
-(void)alertView:(ACAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertTag == AC_ALERTVIEW_DELETE_NOTIFICATION_CONFIRMATION)
    {
        if(buttonIndex==0){
            
            NSLog(@"Index Path %lu",(unsigned long)selectedRowIndex);
            
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
            InboxData* inbox = [arrInboxListing objectAtIndex:selectedRowIndex];
            
            [[AmityCareServices sharedService] DeleteMailInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId mailId:inbox.mailId delegate:self];
        }
    }
}

#pragma mark- Webservice delegate

-(void)InboxListInvocationDidFinish:(InboxListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"%@",dict);
    [self.arrInboxListing removeAllObjects];
    
    @try {
        if(!error)
        {
            
            NSArray* mail = [dict valueForKey:@"email"];
            
            if ([mail count]>0) {
                
                for (int i=0; i < [mail count]; i++) {
                    
                    NSDictionary *tDict = [mail objectAtIndex:i];
                    
                    InboxData *inbox=[[InboxData alloc] init];
                    
                    inbox.mailId=NULL_TO_NIL([tDict valueForKey:@"id"]);
                    inbox.mailTitle=NULL_TO_NIL([tDict valueForKey:@"email"]);
                    inbox.mailSubject=NULL_TO_NIL([tDict valueForKey:@"subject"]);
                    inbox.mailAttechment=NULL_TO_NIL([tDict valueForKey:@"attachement"]);
                    inbox.mailTo=NULL_TO_NIL([tDict valueForKey:@"to"]);
                    inbox.mailFrom=NULL_TO_NIL([tDict valueForKey:@"from"]);
                    inbox.mailDate=NULL_TO_NIL([tDict valueForKey:@"date"]);
                    
                    NSString *msgStr=NULL_TO_NIL([tDict valueForKey:@"message"]);
                    
                    
                    inbox.mailMessage = [msgStr stringByDecodingURLFormat] ;
                    
                    
                    msgStr= [msgStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSMutableString *tempStr= [NSMutableString stringWithFormat:@"%@",[msgStr stringByDecodingURLFormat]];
                    
                    [tempStr replaceOccurrencesOfString:@"img src" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[tempStr length]}];
                    
                    
                    if (DEVICE_OS_VERSION>=7) {
                        
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[tempStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        
                        inbox.mail_short_desc=attributedString;
                    }
                    else
                    {
                        // NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
                        
                        // NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:nil];
                        
                        //inbox.mail_short_desc=attributedString;
                        inbox.mail_short_desc=[[NSAttributedString alloc] initWithString:tempStr attributes:nil];
                    }
                    
                    
                    
                    [self.arrInboxListing addObject:inbox];
                    
                }
            }
            
            [tblView reloadData];
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

-(void)DeleteMailInvocationDidFinish:(DeleteMailInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    {
        NSLog(@"deleteContactInvocationDidFinish =%@",dict);
        @try {
            if (!error) {
                
                id response = [dict valueForKey:@"email"];
                NSString* strSuccess = [response valueForKey:@"success"];
                
                if(strSuccess==nil || strSuccess==(NSString*)[NSNull null]){
                    
                    [ConfigManager showAlertMessage:nil Message:@"Mail not deleted"];
                    
                }
                else
                    [arrInboxListing removeObjectAtIndex:selectedRowIndex];
                
                [tblView reloadData];
                
            }
            else
            {
                [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception =%@",[exception description]);
        }
        @finally {
            [DSBezelActivityView removeView];
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
