//
//  ViewController.m
//  DragDemo
//
//  Created by ac on 2019/12/13.
//  Copyright © 2019 ancc. All rights reserved.
//

#import "ViewController.h"
#import "HCDragView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()<HCDragViewDelegate>
@property (nonatomic,strong)HCDragView *dView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0x2f/255. green:0x28/255. blue:0x49/255. alpha:1];
    
    NSArray *progressRateColor = @[[UIColor colorWithRed:89/255.0 green:124/255.0 blue:184/255.0 alpha:1.0],[UIColor colorWithRed:79/255.0 green:162/255.0 blue:140/255.0 alpha:1.0],[UIColor colorWithRed:187/255.0 green:76/255.0 blue:76/255.0 alpha:1.0],[UIColor yellowColor]];
    
    HCDragView *dView = [HCDragView new];
    dView.delegate = self;
    dView.progressRateNumber = @[@10,@10,@30];
    dView.progressRateColor = progressRateColor;
    [self.view addSubview:dView];
    self.dView = dView;
    [dView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(20);
    }];
    [dView layoutIfNeeded];
    [dView resetView];
    
    UIView *preView = nil;
    for(NSInteger index=0;index<dView.progressRateNumber.count;index++)
    {
        UILabel *label = [UILabel new];
        label.textColor = progressRateColor[index];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        label.tag = 0x100+index;
        label.text = @(index).stringValue;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preView?preView.mas_right:self.view);
            make.centerY.equalTo(self.view).offset(-50);
            make.width.equalTo(self.view).multipliedBy(1./dView.progressRateNumber.count);
        }];
        preView = label;
    }
    
    [dView resetProgressRateNumber];
    
    UIButton *randomButton = [UIButton new];
    [randomButton setTitle:@"随机" forState:(UIControlStateNormal)];
    [randomButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:randomButton];
    [randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(50);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(1/3.);
        make.height.mas_equalTo(50);
    }];
    [randomButton addTarget:self action:@selector(resetEvent) forControlEvents:(UIControlEventTouchUpInside)];
}

-(void)resetEvent
{
    NSInteger all = 100;
    NSMutableArray *arr = [NSMutableArray new];
    while (arr.count < (self.dView.progressRateNumber.count-1))
    {
        [arr addObject:@(arc4random()%all)];
        all -= [arr.lastObject integerValue];
    }
    [arr addObject:@(all)];
    self.dView.progressRateNumber = arr;
    [self.dView resetView];
    [self.dView resetProgressRateNumber];
}
-(void)dragView:(HCDragView *)dragView progressRate:(NSArray <NSNumber *>*)progressRate
{
    NSLog(@"%@",progressRate);
    for(NSInteger index=0;index<progressRate.count;index++)
    {
        UILabel *label = [self.view viewWithTag:0x100+index];
        label.text = [NSString stringWithFormat:@"%.0f",[progressRate[index] floatValue]];
    }
}

@end
