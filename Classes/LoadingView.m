//
//  LoadingView.m
//  LatestChatty
//
//  Created by Jeff Forbes on 9/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView

- (void)setupViewWithFrame:(CGRect)frame {
	self.frame = frame;
	self.backgroundColor = [UIColor blackColor];
	self.alpha = .7;
  
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	CGRect theFrame = spinner.frame;
	theFrame.origin.x = frame.size.width/2 - spinner.frame.size.width/2;
	theFrame.origin.y = frame.size.height/2 - spinner.frame.size.height/2;
	
	spinner.frame = theFrame;
  spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
	
	[self addSubview:spinner];
	[spinner release];
	[spinner startAnimating];

  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.userInteractionEnabled = NO;
}
- (void)dealloc {
  [spinner stopAnimating];
  [super dealloc];
}


@end
