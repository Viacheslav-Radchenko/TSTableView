//
//  TSTableViewContentHolder.m
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/13/13.
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

#import "TSTableViewContentHolder.h"
#import "TSTableViewDataSource.h"
#import "TSTableViewAppearanceCoordinator.h"
#import "TSTableViewRow.h"
#import "TSTableViewCell.h"
#import "TSUtils.h"
#import "TSDefines.h"

 

/**
    @abstract Selection rectangle view
 */

@interface TSTableViewSelection : UIView

@property (nonatomic, strong) NSIndexPath *selectedItem;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIColor *selectionColor;

@end

@implementation TSTableViewSelection

-(id)init
{
    if(self = [super init])
    {
        [self initialize];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_imageView];
    
    self.selectionColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.25f];
}

- (void)setSelectionColor:(UIColor *)selectionColor
{
    _selectionColor = selectionColor;
    UIImage *image = [TSUtils imageWithInnerShadow:_selectionColor.CGColor blurSize:16 andSize:CGSizeMake(32,32)];
    
    _imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
//    _imageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)];
}

@end

/**************************************************************************************************************************************/

@interface  TSTableViewContentHolder ()
{
    NSMutableDictionary *_reusableCells;
    NSMutableArray *_reusableRows;
    NSMutableArray *_rows;
    CGFloat _tableWidth;
}

@property (nonatomic, strong) TSTableViewSelection *rowSelectionView;
@property (nonatomic, strong) TSTableViewSelection *columnSelectionView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation TSTableViewContentHolder

@dynamic rowSelectionColor;
@dynamic columnSelectionColor;

-(id) init
{
    if(self = [super init])
    {
        [self initialize];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if([view isKindOfClass:[TSTableViewCell class]] ||
       [view isKindOfClass:[TSTableViewRow class]] ||
       [view isKindOfClass:[TSTableViewSelection class]])
    {
        return YES;
    }
    return NO;
}

- (void)initialize
{
    VerboseLog();
    self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.delaysContentTouches = YES;
    self.canCancelContentTouches = YES;
    self.alwaysBounceVertical = YES;
    //self.alwaysBounceHorizontal = YES;
    
    _allowRowSelection = YES;
    _rows = [[NSMutableArray alloc] init];
    _reusableCells = [[NSMutableDictionary alloc] init];
    _reusableRows = [[NSMutableArray alloc] init];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidRecognized:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
}

- (TSTableViewSelection *)rowSelectionView
{
    if(!_rowSelectionView)
    {
        _rowSelectionView = [[TSTableViewSelection alloc] init];
        _rowSelectionView.alpha = 0;
        _rowSelectionView.hidden = YES;
        _rowSelectionView.selectionColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.25f];;
        [self addSubview:_rowSelectionView];
    }
    return _rowSelectionView;
}

- (TSTableViewSelection *)columnSelectionView
{
    if(!_columnSelectionView)
    {
        _columnSelectionView = [[TSTableViewSelection alloc] init];
        _columnSelectionView.alpha = 0;
        _columnSelectionView.hidden = YES;
        _columnSelectionView.selectionColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.25f];;
        [self addSubview:_columnSelectionView];
    }
    return _columnSelectionView;
}

#pragma mark - Setters 

