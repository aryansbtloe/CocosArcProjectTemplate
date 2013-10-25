//
//  NSString+HTML.m
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the
//     purpose of any concept relating to diary/journal keeping.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

#pragma mark -
#pragma mark Class Methods

#pragma mark -
#pragma mark Instance Methods

// Replace newlines with <br /> tags
- (NSString *)stringWithNewLinesAsBRs {
	// Strange New lines:
	//	Next Line, U+0085
	//	Form Feed, U+000C
	//	Line Separator, U+2028
	//	Paragraph Separator, U+2029

	// Scanner
	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *result = [[NSMutableString alloc] init];
	NSString *temp;
	NSCharacterSet *newLineCharacters = [NSCharacterSet characterSetWithCharactersInString:
	                                     [NSString stringWithFormat:@"\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	// Scan
	do {
		// Get non new line characters
		temp = nil;
		[scanner scanUpToCharactersFromSet:newLineCharacters intoString:&temp];
		if (temp) [result appendString:temp];
		temp = nil;

		// Add <br /> s
		if ([scanner scanString:@"\r\n" intoString:nil]) {
			// Combine \r\n into just 1 <br />
			[result appendString:@"<br />"];
		}
		else if ([scanner scanCharactersFromSet:newLineCharacters intoString:&temp]) {
			// Scan other new line characters and add <br /> s
			if (temp) {
				for (int i = 0; i < temp.length; i++) {
					[result appendString:@"<br />"];
				}
			}
		}
	}
	while (![scanner isAtEnd]);

	// Cleanup & return
	NSString *retString = [NSString stringWithString:result];
	return retString;
}

// Remove newlines and white space from strong
- (NSString *)stringByRemovingNewLinesAndWhitespace {
	// Strange New lines:
	//	Next Line, U+0085
	//	Form Feed, U+000C
	//	Line Separator, U+2028
	//	Paragraph Separator, U+2029

	// Scanner
	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *result = [[NSMutableString alloc] init];
	NSString *temp;
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:
	                                                  [NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	// Scan
	while (![scanner isAtEnd]) {
		// Get non new line or whitespace characters
		temp = nil;
		[scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
		if (temp) [result appendString:temp];

		// Replace with a space
		if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
			if (result.length > 0 && ![scanner isAtEnd])             // Dont append space to beginning or end of result
				[result appendString:@" "];
		}
	}

	// Cleanup

	// Return
	NSString *retString = [NSString stringWithString:result];
	return retString;
}

// Strip HTML tags
// DEPRECIATED - Please use NSString stringByConvertingHTMLToPlainText
- (NSString *)stringByStrippingTags {
	// Find first & and short-cut if we can
	NSUInteger ampIndex = [self rangeOfString:@"<" options:NSLiteralSearch].location;
	if (ampIndex == NSNotFound) {
		return [NSString stringWithString:self];         // return copy of string as no tags found
	}

	// Scan and find all tags
	NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableSet *tags = [[NSMutableSet alloc] init];
	NSString *tag;
	do {
		// Scan up to <
		tag = nil;
		[scanner scanUpToString:@"<" intoString:NULL];
		[scanner scanUpToString:@">" intoString:&tag];

		// Add to set
		if (tag) {
			NSString *t = [[NSString alloc] initWithFormat:@"%@>", tag];
			[tags addObject:t];
		}
	}
	while (![scanner isAtEnd]);

	// Strings
	NSMutableString *result = [[NSMutableString alloc] initWithString:self];
	NSString *finalString;

	// Replace tags
	NSString *replacement;
	for (NSString *t in tags) {
		// Replace tag with space unless it's an inline element
		replacement = @" ";
		if ([t isEqualToString:@"<a>"] ||
		    [t isEqualToString:@"</a>"] ||
		    [t isEqualToString:@"<span>"] ||
		    [t isEqualToString:@"</span>"] ||
		    [t isEqualToString:@"<strong>"] ||
		    [t isEqualToString:@"</strong>"] ||
		    [t isEqualToString:@"<em>"] ||
		    [t isEqualToString:@"</em>"]) {
			replacement = @"";
		}

		// Replace
		[result replaceOccurrencesOfString:t
		                        withString:replacement
		                           options:NSLiteralSearch
		                             range:NSMakeRange(0, result.length)];
	}

	// Remove multi-spaces and line breaks
	finalString = [result stringByRemovingNewLinesAndWhitespace];

	// Cleanup & return
	return finalString;
}

- (NSString *)stringByURLDecode {
	NSMutableString *tempStr = [NSMutableString stringWithString:self];
	[tempStr replaceOccurrencesOfString:@"+" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];

	return [[NSString stringWithFormat:@"%@", tempStr] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL *)urlByURLDecode {
	NSMutableString *tempStr = [NSMutableString stringWithString:self];
	[tempStr replaceOccurrencesOfString:@"+" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
	return [NSURL URLWithString:[[NSString stringWithFormat:@"%@", tempStr] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)stringByURLEncode {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8));
}

@end
