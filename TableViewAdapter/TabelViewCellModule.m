//
//  TabelViewCellModule.m
//  Platform
//
//  Created by  jesus7_w on 15/10/15.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import "TabelViewCellModule.h"

@implementation TabelViewModule
-(void) loadData {
    //@TODO
}
@end

@implementation TabelViewCellModule
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

@implementation TabelViewSectionModule

-(instancetype) init {
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
        self.height = 0;
    }
    return self;
}
@end


@implementation TabelViewSimpleCellModule

@end
