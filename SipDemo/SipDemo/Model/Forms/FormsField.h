//
//  FormsField.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 04/09/14.
//
//

#import <Foundation/Foundation.h>

@interface FormsField : NSObject

@property(nonatomic,strong) NSString * strFieldRequired;
@property(nonatomic,strong) NSString * strFieldType;
@property(nonatomic,strong) NSString * strFieldValue;
@property(nonatomic,strong) NSString * strCSSClass;
@property(nonatomic,strong) NSString * strTitle;
@property(nonatomic,strong) NSString * strAnswerImage;

@property(nonatomic,strong) NSMutableArray *arrValues;
@property(nonatomic,strong) NSMutableArray* arrStructue;

@end
