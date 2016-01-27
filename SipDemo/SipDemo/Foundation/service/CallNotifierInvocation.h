//
//  ClockInInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class CallNotifierInvocation;

@protocol CallNotifierInvocationDelegate

-(void)callNotifierInvocationDidFinish:(CallNotifierInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface CallNotifierInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSMutableDictionary *userInfo;

@end
