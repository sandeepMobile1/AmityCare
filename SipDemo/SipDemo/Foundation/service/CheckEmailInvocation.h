//
//  LoginInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class CheckEmailInvocation;

@protocol CheckEmailInvocationDelegate

-(void)checkEmailInvocationDidFinish:(CheckEmailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface CheckEmailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *email;

@end
