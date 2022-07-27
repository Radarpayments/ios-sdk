//
//  CardKAllPaymentMethodsController.m
//  CardKit
//
//  Created by Alex Korotkov on 17.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "CardKAllPaymentMethodsController.h"
#import "CardKViewController.h"
#import "CardKConfig.h"
#import "CardKBinding.h"
#import "CardKBindingViewController.h"
#import "CardKBankLogoView.h"
#import "CardKPaymentView.h"
#import "PaymentSystemProvider.h"
#import "CardKApplePayButtonView.h"
#import "DividerView.h"
#import "BindingCellView.h"
#import "NewCardCellView.h"

#import "Constants.h"

@implementation CardKAllPaymentMethodsController {
  UIButton *_button;
  UIBarButtonItem *_editModeButton;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
  NSMutableArray *_removedBindings;
  NSMutableArray *_currentBindings;
  BOOL _isEditing;
  id<CardKDelegate> _cKitDelegate;
  NewCardCellView *_newCardCellView;
}

- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];

  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKAllPaymentMethodsController class]];
    _removedBindings = [[NSMutableArray alloc] init];
    _currentBindings = [[NSMutableArray alloc] initWithArray:CardKConfig.shared.bindings];
    
     NSString *language = CardKConfig.shared.language;
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
    
    _sections = [self _defaultSections];
    
    _newCardCellView = [[NewCardCellView alloc] init];
    
    self.tableView.backgroundColor = CardKConfig.shared.theme.colorTableBackground;
    [UIBarButtonItem appearance].tintColor = [UIColor redColor];
    if (CardKConfig.shared.isEditBindingListMode) {
      _editModeButton = [[UIBarButtonItem alloc]
                         initWithTitle:NSLocalizedStringFromTableInBundle(@"edit", nil, _languageBundle, @"Edit")
                                     style: UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(_editMode:)];
      [_editModeButton setTintColor: CardKConfig.shared.theme.colorLabel];
      
      self.navigationItem.rightBarButtonItem = _editModeButton;
     
    }
//    [self.navigationItem.backBarButtonItem setTitle:@""];
    _isEditing = NO;
  }
  return self;
}

- (void)setCKitDelegate:(id<CardKDelegate>)cKitDelegate {
  _cKitDelegate = cKitDelegate;
}

- (id<CardKDelegate>)cKitDelegate {
  return _cKitDelegate;
}

- (void)_editMode:(UIButton *)button {
  if (self.tableView.isEditing) {
    _isEditing = NO;
    _sections = [self _defaultSections];
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:[_sections.firstObject[@"rows"] count] - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView setEditing:NO animated:YES];
    _editModeButton.title = NSLocalizedStringFromTableInBundle(@"edit", nil, _languageBundle, @"Edit");
    [self.cKitDelegate didRemoveBindings:_removedBindings];
    [self _disableRightBarButton];
    
    self.navigationItem.hidesBackButton = NO;

  } else {
    _isEditing = YES;
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:[_sections.firstObject[@"rows"] count] - 1 inSection:0];
            _sections = [self _defaultSectionsWithoudNewCard];

    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView setEditing:YES animated:YES];
    _editModeButton.title = NSLocalizedStringFromTableInBundle(@"save", nil, _languageBundle, @"Save");
    self.navigationItem.hidesBackButton = YES;
  }
}

