//
//  NormalActionSheetDelegate.m
//  Amity-Care
//
//  Created by Vijay Kumar on 04/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "NormalActionSheetDelegate.h"

@implementation NormalActionSheetDelegate
@synthesize normalDelegate;

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([self.normalDelegate respondsToSelector:@selector(normalActionSheet:clickedButtonAtIndex:)]){
        [self.normalDelegate normalActionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    }
}
@end