//
//  TSTableViewController.m
//  TableView
//
//  Created by Viacheslav Radchenko on 8/15/13.
//  Copyright (c) 2013 Viacheslav Radchenko. All rights reserved.
//

#import "TSTableViewController.h"
#import "TSTableViewModel.h"
#import "TSDefines.h"
#import "TSTableViewController+TestDataDefinition.h"
#import <QuartzCore/QuartzCore.h>

@interface TSTableViewController () <TSTableViewDelegate>
{
    TSTableView *_tableView1;
    TSTableView *_tableView2;
    TSTableViewModel *_model1;
    TSTableViewModel *_model2;
    
    NSArray *_tables;
    NSArray *_dataModels;
    NSArray *_rowExamples;
    
    NSInteger _stepperPreviousValue;
}

@end

@implementation TSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.settingsView.layer.cornerRadius = 4;
    self.settingsView.layer.shadowOpacity = 0.5;
    self.settingsView.layer.shadowOffset = CGSizeMake(2, 4);
    
    // Top table
    _tableView1 = [[TSTableView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, self.view.frame.size.height/2 - 70)];
    _tableView1.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView1.delegate = self;
    [self.view addSubview:_tableView1];
    
    _model1 = [[TSTableViewModel alloc] initWithTableView:_tableView1 andStyle:kTSTableViewStyleDark];
//    NSArray *columns1 = [self columnsInfo1];
//    NSArray *rows1 = [self rowsInfo1];
//    [_model1 setColumnsInfo:columns1 andRowsInfo:rows1];
    
    NSArray *columns1 = [self columnsForFileSystemTree];
    NSArray *rows1 = [self rowsForAppDirectory];
    [_model1 setColumns:columns1 andRows:rows1];
    
    // Bottom table
   
    
    _tableView2 = [[TSTableView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2 + 50, self.view.frame.size.width - 40, self.view.frame.size.height/2 - 70)];
    _tableView2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView2.delegate = self;
    
    [self.view addSubview:_tableView2];
    
    _model2 = [[TSTableViewModel alloc] initWithTableView:_tableView2 andStyle:kTSTableViewStyleLight];
    
//    NSArray *columns2 = [self columnsInfo2];
//    NSArray *rows2 = [self rowsInfo2];
//    [_model2 setColumnsInfo:columns2 andRowsInfo:rows2];
    
    NSArray *columns2 = [self columnsForFileSystemTree];
    NSArray *rows2 = [self rowsForAppDirectory];
    [_model2 setColumns:columns2 andRows:rows2];
    
    _dataModels = @[_model1, _model2];
    _tables = @[_tableView1, _tableView2];
    
    // Row examples should correspond to columnsInfo* and rowsInfo* used above
