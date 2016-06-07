#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friend : NSManagedObject

+ (NSFetchedResultsController *)fetchIsFriend:(NSString *)predicate withDelegate:(id)delegate
andContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Friend+CoreDataProperties.h"
