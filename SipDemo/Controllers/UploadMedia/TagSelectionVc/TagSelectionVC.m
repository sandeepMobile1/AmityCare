//
//  TagSelectionVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 29/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "TagSelectionVC.h"
#import "Tags.h"
#import "TagsInvocation.h"
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface TagSelectionVC ()<TagsInvocationDelegate>

@end

@implementation TagSelectionVC
@synthesize tagDelegate;
@synthesize arrSelectedTags;
@synthesize arrTagData;
@synthesize multipleSelection,checkRecieptSelection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.arrTagData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* if (!IS_DEVICE_IPAD) {
     
     if (DEVICE_OS_VERSION>=7) {
     
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     [tblViewTags setFrame:CGRectMake(0, 54, 320, 510)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [tblViewTags setFrame:CGRectMake(0, 54, 320, 510-IPHONE_FIVE_FACTOR)];
     
     }
     }
     else
     {
     if (IS_IPHONE_5) {
     
     [self.view setFrame:CGRectMake(0, 0, 320, 568)];
     [tblViewTags setFrame:CGRectMake(0, 54, 320, 500)];
     }
     else
     {
     [self.view setFrame:CGRectMake(0, 0, 320, 480)];
     
     [tblViewTags setFrame:CGRectMake(0, 54, 320, 500-IPHONE_FIVE_FACTOR)];
     
     }
     }
     
     }
     
     
     TopNavigationView *navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
     [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [navigation.rightBarButton setImage:[UIImage imageNamed:@"done.png" ] forState:UIControlStateNormal];
     
     CGRect btnFrame = navigation.rightBarButton.frame;
     btnFrame.origin.x = btnFrame.origin.x-25;
     btnFrame.size.width = 50;
     navigation.rightBarButton.frame = btnFrame;
     
     navigation.lblTitle.text = @"Select Similiar Tags";
     [self.view addSubview:navigation];*/
    
    /*if (IS_DEVICE_IPAD) {
     
     if (sharedAppDelegate.isPortrait) {
     
     [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
     
     }
     else
     {
     [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
     
     }
     
     [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
     
     }*/
    
    self.arrTagData = [[NSMutableArray alloc ] init];
    
    if([ConfigManager isInternetAvailable]){
        [self performSelector:@selector(reqeustUserAssignTags) withObject:nil afterDelay:0.1];
    }
    else{
        [ConfigManager showAlertMessage:nil Message:ALERT_MSG_NO_INTERNET];
    }
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
    }}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Invocation

-(void)reqeustUserAssignTags
{
    //implement
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:LOADING_VIEW_DEFAULT_HEADING width:200];
    [[AmityCareServices sharedService] tagInvocation:sharedAppDelegate.userObj.userId delegate:self];
}

