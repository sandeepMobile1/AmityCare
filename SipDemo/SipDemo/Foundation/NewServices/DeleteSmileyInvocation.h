//
//  DeleteSmileyInvocation.h
//  SipDemo
//
//  Created by Shweta Sharma on 16/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteSmileyInvocation;

@protocol DeleteSmileyInvocationDelegate

-(void)DeleteSmileyInvocationDidFinish:(DeleteSmileyInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteSmileyInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