-(void)setContentOffset:(CGPoint)contentOffset
{
    VerboseLog();
    [super setContentOffset:contentOffset];
    [self updateRowsVisibility];
    if(self.contentHolderDelegate)
    {
        [self.contentHolderDelegate tableViewContentHolder:self contentOffsetDidChange:contentOffset animated:NO];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    VerboseLog();
    [super setContentOffset:contentOffset animated:(BOOL)animated];
    [self updateRowsVisibility];
    if(self.contentHolderDelegate)
    {
        [self.contentHolderDelegate tableViewContentHolder:self contentOffsetDidChange:contentOffset animated:animated];
    }
}

- (void)setRowSelectionColor:(UIColor *)color
{
    _rowSelectionView.selectionColor = color;
}

- (UIColor *)rowSelectionColor
{
    return _rowSelectionView.selectionColor;
}

- (void)setColumnSelectionColor:(UIColor *)color
{
    _columnSelectionView.selectionColor = color;
}

- (UIColor *)columnSelectionColor
{
    return _columnSelectionView.selectionColor;
}

#pragma mark - Reuse

- (TSTableViewRow *)dequeueReusableRowView
{
   // NSLog(@"Reusable rows available: %d",_reusableRows.count);
    TSTableViewRow *rowView = [_reusableRows lastObject];
    if(rowView)
        [_reusableRows removeObject:rowView];
    return rowView;
}

- (void)addReusableRow:(TSTableViewRow *)row
{
    [_reusableRows addObject:row];
}

- (TSTableViewCell *)dequeueReusableCellViewWithIdentifier:(NSString *)identifier
{
    VerboseLog();
    NSMutableArray *cells = _reusableCells[identifier];
    if(cells)
    {
       // NSLog(@"Reusable cells '%@' available: %d", identifier, _reusableRows.count);
        TSTableViewCell *cellView = [cells lastObject];
        if(cellView)
            [cells removeObject:cellView];
        
        [cellView prepareForReuse];
        return cellView;
    }
    return nil;
}

- (void)addReusableCell:(TSTableViewCell *)cell
{
    NSMutableArray *cells = _reusableCells[cell.reuseIdentifier];
    if(!cells)
    {
        cells = [[NSMutableArray alloc] init];
        _reusableCells[cell.reuseIdentifier] = cells;
    }
    [cells addObject:cell];
}

- (void)clearCachedData
{
    [_reusableCells removeAllObjects];
    [_reusableRows removeAllObjects];
}

#pragma mark - Load data

- (void)reloadData
{
    VerboseLog();
    for(TSTableViewRowProxy *row in _rows)
    {
        if(row.rowView)
            [row.rowView removeFromSuperview];
    }
    [_rows removeAllObjects];
    
    [self resetColumnSelectionWithAnimtaion:NO];
    [self resetRowSelectionWithAnimtaion:NO];
    
    if(self.dataSource)
    {
        [self loadSubrowsForRowAtPath:nil rowView:nil];
        [self updateLayoutAnimated:NO];
        [self updateRowsVisibility];
    }
    
    if(_rowSelectionView)
    {
        [self bringSubviewToFront:_rowSelectionView];
    }
}

- (void)loadSubrowsForRowAtPath:(NSIndexPath *)rowPath rowView:(TSTableViewRowProxy *)parentRow 
{
    VerboseLog();
    NSInteger numberOfRows = [self.dataSource numberOfRowsAtPath:rowPath];
    if(numberOfRows)
    {
        NSMutableArray *subRows = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
        for(int j = 0; j < numberOfRows;  ++j)
        {
            NSIndexPath *subrowPath;
            if(rowPath)
                subrowPath = [rowPath indexPathByAddingIndex:j];
            else
                subrowPath = [NSIndexPath indexPathWithIndex:j];
            
            CGFloat rowHeight = [self.dataSource heightForRowAtPath:rowPath];
            TSTableViewRowProxy *row = [[TSTableViewRowProxy alloc] init];
            row.rowHeight = rowHeight;
            [self loadSubrowsForRowAtPath:subrowPath rowView:row];
            [subRows addObject:row];
        }
        
        if(parentRow)
            parentRow.subrows = subRows;
        else
            [_rows addObjectsFromArray:subRows];
    }
}

- (void)loadRow:(TSTableViewRowProxy *)row atPath:(NSIndexPath *)rowPath parentView:(UIView *)parentView
{
    VerboseLog();
    NSInteger numberOfColumns = [self.dataSource numberOfColumns];
    NSMutableArray *newCells = [[NSMutableArray alloc] initWithCapacity:numberOfColumns];
    CGFloat xOffset = 0;
    for(int j = 0; j < numberOfColumns;  ++j)
    {
        CGFloat columnWidth = [self.dataSource widthForColumnAtIndex:j];
        TSTableViewCell *cellView = [self.dataSource cellViewForRowAtPath:rowPath cellIndex:j];
        cellView.frame = CGRectMake(xOffset, 0, columnWidth, row.rowHeight);
        [newCells addObject:cellView];
        xOffset += columnWidth;
    }
    TSTableViewRow *rowView = [self dequeueReusableRowView];
    if(!rowView)
        rowView = [[TSTableViewRow alloc] init];
    rowView.cells = [NSArray arrayWithArray:newCells];
    //[parentView addSubview:rowView];
    //if addSubview: is used during scrolling rows overlapping horizontal/vertical scoll indicators of UIScrollView
    [parentView insertSubview:rowView atIndex:0];
    row.rowView = rowView;
    for(int j = 0; j < row.subrows.count;  ++j)
    {
        TSTableViewRowProxy *subrow = row.subrows[j];
        NSIndexPath *indexPath = [rowPath indexPathByAddingIndex:j];
        [self loadRow:subrow atPath:indexPath parentView:row.rowView];
    }
}

#pragma mark -

- (void)updateRowsVisibility
{
    VerboseLog();
    CGFloat tresholdOffset = self.bounds.size.height/3;
    CGFloat topTreshold = self.contentOffset.y - tresholdOffset;
    CGFloat bottomTreshold = self.contentOffset.y + self.bounds.size.height + tresholdOffset;
    for(int i = 0; i < _rows.count;  ++i)
    {
        TSTableViewRowProxy *row = _rows[i];
        if((topTreshold <= CGRectGetMinY(row.frame) && CGRectGetMinY(row.frame) <= bottomTreshold) ||
           (topTreshold <= CGRectGetMaxY(row.frame) && CGRectGetMaxY(row.frame) <= bottomTreshold) ||
           (CGRectGetMinY(row.frame) < topTreshold && bottomTreshold < CGRectGetMaxY(row.frame)))
        {
            if(!row.rowView)
                [self rowWillAppear:row atPath:[NSIndexPath indexPathWithIndex:i]];
        }
        else
        {
            if(row.rowView)
                [self rowWillDissapear:row];
        }
    }
}

- (void)updateRowsVisibilityWithAnimation:(BOOL)animated
{
    VerboseLog();
    if(animated) // first show new visible rows and after delay hide not visible (because they could be still on screen while animation is in progress)
    {
        CGFloat tresholdOffset = self.bounds.size.height/3;
        CGFloat topTreshold = self.contentOffset.y - tresholdOffset;
        CGFloat bottomTreshold = self.contentOffset.y + self.bounds.size.height + tresholdOffset;
        for(int i = 0; i < _rows.count;  ++i)
        {
            TSTableViewRowProxy *row = _rows[i];
            if((topTreshold <= CGRectGetMinY(row.frame) && CGRectGetMinY(row.frame) <= bottomTreshold) ||
               (topTreshold <= CGRectGetMaxY(row.frame) && CGRectGetMaxY(row.frame) <= bottomTreshold) ||
               (CGRectGetMinY(row.frame) < topTreshold && bottomTreshold < CGRectGetMaxY(row.frame)))
            {
                if(!row.rowView)
                    [self rowWillAppear:row atPath:[NSIndexPath indexPathWithIndex:i]];
            }
        }
        
        [TSUtils performViewAnimationBlock:nil withCompletion:^{
            [self updateRowsVisibility];
        } animated:YES];
    }
    else
    {
        [self updateRowsVisibility];
    }
}

- (void)rowWillAppear:(TSTableViewRowProxy *)row atPath:(NSIndexPath *)rowPath
{
    VerboseLog();
    [self loadRow:row atPath:rowPath parentView:self];
}

- (void)rowWillDissapear:(TSTableViewRowProxy *)row
{
    VerboseLog();
    for(TSTableViewCell *cell in row.rowView.cells)
    {
        [self addReusableCell:cell];
    }
    row.rowView.cells = nil;
    
    for(TSTableViewRowProxy *r in row.subrows)
    {
        [self rowWillDissapear:r];
    }
    
    [row.rowView removeFromSuperview];
    [self addReusableRow:row.rowView];
    row.rowView = nil;
}

- (void)updateLayoutAnimated:(BOOL)animated
{
    CGFloat totalHeight = 0;
    _tableWidth = [self.dataSource tableTotalWidth];
    [self updateLayoutForRows:_rows atPath:nil yOffset:&totalHeight animated:animated];
}

- (void)updateLayoutForRows:(NSArray *)rows atPath:(NSIndexPath *)path yOffset:(CGFloat *)yOffset animated:(BOOL)animated
{
    for(int i = 0; i < rows.count;  ++i)
    {
        NSIndexPath *rowPath;
        if(path)
            rowPath = [path indexPathByAddingIndex:i];
        else
            rowPath = [NSIndexPath indexPathWithIndex:i];
        
        TSTableViewRowProxy *row = rows[i];
        CGFloat totalRowHeight = row.rowHeight;
        CGFloat offset = *yOffset;

        if(row.subrows.count)
        {
            [self updateLayoutForRows:row.subrows atPath:rowPath yOffset:&totalRowHeight animated:animated];
        }
        CGFloat visibleHeight = [self heightForRow:row includingSubrows:[self.dataSource isRowExpanded:rowPath]];
        [row setFrame:CGRectMake(row.frame.origin.x, offset, _tableWidth, visibleHeight) animated:animated];
        *yOffset += visibleHeight;
    }
}

#pragma mark - Modify content

- (void)changeColumnWidthOnAmount:(CGFloat)delta forColumn:(NSInteger)columnIndex animated:(BOOL)animated
{
    VerboseLog();
    [self changeColumnWidthForRows:_rows onAmount:delta forColumn:columnIndex animated:animated];
    [self updateRowSelectionWithAnimation:animated];
    [self updateColumnSelectionWithAnimation:animated];
}

- (void)changeColumnWidthForRows:(NSArray *)rows onAmount:(CGFloat)delta forColumn:(NSInteger)columnIndex animated:(BOOL)animated
{
    VerboseLog();
    for (TSTableViewRowProxy *row in rows)
    {
        [self changeColumnWidthForRows:row.subrows onAmount:delta forColumn:columnIndex animated:animated];
        [TSUtils performViewAnimationBlock:^{
            CGRect rect = row.frame;
            rect.size.width += delta;
            row.frame = rect;
            if(row.rowView)
            {
                for(int i = columnIndex; i < row.rowView.cells.count;  ++i)
                {
                    TSTableViewCell *cell = row.rowView.cells[i];
                    CGRect rect = cell.frame;
                    if(i == columnIndex)
                        rect.size.width += delta;
                    else
                        rect.origin.x += delta;
                    cell.frame = rect;
                }
            }
        } withCompletion:nil animated:animated];
    }
}

- (void)changeExpandStateForRow:(NSIndexPath *)rowPath toValue:(BOOL)expanded animated:(BOOL)animated
{
    VerboseLog();
    [self changeExpandStateForSubrows:_rows rowsIndexInPath:0 fullPath:rowPath toValue:expanded animated:animated];
    [self updateRowSelectionWithAnimation:animated];
    [self updateColumnSelectionWithAnimation:animated];
    if(expanded) // if row expands sibling rows may still be visible during animation
        [self updateRowsVisibilityWithAnimation:animated];
    else
        [self updateRowsVisibility];
}

- (void)changeExpandStateForSubrows:(NSArray *)subrows rowsIndexInPath:(NSInteger)index fullPath:(NSIndexPath *)rowPath toValue:(BOOL)expanded animated:(BOOL)animated
{
    VerboseLog();
    NSInteger subRowIndex = [rowPath indexAtPosition:index];
    NSUInteger indexes[index + 1];
    [rowPath getIndexes:indexes];
    NSIndexPath *subRowIndexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:index + 1];
    TSTableViewRowProxy *subRow = subrows[subRowIndex];
    CGFloat prevHeight = subRow.frame.size.height;
    
    // move forvard and calculate new size of subrows
    if(index < rowPath.length - 1)
    {
        [self changeExpandStateForSubrows:subRow.subrows rowsIndexInPath:index + 1 fullPath:rowPath toValue:expanded animated:animated];
    }
    
    // back to this row and update its size as well
    CGRect rect = subRow.frame;
    rect.size.height = [self heightForRow:subRow includingSubrows:[self.dataSource isRowExpanded:subRowIndexPath]];
    [subRow setFrame:rect animated:animated];
    
    // change position of rows that are follow modified row
    CGFloat delta = subRow.frame.size.height - prevHeight;
    for(int i = subRowIndex + 1; i < subrows.count;  ++i)
    {
        TSTableViewRowProxy *row = subrows[i];
        CGRect rect = row.frame;
        rect.origin.y += delta;
        [row setFrame:rect animated:animated];
    }

}

