//
//  OcrListInvocation.h
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class OcrListInvocation;

@protocol OcrListInvocationDelegate

-(void)OcrListInvocationDidFinish:(OcrListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface OcrListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSMutableDictionary *dict;



@end
