//
//  DemoTableViewCell.m
//  RTLabelProject
//
//  Created by honcheng on 5/1/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import "SyTableViewCell.h"


@implementation SyTableViewCell
NSString *str;
@synthesize rtLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.rtLabel = [self textLabel];
        self.rtLabel.delegate=self;
		[self.contentView addSubview:self.rtLabel];
		[self.rtLabel setBackgroundColor:[UIColor clearColor]];
        
       [(UIScrollView *)[[rtLabel subviews] objectAtIndex:0]    setBounces:NO];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	//CGSize optimumSize = [self.rtLabel optimumSize];
	CGRect frame = [self.rtLabel frame];
	//frame.size.height = (int)optimumSize.height+5; // +5 to fix height issue, this should be automatically fixed in iOS5
	[self.rtLabel setFrame:frame];
}

-(UIWebView *)textLabel
{
	UIWebView *label = [[UIWebView alloc] initWithFrame:self.frame];
	return label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView sizeToFit];
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frame.size.height);
    NSLog(@"%f",fittingSize.height);
    [delagate WebViewHeight:frame.size.height];
}


-(void)settDelagate:(id<LoadingDelegate>) tdelagate{
    delagate=tdelagate;
}

@end
