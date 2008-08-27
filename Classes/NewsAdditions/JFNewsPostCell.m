//
//  JFNewsPostCell.m
//  shacknewx
//
//  Created by Jeff Forbes on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JFNewsPostCell.h"


@implementation JFNewsPostCell
-(id) initWithFrame:(CGRect)rect reuseIdentifier:(NSString*)string
{
	title = [[UILabel alloc] init];
	description = [[UILabel alloc] init];
	date = [[UILabel alloc] init];
	
	[super initWithFrame:rect reuseIdentifier:string];
	return self;
}
-(void)setColor:(int)col
{
	color = col;
}
-(void)buildCellForPost:(NewsPost*)post
{
	UIView* cv = self.contentView;
	//cv.frame = CGRectMake( 0,0,320, 100);
	if( color ) cv.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
	else cv.backgroundColor = [UIColor clearColor];
	
	
	CGRect frame = CGRectMake(5, 5, 310, 12);
	
	//date
	//title = [[UILabel alloc] initWithFrame:frame];
	[date setFrame:frame];
	[date setTextColor:[UIColor colorWithRed:.94 green:.18 blue:.04 alpha:1]];
	[date setBackgroundColor:[UIColor clearColor]];
	[date setFont:[UIFont systemFontOfSize:10]];
	[date setNumberOfLines:1];
	[date setText: [post date]];
	[cv addSubview:date];
	
	frame = CGRectMake(10, 18, 295, 40);
	//title = [[UILabel alloc] initWithFrame:frame];
	[title setFrame:frame];
	[title setTextColor:[UIColor whiteColor]];
	[title setBackgroundColor:[UIColor clearColor]];
	[title setFont:[UIFont systemFontOfSize:16]];
	[title setNumberOfLines:2];
	[title setText: [post title]];
	[cv addSubview:title];
	
	//description preview
	frame = CGRectMake(10, 45, 310, 40);
	//title = [[UILabel alloc] initWithFrame:frame];
	[description setFrame:frame];
	[description setTextColor:[UIColor grayColor]];
	[description setBackgroundColor:[UIColor clearColor]];
	[description setFont:[UIFont systemFontOfSize:12]];
	[description setNumberOfLines:1];
	[description setText: [post description]];
	[cv addSubview:description];
	
	//placement
	
	//self.backgroundView.backgroundColor = [UIColor blackColor];
	//self.text = @"testing";
}
-(void) dealloc
{
	[title release];
	[date release];
	[description release];
	[super dealloc];
}
@end
