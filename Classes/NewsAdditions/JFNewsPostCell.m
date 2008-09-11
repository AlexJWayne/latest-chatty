//
//  JFNewsPostCell.m
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JFNewsPostCell.h"


@implementation JFNewsPostCell

- (id)initWithFrame:(CGRect)rect reuseIdentifier:(NSString*)string {
	title       = [[UILabel alloc] init];
	description = [[UILabel alloc] init];
	date        = [[UILabel alloc] init];
	
	[super initWithFrame:rect reuseIdentifier:string];
	return self;
}

- (void)setColor:(int)aColor {
	color = aColor;
}

- (void)buildCellForPost:(NewsPost *)post {
	UIView* cell = self.contentView;
	if (color) cell.backgroundColor = [UIColor colorWithWhite:.231 alpha:1.0];
	else cell.backgroundColor = [UIColor colorWithWhite:.196 alpha:1.0];
	
	date.frame            = CGRectMake(5, 5, 310, 12);
	date.textColor        = [UIColor colorWithWhite:0.39 alpha:1.0];
	date.backgroundColor  = [UIColor clearColor];
	date.font             = [UIFont systemFontOfSize:10];
	date.text             = [post date];
  date.textAlignment    = UITextAlignmentRight;
	[cell addSubview:date];
	
	title.frame           = CGRectMake(10, 18, 295, 40);
	title.textColor       = [UIColor whiteColor];
	title.backgroundColor = [UIColor clearColor];
	title.font            = [UIFont systemFontOfSize:16];
	title.text            = [post title];
  title.numberOfLines   = 2;
	[cell addSubview:title];
	
  /*
	description.frame           = CGRectMake(10, 37, 310, 48);
	description.textColor       = [UIColor colorWithWhite:0.75 alpha:1.0];
	description.backgroundColor = [UIColor clearColor];
	description.font            = [UIFont systemFontOfSize:12];
	description.text            = [post description];
	[cell addSubview:description];
	*/
}

-(void) dealloc {
	[title release];
	[date release];
	[description release];
	[super dealloc];
}
@end
