//
//  RouteCommentListInvocation.h
//  SipDemo
//
//  Created by Octal on 17/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class RouteCommentListInvocation;

@protocol RouteCommentListInvocationDelegate

-(void)RouteCommentListInvocationDidFinish:(RouteCommentListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface RouteCommentListInvocation : SAServiceAsyncInvocation

@property(nonatomic,strong)NSDictionary* dict;

@end
