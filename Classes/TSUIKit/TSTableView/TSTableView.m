//
//  TSTableView.m
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/9/13.
//
//  The MIT License (MIT)
//  Copyright © 2013 Viacheslav Radchenko
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TSTableView.h"
#import "TSTableViewHeaderPanel.h"
#import "TSTableViewExpandControlPanel.h"
#import "TSTableViewContentHolder.h"
#import "TSTableViewDataSource.h"
#import "TSTableViewAppearanceCoordinator.h"
#import "TSUtils.h"
#import "TSDefines.h"

#define DEF_TABLE_CONTENT_ADDITIONAL_SIZE   32
#define DEF_TABLE_MIN_COLUMN_WIDTH          64
#define DEF_TABLE_MAX_COLUMN_WIDTH          512
#define DEF_TABLE_DEF_COLUMN_WIDTH          128

// Add private API in TSTableViewContentHolder to TSTableView scope
@interface TSTableViewContentHolder (Private)

- (void)selectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated internal:(BOOL)internal;

@end

@interface TSTableView () <TSTableViewHeaderPanelDelegate, TSTableViewExpandControlPanelDelegate, TSTableViewContentHolderDelegate, TSTableViewAppearanceCoordinator>

@property (nonatomic, assign) CGFloat contentAdditionalSize;
@property (nonatomic, strong) TSTableViewHeaderPanel *tableHeader;
@property (nonatomic, strong) TSTableViewExpandControlPanel *tableControlPanel;
@property (nonatomic, strong) TSTableViewContentHolder *tableContentHolder;
@property (nonatomic, strong) UIImageView *headerBackgroundImageView;
@property (nonatomic, strong) UIImageView *expandPanelBackgroundImageView;
@property (nonatomic, strong) UIImageView *topLeftCornerBackgroundImageView;

@end

@implementation TSTableView

@dynamic allowRowSelection;
@dynamic allowColumnSelection;
@dynamic maxNestingLevel;
@dynamic expandPanelBackgroundImage;
@dynamic headerBackgroundImage;
@dynamic topLeftCornerBackgroundImage;
@dynamic headerBackgroundColor;
@dynamic expandPanelBackgroundColor;

