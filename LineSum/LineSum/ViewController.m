//
//  ViewController.m
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong,nonatomic)NSArray* sequence;
@property (nonatomic)NSUInteger sum;
@property (strong,nonatomic)NSMutableArray* cubeViews;
@property (strong,nonatomic)UILabel* currentSum;
@property (strong,nonatomic)NSMutableArray* usedIndexArray;
@property (strong,nonatomic)NSMutableArray* occupiedArray;
@end


#define GRID_WIDTH 4
#define GRID_HEIGHT 5
#define UP_PADDING 100
#define CUBE_WIDTH 80
#define CUBE_LINE_COUNT 4
#define LUCKY_NUM 806
#define CUBE_COUNT 4
@implementation ViewController

- (NSMutableArray *)usedIndexArray{
    if(!_usedIndexArray){
        _usedIndexArray = [[NSMutableArray alloc]init];
    }
    return  _usedIndexArray;
}
- (NSMutableArray *)occupiedArray{
    if(!_occupiedArray){
        _occupiedArray = [[NSMutableArray alloc]init];
    }
    return _occupiedArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDictionary* dic = [Util generateNumbers:CUBE_COUNT];
    self.sequence = [dic objectForKey:@"sequence"];
    self.sum = (NSUInteger)[dic objectForKey:@"sum"];
    UILabel* sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 120, 40)];
    sumLabel.text = [[dic objectForKey:@"sum"] stringValue];
    self.currentSum = [[UILabel alloc]initWithFrame:CGRectMake(150, 50, 50, 40 )];
    [self.currentSum setBackgroundColor:[Util randomColor]];
    self.currentSum.text = @"0";
    /*
    for(;i< [self.sequence count]; i++){
        UIView* cubeView =[self generateCube:CGRectMake( i * 80 % 320, UP_PADDING + (i / 4 ) * 80, 80, 80) withNum:self.sequence[i]];
        [self.view addSubview:cubeView];
    }
     */
    [self generateGrid:self.sequence];
    [self.view addSubview:sumLabel];
    [self.view addSubview:self.currentSum];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
    [self lineUpSolutionPath:self.sequence];
}
- (void)handleTap:sender
{
    NSLog(@"start taping");
}
-(void)handlePan:(UIPanGestureRecognizer *)sender
{
    //NSLog(@"start paning x %f",[sender translationInView:self.view].x );
    
    double pointerX = [sender locationInView:self.view].x;
    double pointerY = [sender locationInView:self.view].y - UP_PADDING;
    
    int x =  pointerX / (GRID_WIDTH * CUBE_WIDTH ) * GRID_WIDTH;
    int y = pointerY / (GRID_HEIGHT * CUBE_WIDTH) * GRID_HEIGHT;
    
    int idx =(x+ 4 * y + 1);
    
    if(![self.usedIndexArray containsObject:[NSNumber numberWithInt:idx ]]){
        [self.usedIndexArray addObject:[NSNumber numberWithInt:idx ]];
        UIView* currentView =[self.view viewWithTag:idx];
        UILabel* numLabel = (UILabel*)[currentView viewWithTag:LUCKY_NUM];
        int num = [numLabel.text intValue];
    //    NSLog(@"%d %d",x,y);
    //    NSLog(@"paning on %@", [self.view viewWithTag:(x+ 4 * y + 1)]);
        [currentView setBackgroundColor:[UIColor whiteColor]];
        self.currentSum.text = [NSString stringWithFormat:@"%d",[self.currentSum.text intValue] + num];
    }
    
}
- (UIView*)generateCube:(CGRect)frame withNum:(id)currentNum{
    UIView* cubeView = [[UIView alloc]initWithFrame:frame];
    [cubeView setBackgroundColor:[Util randomColor]];
    NSNumber* num = currentNum;
    UILabel* numLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 50, 50)];
    numLabel.text = [NSString stringWithFormat:@"%d",[num intValue]];
    [numLabel setTag:LUCKY_NUM];
    [cubeView addSubview:numLabel];
    return cubeView;
}
- (void)generateGrid:(NSArray*)sequence{
    int i = 0;
    for(;i< GRID_WIDTH * GRID_HEIGHT; i++){
        UIView* cubeView =[self generateCube:CGRectMake( i * CUBE_WIDTH % (int)IPHONE_SCREEN_WIDTH, UP_PADDING + (i / CUBE_LINE_COUNT) * CUBE_WIDTH, CUBE_WIDTH, CUBE_WIDTH) withNum:[NSNumber numberWithInt:i ]];
        [cubeView setTag:i+1];
        [self.view addSubview:cubeView];
    }
}
- (void)placeAValideCubeView:(int)x y:(int)y withSequenceIdx:(NSUInteger)index
{
    int idx = [self getIndex:x y:y];
    UIView* currentView =[self.view viewWithTag:idx];
    UILabel* numLabel = (UILabel*)[currentView viewWithTag:LUCKY_NUM];
    NSNumber* number = self.sequence[index];
    numLabel.text = [ NSString stringWithFormat:@"%d", [number intValue] ];
    [currentView setBackgroundColor:[UIColor redColor]];
}
- (void)lineUpSolutionPath:(NSArray*)sequence
{
    int x = arc4random() % 4;
    int y = arc4random() % 4;
    BOOL hasChanged = NO;
    NSMutableArray* avaiable = [[NSMutableArray alloc]initWithArray:@[@0,@1,@2,@3]];
    NSNumber* deprecated = @-1;
    //[self placeAValideCubeView:x y:y withSequenceIdx:0];
    for(int i = 0;i < [sequence count];i++){
        hasChanged = NO;
        int directionIdx = arc4random() % [avaiable count];
        NSLog(@"choosing direction %@",avaiable[directionIdx]);
        switch ([avaiable[directionIdx]intValue]) {
            //UP
            case 0:{
                y--;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    y++;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            //DOWN
            case 1:{
                y++;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    y--;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            //RIGHT
            case 2:{
                x++;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    x--;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            //LEFT
            case 3:{
                x--;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    x++;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            default:
                break;
        }
        if(hasChanged){
            NSLog(@"deprecated :%@",deprecated);
            if([deprecated intValue] > -1){
                [avaiable addObject:deprecated];
            }
            deprecated = avaiable[directionIdx];
            [avaiable removeObject:avaiable[directionIdx]];
            NSLog(@"After removing %@",avaiable );
            NSLog(@"placing the value: %@",self.sequence[i]);
            NSLog(@"===========");
            [self.occupiedArray addObject:@[[NSNumber numberWithInt:x],[NSNumber numberWithInt:y]]];
            [self placeAValideCubeView:x y:y withSequenceIdx:i];
        }
    }
}
- (int)getIndex:(int)x y:(int)y
{
    return x + y * 4 + 1;
}
- (BOOL)isValidCoordinate:(int)x y:(int)y
{
    int boundaryX = 3;
    int boundaryY = 3;
    return (x >= 0 && y>=0 && x<= boundaryX && y<=boundaryY) && ![self isOccupied:x y:y];
}
- (BOOL)isOccupied:(int)x y:(int)y
{
    for(int i = 0 ;i < [self.occupiedArray count]; i++)
    {
        if([self.occupiedArray[i][0] intValue] == x &&[self.occupiedArray[i][1] intValue] == y)
        {
            return YES;
        }
    }
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
