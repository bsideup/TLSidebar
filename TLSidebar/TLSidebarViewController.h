#import <UIKit/UIKit.h>

#define kVisiblePortion 40
#define kMenuTableSize 280

@interface TLSidebarViewController : UIViewController

@property( readonly ) UIPanGestureRecognizer *panGesture;
@property( readonly ) UITapGestureRecognizer *tapGesture;

@property( nonatomic, readonly ) BOOL sidebarHidden;

@property( nonatomic ) float slideInterval;

- ( void ) setSidebarHidden:(BOOL)hidden
				   animated:(BOOL)animated;

@end
