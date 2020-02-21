#import <SpriteKit/SpriteKit.h>

@interface GameWonScene : SKScene

@property (nonatomic) BOOL playSound;
@property (nonatomic) NSMutableArray * levels;

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels andPlaySound: (BOOL)playSound;

@end
