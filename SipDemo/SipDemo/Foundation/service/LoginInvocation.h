//
//  LoginInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class LoginInvocation;

@protocol LoginInvocationDelegate

-(void)loginInvocationDidFinish:(LoginInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface LoginInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *token;
@end
