//
//  ViewController.m
//  DropBoxDemo
//
//  Created by Vinod Shau on 19/07/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import "DropBoxManager.h"
#import "TheProjectCell.h"
#import "AppDelegate.h"
#import "DSActivityView.h"
#import "AlertMessage.h"
#import "ConfigManager.h"

#import "UploadMediaFilesVc.h"

@interface DropBoxManager() <TopNavigationViewDelegate>

@end

@implementation DropBoxManager

@synthesize restClient;
@synthesize metaDataHash;
@synthesize nodeList;
@synthesize displayArray;
@synthesize tableView;
@synthesize allPathManager,checkSession,checkView,uploadVc;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    navigation = [[TopNavigationView alloc] initWithFrame:CGRectMake(0, 0, 525, DEVICE_OS_VERSION_7_0?64:44) withRef:self];
    [navigation.leftBarButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    navigation.lblTitle.text = @"Root Folder";
   // [self.view addSubview:navigation];
    
    checkSession=@"NO";

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
    

    self.nodeList=[[NSMutableArray alloc] init];
    self.allPathManager=[[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotificationDidRecieve) name:@"LoginNotification" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
	
  
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([checkSession isEqualToString:@"NO"]) {
        
        [self createSessionAndLinkWithDropBox];
        
    }

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

#pragma mark
#pragma mark Back Button

-(void)createBackButtton{
    
    
    // setting Left Button
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0,4, 59,36)];
    backButton.tag=1;
    [backButton addTarget:self action:@selector(backButtonClickDidClick:) forControlEvents:UIControlEventTouchUpInside];

    UIView *customVw = [[UIView alloc ] initWithFrame: CGRectMake(10, 5, 50, 50)];
    customVw.backgroundColor = [UIColor clearColor];
    [customVw addSubview:backButton];
    
   // self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:customVw];
    
}

-(void)leftBarButtonDidClicked:(id)sender
{
    [self backButtonClickDidClick:sender];
}

-(void)backButtonClickDidClick:(UIButton*)sender{
    
    
    NSLog(@"Back Button Click ");
    
    NSUInteger pathCount=self.allPathManager.count;
    
    
    if (pathCount<=1) {
    
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    else{
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:LOADING_VIEW_DEFAULT_HEADING width:200.0];
            PathManager *tempObj=[self.allPathManager lastObject];
            NSLog(@"~~(%lu) -:%@",(unsigned long)pathCount,tempObj.previousPath);
            [self loadMetaDataWithPath:tempObj.previousPath isBackButtonClick:YES];
        
    }

}



#pragma mark
#pragma mark DropBox DB Session Create

-(void)createSessionAndLinkWithDropBox{
    
    NSString* appKey = @"lmjm14j9bzq632z";
    NSString* appSecret = @"impnhb5a8s0e9no";
    
    
    NSString *root =kDBRootDropbox;
    NSString* errorMsg = nil;
	
    if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound)
    {
		errorMsg = @"Make sure you set the app key correctly in DBRouletteAppDelegate.m";
	}
    else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound)
    {
		errorMsg = @"Make sure you set the app secret correctly in DBRouletteAppDelegate.m";
	}
    else if ([root length] == 0)
    {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
	}
    else
    {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist =
        [NSPropertyListSerialization
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"])
        {
			errorMsg = @"Set your URL scheme correctly in DBRoulette-Info.plist";
		}
	}
	
	DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:appKey
      appSecret:appSecret
      root:root];
    [DBSession setSharedSession:dbSession];
    
	
    if (errorMsg != nil) {
		[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  
		 show];
	}
    
    
    NSLog(@"Link : %d ",[[DBSession sharedSession] isLinked]);
    if ([[DBSession sharedSession] isLinked])
    {
        
        [self loginNotificationDidRecieve];
        
    }
    else{
        checkSession=@"YES";

        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [[DBSession sharedSession] linkFromController:self];
       
    }

}

#pragma mark
#pragma mark LoginNotificationDidRecieve  Create

-(void)loginNotificationDidRecieve{
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:LOADING_VIEW_DEFAULT_HEADING width:200.0];

    NSLog(@"Notification Recieve ");
    [self loadMetaDataWithPath:@"/" isBackButtonClick:NO];
}

