//
//  AllBackpackPicListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllBackpackPicListInvocation;

@protocol AllBackpackPicListInvocationDelegate

-(void)AllBackpackPicListInvocationDidFinish:(AllBackpackPicListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AllBackpackPicListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
