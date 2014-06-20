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
        self.layer.cornerRadius = frame.size.width/2;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor greenColor];
        _numLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_numLabel setText:[NSString stringWithFormat:@"%d",num]];
        [_numLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [_numLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_numLabel];
        self.number = num;
    }
    return self;
}

- (void)setNumber:(int)number {
    _number = number;
    switch (number) {
        case 1:{
            self.backgroundColor =  RGBA(0xcc,0x99,0x99,1.0);
            break;
        }
        case 2:{
            self.backgroundColor =  RGBA(130,232,154,1.0);
            break;
        }
        case 3:{
            self.backgroundColor =  RGBA(154,94,175,1.0);
            break;
        }
        case 4:{
            self.backgroundColor =  RGBA(239,91,76,1.0);
            break;
        }
        case 5:{
            self.backgroundColor =  RGBA(233,217,82,1.0);
            break;
        }
    }
}

@end
