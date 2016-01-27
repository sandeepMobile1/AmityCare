//
//  AddCommentInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 03/03/15.
//
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddCommentInvocation;

@protocol AddCommentInvocationDelegate

-(void)AddCommentInvocationDidFinish:(AddCommentInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface AddCommentInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong)NSDictionary *commentDict;

@end