-(DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
- (void)loadMetaDataWithPath:(NSString *)path isBackButtonClick:(BOOL)isClick{
    
    
    
    if (self.allPathManager.count>0)
    {
        
        if (isClick) {
          
            PathManager *objTemp1=[self.allPathManager lastObject];
            NSLog(@"P:%@ C:%@ ",objTemp1.previousPath,objTemp1.currentPath);
            [self.allPathManager removeLastObject];
            PathManager *objTemp=[self.allPathManager lastObject];
            NSLog(@"P:%@ C:%@ ",objTemp.previousPath,objTemp.currentPath);
            
        }
        else{
            
            PathManager *objTemp=[self.allPathManager lastObject];
            NSLog(@"PP:%@ CC:%@ ",objTemp.previousPath,objTemp.currentPath);
            PathManager *objPathMnager=[[PathManager alloc] init];
            objPathMnager.previousPath=objTemp.currentPath;
            objPathMnager.currentPath=path;
            [self.allPathManager addObject:objPathMnager];
             NSLog(@"*PP:%@ *CC:%@ ",objPathMnager.previousPath,objPathMnager.currentPath);
        }
        
       
        
    }else{
       
        PathManager *objTemp=[[PathManager alloc] init];
        objTemp.currentPath=path;
        objTemp.previousPath=path;
        [self.allPathManager addObject:objTemp];
        NSLog(@"*:%@ *:%@ ",objTemp.previousPath,objTemp.currentPath);
        
    }
    
    if ([path isEqualToDropboxPath:@"/"]) {
     
        
        //self.title=@"Root Folder";
        navigation.lblTitle.text = @"Root Folder";
        
    }else{
     
        //self.title=[[path lastPathComponent] stringByDeletingPathExtension];
        navigation.lblTitle.text = [[path lastPathComponent] stringByDeletingPathExtension];
        
    }
    
    
     NSLog(@"+:{%lu} %@ ",(unsigned long)self.allPathManager.count,path);
     [self.restClient loadMetadata:path withHash:self.metaDataHash];
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
	
    if (alertView==articalSendAlert) {
        
        if (index==1)
        {
            [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Loading..." width:200];
            [self.restClient loadStreamableURLForFile:selectedlink];
        }
        else
        {
            
        }
    }
    else{
    
        if (index != alertView.cancelButtonIndex) {
            [self createSessionAndLinkWithDropBox];
        }
        
    }
}


#pragma mark
#pragma mark TreeView method

- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.tableView reloadData];
}

//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray=[[NSMutableArray alloc]init];
    for (TreeViewNode *node in self.nodeList) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//These functions are used to expand and collapse all the nodes just connect them to two buttons and they will work
- (IBAction)expandAll:(id)sender
{
    
    [self fillDisplayArray];
    [self.tableView reloadData];
}

- (IBAction)collapseAll:(id)sender
{
    for (TreeViewNode *treeNode in self.nodeList) {
        treeNode.isExpanded = NO;
    }
    [self fillDisplayArray];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.displayArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(IS_DEVICE_IPAD)
        return 60.0;
    else
        return 45.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"treeNodeCell";
    
        UINib *nib;
    
    if (IS_DEVICE_IPAD) {
        
        nib= [UINib nibWithNibName:@"ProjectCell~ipad" bundle:nil];
        
        
    }
    else
    {
        nib= [UINib nibWithNibName:@"ProjectCell" bundle:nil];
        
    }
    
        [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
        TheProjectCell *cell = (TheProjectCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.treeNode = node;
        cell.cellLabel.text = node.fileOrFolderName;
    
    if (IS_DEVICE_IPAD) {
        
        cell.cellLabel.font = [UIFont fontWithName:appfontName size:22.0];

    }
    else
    {
        cell.cellLabel.font = [UIFont fontWithName:appfontName size:16.0];

    }
    
        NSLog(@"node.fileOrFolderName =%@",node.fileOrFolderName);
        if (node.isDirectory) {
            
            if (node.isExpanded) {
                [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"folderIcon.png"]];
            }
            else {
                [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"folderIcon.png"]];
            }
        }
        else
        {
            if (node.isExpanded)
            {
                [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"fileIcon.png"]];
            }
            else {
                [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"fileIcon.png"]];
            }
        }
        
        [cell setNeedsDisplay];
        return cell;
        
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TreeViewNode *tempNode=[self.displayArray objectAtIndex:indexPath.row];
    
    if (tempNode.isDirectory) {
    
         //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:LOADING_VIEW_DEFAULT_HEADING width:200.0];
        [self loadMetaDataWithPath:tempNode.nodeObject isBackButtonClick:NO];
        
    }
    else{
        selectedFile=tempNode.fileOrFolderName;
        selectedlink=tempNode.nodeObject;
        
        //if (articalSendAlert!=nil) {
            articalSendAlert=nil;
        //}
        articalSendAlert=[[UIAlertView alloc] initWithTitle:@"DropBox" message:@"Do you want upload this file" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil];
        [articalSendAlert show];
        
    }
}
#pragma mark
#pragma mark DBRestClientDelegate Methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    NSLog(@"Path =%@\nRoot =%@ \n filename=%@",[metadata path], [metadata root],[metadata filename]);
    
  //  NSArray* validExtensions = [NSArray arrayWithObjects:@"mp3", nil];

    [self.nodeList removeAllObjects];
    self.metaDataHash=nil;
    self.metaDataHash = metadata.hash;
    for (DBMetadata* child in metadata.contents)
    {
        
             NSLog(@"Data Path %@ ",child.root);
            TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
            firstLevelNode1.nodeLevel =0;
        
            firstLevelNode1.nodeObject =child.path;
            firstLevelNode1.fileOrFolderName=[[child.path lastPathComponent] stringByDeletingPathExtension];
            if (child.isDirectory) {
                firstLevelNode1.isExpanded = YES;
                firstLevelNode1.isDirectory=YES;
            }else{
                
                firstLevelNode1.isExpanded = NO;
                firstLevelNode1.isDirectory = NO;
            }
       // NSString* extension = [[child.path pathExtension] lowercaseString];
      //  if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {

            [self.nodeList addObject:firstLevelNode1];
            
      //  }
    }
    
    if (IS_DEVICE_IPAD) {
        
    }
    else
    {
        [self.view setFrame:CGRectMake(0, 0, 275, 470)];

    }

    [self fillDisplayArray];
    [self.tableView reloadData];
    
    //[MBProgressHUD hideAllHUDsForView :self.view animated:YES];
    [DSBezelActivityView removeView];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    
    //[MBProgressHUD hideAllHUDsForView :self.view animated:YES];
    [DSBezelActivityView removeView];
     NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    if (IS_DEVICE_IPAD) {
        
    }
    else
    {
        [self.view setFrame:CGRectMake(0, 0, 275, 470)];
        
    }
    if(error)
    {
       // [self.view removeFromSuperview];
        
        [ConfigManager showAlertMessage:@"Error:" Message:[error localizedDescription]];
        
        checkSession=@"YES";

    }
}

