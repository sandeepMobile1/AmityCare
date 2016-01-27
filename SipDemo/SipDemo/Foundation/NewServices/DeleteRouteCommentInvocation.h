//
//  DeleteRouteCommentInvocation.h
//  SipDemo
//
//  Created by Octal on 20/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteRouteCommentInvocation;

@protocol DeleteRouteCommentInvocationDelegate

-(void)DeleteRouteCommentInvocationDidFinish:(DeleteRouteCommentInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface DeleteRouteCommentInvocation : SAServiceAsyncInvocation

@property(nonatomic,strong)NSDictionary* dict;


@end
