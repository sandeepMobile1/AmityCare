//
//  RegistrationInvocation
//  SimpleAddiction
//
//  Created by Om Prakash on 12/26/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ChangePasswordInvocation;

@protocol ChangePasswordInvocationDelegate

-(void)changePasswordInvocationDidFinish:(ChangePasswordInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface ChangePasswordInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSMutableDictionary *userInfo;

@end
