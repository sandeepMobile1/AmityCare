//
//  SortTagStatusDateWiseInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SortTagStatusDateWiseInvocation;

@protocol SortTagStatusDateWiseInvocationDelegate

-(void)SortTagStatusDateWiseInvocationDidFinish:(SortTagStatusDateWiseInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface SortTagStatusDateWiseInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSDictionary *dict;


@end
