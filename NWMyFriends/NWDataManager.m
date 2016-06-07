#import "NWDataManager.h"
#include "NWParsedFriend.h"

@interface NWDataManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation NWDataManager

+ (instancetype)sharedManager {
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)loadData:(NSString*)stringURL onSuccess:(BlockSuccess)blockArray onFailure:(BlockError)blockError {
    NSURL *URL = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *users = responseObject[@"results"];
        NSMutableArray *objectsArray = [NSMutableArray array];
        for(NSDictionary *dictionary in users) {
            NWParsedFriend *friend = [[NWParsedFriend alloc] initWithServerResponse:dictionary];
            [objectsArray addObject:friend];
        }
        blockArray(objectsArray);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        blockError(error);
    }];
    [operation start];
}

@end
