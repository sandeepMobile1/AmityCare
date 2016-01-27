//
//  ManagerSharePostListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ManagerSharePostListInvocation;

@protocol ManagerSharePostListInvocationDelegate

-(void)ManagerSharePostListInvocationDidFinish:(ManagerSharePostListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface ManagerSharePostListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
