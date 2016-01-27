//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AppContactsInvoation;

@protocol AppContactsInvoationDelegate

-(void)appContactsInvoationDidFinish:(AppContactsInvoation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface AppContactsInvoation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
