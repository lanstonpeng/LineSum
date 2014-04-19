//
//  ScoreView.m
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ScoreBoardView.h"

@interface ScoreBoardView()
@property (strong,nonatomic)UILabel* scoreLabel;
@end

@implementation ScoreBoardView

-(instancetype)initScoreBoradView:(NSUInteger)targetSum{
    if(self = [super init]){
        self.frame = CGRectMake(120, 50, 50, 40);
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 50, 40)];
        self.scoreLabel.text = [NSString stringWithFormat:@"%d",(int)targetSum];
        [self addSubview:self.scoreLabel];
    }
    return self;
}
-(void)addNum:(NSUInteger)num{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",[self.scoreLabel.text intValue] + num];
}
-(void)minusNum:(NSUInteger)num{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",[self.scoreLabel.text intValue] - num];
}
-(void)resetNum{
    self.scoreLabel.text = @"0";
}

@end
