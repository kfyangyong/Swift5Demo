//
//  LFMP4Atom.h
//  Swift5Demo
//
//  Created by 阿永 on 2021/6/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFMP4Atom : NSObject
{
    NSFileHandle *_file;
    int64_t _offset;
    int64_t _length;
    OSType _type;
    int64_t _nextChild;
}
@property OSType type;
@property int64_t length;

+ (LFMP4Atom *)atomAt:(int64_t)offset size:(int)length type:(OSType)fourcc inFile:(NSFileHandle *)handle;
- (BOOL)init:(int64_t)offset size:(int)length type:(OSType)fourcc inFile:(NSFileHandle *)handle;
- (NSData *)readAt:(int64_t)offset size:(int)length;
- (BOOL)setChildOffset:(int64_t)offset;
- (LFMP4Atom *)nextChild;
- (LFMP4Atom *)childOfType:(OSType)fourcc startAt:(int64_t)offset;

@end

NS_ASSUME_NONNULL_END
