//
//  NSString+urlDecode.m
//  EasyOrderKorea
//
//  Created by Pramod Sharma on 01/04/13.
//  Copyright (c) 2013 info@octalsoftware.com. All rights reserved.
//

#import "NSString+urlDecode.h"

@implementation NSString (urlDecode)



- (NSString *)stringByDecodingURLFormat
{
    NSString *result = (NSString *)self;
    

    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"nbsp;" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    result = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    return result;
}

- (NSString *)strShareLinkDecodingURL
{
    NSString *result = (NSString *)self;
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    result = [result stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"nbsp;" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    result = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    return result;
}

-(NSString *) getEncodedData:(NSString *)text
{
    NSString *encoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                            NULL,
                                                                            (CFStringRef)text,
                                                                            NULL,
                                                                            (CFStringRef)@".,?\"'!?-/:;()$&@=+*^%#}{][_\\|~<>€£¥ ",
                                                                            kCFStringEncodingUTF8 )); //@"!*'\"();:@&=+$,/?%#[]% "
    return encoded;
}

-(NSString*)capitaliseFirstLetter:(NSString*)string
{
    NSString *firstCapChar = [[string substringToIndex:1] capitalizedString];
    NSString *strfinal = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return strfinal;
}

-(NSString*)trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
