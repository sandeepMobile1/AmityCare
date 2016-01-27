//
//  GetFeedsInvocation.h
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetKeywordFeedsInvocation;

@protocol GetKeywordFeedsInvocationDelegate

-(void)getKeywordFeedsInvocationDidFinish:(GetKeywordFeedsInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface GetKeywordFeedsInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *tagId;
@property(nonatomic, strong) NSString* lastIndex;
@property(nonatomic, strong) NSDictionary* infoDict;
@end
