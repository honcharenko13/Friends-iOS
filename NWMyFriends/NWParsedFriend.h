#import <Foundation/Foundation.h>

@interface NWParsedFriend : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;

@property (strong, nonatomic) NSString *stringImageThumbnailURL;
@property (strong, nonatomic) NSString *stringImageMediumURL;
@property (strong, nonatomic) NSString *stringImageLargeURL;
@property (strong, nonatomic) NSNumber *isFriend;

- (id)initWithServerResponse:(NSDictionary*) responseObject;

@end
