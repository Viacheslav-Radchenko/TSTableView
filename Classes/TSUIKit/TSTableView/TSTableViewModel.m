//
//  TSTableViewModel.m
//  TSUIKit
//
//  Created by Viacheslav Radchenko on 8/14/13.
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

#import "TSTableViewModel.h"
#import "TSTableView.h"
#import "TSTableViewCell.h"
#import "TSTableViewHeaderSectionView.h"
#import "TSDefines.h"
#import "TSUtils.h"

#import <QuartzCore/QuartzCore.h>


#define MIN_COLUMN_WIDTH          64
#define MAX_COLUMN_WIDTH          512
#define DEF_COLUMN_WIDTH          128
#define DEF_COLUMN_HEADER_HEIGHT  32
#define DEF_ROW_HEIGHT            28
#define DEF_EXPAND_ITEM_WIDTH     24

@implementation TSColumn 

+ (id)columnWithTitle:(NSString *)title
{
    return [[TSColumn alloc] initWithTitle:title];
}

+ (id)columnWithTitle:(NSString *)title andSubcolumns:(NSArray *)sublolumns
{
    return [[TSColumn alloc] initWithTitle:title andSubcolumns:sublolumns];
}

+ (id)columnWithDictionary:(NSDictionary *)info
{
    return [[TSColumn alloc] initWithDictionary:info];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", [super description], self.title];
}

