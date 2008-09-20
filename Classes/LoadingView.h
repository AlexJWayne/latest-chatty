//
//  LoadingView.h
//  LatestChatty
//
//  Created by Jeff Forbes on 9/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
	UIActivityIndicatorView* spinner;
}
-(void)setupViewWithFrame:(CGRect)frame;

@end
