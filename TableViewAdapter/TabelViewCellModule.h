//
//  TabelViewCellModule.h
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
 TabelViewCellModule updateCell =   ^void (UITableViewCell *cell, NSIndexPath* indexPath, UITableView *tableView, TabelViewCellModule *module) {
    BLOCK_END
    [sself dotoSomeThing];
 };
****/

@class TabelViewCellModule;

@protocol TableViewCellModuleDataSource <NSObject>

@required
+(TabelViewCellModule *) moduleAtIndexPath:(NSIndexPath *) indexPath withModel:(id) model;

@optional
-(void) tableView:(UITableView *) tableView UpdateCell:(UITableViewCell *) cell atIndexPath:(NSIndexPath *) indexPath withModule:(TabelViewCellModule *) module;
@end

@class TabelViewCellModule;
@class TabelViewSectionModule;
//定义更新cell的block
typedef void (^UpdateCellCallBack)(UITableViewCell*, NSIndexPath*, UITableView*, TabelViewCellModule*);
//定义点击cell的block;
typedef void (^ClickCellCallBack)(NSIndexPath*, UITableView*, TabelViewCellModule *);

//定义高度获取的block;
typedef CGFloat (^CellHeightCallBack)(NSIndexPath*, UITableView*,  TabelViewCellModule*);

//定义创建cell的block
typedef UITableViewCell* (^CreateCellCallBack)(NSIndexPath*, UITableView*,  NSString*);
//加载数据
typedef void (^LoadDataCallBack)(BOOL, NSDictionary *);

@interface TabelViewModule : NSObject
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSString *viewIdentifier;
@property (nonatomic, strong) id model;//数据模型
@property (nonatomic, assign) NSInteger tag;
//@TODO 是否把加载数据放到SectionModule里面？
-(void) loadData;
@property (nonatomic, copy) LoadDataCallBack loadDataCallBack;
@end

//tableview cell模块
@interface TabelViewCellModule : TabelViewModule
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



@interface TabelViewSimpleCellModule : TabelViewCellModule
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIImage *icon;
@end


typedef UIView* (^MakeHeaderOrFooterViewBlock)();
typedef void (^UpdateSectionCallBack)(UIView*, NSInteger, UITableView*, TabelViewSectionModule *);

//tableview 头模块
@interface TabelViewSectionModule : TabelViewModule
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) MakeHeaderOrFooterViewBlock sectionView;
@property (nonatomic, copy) UpdateSectionCallBack updateSection;
@property (nonatomic, copy) UIColor *sectionBackgroundColor;


@end

