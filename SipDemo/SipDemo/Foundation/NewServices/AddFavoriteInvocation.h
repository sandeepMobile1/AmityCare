//
//  AddFavoriteInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddFavoriteInvocation;

@protocol AddFavoriteInvocationDelegate

-(void)AddFavoriteInvocationDidFinish:(AddFavoriteInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AddFavoriteInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;
@property(nonatomic, strong) NSString *feed_id;

@end
