TSTableView
=======

`TSTableView` is UI component for displaying multi columns tabular data with support of hierarchical rows and columns structure.
It provides smooth animations for item selection and dynamic content modification. Some features are listed below:

* Suport muti columns data structure.
* Support hierarchical column definition (i.e. column may have subsections).
* Support hierarchical row definition (i.e. row may have expand subrows).
* Optimized to display big sets of data: row and cell views are cached internally and reused during scrolling.
* Support row and column selection.
* Allow modification of column width by sliding column border.
* Allow expand/collapse subrows content.
* Support simple declarative syntax for columns and rows content definition.
* Providing your own implementation of TSTableViewDataSource protocol will allow you fully customise structure and appearance of the table.
* Default TSTableViewModel implements TSTableViewDataSource protocol and includes two built in styles (see screenshots).
            
<img src="https://raw.github.com/Viacheslav-Radchenko/TSUIKit/master/Screenshots/TSTableView_SCreenshot1.png" alt="TSTableView examples" width="360" height="480" />
<img src="https://raw.github.com/Viacheslav-Radchenko/TSUIKit/master/Screenshots/TSTableView_SCreenshot2.png" alt="TSTableView examples" width="360" height="480" />

Example of TSTableView object instantiation provided below. 
```
    NSArray *columns = @[
                         @{ @"title" : @"Column 1", @"subtitle" : @"This is first column"},
                         @{ @"title" : @"Column 2", @"subcolumns" : @[
                                    @{ @"title" : @"Column 2.1", @"headerHeight" : @20},
                                    @{ @"title" : @"Column 2.2", @"headerHeight" : @20}]},
                         @{ @"title" : @"Column 3", @"titleColor" : @"FF00CF00"}
                         ];

    NSArray *rows = @[
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 1"},
                                 @{ @"value" : @1},
                                 @{ @"value" : @2},
                                 @{ @"value" : @3}
                                 ]
                         },
                      @{ @"cells" : @[
                                 @{ @"value" : @"Value 2"},
                                 @{ @"value" : @2},
                                 @{ @"value" : @3},
                                 @{ @"value" : @4}
                                 ]
                         }
                      ];

    TSTableView *tableView = [[TSTableView alloc] initWithFrame:self.view.bounds];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    TSTableViewModel  *dataModel = [[TSTableViewModel alloc] initWithTableView:tableView andStyle:kTSTableViewStyleDark];
    [dataModel setColumnsInfo:columns andRowsInfo:rows];

```
Result of code snippet is shown below, as well as more complex example displaying file system tree using `TSTableView`.

<img src="https://raw.github.com/Viacheslav-Radchenko/TSUIKit/master/Screenshots/TSTableView_Screenshot3.png" alt="TSTableView examples" width="360" height="480" />
<img src="https://raw.github.com/Viacheslav-Radchenko/TSUIKit/master/Screenshots/TSTableView_Screenshot4.png" alt="TSTableView examples" width="360" height="480" />

## Links

Parent repository [TSUIKit](https://github.com/Viacheslav-Radchenko/TSUIKit).

## Requirements

* Xcode 4.5 or higher
* Apple LLVM compiler
* iOS 5.0 or higher
* ARC

## Demo

Build and run the `TSTableView` project in Xcode to see examples.

## Installation

All you need to do is drop source files from `Classes\TSUIKit` folder into your project and add `#include "TSTableView.h"`.

## Contact

Viacheslav Radchenko

- https://github.com/Viacheslav-Radchenko
- radchencko.v.i@gmail.com

## License

TSTableView is available under the MIT license.

Copyright © 2013 Viacheslav Radchenko.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
