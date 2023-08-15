#import "DarwinSideJitEnable.h"

@implementation DarwinSideJitEnable 

- (void) EnableIdentifier {
    NSLog(@"EmableIdentifier Ran");
    let darwin = DarwinNotification(identifier: "com.sidestore.EnableSideJit")
    darwin.addObserver { [unowned self] (n: NSNotification!) -> Void in
}

@end
