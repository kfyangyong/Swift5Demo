//
//  LFVideoEncoder.h
//  Swift5Demo
//
//  Created by 阿永 on 2021/6/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAssetWriter.h>
#import <AVFoundation/AVAssetWriterInput.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVVideoSettings.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFVideoEncoder : NSObject
@property NSString *path;
@property (nonatomic, readonly) NSUInteger bitrate;

+ (LFVideoEncoder *)encoderForPath:(NSString *)path Height:(int)height andWidth:(int)width bitrate:(int)bitrate;

- (void)initPath:(NSString *)path Height:(int)height andWidth:(int)width bitrate:(int)bitrate;
- (void)finishWithCompletionHandler:(void (^)(void))handler;
- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
