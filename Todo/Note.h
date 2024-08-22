//
//  Note.h
//  Todo
//
//  Created by Marco on 2024-07-17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Note : NSObject <NSCoding, NSSecureCoding>

@property NSString* title;
@property NSString* content;
@property int priority;
@property int type;
@property NSDate* date;

+(NSMutableArray *) getArr;
+(void) initArr;

@end

NS_ASSUME_NONNULL_END
