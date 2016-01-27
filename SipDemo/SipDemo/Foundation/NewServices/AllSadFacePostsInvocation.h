//
//  AllSadFacePostsInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllSadFacePostsInvocation;

@protocol AllSadFacePostsInvocationDelegate

-(void)AllSadFacePostsInvocationDidFinish:(AllSadFacePostsInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AllSadFacePostsInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
