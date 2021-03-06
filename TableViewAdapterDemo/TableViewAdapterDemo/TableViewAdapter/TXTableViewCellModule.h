//
//  TXTableViewCellModule.h
//  Platform
//
//  Created by  jesus7_w on 15/10/15.
//  Copyright © 2015年  jesus7_w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//在block中如果使用self会导致内测泄露
#define  BLOCK_START  __weak id wself = self;
#define  BLOCK_END __strong id sself = wself;
/****
 BLOCK_START
 TXTableViewCellModule updateCell =   ^void (UITableViewCell *cell, NSIndexPath* indexPath, UITableView *tableView, TXTableViewCellModule *module) {
    BLOCK_END
    [sself dotoSomeThing];
 };
****/

@class TXTableViewCellModule;
@class TXTableViewSectionModule;
@class  TXTabelViewSectionHeaderFooterModule;

@protocol TableViewCellModuleDataSource <NSObject>

@required
+(TXTableViewCellModule *) moduleAtIndexPath:(NSIndexPath *) indexPath withModel:(id) model;

@optional
-(void) tableView:(UITableView *) tableView UpdateCell:(UITableViewCell *) cell atIndexPath:(NSIndexPath *) indexPath withModule:(TXTableViewCellModule *) module;
@end

//定义更新cell的block
typedef void (^UpdateCellCallBack)(UITableViewCell*, NSIndexPath*, UITableView*, TXTableViewCellModule*);
//定义点击cell的block;
typedef void (^ClickCellCallBack)(NSIndexPath*, UITableView*, TXTableViewCellModule *);

//定义高度获取的block;
typedef CGFloat (^CellHeightCallBack)(NSIndexPath*, UITableView*,  TXTableViewCellModule*);

//定义创建cell的block
typedef UITableViewCell* (^CreateCellCallBack)(NSIndexPath*, UITableView*,  NSString*);
//加载数据
typedef void (^LoadDataCallBack)(BOOL, NSDictionary *);

@interface TXTableViewModule : NSObject
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSString *viewIdentifier;
@property (nonatomic, strong) id model;//数据模型
@property (nonatomic, assign) NSInteger tag;

@end

//tableview cell模块
@interface TXTableViewCellModule : TXTableViewModule
@property (nonatomic, assign) Class viewCls;
//优先考虑dynamicHeight
@property (nonatomic, copy) CellHeightCallBack dynamicHeight;

//这里更合适？
/**
在使用约束的情形下可以使用程序计算高度
 **/
@property (nonatomic, assign) BOOL calculationHeightByCell; //由程序自己计算高度,实验阶段，谨慎使用

@property (nonatomic, strong) NSString *viewNibName;
#pragma mark  UITableViewCell常用属性
@property (nonatomic, assign)  UITableViewCellStyle cellStyle;
@property (nonatomic, assign) UITableViewCellSelectionStyle selctionStyle;
@property (nonatomic, assign) UIEdgeInsets  separatorInset;
#pragma end
@property (nonatomic, copy) UpdateCellCallBack updateCell;
@property (nonatomic, copy) ClickCellCallBack clickCell;
@property (nonatomic, copy) CreateCellCallBack createCell;
@end



@interface TXTableViewSimpleCellModule : TXTableViewCellModule
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIImage *icon;
@end

typedef UIView* (^MakeHeaderOrFooterViewBlock)();
typedef void (^UpdateHeaderFooterCallBack)(UITableViewHeaderFooterView*, NSInteger, UITableView*, TXTabelViewSectionHeaderFooterModule *);


@interface TXTabelViewSectionHeaderFooterModule : TXTableViewModule;
@property (nonatomic, copy) MakeHeaderOrFooterViewBlock headerFooterView;
@property (nonatomic, copy) UpdateHeaderFooterCallBack updateHeaderFooter;
@property (nonatomic, copy) UIColor *backgroundColor;
//TODO support dynamic height?
@end


//tableview 头模块
@interface TXTableViewSectionModule : NSObject
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) TXTabelViewSectionHeaderFooterModule *header;
@property (nonatomic, strong) TXTabelViewSectionHeaderFooterModule *footer;

-(void) loadData;
@property (nonatomic, copy) LoadDataCallBack loadDataCallBack;

@end

