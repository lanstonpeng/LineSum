//
//  ScoreView.h
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scoreTargetDelgate <NSObject>

@optional
-(void)onScoreLess;
-(void)onScoreEqual;
-(void)onScoreBigger;
@end



@interface ScoreBoardView : UIView
@property (nonatomic)int targetSum;
-(instancetype)initScoreBoradView:(int)targetSum withDelegate:(id<scoreTargetDelgate>)delegate;
-(void)addNum:(NSUInteger)num;
-(void)minusNum:(NSUInteger)num;
-(void)resetNum;
@end
