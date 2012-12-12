#import <UIKit/UIKit.h>
#import "TLSignals.h"

#define kDefaultMenuTableSize 280

typedef enum
{
	TLSidebarMenuDirectionLeft,
	TLSidebarMenuDirectionRight
} TLSidebarMenuDirection;


@interface TLSidebarViewController : UIViewController

@property (nonatomic, readonly) TLSignal<UIViewController *, BOOL> *willShowSidebarAnimatedSignal;
@property (nonatomic, readonly) TLSignal<UIViewController *, BOOL> *didShowSidebarAnimatedSignal;
@property (nonatomic, readonly) TLSignal<UIViewController *, BOOL> *willHideSidebarAnimatedSignal;
@property (nonatomic, readonly) TLSignal<UIViewController *, BOOL> *didHideSidebarAnimatedSignal;

@property( nonatomic, readonly ) UIPanGestureRecognizer *panGesture;
@property( nonatomic, readonly ) UITapGestureRecognizer *tapGesture;

@property( nonatomic, readonly ) UIViewController *leftMenu;
@property( nonatomic, readonly ) UIViewController *rightMenu;

@property( nonatomic, readonly ) UIViewController *currentMenu;

@property( nonatomic, readonly ) TLSidebarMenuDirection currentDirection;

@property( nonatomic, readonly ) UIViewController *contentViewController;

@property( nonatomic, readonly ) BOOL sidebarHidden;

@property( nonatomic ) float slideInterval;

- ( id ) initWithContentViewController:(UIViewController *)aContentViewController;

- ( void ) hideSidebarAnimated:(BOOL)animated;

- ( void ) showSidebar:(UIViewController *)sidebar
		   inDirection:(TLSidebarMenuDirection)direction
			  animated:(BOOL)animated;

@end
