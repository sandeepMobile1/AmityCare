//
//  UserSelectionVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 05/05/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "UserSelectionVC.h"
#import "UIImageView+WebCache.h"

#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"
#import "UserListInvocation.h"

@interface UserSelectionVC (Private)<UserListInvocationDelegate>

@end

@implementation UserSelectionVC
@synthesize delegate;
@synthesize arrSelectedUser,tagId;

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
    
        
    //[self.view addSubview:navigation];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
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
    
    arrUsersData = [[NSMutableArray alloc] init];
    
    [self performSelector:@selector(requestUsersList) withObject:nil afterDelay:0.1f];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-  Navigation Delegate
-(void)leftBarButtonDidClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonDidClicked:(id)sender
{
    BOOL flag = FALSE;
    //User *selUser = nil;
    
    NSMutableArray* arrSelU = [[NSMutableArray alloc] init];
    
    for (User *u in arrUsersData) {
        if(u.isSelected)
        {
            [arrSelU addObject:u];
            flag = TRUE;
        }
    }
    
    if(!flag){
        [ConfigManager showAlertMessage:nil Message:@"Please select user"];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(userDidSelected:)])
        {
            [self.delegate userDidSelected:arrSelU];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)btnDoneAction:(id)sender
{
    BOOL flag = FALSE;
    //User *selUser = nil;
    
    NSMutableArray* arrSelU = [[NSMutableArray alloc] init];
    
    for (User *u in arrUsersData) {
        if(u.isSelected)
        {
            [arrSelU addObject:u];
            flag = TRUE;
        }
    }
    
    if(!flag){
        [ConfigManager showAlertMessage:nil Message:@"Please select user"];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(userDidSelected:)])
        {
            [self.delegate userDidSelected:arrSelU];
        }
        [self.view removeFromSuperview];
    }
}

#pragma mark- Other Methods

-(void)requestUsersList
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Fetching users List..." width:200];
    
    if (self.tagId==nil || self.tagId==(NSString*)[NSNull null]) {
        
        self.tagId=@"";
    }
   // self.tagId=@"";

    [[AmityCareServices sharedService] getUsersListInvocation:sharedAppDelegate.userObj.userId tagId:self.tagId delegate:self];
}

#pragma mark- UITableViewDelegate  & DataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenitifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenitifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    User * u = [arrUsersData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = u.username;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",smallThumbImageURL,u.image]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    if(u.isSelected)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrUsersData count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*  int i =0;
     for (User *u in arrUsersData) {
     if(u.isSelected){
     u.isSelected = !u.isSelected;
     NSIndexPath *ip =[NSIndexPath indexPathForRow:i inSection:0];
     [tblUsersList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:ip, nil] withRowAnimation:UITableViewRowAnimationFade];
     break;
     }
     i++;
     }
     
     User *u = [arrUsersData objectAtIndex:indexPath.row];
     u.isSelected = !u.isSelected;
     
     UITableViewCell *cell = [tblUsersList cellForRowAtIndexPath:indexPath];
     if(u.isSelected) {
     cell.accessoryType = UITableViewCellAccessoryNone;
     }
     else{
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     }
     NSArray *indexArray = [NSArray arrayWithObjects:indexPath, nil];
     
     [tblUsersList reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];*/
    
    User *u = [arrUsersData objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    u.isSelected = !u.isSelected;
    
    if(u.isSelected){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView reloadData];
    
}

#pragma mark - Invocation
-(void)userListInvocationDidFinish:(UserListInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"userListInvocationDidFinish = %@",dict);
    
    @try {
        if (!error) {
            
            id response  =  [dict valueForKey:@"response"];
            NSString *strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess isEqualToString:@"true"])
            {
                NSArray *arrUsr = NULL_TO_NIL([response valueForKey:@"users"]);
                
                for (NSDictionary *dic in arrUsr) {
                    
                    User *u = [[User alloc] init];
                    
                    u.fname = NULL_TO_NIL([dic valueForKey:@"first_name"]);
                    u.lname = NULL_TO_NIL([dic valueForKey:@"last_name"]);
                    u.userId = NULL_TO_NIL([dic valueForKey:@"id"]);
                    u.image = NULL_TO_NIL([dic valueForKey:@"user_img"]);
                    u.username = NULL_TO_NIL([dic valueForKey:@"nickname"]);
                    u.role = NULL_TO_NIL([dic valueForKey:@"user_type"]);
                    
                    u.fname= [u.fname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if (u.fname.length>0) {
                        
                        [arrUsersData addObject:u];

                    }
                }
                
                for (User* _selUsr in self.arrSelectedUser) {
                    
                    for (User* _u in arrUsersData) {
                        
                        if([_selUsr.userId isEqualToString:_u.userId]){
                            
                            _selUsr.fname= [_selUsr.fname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
                            if (_selUsr.fname.length>0) {
                                
                                _u.isSelected = TRUE;
                                break;
                            }
                            
                           
                        }
                    }
                }
                
                [tblUsersList reloadData];
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
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}


@end
