//
//  TagCompletedFormDetailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagCompletedFormDetailInvocation;

@protocol TagCompletedFormDetailInvocationDelegate

-(void)TagCompletedFormDetailInvocationDidFinish:(TagCompletedFormDetailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface TagCompletedFormDetailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
