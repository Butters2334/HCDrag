//
//  HCDragView.h
//  ScratchCardDemo
//
//  Created by ac on 2019/12/13.
//  Copyright © 2019 ancc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HCDragView;
@protocol HCDragViewDelegate <NSObject>
/**每次滑动后都会响应函数*/
-(void)dragView:(HCDragView *)dragView progressRate:(NSArray <NSNumber *>*)progressRate;
@end

/**刮刮卡双向拖动进度条*/
@interface HCDragView : UIView
/**拖动后的回调,或者直接调用progressRateNumber也可以获取最新值*/
@property (nonatomic,assign)id <HCDragViewDelegate>delegate;
/**不同区域的色值*/
@property (nonatomic,strong)NSArray <UIColor *>*progressRateColor;
/**区域内数值,如果传入数值相加不等于100会按比例调整为100*/
@property (nonatomic,strong)NSArray <NSNumber *>*progressRateNumber;
/**刷新页面*/
-(void)resetView;
/**刷新进度条显示*/
-(void)resetProgressRateNumber;
@end

NS_ASSUME_NONNULL_END
