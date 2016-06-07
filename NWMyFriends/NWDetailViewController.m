#import "Friend.h"
#import "NWDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "JAMValidatingTextField.h"

@interface NWDetailViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelFullName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFLastName;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBottomConstaint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSave;

@end

@implementation NWDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem) {
        Friend *currentFriend = self.detailItem;
        self.textFieldFirstName.text = currentFriend.firstName;
        self.textFieldFLastName.text = currentFriend.lastName;
        self.textFieldPhone.text = currentFriend.phone;
        self.textFieldEmail.text = currentFriend.email;
        self.textFieldPhone.validationType = JAMValidatingTextFieldTypePhone;
        self.textFieldEmail.validationType = JAMValidatingTextFieldTypeEmail;
        NSURL *url = [NSURL URLWithString:currentFriend.stringImageLargeURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request,
                                                                                      NSHTTPURLResponse *response, UIImage *image) {
            self.imageView.image = image;
            [self.imageView layoutSubviews];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textFieldFirstName.delegate = self;
    self.textFieldFLastName.delegate = self;
    self.textFieldPhone.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFieldFirstName.userInteractionEnabled = false;
    self.textFieldFLastName.userInteractionEnabled = false;
    self.title = @"Detail information";
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(closeKeyboard)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [self.view addGestureRecognizer:tapRecognizer];
    [self configureView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)closeKeyboard {
    [self.textFieldFirstName resignFirstResponder];
    [self.textFieldFLastName resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textFieldFirstName resignFirstResponder];
    [self.textFieldFLastName resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.toBottomConstaint.constant = keyboardFrameBeginRect.size.height;
}

- (void)keyboardWillHide {
    self.toBottomConstaint.constant = 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)saveButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    NSManagedObjectContext *writerObjectContext = [(AppDelegate *)[[UIApplication sharedApplication]
                                                                   delegate] writerManagedObjectContext];
    Friend *currentFriend = self.detailItem;
    currentFriend.firstName = self.textFieldFirstName.text;
    currentFriend.lastName = self.textFieldFirstName.text;
    currentFriend.phone = self.textFieldPhone.text;
    currentFriend.email = self.textFieldEmail.text;
    NSError *error;
    if (![writerObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

- (IBAction)editingDidBeginForPhone:(JAMValidatingTextField *)sender {
    self.buttonSave.enabled = NO;
}

- (IBAction)endEditingTextFieldPhone:(JAMValidatingTextField *)sender {
    if (self.textFieldPhone.validationStatus == JAMValidatingTextFieldStatusValid) {
        self.buttonSave.enabled = YES;
    } else {
        self.buttonSave.enabled = NO;
    }
}

- (IBAction)beginEditingTextFieldEmail:(JAMValidatingTextField *)sender {
    self.buttonSave.enabled = NO;
}

- (IBAction)endEditingTextFieldEmail:(JAMValidatingTextField *)sender {
    if (self.textFieldEmail.validationStatus == JAMValidatingTextFieldStatusValid) {
        self.buttonSave.enabled = YES;
    } else {
        self.buttonSave.enabled = NO;
    }
}


@end
