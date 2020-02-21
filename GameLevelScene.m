#import "GameLevelScene.h"
#import "GameMenuScene.h"
#import "GameScene.h"

static NSString * menuCategoryName = @"menu";
static NSString * menuLabelCategoryName = @"menu-label";

@implementation GameLevelScene

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels andPlaySound: (BOOL)playSound // ------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithSize: size];
    self.levels = levels;
    self.playSound = playSound;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
    // Background properties
    SKSpriteNode * background = [SKSpriteNode spriteNodeWithImageNamed: @"background"];
    background.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    background.zPosition = 0.0;
    [background scaleToSize: size];
    [self addChild: background];
    
    // Menu & menu label properties
    SKSpriteNode * menu = [SKSpriteNode spriteNodeWithImageNamed: @"menu"];
    menu.position = CGPointMake(size.width * 0.5, size.height * 0.9);
    menu.zPosition = 0.1;
    menu.name = menuCategoryName;
    [self addChild: menu];
    SKLabelNode * menuLabel = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
    menuLabel.position = CGPointMake(menu.position.x, menu.position.y - menu.size.height * 0.5 - 50.0);
    menuLabel.zPosition = 0.1;
    menuLabel.name = menuLabelCategoryName;
    menuLabel.text = @"BACK TO MENU";
    menuLabel.fontSize = 20.0;
    menuLabel.fontColor = UIColor.whiteColor;
    [self addChild: menuLabel];
    
    // Level array properties
    int numLevelsOnRow = 4;
    float padding = 20.0;
    float levelWidth = [SKSpriteNode spriteNodeWithImageNamed: @"level-locked"].size.width;
    float xOffset = (self.size.width - (levelWidth * numLevelsOnRow + padding * (numLevelsOnRow - 1))) / 2;
    for(int i = 1; i <= 16; i++)
    {
        NSString * imageNamed = ([levels[i - 1] isEqualToString: @"YES"]) ? [NSString stringWithFormat:@"level%d", i] : @"level-locked";
        SKSpriteNode * level = [SKSpriteNode spriteNodeWithImageNamed: imageNamed];
        level.position = CGPointMake((i - 0.5 - numLevelsOnRow * ((i - 1) / numLevelsOnRow)) * level.size.width + (i - 1 - numLevelsOnRow * ((i - 1) / numLevelsOnRow)) * padding + xOffset, self.size.height * (0.6 - 0.15 * ((i - 1) / numLevelsOnRow)));
        level.zPosition = 0.1;
        level.name = imageNamed;
        [self addChild: level];
    }
    
    return self;
}

- (void)touchesBegan: (NSSet<UITouch *> *)touches withEvent:(UIEvent *)event // -----------------------------------------------------------------------------------------------------------------------------------------
{
    if(self.playSound)
        [self runAction: [SKAction playSoundFileNamed: @"sound-click" waitForCompletion: NO]];
    
    UITouch * touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode: self];
    
    SKNode * node = [self nodeAtPoint: touchLocation];
    if(node && [node.name isEqualToString: menuCategoryName])
    {
        SKAction * actionWait = [SKAction waitForDuration: 0.5];
        SKAction * actionMenuZoomOut = [SKAction runBlock: ^
                                        {
                                            SKLabelNode * menuLabel = (SKLabelNode *)[self childNodeWithName: menuLabelCategoryName];
                                            menuLabel.fontSize *= 1.5;
                                            menuLabel.fontColor = UIColor.yellowColor;
                                        }];
        SKAction * actionChangeScene = [SKAction runBlock: ^
                                        {
                                            GameMenuScene * gameMenuScene = [[GameMenuScene alloc]initWithSize: self.size andLevels: self.levels];
                                            [self.view presentScene: gameMenuScene];
                                        }];
        [((SKSpriteNode *)node) runAction: [SKAction sequence: @[actionMenuZoomOut, actionWait, actionChangeScene]]];
    }
    if(node && [node.name isEqualToString: @"level-locked"] == NO)
    {
        NSUInteger searchLocation = [node.name rangeOfString:@"level"].location;
        if(searchLocation != NSNotFound)
        {
            NSString * levelStr = [node.name substringFromIndex: searchLocation + 5];
            if(levelStr)
            {
                int level = [levelStr intValue];
                if([self.levels[level - 1] isEqualToString: @"YES"])
                {
                    GameScene * gameScene = [[GameScene alloc]initWithSize: self.size andLevels: self.levels andPlaySound: self.playSound andLevel: level];
                    [self.view presentScene: gameScene];
                }
            }
        }
    }
}

@end
