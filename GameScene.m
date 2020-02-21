#import "GameScene.h"
#import "GameLevelScene.h"
#import "GameShape.h"
#import "GameWonScene.h"

// ========= PHYSIC CATEGORY
static const uint32_t ballCategory = 0b1;
static const uint32_t bottomCategory = 0b1 << 1;
static const uint32_t bucketCategory = 0b1 << 2;
// ========= PHYSIC CATEGORY NAME
static NSString * menuCategoryName = @"menu";
static NSString * replayCategoryName = @"replay";
static NSString * ballCategoryName = @"ball";
static NSString * bottomCategoryName = @"bottom";
static NSString * bucketCategoryName = @"bucket";
static NSString * staticCategoryName = @"static";
static NSString * dynamicCategoryName = @"dynamic";
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation GameScene

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels andPlaySound: (BOOL)playSound andLevel: (int)level // ----------------------------------------------------------------------------------------------
{
    self = [super initWithSize: size];
    self.levels = levels;
    self.level = level;
    self.playSound = playSound;
    self.isFingerOnDynamicShape = NO;
    self.didDropBall = NO;
    self.physicsWorld.gravity = CGVectorMake(0.0, -9.81);
    self.physicsWorld.contactDelegate = self;
    
    if(self.playSound)
    {
        SKAudioNode * backgroundMusic = [[SKAudioNode alloc]initWithFileNamed: @"background-music"];
        backgroundMusic.autoplayLooped = YES;
        [self addChild: backgroundMusic];
    }
    
    // Background properties
    SKSpriteNode * background = [SKSpriteNode spriteNodeWithImageNamed: @"background"];
    background.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    background.zPosition = 0.0;
    [background scaleToSize: size];
    [self addChild: background];
    
    // Menu properties
    SKSpriteNode * menu = [SKSpriteNode spriteNodeWithImageNamed: @"menu1x"];
    menu.position = CGPointMake(size.width * 0.2, size.height * 0.9);
    menu.zPosition = 0.1;
    menu.name = menuCategoryName;
    menu.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: menu.size.width * 0.5];
    menu.physicsBody.dynamic = NO;
    [self addChild: menu];
    
    // Replay properties
    SKSpriteNode * replay = [SKSpriteNode spriteNodeWithImageNamed: @"replay1x"];
    replay.position = CGPointMake(size.width * 0.4, size.height * 0.9);
    replay.zPosition = 0.1;
    replay.name = replayCategoryName;
    replay.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: replay.size.width * 0.5];
    replay.physicsBody.dynamic = NO;
    [self addChild: replay];
    
    // Bottom properties
    SKNode * bottom = [SKNode node];
    bottom.zPosition = 0.1;
    bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1.0)];
    bottom.physicsBody.categoryBitMask = bottomCategory;
    [self addChild: bottom];
    
    switch (level)
    {
        case 1:
            [self setLevel1];
            break;
        case 2:
            [self setLevel2];
            break;
        case 3:
            [self setLevel3];
            break;
        case 4:
            [self setLevel4];
            break;
        case 5:
            [self setLevel5];
            break;
        case 6:
            [self setLevel6];
            break;
        case 7:
            [self setLevel7];
            break;
        case 8:
            [self setLevel8];
            break;
        case 9:
            [self setLevel9];
            break;
        case 10:
            [self setLevel10];
            break;
        case 11:
            [self setLevel11];
            break;
        case 12:
            [self setLevel12];
            break;
        case 13:
            [self setLevel13];
            break;
        case 14:
            [self setLevel14];
            break;
        case 15:
            [self setLevel15];
            break;
        case 16:
            [self setLevel16];
            break;
        default:
            break;
    }
    
    return self;
}

