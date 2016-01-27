//
//  ClockInInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class BackgroundClockInInvocation;

@protocol BackgroundClockInInvocationDelegate

-(void)backgroundClockInInvocationDidFinish:(BackgroundClockInInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface BackgroundClockInInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSMutableDictionary *userInfo;

@end
