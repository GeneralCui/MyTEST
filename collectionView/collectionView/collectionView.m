//
//  collectionView.m
//  collectionView
//
//  Created by tzh on 2017/11/29.
//  Copyright © 2017年 tzh. All rights reserved.
//

#import "collectionView.h"

//CGFloat const TOP_OFFSCREEN_MARGIN = 120;

@implementation collectionView


// Append a page
-(void)appendItem{

    [self addNewPage];
    
}
// Add
-(void)addNewPage{


    NSInteger total=[self numberOfItemsInSection:0];
    if (total > 0) {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:total-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }

    ///Add Data
    [(id<collectionViewDataSource>)self.dataSource willAppendItemInCollectionView:self];
    NSInteger lastRow = total;
    NSIndexPath* insertIndexPath=[NSIndexPath indexPathForItem:lastRow inSection:0];

    [self insertItemsAtIndexPaths:@[insertIndexPath]];
    self.inEditState = YES;

}

#pragma mark - 是否处于编辑状态

- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState) {
        for (collectionViewCell *cvCell in self.visibleCells) {
            cvCell.button.hidden = NO;
        }
    } else {
        for (collectionViewCell *cvCell in self.visibleCells) {
            cvCell.button.hidden = YES;
        }
    }
}


@end
