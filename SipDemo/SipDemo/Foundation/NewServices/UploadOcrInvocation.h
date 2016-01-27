//
//  UploadOcrInvocation.h
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadOcrInvocation;

@protocol UploadOcrInvocationDelegate

-(void)UploadOcrInvocationDidFinish:(UploadOcrInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface UploadOcrInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;



@end
