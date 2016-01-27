//
//  LoginInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SecureLoginInvocation;

@protocol SecureLoginInvocationDelegate

-(void)secureLoginInvocationDidFinish:(SecureLoginInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface SecureLoginInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *tagId;
@property(nonatomic, strong) NSString *password;

@end
