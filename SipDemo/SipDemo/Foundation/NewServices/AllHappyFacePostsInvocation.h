//
//  AllHappyFacePostsInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllHappyFacePostsInvocation;

@protocol AllHappyFacePostsInvocationDelegate

-(void)AllHappyFacePostsInvocationDidFinish:(AllHappyFacePostsInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface AllHappyFacePostsInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
