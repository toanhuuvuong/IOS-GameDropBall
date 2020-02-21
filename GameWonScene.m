#import "GameWonScene.h"
#import "GameMenuScene.h"

static NSString * menuCategoryName = @"menu";
static NSString * menuLabelCategoryName = @"menu-label";

@implementation GameWonScene

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels andPlaySound: (BOOL)playSound // --------------------------------------------------------------------------------------------------------------------
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
    
    // Message label properties
    SKLabelNode * messageLabel = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
    messageLabel.position = CGPointMake(size.width * 0.5, size.height * 0.6);
    messageLabel.zPosition = 0.1;
    messageLabel.text = @"YOU WON!";
    messageLabel.fontSize = 60.0;
    messageLabel.fontColor = UIColor.whiteColor;
    [self addChild: messageLabel];
    
    // Menu & menu label properties
    SKSpriteNode * menu = [SKSpriteNode spriteNodeWithImageNamed: @"menu"];
    menu.position = CGPointMake(size.width * 0.5, size.height * 0.4);
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
}

@end
