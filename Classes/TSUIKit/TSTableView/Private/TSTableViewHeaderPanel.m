//
//  TSTableViewHeaderPanel.m
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

#import "TSTableViewHeaderPanel.h"
#import "TSTableViewHeaderSection.h"
#import "TSTableViewHeaderSectionView.h"
#import "TSTableViewDataSource.h"
#import "TSTableViewAppearanceCoordinator.h"
#import "TSUtils.h"
#import "TSDefines.h"


@interface TSTableViewHeaderPanel ()
{
    NSMutableArray *_headerSections;
    CGFloat _headerHeight;
    CGPoint _lastTouchPos;
    BOOL _changingColumnSize;
}

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation TSTableViewHeaderPanel

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
    self.backgroundColor = [UIColor lightGrayColor];
    self.scrollEnabled = NO;
    _allowColumnSelection = YES;
    _changingColumnSize = NO;
    _headerSections = [[NSMutableArray alloc] init];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidRecognized:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
}

- (TSTableViewHeaderSection *)headerSectionAtIndex:(NSInteger)index
{
    VerboseLog(@"index = %d",index);
    TSTableViewHeaderSection *section;
    NSArray *sections = _headerSections;
    while(sections && sections.count)
    {
        for(int i = 0; i < sections.count;  ++i)
        {
            section = sections[i];
            if(index < section.subcolumnsRange.location + section.subcolumnsRange.length)
            {
                sections = section.subsections;
                break;
            }
        }
    }
    return section;
}

- (TSTableViewHeaderSection *)headerSectionAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    TSTableViewHeaderSection *section;
    NSArray *sections = _headerSections;
    for(int i = 0; i < indexPath.length;  ++i)
    {
        NSInteger index = [indexPath indexAtPosition:i];
        section = sections[index];
        sections = section.subsections;
    }
    return section;
}


#pragma mark - Getters & Setters

#pragma mark - Slide Button

