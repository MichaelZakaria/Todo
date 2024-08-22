//
//  AddNoteViewController.m
//  Todo
//
//  Created by Marco on 2024-07-17.
//

#import "AddNoteViewController.h"
#import "Note.h"

@interface AddNoteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *titleRequiredLabel;

@property (weak, nonatomic) IBOutlet UITextField *header;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *type;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property NSUserDefaults *defaults;
@property NSArray *notesArr;
@property NSMutableArray *notesMutableArr;
@property UIAlertController *alert;

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    _header.delegate = self;
    _content.delegate = self;
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSError *error;
    NSData *savedData = [_defaults objectForKey:@"Notes"];
    NSSet *set = [NSSet setWithArray:@[[NSArray class], [Note class]]];
    NSArray<Note *> *notesArray = (NSArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    
    _notesMutableArr = [[NSMutableArray alloc] initWithArray:notesArray];
    
    //if editing existing note
    [self editing];
    
    [self setMyAlert];
    
    _date.minimumDate = [NSDate  now];
    
    switch ([_priority selectedSegmentIndex]) {
        case 0:
            _priority.selectedSegmentTintColor = [UIColor greenColor];
            _image.image = [UIImage imageNamed:@"green"];
            break;
        case 1:
            _priority.selectedSegmentTintColor = [UIColor yellowColor];
            _image.image = [UIImage imageNamed:@"yellow"];
            break;
        case 2:
            _priority.selectedSegmentTintColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"red"];
            break;
        default:
            break;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// to dismiss keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return _header.resignFirstResponder;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [_content resignFirstResponder];
        return NO;
    }
    return YES;
}

-(IBAction)prioritySegmentedOnChange:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            _priority.selectedSegmentTintColor = [UIColor greenColor];
            _image.image = [UIImage imageNamed:@"green"];
            break;
        case 1:
            _priority.selectedSegmentTintColor = [UIColor yellowColor];
            _image.image = [UIImage imageNamed:@"yellow"];
            break;
        case 2:
            _priority.selectedSegmentTintColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"red"];
            break;
        default:
            break;
    }
}

- (IBAction)save:(id)sender {
    if(![_header.text  isEqual: @""]){ // if the title is enterd
        [self presentViewController:_alert animated:YES completion:nil];
    } else{
        _titleRequiredLabel.hidden = NO;
    }
}

- (void) editing{
    if(_note){
        _header.text = _note.title;
        _content.text = _note.content;
        _priority.selectedSegmentIndex = _note.priority;
        _type.selectedSegmentIndex = _note.type;
        _date.date = _note.date;
    }
    
    if(_note.type == 2){
        _header.enabled = NO;
        _content.editable = NO;
        _priority.enabled = NO;
        _type.enabled = NO;
        _date.enabled = NO;
        _btn.hidden = YES;
    }
    
    if(_note.type == 1){
        [_type setEnabled:NO forSegmentAtIndex:0];
    }
    
}

- (void) setMyAlert{
    _alert = [UIAlertController alertControllerWithTitle:@"Sure" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveNote];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [_alert addAction:ok];
    [_alert addAction:cancel];
}

- (void) saveNote{
    if(_note)
        [_notesMutableArr removeObjectAtIndex:_noteNumber];
    
    Note *note = [Note new];
    note.title = _header.text;
    note.content = _content.text;
    note.priority = (int) _priority.selectedSegmentIndex;
    note.type = (int) _type.selectedSegmentIndex;
    note.date = _date.date;
    
    if(_note) // if you are editing an existing note
        [_notesMutableArr insertObject:note atIndex:_noteNumber];
    else
        [_notesMutableArr addObject:note];
        
    _notesArr = [[NSArray alloc] initWithArray:_notesMutableArr];
    
    // Save notes array in user defaults
    NSError *error;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:_notesArr requiringSecureCoding:YES error:&error];
    [_defaults setObject:archivedData forKey:@"Notes"];
    
    printf("done");
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
