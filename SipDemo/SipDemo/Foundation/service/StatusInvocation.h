//
//  StatusInvocation.h
//  Amity Care
//
//  Created by Dharmbir Singh on 25/08/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class StatusInvocation;

@protocol StatusInvocationDelegate

-(void)statusInvocationDidFinish:(StatusInvocation *)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface StatusInvocation : SAServiceAsyncInvocation

@property(nonatomic, strong) NSDictionary *statusDic;

@end