- (id)initWithTitle:(NSString *)title
{
    if(self = [super init])
    {
        _title = title;
        _minWidth = MIN_COLUMN_WIDTH;
        _maxWidth = MAX_COLUMN_WIDTH;
        _defWidth = DEF_COLUMN_WIDTH;
        _headerHeight = DEF_COLUMN_HEADER_HEIGHT;
        _textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andSubcolumns:(NSArray *)subcolumns
{
    if(self = [super init])
    {
        _title = title;
        _minWidth = MIN_COLUMN_WIDTH;
        _maxWidth = MAX_COLUMN_WIDTH;
        _defWidth = DEF_COLUMN_WIDTH;
        _headerHeight = DEF_COLUMN_HEADER_HEIGHT;
        _textAlignment = NSTextAlignmentCenter;
        
        NSMutableArray *columns = [[NSMutableArray alloc] initWithCapacity:subcolumns.count];
        for(id subcolumn in subcolumns)
        {
            if([subcolumn isKindOfClass:[TSColumn class]])
            {
                [columns addObject:subcolumn];
            }
            else if([subcolumn isKindOfClass:[NSString class]])
            {
                [columns addObject:[[TSColumn alloc] initWithTitle:title]];
            }
            else
            {
                NSAssert(FALSE, @"Type is not supported");
            }
        }
        _subcolumns = columns;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)info
{
    if(self = [super init])
    {
        _title = info[@"title"];
        _subtitle = info[@"subtitle"];
        id iconVal = info[@"icon"];
        if([iconVal isKindOfClass:[UIImage class]])
            _icon = iconVal;
        else if([iconVal isKindOfClass:[NSString class]])
            _icon = [UIImage imageNamed:iconVal];
        
        id colorVal = info[@"color"];
        if([colorVal isKindOfClass:[UIColor class]])
            _color = colorVal;
        else if([colorVal isKindOfClass:[NSString class]])
            _color = [TSUtils colorWithHexString:colorVal];
        
        colorVal = info[@"titleColor"];
        if([colorVal isKindOfClass:[UIColor class]])
            _titleColor = colorVal;
        else if([colorVal isKindOfClass:[NSString class]])
            _titleColor = [TSUtils colorWithHexString:colorVal];
        
        colorVal = info[@"subtitleColor"];
        if([colorVal isKindOfClass:[UIColor class]])
            _subtitleColor = colorVal;
        else if([colorVal isKindOfClass:[NSString class]])
            _subtitleColor = [TSUtils colorWithHexString:colorVal];

        _titleFontSize = [info[@"titleFontSize"] floatValue];
        _subtitleFontSize = [info[@"subtitleFontSize"] floatValue];
        
        _minWidth = MIN_COLUMN_WIDTH;
        _maxWidth = MAX_COLUMN_WIDTH;
        _defWidth = DEF_COLUMN_WIDTH;
        _headerHeight = DEF_COLUMN_HEADER_HEIGHT;
        _textAlignment = NSTextAlignmentCenter;
        
        NSString *textAligmentStr = info[@"textAlignment"];
        if(textAligmentStr)
            _textAlignment = [textAligmentStr integerValue];
        
        NSString *widthStr = info[@"minWidth"];
        if(widthStr)
            _minWidth = [widthStr floatValue];
        
        widthStr = info[@"maxWidth"];
        if(widthStr)
            _maxWidth = [widthStr floatValue];
        
        widthStr = info[@"defWidth"];
        if(widthStr)
            _defWidth = [widthStr floatValue];
        
        widthStr = info[@"headerHeight"];
        if(widthStr)
            _headerHeight = [widthStr floatValue];
        
        NSArray *subcolumns = info[@"subcolumns"];
        if(subcolumns.count)
        {
            NSMutableArray *tmpColumns = [[NSMutableArray alloc] initWithCapacity:subcolumns.count];
            for(id subcolumnInfo in subcolumns)
            {
                if([subcolumnInfo isKindOfClass:[NSString class]])
                {
                    [tmpColumns addObject:[[TSColumn alloc] initWithTitle:subcolumnInfo]];
                }
                else if([subcolumnInfo isKindOfClass:[NSDictionary class]])
                {
                    [tmpColumns addObject:[[TSColumn alloc] initWithDictionary:subcolumnInfo]];
                }
                else if([subcolumnInfo isKindOfClass:[TSColumn class]])
                {
                    [tmpColumns addObject:subcolumnInfo];
                }
                else
                {
                    NSAssert(FALSE, @"Type is not supported");
                }
            }
            _subcolumns = tmpColumns;
        }
    }
    return self;
}

@end

/**************************************************************************************************************************************/

@implementation TSRow 

+ (id)rowWithCells:(NSArray *)cells
{
    return [[TSRow alloc] initWithCells:cells];
}

+ (id)rowWithCells:(NSArray *)cells andSubrows:(NSArray *)subrows
{
    return [[TSRow alloc] initWithCells:cells andSubrows:subrows];
}

+ (id)rowWithDictionary:(NSDictionary *)info
{
    return [[TSRow alloc] initWithDictionary:info];
}

- (id)initWithCells:(NSArray *)cells
{
    return [self initWithCells:cells andSubrows:nil];
}

- (id)initWithCells:(NSArray *)cells andSubrows:(NSArray *)subrows
{
    if(self = [super init])
    {
        if(cells)
        {
            NSMutableArray *tmpCells = [[NSMutableArray alloc] initWithCapacity:cells.count];
            for(id cell in cells)
            {
                if([cell isKindOfClass:[TSCell class]])
                {
                    [tmpCells addObject:cell];
                }
                else 
                {
                    [tmpCells addObject:[[TSCell alloc] initWithValue:cell]];
                }
            }
            _cells = tmpCells;
        }
        
        if(subrows)
        {
            NSMutableArray *tmpRows = [[NSMutableArray alloc] initWithCapacity:subrows.count];
            for(id row in subrows)
            {
                if([row isKindOfClass:[TSRow class]])
                {
                    [tmpRows addObject:row];
                }
                else if([row isKindOfClass:[NSArray class]])
                {
                    [tmpRows addObject:[[TSRow alloc] initWithCells:row]];
                }
                else
                {
                    NSAssert(FALSE, @"Type is not supported");
                }
            }
            _subrows = tmpRows;
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)info
{
    if(self = [super init])
    {
        NSArray *cells = info[@"cells"];
        if(cells)
        {
            NSMutableArray *tmpCells = [[NSMutableArray alloc] initWithCapacity:cells.count];
            for(id cellInfo in cells)
            {
                if([cellInfo isKindOfClass:[NSDictionary class]])
                {
                    [tmpCells addObject:[[TSCell alloc] initWithDictionary:cellInfo]];
                }
                else if([cellInfo isKindOfClass:[TSCell class]])
                {
                    [tmpCells addObject:cellInfo];
                }
                else
                {
                    NSAssert(FALSE, @"Type is not supported");
                }
            }
            _cells = tmpCells;
        }
        
        NSArray *subrows = info[@"subrows"];
        if(subrows)
        {
            NSMutableArray *tmpRows = [[NSMutableArray alloc] initWithCapacity:subrows.count];
            for(id rowInfo in subrows)
            {
                if([rowInfo isKindOfClass:[NSDictionary class]])
                {
                    [tmpRows addObject:[[TSRow alloc] initWithDictionary:rowInfo]];
                }
                else if([rowInfo isKindOfClass:[TSRow class]])
                {
                    [tmpRows addObject:rowInfo];
                }
                else
                {
                    NSAssert(FALSE, @"Type is not supported");
                }
            }
            _subrows = tmpRows;
        }
    }
    return self;
}

@end

/**************************************************************************************************************************************/

@implementation TSCell 

+ (id)cellWithValue:(NSObject *)value
{
    return [[TSCell alloc] initWithValue:value];
}

+ (id)cellWithDictionary:(NSDictionary *)info
{
    return [[TSCell alloc] initWithDictionary:info];
}

- (id)initWithValue:(NSObject *)value
{
    if(self = [super init])
    {
        _textAlignment = NSTextAlignmentCenter;
        _value = value;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)info
{
    if(self = [super init])
    {
        _value = info[@"value"];
        _details = info[@"details"];
        
        id colorVal = info[@"textColor"];
        if([colorVal isKindOfClass:[UIColor class]])
            _textColor = colorVal;
        else if([colorVal isKindOfClass:[NSString class]])
            _textColor = [TSUtils colorWithHexString:colorVal];
        
        colorVal = info[@"detailsColor"];
        if([colorVal isKindOfClass:[UIColor class]])
            _detailsColor = colorVal;
        else if([colorVal isKindOfClass:[NSString class]])
            _detailsColor = [TSUtils colorWithHexString:colorVal];
        
        id iconVal = info[@"icon"];
        if([iconVal isKindOfClass:[UIImage class]])
            _icon = iconVal;
        else if([iconVal isKindOfClass:[NSString class]])
            _icon = [UIImage imageNamed:iconVal];
        
        _textAlignment = NSTextAlignmentCenter;
        NSString *textAligmentStr = info[@"textAlignment"];
        if(textAligmentStr)
            _textAlignment = [textAligmentStr integerValue];
    }
    return self;
}

@end

/**************************************************************************************************************************************/

@interface TSTableViewModel ()
{
    NSMutableDictionary *_cachedHeaderSectionBackgroundImages;
    NSMutableDictionary *_cachedCellBackgroundImages;
    UIImage *_cachedGeneralBackgroundImage;
    UIImage *_cachedExpandSectionBackgroundImage;
    UIImage *_cachedExpandItemNormalBackgroundImage;
    UIImage *_cachedExpandItemSelectedBackgroundImage;
}

@end

@implementation TSTableViewModel

- (id)initWithTableView:(TSTableView *)tableView andStyle:(TSTableViewStyle)style
{
    if(self = [super init])
    {
        _tableView = tableView;
        _tableView.dataSource = self;
        _tableStyle = style;
        _heightForRow = DEF_ROW_HEIGHT;
        _widthForExpandItem = DEF_EXPAND_ITEM_WIDTH;
        
        if(_tableStyle == kTSTableViewStyleLight)
        {
            _tableView.lineNumbersColor = [UIColor blackColor];
            _tableView.backgroundColor = [UIColor grayColor];
        }
        else
        {
            _tableView.lineNumbersColor = [UIColor lightGrayColor];
            _tableView.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1];
        }
        
        _tableView.headerBackgroundImage = [self generalBackgroundImage];
        _tableView.expandPanelBackgroundImage = [self generalBackgroundImage];
        _tableView.topLeftCornerBackgroundImage = [self generalBackgroundImage];
        _tableView.expandItemNormalBackgroundImage = [self expandItemNormalBackgroundImage];
        _tableView.expandItemSelectedBackgroundImage = [self expandItemSelectedBackgroundImage];
        _tableView.expandSectionBackgroundImage = [self expandSectionBackgroundImage];
        
        _rows = [[NSMutableArray alloc] init];
        _columns = [[NSMutableArray alloc] init];
        _bottomEndColumns = [[NSMutableArray alloc] init];
        _cachedHeaderSectionBackgroundImages = [[NSMutableDictionary alloc] init];
        _cachedCellBackgroundImages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setColumns:(NSArray *)columns andRows:(NSArray *)rows
{
    VerboseLog();
    [_columns removeAllObjects];
    [_bottomEndColumns removeAllObjects];
    [_rows removeAllObjects];
    
    for(id columnInfo in columns)
    {
        if([columnInfo isKindOfClass:[TSColumn class]])
        {
            [_columns addObject:columnInfo];
        }
        else if([columnInfo isKindOfClass:[NSString class]])
        {
            [_columns addObject:[[TSColumn alloc] initWithTitle:columnInfo]];
        }
        else if([columnInfo isKindOfClass:[NSDictionary class]])
        {
            [_columns addObject:[TSColumn columnWithDictionary:columnInfo]];
        }
        else
        {
            NSAssert(FALSE, @"Type is not supported");
        }
        [self addLeafColumnsFrom:[_columns lastObject]];
    }
    
    for(id rowInfo in rows)
    {
        if([rowInfo isKindOfClass:[TSRow class]])
        {
            [_rows addObject:rowInfo];
        }
        else if([rowInfo isKindOfClass:[NSArray class]])
        {
            [_rows addObject:[[TSRow alloc] initWithCells:rowInfo]];
        }
        else if([rowInfo isKindOfClass:[NSDictionary class]])
        {
            [_rows addObject:[TSRow rowWithDictionary:rowInfo]];
        }
        else
        {
            NSAssert(FALSE, @"Type is not supported");
        }
    }
    [_tableView reloadData];
}

- (void)addLeafColumnsFrom:(TSColumn *)parentColumn
{
    if(parentColumn.subcolumns.count == 0)
    {
        [_bottomEndColumns addObject:parentColumn];
    }
    else
    {
        for(TSColumn *column in parentColumn.subcolumns)
        {
            [self addLeafColumnsFrom:column];
        }
    }
}

- (void)setRows:(NSArray *)rows
{
    VerboseLog();
    [_rows removeAllObjects];

    for(id rowInfo in rows)
    {
        if([rowInfo isKindOfClass:[TSRow class]])
        {
            [_rows addObject:rowInfo];
        }
        else if([rowInfo isKindOfClass:[NSArray class]])
        {
            [_rows addObject:[[TSRow alloc] initWithCells:rowInfo]];
        }
        else if([rowInfo isKindOfClass:[NSDictionary class]])
        {
            [_rows addObject:[TSRow rowWithDictionary:rowInfo]];
        }
        else
        {
            NSAssert(FALSE, @"Type is not supported");
        }
    }
    [_tableView reloadRowsData];
}

- (TSRow *)rowAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    TSRow *row;
    NSArray *rows = _rows;
    for(int i = 0; i < indexPath.length;  ++i)
    {
        NSInteger index = [indexPath indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    return row;
}

- (TSColumn *)columnAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    TSColumn *column;
    NSArray *columns = _columns;
    for(int i = 0; i < indexPath.length;  ++i)
    {
        NSInteger index = [indexPath indexAtPosition:i];
        column = columns[index];
        columns = column.subcolumns;
    }
    return column;
}

- (TSCell *)cellAtRowPath:(NSIndexPath *)rowPath atIndex:(NSInteger)index
{
    VerboseLog();
    TSRow *row = [self rowAtPath:rowPath];
    TSCell *cell = row.cells[index];
    return cell;
}

- (TSColumn *)columnAtIndex:(NSInteger)index
{
    VerboseLog(@"index = %d",index);

    return [_bottomEndColumns objectAtIndex:index];
}

// Find specified column recursevly in TSColumn hierarchy
- (TSColumn *)findColumnAtIndex:(NSInteger *)index inColumns:(NSArray *)columns
{
    TSColumn *found;
    for (int i = 0; i < columns.count;  ++i)
    {
        TSColumn *column = columns[i];
        if(column.subcolumns.count == 0)
        {
            if(*index == 0)
                return column;
            --(*index);
        }
        else
        {
            found = [self findColumnAtIndex:index inColumns:column.subcolumns];
            if(found) break;
        }
    }
    return found;
}

#pragma mark - TSTableViewDataSource

- (NSInteger)numberOfColumns
{
    VerboseLog();
    return [self calcNumberOfColumns:_columns];
}

- (NSInteger)calcNumberOfColumns:(NSArray *)columns
{
    VerboseLog();
    NSInteger columnsCount = columns.count;
    for(TSColumn *column in columns)
    {
        if(column.subcolumns.count)
        {
            columnsCount += [self calcNumberOfColumns:column.subcolumns] - 1;
        }
    }
    return columnsCount;
}

- (NSInteger)numberOfRows
{
    VerboseLog();
    return [self calcNumberOfRows:_rows];
}

- (NSInteger)calcNumberOfRows:(NSArray *)rows
{
    VerboseLog();
    NSInteger rowsCount = rows.count;
    for(TSRow *row in rows)
    {
        rowsCount += [self calcNumberOfRows:row.subrows];
    }
    return rowsCount;
}

- (NSInteger)numberOfColumnsAtPath:(NSIndexPath *)indexPath
{
    VerboseLog(@"%@", indexPath);
    if(indexPath == nil)
        return _columns.count;
    TSColumn *column = [self columnAtPath:indexPath];
    return column.subcolumns.count;
}

- (NSInteger)numberOfRowsAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    if(indexPath == nil)
        return _rows.count;
    TSRow *row = [self rowAtPath:indexPath];
    return row.subrows.count;
}

- (CGFloat)heightForRowAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    return _heightForRow;
}

- (CGFloat)heightForHeaderSectionAtPath:(NSIndexPath *)columnPath
{
    VerboseLog();
    TSColumn *columnInfo = [self columnAtPath:columnPath];
    return columnInfo.headerHeight;
}

- (CGFloat)defaultWidthForColumnAtIndex:(NSInteger)index
{
    TSColumn *columnInfo = [self columnAtIndex:index];
    return columnInfo.defWidth;
}

- (CGFloat)minimalWidthForColumnAtIndex:(NSInteger)index
{
    TSColumn *columnInfo = [self columnAtIndex:index];
    return columnInfo.minWidth;
}

- (CGFloat)maximalWidthForColumnAtIndex:(NSInteger)index
{
    TSColumn *columnInfo = [self columnAtIndex:index];
    return columnInfo.maxWidth;
}

- (CGFloat)widthForExpandItem
{
    VerboseLog();
    return _widthForExpandItem;
}

- (TSTableViewCell *)tableView:(TSTableView *)tableView cellViewForRowAtPath:(NSIndexPath *)indexPath cellIndex:(NSInteger)index
{
    VerboseLog();
    NSString * const kReuseCellId = @"TSTableViewCell";
    TSCell *cellInfo = [self cellAtRowPath:indexPath atIndex:index];
    TSTableViewCell *cell =  [tableView dequeueReusableCellViewWithIdentifier:kReuseCellId];
    if(!cell)
        cell = [[TSTableViewCell alloc] initWithReuseIdentifier:kReuseCellId];

    TSColumn *columnInfo = [self columnAtIndex:index];
    if(columnInfo.titleColor)
    {
        cell.textLabel.textColor = columnInfo.titleColor;
    }
    else
    {
        if(_tableStyle == kTSTableViewStyleDark)
            cell.textLabel.textColor = [UIColor grayColor];
        else
            cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    if(cellInfo.value)
    {
        cell.textLabel.text = [cellInfo.value description];
        cell.textLabel.textAlignment = cellInfo.textAlignment;
        if(cellInfo.textColor)
            cell.textLabel.textColor = cellInfo.textColor;
    }
    if(cellInfo.details)
    {
        cell.detailsLabel.text = cellInfo.details;
        cell.detailsLabel.textAlignment = cellInfo.textAlignment;
        if(cellInfo.detailsColor)
            cell.detailsLabel.textColor = cellInfo.detailsColor;
    }
    if(cellInfo.icon)
        cell.iconView.image = cellInfo.icon;
    
    // Color values and proportions below just came up from my head, there is no special logic for this... it just looks fine, that's all
    if(columnInfo.color)
    {
        CGFloat color = 0.9f + 0.1f * (1 - (indexPath.length - 1)/(float)tableView.maxNestingLevel);
        CGColorRef colorRef = columnInfo.color.CGColor;
        const float *rgb = CGColorGetComponents(colorRef);
        cell.backgroundImageView.image = [self cellBackgroundImageWithTintColor:[UIColor colorWithRed:color * rgb[0]  green:color * rgb[1] blue:color * rgb[2] alpha:1]];
    }
    else
    {
        CGFloat color;
        if(_tableStyle == kTSTableViewStyleDark)
            color = 0.16f + 0.04f * (1 - (indexPath.length - 1)/(float)tableView.maxNestingLevel);
        else
            color = 0.9f + 0.1f * (1 - (indexPath.length - 1)/(float)tableView.maxNestingLevel);
        cell.backgroundImageView.image = [self cellBackgroundImageWithTintColor:[UIColor colorWithWhite:color alpha:1]];
    }
    return cell;
}

- (TSTableViewHeaderSectionView *)tableView:(TSTableView *)tableView headerSectionViewForColumnAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    TSColumn *column = [self columnAtPath:indexPath];
    TSTableViewHeaderSectionView *section = [[TSTableViewHeaderSectionView alloc] init];
    
    if(_tableStyle == kTSTableViewStyleDark)
    {
        section.textLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        section.textLabel.textColor = [UIColor grayColor];
    }
    else
    {
        section.textLabel.textColor = [UIColor darkGrayColor];
    }
    section.backgroundImageView.image = [self headerSectionBackgroundImageWithTintColor:column.color];
    
    if(column.title)
    {
        section.textLabel.text = column.title;
        section.textLabel.textAlignment = column.textAlignment;
    }
    if(column.subtitle)
    {
        section.detailsLabel.text = column.subtitle;
        section.detailsLabel.textAlignment = column.textAlignment;
    }
    if(column.icon)
        section.iconView.image = column.icon;
    if(column.titleColor)
        section.textLabel.textColor = column.titleColor;
    if(column.subtitleColor)
        section.detailsLabel.textColor = column.subtitleColor;
    if(column.titleFontSize)
        section.textLabel.font = [UIFont boldSystemFontOfSize:column.titleFontSize];
    if(column.subtitleFontSize)
        section.detailsLabel.font = [UIFont boldSystemFontOfSize:column.subtitleFontSize];
    
    return section;
}

#pragma mark - Modify content

- (void)insertRow:(TSRow *)rowInfo atPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    TSRow *row;
    NSMutableArray *rows = _rows;
    for(int i = 0; i < indexPath.length - 1;  ++i)
    {
        NSInteger index = [indexPath indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    NSInteger lastIndex = [indexPath indexAtPosition:indexPath.length - 1];
    [rows insertObject:rowInfo atIndex:lastIndex];
    [_tableView insertRowAtPath:indexPath animated:YES];
}

- (void)removeRowAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    TSRow *row;
    NSMutableArray *rows = _rows;
    for(int i = 0; i < indexPath.length - 1;  ++i)
    {
        NSInteger index = [indexPath indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    NSInteger lastIndex = [indexPath indexAtPosition:indexPath.length - 1];
    [rows removeObjectAtIndex:lastIndex];
    [_tableView removeRowAtPath:indexPath animated:YES];
}

- (void)replcaceRowAtPath:(NSIndexPath *)indexPath withRow:(TSRow *)rowInfo
{
    VerboseLog();
    TSRow *row;
    NSMutableArray *rows = _rows;
    for(int i = 0; i < indexPath.length - 1;  ++i)
    {
        NSInteger index = [indexPath indexAtPosition:i];
        row = rows[index];
        rows = row.subrows;
    }
    NSInteger lastIndex = [indexPath indexAtPosition:indexPath.length - 1];
    [rows replaceObjectAtIndex:lastIndex withObject:rowInfo];
    [_tableView updateRowAtPath:indexPath];
}

#pragma mark - Create background images

- (NSString *)keyForColor:(UIColor *)color
{
    if(!color) return @"";
    const CGFloat *rgba = CGColorGetComponents(color.CGColor);
    return [NSString stringWithFormat:@"%d%d%d%d", (char)(rgba[0] * 255), (char)(rgba[1] * 255), (char)(rgba[2] * 255), (char)(rgba[3] * 255)];
}

- (UIImage *)cellBackgroundImageWithTintColor:(UIColor *)color
{
    NSString *key = [self keyForColor:color];
    UIImage *image = _cachedCellBackgroundImages[key];
    if(!image)
    {
        if(_tableStyle == kTSTableViewStyleDark)
            image = [self darkCellBackgroundImageWithTintColor:color];
        else
            image = [self lightCellBackgroundImageWithTintColor:color];
        _cachedCellBackgroundImages[key] = image;
    }
    return image;
}

- (UIImage *)headerSectionBackgroundImageWithTintColor:(UIColor *)color
{
    NSString *key = [self keyForColor:color];
    UIImage *image = _cachedHeaderSectionBackgroundImages[key];
    if(!image)
    {
        if(_tableStyle == kTSTableViewStyleDark)
            image = [self darkHeaderSectionBackgroundImageWithTintColor:color];
        else
            image = [self lightHeaderSectionBackgroundImageWithTintColor:color];
        _cachedHeaderSectionBackgroundImages[key] = image;
    }
    return image;
}

- (UIImage *)expandSectionBackgroundImage
{
    if(!_cachedExpandSectionBackgroundImage)
    {
        if(_tableStyle == kTSTableViewStyleDark)
            _cachedExpandSectionBackgroundImage = [self darkExpandSectionBackgroundImage];
        else
            _cachedExpandSectionBackgroundImage = [self lightExpandSectionBackgroundImage];
    }
    return _cachedExpandSectionBackgroundImage;
}

- (UIImage *)expandItemNormalBackgroundImage
{
    if(!_cachedExpandItemNormalBackgroundImage)
    {
        if(_tableStyle == kTSTableViewStyleDark)
            _cachedExpandItemNormalBackgroundImage = [self darkExpandItemNormalBackgroundImage];
        else
            _cachedExpandItemNormalBackgroundImage = [self lightExpandItemNormalBackgroundImage];
    }
    return _cachedExpandItemNormalBackgroundImage;
}

- (UIImage *)expandItemSelectedBackgroundImage
{
    if(!_cachedExpandItemSelectedBackgroundImage)
    {
        if(_tableStyle == kTSTableViewStyleDark)
            _cachedExpandItemSelectedBackgroundImage = [self darkExpandItemSelectedBackgroundImage];
        else
            _cachedExpandItemSelectedBackgroundImage = [self lightExpandItemSelectedBackgroundImage];
    }
    return _cachedExpandItemSelectedBackgroundImage;
}

- (UIImage *)generalBackgroundImage
{
    if(!_cachedGeneralBackgroundImage)
    {
        if(_tableStyle == kTSTableViewStyleDark)
            _cachedGeneralBackgroundImage = [self darkGeneralBackgroundImage];
        else
            _cachedGeneralBackgroundImage = [self lightGeneralBackgroundImage];
    }
    return _cachedGeneralBackgroundImage;
}

#pragma mark - Create background images for Light style

- (UIImage *)lightCellBackgroundImageWithTintColor:(UIColor *)color
{
    UIColor *topColor = (color ? color : [UIColor whiteColor]);
    UIColor *bottomColor = (color ? color : [UIColor whiteColor]);
    UIColor *topBorderColor = [UIColor whiteColor];
    UIColor *bottomBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    UIColor *leftBorderColor = [UIColor whiteColor];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/2];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(rect.size.height/2, rect.size.width/2, rect.size.height/2, rect.size.width/2)];
}

- (UIImage *)lightHeaderSectionBackgroundImageWithTintColor:(UIColor *)color
{
    UIColor *topColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    UIColor *bottomColor = (color ? color : [UIColor colorWithWhite:0.9f alpha:1.0f]);
    UIColor *topBorderColor = [UIColor whiteColor];
    UIColor *bottomBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    UIColor *leftBorderColor = [UIColor whiteColor];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    UIColor *lineColor = [UIColor colorWithWhite:0.0f alpha:0.1f];

    CGFloat lineWidth = 8;
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - lineWidth/2, 0)
                      endPoint:CGPointMake(rect.size.width - lineWidth/2, rect.size.height - 0.5f)
                         color:lineColor.CGColor
                     lineWidth:lineWidth];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/2];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(rect.size.height/2, rect.size.width/2, rect.size.height/2, rect.size.width/2)];
}

- (UIImage *)lightExpandSectionBackgroundImage
{
    UIColor *topColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    UIColor *bottomColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    UIColor *topBorderColor = [UIColor whiteColor];
    UIColor *bottomBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    UIColor *leftBorderColor = [UIColor whiteColor];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    UIColor *lineColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    CGFloat lineWidth = 8;
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(lineWidth/2, 0)
                      endPoint:CGPointMake(lineWidth/2, rect.size.height - 0.5f)
                         color:lineColor.CGColor
                     lineWidth:lineWidth];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/2];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(rect.size.height/2, rect.size.width/2, rect.size.height/2, rect.size.width/2)];
}


