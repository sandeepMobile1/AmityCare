//
//  TestViewController.m
//  SipDemo
//
//  Created by Shweta Sharma on 09/06/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

@synthesize callingView,phoneCallDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSLog(@"sssss");
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnStartCallPressed:(id)sender
{
   // [sharedAppDelegate.callingView setUserImage:nil];
    
    //[self.phoneCallDelegate dialup:@"8483410976" number:NO];
}
-(IBAction)btnEndCallPressed:(id)sender
{
    
}
#pragma mark- CallingViewDelegate
-(void)muteBtnDidClicked:(id)sender
{
    
}

-(void)transferCallBtnDidClicked:(id)sender
{
    
}

-(void)speakerBtnDidClicked:(id)sender
{
    
}

-(void)contactsBtnDidClicked:(id)sender
{
    
}

-(void)hello
{
    self.callingView = nil;
}

-(void)callEndDidClicked:(id)sender
{
    [self performSelector:@selector(hello) withObject:nil afterDelay:0.3f];
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
