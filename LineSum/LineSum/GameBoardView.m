//
//  GameBoardView.m
//  LineSum
//
//  Created by Sun Xi on 5/9/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "GameBoardView.h"
#import "GameBoardCell.h"
#import "MatrixMath.h"
@import CoreGraphics;

@interface GameBoardView()

@property (strong, nonatomic) NSMutableArray* selectedCell;

@property (nonatomic) CGPoint movePoint;

@property (nonatomic, strong) NSMutableArray* posArray;

@end

@implementation GameBoardView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setMultipleTouchEnabled:NO];
        _selectedCell = [NSMutableArray new];
        _posArray = [NSMutableArray new];
        [self initNumbers];
    }
    return self;
}

- (void)initNumbers {
    for (int i = 0; i < 5; i++) {
        for(int j = 0; j < 5; j++) {
            GameBoardCell* view = [[GameBoardCell alloc] initWithFrame:CGRectMake(0, 0, 50, 50) andNum:(rand()%4+1)];
            view.tag = i*5 + j + 1;
            CGPoint center = CGPointMake(40 + j*60, 40+i*60);
            _posArray[i*5 + j] = [NSValue valueWithCGPoint:center];
            [view setCenter:center];
            [self addSubview:view];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint pos = [touch locationInView:self];
    UIView* view = [self hitTest:pos withEvent:nil];
    if ([view isKindOfClass:[GameBoardCell class]]) {
        GameBoardCell* cell = (GameBoardCell*)view;
        [_selectedCell addObject:cell];
        //add effect
        [self addEffectToView:cell];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    _movePoint = [touch locationInView:self];
    UIView* view = [self hitTest:_movePoint withEvent:nil];
    if ([view isKindOfClass:[GameBoardCell class]]) {
        GameBoardCell* cell = (GameBoardCell*)view;
        GameBoardCell* preCell = [_selectedCell lastObject];
        if ([self view:cell.tag isNearby:preCell.tag]) {
            if ([_selectedCell containsObject:cell]) {
                if([_selectedCell indexOfObject:preCell] -[_selectedCell indexOfObject:cell] == 1) {
                    [_selectedCell removeLastObject];
                }
            } else {
                if ([self currectNum] + cell.number <= 10) {
                    [_selectedCell addObject:cell];
                    [self addEffectToView:cell];
                }
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self currectNum] == 10) {
        [self relayoutCells];
        NSMutableArray* array = [NSMutableArray new];
        [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
            if ([view isKindOfClass:[GameBoardCell class]]) {
                GameBoardCell* cell = (GameBoardCell*)view;
                [array addObject:@(cell.number)];
            }
        }];
        MatrixMath* matrixMath = [[MatrixMath alloc]initWithArray:array andSize:CGSizeMake(5, 5)];
        if ([matrixMath isSumExist:10]) {
            NSLog(@"%d",matrixMath.result.count);
        }
    }
    [_selectedCell removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_selectedCell removeAllObjects];
    [self setNeedsDisplay];
}

- (BOOL)view:(int)tag1 isNearby:(int)tag2 {
    if ( abs(tag1-tag2) == 5) {
        return YES;
    }
    if (abs(tag1-tag2) == 1) {
        if ((tag1%5)*(tag2%5) == 0 && (tag2%5+tag1%5 == 1)) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (int)currectNum {
    __block int sum = 0;
    [_selectedCell enumerateObjectsUsingBlock:^(GameBoardCell* cell, NSUInteger idx, BOOL *stop) {
        sum += cell.number;
    }];
    return sum;
}

- (void)addEffectToView:(GameBoardCell*)view {
    UIView* effectView = [[UIView alloc] initWithFrame:view.frame];
    effectView.layer.cornerRadius = view.layer.cornerRadius;
    [effectView setBackgroundColor:view.backgroundColor];
    effectView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [effectView setClipsToBounds:YES];
    [self addSubview:effectView];
    [UIView animateWithDuration:0.5f animations:^{
        effectView.transform = CGAffineTransformMakeScale(2, 2);
        effectView.alpha = 0;
    } completion:^(BOOL finished) {
        [effectView removeFromSuperview];
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    if (_selectedCell.count) {
        CGContextRef ref = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ref, 8.0);
        CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
        CGPoint point[_selectedCell.count+1];
        for (int i = 0; i < _selectedCell.count; i++) {
            UIView* cell = _selectedCell[i];
            point[i] = cell.center;
        }
        point[_selectedCell.count] = _movePoint;
        if ([self currectNum] == 10) {
            CGContextAddLines(ref, point, _selectedCell.count);
        } else {
            CGContextAddLines(ref, point, _selectedCell.count+1);
        }
        CGContextStrokePath(ref);
    }
}

- (void)relayoutCells {
    
    NSMutableDictionary* moveDict = [NSMutableDictionary new];
    NSMutableSet* addArray = [NSMutableSet new];
    for (int posx = 0; posx < 5; posx++) {
        int delIdx = 0;
        for (int posy = 4; posy >= 0; posy--) {
            int tag = posx+posy*5+1;
            GameBoardCell* cell = (GameBoardCell*)[self viewWithTag:tag];
            if ([_selectedCell containsObject:cell]) {
                int desTag = delIdx*5 + 1 + posx ;
                [addArray addObject:@(desTag)];
                delIdx++;
            } else {
                int desTag = (posy+delIdx)*5 + 1 + posx;
                if (desTag != tag) {
                    [moveDict setObject:@(desTag) forKey:@(tag)];
                }
            }
        }
    }
    
    [_selectedCell enumerateObjectsUsingBlock:^(GameBoardCell* cell, NSUInteger idx, BOOL *stop) {
        [cell removeFromSuperview];
    }];
    
    [moveDict enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, NSNumber* obj, BOOL *stop) {
        GameBoardCell* moveCell = (GameBoardCell*)[self viewWithTag:key.intValue];
        moveCell.tag = obj.intValue;
    }];
    
    [addArray enumerateObjectsUsingBlock:^(NSNumber* obj, BOOL *stop) {
        GameBoardCell* cell = [[GameBoardCell alloc] initWithFrame:CGRectMake(0, 0, 50, 50) andNum:(rand()%4+1)];
        [cell setTag:obj.intValue];
        NSValue* value = _posArray[obj.intValue-1];
        CGPoint desPos = [value CGPointValue];
        cell.center = CGPointMake(desPos.x, -25);
        [self addSubview:cell];
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        [moveDict enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, NSNumber* obj, BOOL *stop) {
            GameBoardCell* moveCell = (GameBoardCell*)[self viewWithTag:obj.intValue];
            NSValue* value = _posArray[obj.intValue-1];
            CGPoint desPos = [value CGPointValue];
            moveCell.center = desPos;
        }];
        
        [addArray enumerateObjectsUsingBlock:^(NSNumber* obj, BOOL *stop) {
            NSValue* value = _posArray[obj.intValue-1];
            CGPoint desPos = [value CGPointValue];
            GameBoardCell* addCell = (GameBoardCell*)[self viewWithTag:obj.intValue];
            addCell.center = desPos;
        }];

    }];
}


@end
