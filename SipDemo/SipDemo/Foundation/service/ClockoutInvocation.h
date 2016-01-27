//
//  ClockoutInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ClockoutInvocation;

@protocol ClockoutInvocationDelegate

-(void)clockoutInvocationDidFinish:(ClockoutInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface ClockoutInvocation : SAServiceAsyncInvocation{
    
}


@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
