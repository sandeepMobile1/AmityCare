//
//  SortUserStatusDateWiseInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SortUserStatusDateWiseInvocation;

@protocol SortUserStatusDateWiseInvocationDelegate

-(void)SortUserStatusDateWiseInvocationDidFinish:(SortUserStatusDateWiseInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface SortUserStatusDateWiseInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSDictionary *dict;


@end
