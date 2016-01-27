//
//  SadSmileFeedListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//


#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SadSmileFeedListInvocation;

@protocol SadSmileFeedListInvocationDelegate

-(void)SadSmileFeedListInvocationDidFinish:(SadSmileFeedListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface SadSmileFeedListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;
@property(nonatomic, strong) NSString *status;

@end
