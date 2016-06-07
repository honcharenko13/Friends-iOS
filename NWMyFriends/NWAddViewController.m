#import "NWAddViewController.h"
#import "NWDataManager.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "NWParsedFriend.h"
#import "Friend.h"
#import "SVProgressHUD.h"

NSString *const stringURL = @"http://api.randomuser.me/?results=15";

@interface NWAddViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfFriends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIRefreshControl *refreshcontrol;

@end

@implementation NWAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfFriends = [NSMutableArray array];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getFriendsFromServer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    self.title = @"Add friend";
    //[self getFriendsFromServer];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(getFriendsFromServer) forControlEvents:UIControlEventValueChanged];
    self.refreshcontrol = refreshControl;
    [self.tableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  = UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString  *indentifier =  @"cell";
    NWCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    [self configureCell:customCell atIndexPath:indexPath];
    return customCell;
}

- (void)configureCell:(NWCustomCell *)customCell atIndexPath:(NSIndexPath *)indexPath {
    customCell.delegate = self;
    NWParsedFriend *friend = self.arrayOfFriends[indexPath.row];
    customCell.labelFullName.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    NSURL *url = [NSURL URLWithString:friend.stringImageThumbnailURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak UITableViewCell *weakCell = customCell;
    [customCell.imagePhoto setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request,
                                                                                         NSHTTPURLResponse *response, UIImage *image) {
        weakCell.imageView.image = image;
        [weakCell layoutSubviews];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }];
}

- (void)friendCellWasTapped:(NWCustomCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication]
                                                                    delegate] managedObjectContext];
    NSManagedObjectContext *writerObjectContext = [(AppDelegate *)[[UIApplication sharedApplication]
                                                                   delegate] writerManagedObjectContext];
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:
                                                NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = managedObjectContext;
    [temporaryContext performBlock:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Friend" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        Friend *selectedFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend"
                                                               inManagedObjectContext:managedObjectContext];
        NWParsedFriend *friend = self.arrayOfFriends[indexPath.row];
        selectedFriend.firstName = friend.firstName;
        selectedFriend.lastName = friend.lastName;
        selectedFriend.phone = friend.phone;
        selectedFriend.email = friend.email;
        selectedFriend.stringImageThumbnailURL = friend.stringImageThumbnailURL;
        selectedFriend.stringImageMediumURL = friend.stringImageMediumURL;
        selectedFriend.stringImageLargeURL = friend.stringImageLargeURL;
        selectedFriend.isFriend = friend.isFriend;
        NSLog(@"%@", selectedFriend);
        NSError *error = nil;
        if(![temporaryContext save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
        [managedObjectContext performBlock:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"%@", [error localizedDescription]);
                abort();
            }
            [self.arrayOfFriends removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [writerObjectContext performBlock:^{
                NSError *error = nil;
                if (![writerObjectContext save:&error]) {
                    NSLog(@"%@", [error localizedDescription]);
                    abort();
                }
                
            }];
        }];
    }];
}

- (void)getFriendsFromServer {
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NWDataManager sharedManager] loadData:stringURL onSuccess:^(NSArray *responseArray) {
            [self.arrayOfFriends addObjectsFromArray:responseArray];
            [self.tableView reloadData];
        } onFailure:^(NSError *error) {
            if(error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network unavailable"
                                                                               message:@"It is impossible to load new friends"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {}];
                [alert addAction:OkAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            [self.refreshcontrol endRefreshing];
        });
    });
    
}

@end
