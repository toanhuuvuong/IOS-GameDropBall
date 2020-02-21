#import <SpriteKit/SpriteKit.h>

@interface GameMenuScene : SKScene

@property (nonatomic) BOOL playSound;
@property (nonatomic, readwrite) NSMutableArray * levels;

- (id)initWithSize: (CGSize)size andLevels: (NSMutableArray *)levels;

@end
