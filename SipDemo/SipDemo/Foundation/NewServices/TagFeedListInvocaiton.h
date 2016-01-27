//
//  TagFeedListInvocaiton.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagFeedListInvocaiton;

@protocol TagFeedListInvocaitonDelegate

-(void)TagFeedListInvocaitonDidFinish:(TagFeedListInvocaiton*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface TagFeedListInvocaiton : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;

@end
