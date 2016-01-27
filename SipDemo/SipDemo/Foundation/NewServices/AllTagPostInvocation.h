//
//  AllTagPostInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 26/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllTagPostInvocation;

@protocol AllTagPostInvocationDelegate

-(void)AllTagPostInvocationFinish:(AllTagPostInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AllTagPostInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
