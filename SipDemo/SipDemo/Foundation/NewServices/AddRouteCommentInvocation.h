//
//  AddRouteCommentInvocation.h
//  SipDemo
//
//  Created by Octal on 14/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddRouteCommentInvocation;

@protocol AddRouteCommentInvocationDelegate

-(void)AddRouteCommentInvocationDidFinish:(AddRouteCommentInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AddRouteCommentInvocation : SAServiceAsyncInvocation

@property(nonatomic,strong)NSDictionary* dict;


@end
