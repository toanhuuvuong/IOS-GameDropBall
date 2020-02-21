#import "GameShape.h"

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
@implementation Ball

- (id)initWithPosition: (CGPoint)position
{
    // Ball properties
    self = (Ball*)[SKSpriteNode spriteNodeWithImageNamed: @"ball"];
    self.position = position;
    self.zPosition = 0.2;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.size.width * 0.5];
    self.name = ballCategoryName;
    self.physicsBody.categoryBitMask = ballCategory;
    self.physicsBody.contactTestBitMask = bottomCategory | bucketCategory;
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.0; // Độ ma sát khi va chạm (0.0 -> 1.0)
    self.physicsBody.restitution = 0.2; // Độ nảy ra khi va chạm (0.0 -> 1.0)
    self.physicsBody.linearDamping = 0.0; // Độ ma sát không khí (0.0 -> 1.0)
    self.physicsBody.allowsRotation = NO; // Cho phép sự ảnh hưởng của các lực và xung
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation Bucket

- (id)initWithPosition: (CGPoint)position
{
    self = (Bucket *)[SKSpriteNode spriteNodeWithImageNamed: @"bucket"];
    self.position = position;
    self.zPosition = 0.1;
    self.name = bucketCategoryName;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -self.size.width / 3, -self.size.height / 2 + self.size.height / 10);
    CGPathAddLineToPoint(path, NULL, -self.size.width / 3, -self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, self.size.width / 3, -self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, self.size.width / 3, -self.size.height / 2 + self.size.height / 10);
    CGPathCloseSubpath(path);
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: path];
    self.physicsBody.categoryBitMask = bucketCategory;
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation LeftTriangle

- (id)initWithPosition:(CGPoint)position
{
    self = (LeftTriangle *)[SKSpriteNode spriteNodeWithImageNamed: @"left-triangle"];
    self.position = position;
    self.zPosition = 0.2;
    self.name = dynamicCategoryName;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -self.size.width / 2, self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, -self.size.width / 2, -self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, self.size.width / 2, -self.size.height / 2);
    CGPathCloseSubpath(path);
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: path];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation RightTriangle

- (id)initWithPosition:(CGPoint)position
{
    self = (RightTriangle *)[SKSpriteNode spriteNodeWithImageNamed: @"right-triangle"];
    self.position = position;
    self.zPosition = 0.2;
    self.name = dynamicCategoryName;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.size.width / 2, self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, -self.size.width / 2, -self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, self.size.width / 2, -self.size.height / 2);
    CGPathCloseSubpath(path);
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: path];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation BigCircle

- (id)initWithPosition:(CGPoint)position
{
    self = (BigCircle *)[SKSpriteNode spriteNodeWithImageNamed: @"big-circle"];
    self.position = position;
    self.zPosition = 0.2;
    self.name = dynamicCategoryName;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.size.width / 2];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation SmallCircle

- (id)initWithPosition:(CGPoint)position
{
    self = (SmallCircle *)[SKSpriteNode spriteNodeWithImageNamed: @"small-circle"];
    self.position = position;
    self.zPosition = 0.2;
    self.name = dynamicCategoryName;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.size.width / 2];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation Rectangle

- (id)initWithPosition:(CGPoint)position
{
    self = (Rectangle *)[SKSpriteNode spriteNodeWithImageNamed: @"rectangle"];
    self.position = position;
    self.zPosition = 0.2;
    self.name = dynamicCategoryName;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.size];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation VerticalRectangle

- (id)initWithPosition:(CGPoint)position
{
    self = (VerticalRectangle *)[SKSpriteNode spriteNodeWithImageNamed: @"vertical-rectangle"];
    self.position = position;
    self.zPosition = 0.2;
    self.name = dynamicCategoryName;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.size];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation Rhombus

- (id)initWithPosition:(CGPoint)position
{
    self = (Rhombus *)[SKSpriteNode spriteNodeWithImageNamed: @"rhombus"];
    self.position = position;
    self.zPosition = 0.2;
    self.name = dynamicCategoryName;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, -self.size.width / 2, 0.0);
    CGPathAddLineToPoint(path, NULL, 0.0, -self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, self.size.width / 2, 0.0);
    CGPathCloseSubpath(path);
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: path];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation BigStaticCircle

- (id)initWithPosition:(CGPoint)position
{
    self = (BigStaticCircle *)[SKSpriteNode spriteNodeWithImageNamed: @"big-static-circle"];
    self.position = position;
    self.zPosition = 0.1;
    self.name = staticCategoryName;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.size.width / 2];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation SmallStaticCircle

- (id)initWithPosition:(CGPoint)position
{
    self = (SmallStaticCircle *)[SKSpriteNode spriteNodeWithImageNamed: @"small-static-circle"];
    self.position = position;
    self.zPosition = 0.1;
    self.name = staticCategoryName;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.size.width / 2];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation StaticRectangle

- (id)initWithPosition:(CGPoint)position
{
    self = (StaticRectangle *)[SKSpriteNode spriteNodeWithImageNamed: @"static-rectangle"];
    self.position = position;
    self.zPosition = 0.1;
    self.name = staticCategoryName;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.size];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation StaticRhombus

- (id)initWithPosition:(CGPoint)position
{
    self = (StaticRhombus *)[SKSpriteNode spriteNodeWithImageNamed: @"static-rhombus"];
    self.position = position;
    self.zPosition = 0.1;
    self.name = staticCategoryName;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, -self.size.width / 2, 0.0);
    CGPathAddLineToPoint(path, NULL, 0.0, -self.size.height / 2);
    CGPathAddLineToPoint(path, NULL, self.size.width / 2, 0.0);
    CGPathCloseSubpath(path);
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: path];
    self.physicsBody.dynamic = NO;
    self.physicsBody.friction = 0.4;
    self.physicsBody.restitution = 0.1;
    
    return self;
}

@end