- (void)touchesBegan: (NSSet<UITouch *> *)touches withEvent:(UIEvent *)event // ------------------------------------------------------------------------------------------------------------------------------------------
{
    UITouch * touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode: self];
    
    SKPhysicsBody * body = [self.physicsWorld bodyAtPoint: touchLocation]; // Lấy node đang chứa điểm chạm trên scene
    if(body && [body.node.name isEqualToString: menuCategoryName])
    {
        SKAction * actionWait = [SKAction waitForDuration: 0.5];
        SKAction * actionChangeScene = [SKAction runBlock: ^
                                        {
                                            GameLevelScene * gameLevelScene = [[GameLevelScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound];
                                            [self.view presentScene: gameLevelScene];
                                        }];
        [self runAction: [SKAction sequence: @[actionWait, actionChangeScene]]];
    }
    if(body && [body.node.name isEqualToString: replayCategoryName])
    {
        SKAction * actionWait = [SKAction waitForDuration: 0.5];
        SKAction * actionChangeScene = [SKAction runBlock: ^
                                        {
                                            GameScene * gameScene = [[GameScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound andLevel: self.level];
                                            [self.view presentScene: gameScene];
                                        }];
        [self runAction: [SKAction sequence: @[actionWait, actionChangeScene]]];
    }
    if(body && [body.node.name isEqualToString: dynamicCategoryName])
    {
        NSLog(@"Began touch on dynamic shape");
        self.isFingerOnDynamicShape = YES;
    }
    if(body && [body.node.name isEqualToString: ballCategoryName])
    {
        body.dynamic = YES;
        self.didDropBall = YES;
    }
}

- (void)touchesMoved: (NSSet<UITouch *> *)touches withEvent:(UIEvent *)event // -----------------------------------------------------------------------------------------------------------------------------------------
{
    if(self.isFingerOnDynamicShape && self.didDropBall == NO)
    {
        UITouch * touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode: self];
        CGPoint previousLocation = [touch previousLocationInNode: self];
        
        SKSpriteNode * dynamic = (SKSpriteNode *)[self nodeAtPoint: previousLocation]; // Lấy node từ scene
        if([dynamic.name isEqualToString: dynamicCategoryName])
        {
            CGFloat xDynamic = dynamic.position.x + (touchLocation.x - previousLocation.x);
            CGFloat yDynamic = dynamic.position.y + (touchLocation.y - previousLocation.y);
            xDynamic = MAX(xDynamic, dynamic.size.width / 2);
            xDynamic = MIN(xDynamic, self.size.width - dynamic.size.width / 2);
            yDynamic = MAX(yDynamic, dynamic.size.height / 2);
            yDynamic = MIN(yDynamic, self.size.height - dynamic.size.height / 2);
            
            dynamic.position = CGPointMake(xDynamic, yDynamic); // Cập nhật vị trí mới
        }
    }
}

- (void)touchesEnded: (NSSet<UITouch *> *)touches withEvent:(UIEvent *)event // ------------------------------------------------------------------------------------------------------------------------------------------
{
    self.isFingerOnDynamicShape = NO;
}

- (void)didBeginContact: (SKPhysicsContact *)contact // ------------------------------------------------------------------------------------------------------------------------------------------------------------------
{
    SKPhysicsBody * firstBody;
    SKPhysicsBody * secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if(firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory)
        [self didBallContactWithBottom];
    if(firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bucketCategory)
        [self didBallContactWithBucket];
}

