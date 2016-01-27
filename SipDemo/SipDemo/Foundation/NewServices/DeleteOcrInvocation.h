//
//  DeleteOcrInvocation.h
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteOcrInvocation;

@protocol DeleteOcrInvocationDelegate

-(void)DeleteOcrInvocationDidFinish:(DeleteOcrInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface DeleteOcrInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;



@end
