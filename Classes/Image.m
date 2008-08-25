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
  NSData *data;
  
  // Resize the image if it's too big
  if ((image.size.width > 640.0) || (image.size.height > 640.0)) {
    // calculate scale factor 
    float maxDimension;
    if (image.size.width > image.size.height) {
      maxDimension = image.size.width;
    } else {
      maxDimension = image.size.height;
    }
    float scaleFactor = 640.0 / maxDimension;
    
    // Create a new image as a resized version of the provided image
    CGImageRef imageRef = [image CGImage];
    CGRect newRect = CGRectMake(0, 0, image.size.width*scaleFactor, image.size.height*scaleFactor);
    
    CGContextRef context = CGBitmapContextCreate(NULL, newRect.size.width, newRect.size.height,
                                                 CGImageGetBitsPerComponent(imageRef), newRect.size.width*4,
                                                 CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
    CGContextDrawImage(context, newRect, imageRef);
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    
    data = UIImageJPEGRepresentation([UIImage imageWithCGImage:newImageRef], 0.7);
    CGImageRelease(newImageRef);
    CGContextRelease(context);
    
  } else {
    // No resize needed, just convert to jpeg data
    data = UIImageJPEGRepresentation(image, 0.7);
  }
  
  return data;
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

@end
