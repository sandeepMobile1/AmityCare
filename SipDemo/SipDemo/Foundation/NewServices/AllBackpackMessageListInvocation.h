//
//  AllBackpackMessageListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllBackpackMessageListInvocation;

@protocol AllBackpackMessageListInvocationDelegate

-(void)AllBackpackMessageListInvocationDidFinish:(AllBackpackMessageListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface AllBackpackMessageListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
