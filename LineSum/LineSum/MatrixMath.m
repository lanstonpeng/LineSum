//
//  MatrixMath.m
//  LineSum
//
//  Created by Lanston Peng on 5/7/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MatrixMath.h"

#define RIGHT 1
#define DOWN 2

@interface MatrixMath()

@property (strong,nonatomic)NSArray* matrix;
@property (nonatomic)int result;
@property (nonatomic)int xBoundary;
@property (nonatomic)int yBoundary;
@property (strong,nonatomic)NSMutableArray* stack;
@end

@implementation MatrixMath

-(BOOL)isMatrixValid:(NSArray*)matrix withSum:(int)sum
{
    _matrix = matrix;
    _result = sum;
    _xBoundary  = [matrix[0] count] - 1;
    _yBoundary  = [matrix count] - 1;
    _stack = [[NSMutableArray alloc]init];
    [self dfs4:0 withX:0 withY:0];
    return NO;
}
-(int)dfs4:(int)sum withX:(int)x withY:(int)y{
    
    int currentNum = [_matrix[x][y] integerValue];
    if([_stack containsObject:@(currentNum)]){
        return -1;
    }
    NSLog(@"curr: %d",currentNum);
    sum = currentNum + sum;
    NSLog(@"sum: %d",sum);
    NSLog(@"------------");
    if(sum == _result){
        [_stack addObject:@(currentNum)];
        NSLog(@"yep %@",_stack);
        return 1;
    }
    [_stack addObject:@(currentNum)];
    if(sum > _result){
        [_stack removeObject:[_stack lastObject]];
        return -1;
    }
    //right
    if( ++y <= _yBoundary){
        /*
        if([self dfs4:sum withX:x withY:y] < 0){
            [_stack removeObject:[_stack lastObject]];
            return 1;
        }*/
        [self dfs4:sum withX:x withY:y];
    }
    y--;
    //down
    if( ++x <= _xBoundary){
        /*
        if([self dfs4:sum withX:x withY:y] < 0){
            [_stack removeObject:[_stack lastObject]];
            return 1;
        }*/
        [self dfs4:sum withX:x withY:y];
    }
    x--;
    
    //left
    if(--y >= 0){
        /*
        if([self dfs4:sum withX:x withY:y] < 0){
            [_stack removeObject:[_stack lastObject]];
            return 1;
        }*/
        [self dfs4:sum withX:x withY:y];
    }
    y++;
    
    //up
    if(--x >= 0 ){
        /*
        if([self dfs4:sum withX:x withY:y] < 0){
            [_stack removeObject:[_stack lastObject]];
            return 1;
        }*/
        [self dfs4:sum withX:x withY:y];
    }
    x++;
    [_stack removeObject:[_stack lastObject]];
    return 1;
}

@end