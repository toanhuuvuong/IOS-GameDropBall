#import "GameViewController.h"
#import "GameMenuScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.ignoresSiblingOrder = YES;
    
    NSMutableArray * levels = [NSMutableArray arrayWithObjects: @"YES", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", nil];
    
    GameMenuScene * gameMenuScene = [[GameMenuScene alloc]initWithSize: skView.bounds.size andLevels: levels];
    gameMenuScene.scaleMode = SKSceneScaleModeAspectFill;
        
    [skView presentScene: gameMenuScene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
