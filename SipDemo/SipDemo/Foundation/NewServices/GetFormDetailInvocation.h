//
//  GetFormDetailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 15/01/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetFormDetailInvocation;

@protocol GetFormDetailInvocationDelegate

-(void)GetFormDetailInvocationDidFinish:(GetFormDetailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface GetFormDetailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* formId;

@end