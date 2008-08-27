//
//  JFNewsPostCell.h
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#import "NewsPost.h"
@interface JFNewsPostCell : UITableViewCell {
	UILabel* title;
	UILabel* date;
	UILabel* description;
	int color;
}
-(void)buildCellForPost:(NewsPost*)post;
-(void)setColor:(int)col;
@end