- (CGFloat)heightForRow:(TSTableViewRowProxy *)row includingSubrows:(BOOL)withSubrows
{
    VerboseLog();
    CGFloat height = row.rowHeight;
    if(withSubrows)
    {
        for (TSTableViewRowProxy *subrow in row.subrows)
        {
            height += subrow.frame.size.height;
        }
    }
    return height;
}

- (void)expandAllRowsWithAnimation:(BOOL)animated
{
    VerboseLog();
    [self changeExpandStateForAllSubrows:_rows rowsPath:nil toValue:YES animated:animated];
    [self updateRowSelectionWithAnimation:animated];
    [self updateColumnSelectionWithAnimation:animated];
    // if row expands sibling rows may still be visible during animation
    [self updateRowsVisibilityWithAnimation:animated];
    
}

- (void)collapseAllRowsWithAnimation:(BOOL)animated
{
    VerboseLog();
    [self changeExpandStateForAllSubrows:_rows rowsPath:nil toValue:NO animated:animated];
    [self updateRowSelectionWithAnimation:animated];
    [self updateColumnSelectionWithAnimation:animated];
    [self updateRowsVisibility];
}

- (void)changeExpandStateForAllSubrows:(NSArray *)subrows rowsPath:(NSIndexPath *)rowsPath toValue:(BOOL)expanded animated:(BOOL)animated
{
    VerboseLog();
    for(int i = 0; i < subrows.count;  ++i)
    {
        TSTableViewRowProxy *subRow = subrows[i];
        NSIndexPath *subrowPath = (rowsPath ? [rowsPath indexPathByAddingIndex:i] : [NSIndexPath indexPathWithIndex:i]);
        if(subRow.subrows.count)
        {
            [self changeExpandStateForAllSubrows:subRow.subrows rowsPath:subrowPath toValue:expanded animated:animated];
        }
    }
    
    // change position and size of rows
    CGFloat yOffset = 0;
    for(int i = 0; i < subrows.count;  ++i)
    {
        TSTableViewRowProxy *row = subrows[i];
        // first row in group may have offset that is not equal to 0
        if(i == 0)
            yOffset = row.frame.origin.y;
        CGRect rect = row.frame;
        rect.size.height = [self heightForRow:row includingSubrows:expanded];
        rect.origin.y = yOffset;
        [row setFrame:rect animated:animated];
        
        yOffset += rect.size.height;
    }
}

