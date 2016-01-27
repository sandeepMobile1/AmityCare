//
//  TagCompletedFormListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagCompletedFormListInvocation;

@protocol TagCompletedFormListInvocationDelegate

-(void)TagCompletedFormListInvocationDidFinish:(TagCompletedFormListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface TagCompletedFormListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