-(void)tagsInvocationDidFinish:(TagsInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    @try {
        
        [DSBezelActivityView removeView] ;
        
        if(!error)
        {
            NSLog(@"Tags = %@",dict);
            id response = [dict valueForKey:@"response"];
            if([response isKindOfClass:[NSDictionary class]])
            {
                [self.arrTagData removeAllObjects];
                NSString *strSuccess = [response valueForKey:@"success"];
                if([strSuccess isEqualToString:@"true"])
                {
                    NSArray *tags = [response valueForKey:@"Tag"];
                    
                    for (int i = 0; i < [tags count]; i++) {
                        
                        NSDictionary *tDict = [tags objectAtIndex:i];
                        
                        Tags *tag = [[Tags alloc] init];
                        
                        tag.tagId = [tDict valueForKey:@"id"];
                        tag.tagTitle = [tDict valueForKey:@"title"];
                        
                        [self.arrTagData addObject:tag];
                        
                    }
                    
                    //set selected tag which user has recently clocked in
                    if([self.arrSelectedTags count]>0)
                    {
                        for (Tags* selTag in arrSelectedTags ) {
                            
                            for (Tags* innerTag in arrTagData) {
                                if([selTag.tagId isEqualToString:innerTag.tagId])
                                {
                                    innerTag.isSelected = TRUE;
                                }
                            }
                        }
                    }
                    else{
                        for (int i=0; i< [self.arrTagData count]; i++) {
                            
                            //Tags *t = [self.arrTagData objectAtIndex:i];
                            
                            /* if([sharedAppDelegate.strSelectedTagId isEqualToString:t.tagId])
                             {
                             t.isSelected = TRUE;
                             break;
                             }*/
                        }
                    }
                    [tblViewTags reloadData];
                }
                else if([strSuccess isEqualToString:@"False"])
                {
                    
                }
            }
            else
            {
                
            }//if response not nsdictionary
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


#pragma mark- TopNavigation Delegate

-(void)leftBarButtonDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonDidClicked:(id)sender
{
    if([self.tagDelegate respondsToSelector:@selector(didFinishAssignTags:)])
    {
        NSMutableArray *arrTagged = [[NSMutableArray alloc] init];
        
        for(Tags *t in self.arrTagData)
        {
            if(t.isSelected)
            {
                [arrTagged addObject:[t copy]];
            }
        }
        if([arrTagged count]>0)
        {
            [self.tagDelegate didFinishAssignTags:arrTagged];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(IBAction)btnDoneAction:(id)sender
{
    if([self.tagDelegate respondsToSelector:@selector(didFinishAssignTags:)])
    {
        NSMutableArray *arrTagged = [[NSMutableArray alloc] init];
        
        for(Tags *t in self.arrTagData)
        {
            if(t.isSelected)
            {
                [arrTagged addObject:[t copy]];
            }
        }
        if([arrTagged count]>0)
        {
            [self.tagDelegate didFinishAssignTags:arrTagged];
            [self.view removeFromSuperview];
            
        }
    }
}
#pragma mark- UITableView DataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"TagCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Tags *t = [self.arrTagData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = t.tagTitle;
    cell.textLabel.font = [UIFont fontWithName:appfontName size:13.0f];
    cell.textLabel.textColor = TEXT_COLOR_GREEN;
    
    if(t.isSelected){
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
    }
    else{
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck.png"]];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTagData count];
}

#pragma mark- UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (checkRecieptSelection==TRUE) {
        
        Tags *t  = [self.arrTagData objectAtIndex:indexPath.row];
        
        sharedAppDelegate.uploadRecieptTagId=t.tagId;
        sharedAppDelegate.uploadRecieptTagName=t.tagTitle;

        [[NSNotificationCenter defaultCenter] postNotificationName: AC_RECIEPT_TAG_SELECTION object:nil];

        [self.view removeFromSuperview];
    }
    else
    {
        Tags *t  = [self.arrTagData objectAtIndex:indexPath.row];
        
        // if(![t.tagId isEqualToString:sharedAppDelegate.strSelectedTagId])
        // {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        t.isSelected = !t.isSelected;
        
        if(t.isSelected){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        // }
        [tableView reloadData];

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


/*
 if(self.isEdit)
 {
 for (int i=0; i< [arrSelTags count]; i++) {
 
 Tags * outerTag = [arrSelTags objectAtIndex:i];
 
 for (int j=0; j< [arrTagData count]; j++) {
 
 Tags *innerTag = [arrTagData objectAtIndex:j];
 
 if([outerTag.tagId isEqualToString:innerTag.tagId])
 {
 innerTag.isSelected = true;
 }
 }
 }
 }
 else
 {
 
 //set selected tag which user has recently clocked in
 for (int i=0; i< [self.arrTagData count]; i++) {
 
 Tags *t = [self.arrTagData objectAtIndex:i];
 
 if([sharedAppDelegate.strSelectedTagId isEqualToString:t.tagId])
 {
 t.isSelected = TRUE;
 break;
 }
 }
 }
 */


@end
