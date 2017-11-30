//
//  collectionViewFlowLayout.h
//  collectionView
//
//  Created by tzh on 2017/11/28.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlowLayoutDelegate <NSObject>

 // 更新数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;

// 改变编辑状态
- (void)didChangeEditState:(BOOL)inEditState;

@end

@interface collectionViewFlowLayout : UICollectionViewFlowLayout

//检测是否处于编辑状态
@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, weak) id<FlowLayoutDelegate> delegate;

@end
