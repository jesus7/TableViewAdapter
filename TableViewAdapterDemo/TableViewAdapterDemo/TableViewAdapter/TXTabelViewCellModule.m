//
//  TXTabelViewCellModule.m
//  Platform
//
//  Created by  jesus7_w on 15/10/15.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import "TXTabelViewCellModule.h"

@implementation TXTabelViewModule
-(void) loadData {
    //@TODO
}
@end

@implementation TXTabelViewCellModule
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

@implementation TXTabelViewSectionModule

-(instancetype) init {
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
        self.height = 0;
    }
    return self;
}
@end


@implementation TXTabelViewSimpleCellModule

@end