- (TSTableViewRowProxy *)rowAtPath:(NSIndexPath *)rowPath
{
    TSTableViewRowProxy *row;
    for(int i = 0; i < rowPath.length;  ++i)
    {
        NSInteger index = [rowPath indexAtPosition:i];
        if(i == 0)
            row = _rows[index];
        else
            row = row.subrows[index];
    }
    return row;
}

- (void)selectRowAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated
{
    VerboseLog();
    [self selectRowAtPath:rowPath selectedCell:0 animated:animated internal:NO];
}

- (void)selectRowAtPath:(NSIndexPath *)rowPath selectedCell:(NSInteger)cellIndex animated:(BOOL)animated internal:(BOOL)internal
{
    VerboseLog();
    if(![self.dataSource isRowVisible:rowPath])
    {
        [TSUtils performViewAnimationBlock:^{
            self.rowSelectionView.alpha = 0;
        } withCompletion:^{
            self.rowSelectionView.hidden = YES;
        } animated:animated];
        return;
    }
    
    if(internal && self.contentHolderDelegate)
    {
        [self.contentHolderDelegate tableViewContentHolder:self willSelectRowAtPath:rowPath selectedCell:cellIndex animated:animated];
    }
    
    CGRect rect = CGRectZero;
    TSTableViewRowProxy *row;
    for(int i = 0; i < rowPath.length;  ++i)
    {
        NSInteger index = [rowPath indexAtPosition:i];
        if(i == 0)
            row = _rows[index];
        else
            row = row.subrows[index];
        
        rect.origin.x += row.frame.origin.x;
        rect.origin.y += row.frame.origin.y;
    }
    rect.size.width = row.frame.size.width;
    rect.size.height = row.frame.size.height;
    
    self.rowSelectionView.selectedItem = rowPath;
    
    self.rowSelectionView.hidden = NO;
    [TSUtils performViewAnimationBlock:^{
        self.rowSelectionView.frame = rect;
        self.rowSelectionView.alpha = 1;
    } withCompletion:^{
        if(internal && self.contentHolderDelegate)
        {
            [self.contentHolderDelegate tableViewContentHolder:self didSelectRowAtPath:rowPath selectedCell:cellIndex];
        }
    } animated:animated];
}

