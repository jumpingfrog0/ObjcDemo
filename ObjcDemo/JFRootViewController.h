//
//  JFRootViewController.h
//  ObjcDemo
//
//  Created by huangdonghong on 2026/1/5.
//

#import <UIKit/UIKit.h>
#import "JFTestItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFRootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *testListTableView;
@property (nonatomic, strong) NSArray<JFTestItem *> *testItems;

@end

NS_ASSUME_NONNULL_END
