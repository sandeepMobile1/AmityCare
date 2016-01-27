//
//  AllPostListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllPostListInvocation;

@protocol AllPostListInvocationDelegate

-(void)AllPostListInvocationDidFinish:(AllPostListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AllPostListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
