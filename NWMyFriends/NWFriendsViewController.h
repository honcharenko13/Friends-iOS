#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class NWDetailViewController;

@interface NWFriendsViewController : UIViewController

@property (strong, nonatomic) NWDetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *writerManagedObjectContext;

@end
