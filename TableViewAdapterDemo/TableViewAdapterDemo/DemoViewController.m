//
//  DemoViewController.m
//  TableViewAdapterDemo
//
//  Created by  jesus7_w on 15/12/17.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import "DemoViewController.h"
#import "TXTableViewAdapter.h"
#import "DemoTableViewCell.h"

@interface TabelViewSectionModule1 : TXTabelViewSectionModule

@end
@implementation TabelViewSectionModule1
-(void) loadData {
    for (int i = 0; i < 10; i++) {
        TXTabelViewSimpleCellModule *module = [TXTabelViewSimpleCellModule new];
        module.height = 50;
        module.updateCell =  ^void(UITableViewCell* cell, NSIndexPath* indexPath, UITableView* tableView, TXTabelViewCellModule* module) {
            cell.textLabel.text = ((TXTabelViewSimpleCellModule*) module).title;
            cell.detailTextLabel.text = ((TXTabelViewSimpleCellModule*) module).subTitle;
        };
        module.cellStyle = UITableViewCellStyleValue1;
        module.subTitle = @(i).stringValue;
        module.viewCls = [UITableViewCell class];
        module.title = @"模块1";
        module.viewIdentifier = @"模块1";
        [self.dataSource addObject:module];
    }
    self.loadDataCallBack(YES, nil);
}
@end

@interface TabelViewSectionModule2 : TXTabelViewSectionModule

@end
@implementation TabelViewSectionModule2
-(void) loadData {
    for (int i = 0; i < 10; i++) {
        TXTabelViewSimpleCellModule *module = [TXTabelViewSimpleCellModule new];
        module.height = 40;
        module.updateCell =  ^void(UITableViewCell* cell, NSIndexPath* indexPath, UITableView* tableView, TXTabelViewCellModule* module) {
            cell.contentView.backgroundColor = [UIColor grayColor];
            cell.textLabel.text = ((TXTabelViewSimpleCellModule*) module).title;
            cell.detailTextLabel.text = ((TXTabelViewSimpleCellModule*) module).subTitle;
        };
        module.cellStyle = UITableViewCellStyleValue1;
        module.viewIdentifier = @"模块2";
        module.subTitle = @(i).stringValue;
        module.viewCls = [UITableViewCell class];
        module.title = @"模块2";
        [self.dataSource addObject:module];
    }
    self.loadDataCallBack(YES, nil);
}
@end

@interface TabelViewSectionModule3 : TXTabelViewSectionModule

@end
@implementation TabelViewSectionModule3
-(void) loadData {
    for (int i = 0; i < 10; i++) {
        TXTabelViewCellModule *module = [TXTabelViewCellModule new];
        module.height = 100;
        module.cellStyle = UITableViewCellStyleValue1;
        module.viewIdentifier = @"模块3";
        module.viewNibName = @"DemoTableViewCell";
        [self.dataSource addObject:module];
    }
    self.loadDataCallBack(YES, nil);
}
@end


@interface DemoViewController ()<TableItemClickDelegate, TableAdapterSupportEditDelegate>

@end


@implementation DemoViewController {
    UITableView *_tableView;
    
    TXTableViewAdapter* _adapter;
}

-(void) onItemClickforTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath inAdapter:(TXTableViewAdapter *)adapter {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    
    
    if (_multi_Section) {
        _adapter  = [TXTableViewAdapter new];
        
        _tableView.adapter = _adapter;
        _adapter.delegate = self;
        [_adapter.dataSource addObject:[TabelViewSectionModule1 new]];
        [_adapter.dataSource addObject:[TabelViewSectionModule2 new]];
        [_adapter.dataSource addObject:[TabelViewSectionModule3 new]];
        
        for (TXTabelViewSectionModule *module in _adapter.dataSource) {
            BLOCK_START
            module.loadDataCallBack =  ^void (BOOL success, NSDictionary * userInfo) {
                BLOCK_END
                [((DemoViewController*)sself)->_tableView reloadData];
            };
            
            [module loadData];
        }
    } else {
        _adapter  = [TXSimpleTableViewAdapter new];
        if (!_multi_Section) {
            for (int i = 0; i < 100; i++) {
                [_adapter.dataSource addObject:[self getModule:@(i).stringValue andSubTitle:@(i).stringValue]];
            }
        }
        if (_supportEdit) {
            _adapter.editDelegate = self;
        }
        
        _tableView.adapter = _adapter;
        _adapter.delegate = self;
        [_tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(TXTabelViewSimpleCellModule*) getModule:(NSString *) title andSubTitle:(NSString *) subTitle {
    TXTabelViewSimpleCellModule *module = [TXTabelViewSimpleCellModule new];
    if (_dynamicHeight) {
        module.height = 0; //default height;
        module.dynamicHeight = ^CGFloat (NSIndexPath* indexPath, UITableView* tableView,  TXTabelViewCellModule* module) {
            
            if (module.height > 0) {
                return module.height;
            }
            
            int height = arc4random() % 50 + 20;
            module.height = height;
            NSLog(@"%f", module.height);
            return module.height;
        };
    } else {
        module.height = 50;
    }
    module.updateCell =  ^void(UITableViewCell* cell, NSIndexPath* indexPath, UITableView* tableView, TXTabelViewCellModule* module) {
        cell.textLabel.text = ((TXTabelViewSimpleCellModule*) module).title;
        cell.detailTextLabel.text = ((TXTabelViewSimpleCellModule*) module).subTitle;
    };
    module.cellStyle = UITableViewCellStyleSubtitle;
    module.subTitle = subTitle;
    module.viewCls = [UITableViewCell class];
    module.title = title;
    return module;
}


#pragma edit
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:NO animated:YES];
}

-(NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
