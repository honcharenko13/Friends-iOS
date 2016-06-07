#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface Friend (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *stringImageLargeURL;
@property (nullable, nonatomic, retain) NSString *stringImageMediumURL;
@property (nullable, nonatomic, retain) NSString *stringImageThumbnailURL;
@property (nullable, nonatomic, retain) NSNumber *isFriend;

@end

NS_ASSUME_NONNULL_END
