//
//  TSTableViewExpandControlPanel.m
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/12/13.
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

#import "TSTableViewExpandControlPanel.h"
#import "TStableViewDataSource.h"
#import "TSTableViewAppearanceCoordinator.h"
#import "TSTableViewExpandSection.h"
#import "TSUtils.h"
#import "TSDefines.h"


@interface TSTableViewExpandControlPanel ()
{
    NSMutableArray* _rows;
    NSInteger _maxNestingLevel;
    CGFloat _totalWidth;
    CGFloat _totalHeight;
}

@end

@implementation TSTableViewExpandControlPanel

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

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if([view isKindOfClass:[UIButton class]])
    {
        return YES;
    }
    return NO;
}

- (void)initialize
{
    VerboseLog();
    
    self.backgroundColor = [UIColor lightGrayColor];
    self.delaysContentTouches = YES;
    self.canCancelContentTouches = YES;
    self.scrollEnabled = NO;
    
    _rows = [[NSMutableArray alloc] init];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self updateRowsVisibility];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [super setContentOffset:contentOffset  animated:animated];
    [self updateRowsVisibility];
}

#pragma mark - Expand button

- (void)addExpandButtonAtPath:(NSIndexPath *)rowPath expandRowView:(TSTableViewExpandSection *)expandRow
{
    VerboseLog();
    NSInteger numberOfRows = [self.dataSource numberOfRowsAtPath:rowPath];
    if(numberOfRows)
    {
        UIImage *normalImage = [self.dataSource controlPanelExpandItemNormalBackgroundImage];
        UIImage *selectedImage = [self.dataSource controlPanelExpandItemSelectedBackgroundImage];
        CGFloat rowHeight = [self.dataSource heightForRowAtPath:rowPath];
        UIButton *expandBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, expandRow.frame.size.width, rowHeight)];
        expandBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        expandBtn.showsTouchWhenHighlighted = [self.dataSource highlightControlsOnTap];
        expandBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        expandBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [expandBtn setImage:normalImage forState:UIControlStateNormal];
        [expandBtn setImage:normalImage forState:UIControlStateHighlighted];
        [expandBtn setImage:selectedImage forState:UIControlStateSelected];
        [expandBtn setImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
        [expandBtn addTarget:self action:@selector(expandBtnTouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        expandBtn.selected = YES;
        expandRow.expandButton = expandBtn;
    }
}

- (void)expandBtnTouchUpInside:(UIButton *)sender withEvent:(UIEvent *)event
{
    VerboseLog();
    TSTableViewExpandSection *rowView = (TSTableViewExpandSection *)sender.superview;
    [self changeExpandStateForRow:rowView.rowPath toValue:!sender.selected animated:YES];
    if(self.controlPanelDelegate)
    {
        [self.controlPanelDelegate tableViewSideControlPanel:self expandStateDidChange:sender.selected forRow:rowView.rowPath];
    }
}

#pragma mark -

- (void)reloadData
{
    VerboseLog();
    for(TSTableViewExpandSection *row in _rows)
    {
        [row removeFromSuperview];
    }
    [_rows removeAllObjects];
    
    if(self.dataSource)
    {
        [self loadSubrowsForRowAtPath:nil expandRowView:nil];
        [self updateLayout];
        [self updateLineNumbers];
        [self updateRowsVisibility];
    }
}

- (void)loadSubrowsForRowAtPath:(NSIndexPath *)rowPath expandRowView:(TSTableViewExpandSection *)parentRowView 
{
    VerboseLog();
    NSInteger numberOfRows = [self.dataSource numberOfRowsAtPath:rowPath];
    if(numberOfRows)
    {
        CGFloat controlPanelExpandButtonWidth = [self.dataSource widthForExpandItem];
        UIImage *controlPanelExpandBackImage = [self.dataSource controlPanelExpandSectionBackgroundImage];
        NSMutableArray *newRows = [[NSMutableArray alloc] init];
        for(int j = 0; j < numberOfRows; ++j)
        {
            NSIndexPath *subrowPath;
            if(rowPath)
                subrowPath = [rowPath indexPathByAddingIndex:j];
            else
                subrowPath = [NSIndexPath indexPathWithIndex:j];
            
            CGFloat rowHeight = [self.dataSource heightForRowAtPath:subrowPath];
            TSTableViewExpandSection *rowView = [[TSTableViewExpandSection alloc] initWithFrame:CGRectMake(0, 0,controlPanelExpandButtonWidth, rowHeight)];
            rowView.rowPath = subrowPath;
            rowView.rowHeight = rowHeight;
            if(controlPanelExpandBackImage)
            {
                rowView.backgroundImage.image = controlPanelExpandBackImage;
            }
            if(![self.dataSource lineNumbersAreHidden])
            {
                rowView.lineLabel.textColor = [self.dataSource lineNumbersColor];
            }
            [self addExpandButtonAtPath:subrowPath expandRowView:rowView];
            [self loadSubrowsForRowAtPath:subrowPath expandRowView:rowView];
            
            [newRows addObject:rowView];
        }
        
        if(parentRowView)
        {
            parentRowView.subrows = newRows;
        }
        else
        {
            [_rows addObjectsFromArray:newRows];
            for(UIView *row in _rows)
                [self addSubview:row];
        }
    }
}

#pragma mark - Modify content

- (void)changeExpandStateForRow:(NSIndexPath *)rowPath toValue:(BOOL)expanded animated:(BOOL)animated
{
    VerboseLog();
    [self changeExpandStateForSubrows:_rows rowsIndexInPath:0 fullPath:rowPath toValue:expanded animated:animated];
    [self updateRowsVisibility];
}

- (void)changeExpandStateForSubrows:(NSArray *)subrows rowsIndexInPath:(NSInteger)index fullPath:(NSIndexPath *)rowPath toValue:(BOOL)expanded animated:(BOOL)animated
{
    VerboseLog();
    NSInteger subRowIndex = [rowPath indexAtPosition:index];
    TSTableViewExpandSection *subRow = subrows[subRowIndex];
    CGFloat prevHeight = subRow.frame.size.height;
    
    // calculate new size of subrows
    if(index < rowPath.length - 1)
        [self changeExpandStateForSubrows:subRow.subrows rowsIndexInPath:index + 1 fullPath:rowPath toValue:expanded animated:animated];
    else
        subRow.expanded = expanded;
    
    if(expanded)
        subRow.expanded = YES;
    
    // back to this row and update its size
    [TSUtils performViewAnimationBlock:^{
        CGRect rect = subRow.frame;
        rect.size.height = [self heightForRow:subRow includingSubrows:subRow.expanded];
        subRow.frame = rect;
    } withCompletion:nil animated:animated];
    
    // change position of rows that are follow modified row
    CGFloat delta = subRow.frame.size.height - prevHeight;
    [TSUtils performViewAnimationBlock:^{
        for(int i = subRowIndex + 1; i < subrows.count; ++i)
        {
            TSTableViewExpandSection *row = subrows[i];
            CGRect rect = row.frame;
            rect.origin.y += delta;
            row.frame = rect;
        }
    } withCompletion:nil animated:animated];
}

- (CGFloat)heightForRow:(TSTableViewExpandSection *)rowView includingSubrows:(BOOL)withSubrows
{
    VerboseLog();
    CGFloat height = rowView.rowHeight;
    if(withSubrows)
    {
        for (TSTableViewExpandSection *subrow in rowView.subrows)
        {
            height += subrow.frame.size.height;
        }
    }
    return height;
}

- (TSTableViewExpandSection *)rowAtPath:(NSIndexPath *)rowPath
{
    VerboseLog();
    TSTableViewExpandSection *row;
    for(int i = 0; i < rowPath.length; ++i)
    {
        NSInteger index = [rowPath indexAtPosition:i];
        if(i == 0)
            row = _rows[index];
        else
            row = row.subrows[index];
    }
    return row;
}

- (BOOL)isRowExpanded:(NSIndexPath *)rowPath
{
    VerboseLog();
    return [self rowAtPath:rowPath].expanded;
}

- (BOOL)isRowVisible:(NSIndexPath *)rowPath
{
    VerboseLog();
    BOOL visible = YES;
    TSTableViewExpandSection *row;
    for(int i = 0; i < rowPath.length - 1;  ++i)
    {
        NSInteger index = [rowPath indexAtPosition:i];
        if(i == 0)
            row = _rows[index];
        else
            row = row.subrows[index];
        if(!row.expanded)
        {
            visible = FALSE;
            break;
        }
    }
    return visible;
}

- (void)expandAllRowsWithAnimation:(BOOL)animated
{
    VerboseLog();
    [self changeExpandStateForAllSubrows:_rows rowsPath:nil toValue:YES animated:animated];
    [self updateRowsVisibility];
}

- (void)collapseAllRowsWithAnimation:(BOOL)animated
{
    VerboseLog();
    [self changeExpandStateForAllSubrows:_rows rowsPath:nil toValue:NO animated:animated];
    [self updateRowsVisibility];
}

- (void)changeExpandStateForAllSubrows:(NSArray *)subrows rowsPath:(NSIndexPath *)rowsPath toValue:(BOOL)expanded animated:(BOOL)animated
{
    VerboseLog();
    for(int i = 0; i < subrows.count;  ++i)
    {
        TSTableViewExpandSection *subRow = subrows[i];
        NSIndexPath *subrowPath = (rowsPath ? [rowsPath indexPathByAddingIndex:i] : [NSIndexPath indexPathWithIndex:i]);
        if(subRow.subrows.count)
        {
            [self changeExpandStateForAllSubrows:subRow.subrows rowsPath:subrowPath toValue:expanded animated:animated];
        }
    }
    
    // change position and size of rows
    [TSUtils performViewAnimationBlock:^{
        CGFloat yOffset = 0;
        for(int i = 0; i < subrows.count;  ++i)
        {
            TSTableViewExpandSection *row = subrows[i];
            row.expanded = expanded;
            // first row in group may have offset that is not equal to 0
            if(i == 0)
                yOffset = row.frame.origin.y;
            CGRect rect = row.frame;
            rect.size.height = [self heightForRow:row includingSubrows:expanded];
            rect.origin.y = yOffset;
            row.frame = rect;
            
            yOffset += rect.size.height;
        }
    } withCompletion:nil animated:animated];
}

#pragma mark - Getters

- (CGFloat)tableHeight
{
    VerboseLog();
    CGFloat height = 0;
    for(TSTableViewExpandSection * row in _rows)
    {
        height += row.frame.size.height;
    }
    return height;
}

- (CGFloat)tableTotalHeight
{
    VerboseLog();
    return _totalHeight;//  [self heightForRows:_rows];
}

- (CGFloat)heightForRows:(NSArray *)rows
{
    VerboseLog();
    CGFloat height = 0;
    for(TSTableViewExpandSection * row in rows)
    {
        height += row.rowHeight;
        if(row.subrows.count)
        {
            height += [self heightForRows:rows];
        }
    }
    return height;
}

- (CGFloat)panelWidth
{
    VerboseLog();
    return _totalWidth;
}

#pragma mark - Modify content


- (void)insertRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    // Find subrows where new row should be inserted
    TSTableViewExpandSection *row;
    NSMutableArray *rows = _rows;
    for(int i = 0; i < path.length - 1;  ++i)
    {
        NSInteger index = [path indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    
    // Find position where new row should be inserted
    NSInteger lastIndex = [path indexAtPosition:path.length - 1];
    UIImage *controlPanelExpandBackImage = [self.dataSource controlPanelExpandSectionBackgroundImage];
    CGFloat rowHeight = [self.dataSource heightForRowAtPath:path];
    TSTableViewExpandSection *newRowView = [[TSTableViewExpandSection alloc] initWithFrame:CGRectMake(0, 0, _totalWidth, rowHeight)];
    newRowView.rowPath = path;
    newRowView.rowHeight = rowHeight;
    if(controlPanelExpandBackImage)
    {
        newRowView.backgroundImage.image = controlPanelExpandBackImage;
    }
    if(![self.dataSource lineNumbersAreHidden])
    {
        newRowView.lineLabel.textColor = [self.dataSource lineNumbersColor];
    }
    if(rows.count > lastIndex)
    {
        TSTableViewExpandSection *prevRow = rows[lastIndex];
        newRowView.frame = CGRectMake(prevRow.frame.origin.x, prevRow.frame.origin.y, _totalWidth, rowHeight);
        if(row)
            [row insertSubview:newRowView belowSubview:prevRow];
        else
            [self insertSubview:newRowView belowSubview:prevRow];
    }
    else if(row)
    {
        newRowView.frame = CGRectMake(0, row.rowHeight, _totalWidth, rowHeight);
        [row addSubview:newRowView];
    }
    else
    {
        [self addSubview:newRowView];
    }
    [self addExpandButtonAtPath:path expandRowView:newRowView];
    [self loadSubrowsForRowAtPath:path expandRowView:newRowView];
    [rows insertObject:newRowView atIndex:lastIndex];
    
    // Check if parent row has expand button and add it if needed
    if(!row.expandButton)
        [self addExpandButtonAtPath:[path indexPathByRemovingLastIndex] expandRowView:row];

    //Update indexPathes for expand buttons following after removed item
    NSIndexPath *basePath = [path indexPathByRemovingLastIndex];
    for(int i = lastIndex; i < rows.count; ++i)
    {
        row = rows[i];
        row.rowPath = [basePath indexPathByAddingIndex:i];
        [self updateIndexPathForRows:row.subrows parentPath:row.rowPath];
    }
    
    [TSUtils performViewAnimationBlock:^{
        [self updateLayout];
    } withCompletion:nil animated:animated];
    [self updateLineNumbers];
    [self updateRowsVisibility];
}

- (void)removeRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    // Find subrows where row should be removed
    TSTableViewExpandSection *row;
    NSMutableArray *rows = _rows;
    for(int i = 0; i < path.length - 1; ++i)
    {
        NSInteger index = [path indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    
    // Find position where new row should be inserted
    NSInteger lastIndex = [path indexAtPosition:path.length - 1];
    TSTableViewExpandSection *removedRow = rows[lastIndex];
    [removedRow removeFromSuperview];
    [rows removeObject:removedRow];
    
    if(rows.count == 0)
        row.expandButton = nil;
    
    //Update indexPathes for expand buttons following after removed item
    NSIndexPath *basePath = [path indexPathByRemovingLastIndex];
    for(int i = lastIndex; i < rows.count; ++i)
    {
        row = rows[i];
        row.rowPath = [basePath indexPathByAddingIndex:i];
        [self updateIndexPathForRows:row.subrows parentPath:row.rowPath];
    }
    
    [TSUtils performViewAnimationBlock:^{
        [self updateLayout];
    } withCompletion:nil animated:animated];
    [self updateLineNumbers];
    [self updateRowsVisibility];
}

- (void)updateIndexPathForRows:(NSArray *)rows parentPath:(NSIndexPath *)indexPath
{
    for(int i = 0; i < rows.count; ++i)
    {
        TSTableViewExpandSection *row = rows[i];
        row.rowPath = [indexPath indexPathByAddingIndex:i];
        [self updateIndexPathForRows:row.subrows parentPath:row.rowPath];
    }
}

#pragma mark - Update layout

- (void)updateLineNumbers
{
     if([self.dataSource lineNumbersAreHidden]) return;
    [self updateLineNumbersForRows:_rows];
}

- (void)updateRowsVisibility
{
    for(int i = 0; i < _rows.count; ++i)
    {
        TSTableViewExpandSection *row = _rows[i];
        if((self.contentOffset.y <= CGRectGetMinY(row.frame) && CGRectGetMinY(row.frame) <= self.contentOffset.y + self.bounds.size.height) ||
           (self.contentOffset.y <= CGRectGetMaxY(row.frame) && CGRectGetMaxY(row.frame) <= self.contentOffset.y + self.bounds.size.height) ||
           (CGRectGetMinY(row.frame) < self.contentOffset.y && self.contentOffset.y + self.bounds.size.height < CGRectGetMaxY(row.frame)))
        {
            row.hidden = NO;
        }
        else
        {
            row.hidden = YES;
        }
    }
}

- (void)updateLineNumbersForRows:(NSArray *)rows
{
    for(int i = 0; i < rows.count; ++i)
    {
        TSTableViewExpandSection *row = rows[i];
        [row setLineNumber:i + 1];
        if(row.subrows.count)
            [self updateLineNumbersForRows:row.subrows];
    }
}

- (void)updateLayout
{
    _totalHeight = 0;
    _totalWidth = 0;
    _maxNestingLevel = 0;
    [self updateLayoutForRows:_rows yOffset:0 xOffset:0 totalWidth:&_totalWidth totalHeight:&_totalHeight nestingLevel:&_maxNestingLevel];
    [self adjustRowWidthTo:_totalWidth forRows:_rows];
}

- (void)updateLayoutForRows:(NSArray *)rows
                    yOffset:(CGFloat)yOffset
                    xOffset:(CGFloat)xOffset
                 totalWidth:(CGFloat *)totalWidth
                totalHeight:(CGFloat *)totalHeight
               nestingLevel:(NSInteger *)maxNestingLevel
{
    CGFloat controlPanelExpandButtonWidth = [self.dataSource widthForExpandItem];
    CGFloat maxWidth = 0;
    NSInteger maxNestLevel = 0;
    for(int i = 0; i < rows.count; ++i)
    {
        TSTableViewExpandSection *row = rows[i];
        CGFloat rowHeight = row.rowHeight;
        CGFloat totalRowHeight = rowHeight;
        CGFloat totalRowWidth = controlPanelExpandButtonWidth;
        NSInteger nestingLevel = 1;
        if(row.subrows.count)
        {
            [self updateLayoutForRows:row.subrows
                              yOffset:totalRowHeight
                              xOffset:totalRowWidth
                           totalWidth:&totalRowWidth
                          totalHeight:&totalRowHeight
                          nestingLevel:&nestingLevel];
        }
        CGFloat visibleHeight = [self heightForRow:row includingSubrows:row.expanded];
        row.frame = CGRectMake(xOffset, yOffset, row.frame.size.width, visibleHeight);
        yOffset += visibleHeight;
        *totalHeight += totalRowHeight;
        
        if(totalRowWidth > maxWidth)
            maxWidth = totalRowWidth;
        
        if(nestingLevel > maxNestLevel)
            maxNestLevel = nestingLevel;
    }
    *totalWidth += maxWidth;
    *maxNestingLevel += maxNestLevel;
}

- (void)adjustRowWidthTo:(CGFloat)rowWidth forRows:(NSArray *)rows
{
    CGFloat controlPanelExpandButtonWidth = [self.dataSource widthForExpandItem];
    for(int i = 0; i < rows.count; ++i)
    {
        TSTableViewExpandSection *row = rows[i];
        row.frame = CGRectMake(row.frame.origin.x, row.frame.origin.y, rowWidth, row.frame.size.height);
        if(row.subrows.count)
        {
            [self adjustRowWidthTo:rowWidth - controlPanelExpandButtonWidth  forRows:row.subrows];
        }
    }
}

@end
