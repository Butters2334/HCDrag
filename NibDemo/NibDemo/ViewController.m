//
//  ViewController.m
//  NibDemo
//
//  Created by ac on 2019/12/14.
//  Copyright © 2019 ancc. All rights reserved.
//

#import "ViewController.h"
#import "HCDragView.h"

@interface ViewController ()<HCDragViewDelegate>
@property (nonatomic,weak)IBOutlet HCDragView *dView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0x2f/255. green:0x28/255. blue:0x49/255. alpha:1];
    
    CGFloat appWidth  = [UIScreen mainScreen].bounds.size.width;
    CGFloat appHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.dView.delegate           = self;
    self.dView.progressRateNumber = @[@10,@10,@30];
    self.dView.progressRateColor  = @[[UIColor blueColor],[UIColor greenColor],[UIColor redColor]];;
    [self.dView resetView];
    
    UIView *preView = nil;
    for(NSInteger index=0;index<self.dView.progressRateNumber.count;index++)
    {
        UILabel *label      = [UILabel new];
        label.textColor     = self.dView.progressRateColor[index];
        label.textAlignment = NSTextAlignmentCenter;
        label.font          = [UIFont systemFontOfSize:30];
        label.tag           = 0x100+index;
        label.text          = @(index).stringValue;
        [self.view addSubview:label];
        label.frame         = CGRectMake(preView?(preView.frame.origin.x+preView.frame.size.width):0, 0, appWidth/self.dView.progressRateNumber.count, 50);
        label.center        = CGPointMake(label.center.x, appHeight/2. - 50.);
        preView = label;
    }
    
    [self.dView resetProgressRateNumber];
    
    UIButton *randomButton = [UIButton new];
    [randomButton setTitle:@"随机" forState:(UIControlStateNormal)];
    [randomButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:randomButton];
    randomButton.frame     = CGRectMake(0, 0, appWidth/3., 50);
    randomButton.center    = CGPointMake(appWidth/2., appHeight/2. + 50.);
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