- (UIImage *)lightExpandItemNormalBackgroundImage
{
    CGFloat expandItemWidth = [self widthForExpandItem];
    CGFloat rowHeight = [self heightForRow];
    CGRect rect = CGRectMake(0.0f, 0.0f, 2 * expandItemWidth, rowHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat lineWithd = 8;
    NSArray *points = @[
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd + 1, CGRectGetMidY(rect) - lineWithd/2)],
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd + expandItemWidth - 5, CGRectGetMidY(rect) - lineWithd/2)],
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd + expandItemWidth, CGRectGetMidY(rect))],
                        
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd + expandItemWidth - 5, CGRectGetMidY(rect) + lineWithd/2)],
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd + 1, CGRectGetMidY(rect) + lineWithd/2)]
                        ];
    
    [TSUtils drawPolygonInContext:context points:points
                        fillColor:[UIColor colorWithWhite:0 alpha:0.1].CGColor
                      strokeColor:[UIColor clearColor].CGColor
                       strokeSize:0];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)lightExpandItemSelectedBackgroundImage
{
    CGFloat expandItemWidth = [self widthForExpandItem];
    CGFloat rowHeight = [self heightForRow];
    CGRect rect = CGRectMake(0.0f, 0.0f, 2 * expandItemWidth, rowHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWithd = 8;
 
    NSArray *points = @[
                        [NSValue valueWithCGPoint:CGPointMake(expandItemWidth + lineWithd/2, CGRectGetMaxY(rect) - 2)],
                        [NSValue valueWithCGPoint:CGPointMake(expandItemWidth - lineWithd/2, CGRectGetMaxY(rect) - 14)],
                        [NSValue valueWithCGPoint:CGPointMake(expandItemWidth + 3 * lineWithd/2, CGRectGetMaxY(rect) - 14)]
                        ];
    
    [TSUtils drawPolygonInContext:context points:points
                        fillColor:[UIColor colorWithWhite:0 alpha:0.1].CGColor
                      strokeColor:[UIColor clearColor].CGColor
                       strokeSize:0];
    
    NSArray *points1 = @[
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth, CGRectGetMaxY(rect))],
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth, CGRectGetMaxY(rect) - 6)],
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth + lineWithd/2, CGRectGetMaxY(rect))],
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth + lineWithd, CGRectGetMaxY(rect) - 6)],
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth + lineWithd, CGRectGetMaxY(rect))]
                         ];
    
    [TSUtils drawPolygonInContext:context points:points1
                        fillColor:[UIColor colorWithWhite:0 alpha:0.1].CGColor
                      strokeColor:[UIColor clearColor].CGColor
                       strokeSize:0];
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)lightGeneralBackgroundImage
{
    UIColor *topColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    UIColor *bottomColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    UIColor *topBorderColor = [UIColor whiteColor];
    UIColor *bottomBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    UIColor *leftBorderColor = [UIColor whiteColor];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/2];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(rect.size.height/2, rect.size.width/2, rect.size.height/2, rect.size.width/2)];
}

