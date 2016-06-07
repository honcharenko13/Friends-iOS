#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

typedef void(^BlockSuccess)(NSArray *responseArray);
typedef void(^BlockError)(NSError *error);

@interface NWDataManager : NSObject

@property (strong, nonatomic) NSArray *globalArray;

+ (instancetype)sharedManager;
- (void)loadData:(NSString*)stringURL onSuccess:(BlockSuccess)blockArray onFailure:(BlockError)blockError;

@end
