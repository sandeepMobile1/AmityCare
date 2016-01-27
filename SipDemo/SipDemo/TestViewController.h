//
//  TestViewController.h
//  SipDemo
//
//  Created by Shweta Sharma on 09/06/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallingView.h"
#import "PhoneCallDelegate.h"

@interface TestViewController : UIViewController
{
    id<PhoneCallDelegate> phoneCallDelegate;

}
@property (nonatomic,strong) CallingView *callingView;
@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;

-(IBAction)btnStartCallPressed:(id)sender;
-(IBAction)btnEndCallPressed:(id)sender;

@end
