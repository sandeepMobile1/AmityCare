//
//  ChooseBackpackFileInvocation.h
//  SipDemo
//
//  Created by Om Prakash on 14/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ChooseBackpackFileInvocation;

@protocol ChooseBackpackFileInvocationDelegate

-(void)ChooseBackpackFileInvocationDidFinish:(ChooseBackpackFileInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface ChooseBackpackFileInvocation : SAServiceAsyncInvocation

@property(nonatomic,strong)NSDictionary* dict;

@end
