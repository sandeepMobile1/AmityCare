//
//  MBProgressWrapper.h
//  Amity-Care
//
//  Created by Vijay Kumar on 21/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressWrapper : MBProgressHUD
+(MBProgressWrapper*)sharedHUD;
+(void)showProgressHUDInView:(UIView*)view animated:(BOOL)animated;
+(void)hideProgressHUD:(UIView*)view animated:(BOOL)animated;

@end
