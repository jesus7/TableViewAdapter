//
//  ViewController.m
//  TableViewAdapterDemo
//
//  Created by  jesus7_w on 15/12/17.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import "ViewController.h"
#import "TableViewAdapter.h"
#import "DemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    UITableView *_tableView;
    
    TableViewAdapter* _adapter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _adapter  = [SimpleTableViewAdapter new];
    _tableView.adapter = _adapter;

    BLOCK_START
    [_adapter.dataSource addObject:[self getModule:@"多个section" andClickCell:^(NSIndexPath * indexPath, UITableView * tableView, TabelViewCellModule * module) {
        DemoViewController *controller = [DemoViewController new];
        controller.multi_Section = YES;
        BLOCK_END
        [((ViewController *) sself) presentViewController:controller animated:YES completion:nil];
    }]];
    
    [_adapter.dataSource addObject:[self getModule:@"动态高度" andClickCell:^(NSIndexPath * indexPath, UITableView * tableView, TabelViewCellModule * module) {
        
        DemoViewController *controller = [DemoViewController new];
        controller.dynamicHeight = YES;
        BLOCK_END
        [((ViewController *) sself) presentViewController:controller animated:YES completion:nil];
    }]];
    
    [_adapter.dataSource addObject:[self getModule:@"可编辑" andClickCell:^(NSIndexPath * indexPath, UITableView * tableView, TabelViewCellModule * module) {
        
        DemoViewController *controller = [DemoViewController new];
        controller.supportEdit = YES;
        BLOCK_END
        [((ViewController *) sself) presentViewController:controller animated:YES completion:nil];
    }]];
    
    [_tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}


-(TabelViewSimpleCellModule*) getModule:(NSString *) title andClickCell:(ClickCellCallBack ) clickCell {
    TabelViewSimpleCellModule *module = [TabelViewSimpleCellModule new];
    module.height = 50;
    module.updateCell =  ^void(UITableViewCell* cell, NSIndexPath* indexPath, UITableView* tableView, TabelViewCellModule* module) {
        cell.textLabel.text = ((TabelViewSimpleCellModule*) module).title;
    };
    module.clickCell = clickCell;
    module.viewCls = [UITableViewCell class];
    module.title = title;
    return module;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