#pragma mark - Create background images for Dark Style

- (UIImage *)darkCellBackgroundImageWithTintColor:(UIColor *)color
{
    UIColor *topColor = (color ? color : [UIColor colorWithWhite:0.2f alpha:1.0f]);
    UIColor *bottomColor = (color ? color : [UIColor colorWithWhite:0.15f alpha:1.0f]);
    UIColor *topBorderColor =   [UIColor colorWithWhite:0.4f alpha:1.0f];
    UIColor *bottomBorderColor =[UIColor colorWithWhite:0.05f alpha:1.0f];
    UIColor *leftBorderColor =  [UIColor colorWithWhite:0.4f alpha:1.0f];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.05f alpha:1.0f];

    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/2];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(rect.size.height/2, rect.size.width/2, rect.size.height/2, rect.size.width/2)];
}

- (UIImage *)darkHeaderSectionBackgroundImageWithTintColor:(UIColor *)color
{
    UIColor *topColor =         [UIColor colorWithWhite:0.2f alpha:1.0f];
    UIColor *bottomColor =   (color ? color :  [UIColor colorWithWhite:0.15f alpha:1.0f]);
    UIColor *topBorderColor =   [UIColor colorWithWhite:0.4f alpha:1.0f];
    UIColor *bottomBorderColor =[UIColor colorWithWhite:0.05f alpha:1.0f];
    UIColor *leftBorderColor =  [UIColor colorWithWhite:0.4f alpha:1.0f];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    UIColor *lineColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    CGFloat lineWidth = 8;
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - lineWidth/2, 0)
                      endPoint:CGPointMake(rect.size.width - lineWidth/2, rect.size.height - 0.5f)
                         color:lineColor.CGColor
                     lineWidth:lineWidth];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/4];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, rect.size.width/2, 2, rect.size.width/2) resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)darkExpandSectionBackgroundImage
{
    UIColor *topColor =         [UIColor colorWithWhite:0.2f alpha:1.0f];
    UIColor *bottomColor =      [UIColor colorWithWhite:0.15f alpha:1.0f];
    UIColor *topBorderColor =   [UIColor colorWithWhite:0.3f alpha:1.0f];
    UIColor *bottomBorderColor =[UIColor colorWithWhite:0.05f alpha:1.0f];
    UIColor *leftBorderColor =  [UIColor colorWithWhite:0.15f alpha:1.0f];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    UIColor *lineColor = [UIColor colorWithWhite:0 alpha:0.15f];
    
    CGFloat lineWidth = 8;
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(lineWidth/2, 0)
                      endPoint:CGPointMake(lineWidth/2, rect.size.height - 0.5f)
                         color:lineColor.CGColor
                     lineWidth:lineWidth];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/2];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(rect.size.height/2, rect.size.width/2, rect.size.height/2, rect.size.width/2)];
}


