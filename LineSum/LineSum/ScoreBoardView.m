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
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 120, 40)];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
