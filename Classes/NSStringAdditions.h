// 
// Copyright (c) 2008 Eric Czarny <eczarny@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of  this  software  and  associated documentation files (the "Software"), to
// deal  in  the Software without restriction, including without limitation the
// rights  to  use,  copy,  modify,  merge,  publish,  distribute,  sublicense,
// and/or sell copies  of  the  Software,  and  to  permit  persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The  above  copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE  SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED,  INCLUDING  BUT  NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY,  WHETHER  IN  AN  ACTION  OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// 

// 
// NOTE:  The  following  is  an  adaptation of code released by Dave Winer and
// Brent  Simmons.  Dave  Winer wrote the original Base64 encoding and decoding
// routines.  Brent Simmons adapted Dave Winer's code for use with Objective-C.
// These  extensions  are  simple  NSString  and  NSData additions that provide
// better NSIntegeregration NSIntegero this XMLRPC framework.
// 

// 
// Cocoa XML-RPC Framework
// NSStringAdditions.h
// 
// Created by Eric Czarny on Wednesday, January 14, 2004.
// Copyright (c) 2008 Divisible by Zero.
// 

#import <Foundation/NSString.h>

@class NSData;

@interface NSString (NSStringAdditions)

+ (NSString *)base64StringFromData: (NSData *)data length: (NSInteger)length;

@end
