#import <UIKit/UIKit.h>

#define kDefaultMenuTableSize 280

@interface TLSidebarViewController : UIViewController

@property( readonly ) UIPanGestureRecognizer *panGesture;
@property( readonly ) UITapGestureRecognizer *tapGesture;

@property( readonly ) UIViewController *menu;
@property( readonly ) UIViewController *content;

@property( nonatomic, readonly ) BOOL sidebarHidden;

@property( nonatomic ) float slideInterval;

- ( void ) setSidebarHidden:(BOOL)hidden
				   animated:(BOOL)animated;

@end
