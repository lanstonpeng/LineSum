//
//  GameBoardCell.m
//  LineSum
//
//  Created by Sun Xi on 5/9/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "GameBoardCell.h"
@import CoreGraphics;

@interface GameBoardCell()

@property (strong, nonatomic) UILabel* numLabel;

@end

@implementation GameBoardCell

- (id)initWithFrame:(CGRect)frame andNum:(int)num
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _number = num;
        self.layer.cornerRadius = frame.size.width/2;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor greenColor];
        _numLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setText:[NSString stringWithFormat:@"%d",num]];
        [_numLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [_numLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_numLabel];
    }
    return self;
}

@end
