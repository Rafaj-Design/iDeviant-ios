
#import <UIKit/UIKit.h>


@interface JCOMessageCell : UITableViewCell {
    UILabel* _title;
    UILabel* _body;
    UIView* _bgview;
}

@property (nonatomic, retain) IBOutlet UILabel* title;
@property (nonatomic, retain) IBOutlet UILabel* body;
@property (nonatomic, retain) IBOutlet UIView* bgview;

@end