//    _rowExamples = @[
//                     [self rowExample1],
//                     [self rowExample2],
//                     ];
    
    _rowExamples = @[
                     [self rowForDummyFile],
                     [self rowForDummyFile],
                     ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (IBAction)numberOfRowsValueChanged:(UIStepper *)stepper
{
    NSInteger val = [stepper value];
    if(val > _stepperPreviousValue)
    {
        for(int i = 0; i < _dataModels.count;  ++i)
        {
            TSTableView *table = _tables[i];
            TSTableViewModel *model = _dataModels[i];
            NSIndexPath *rowPath = [table pathToSelectedRow];
            if(!rowPath)
                rowPath = [NSIndexPath indexPathWithIndex:0];
            
            TSRow *row = _rowExamples[i];
            [model insertRow:row atPath:rowPath];
        }
    }
    else
    {
        for(int i = 0; i < _dataModels.count;  ++i)
        {
            TSTableView *table = _tables[i];
            TSTableViewModel *model = _dataModels[i];
            NSIndexPath *rowPath = [table pathToSelectedRow];
            if(rowPath)
                [model removeRowAtPath:rowPath];
            
        }
    }
    _stepperPreviousValue = val;
}

- (IBAction)expandAllButtonPressed
{
    for(TSTableView *table in _tables)
    {
        [table expandAllRowsWithAnimation:YES];
    }
}

- (IBAction)collapseAllButtonPressed
{
    for(TSTableView *table in _tables)
    {
        [table collapseAllRowsWithAnimation:YES];
    }
}

- (IBAction)resetSelectionButtonPressed
{
    for(TSTableView *table in _tables)
    {
        [table resetColumnSelectionWithAnimtaion:YES];
        [table resetRowSelectionWithAnimtaion:YES];
    }
}

#pragma mark - TSTableViewDelegate

- (void)tableView:(TSTableView *)tableView willSelectRowAtPath:(NSIndexPath *)rowPath animated:(BOOL)animated
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView didSelectRowAtPath:(NSIndexPath *)rowPath selectedCell:(NSInteger)cellIndex
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView willSelectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView didSelectColumnAtPath:(NSIndexPath *)columnPath
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView widthDidChangeForColumnAtIndex:(NSInteger)columnIndex
{
    VerboseLog();
}

- (void)tableView:(TSTableView *)tableView expandStateDidChange:(BOOL)expand forRowAtPath:(NSIndexPath *)rowPath
{
    VerboseLog();
}

#pragma mark - FileSystem

- (NSArray *)columnsForFileSystemTree
{
    NSArray *columns = @[
                         [TSColumn columnWithDictionary:@{ @"title" : @"Filename", @"subtitle" : @"Files in Application directory", @"minWidth" : @128, @"defWidth" : @288 }],
                         [TSColumn columnWithDictionary:@{ @"title" : @"Attributes", @"subcolumns" : @[
                          @{ @"title" : @"File size", @"titleFontSize" : @12, @"titleColor" : @"FF006F00", @"headerHeight" : @24, @"defWidth" : @64},
                                     @{ @"title" : @"Modification date", @"titleFontSize" : @12, @"headerHeight" : @24, @"defWidth" : @200},
                                     @{ @"title" : @"Creation date", @"titleFontSize" : @12, @"headerHeight" : @24, @"defWidth" : @200}
                          ]}
                          ]
                         ];
    return columns;
}

- (NSArray *)rowsForAppDirectory
{
    NSArray *dirs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if(!dirs || dirs.count ==0)
        return nil;
    
    NSURL *rootUrl = [dirs lastObject];
    
    return [self rowsForDirectory:[rootUrl URLByDeletingLastPathComponent]];
}

- (NSArray *)rowsForDirectory:(NSURL *)rootUrl
{
    NSError *error = nil;
    NSArray *properties = @[
        NSURLLocalizedNameKey,
        NSURLCreationDateKey,
        NSURLContentModificationDateKey,
        NSURLIsSymbolicLinkKey,
        NSURLIsDirectoryKey,
        NSURLIsHiddenKey,
        NSURLFileSizeKey
    ];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:MM  dd-MMM-YYYY"];
    
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:rootUrl
                                                   includingPropertiesForKeys:properties
                                                                      options:0//(NSDirectoryEnumerationSkipsHiddenFiles)
                                                                        error:&error];
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:array.count];
    for(NSURL * url in array)
    {
        NSString *localizedName = nil;
        [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
        
        NSNumber *isPackage = nil;
        [url getResourceValue:&isPackage forKey:NSURLIsPackageKey error:NULL];
        
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        NSNumber *isHidden = nil;
        [url getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:NULL];
        
        NSNumber *isSymbolic = nil;
        [url getResourceValue:&isSymbolic forKey:NSURLIsSymbolicLinkKey error:NULL];
        
        TSCell *cellFilename = [TSCell cellWithValue:localizedName];
        cellFilename.textAlignment = NSTextAlignmentLeft;
        NSArray *subrows = @[];
        if([isDirectory boolValue])
        {
            subrows = [self rowsForDirectory:url];
            cellFilename.icon = [UIImage imageNamed:@"TableViewFolderIcon"];
            
        }
        else
        {
            cellFilename.icon = [UIImage imageNamed:@"TableViewFileIcon"];
            cellFilename.textColor = [UIColor colorWithRed:0.5 green:0.4 blue:0 alpha:1];
        }
        
        if([isHidden boolValue])
        {
            cellFilename.textColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1];
        }
        
        if([isPackage boolValue])
        {
            cellFilename.icon = [UIImage imageNamed:@"TableViewPackageIcon"];
        }

        NSNumber *fileSize = nil;
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
        NSString *fileSizeStr = @"";
        if(fileSize)
            fileSizeStr = [NSString stringWithFormat:@"%.2f kb",[fileSize floatValue]/1024];
        
        NSDate *creationDate = nil;
        [url getResourceValue:&creationDate forKey:NSURLCreationDateKey error:NULL];
        
        NSDate *modificationDate = nil;
        [url getResourceValue:&modificationDate forKey:NSURLContentModificationDateKey error:NULL];

        TSRow *row = [TSRow rowWithDictionary:@{
                      @"cells" : @[
                              cellFilename,
                              @{@"value" : fileSizeStr},
                              @{@"value" : [dateFormatter stringFromDate:modificationDate]},
                              @{@"value" : [dateFormatter stringFromDate:creationDate]}
                              
                      ],
                      @"subrows" : subrows
         }];
        [rows addObject:row];
    }
    return [NSArray arrayWithArray:rows];
}

- (TSRow *)rowForDummyFile
{
    TSRow *row = [TSRow rowWithDictionary:@{
                  @"cells" : @[
                  @{@"value" : @"New File"},
                  @{@"value" : @"-"},
                  @{@"value" : @"-"},
                  @{@"value" : @"-"}
                  ],
                }];
    return row;

}


@end