- (void)didBallContactWithBottom // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
{
    SKAction * actionWait = [SKAction waitForDuration: 0.5];
    SKAction * actionChangeScene = [SKAction runBlock: ^
                                    {
                                        GameScene * gameScene = [[GameScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound andLevel: self.level];
                                        [self.view presentScene: gameScene];
                                    }];
    [self runAction: [SKAction sequence: @[actionWait, actionChangeScene]]];
}

- (void)didBallContactWithBucket // ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
{
    if(self.level >= 16)
    {
        SKAction * actionWait = [SKAction waitForDuration: 0.5];
        SKAction * actionChangeScene = [SKAction runBlock: ^
                                        {
                                            GameWonScene * gameWonScene = [[GameWonScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound];
                                            [self.view presentScene: gameWonScene];
                                        }];
        [self runAction: [SKAction sequence: @[actionWait, actionChangeScene]]];
    }
    else
    {
        [self.levels replaceObjectAtIndex: self.level withObject: @"YES"];
        SKAction * actionWait = [SKAction waitForDuration: 0.5];
        SKAction * actionChangeScene = [SKAction runBlock: ^
                                        {
                                            GameScene * gameScene = [[GameScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound andLevel: self.level + 1];
                                            [self.view presentScene: gameScene];
                                        }];
        [self runAction: [SKAction sequence: @[actionWait, actionChangeScene]]];
    }
}

- (void)addLeftRightEdgeForBucket: (Bucket *)bucket // -----------------------------------------------------------------------------------------------------------------------------------------------------------------
{
    SKNode * left = [SKNode node];
    left.zPosition = 0.1;
    left.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: CGRectMake(bucket.position.x - bucket.size.width / 2, bucket.position.y - bucket.size.height / 2, 2.0, 2 * (bucket.size.height) / 3)];
    SKNode * right = [SKNode node];
    right.zPosition = 0.1;
    right.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: CGRectMake(bucket.position.x + bucket.size.width / 2 - 2.0, bucket.position.y - bucket.size.height / 2, 2.0, 2 * (bucket.size.height) / 3)];
    [self addChild: left];
    [self addChild: right];
}

- (void)update: (NSTimeInterval)currentTime
{
    SKNode * ball = [self childNodeWithName: ballCategoryName];
    if(ball.position.x < 0.0 || ball.position.x > self.size.width || ball.position.y < 0.0)
    {
        SKAction * actionWait = [SKAction waitForDuration: 0.5];
        SKAction * actionChangeScene = [SKAction runBlock: ^
                                        {
                                            GameScene * gameScene = [[GameScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound andLevel: self.level];
                                            [self.view presentScene: gameScene];
                                        }];
        [self runAction: [SKAction sequence: @[actionWait, actionChangeScene]]];
    }
}
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setLevel1
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    RightTriangle * rt = [[RightTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.5)];
    [self addChild: rt];
}

- (void)setLevel2
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.3)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    LeftTriangle * lt = [[LeftTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.1)];
    RightTriangle * rt = [[RightTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.1)];
    SmallStaticCircle * ssc = [[SmallStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.51, self.size.height * 0.5)];
    [self addChild: lt];
    [self addChild: rt];
    [self addChild: ssc];
}

- (void)setLevel3
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.3)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    Rhombus * rh = [[Rhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.6)];
    StaticRectangle * sr = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.5)];
    SmallStaticCircle * ssc = [[SmallStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.5)];
    Rectangle * r = [[Rectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.3)];
    LeftTriangle * lt = [[LeftTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.1)];
    [self addChild: rh];
    [self addChild: sr];
    [self addChild: ssc];
    [self addChild: r];
    [self addChild: lt];
}

- (void)setLevel4
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    LeftTriangle * lt = [[LeftTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.7)];
    RightTriangle * rt = [[RightTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.55)];
    SmallStaticCircle * ssc = [[SmallStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.21, self.size.height * 0.45)];
    VerticalRectangle * vr = [[VerticalRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.5)];
    BigStaticCircle * bsc = [[BigStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.3)];
    [self addChild: lt];
    [self addChild: rt];
    [self addChild: ssc];
    [self addChild: bsc];
    [self addChild: vr];
}

- (void)setLevel5
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    SmallCircle * sc1 = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.6)];
    SmallCircle * sc2 = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.5)];
    SmallCircle * sc3 = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.4)];
    SmallCircle * sc4 = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.3)];
    [self addChild: sc1];
    [self addChild: sc2];
    [self addChild: sc3];
    [self addChild: sc4];
}

- (void)setLevel6
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRectangle * sr = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.5)];
    RightTriangle * rt = [[RightTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.3)];
    VerticalRectangle * vr = [[VerticalRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.4)];
    [self addChild: sr];
    [self addChild: rt];
    [self addChild: vr];
    
    [sr runAction: [SKAction rotateToAngle: -3600.0 duration: 3600.0]];
}

- (void)setLevel7
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRectangle * sr1 = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.6)];
    StaticRectangle * sr2 = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.3)];
    SmallCircle * sc = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.1)];
    StaticRhombus * srh = [[StaticRhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.3)];
    [self addChild: sr1];
    [self addChild: sr2];
    [self addChild: sc];
    [self addChild: srh];
    
    [sr1 runAction: [SKAction rotateToAngle: 3600.0 duration: 3600.0]];
    [sr2 runAction: [SKAction rotateToAngle: -3600.0 duration: 3600.0]];
}

