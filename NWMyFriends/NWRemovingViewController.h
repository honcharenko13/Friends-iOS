#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NWCustomCell.h"

@interface NWRemovingViewController : UIViewController <NWCustomCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *writerManagedObjectContext;

@end