- (void)selectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated
{
    VerboseLog();
    [self selectColumnAtPath:columnPath animated:animated internal:NO];
}

- (void)selectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated internal:(BOOL)internal
{
    VerboseLog();
    if(internal && self.contentHolderDelegate)
    {
        [self.contentHolderDelegate tableViewContentHolder:self willSelectColumnAtPath:columnPath animated:animated];
    }
    
    CGFloat width = [self.dataSource widthForColumnAtPath:columnPath];
    CGFloat offset = [self.dataSource offsetForColumnAtPath:columnPath];
    CGFloat height = [self.dataSource tableHeight];
   
    self.columnSelectionView.selectedItem = columnPath;

    self.columnSelectionView.hidden = NO;
    [TSUtils performViewAnimationBlock:^{
        self.columnSelectionView.frame = CGRectMake(offset, 0, width, height);
        self.columnSelectionView.alpha = 1;
    } withCompletion:^{
        if(internal && self.contentHolderDelegate)
        {
            [self.contentHolderDelegate tableViewContentHolder:self didSelectColumnAtPath:columnPath];
        }
    } animated:animated];
}

- (void)resetRowSelectionWithAnimtaion:(BOOL)animated
{
    if(_rowSelectionView)
    {
        self.rowSelectionView.selectedItem = nil;
        [TSUtils performViewAnimationBlock:^{
            self.rowSelectionView.alpha = 0;
        } withCompletion:^{
            self.rowSelectionView.hidden = YES;
        } animated:animated];
    }
}