- (void)setLevel8
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    Rectangle * r1 = [[Rectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.4, self.size.height * 0.7)];
    Rectangle * r2 = [[Rectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.4, self.size.height * 0.6)];
    StaticRectangle * sr = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.2)];
    BigStaticCircle * bsc = [[BigStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.19, self.size.height * 0.4)];
    SmallStaticCircle * ssc = [[SmallStaticCircle alloc]initWithPosition: CGPointMake(bsc.position.x + bsc.size.width - 20.0, self.size.height * 0.4)];
    SmallCircle * sc = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.65)];
    [self addChild: r1];
    [self addChild: r2];
    [self addChild: sr];
    [self addChild: bsc];
    [self addChild: ssc];
    [self addChild: sc];
    
    [sr runAction: [SKAction rotateToAngle: 3600.0 duration: 3600.0]];
}

- (void)setLevel9
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRectangle * sr1 = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.6)];
    StaticRectangle * sr2 = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.35)];
    SmallCircle * sc = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.45)];
    Rhombus * rh = [[Rhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.1)];
    LeftTriangle * lt = [[LeftTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.3)];
    [self addChild: sr1];
    [self addChild: sr2];
    [self addChild: sc];
    [self addChild: rh];
    [self addChild: lt];
    
    [sr1 runAction: [SKAction rotateToAngle: -14400.0 duration: 3600.0]];
}

- (void)setLevel10
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    BigStaticCircle * bsc = [[BigStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.49, self.size.height * 0.5)];
    Rhombus * rh1 = [[Rhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.5)];
    Rhombus * rh2 = [[Rhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.5)];

    [self addChild: bsc];
    [self addChild: rh1];
    [self addChild: rh2];
}

- (void)setLevel11
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRhombus * srh = [[StaticRhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.5)];
    Rectangle * r = [[Rectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.4, self.size.height * 0.2)];
    BigStaticCircle * bsc = [[BigStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.3)];
    [self addChild: srh];
    [self addChild: r];
    [self addChild: bsc];
    
    [srh runAction: [SKAction rotateToAngle: -14400.0 duration: 3600.0]];
}

- (void)setLevel12
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRhombus * srh = [[StaticRhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.6)];
    VerticalRectangle * r = [[VerticalRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.4)];
    BigStaticCircle * bsc = [[BigStaticCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.3)];
    RightTriangle * rt = [[RightTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.6)];
    [self addChild: srh];
    [self addChild: r];
    [self addChild: bsc];
    [self addChild: rt];
    
    [srh runAction: [SKAction rotateToAngle: 7200.0 duration: 3600.0]];
}

- (void)setLevel13
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRectangle * sr = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.5)];
    BigCircle * bc = [[BigCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.4)];
    [self addChild: sr];
    [self addChild: bc];
    
    [sr runAction: [SKAction rotateToAngle: -7200.0 duration: 3600.0]];
}

- (void)setLevel14
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    Rhombus * rh1 = [[Rhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.5)];
    Rhombus * rh2 = [[Rhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.5)];
    StaticRhombus * srh = [[StaticRhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.5)];
    
    [self addChild: rh1];
    [self addChild: rh2];
    [self addChild: srh];
}

- (void)setLevel15
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.8, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRectangle * sr = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.5)];
    VerticalRectangle * vr = [[VerticalRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.2, self.size.height * 0.7)];
    Rhombus * rh = [[Rhombus alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.6)];
    RightTriangle * rt = [[RightTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.5, self.size.height * 0.3)];
    [self addChild: sr];
    [self addChild: vr];
    [self addChild: rh];
    [self addChild: rt];
}

- (void)setLevel16
{
    Ball * ball = [[Ball alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.8)];
    Bucket * bucket = [[Bucket alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.1)];
    [self addLeftRightEdgeForBucket: bucket];
    [self addChild: ball];
    [self addChild: bucket];
    
    StaticRectangle * sr1 = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.7, self.size.height * 0.4)];
    StaticRectangle * sr2 = [[StaticRectangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.6)];
    SmallCircle * sc = [[SmallCircle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.7)];
    LeftTriangle * lt = [[LeftTriangle alloc]initWithPosition: CGPointMake(self.size.width * 0.3, self.size.height * 0.2)];
    [self addChild: sr1];
    [self addChild: sr2];
    [self addChild: sc];
    [self addChild: lt];
    
    [sr1 runAction: [SKAction rotateToAngle: 14400.0 duration: 3600.0]];
}

@end
