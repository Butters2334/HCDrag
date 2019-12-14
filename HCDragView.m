//
//  HCDragView.m
//  ScratchCardDemo
//
//  Created by ac on 2019/12/13.
//  Copyright © 2019 ancc. All rights reserved.
//

#import "HCDragView.h"

@interface HCDragView()
/**进度条父级view*/
@property (nonatomic,strong)UIView *contentView;
/**拖动进度条数组*/
@property (nonatomic,strong)NSArray *panViewArray;
/**滑动开始的时候计算并保存下可滑动范围*/
@property (nonatomic,assign)CGFloat startPropress;
/**最大可滑动范围*/
@property (nonatomic,assign)CGFloat endPropress;
@end

@implementation HCDragView

-(void)setProgressRateNumber:(NSArray<NSNumber *> *)progressRateNumber
{
    _progressRateNumber = progressRateNumber;
    if(![progressRateNumber isKindOfClass:NSArray.class])
    {
        return;
    }
    NSInteger allNum = 0;
    for(NSNumber *number in _progressRateNumber)
    {
        allNum += number.integerValue;
    }
    NSMutableArray *tmp = [NSMutableArray new];
    for(NSInteger index=0;index<_progressRateNumber.count;index++)
    {
        tmp[index] = @([_progressRateNumber[index] integerValue]*(100./allNum));
    }
    _progressRateNumber = tmp;
}
/**刷新页面*/
-(void)resetView
{
    self.backgroundColor = [UIColor clearColor];
    if(self.progressRateNumber.count == 0 && self.progressRateColor.count == 0)
    {
        return;
    }
    //传入参数不一致时,确保能运行为前提
    if(self.progressRateNumber.count != self.progressRateColor.count)
    {
        NSInteger maxCount = MIN(self.progressRateNumber.count, self.progressRateColor.count);
        self.progressRateNumber = [self.progressRateNumber subarrayWithRange:NSMakeRange(0, maxCount)];
        self.progressRateColor = [self.progressRateColor subarrayWithRange:NSMakeRange(0, maxCount)];
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *contentView = [UIView new];
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    CGFloat contentHeight = 10;
    CGFloat contentWidth  = self.frame.size.width;
    CGFloat panViewWidth  = 24;
    contentView.layer.cornerRadius = contentHeight/2.;
    CGFloat selfHeight = self.frame.size.height;
    contentView.frame = CGRectMake(0, (selfHeight-contentHeight)/2., contentWidth , contentHeight);
    {
        //计算实际可用进度条控件
        contentWidth -= panViewWidth * (self.progressRateNumber.count - 1);
        if(self.progressRateNumber.lastObject.integerValue==0)
        {
            contentWidth += panViewWidth*0.5;
        }
        if(self.progressRateNumber.firstObject.integerValue==0)
        {
            contentWidth += panViewWidth*0.5;
        }
    }
    //生成进度view
    UIView *previousView = nil;
    for (NSInteger index=0; index<self.progressRateNumber.count; index++)
    {
        UIView *propressView = [UIView new];
        propressView.backgroundColor = self.progressRateColor[index];
        CGFloat propressWidth = [self.progressRateNumber[index]floatValue]/100.*contentWidth;
        if(index == 0 || index == self.progressRateNumber.count-1)
        {
            propressWidth += panViewWidth*0.5;
        }else{
            propressWidth += panViewWidth;
        }
        propressView.frame = CGRectMake(previousView.frame.origin.x+previousView.frame.size.width, 0, propressWidth, contentHeight);
        [contentView addSubview:propressView];
        previousView = propressView;
    }
    //拖动条固定在进度view后面
    NSMutableArray *panViewArray = [NSMutableArray new];
    for(NSInteger index=0;index<self.progressRateNumber.count-1;index++)
    {
        UIView *panView = [[UIView alloc] init];
        panView.layer.backgroundColor = [UIColor colorWithRed:229/255.0 green:227/255.0 blue:237/255.0 alpha:1.0].CGColor;
        panView.layer.cornerRadius = 6;
        panView.layer.shadowColor = [UIColor colorWithRed:59/255.0 green:53/255.0 blue:85/255.0 alpha:0.55].CGColor;
        panView.layer.shadowOffset = CGSizeMake(0,0);
        panView.layer.shadowRadius = 6;
        [self addSubview:panView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)];
        panView.userInteractionEnabled = YES;
        [panView addGestureRecognizer:pan];
        

        UIView *propressView = contentView.subviews[index];
        CGFloat shadowOpacity = 1;
        panView.layer.shadowOpacity = shadowOpacity;
        panView.frame = CGRectMake(propressView.frame.origin.x+propressView.frame.size.width-panViewWidth/2.,shadowOpacity,panViewWidth,selfHeight-shadowOpacity*2);
        [panViewArray addObject:panView];
    }
    self.panViewArray = panViewArray;
//    [self resetProgressRateNumber];
}
-(void)panEvent:(UIPanGestureRecognizer *)pan
{
    NSInteger panIndex = [self.panViewArray indexOfObject:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            //计算当前可滑动的范围
            self.endPropress   = 0.0;
            //第零个控件可以直接从零开始计算
            CGFloat panWidth_2 = pan.view.frame.size.width;
            NSArray *subviews  = self.contentView.subviews;
            UIView *preView    = subviews[panIndex];
            self.startPropress = panIndex == 0 ? panWidth_2/2. : preView.frame.origin.x+panWidth_2;
            UIView *lastView   = subviews[panIndex+1];
            self.endPropress   = (lastView.frame.origin.x+lastView.frame.size.width)-(subviews.lastObject==lastView ?panWidth_2/2.:panWidth_2);
        }   break;
        case UIGestureRecognizerStateChanged:
        {
            //避免为0的滑块本身大小冲突,最终结果需要按比例换算
            CGPoint point      = [pan locationInView:self];
            CGPoint newCenter  = CGPointMake(MAX(MIN(point.x, self.endPropress), self.startPropress), pan.view.center.y);
            NSArray *subviews  = self.contentView.subviews;
            CGFloat distance   = (newCenter.x - pan.view.center.x);
            UIView *preView    = subviews[panIndex];
            preView.frame      = CGRectMake(preView.frame.origin.x, preView.frame.origin.y, preView.frame.size.width+distance, preView.frame.size.height);
            UIView *lastView   = subviews[panIndex+1];
            lastView.frame      = CGRectMake(lastView.frame.origin.x+distance, lastView.frame.origin.y, lastView.frame.size.width-distance, lastView.frame.size.height);
            pan.view.center    = newCenter;
            [self resetProgressRateNumber];
        }   break;
        case UIGestureRecognizerStateEnded:
        {
            //结算的时候是否将范围归零其实不重要了
            self.startPropress = 0.0;
            self.endPropress   = 0.0;
        }   break;
        default:
            break;
    }
}

