//
//  UploadChatAudioInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadChatAudioInvocation;

@protocol UploadChatAudioInvocationDelegate

-(void)UploadChatAudioInvocationDidFinish:(UploadChatAudioInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UploadChatAudioInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
