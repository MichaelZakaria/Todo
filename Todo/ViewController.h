//
//  ViewController.h
//  Todo
//
//  Created by Marco on 2024-07-17.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>


-(void) refresh;

@end

