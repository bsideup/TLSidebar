#import <UIKit/UIKit.h>

#define kDefaultMenuTableSize 280

typedef enum
{
	TLSidebarMenuDirectionLeft,
	TLSidebarMenuDirectionRight
} TLSidebarMenuDirection;

@interface TLSidebarViewController : UIViewController

@property( readonly  ) UIPanGestureRecognizer *panGesture;
@property( readonly  ) UITapGestureRecognizer *tapGesture;

@property( readonly  ) UIViewController *leftMenu;
@property( readonly  ) UIViewController *rightMenu;

@property( readonly  ) UIViewController *currentMenu;
@property( nonatomic, readonly ) TLSidebarMenuDirection currentDirection;

@property( nonatomic, readonly ) UIViewController *contentViewController;

@property( nonatomic, readonly ) BOOL sidebarHidden;

@property( nonatomic ) float slideInterval;

-(id)initWithContentViewController:(UIViewController *)aContentViewController;

-(void)hideSidebarAnimated:(BOOL)animated;

-(void) showSidebar:(UIViewController *)sidebar
		inDirection:(TLSidebarMenuDirection)direction
		   animated:(BOOL)animated;

@end
