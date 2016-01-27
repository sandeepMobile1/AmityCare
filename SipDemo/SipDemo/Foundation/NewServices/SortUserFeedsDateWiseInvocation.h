//
//  SortUserFeedsDateWiseInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SortUserFeedsDateWiseInvocation;

@protocol SortUserFeedsDateWiseInvocationDelegate

-(void)SortUserFeedsDateWiseInvocationDidFinish:(SortUserFeedsDateWiseInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface SortUserFeedsDateWiseInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSDictionary *dict;


@end
