//
//  UploadChatImageInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadChatImageInvocation;

@protocol UploadChatImageInvocationDelegate

-(void)UploadChatImageInvocationDidFinish:(UploadChatImageInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UploadChatImageInvocation : SAServiceAsyncInvocation{
    
}


@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