- (void)_disableRightBarButton {
  if (!_isEditing && [_currentBindings count] == 0) {
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
}

- (NSArray *)_defaultSections {
  NSMutableArray *bindings = [[NSMutableArray alloc] initWithArray:@[]];
  
  for (CardKBinding * binding in _currentBindings) {
    BindingCellView *cellBinding = [[BindingCellView alloc] init];
    cellBinding.binding = binding;
    cellBinding.showShortCardNumber = YES;
    [bindings addObject:@{ CardKSavedCardsCellID: cellBinding}];
  }
  
  [bindings addObject:@{NewCardCellID: @[]}];
  
  return @[@{CardKKindPayRows: bindings}];
}

- (NSArray *)_defaultSectionsWithoudNewCard {
  NSMutableArray *bindings = [[NSMutableArray alloc] initWithArray:@[]];
  
  for (CardKBinding * binding in _currentBindings) {
    BindingCellView *cellBinding = [[BindingCellView alloc] init];
    cellBinding.binding = binding;
    cellBinding.showShortCardNumber = YES;
    [bindings addObject:@{ CardKSavedCardsCellID: cellBinding}];
  }
  
  return @[@{CardKKindPayRows: bindings}];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.tag = 40001;
  
  for (NSString *cellID in @[CardKSavedCardsCellID,  NewCardCellID]) {
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  self.tableView.backgroundColor = CardKConfig.shared.theme.colorCellBackground;
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.allowsSelectionDuringEditing = YES;
  
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;

  self.title = @"Payment Methods";
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections.firstObject[@"rows"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];
  
  if([CardKSavedCardsCellID isEqual:cellID]) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
       [view setBackgroundColor:[UIColor greenColor]];
    
    UIImage *uiImage =  [UIImage imageNamed:@"bucket" inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imageView.image = uiImage;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [button addSubview:imageView];

    [button addTarget:self action:@selector(removeBinding:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.tag = indexPath.row;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.editingAccessoryView = button;
    BindingCellView *bindingCellView = _sections[indexPath.section][CardKKindPayRows][indexPath.row][CardKSavedCardsCellID];
    bindingCellView.frame = bindingCellView.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height);
    [cell.contentView addSubview:bindingCellView];
  }  else if ([NewCardCellID isEqual:cellID]) {
    _newCardCellView.frame = cell.contentView.frame;
    [cell.contentView addSubview:_newCardCellView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
   
  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }

  return cell;
}


- (void) removeBinding:(id)sender event:(id)event {
  NSSet *touches = [event allTouches];
  UITouch *touch = [touches anyObject];
  CGPoint currentTouchPosition = [touch locationInView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
  
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You really want to delete?"
                                 message:@"The card cannot restored. You'll have to add a ner card"
                                 preferredStyle:UIAlertControllerStyleAlert];
   
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action) {
    
    [self _removeBindingByIndexPath: indexPath];
  }];
  
  UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action) {
   
  }];
  
  [alert addAction:cancelAction];
  [alert addAction:defaultAction];
  alert.preferredAction = defaultAction;
  
  [self presentViewController:alert animated:YES completion:nil];
}

- (void) _removeBindingByIndexPath:(NSIndexPath *) indexPath {
  [_removedBindings addObject: _currentBindings[indexPath.row]];
  [_currentBindings removeObjectAtIndex:indexPath.row];
    
  _sections = [self _defaultSectionsWithoudNewCard];

  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  [_removedBindings addObject: _currentBindings[indexPath.row]];
  [_currentBindings removeObjectAtIndex:indexPath.row];
  
  if ([_currentBindings count] != 0) {
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];
  if([CardKSavedCardsCellID isEqual:cellID]) {
    BindingCellView *bindingCellView = _sections[indexPath.section][CardKKindPayRows][indexPath.row][CardKSavedCardsCellID];
    bindingCellView.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height);
    [cell.contentView addSubview:bindingCellView];
  }  else if ([NewCardCellID isEqual:cellID]) {
    _newCardCellView.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height);
    [cell.contentView addSubview:_newCardCellView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];
  
  if ([CardKSavedCardsCellID isEqual:cellID]) {
    CardKBindingViewController *cardKBindingViewController = [[CardKBindingViewController alloc] init];
    
    BindingCellView *selectedBindingView = _sections[indexPath.section][CardKKindPayRows][indexPath.row][CardKSavedCardsCellID];
    
    cardKBindingViewController.cardKBinding = selectedBindingView.binding;
    cardKBindingViewController.cKitDelegate = _cKitDelegate;
    
    
    [self.navigationController pushViewController:cardKBindingViewController animated:true];
  } else if ([NewCardCellID isEqual:cellID]) {
    CardKViewController *controller = [[CardKViewController alloc] init];
    controller.cKitDelegate = _cKitDelegate;
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return CardKConfig.shared.bindingsSectionTitle;
  }
  
  return @"";
}
  
  - (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

  header.textLabel.textColor = CardKConfig.shared.theme.colorLabel;
  header.textLabel.font = [UIFont boldSystemFontOfSize:20];
  header.textLabel.text = [header.textLabel.text capitalizedString];
}
  
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 56;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];

  if (CardKConfig.shared.isEditBindingListMode && [CardKSavedCardsCellID isEqual:cellID]) {
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
   [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
   [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (_isEditing && editingStyle == UITableViewCellEditingStyleDelete) {
    [_removedBindings addObject: _currentBindings[indexPath.row]];
    [_currentBindings removeObjectAtIndex:indexPath.row];
    
  } else if (editingStyle == UITableViewCellEditingStyleDelete){
    [self.cKitDelegate didRemoveBindings:@[_currentBindings[indexPath.row]]];
    
    [_currentBindings removeObjectAtIndex:indexPath.row];
  }
  
  if ([_currentBindings count] != 0) {
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  
  [self _disableRightBarButton];
}

- (void)pressedCardPayButton {
  CardKViewController *controller = [[CardKViewController alloc] init];
  controller.cKitDelegate = _cKitDelegate;
  
  [self.navigationController pushViewController:controller animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

@end
