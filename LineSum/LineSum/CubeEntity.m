//
//  CubeEntity.m
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CubeEntity.h"

@implementation CubeEntity

-(instancetype)initWithView:(UIView*)cubeView x:(int)x y:(int)y{
    CubeEntity* cubeEntity = [[CubeEntity alloc]init];
    cubeEntity.cubeView = cubeView;
    cubeEntity.x = [NSNumber numberWithInt:x];
    cubeEntity.y = [NSNumber numberWithInt:y];
    return cubeEntity;
}
@end