- (id)init
{
    if(self = [super init])
    {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    VerboseLog();
    self.backgroundColor = [UIColor blackColor];
    
    _lineNumbersColor = [UIColor blackColor];
    _contentAdditionalSize = DEF_TABLE_CONTENT_ADDITIONAL_SIZE;
   
    CGRect headerRect = CGRectMake(0, 0, self.frame.size.width, 0);
    _tableHeader = [[TSTableViewHeaderPanel alloc] initWithFrame: headerRect];
    _tableHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableHeader.backgroundColor = [UIColor clearColor];
    _tableHeader.headerDelegate = self;
    [self addSubview:_tableHeader];
    
    CGRect controlPanelRect = CGRectMake(0, 0, 0, self.frame.size.height);
    _tableControlPanel = [[TSTableViewExpandControlPanel alloc] initWithFrame:controlPanelRect];
    _tableControlPanel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableControlPanel.controlPanelDelegate = self;
    _tableControlPanel.backgroundColor = [UIColor clearColor];
    [self addSubview: _tableControlPanel];
    
    CGRect contentRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _tableContentHolder = [[TSTableViewContentHolder alloc] initWithFrame:contentRect];
    _tableContentHolder.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableContentHolder.contentHolderDelegate = self;
    [self addSubview: _tableContentHolder];
}

- (void)setDataSource:(id<TSTableViewDataSource>)dSource
{
    VerboseLog();
    _dataSource = dSource;
    _tableHeader.dataSource = (id)self;
    _tableControlPanel.dataSource = (id)self;
    _tableContentHolder.dataSource = (id)self;
}

#pragma mark - Getters & Setters

- (NSInteger)maxNestingLevel
{
    return _tableControlPanel.maxNestingLevel;
}

- (BOOL)allowRowSelection
{
    return _tableContentHolder.allowRowSelection;
}

- (void)setAllowRowSelection:(BOOL)val
{
    _tableContentHolder.allowRowSelection = val;
}

- (BOOL)allowColumnSelection
{
    return _tableHeader.allowColumnSelection;
}

- (void)setAllowColumnRowSelection:(BOOL)val
{
    _tableHeader.allowColumnSelection = val;
}

- (BOOL)headerPanelHidden
{
    return _tableHeader.hidden;
}

- (void)setHeaderPanelHidden:(BOOL)hidden
{
    _tableHeader.hidden = hidden;
    [self updateLayout];
}

- (BOOL)expandPanelHidden
{
    return _tableControlPanel.hidden;
}

- (void)setExpandPanelHidden:(BOOL)hidden
{
    _tableControlPanel.hidden = hidden;
    [self updateLayout];
}

- (UIImage *)headerBackgroundImage
{
    return self.headerBackgroundImageView.image;
}

- (void)setHeaderBackgroundImage:(UIImage *)image
{
    self.headerBackgroundImageView.image = image;
}

- (UIImage *)expandPanelBackgroundImage
{
    return self.expandPanelBackgroundImageView.image;
}

- (void)setExpandPanelBackgroundImage:(UIImage *)image
{
    self.expandPanelBackgroundImageView.image = image;
}

- (UIImage *)topLeftCornerBackgroundImage
{
    return self.topLeftCornerBackgroundImageView.image;
}

- (void)setTopLeftCornerBackgroundImage:(UIImage *)image
{
    self.topLeftCornerBackgroundImageView.image = image;
}

- (UIColor *)headerBackgroundColor
{
    return _tableHeader.backgroundColor;
}

- (void)setHeaderBackgroundColor:(UIColor *)color
{
    _tableHeader.backgroundColor = color;
}

- (UIColor *)expandPanelBackgroundColor
{
    return _tableControlPanel.backgroundColor;
}

- (void)setExpandPanelBackgroundColor:(UIColor *)color
{
    _tableControlPanel.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _tableContentHolder.backgroundColor = backgroundColor;
}

- (UIImageView *)headerBackgroundImageView
{
    if(!_headerBackgroundImageView)
    {
        _headerBackgroundImageView = [[UIImageView alloc] initWithFrame:_tableHeader.frame];
        _headerBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self insertSubview:_headerBackgroundImageView belowSubview:_tableHeader];
    }
    return _headerBackgroundImageView;
}

- (UIImageView *)expandPanelBackgroundImageView
{
    if(!_expandPanelBackgroundImageView)
    {
        _expandPanelBackgroundImageView = [[UIImageView alloc] initWithFrame:_tableControlPanel.frame];
        _expandPanelBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_expandPanelBackgroundImageView belowSubview:_tableControlPanel];
    }
    return _expandPanelBackgroundImageView;
}

- (UIImageView *)topLeftCornerBackgroundImageView
{
    if(!_topLeftCornerBackgroundImageView)
    {
        _topLeftCornerBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tableControlPanel.frame.size.width, _tableHeader.frame.size.height)];
        [self addSubview:_topLeftCornerBackgroundImageView];
    }
    return _topLeftCornerBackgroundImageView;
}


#pragma mark - Layout

