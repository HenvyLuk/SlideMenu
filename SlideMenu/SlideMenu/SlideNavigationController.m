//
//  SlideNavigationController.m
//  SlideMenu
//
//  Created by csh on 16/5/25.
//  Copyright © 2016年 csh. All rights reserved.
//

#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimator.h"
@interface SlideNavigationController ()

@end

@implementation SlideNavigationController

NSString * const SlideNavigationControllerDidOpen = @"SlideNavigationControllerDidOpen";
NSString * const SlideNavigationControllerDidClose = @"SlideNavigationControllerDidClose";
NSString  *const SlideNavigationControllerDidReveal = @"SlideNavigationControllerDidReveal";

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define MENU_SLIDE_ANIMATION_DURATION .3
#define MENU_SLIDE_ANIMATION_OPTION UIViewAnimationOptionCurveEaseOut
#define MENU_QUICK_SLIDE_ANIMATION_DURATION .18
#define MENU_IMAGE @"menu-button"
#define MENU_SHADOW_RADIUS 10
#define MENU_SHADOW_OPACITY 1
#define MENU_DEFAULT_SLIDE_OFFSET 60
#define MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION 1200
#define STATUS_BAR_HEIGHT 20
#define NOTIFICATION_USER_INFO_MENU_LEFT @"left"
#define NOTIFICATION_USER_INFO_MENU_RIGHT @"right"
#define NOTIFICATION_USER_INFO_MENU @"menu"

static SlideNavigationController *singletonInstance;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (SlideNavigationController *)sharedInstance
{
    if (!singletonInstance)
        NSLog(@"SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code");
    
    return singletonInstance;
}

- (id)init
{
    if (self = [super init])
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    if (singletonInstance)
        NSLog(@"Singleton instance already exists. You can only instantiate one instance of SlideNavigationController. This could cause major issues");
    
    singletonInstance = self;
    
}

- (void)toggleLeftMenu
{
    [self toggleMenu:MenuLeft withCompletion:nil];
}

- (void)toggleRightMenu
{
    [self toggleMenu:MenuRight withCompletion:nil];
}
- (void)toggleMenu:(Menu)menu withCompletion:(void (^)())completion
{
    if ([self isMenuOpen])
        [self closeMenuWithCompletion:completion];
    else
        [self openMenu:menu withCompletion:completion];
}
- (void)closeMenuWithCompletion:(void (^)())completion
{
   // [self closeMenuWithDuration:self.menuRevealAnimationDuration andCompletion:completion];
}

- (void)openMenu:(Menu)menu withCompletion:(void (^)())completion
{
    [self openMenu:menu withDuration:self.menuRevealAnimationDuration andCompletion:completion];
}
- (void)openMenu:(Menu)menu withDuration:(float)duration andCompletion:(void (^)())completion
{
    //[self enableTapGestureToCloseMenu:YES];
    
    //[self prepareMenuForReveal:menu];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:self.menuRevealAnimationOption
                     animations:^{
                         CGRect rect = self.view.frame;
                         CGFloat width = self.horizontalSize;
                         rect.origin.x = (menu == MenuLeft) ? (width - self.slideOffset) : ((width - self.slideOffset )* -1);
                         [self moveHorizontallyToLocation:rect.origin.x];
                     }
                     completion:^(BOOL finished) {
                         if (completion)
                             completion();
                         
                         [self postNotificationWithName:SlideNavigationControllerDidOpen forMenu:menu];
                     }];
}

- (void)moveHorizontallyToLocation:(CGFloat)location
{
    CGRect rect = self.view.frame;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    Menu menu = (self.horizontalLocation >= 0 && location >= 0) ? MenuLeft : MenuRight;
    
    if ((location > 0 && self.horizontalLocation <= 0) || (location < 0 && self.horizontalLocation >= 0)) {
        [self postNotificationWithName:SlideNavigationControllerDidReveal forMenu:(location > 0) ? MenuLeft : MenuRight];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        rect.origin.x = location;
        rect.origin.y = 0;
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            rect.origin.x = 0;
            rect.origin.y = (orientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
        }
        else
        {
            rect.origin.x = (orientation == UIInterfaceOrientationPortrait) ? location : location*-1;
            rect.origin.y = 0;
        }
    }
    
    self.view.frame = rect;
    [self updateMenuAnimation:menu];
}
- (void)updateMenuAnimation:(Menu)menu
{
    CGFloat progress = (menu == MenuLeft)
    ? (self.horizontalLocation / (self.horizontalSize - self.slideOffset))
    : (self.horizontalLocation / ((self.horizontalSize - self.slideOffset) * -1));
    
    [self.menuRevealAnimator animateMenu:menu withProgress:progress];
}
- (CGFloat)slideOffset
{
    return (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    ? self.landscapeSlideOffset
    : self.portraitSlideOffset;
}
- (void)postNotificationWithName:(NSString *)name forMenu:(Menu)menu
{
    NSString *menuString = (menu == MenuLeft) ? NOTIFICATION_USER_INFO_MENU_LEFT : NOTIFICATION_USER_INFO_MENU_RIGHT;
    NSDictionary *userInfo = @{ NOTIFICATION_USER_INFO_MENU : menuString };
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}
- (BOOL)isMenuOpen
{
    return (self.horizontalLocation == 0) ? NO : YES;
}
- (CGFloat)horizontalSize
{
    CGRect rect = self.view.frame;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.size.width;
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return rect.size.height;
        }
        else
        {
            return rect.size.width;
        }
    }
}

- (CGFloat)horizontalLocation
{
    CGRect rect = self.view.frame;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.origin.x;
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return (orientation == UIInterfaceOrientationLandscapeRight)
            ? rect.origin.y
            : rect.origin.y*-1;
        }
        else
        {
            return (orientation == UIInterfaceOrientationPortrait)
            ? rect.origin.x
            : rect.origin.x*-1;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
