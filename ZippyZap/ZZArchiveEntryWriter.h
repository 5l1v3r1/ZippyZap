//
//  ZZZipEntryWriter.h
//  ZippyZap
//
//  Created by Glen Low on 6/10/12.
//  Copyright (c) 2012-2020, Pixelglow Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZZChannelOutput;

NS_ASSUME_NONNULL_BEGIN

@protocol ZZArchiveEntryWriter

- (uint32_t)offsetToLocalFileEnd;
- (BOOL)writeLocalFileToChannelOutput:(id<ZZChannelOutput>)channelOutput
					  withInitialSkip:(uint32_t)initialSkip
								error:(out NSError**)error;
- (BOOL)writeCentralFileHeaderToChannelOutput:(id<ZZChannelOutput>)channelOutput
										error:(out NSError**)error;
@end

NS_ASSUME_NONNULL_END