/**刷新进度条显示*/
-(void)resetProgressRateNumber
{
    NSArray *subviews  = self.contentView.subviews;
    CGFloat panWidth   = [self.panViewArray.firstObject frame].size.width;
    CGFloat contenttWidth = self.contentView.frame.size.width - panWidth * (self.panViewArray.count);
    NSMutableArray *progressRateNumber = [NSMutableArray new];
    if([self.panViewArray.firstObject frame].origin.x < 0)
    {
        contenttWidth += panWidth*0.5;
    }
    if([self.panViewArray.lastObject frame].origin.x +
       [self.panViewArray.lastObject frame].size.width > self.contentView.frame.size.width)
    {
        contenttWidth += panWidth*0.5;
    }
//    NSInteger all = 0;
    for(UIView *subview in subviews)
    {
        CGFloat pViewWidth = subview.frame.size.width;
        if(subview == subviews.firstObject || subview == subviews.lastObject)
        {
            pViewWidth -= panWidth/2.;
        }else{
            pViewWidth -= panWidth;
        }
        NSInteger propressNum = [NSString stringWithFormat:@"%.0f",MAX(pViewWidth, 0)/contenttWidth*100.].integerValue;
        [progressRateNumber addObject:@(propressNum)];
//        all += propressNum;
    }
    //有可能会出现多个进度都在0.5以下导致总数额变为99的bug,暂时没有合适的解决办法
//    progressRateNumber[progressRateNumber.count-1] = @([progressRateNumber.lastObject integerValue]+(100-all));
    
    self.progressRateNumber = progressRateNumber;
    if(self.delegate && [self.delegate respondsToSelector:@selector(dragView:progressRate:)])
    {
        [self.delegate dragView:self progressRate:_progressRateNumber];
    }
}
@end
