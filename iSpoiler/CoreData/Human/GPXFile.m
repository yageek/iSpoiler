#import "GPXFile.h"


@interface GPXFile ()

// Private interface goes here.

@end


@implementation GPXFile

@synthesize leaf = _leaf;
// Custom logic goes here.

- (void) awakeFromInsert
{
    self.leaf = NO;
}
@end
