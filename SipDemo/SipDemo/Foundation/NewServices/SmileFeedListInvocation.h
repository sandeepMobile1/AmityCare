//
//  SmileFeedListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SmileFeedListInvocation;

@protocol SmileFeedListInvocationDelegate

-(void)SmileFeedListInvocationDidFinish:(SmileFeedListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface SmileFeedListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;
@property(nonatomic, strong) NSString *status;

@end
