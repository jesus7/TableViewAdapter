//
//  TXTableViewAdapter.m
//  Platform
//
//  Created by  jesus7_w on 15/10/15.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import "TXTableViewAdapter.h"


@implementation TXTableViewAdapter

-(instancetype) init {
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

-(TXTableViewCellModule*) cellModuleAtIndexPath:(NSIndexPath *)indexPath {
    TXTableViewSectionModule *section = [self sectionModuleAtSection:indexPath.section];
    return section.dataSource[indexPath.row];
}

-(TXTableViewSectionModule *) sectionModuleAtSection:(NSInteger)section {
    return _dataSource[section];
}

#pragma mark tableview
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  {
    return _dataSource.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self sectionModuleAtSection:section].dataSource.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self sectionModuleAtSection:section].height;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTableViewCellModule *module = [self cellModuleAtIndexPath:indexPath];
    if (module.dynamicHeight) {
        return module.dynamicHeight(indexPath, tableView, module);
    }
    return module.height;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TXTableViewSectionModule *sectionModule = [self sectionModuleAtSection:section];
    UITableViewHeaderFooterView *view =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionModule.viewIdentifier];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:sectionModule.viewIdentifier];
        if (sectionModule.sectionView) {
            UIView *child =  sectionModule.sectionView();
            [view addSubview:child];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
        if (sectionModule.sectionBackgroundColor) {
            view.contentView.backgroundColor = sectionModule.sectionBackgroundColor;
        }
    }
    if (sectionModule.updateSection) {
        sectionModule.updateSection(view, section, tableView, sectionModule);
    }
    return view;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTableViewCellModule *module = [self cellModuleAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:module.viewIdentifier];
    if (!cell) {
        if (module.createCell) {
            cell = module.createCell(indexPath, tableView, module.viewIdentifier);
        } else {
            if (module.viewNibName) {
                [tableView registerNib:[UINib nibWithNibName:module.viewNibName bundle:nil] forCellReuseIdentifier:module.viewIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:module.viewIdentifier];
            } else {
                cell = [[module.viewCls alloc] initWithStyle:module.cellStyle reuseIdentifier:module.viewIdentifier];
            }
        }
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = module.separatorInset;
    }
    cell.selectionStyle = module.selctionStyle;
    
    //如果cell有实现TableViewCellModuleDataSource协议并且实现了updatecell方法，优先通过TableViewCellModuleDataSource更新
    if ([cell respondsToSelector:@selector(tableView:UpdateCell:atIndexPath:withModule:)]) {
        id<TableViewCellModuleDataSource> dataSource = (id<TableViewCellModuleDataSource> )cell;
        [dataSource tableView:tableView UpdateCell:cell atIndexPath:indexPath withModule:module];
    } else {
        if (module.updateCell) {
            module.updateCell(cell, indexPath, tableView, module);
        }
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTableViewCellModule *module = [self cellModuleAtIndexPath:indexPath];
    if (module.clickCell) {
        module.clickCell(indexPath, tableView, module);
        return;
    }
    
    if (_delegate) {
        [_delegate onItemClickforTableView:tableView atIndexPath:indexPath inAdapter:self];
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTableViewCellModule *module = [self cellModuleAtIndexPath:indexPath];
    if (module.dynamicHeight || !module.calculationHeightByCell) {
        return;
    }
    CGFloat height =  [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    if (height < module.height) {
        //autoLayout 没有规范使用
        module.calculationHeightByCell = NO;
        return;
    }
    module.height =  height;
    
    module.dynamicHeight = ^CGFloat (NSIndexPath* indexPath, UITableView* tableView,  TXTableViewCellModule* module){
        return module.height;
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW , 0.01), dispatch_get_main_queue(), ^{
        //        [tableView reloadData];
        //TODO 这里直接reloadData可能性能会有问题
        NSArray *indexPaths =  [tableView indexPathsForVisibleRows];
        NSIndexPath *last;
        for (NSIndexPath *path in indexPaths) {
            if (path.row > last.row) {
                last = path;
            }
        }
        
        if (last.row == indexPath.row) {
            [tableView reloadData];
        }
    });
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TXTableViewCellModule *module = [self cellModuleAtIndexPath:indexPath];
//    return module.height;
//}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_editDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [_editDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_editDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [_editDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_editDelegate respondsToSelector:@selector(tableView:commitEditingStyle: forRowAtIndexPath:)]) {
        [_editDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_editDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [_editDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}
@end


@implementation TXSimpleTableViewAdapter
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(TXTableViewCellModule*) cellModuleAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row];
}

-(TXTableViewSectionModule *) sectionModuleAtSection:(NSInteger)section {
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

@end


@implementation UITableView (Adapter)

-(void) setAdapter:(TXTableViewAdapter *)adapter {
    self.dataSource =adapter;
    self.delegate = adapter;
}

-(TXTableViewAdapter *) adapter {
    if (self.dataSource ==nil && self.delegate == nil) {
        return nil;
    }
    if ([self.dataSource isKindOfClass:[TXTableViewAdapter class]]) {
        return (TXTableViewAdapter*)self.dataSource;
    }
    
    if ([self.delegate isKindOfClass:[TXTableViewAdapter class]]) {
        return (TXTableViewAdapter*)self.delegate;
    }
    return nil;
}

@end