#import <SpriteKit/SpriteKit.h>

@interface GameLevelScene : SKScene

@property (nonatomic) BOOL playSound;
@property (nonatomic, readwrite) NSMutableArray * levels;

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels andPlaySound: (BOOL)playSound;

@end