- (void)resetColumnSelectionWithAnimtaion:(BOOL)animated
{
    if(_columnSelectionView)
    {
        self.columnSelectionView.selectedItem = nil;
        [TSUtils performViewAnimationBlock:^{
            self.columnSelectionView.alpha = 0;
        } withCompletion:^{
            self.columnSelectionView.hidden = YES;
        } animated:animated];
    }
}

- (void)updateRowSelectionWithAnimation:(BOOL)animated
{
    if(_rowSelectionView && _rowSelectionView.selectedItem)
        [self selectRowAtPath:self.rowSelectionView.selectedItem animated:animated];
}

- (void)updateColumnSelectionWithAnimation:(BOOL)animated
{
    if(_columnSelectionView && _columnSelectionView.selectedItem)
        [self selectColumnAtPath:self.columnSelectionView.selectedItem animated:animated];
}

- (NSIndexPath *)pathToSelectedRow
{
    return _rowSelectionView.selectedItem;
}

- (NSIndexPath *)pathToSelectedColumn
{
    return _columnSelectionView.selectedItem;
}

#pragma mark - Selection 

- (void)tapGestureDidRecognized:(UITapGestureRecognizer *)recognizer
{
    if(_allowRowSelection)
    {
        CGPoint pos = [recognizer locationInView:self];
        NSIndexPath *rowIndexPath = [self findRowAtPosition:pos parentRow:nil parentPowPath:nil];

        if(rowIndexPath)
        {
            NSInteger numberOfColumns = [self.dataSource numberOfColumns];
            NSInteger cellIndex = 0;
            CGFloat xOffset = 0;
            for(int i = 0; i < numberOfColumns; ++i)
            {
                CGFloat width = [self.dataSource widthForColumnAtIndex:i];
                if(xOffset < pos.x && pos.x <= xOffset + width)
                {
                    cellIndex = i;
                    break;
                }
                xOffset += width;
            }
            
            [self selectRowAtPath:rowIndexPath selectedCell:cellIndex animated:YES internal:YES];
        }
    }
}

