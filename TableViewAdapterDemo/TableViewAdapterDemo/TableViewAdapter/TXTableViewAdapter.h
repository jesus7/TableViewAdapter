//
//  TXTableViewAdapter.h
//  Platform
//
//  Created by  jesus7_w on 15/10/15.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXTabelViewCellModule.h"

@class TXTableViewAdapter;

@protocol TableItemClickDelegate <NSObject>
@required
-(void) onItemClickforTableView:(UITableView *) tableView atIndexPath:(NSIndexPath *) indexPath inAdapter:(TXTableViewAdapter*) adapter ;
@end

//编辑回调,其实就是把UITableViewDelegate的一些方法分离
@protocol TableAdapterSupportEditDelegate <NSObject>
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TXTableViewAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) id<TableItemClickDelegate> delegate;

@property (nonatomic, weak) id<TableAdapterSupportEditDelegate> editDelegate;

-(TXTabelViewCellModule *) cellModuleAtIndexPath:(NSIndexPath *) indexPath;
-(TXTabelViewSectionModule *) sectionModuleAtSection:(NSInteger) section;
@end

//简单的tableview适配器
@interface TXSimpleTableViewAdapter : TXTableViewAdapter

@end

@interface  UITableView (Adapter)
@property (nonatomic, weak) TXTableViewAdapter *adapter;
@end