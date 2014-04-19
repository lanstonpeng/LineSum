//
//  ViewController.m
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"

#define GRID_WIDTH 4
#define GRID_HEIGHT 4
#define UP_PADDING 10
#define CUBE_WIDTH 80
#define CUBE_LINE_COUNT 4
#define CUBE_COUNT 3

@interface ViewController ()<scoreTargetDelgate>

@property (strong,nonatomic)NSArray* sequence;
@property (nonatomic)NSUInteger sum;
@property (strong,nonatomic)NSMutableArray* cubeViews;
@property (strong,nonatomic)NSMutableArray* usedIndexArray;
@property (strong,nonatomic)NSMutableArray* occupiedArray;
@property (strong,nonatomic)NSMutableArray* occupiedCubeViewArray;
@property (strong,nonatomic)UIView* containerView;
@property (strong,nonatomic)CubePath* cubePath;
@property (strong,nonatomic)UIButton* restartBtn;
@property (strong,nonatomic)ScoreBoardView* scoreBoardView;
@property (strong,nonatomic)UILabel* sumLabel;
@end


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
- (NSMutableArray *)occupiedCubeViewArray{
    if(!_occupiedCubeViewArray){
        _occupiedCubeViewArray = [[NSMutableArray alloc]init];
    }
    return _occupiedCubeViewArray;
}
-(CubePath*)cubePath{
    if(!_cubePath){
        _cubePath = [[CubePath alloc]init];
    }
    return _cubePath;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary* dic = [Util generateNumbers:CUBE_COUNT];
    self.sequence = [dic objectForKey:@"sequence"];
    self.sum = [(NSNumber*)[dic objectForKey:@"sum"] integerValue];
    [self initGameUI];
    
    //Text Label
    self.sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 120, 40)];
    self.sumLabel.text = [[dic objectForKey:@"sum"] stringValue];
    [self.view addSubview:self.sumLabel];
    
    [self generateGrid:self.sequence];
    [self lineUpSolutionPath:self.sequence];
}
-(void)handlePan:(UIPanGestureRecognizer *)sender
{
    //Alert View will trigger pan gesture of such state
    if(sender.state == UIGestureRecognizerStateCancelled){
        return;
    }
    double pointerX = [sender locationInView:self.containerView].x;
    double pointerY = [sender locationInView:self.containerView].y - UP_PADDING;
    
    int x =  pointerX / (GRID_WIDTH * CUBE_WIDTH ) * GRID_WIDTH;
    int y = pointerY / (GRID_HEIGHT * CUBE_WIDTH) * GRID_HEIGHT;
    
    int idx =(x+ 4 * y + 1);
    UIView* currentView =[self.view viewWithTag:idx];
    __weak typeof(self) weakSelf = self;
    CubeEntity* cubeEntity = [[CubeEntity alloc]initWithView:currentView x:x y:y];
    
    //Things to Do
    //record the cube path so that we can change the status while users moving back
    //while it move inside the cube ,prevent it from running the logic again
    //the first time moving into the current view
    if(![self.cubePath isEqualToLastObject:cubeEntity]){
        int num = [cubeEntity.score intValue];
        if(![self.cubePath containCubePath:cubeEntity]){
            [cubeEntity.cubeView setBackgroundColor:[UIColor whiteColor]];
            [self.scoreBoardView addNum:num];
            [self.cubePath addCubeEntity:cubeEntity];
        }
        //if the view is already in the path,we revert the path
        else{
           [_cubePath revertPathAfterCubeView:cubeEntity executeBlokOnRevertedItem:^(CubeEntity *cubeEntity) {
               [cubeEntity.cubeView setBackgroundColor:[Util generateColor]];
               [weakSelf.scoreBoardView minusNum:[cubeEntity.score intValue]];
           }];
        }
    }
    else if(sender.state == UIGestureRecognizerStateEnded){
        if([self.scoreBoardView getCurrentState] == LESS){
            NSLog(@"ready to end pan in less mode");
            
            NSLog(@"count:%d",[self.cubePath.cubePathArray count]);
            CubeEntity* firstEntity = [self.cubePath.cubePathArray firstObject];
           [_cubePath revertPathAfterCubeView:firstEntity executeBlokOnRevertedItem:^(CubeEntity *cubeEntity) {
               [cubeEntity.cubeView setBackgroundColor:[Util generateColor]];
               [weakSelf.scoreBoardView minusNum:[cubeEntity.score intValue]];
           }];
           [self.occupiedArray removeAllObjects];
            
        }
    }
    
}
- (UIView*)generateCube:(CGRect)frame withNum:(id)currentNum{
    UIView* cubeView = [[UIView alloc]initWithFrame:frame];
    [cubeView setBackgroundColor:[Util generateColor]];
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
        [self.containerView addSubview:cubeView];
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
//        NSLog(@"choosing direction %@",avaiable[directionIdx]);
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
            if([deprecated intValue] > -1){
                [avaiable addObject:deprecated];
            }
            deprecated = avaiable[directionIdx];
            [avaiable removeObject:avaiable[directionIdx]];
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
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touch end");
//}
-(void)initGameUI{
    
    self.scoreBoardView = [[ScoreBoardView alloc]initScoreBoradView:(int)_sum
                                                       withDelegate:self];
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    self.restartBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 50, 100, 40)];
    [self.restartBtn setTitle:@"Restart" forState:UIControlStateNormal];
    self.restartBtn.backgroundColor = [Util generateColor];
    self.scoreBoardView.backgroundColor = [Util generateColor];
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.scoreBoardView];
    [self.view addSubview:self.restartBtn];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:1];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(restartGame)];
    [self.restartBtn addGestureRecognizer:tapGesture];
    [self.view addGestureRecognizer:panGesture];
}
-(void)restartGame
{
    NSDictionary* dic = [Util generateNumbers:CUBE_COUNT];
    self.sequence = [dic objectForKey:@"sequence"];
    self.sum = [(NSNumber*)[dic objectForKey:@"sum"] integerValue];
    self.sumLabel.text = [[dic objectForKey:@"sum"] stringValue];
    self.scoreBoardView.targetSum = (int)self.sum;
    
    [self.containerView removeFromSuperview];
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    [self.view addSubview:self.containerView];
    
    [self.occupiedArray removeAllObjects];
    
    [self generateGrid:self.sequence];
    [self lineUpSolutionPath:self.sequence];
    [self.scoreBoardView resetNum];
}

#pragma ScoreBoard delegate
- (void)onScoreBigger{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"OOps"
                                                      message:@"Too Big Buddy"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    [self restartGame];
}
- (void)onScoreEqual{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Yep"
                                                      message:@"You got it"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    [self restartGame];
}
@end