- (void)updateLayout
{
    VerboseLog();
    CGFloat headerHeight = (_tableHeader.hidden ? 0 : [_tableHeader headerHeight]);
    CGFloat controlPanleWidth = (_tableControlPanel.hidden ? 0 : [_tableControlPanel panelWidth]);
    CGFloat tableWidth = [_tableHeader tableTotalWidth];
    CGFloat tableHeight = [_tableControlPanel tableHeight];
    
    CGRect headerRect = CGRectMake(controlPanleWidth, 0, self.frame.size.width - controlPanleWidth, headerHeight);
    _tableHeader.frame =  headerRect;
    _tableHeader.contentSize = CGSizeMake(tableWidth + _contentAdditionalSize , headerHeight);
    
    CGRect controlPanelRect = CGRectMake(0, headerHeight, controlPanleWidth, self.frame.size.height - headerHeight);
    _tableControlPanel.frame = controlPanelRect;
    _tableControlPanel.contentSize = CGSizeMake(controlPanleWidth, tableHeight + _contentAdditionalSize );
    
    CGRect contentRect = CGRectMake(controlPanleWidth, headerHeight, self.frame.size.width - controlPanleWidth, self.frame.size.height - headerHeight);
    _tableContentHolder.frame = contentRect;
    _tableContentHolder.contentSize = CGSizeMake(tableWidth + _contentAdditionalSize, tableHeight + _contentAdditionalSize);
    
    if(_headerBackgroundImageView)
    {
        _headerBackgroundImageView.hidden = _tableHeader.hidden;
        _headerBackgroundImageView.frame = _tableHeader.frame;
    }
    
    if(_expandPanelBackgroundImageView)
    {
        _expandPanelBackgroundImageView.hidden = _tableControlPanel.hidden;
        _expandPanelBackgroundImageView.frame = _tableControlPanel.frame;
    }

    if(_topLeftCornerBackgroundImageView)
    {
        _topLeftCornerBackgroundImageView.hidden = _tableControlPanel.hidden || _tableHeader.hidden;
        _topLeftCornerBackgroundImageView.frame = CGRectMake(0, 0, _tableControlPanel.frame.size.width, _tableHeader.frame.size.height);
    }
}

- (void)reloadData
{
    VerboseLog();
    [self clearCachedData];
    [self.tableHeader reloadData];
    [self.tableControlPanel reloadData];
    [self.tableContentHolder reloadData];
    [self updateLayout];
}

- (void)reloadRowsData
{
    VerboseLog();
    [self.tableControlPanel reloadData];
    [self.tableContentHolder reloadData];
    [self updateLayout];
}

- (TSTableViewCell *)dequeueReusableCellViewWithIdentifier:(NSString *)identifier
{
    return [_tableContentHolder dequeueReusableCellViewWithIdentifier:identifier];
}

- (void)clearCachedData
{
    [_tableContentHolder clearCachedData];
}

#pragma mark - TSTableViewHeaderPanelDelegate 

- (void)tableViewHeader:(TSTableViewHeaderPanel *)header columnWidthDidChange:(NSInteger)columnIndex oldWidth:(CGFloat)oldWidth newWidth:(CGFloat)newWidth
{
    VerboseLog();
    CGFloat delta = newWidth - oldWidth;
    [_tableContentHolder changeColumnWidthOnAmount:delta forColumn:columnIndex animated:NO];
    [self updateLayout];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:widthDidChangeForColumnAtIndex:)])
    {
        [self.delegate tableView:self widthDidChangeForColumnAtIndex:columnIndex];
    }
}

- (void)tableViewHeader:(TSTableViewHeaderPanel *)header didSelectColumnAtPath:(NSIndexPath *)columnPath
{
    VerboseLog();
    [_tableContentHolder selectColumnAtPath:columnPath animated:YES internal:YES];
}

#pragma mark - TSTableViewExpandControlPanelDelegate

- (void)tableViewSideControlPanel:(TSTableViewExpandControlPanel *)controlPanel expandStateDidChange:(BOOL)expand forRow:(NSIndexPath *)rowPath
{
    VerboseLog();
    [self updateLayout];
    [_tableContentHolder changeExpandStateForRow:rowPath toValue:expand animated:YES];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:expandStateDidChange:forRowAtPath:)])
    {
        [self.delegate tableView:self expandStateDidChange:expand forRowAtPath:rowPath];
    }
}

#pragma mark - TSTableViewContentHolderDelegate

- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder contentOffsetDidChange:(CGPoint)contentOffset animated:(BOOL)animated
{
    VerboseLog();
    [_tableControlPanel setContentOffset:CGPointMake(self.tableControlPanel.contentOffset.x, contentOffset.y) animated:animated];
    [_tableHeader setContentOffset:CGPointMake(contentOffset.x, self.tableHeader.contentOffset.y) animated:animated];
}

- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder willSelectRowAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated
{
    VerboseLog();
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtPath:animated:)])
    {
        [self.delegate tableView:self willSelectRowAtPath:rowPath animated:animated];
    }
}

- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder didSelectRowAtPath:(NSIndexPath *)rowPath
{
    VerboseLog();
    if(self.delegate)
    {
        [self.delegate tableView:self didSelectRowAtPath:rowPath];
    }
}

- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder willSelectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated
{
    VerboseLog();
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:willSelectColumnAtPath:animated:)])
    {
        [self.delegate tableView:self willSelectColumnAtPath:columnPath animated:animated];
    }
}

- (void)tableViewContentHolder:(TSTableViewContentHolder *)contentHolder didSelectColumnAtPath:(NSIndexPath *)columnPath
{
    VerboseLog();
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectColumnAtPath:)])
    {
        [self.delegate tableView:self didSelectColumnAtPath:columnPath];
    }
}

#pragma mark - 

- (void)changeExpandStateForRow:(NSIndexPath *)rowPath toValue:(BOOL)expanded animated:(BOOL)animated
{
    VerboseLog();
    [_tableContentHolder changeExpandStateForRow:rowPath toValue:expanded animated:YES];
    [self updateLayout];
}

- (void)expandAllRowsWithAnimation:(BOOL)animated
{
    VerboseLog();
    [_tableControlPanel expandAllRowsWithAnimation:animated];
    [_tableContentHolder  expandAllRowsWithAnimation:animated];
    [self updateLayout];
}

- (void)collapseAllRowsWithAnimation:(BOOL)animated
{
    VerboseLog();
    [_tableControlPanel collapseAllRowsWithAnimation:animated];
    [_tableContentHolder  collapseAllRowsWithAnimation:animated];
    [self updateLayout];
}

- (void)selectRowAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated
{
    [_tableContentHolder selectRowAtPath:rowPath animated:animated];
}

- (void)resetRowSelectionWithAnimtaion:(BOOL)animated
{
    [_tableContentHolder resetRowSelectionWithAnimtaion:YES];
}

- (void)selectColumnAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated
{
    [_tableContentHolder selectRowAtPath:rowPath animated:animated];
}

- (void)resetColumnSelectionWithAnimtaion:(BOOL)animated
{
    [_tableContentHolder resetColumnSelectionWithAnimtaion:YES];
}

- (NSIndexPath *)pathToSelectedRow
{
    return [_tableContentHolder pathToSelectedRow];
}

- (NSIndexPath *)pathToSelectedColumn
{
    return [_tableContentHolder pathToSelectedColumn];
}

#pragma mark - Provide TSTableViewDataSource functionality

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if(!signature)
        signature = [(id)self.dataSource methodSignatureForSelector:aSelector];
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.dataSource respondsToSelector:[anInvocation selector]])
        [anInvocation invokeWithTarget:self.dataSource];
    else
        [super forwardInvocation:anInvocation];
}

#pragma mark - TSTableViewAppearanceCoordinator

- (BOOL)isRowExpanded:(NSIndexPath *)indexPath
{
    return [_tableControlPanel isRowExpanded:indexPath];
}

- (BOOL)isRowVisible:(NSIndexPath *)indexPath
{
    return [_tableControlPanel isRowVisible:indexPath];
}

- (UIImage *)controlPanelExpandItemNormalBackgroundImage
{
    return _expandItemNormalBackgroundImage;
}

- (UIImage *)controlPanelExpandItemSelectedBackgroundImage
{
    return _expandItemSelectedBackgroundImage;
}

