//
//  MBProgressWrapper.m
//  Amity-Care
//
//  Created by Vijay Kumar on 21/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "MBProgressWrapper.h"
@interface MBProgressWrapper()<MBProgressHUDDelegate>
@end
@implementation MBProgressWrapper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(MBProgressWrapper*)sharedHUD
{
    static MBProgressWrapper *hud = nil;
    @synchronized(self)
    {
        if(!hud){
            hud = [[MBProgressWrapper alloc] init];
        }
    }
    return hud;
}

+(void)showProgressHUDInView:(UIView*)view animated:(BOOL)animated
{
    [self sharedHUD].dimBackground = YES;
    [view addSubview:[self sharedHUD]];
}

+(void)hideProgressHUD:(UIView*)view animated:(BOOL)animated
{
    [[[self sharedHUD] superclass] hideAllHUDsForView:view animated:YES];
}

@end
