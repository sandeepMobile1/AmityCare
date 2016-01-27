//
//  UploadReceiptInvocation.h
//  SipDemo
//
//  Created by Octal on 03/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadReceiptInvocation;

@protocol UploadReceiptInvocationDelegate

-(void)UploadReceiptInvocationDidFinish:(UploadReceiptInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface UploadReceiptInvocation : SAServiceAsyncInvocation{
    
}


@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
