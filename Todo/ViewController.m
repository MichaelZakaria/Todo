//
//  ViewController.m
//  Todo
//
//  Created by Marco on 2024-07-17.
//

#import "ViewController.h"
#import "Note.h"
#import "AddNoteViewController.h"
#import "TabBarViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImage;

@property NSUserDefaults *defaults;

@property NSArray<Note *> *allNotesArray;
@property NSMutableArray<Note *> *notesArray;
@property NSMutableArray<Note *> *filterdArr;
@property NSMutableArray<Note *> *sortedArr;

@property UISearchController *searchController;

@property bool isFilterd;
@property bool isSorted;

@property int indexCounter;

@end

@implementation ViewController
- (IBAction)addNewNoteButtonAction:(id)sender {
    AddNoteViewController *new = [self.storyboard instantiateViewControllerWithIdentifier:@"new"];
     [self.navigationController pushViewController:new animated:YES];
}
- (IBAction)setFilterd:(id)sender {
    if(_isSorted)
        _isSorted = NO;
    else
        _isSorted = YES;
    
    [_table reloadData];
}

- (void)viewDidLoad {
// seting table view delegate
    _table.delegate = self;
    _table.dataSource =self;
// seting search bar view delegate
    _searchbar.delegate = self;
// init UserDefault obj
    _defaults = [NSUserDefaults standardUserDefaults];
    
    self.tabBarController.title = @"Todo List";
// init SearchController obj
    _searchController = [UISearchController new];
    
    _sortedArr = [NSMutableArray new];
    
    _emptyImage.image = [UIImage imageNamed:@"empty"];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorWithWhite:1 alpha:0.6];
   
    // Do any additional setup after loading the view.
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [self initElements];
}

-(void) initElements{
// init indtxCounter for use later
    _indexCounter = 0;
    
// Get notes array from user defaults
    NSError *error;
    NSData *savedData = [_defaults objectForKey:@"Notes"];
    NSSet *set = [NSSet setWithArray:@[[NSArray class], [Note class]]];
    NSArray<Note *> *notesArray = (NSArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    
    _allNotesArray = [[NSArray alloc] initWithArray:notesArray];

// Set Which screen will be displayed
    [self setViews:notesArray];
    
// Empty array to compare
    NSMutableArray *emptyArr = [NSMutableArray new];
    
    if([_notesArray isEqual:emptyArr]){
        _emptyImage.hidden = NO;
    }
    else {
        _emptyImage.hidden = YES;
    }

// init SortedArr
    _sortedArr = [NSMutableArray new];
    for (int i = 0; i < [_notesArray count]; i++) {
        NSSortDescriptor *sortByPriority = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByPriority];
        
        _notesArray =[[NSMutableArray alloc] initWithArray:[_notesArray sortedArrayUsingDescriptors:sortDescriptors]];
        
        if([_sortedArr count] == [_notesArray count]) _sortedArr = [NSMutableArray new];
        if(_indexCounter == _notesArray.count) _indexCounter = 0;
        
        [_sortedArr addObject:_notesArray[_indexCounter]];
        _indexCounter++;
    }
    
    [_table reloadData];
}


