//
//  TXTableViewCellModule.m
//  Platform
//
//  Created by  jesus7_w on 15/10/15.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import "TXTableViewCellModule.h"

@implementation TXTableViewModule
-(void) loadData {
    //@TODO
}
@end

@implementation TXTableViewCellModule
-(instancetype) init {
    self = [super init];
    if (self) {
        self.cellStyle = UITableViewCellStyleDefault;
        self.selctionStyle = UITableViewCellSelectionStyleDefault;
        self.viewCls = [UITableViewCell class];
        self.height = 0;
    }
    return self;
}

-(NSString *) viewIdentifier {
    if ([super viewIdentifier] == Nil) {
        [super setViewIdentifier:NSStringFromClass(self.viewCls)];
    }
    return [super viewIdentifier];
}
@end

@implementation TXTableViewSectionModule

-(instancetype) init {
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

-(TXTabelViewSectionHeaderFooterModule *) header {
    if (_header) {
        return _header;
    }
    _header = [TXTabelViewSectionHeaderFooterModule new];
    _header.viewIdentifier = @"__header__";
    return _header;
}

-(TXTabelViewSectionHeaderFooterModule *) footer {
    if (_footer) {
        return _footer;
    }
    _footer = [TXTabelViewSectionHeaderFooterModule new];
    _footer.viewIdentifier = @"__footer__";
    return _footer;
}

-(void) loadData {
    //@TODO
}
@end

@implementation TXTabelViewSectionHeaderFooterModule

@end

@implementation TXTableViewSimpleCellModule

@end