- (NSIndexPath *)findRowAtPosition:(CGPoint)pos parentRow:(TSTableViewRowProxy *)parentRow parentPowPath:(NSIndexPath *)parentRowPath
{
    NSArray *rows = (parentRow ? parentRow.subrows : _rows);
    for(int i = 0; i < rows.count;  ++i)
    {
        TSTableViewRowProxy *row = rows[i];
        if(CGRectContainsPoint(row.frame, pos))
        {
            NSIndexPath *rowIndexPath = (parentRowPath ? [parentRowPath indexPathByAddingIndex:i] : [NSIndexPath indexPathWithIndex:i]);
            return [self findRowAtPosition:CGPointMake(pos.x - row.frame.origin.x, pos.y - row.frame.origin.y) parentRow:row parentPowPath:rowIndexPath];
        }
    }
    return parentRowPath;
}

#pragma mark - Modify content

- (void)insertRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    // Find subrows where new row should be inserted
    TSTableViewRowProxy *row;
    NSMutableArray *rows = _rows;
    for(int i = 0; i < path.length - 1;  ++i)
    {
        NSInteger index = [path indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    
    // Find position where new row should be inserted
    NSInteger lastIndex = [path indexAtPosition:path.length - 1];
    CGFloat rowHeight = [self.dataSource heightForRowAtPath:path];
    TSTableViewRowProxy *newRow = [[TSTableViewRowProxy alloc] init];
    newRow.rowHeight = rowHeight;
    if(rows.count > lastIndex)
    {
        TSTableViewRowProxy *prevRow = rows[lastIndex];
        newRow.frame = CGRectMake(prevRow.frame.origin.x, prevRow.frame.origin.y, _tableWidth, rowHeight);
    }
    else if(row)
    {
        newRow.frame = CGRectMake(0, row.rowHeight, _tableWidth, rowHeight);
    }
    [self loadSubrowsForRowAtPath:path rowView:newRow];
    [rows insertObject:newRow atIndex:lastIndex];
    
    if(row.rowView)
        [self loadRow:newRow atPath:path parentView:row.rowView];
    
    [self updateLayoutAnimated:animated];
    [self updateRowsVisibility];
    [self updateCurrentSelectionOnInsertRowAtPath:path animated:animated];
}

- (void)removeRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    // Find subrows where row should be removed
    TSTableViewRowProxy *row;
    NSMutableArray *rows = _rows;
    for(int i = 0; i < path.length - 1;  ++i)
    {
        NSInteger index = [path indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    
    // Find position where row should be removed
    NSInteger lastIndex = [path indexAtPosition:path.length - 1];
    TSTableViewRowProxy *removedRow = rows[lastIndex];
    if(removedRow.rowView)
    {
        [self rowWillDissapear:removedRow];
    }
    [rows removeObject:removedRow];
    
    [self updateLayoutAnimated:animated];
    [self updateRowsVisibility];
    [self updateCurrentSelectionOnRemoveRowAtPath:path animated:animated];
}

- (void)updateRowAtPath:(NSIndexPath *)path
{
    TSTableViewRowProxy *row = [self rowAtPath:path];
    CGFloat rowHeight = [self.dataSource heightForRowAtPath:path];
    BOOL rowHeightChanged = (row.rowHeight != rowHeight);
    row.rowHeight = rowHeight;
    if(row.rowView)
    {
        CGFloat xOffset = 0;
        NSInteger numberOfColumns = row.rowView.cells.count;
        for(TSTableViewCell *cell in row.rowView.cells)
        {
            [cell removeFromSuperview];
            [self addReusableCell:cell];
        }
        row.rowView.cells = nil;
        
        NSMutableArray *newCells = [[NSMutableArray alloc] initWithCapacity:numberOfColumns];
        for(int j = 0; j < numberOfColumns;  ++j)
        {
            CGFloat columnWidth = [self.dataSource widthForColumnAtIndex:j];
            TSTableViewCell *cellView = [self.dataSource cellViewForRowAtPath:path cellIndex:j];
            cellView.frame = CGRectMake(xOffset, 0, columnWidth, row.rowHeight);
            [newCells addObject:cellView];
            xOffset += columnWidth;
        }
        row.rowView.cells = [NSArray arrayWithArray:newCells];
    }
    if(rowHeightChanged)
    {
        [self updateLayoutAnimated:YES];
        [self updateRowsVisibility];
    }
}


#pragma mark - Update selection on row insert/remove

- (void)updateCurrentSelectionOnRemoveRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    // update selection
    if(_rowSelectionView.selectedItem)
    {
        // if selected row is removed then just reset selection
        if([_rowSelectionView.selectedItem isEqual:path])
        {
            [self resetRowSelectionWithAnimtaion:animated];
        }
        else if(_rowSelectionView.selectedItem.length > path.length)
        {
            //is selection path is deeper it might be affected due to row deletion
            BOOL equal = YES;
            // compare both pathes to find equal range in the beginning
            NSIndexPath *newSelectionPath;
            for(int i = 0; i < _rowSelectionView.selectedItem.length;  ++i)
            {
                NSInteger selectionIndex = [_rowSelectionView.selectedItem indexAtPosition:i];
                if(equal && i < path.length)
                {
                    NSInteger removeIndex = [path indexAtPosition:i];
                    if(path.length == i - 1) // end of the removed row path
                    {
                        if(selectionIndex == removeIndex) // if selection is subrow in removed row hierarchy then reset selection
                        {
                            [self resetRowSelectionWithAnimtaion:animated];
                            newSelectionPath = nil;
                            break;
                        }
                        else if(selectionIndex > removeIndex) // correct selection index if it greater the removed row
                        {
                            selectionIndex--;
                            equal = NO;
                        }
                    }
                    else if(removeIndex != selectionIndex) // if found first difference in pathes, remove path still have inner subrows so it wouldn't affect selection row
                    {
                        equal = NO;
                    }
                }
                
                if(newSelectionPath)
                    newSelectionPath = [newSelectionPath indexPathByAddingIndex:i];
                else
                    newSelectionPath = [NSIndexPath indexPathWithIndex:i];
            }
            
            if(newSelectionPath)
            {
                [self selectRowAtPath:newSelectionPath animated:animated];
            }
            else
            {
                [self updateRowSelectionWithAnimation:animated];
            }
        }
    }
    [self updateColumnSelectionWithAnimation:animated];
}

- (void)updateCurrentSelectionOnInsertRowAtPath:(NSIndexPath *)path animated:(BOOL)animated
{
    // update selection
    if(_rowSelectionView.selectedItem)
    {
        if([_rowSelectionView.selectedItem isEqual:path])
        {
            NSInteger lastIndex = [path indexAtPosition:path.length - 1];
            NSIndexPath *baseIndexPath = [path indexPathByRemovingLastIndex];
            [self selectRowAtPath:[baseIndexPath indexPathByAddingIndex:lastIndex + 1] animated:animated];
        }
        else if(_rowSelectionView.selectedItem.length > path.length)
        {
            //is selection path is deeper it might be affected due to row insertion
            BOOL equal = YES;
            // compare both pathes to find equal range in the beginning
            NSIndexPath *newSelectionPath;
            for(int i = 0; i < _rowSelectionView.selectedItem.length;  ++i)
            {
                NSInteger selectionIndex = [_rowSelectionView.selectedItem indexAtPosition:i];
                if(equal && i < path.length)
                {
                    NSInteger insertIndex = [path indexAtPosition:i];
                    if(path.length == i - 1) // end of the inserted row path
                    {
                        if(selectionIndex >= insertIndex) // correct selection index if it greater the removed row
                        {
                            selectionIndex++;
                            equal = NO;
                        }
                    }
                    else if(insertIndex != selectionIndex) // if found first difference in pathes, insert path still have inner subrows so it wouldn't affect selection row
                    {
                        equal = NO;
                    }
                }
                
                if(newSelectionPath)
                    newSelectionPath = [newSelectionPath indexPathByAddingIndex:i];
                else
                    newSelectionPath = [NSIndexPath indexPathWithIndex:i];
            }
            
            if(newSelectionPath)
            {
                [self selectRowAtPath:newSelectionPath animated:animated];
            }
            else
            {
                [self updateRowSelectionWithAnimation:animated];
            }
        }
    }
    [self updateColumnSelectionWithAnimation:animated];
}

@end
