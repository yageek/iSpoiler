#import "_GPXFile.h"

@interface GPXFile : _GPXFile {
    BOOL _leaf;
}
    // Custom logic goes here.
@property(nonatomic,getter = isLeaf) BOOL leaf;
@end
