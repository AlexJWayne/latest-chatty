//
//  LoadingView.m
//  LatestChatty
//
//  Created by Jeff Forbes on 9/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView

-(void)setupViewWithFrame:(CGRect)frame
{
	//FIXME: HardCoded value because of a bug in the first load
	frame.size.height = 372;
	
	self.frame = frame;
	self.backgroundColor = [UIColor blackColor];
	self.alpha = .7;
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	CGRect theFrame = spinner.frame;
	theFrame.origin.x = frame.size.width/2 - spinner.frame.size.width/2;
	theFrame.origin.y = (frame.size.height/2 - spinner.frame.size.height/2);
	
	spinner.frame = theFrame;
	
	[self addSubview:spinner];
	[spinner release];
	[spinner startAnimating];

	self.userInteractionEnabled = NO;
	
}
- (void)dealloc {
	[spinner stopAnimating];
    [super dealloc];
}


@end
