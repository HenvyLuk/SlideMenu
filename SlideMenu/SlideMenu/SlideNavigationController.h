//
//  SlideNavigationController.h
//  SlideMenu
//
//  Created by csh on 16/5/25.
//  Copyright © 2016年 csh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@protocol SlideNavigationControllerDelegate <NSObject>
@optional
- (BOOL)slideNavigationControllerShouldDisplayRightMenu;
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu;
@end

typedef enum{
    MenuLeft = 1,
    MenuRight = 2
}Menu;
@protocol SlideNavigationContorllerAnimator;

@interface SlideNavigationController : UINavigationController <UINavigationControllerDelegate>

extern NSString  *const SlideNavigationControllerDidOpen;
extern NSString  *const SlideNavigationControllerDidClose;
extern NSString  *const SlideNavigationControllerDidReveal;

@property (nonatomic, strong) UIViewController *rightMenu;
@property (nonatomic, strong) UIViewController *leftMenu;
@property (nonatomic, assign) Menu lastRevealedMenu;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, assign) CGFloat menuRevealAnimationDuration;
@property (nonatomic, assign) UIViewAnimationOptions menuRevealAnimationOption;
@property (nonatomic, assign) CGFloat landscapeSlideOffset;
@property (nonatomic, assign) CGFloat portraitSlideOffset;
@property (nonatomic, strong) id <SlideNavigationContorllerAnimator> menuRevealAnimator;
@property (nonatomic, assign) BOOL avoidSwitchingToSameClassViewController;
@property (nonatomic, assign) BOOL menuNeedsLayout;
@property (nonatomic, assign) BOOL enableSwipeGesture;
@property (nonatomic, assign) BOOL enableShadow;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint draggingPoint;
@property (nonatomic, assign) CGFloat panGestureSideOffset;

+ (SlideNavigationController *)sharedInstance;

- (void)toggleLeftMenu;

- (void)toggleRightMenu;

- (void)openMenu:(Menu)menu withCompletion:(void (^)())completion;

- (void)closeMenuWithCompletion:(void (^)())completion;

- (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion __deprecated;

- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController withSlideOutAnimation:(BOOL)slideOutAnimation andCompletion:(void (^)())completion;

- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;

- (void)popAllAndSwitchToViewController:(UIViewController *)viewController withSlideOutAnimation:(BOOL)slideOutAnimation andCompletion:(void (^)())completion;

- (void)popAllAndSwitchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;
@end
