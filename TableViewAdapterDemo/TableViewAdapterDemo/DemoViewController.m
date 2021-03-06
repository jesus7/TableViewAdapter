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

@interface TabelViewSectionModule1 : TXTableViewSectionModule

@end
@implementation TabelViewSectionModule1

-(instancetype) init {
    self = [super init];
    if (self) {
        self.header.height = 10;
        self.header.backgroundColor = [UIColor greenColor];
        self.footer.height = 20;
        self.footer.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) loadData {
    for (int i = 0; i < 10; i++) {
        TXTableViewSimpleCellModule *module = [TXTableViewSimpleCellModule new];
        module.height = 50;
        module.updateCell =  ^void(UITableViewCell* cell, NSIndexPath* indexPath, UITableView* tableView, TXTableViewCellModule* module) {
            cell.textLabel.text = ((TXTableViewSimpleCellModule*) module).title;
            cell.detailTextLabel.text = ((TXTableViewSimpleCellModule*) module).subTitle;
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

@interface TabelViewSectionModule2 : TXTableViewSectionModule

@end
@implementation TabelViewSectionModule2

-(instancetype) init {
    self = [super init];
    if (self) {
        self.header.height = 10;
        self.header.backgroundColor = [UIColor orangeColor];
        self.footer.height = 20;
        self.footer.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void) loadData {
    for (int i = 0; i < 10; i++) {
        TXTableViewSimpleCellModule *module = [TXTableViewSimpleCellModule new];
        module.height = 40;
        module.updateCell =  ^void(UITableViewCell* cell, NSIndexPath* indexPath, UITableView* tableView, TXTableViewCellModule* module) {
            cell.contentView.backgroundColor = [UIColor grayColor];
            cell.textLabel.text = ((TXTableViewSimpleCellModule*) module).title;
            cell.detailTextLabel.text = ((TXTableViewSimpleCellModule*) module).subTitle;
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

@interface TabelViewSectionModule3 : TXTableViewSectionModule

@end
@implementation TabelViewSectionModule3
-(void) loadData {
    for (int i = 0; i < 10; i++) {
        TXTableViewCellModule *module = [TXTableViewCellModule new];
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
        
        for (TXTableViewSectionModule *module in _adapter.dataSource) {
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


-(TXTableViewSimpleCellModule*) getModule:(NSString *) title andSubTitle:(NSString *) subTitle {
    TXTableViewSimpleCellModule *module = [TXTableViewSimpleCellModule new];
    if (_dynamicHeight) {
        module.height = 0; //default height;
        module.dynamicHeight = ^CGFloat (NSIndexPath* indexPath, UITableView* tableView,  TXTableViewCellModule* module) {
            
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
    module.updateCell =  ^void(UITableViewCell* cell, NSIndexPath* indexPath, UITableView* tableView, TXTableViewCellModule* module) {
        cell.textLabel.text = ((TXTableViewSimpleCellModule*) module).title;
        cell.detailTextLabel.text = ((TXTableViewSimpleCellModule*) module).subTitle;
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
