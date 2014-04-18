//
//  CubePath.m
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CubePath.h"

@interface CubePath()
@property (strong,nonatomic)NSMutableArray* cubePathArray;
@end

@implementation CubePath
- (NSMutableArray *)cubePathArray{
    if(!_cubePathArray){
        _cubePathArray = [[NSMutableArray alloc]init];
    }
    return _cubePathArray;
}
-(void)addCubeView:(UIView*)cubeView x:(int)x y:(int)y{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:cubeView forKey:@"cubeview"];
    [dic setObject:[NSNumber numberWithInt:x] forKey:@"pointX"];
    [dic setObject:[NSNumber numberWithInt:y] forKey:@"pointY"];
    [self.cubePathArray addObject:dic];
}
-(void)removeLastCubeView{
    if([_cubePathArray count] > 0){
        [_cubePathArray removeLastObject];
    }
}
@end