- (UIImage *)controlPanelExpandSectionBackgroundImage
{
    return _expandSectionBackgroundImage;
}

- (BOOL)lineNumbersAreHidden
{
    return _lineNumbersHidden;
}

- (BOOL)highlightControlsOnTap
{
    return _highlightControlsOnTap;
}

- (UIColor *)lineNumbersColor
{
    return _lineNumbersColor;
}

- (CGFloat)tableTotalWidth
{
    VerboseLog();
    return [_tableHeader tableTotalWidth];
}

- (CGFloat)tableTotalHeight
{
    VerboseLog();
    return [_tableControlPanel tableTotalHeight];
}

- (CGFloat)tableHeight
{
    VerboseLog();
    return [_tableControlPanel tableHeight];
}

- (CGFloat)widthForColumnAtIndex:(NSInteger)columnIndex
{
    VerboseLog();
    return [_tableHeader widthForColumnAtIndex:columnIndex];
}

- (CGFloat)widthForColumnAtPath:(NSIndexPath *)columnPath
{
    VerboseLog();
    return [_tableHeader widthForColumnAtPath:columnPath];
}

- (CGFloat)offsetForColumnAtPath:(NSIndexPath *)columnPath
{
    VerboseLog();
    return [_tableHeader offsetForColumnAtPath:columnPath];
}

- (CGFloat)defaultWidthForColumnAtIndex:(NSInteger)index
{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(defaultWidthForColumnAtIndex:)])
    {
        return [self.dataSource defaultWidthForColumnAtIndex:index];
    }
    return DEF_TABLE_DEF_COLUMN_WIDTH;
}

- (CGFloat)minimalWidthForColumnAtIndex:(NSInteger)index
{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(minimalWidthForColumnAtIndex:)])
    {
        return [self.dataSource minimalWidthForColumnAtIndex:index];
    }
    return DEF_TABLE_MIN_COLUMN_WIDTH;
}
- (CGFloat)maximalWidthForColumnAtIndex:(NSInteger)index
{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(maximalWidthForColumnAtIndex:)])
    {
        return [self.dataSource maximalWidthForColumnAtIndex:index];
    }
    return DEF_TABLE_MAX_COLUMN_WIDTH;
}

- (TSTableViewCell *)cellViewForRowAtPath:(NSIndexPath *)indexPath cellIndex:(NSInteger)index
{
    return [self.dataSource tableView:self cellViewForRowAtPath:indexPath cellIndex:index];
}

- (TSTableViewHeaderSectionView *)headerSectionViewForColumnAtPath:(NSIndexPath *)indexPath
{
    return [self.dataSource tableView:self headerSectionViewForColumnAtPath:indexPath];
}

#pragma mark - Modify content

- (void)insertRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    [_tableControlPanel insertRowAtPath:path animated:animated];
    [_tableContentHolder insertRowAtPath:path animated:animated];
    [TSUtils performViewAnimationBlock:^{
        [self updateLayout];
    } withCompletion:nil animated:animated];
}

- (void)removeRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    [_tableControlPanel removeRowAtPath:path animated:animated];
    [_tableContentHolder removeRowAtPath:path animated:animated];
    [TSUtils performViewAnimationBlock:^{
        [self updateLayout];
    } withCompletion:nil animated:animated];
}

- (void)updateRowAtPath:(NSIndexPath *)path
{
    [_tableContentHolder updateRowAtPath:path];
}

- (void)insertRowsAtPathes:(NSArray *)pathes animated:(BOOL)animated
{
     NSAssert(FALSE, @"Not implemented");
}

- (void)updateRowsAtPathes:(NSArray *)pathes animated:(BOOL)animated
{
    NSAssert(FALSE, @"Not implemented");
}

- (void)removeRowsAtPathes:(NSArray *)pathes animated:(BOOL)animated
{
     NSAssert(FALSE, @"Not implemented");
}

@end