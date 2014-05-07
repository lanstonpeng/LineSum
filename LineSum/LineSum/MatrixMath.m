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

-(void)printResult:(NSArray*)result
{
    int x;
    int y;
    NSString* item;
    NSArray* temp;
    for(int i = 0 ;i < [result count] ; i++){
        item = result[i];
        temp = [item componentsSeparatedByString:@":"];
        x = [temp[0] integerValue];
        y = [temp[1] integerValue];
        NSLog(@"%d",[_matrix[x][y] integerValue]);
    }
}
/**
 *  DFS for 4 directions
 *
 *  @param sum current sum of numberes
 *  @param x   literally
 *  @param y   literally
 *
 *  @return flag(not used here)
 */
-(int)dfs4:(int)sum withX:(int)x withY:(int)y{
    
    int currentNum = [_matrix[x][y] integerValue];
    NSString* numStr = [NSString stringWithFormat:@"%d:%d",x,y];
    if([_stack containsObject:numStr]){
        return -1;
    }
    sum = currentNum + sum;
    if(sum == _result){
        [_stack addObject:numStr];
        [self printResult:_stack];
        return 1;
    }
    [_stack addObject:numStr];
    if(sum > _result){
        [_stack removeObject:[_stack lastObject]];
        return -1;
    }
    //right
    if( ++y <= _yBoundary){
        [self dfs4:sum withX:x withY:y];
    }
    y--;
    //down
    if( ++x <= _xBoundary){
        [self dfs4:sum withX:x withY:y];
    }
    x--;
    
    //left
    if(--y >= 0){
        [self dfs4:sum withX:x withY:y];
    }
    y++;
    
    //up
    if(--x >= 0 ){
        [self dfs4:sum withX:x withY:y];
    }
    x++;
    [_stack removeObject:[_stack lastObject]];
    return 1;
}

@end