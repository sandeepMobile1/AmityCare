//
//  GetFeedsInvocation.h
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SortFeedsDateWiseInvocation;

@protocol SortFeedsDateWiseInvocationDelegate

-(void)sortFeedsDateWiseInvocationDidFinish:(SortFeedsDateWiseInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface SortFeedsDateWiseInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSDictionary *dict;


@end
