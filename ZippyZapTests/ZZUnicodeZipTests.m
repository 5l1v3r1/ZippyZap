//
//  ZZUnicodeZipTests.m
//  ZippyZapTests
//
//  Created by Tim Oliver on 2020/03/22.
//  Copyright (c) 2020, Timothy Oliver. All rights reserved.

#import "ZZUnicodeZipTests.h"

#import <ZippyZap/ZippyZap.h>
#import "ZZTasks.h"

/**
Previously, ZipZap tested zipping/unzipping files that had non-Latin
characters (e.g. Chinese) in the file names.

However, those tests started failing because at of the time of this
writing, the `zipinfo` CLI utility included with the latest macOS version (10.15)
is unable to correctly print these values, despite the fact that they can be manually
checked and are found to be correct.

In order to mitigate this, the previous tests now only provide `zipinfo` with
files that include Latin characters, and these tests have been additionally
provided to ensure that files
*/

@implementation ZZUnicodeZipTests
{
	NSMutableArray* _entryFilePaths;
	ZZArchive* _zipFile;
}

- (void)setUp
{
	[super setUp];
	
	NSBundle* bundle = [NSBundle bundleForClass:self.class];
	_entryFilePaths = [bundle objectForInfoDictionaryKey:@"ZZTestFilesUnicode"];
}

- (void)tearDown
{
	[super tearDown];
}

- (void)testZippingEntries
{
	// Create a new zip file with ZippyZap
	_zipFile = [[ZZArchive alloc] initWithURL:self.zipFileURL
									  options:@{ ZZOpenOptionsCreateIfMissingKey: @YES }
										error:nil];
	XCTAssertNotNil(_zipFile);
	
	// Add all of the entries to it
	NSMutableArray *entries = [NSMutableArray array];
	for (NSString *entryName in _entryFilePaths) {
		id dataBlock = ^NSData *(NSError **error) { return [self dataAtFilePath:entryName]; };
		ZZArchiveEntry *entry = [ZZArchiveEntry archiveEntryWithFileName:entryName
																compress:YES
															   dataBlock:dataBlock];
		[entries addObject:entry];
	}
	XCTAssertTrue([_zipFile updateEntries:entries error:nil]);
	
	// Try unzipping the produced file with macOS' built-in zip utility
	// and ensure we can correctly read the contents of each entry
	for (NSString *entryName in _entryFilePaths) {
		NSData *data = [ZZTasks unzipFile:entryName fromPath:self.zipFileURL.path];
		XCTAssertNotNil(data);
		NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		XCTAssertTrue([@"zipper" isEqualToString:string]);
	}
}

- (void)testUnzippingEntries
{
	// Create a new zip file using macOS' built in utility that includes all of our entries
	[ZZTasks zipFiles:_entryFilePaths toPath:self.zipFileURL.path];
	XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:self.zipFileURL.path]);
	
	// Open the resulting zip file with ZippyZap
	_zipFile = [[ZZArchive alloc] initWithURL:self.zipFileURL options:nil error:nil];
	XCTAssertNotNil(_zipFile);
	
	// Get the entries and ensure the count matches what we specified
	NSArray *entries = _zipFile.entries;
	XCTAssertEqual(entries.count, _entryFilePaths.count);
	
	// Compare the names of each entry to the original list
	for (ZZArchiveEntry *entry in entries) {
		XCTAssertTrue([_entryFilePaths indexOfObject:entry.fileName] != NSNotFound);
	}
}

@end
