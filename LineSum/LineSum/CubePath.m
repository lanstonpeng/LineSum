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
-(void)addCubeEntity:(CubeEntity*)cubeEntity{
    NSLog(@"adding");
    [self.cubePathArray addObject:cubeEntity];
}
-(BOOL)containCubePath:(CubeEntity*)cubeEntity{
    for(int i = 0;i<[self.cubePathArray count];i++){
        if([self isEqualCubeView:self.cubePathArray[i] anotherEntity:cubeEntity]){
            return YES;
        }
    }
    return NO;
}
-(BOOL)isEqualToLastObject:(CubeEntity*)cubeEntity{
    
    if ([_cubePathArray count]>0) {
        CubeEntity* lastObject = [self.cubePathArray lastObject];
        return [self isEqualCubeView:lastObject anotherEntity:cubeEntity];
    }
    return NO;
}
-(void)revertPathAfterCubeView:(CubeEntity*)cubeEntity executeBlokOnRevertedItem:(void (^)(CubeEntity* cubeEntity))executeBlock{
    NSUInteger idx = [self getCubeEntityIdx:cubeEntity];
    for(;idx < [self.cubePathArray count];idx++){
        CubeEntity* lastObject = [self.cubePathArray lastObject];
        executeBlock(lastObject);
        [self.cubePathArray removeLastObject];
    }
}
-(BOOL)isEqualCubeView:(CubeEntity*)cubeEntity1 anotherEntity:(CubeEntity*)cubeEntity2{
    return cubeEntity1.cubeView == cubeEntity2.cubeView && cubeEntity1.x == cubeEntity2.x && cubeEntity2.y == cubeEntity2.y;
}
-(NSUInteger)getCubeEntityIdx:(CubeEntity*)cuebEntity{
    for(int i = 0 ;i<[self.cubePathArray count];i++){
        if( [self isEqualCubeView:self.cubePathArray[i] anotherEntity:cuebEntity])
        {
            return i;
        }
    }
    return NSIntegerMax;
}
-(void)removeLastCubeView{
    if([_cubePathArray count] > 0){
        [_cubePathArray removeLastObject];
    }
}
@end
