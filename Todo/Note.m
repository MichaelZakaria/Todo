//
//  Note.m
//  Todo
//
//  Created by Marco on 2024-07-17.
//

#import "Note.h"

@implementation Note

static NSMutableArray *notesArr;

+(NSMutableArray *) getArr{
    return notesArr;
}

+(void) initArr{
    if(!notesArr)
        notesArr = [NSMutableArray new];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeInt:_priority forKey:@"priority"];
    [coder encodeInt:_type forKey:@"type"];
    [coder encodeObject:_date forKey:@"date"];
    
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if((self = [super init])){
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
        _priority = [coder decodeIntForKey:@"priority"];
        _type = [coder decodeIntForKey:@"type"];
        _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding{
    return true;
}

@end
