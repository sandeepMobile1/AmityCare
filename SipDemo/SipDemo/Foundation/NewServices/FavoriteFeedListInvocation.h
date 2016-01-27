//
//  FavoriteFeedListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class FavoriteFeedListInvocation;

@protocol FavoriteFeedListInvocationDelegate

-(void)FavoriteFeedListInvocationDidFinish:(FavoriteFeedListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface FavoriteFeedListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;

@end
