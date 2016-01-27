//
//  OcrData.h
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OcrData : NSObject

@property(nonatomic,strong)NSString *ocrId;
@property(nonatomic,strong)NSString *ocrTitle;
@property(nonatomic,strong)NSString *ocrImage;
@property(nonatomic,strong)NSString *ocrAmount;
@property(nonatomic,strong)NSString *ocrDate;
@property(nonatomic,strong)NSString *ocrAddress;
@property(nonatomic,strong)NSString *ocrNumber;
@property(nonatomic,strong)NSString *ocrComment;

@end
