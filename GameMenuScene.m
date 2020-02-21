#import "GameMenuScene.h"
#import "GameLevelScene.h"

static NSString * soundCategoryName = @"sound";
static NSString * playCategoryName = @"play";
static NSString * soundLabelCategoryName = @"sound-label";
static NSString * playLabelCategoryName = @"play-label";

@implementation GameMenuScene

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels // -------------------------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithSize: size];
    self.levels = levels;
    self.playSound = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
    // Background properties
    SKSpriteNode * background = [SKSpriteNode spriteNodeWithImageNamed: @"background"];
    background.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    background.zPosition = 0.0;
    [background scaleToSize: size];
    [self addChild: background];
    
    // Sound & sound label properties
    SKSpriteNode * sound = [SKSpriteNode spriteNodeWithImageNamed: @"sound-on"];
    sound.position = CGPointMake(size.width * 0.8, size.height * 0.9);
    sound.zPosition = 0.1;
    sound.name = soundCategoryName;
    [self addChild: sound];
    SKLabelNode * soundLabel = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
    soundLabel.position = CGPointMake(sound.position.x, sound.position.y - sound.size.height * 0.5 - 40.0);
    soundLabel.zPosition = 0.1;
    soundLabel.name = soundLabelCategoryName;
    soundLabel.text = @"Sound on";
    soundLabel.fontSize = 20.0;
    soundLabel.fontColor = UIColor.whiteColor;
    [self addChild: soundLabel];
    
    // Play & play label properties
    SKSpriteNode * play = [SKSpriteNode spriteNodeWithImageNamed: @"play"];
    play.position = CGPointMake(size.width * 0.5, size.height * 0.3);
    play.zPosition = 0.1;
    play.name = playCategoryName;
    [self addChild: play];
    SKLabelNode * playLabel = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
    playLabel.position = CGPointMake(play.position.x, play.position.y - play.size.height * 0.5 - 60.0);
    playLabel.zPosition = 0.1;
    playLabel.name = playLabelCategoryName;
    playLabel.text = @"PLAY NOW!";
    playLabel.fontSize = 30.0;
    playLabel.fontColor = UIColor.whiteColor;
    [self addChild: playLabel];
    
    // Game symbol & game name label properties
    SKSpriteNode * gameSymbol = [SKSpriteNode spriteNodeWithImageNamed: @"game-symbol"];
    gameSymbol.position = CGPointMake(size.width * 0.5, size.height * 0.5);
    gameSymbol.zPosition = 0.1;
    [self addChild: gameSymbol];
    SKLabelNode * gameNameLabel = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
    gameNameLabel.position = CGPointMake(gameSymbol.position.x, gameSymbol.position.y + gameSymbol.size.height * 0.5 + 80.0);
    gameNameLabel.zPosition = 0.1;
    gameNameLabel.text = @"DD-BALL";
    gameNameLabel.fontSize = 60.0;
    gameNameLabel.fontColor = UIColor.whiteColor;
    [self addChild: gameNameLabel];
    
    return self;
}

- (void)touchesBegan: (NSSet<UITouch *> *)touches withEvent:(UIEvent *)event // -----------------------------------------------------------------------------------------------------------------------------------------
{
    if(self.playSound)
        [self runAction: [SKAction playSoundFileNamed: @"sound-click" waitForCompletion: NO]];
    
    UITouch * touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode: self];
    
    SKNode * node = [self nodeAtPoint: touchLocation];
    if(node && [node.name isEqualToString: soundCategoryName])
    {
        if(self.playSound)
        {
            self.playSound = NO;
            ((SKSpriteNode *)node).texture = [SKTexture textureWithImageNamed: @"sound-off"];
            SKLabelNode * soundLabel = (SKLabelNode *)[self childNodeWithName: soundLabelCategoryName];
            soundLabel.text = @"Sound off";
        }
        else
        {
            self.playSound = YES;
            ((SKSpriteNode *)node).texture = [SKTexture textureWithImageNamed: @"sound-on"];
            SKLabelNode * soundLabel = (SKLabelNode *)[self childNodeWithName: soundLabelCategoryName];
            soundLabel.text = @"Sound on";
        }
    }
    if(node && [node.name isEqualToString: playCategoryName])
    {
        SKAction * actionWait = [SKAction waitForDuration: 0.5];
        SKAction * actionPlayZoomOut = [SKAction runBlock: ^
                                        {
                                            SKLabelNode * playLabel = (SKLabelNode *)[self childNodeWithName: playLabelCategoryName];
                                            playLabel.fontSize *= 1.5;
                                            playLabel.fontColor = UIColor.yellowColor;
                                        }];
        SKAction * actionChangeScene = [SKAction runBlock: ^
                                       {
                                           GameLevelScene * gameLevelScene = [[GameLevelScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound];
                                           [self.view presentScene: gameLevelScene];
                                       }];
        [((SKSpriteNode *)node) runAction: [SKAction sequence: @[actionPlayZoomOut, actionWait, actionChangeScene]]];
    }
}

@end
