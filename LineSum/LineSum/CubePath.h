//
//  CubePath.h
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CubePath : NSObject
@property (strong,nonatomic)NSDictionary* lastObject;

-(void)addCubeView:(UIView*)cubeView x:(int)x y:(int)y;
-(void)removeLastCubeView;
@end