// dismiss search keyboard
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [_searchbar resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void) setViews:(NSArray<Note *> *) allNotesArr{
    
    int selectedScreenTag = (int)[self.tabBarController.tabBar.selectedItem tag];
    
    switch(selectedScreenTag){
        case 0:
            self.tabBarController.title = @"Todo List";
            _notesArray = [NSMutableArray new];
            for (int i =0; i<[allNotesArr count]; i++) {
                if (allNotesArr[i].type == 0) {
                    [_notesArray addObject:allNotesArr[i]];
                }
            }
            break;
        case 1:
            self.tabBarController.title = @"InProgress";
            _notesArray = [NSMutableArray new];
            for (int i =0; i<[allNotesArr count]; i++) {
                if (allNotesArr[i].type == 1) {
                    [_notesArray addObject:allNotesArr[i]];
                }
            }
            break;
        case 2:
            self.tabBarController.title = @"Done";
            _notesArray = [NSMutableArray new];
            for (int i =0; i<[allNotesArr count]; i++) {
                if (allNotesArr[i].type == 2) {
                    [_notesArray addObject:allNotesArr[i]];
                }
            }
            break;
    }
   [_table reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
    
// change it in the future ***
    NSString *notePriority;
    if(_isFilterd){
        notePriority = [[NSString alloc] initWithFormat:@"%@",[_filterdArr[indexPath.row] valueForKey:@"priority"]];
    } else {
        if(_indexCounter == _notesArray.count) {
            _indexCounter = 0;
        }
        notePriority = [[NSString alloc] initWithFormat:@"%@",[_notesArray[_indexCounter] valueForKey:@"priority"]];
    }
    
    if([notePriority isEqual:@"0"])
        cell.imageView.image = [UIImage imageNamed:@"green"];
    else if([notePriority isEqual:@"1"])
        cell.imageView.image = [UIImage imageNamed:@"yellow"];
    else
        cell.imageView.image = [UIImage imageNamed:@"red"];
    
    
    if(_isFilterd){
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",[_filterdArr[indexPath.row] valueForKey:@"title"]];
    } else {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", [_notesArray[_indexCounter] valueForKey:@"title"]];
    
            _indexCounter++;
    }
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_isSorted){
        switch (section) {
            case 0:
                return @"Low";
                break;
            case 1:
                return @"meduim";
                break;
            case 2:
                return @"heigh";
                break;
            default:
                return @"";
                break;
        }
    }
    return @"";
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isSorted){
        int i = 0;
        switch (section) {
            case 0:
                for (Note *note in _notesArray) {
                    if(note.priority == 0)
                        i++;
                };
                return i;
                break;
            case 1:
                for (Note *note in _notesArray) {
                    if(note.priority == 1)
                        i++;
                };
                return i;
                break;
            case 2:
                for (Note *note in _notesArray) {
                    if(note.priority == 2)
                        i++;
                };
                return i;
                break;
                
            default:
                return 1;
                break;
        }
    }
    
    if(_isFilterd)
        return [_filterdArr count];
    else
        return [_notesArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSorted)
        return 3;
    else
        return 1;;
}
    
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction *action1 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
        title:@"Delete"
        handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        Note *deletedNote;
        if(self->_isFilterd){
            deletedNote = self->_filterdArr[indexPath.row];
            [self->_filterdArr removeObject:deletedNote];
        } else if(self->_isSorted) {
            NSInteger index = 0;
            NSInteger numOFRows = 0;
            for (int i = 0; i <= indexPath.section-1; i++ ) {
                numOFRows += [self->_table numberOfRowsInSection:i];
            }
            
            index = indexPath.row + numOFRows;
            
            deletedNote = self->_sortedArr[index];
            [self->_sortedArr removeObject:deletedNote];
        } else {
            deletedNote = self->_notesArray[indexPath.row];
        }
        
        self->_notesArray = [[NSMutableArray alloc] initWithArray:self->_allNotesArray];
        [self->_notesArray removeObject:deletedNote];
        
        NSError *error;
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self->_notesArray requiringSecureCoding:YES error:&error];
        [self->_defaults setObject:archivedData forKey:@"Notes"];
        
        [self setViews:[[NSArray alloc] initWithArray:self->_notesArray]];
        
        [self initElements];
            
            completionHandler(YES); // Inform the table view that the action was performed
        }];
    
        action1.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[action1]];
    
    return configuration;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddNoteViewController *new = [self.storyboard instantiateViewControllerWithIdentifier:@"new"];
    if(_isFilterd){
        new.note = _filterdArr[indexPath.row];
        new.note = _filterdArr[indexPath.row];
        new.noteNumber = [_allNotesArray indexOfObject:new.note];
    } else if (_isSorted) {
        
        NSInteger index = 0;
        NSInteger numOFRows = 0;
        for (int i =0; i <= indexPath.section-1; i++ ) {
            numOFRows += [_table numberOfRowsInSection:i];
        }
        
        index = indexPath.row + numOFRows;
        
        new.note = _sortedArr[index];
        new.noteNumber = [_allNotesArray indexOfObject:new.note];
    } else {
        new.note = _notesArray[indexPath.row];
        new.noteNumber = [_allNotesArray indexOfObject:new.note];
    }
     [self.navigationController pushViewController:new animated:YES];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [_table reloadData];
}

-(void) refresh{
    [_table reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0) {
        _isFilterd = NO;
    } else {
        _isFilterd = YES;
        _filterdArr = [NSMutableArray new];
        
        for (Note *note in _notesArray) {
            NSRange titleRange = [note.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(titleRange.location != NSNotFound){
                [_filterdArr addObject:note];
            }
        }
    }
    if([_filterdArr isEqual:[NSMutableArray new]] && _isFilterd) 
        _emptyImage.hidden = NO;
    else
        _emptyImage.hidden = YES;
        
    [_table reloadData];
}

@end



