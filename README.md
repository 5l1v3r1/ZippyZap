<p align="center">
	<img src="https://puu.sh/FnwAo/7e6427cb67.png" width="700" align="center" alt="ZippyZap Logo" />
</p>

<p align="center">
	<a href="https://github.com/TimOliver/ZippyZap/actions?query=workflow%3ACI">
		<img src="https://github.com/TimOliver/ZippyZap/workflows/CI/badge.svg" alt="CI" />
	</a>
	<a href="http://cocoadocs.org/docsets/ZippyZap">
		<img src="https://img.shields.io/cocoapods/v/ZippyZap.svg?style=flat" alt="Version" />
	</a>
	<a href="https://raw.githubusercontent.com/TimOliver/ZippyZap/master/LICENSE">
		<img src="https://img.shields.io/badge/license-BSD-blue.svg" alt="GitHub License" />
	</a>
	<a href="http://cocoadocs.org/docsets/ZippyZap">
		<img src="https://img.shields.io/cocoapods/p/ZippyZap.svg?style=flat" alt="Platform" />
	</a>
	<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M4RKULAVKV7K8">
		<img src="https://img.shields.io/badge/paypal-donate-blue.svg" alt="PayPal" />
	</a>
	<a href="http://twitch.tv/timXD">
		<img src="https://img.shields.io/badge/twitch-timXD-6441a5.svg" alt="Twitch" />
	</a>
</p>

**ZippyZap** is a ZIP compression file I/O library for macOS, iOS/iPadOS, and tvOS.

It probably goes without saying that ZIP is the most popular compression format in the world. Supported natively by many operating systems, ZIP is completely open, easy to create and consume, and serves as the basis for many other file formats.

ZippyZap is a fork of [ZipZap, originally by Glen Low](https://github.com/pixelglow/ZipZap). ZipZap had the goal of being the most comprehensive open source ZIP library for Apple's platforms, adhering to the ZIP standard as closely as possible, and also having a very extensive test suite.

Glen's current working circumstances have made it such that he has unable been able to continue working on ZipZap for the last few years. Since I believe that this is by far the best ZIP library available on the platform, I've forked ZipZap into ZippyZap with the goal of continuing to use and refine it for my own upcoming projects.

## Features

* **Easy-to-use interface**: The public API offers just two classes! You can browse through zip files using familiar `NSArray` collections and properties. And you can zip, unzip and re-zip ZIP files through familiar `NSData`, `NSStream` and `ImageIO` classes.
* **Efficient implementation**: ZIP file reading and writing has been optimised to reduce virtual memory pressure and disk file thrashing. Depending on how your archive is organised, updating a single entry can be faster than writing the same data to a separate file.
* **File format compatibility**: Since ZippyZap closely follows the [zip file format specification](http://www.pkware.com/documents/casestudies/APPNOTE.TXT), it works with most Mac, Linux and Windows ZIP tools.

## System Requirements

* **Build**: Xcode 7 and later.
* **Linking**:
  * `ApplicationServices.framework` (macOS only)
  * `ImageIO.framework` (iOS only)
  * `Foundation.framework`
  * `libz.dylib`
* **System**: macOS 10.10 (Yosemite) or iOS 7.0 and later.

## Install

### CocoaPods

Include the following line in your

```
pod 'ZippyZap' 
```

### Compile your own copy:

1. [Download the `ZippyZap` repo](https://github.com/TimOliver/ZippyZap/archive/master.zip) to your hard drive and decompress it.
2. Within the `ZippyZap` directory, open the `ZippyZap.xcodeproj` project in Xcode.
3. In the Xcode project, select either the *ZippyZap (iOS Framework)*, *ZippyZap (iOS Static Library)*, *ZippyZap (macOS Framework)* or *ZippyZap (macOS Static Library)*  scheme from the drop down.
4. From the selected scheme, you can build a copy of the framework that you can them embed in your own project.
5. The built libraries and test cases are located in a subdirectory of `~/Library/Developer/Xcode/DerivedData`.

### Integrate as a project in your Xcode workspace:

* In Terminal, run `cd workspace` then `git submodule add https://github.com/TimOliver/ZippyZap.git`.
* In your Xcode workspace, choose *File > Add Files to "workspace"*, and then within the *ZippyZap* directory pick the *ZippyZap.xcodeproj* Xcode project.
* In any project target that will use *ZippyZap*:
  * In *Build Phases > Link Binary With Libraries*, add the corresponding *libZippyZap.a* and any other library listed in the Require Link section below.
  * Under *Build Settings > Search Paths > Header Search Paths*, add *../ZippyZap*.
* You can now build, test or analyse any of those project targets.

## Usage

Header includes:

```objc
#import <ZippyZap/ZippyZap.h>
```

Read an existing ZIP file:

```objc
// Open the ZIP archive
ZZArchive* archive = [ZZArchive archiveWithURL:[NSURL fileURLWithPath:@"/tmp/archive.zip"] error:nil];
	
// Load the first entry from within the archive
ZZArchiveEntry* firstArchiveEntry = archive.entries[0];
	
NSLog(@"The first entry's uncompressed size is %lu bytes.", (unsigned long)firstArchiveEntry.uncompressedSize);
	
NSLog(@"The first entry's data is: %@.", [firstArchiveEntry newDataWithError:nil]);
```
	
Write a new ZIP file:

```objc
NSURL *newURL = [NSURL fileURLWithPath:@"/tmp/new.zip"];
ZZArchive* newArchive = [[ZZArchive alloc] initWithURL:newURL options:@{ZZOpenOptionsCreateIfMissingKey : @YES} error:nil];

ZZArchiveEntry *newEntry = [ZZArchiveEntry archiveEntryWithFileName:@"first.text" compress:YES dataBlock:^(NSError** error)
															  {
																  return [@"hello, world" dataUsingEncoding:NSUTF8StringEncoding];
															  }];

[newArchive updateEntries:@[newEntry] error:nil];
```

Update an existing ZIP file:

```objc
NSURL *zipURL = [NSURL fileURLWithPath:@"/tmp/old.zip"];
ZZArchive *archive = [ZZArchive archiveWithURL:zipURL error:nil];

ZZArchiveEntry *entry = [ZZArchiveEntry archiveEntryWithFileName:@"second.text"
									  compress:YES
									 dataBlock:^(NSError** error)
										   {
											   return [@"bye, world" dataUsingEncoding:NSUTF8StringEncoding];
										   }];

[archive updateEntries:[oldArchive.entries arrayByAddingObject:entry] error:nil];
```

## License

*ZippyZap* is licensed under the BSD license. Please see the [LICENSE](LICENSE) file.