- (UIImage *)darkExpandItemNormalBackgroundImage
{
    CGFloat expandItemWidth = [self widthForExpandItem];
    CGFloat rowHeight = [self heightForRow];
    CGRect rect = CGRectMake(0.0f, 0.0f, 2 * expandItemWidth, rowHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWithd = 8;
    NSArray *points = @[
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd , CGRectGetMidY(rect) - lineWithd/2)],
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd + expandItemWidth, CGRectGetMidY(rect) - lineWithd/2)],
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd + expandItemWidth, CGRectGetMidY(rect) + lineWithd/2)],
                        [NSValue valueWithCGPoint:CGPointMake(lineWithd , CGRectGetMidY(rect) + lineWithd/2)]
                        ];

    CGMutablePathRef path = CGPathCreateMutable();
    for(int i = 0; i < points.count;  ++i)
    {
        NSValue *pointVal = points[i];
        CGPoint point = [pointVal CGPointValue];
        if(i == 0)
            CGPathMoveToPoint(path, NULL, point.x, point.y);
        else
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    CGFloat radius = 8;
    CGPathAddEllipseInRect(path, NULL, CGRectMake(expandItemWidth + lineWithd/2 - radius, CGRectGetMidY(rect) - radius, 2*radius, 2*radius));
    
    CGPathCloseSubpath(path);
    
    
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.15].CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.1].CGColor);
    CGFloat innerRadius = 3.5f;
    CGContextAddEllipseInRect(context, CGRectMake(expandItemWidth + lineWithd/2 - innerRadius, CGRectGetMidY(rect) - innerRadius, 2*innerRadius, 2*innerRadius));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)darkExpandItemSelectedBackgroundImage
{
    CGFloat expandItemWidth = [self widthForExpandItem];
    CGFloat rowHeight = [self heightForRow];
    CGRect rect = CGRectMake(0.0f, 0.0f, 2 * expandItemWidth, rowHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWithd = 8;
    NSArray *points = @[
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth, CGRectGetMaxY(rect))],
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth, CGRectGetMidY(rect))],
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth + lineWithd, CGRectGetMidY(rect))],
                         [NSValue valueWithCGPoint:CGPointMake(expandItemWidth + lineWithd, CGRectGetMaxY(rect))]
                         ];

    CGMutablePathRef path = CGPathCreateMutable();
    for(int i = 0; i < points.count;  ++i)
    {
        NSValue *pointVal = points[i];
        CGPoint point = [pointVal CGPointValue];
        if(i == 0)
            CGPathMoveToPoint(path, NULL, point.x, point.y);
        else
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    CGFloat radius = 8;
    CGPathAddEllipseInRect(path, NULL, CGRectMake(expandItemWidth + lineWithd/2 - radius, CGRectGetMidY(rect) - radius, 2*radius, 2*radius));
    
    CGPathCloseSubpath(path);
    
    
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.15].CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.185 alpha:1].CGColor);
    CGFloat innerRadius = 3.5f;
    CGContextAddEllipseInRect(context, CGRectMake(expandItemWidth + lineWithd/2 - innerRadius, CGRectGetMidY(rect) - innerRadius, 2*innerRadius, 2*innerRadius));
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)darkGeneralBackgroundImage
{
    UIColor *topColor =         [UIColor colorWithWhite:0.2f alpha:1.0f];
    UIColor *bottomColor =      [UIColor colorWithWhite:0.15f alpha:1.0f];
    UIColor *topBorderColor =   [UIColor colorWithWhite:0.4f alpha:1.0f];
    UIColor *bottomBorderColor =[UIColor colorWithWhite:0.05f alpha:1.0f];
    UIColor *leftBorderColor =  [UIColor colorWithWhite:0.4f alpha:1.0f];
    UIColor *rightBorderColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [TSUtils drawLinearGradientInContext:context
                                    rect:rect
                              startColor:topColor.CGColor
                                endColor:bottomColor.CGColor];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, 0)
                         color:topBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, rect.size.height - 0.5f)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:bottomBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(rect.size.width - 0.5f, 0)
                      endPoint:CGPointMake(rect.size.width - 0.5f, rect.size.height - 0.5f)
                         color:rightBorderColor.CGColor
                     lineWidth:0.5];
    [TSUtils drawLineInContext:context
                    startPoint:CGPointMake(0, 0)
                      endPoint:CGPointMake(0, rect.size.height - 0.5f)
                         color:leftBorderColor.CGColor
                     lineWidth:0.5];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    return [image stretchableImageWithLeftCapWidth:rect.size.width/2 topCapHeight:rect.size.height/2];
    //return [image resizableImageWithCapInsets:UIEdgeInsetsMake(rect.size.height/2, rect.size.width/2, rect.size.height/2, rect.size.width/2)];
}


@end
