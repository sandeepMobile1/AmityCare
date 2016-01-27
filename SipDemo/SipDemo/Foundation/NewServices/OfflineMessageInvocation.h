//
//  OfflineMessageInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 12/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class OfflineMessageInvocation;

@protocol OfflineMessageInvocationDelegate

-(void)OfflineMessageInvocationDidFinish:(OfflineMessageInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface OfflineMessageInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
