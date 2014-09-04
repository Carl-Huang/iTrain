//
//  AKPickerView.m
//  AKPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import "AKPickerView.h"

@interface AKCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@interface AKCollectionViewLayout : UICollectionViewFlowLayout
@end

@interface AKPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

- (CGFloat)offsetForItem:(NSUInteger)item;
- (void)didEndScrolling;
@end

@implementation AKPickerView

- (void)initialize
{
    
    CGRect bframe =self.bounds;
    bframe.size.width=320;
    bframe.size.height=45;
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:bframe];
    [backImageView setImage:[UIImage imageNamed:@"xunlian_02"]];
    [self addSubview:backImageView];
	self.font = self.font ?: [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
	self.textColor = self.textColor ?: [UIColor darkGrayColor];
	self.highlightedTextColor = self.highlightedTextColor ?: [UIColor blackColor];
    
	if (self.collectionView) [self.collectionView removeFromSuperview];
    CGRect frame =self.bounds;
	self.collectionView = [[UICollectionView alloc] initWithFrame:frame
											 collectionViewLayout:[AKCollectionViewLayout new]];
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
	self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView registerClass:[AKCollectionViewCell class]
			forCellWithReuseIdentifier:NSStringFromClass([AKCollectionViewCell class])];
	[self addSubview:self.collectionView];
    
	CAGradientLayer *maskLayer = [CAGradientLayer layer];
	maskLayer.frame = self.collectionView.bounds;
	maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
						 (id)[[UIColor blackColor] CGColor],
						 (id)[[UIColor blackColor] CGColor],
						 (id)[[UIColor clearColor] CGColor],];
	maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
	maskLayer.startPoint = CGPointMake(0.0, 0.0);
	maskLayer.endPoint = CGPointMake(1.0, 0.0);
    self.collectionView.layer.mask = maskLayer;
    self.collectionView.backgroundColor=[UIColor clearColor];
    _oldindex=-1;
    [self scrollViewDidScroll:self.collectionView];
    [self didEndScrolling];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

#pragma mark -

- (void)setFont:(UIFont *)font
{
	if (![_font isEqual:font]) {
		_font = font;
		CGRect frame = CGRectInset(self.bounds, 0, (self.bounds.size.height - ceilf(self.font.lineHeight)) / 2);
		self.collectionView.frame = frame;
		[self initialize];
	}
}

#pragma mark -

- (void)reloadData
{
	[self.collectionView reloadData];
}

- (CGFloat)offsetForItem:(NSUInteger)item
{
	CGFloat offset = 0.0;
    offset=64*item;
    NSLog(@"%f",offset);
	return offset;
}

- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated
{
	[self.collectionView setContentOffset:CGPointMake([self offsetForItem:item],self.collectionView.contentOffset.y)animated:animated];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated
{
	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]animated:animated scrollPosition:UICollectionViewScrollPositionNone];
	[self scrollToItem:item animated:animated];
    _oldindex=item;
    [self.collectionView reloadData];
	if ([self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)])
		[self.delegate pickerView:self didSelectItem:item];
}

- (void)didEndScrolling
{
	for (NSUInteger i = 0; i < [self collectionView:self.collectionView numberOfItemsInSection:0]; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		AKCollectionViewCell *cell = (AKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
		if ([self offsetForItem:i] + cell.bounds.size.width / 2 > self.collectionView.contentOffset.x) {
			[self selectItem:i animated:YES];
			break;
		}
	}
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.delegate numberOfItemsInPickerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [self.delegate pickerView:self titleForItem:indexPath.item];
	AKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AKCollectionViewCell class])forIndexPath:indexPath];
    if(_oldindex==indexPath.row){
        cell.label.textColor=[UIColor redColor];
    }else{
        cell.label.textColor = self.textColor;
    }
	cell.label.highlightedTextColor = self.highlightedTextColor;
	cell.label.font = self.font;
		if ([cell.label respondsToSelector:@selector(setAttributedText:)]) {
		cell.label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: self.font}];
	} else {
		cell.label.text = title;
	}
    cell.label.frame=CGRectMake(cell.label.frame.origin.x, cell.label.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
    [cell.label setTextAlignment:NSTextAlignmentCenter];
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [self.delegate pickerView:self titleForItem:indexPath.item];
	CGSize size;
     UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20];
	if ([title respondsToSelector:@selector(sizeWithAttributes:)]) {
		size = [title sizeWithAttributes:@{NSFontAttributeName: self.font}];
	} else {
		size = [title sizeWithFont:font];
	}
    size = [title sizeWithFont:font];
    CGFloat width=self.frame.size.width/5;
	return CGSizeMake(width, ceilf(size.height));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
	CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
	CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
	return UIEdgeInsetsMake(0,
							(collectionView.bounds.size.width - firstSize.width) / 2,
							0,
							(collectionView.bounds.size.width - lastSize.width) / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self selectItem:indexPath.item animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self didEndScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate) [self didEndScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	self.collectionView.layer.mask.frame = self.collectionView.bounds;
	[CATransaction commit];
}

@end

@implementation AKCollectionViewCell

- (void)initialize
{
	self.label = [[UILabel alloc] initWithFrame:self.bounds];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.textColor = [UIColor grayColor];
	self.label.numberOfLines = 1;
	self.label.lineBreakMode = NSLineBreakByTruncatingTail;
	self.label.highlightedTextColor = [UIColor blackColor];
	self.label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
	[self.contentView addSubview:self.label];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

@end

@interface AKCollectionViewLayout ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat maxAngle;
@end

@implementation AKCollectionViewLayout

- (id)init
{
	self = [super init];
	if (self) {
		self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
		self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.minimumLineSpacing = 0.0;
	}
	return self;
}

- (void)prepareLayout
{
	CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
	self.midX = CGRectGetMidX(visibleRect);
	self.width = (CGRectGetWidth(visibleRect) / 2);
	self.maxAngle = M_PI_2;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
	CGFloat distance = CGRectGetMidX(attributes.frame) - self.midX;
	//CGFloat currentAngle = self.maxAngle * distance / self.width;
	//CGFloat delta = sinf(currentAngle) * self.width - distance;
	attributes.transform3D = CATransform3DConcat(CATransform3DMakeRotation(0, 0, 1, 0),
												 CATransform3DMakeTranslation(0, 0, 0));
    
	attributes.alpha = (ABS(distance) < self.width);
    
	return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		[attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end