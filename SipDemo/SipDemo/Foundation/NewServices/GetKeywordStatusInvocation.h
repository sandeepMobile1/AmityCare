//
//  GetKeywordStatusInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetKeywordStatusInvocation;

@protocol GetKeywordStatusInvocationDelegate

-(void)GetKeywordStatusInvocationDidFinish:(GetKeywordStatusInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface GetKeywordStatusInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *tagId;
@property(nonatomic, strong) NSString* lastIndex;
@property(nonatomic, strong) NSDictionary* infoDict;

@end
