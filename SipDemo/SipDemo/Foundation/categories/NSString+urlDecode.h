//
//  NSString+urlDecode.h
//  EasyOrderKorea
//
//  Created by Pramod Sharma on 01/04/13.
//  Copyright (c) 2013 info@octalsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (urlDecode)
- (NSString *)stringByDecodingURLFormat;
- (NSString *)strShareLinkDecodingURL;
-(NSString *) getEncodedData:(NSString *)text;
-(NSString*)capitaliseFirstLetter:(NSString*)string;
-(NSString*)trimmedString;
@end
