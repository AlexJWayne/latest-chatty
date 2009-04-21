//
//  Image.m
//  LatestChatty
//
//  Created by Alex Wayne on 8/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Image.h"


@implementation Image

- (id)initWithImage:(UIImage *)anImage {
  [self init];
  image = anImage;
  return self;
}

- (NSData *)process {
  image = [self scaleAndRotateImage];
  return UIImageJPEGRepresentation(image, 0.7);
}

- (NSString *)base64String {
  NSData *imageData = [self process];
  return [LatestChattyAppDelegate urlEscape:[NSString base64StringFromData:imageData length:[imageData length]]];
}

- (NSString *)post {
  NSString *imageBase64Data = [self base64String];
  NSLog(@"Image Data Base 64 Length: %d", [imageBase64Data length]);
  
  // Request setup
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[Feed urlStringWithPath:@"images.xml"]]] autorelease];
  [request setHTTPMethod:@"POST"];
  
  // Post body construction
  NSString *usernameString = [LatestChattyAppDelegate urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]];
  NSString *passwordString = [LatestChattyAppDelegate urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"]];
  NSString *postBody = [NSString stringWithFormat:@"username=%@&password=%@&filename=iPhoneUpload.jpg&image=%@", usernameString, passwordString, imageBase64Data];
  [request setHTTPBody:[postBody dataUsingEncoding:NSASCIIStringEncoding]];
  
  // Send the request
  NSLog(@"Sending image POST.");
  NSHTTPURLResponse *response = nil;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  
  // Process response
  int statusCode = (int)[response statusCode];
  NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
  NSLog(responseString);
  NSLog(@"Image POST response code: %d", statusCode);
  
  
  // Success! Return to previous view
  if (statusCode == 201) {
    NSError *err = nil;
    CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:responseString options:0 error:&err];
    CXMLElement *elem = [doc rootElement];
    
    return [elem stringValue];
    
  } else {
    // Failure
    NSLog(@"Didn't get a good response.");
    return nil;
  }
}


// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
- (UIImage *)scaleAndRotateImage {
  int kMaxResolution = 800; // Or whatever
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

@end
