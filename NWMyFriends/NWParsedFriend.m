#import "NWParsedFriend.h"

@implementation NWParsedFriend

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject {
    self = [super init];
    if (self) {
        self.firstName = [[responseObject objectForKey:@"name"]objectForKey:@"first"];
        self.lastName = [[responseObject objectForKey:@"name"]objectForKey:@"last"];
        self.email = [responseObject objectForKey:@"email"];
        self.phone = [responseObject objectForKey:@"phone"];
        self.stringImageThumbnailURL = [[responseObject objectForKey:@"picture"]objectForKey:@"thumbnail"];
        self.stringImageMediumURL = [[responseObject objectForKey:@"picture"]objectForKey:@"medium"];
        self.stringImageLargeURL = [[responseObject objectForKey:@"picture"]objectForKey:@"large"];
        self.isFriend = @YES;
    }
    return self;
}

@end