- (void)restClient:(DBRestClient*)restClient loadedStreamableURL:(NSURL*)url forFile:(NSString*)path
{
    NSLog(@"loadedStreamableURL =%@ path =%@",url,path);
    
    @try
    {
        checkSession=@"YES";

        NSString* fileExtension = [[path componentsSeparatedByString:@"."] lastObject];
        
        NSMutableDictionary* mDict = [[NSMutableDictionary alloc] init];

        [mDict setObject:[url absoluteString] forKey:@"url"];
        [mDict setObject:fileExtension forKey:@"extension"];
        
        sharedAppDelegate.dropBoxContentD=mDict;
        
        NSLog(@"%@",self.checkView);
        
        if (![self.checkView isEqualToString:@"backpack"]) {
            
            
            if (IS_DEVICE_IPAD) {
                
                self.uploadVc= [[UploadMediaFilesVc alloc] initWithNibName:@"UploadMediaFilesVc" bundle:nil];
                
            }
            else
            {
                self.uploadVc= [[UploadMediaFilesVc alloc] initWithNibName:@"UploadMediaFilesVc_iphone" bundle:nil];
                
            }
            self.uploadVc.uploadMedia = uploadMediaFromDropbox;
            self.uploadVc.dDropBoxContent = mDict;
            
            [self.view addSubview:self.uploadVc.view];
        }
        else
        {
            [self.view removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AC_DROPBOX_UPDATE object:nil];
            
           // [self.view removeFromSuperview];

        }
        
        
        //[self.navigationController pushViewController:uploadVc animated:YES];
        
    }
    @catch (NSException *exception) {

    }
    @finally {
        [DSBezelActivityView removeView];
    }
}


- (void)restClient:(DBRestClient*)restClient loadedSharableLink:(NSString*)link
           forFile:(NSString*)path{
    
    if (link!=nil) {
    
        /*globalSelectedArticalLink=link;
        globalSelectedArticalName=selectedFile;
        isBackFromDropBox=YES;*/

        //[self.navigationController popViewControllerAnimated:YES];
        NSString* fileExtension = [[path componentsSeparatedByString:@"."] lastObject];
        NSString* fileName = [NSString stringWithFormat:@"%@.%@",selectedFile,fileExtension];
       
        NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* filePath = [documentDir stringByAppendingPathComponent:fileName];
        
        [self.restClient loadFile:path intoPath:filePath];
        
        NSFileManager * fileManager = [NSFileManager defaultManager] ;

        if([fileManager fileExistsAtPath:filePath])
        {
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
            NSLog(@" size =%lu",(unsigned long)[data length]);
            [ConfigManager showAlertMessage:@"" Message:@"file saved to document directory"];
        }
        else{
            [ConfigManager showAlertMessage:nil Message:@"File not saved"];
        }
        
    }
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [DSBezelActivityView removeView];
    NSLog(@"---Link:%@   File Name:%@ \n PATh=%@",link,selectedFile,path);
    
}
#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
	relinkUserId =userId;
	[[[UIAlertView alloc]
	   initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self
	   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]show];
}


#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