- (void)addSlideButtonToSection:(TSTableViewHeaderSection *)section
{
    VerboseLog();
    CGFloat slideBtnWidth = 20;
    UIButton *slideBtn = [[UIButton alloc] initWithFrame:CGRectMake(section.frame.size.width - slideBtnWidth, 0, slideBtnWidth, section.frame.size.height)];
    slideBtn.showsTouchWhenHighlighted = [self.dataSource highlightControlsOnTap];
    [slideBtn addTarget:self action:@selector(slideBtnTouchBegin:withEvent:) forControlEvents:UIControlEventTouchDown];
    [slideBtn addTarget:self action:@selector(slideBtnTouch:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    [slideBtn addTarget:self action:@selector(slideBtnTouchEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn addTarget:self action:@selector(slideBtnTouchEnd:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    slideBtn.tag = section.subcolumnsRange.location + section.subcolumnsRange.length - 1;
    slideBtn.backgroundColor = [UIColor clearColor];
    slideBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [section addSubview:slideBtn];
}

- (void)slideBtnTouchBegin:(UIButton *)sender withEvent:(UIEvent *)event
{
    VerboseLog();
    _changingColumnSize = YES;
    _lastTouchPos = [[[event allTouches] anyObject] locationInView:self];
}

- (void)slideBtnTouchEnd:(UIButton *)sender withEvent:(UIEvent *)event
{
    VerboseLog();
    _changingColumnSize = NO;
}

- (void)slideBtnTouch:(UIButton *)sender withEvent:(UIEvent *)event
{
    VerboseLog();
    if(_changingColumnSize)
    {
        UIButton *thisButton = (UIButton *)sender;
        NSInteger columnIndex = thisButton.tag;
        TSTableViewHeaderSection *section = [self headerSectionAtIndex:columnIndex];
        CGFloat oldWidth = section.bounds.size.width;
        CGPoint centerPoint = [[[event allTouches] anyObject] locationInView:self];
        CGFloat delta = centerPoint.x - _lastTouchPos.x;
        CGFloat newWidth = oldWidth + delta;
        CGFloat maxWidth = [self.dataSource maximalWidthForColumnAtIndex:columnIndex];
        CGFloat minWidth = [self.dataSource minimalWidthForColumnAtIndex:columnIndex];
        newWidth = CLAMP(minWidth, maxWidth, (int)newWidth);
        [self changeColumnWidthOnAmount:newWidth - oldWidth forColumn:columnIndex animated:NO];
    
        if(self.headerDelegate)
        {
            [self.headerDelegate tableViewHeader:self columnWidthDidChange:columnIndex oldWidth:oldWidth newWidth:newWidth];
        }

        _lastTouchPos = centerPoint;
    }
}

#pragma mark - Load data

- (void)reloadData
{
    VerboseLog();
    for(TSTableViewHeaderSection *section in _headerSections)
    {
        [section removeFromSuperview];
    }
    [_headerSections removeAllObjects];

    if(self.dataSource)
    {
        _headerHeight = 0;
        CGFloat xOffset = 0;
        
        [self loadSubsectionsAtPath:nil section:nil yOffset:0 totalHeight:&_headerHeight totalWidth:&xOffset];
    }
}

#pragma mark - Load sections

- (void)loadSectionAtPath:(NSIndexPath *)sectionPath section:(TSTableViewHeaderSection *)section
{
    VerboseLog();
    CGFloat columnHeight = [self.dataSource heightForHeaderSectionAtPath:sectionPath];
    TSTableViewHeaderSectionView *sectionView = [self.dataSource headerSectionViewForColumnAtPath:sectionPath];
    sectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    sectionView.frame = CGRectMake(0, 0, section.bounds.size.width, columnHeight);
    section.sectionView = sectionView;
}

- (void)loadSubsectionsAtPath:(NSIndexPath *)sectionPath section:(TSTableViewHeaderSection *)rootSection yOffset:(CGFloat)yOffset totalHeight:(CGFloat *)totalHeight totalWidth:(CGFloat *)totalWidth
{
    VerboseLog();
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsAtPath:sectionPath];
    if(numberOfColumns)
    {
        NSMutableArray *subsections = [[NSMutableArray alloc] initWithCapacity:numberOfColumns];
        CGFloat xOffset = 0;
        CGFloat maxHeight = 0;
        CGFloat columnsCount = 0;
        for(int j = 0; j < numberOfColumns;  ++j)
        {
            NSInteger columnIndex = (rootSection ? rootSection.subcolumnsRange.location + columnsCount : columnsCount);
            NSIndexPath *subsectionPath = (sectionPath ? [sectionPath indexPathByAddingIndex:j] : [NSIndexPath indexPathWithIndex:j]);
            CGFloat columnWidth = [self.dataSource defaultWidthForColumnAtIndex:columnIndex];
            CGFloat columnHeight = [self.dataSource heightForHeaderSectionAtPath:subsectionPath];
            CGFloat subsectionsHeight = columnHeight;
            CGFloat subsectionsWidth = columnWidth;
            
            TSTableViewHeaderSection *columnSection = [[TSTableViewHeaderSection alloc] initWithFrame:CGRectMake(xOffset, yOffset, columnWidth, columnHeight)];
            columnSection.backgroundColor = [UIColor clearColor];
            columnSection.subcolumnsRange = NSMakeRange(columnIndex, 1);
            [subsections addObject:columnSection];
            
            [self loadSectionAtPath:subsectionPath section:columnSection];
            [self loadSubsectionsAtPath:subsectionPath section:columnSection yOffset:columnHeight totalHeight:&subsectionsHeight totalWidth:&subsectionsWidth];
            if(j != numberOfColumns - 1 || !rootSection)
                [self addSlideButtonToSection:columnSection];
            
            columnSection.frame = CGRectMake(xOffset, yOffset, subsectionsWidth, subsectionsHeight);
        
            if(subsectionsHeight > maxHeight)
                maxHeight = subsectionsHeight;
            
            xOffset += subsectionsWidth;
            columnsCount += columnSection.subcolumnsRange.length;
        }
        
        // Update section's size to max height
        for(int j = 0; j < numberOfColumns;  ++j)
        {
            TSTableViewHeaderSection *columnSection = subsections[j];
            columnSection.frame = CGRectMake(columnSection.frame.origin.x, columnSection.frame.origin.y, columnSection.frame.size.width, maxHeight);
            if(columnSection.subsections.count == 0)
                columnSection.sectionView.frame = columnSection.bounds;
        }
        if(rootSection)
        {
            rootSection.subcolumnsRange = NSMakeRange(rootSection.subcolumnsRange.location, columnsCount);
            rootSection.subsections = [NSArray arrayWithArray:subsections];
        }
        else
        {
            [_headerSections addObjectsFromArray:subsections];
            for(UIView *v in _headerSections)
                [self addSubview:v];
        }
        *totalHeight += maxHeight;
        *totalWidth = xOffset;
    }
}

#pragma mark - Modify content

- (void)changeColumnWidthOnAmount:(CGFloat)delta forColumn:(NSInteger)columnIndex animated:(BOOL)animated
{
    VerboseLog();
    TSTableViewHeaderSection *section;
    NSArray *sections = _headerSections;
    while(sections && sections.count)
    {
        for(int i = 0; i < sections.count;  ++i)
        {
            section = sections[i];
            if(columnIndex < section.subcolumnsRange.location + section.subcolumnsRange.length)
            {
                [TSUtils performViewAnimationBlock:^{
                    for(int j = i; j < sections.count;  ++j)
                    {
                        TSTableViewHeaderSection *tmp = sections[j];
                        CGRect rect = tmp.frame;
                        if(j == i)
                            rect.size.width += delta;
                        else
                            rect.origin.x += delta;
                        tmp.frame = rect;
                    }
                } withCompletion:nil animated:animated];
                sections = section.subsections;
                break;
            }
        }
    }
}

#pragma mark - Getters

- (CGFloat)tableTotalWidth
{
    VerboseLog();
    CGFloat width = 0;
    for(int j = 0; j < _headerSections.count;  ++j)
    {
        TSTableViewHeaderSection *columnSection = _headerSections[j];
        width += columnSection.frame.size.width;
    }
    return width;
}

- (CGFloat)headerHeight
{
    VerboseLog();
    return _headerHeight;
}

- (CGFloat)widthForColumnAtIndex:(NSInteger)index
{
    VerboseLog();
    TSTableViewHeaderSection *section = [self headerSectionAtIndex:index];
    return section.frame.size.width;
}

- (CGFloat)widthForColumnAtPath:(NSIndexPath *)indexPath
{
    VerboseLog();
    TSTableViewHeaderSection *section = [self headerSectionAtPath:indexPath];
    return section.frame.size.width;
}

- (CGFloat)offsetForColumnAtPath:(NSIndexPath *)indexPath
{
    UIView *section = [self headerSectionAtPath:indexPath];
    CGFloat xOffset = section.frame.origin.x;
    while (section.superview != self)
    {
        xOffset += section.superview.frame.origin.x;
        section = section.superview;
    }
    return xOffset;
}

#pragma mark - Selection

- (void)tapGestureDidRecognized:(UITapGestureRecognizer *)recognizer
{
    if(_allowColumnSelection)
    {
        CGPoint pos = [recognizer locationInView:self];
        NSIndexPath *columnIndexPath = [self findColumnAtPosition:pos parentColumn:nil parentColumnPath:nil];
        if(columnIndexPath && self.headerDelegate)
        {
            [self.headerDelegate tableViewHeader:self didSelectColumnAtPath:columnIndexPath];
        }
    }
}

- (NSIndexPath *)findColumnAtPosition:(CGPoint)pos parentColumn:(TSTableViewHeaderSection *)parentColumn parentColumnPath:(NSIndexPath *)parentColumnPath
{
    NSArray *columns = (parentColumn ? parentColumn.subsections : _headerSections);
    for(int i = 0; i < columns.count;  ++i)
    {
        TSTableViewHeaderSection *column = columns[i];
        if(CGRectContainsPoint(column.frame, pos))
        {
            NSIndexPath *columnIndexPath = (parentColumnPath ? [parentColumnPath indexPathByAddingIndex:i] : [NSIndexPath indexPathWithIndex:i]);
            return [self findColumnAtPosition:CGPointMake(pos.x - column.frame.origin.x, pos.y - column.frame.origin.y) parentColumn:column parentColumnPath:columnIndexPath];
        }
    }
    return parentColumnPath;
}

@end