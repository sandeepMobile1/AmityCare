//
//  ClockInInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ClockInInvocation;

@protocol ClockInInvocationDelegate

-(void)clockInInvocationDidFinish:(ClockInInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface ClockInInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSMutableDictionary *userInfo;

@end
