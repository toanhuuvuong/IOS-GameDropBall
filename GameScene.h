#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic) int level;
@property (nonatomic) BOOL playSound;
@property (nonatomic, readwrite) NSMutableArray * levels;
@property (nonatomic) BOOL isFingerOnDynamicShape;
@property (nonatomic) BOOL didDropBall;

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels andPlaySound: (BOOL)playSound andLevel: (int)level;

@end
