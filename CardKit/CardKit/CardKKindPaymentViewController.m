//
//  UITableViewController+CardKKindPaymentViewController.m
//  CardKit
//
//  Created by Alex Korotkov on 5/13/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "CardKKindPaymentViewController.h"
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
#import "CardKAllPaymentMethodsController.h"
#import "CardKitImageProvider.h"

#import "Constants.h"
#import "Logger.h"


@implementation CardKKindPaymentViewController {
  UIButton *_button;
  CardKApplePayButtonView *_applePayButton;
  UIBarButtonItem *_editModeButton;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
  CardKBankLogoView *_bankLogoView;
  NSMutableArray *_removedBindings;
  NSMutableArray *_currentBindings;
  BOOL _isEditing;
  id<CardKDelegate> _cKitDelegate;
  DividerView *_dividerView;
  NewCardCellView *_newCardCellView;
  UIView *uiview;
  UITableView *tableView;
  NSLayoutConstraint *_containerViewHeightConstraint;
  NSLayoutConstraint *_containerViewBottomConstraint;
  UIImageView *_closeView;
  UIView *_dimmedView;
}

- (instancetype)init {
  self = [super init];
  
  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKKindPaymentViewController class]];
    _removedBindings = [[NSMutableArray alloc] init];
    _currentBindings = [[NSMutableArray alloc] initWithArray:CardKConfig.shared.bindings];
    
    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }
    
    _sections = [self _defaultSections];
    
    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bankLogoView.title = NSLocalizedStringFromTableInBundle(@"title", nil, _languageBundle, @"Title");
    
    _dividerView = [[DividerView alloc] init];
    _dividerView.title = NSLocalizedStringFromTableInBundle(@"payByCard", nil, _languageBundle, @"payByCard");
    
    _newCardCellView = [[NewCardCellView alloc] init];
    _newCardCellView.tag = 20000;
    
    tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.clipsToBounds = YES;
    

    
    _closeView = [[UIImageView alloc] init];
    _closeView.image = [CardKitImageProvider namedImage:@"close" inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
    
    
    _dimmedView = [[UIView alloc] init];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(_hideTableViewTap:)];
    [_dimmedView addGestureRecognizer:singleFingerTap];
    _dimmedView.backgroundColor = [UIColor blackColor];
    _dimmedView.layer.opacity = 0;
    
    [self.view addSubview:_dimmedView];
    [self.view addSubview:tableView];
    
    self.accessibilityNavigationStyle = UIAccessibilityNavigationStyleCombined;
    
    CardKTheme *theme = CardKConfig.shared.theme;
    [UIBarButtonItem appearance].tintColor = theme.colorLabel;
    
    if (@available(iOS 11.0, *)) {
      self.navigationItem.backButtonTitle = @"";
    }
  }
  return self;
}

- (void)setCKitDelegate:(id<CardKDelegate>)cKitDelegate {
  _applePayButton = [[CardKApplePayButtonView alloc] initWithDelegate: cKitDelegate];
  
  _applePayButton.cardKPaymentViewDelegate = self;
  _applePayButton.controller = self;
  _cKitDelegate = cKitDelegate;
}

- (id<CardKDelegate>)cKitDelegate {
  return _cKitDelegate;
}

- (NSArray *)_defaultSections {
  NSMutableArray *bindings = [[NSMutableArray alloc] initWithArray:@[]];
  
  [bindings addObject:@{CardKCloseIconCellID: @[]}];
  [bindings addObject:@{CardKPayCardButtonCellID: @[]}];
  [bindings addObject:@{CardKDividerCellID: @[]}];
  for (CardKBinding * binding in _currentBindings) {
    BindingCellView *cellBinding = [[BindingCellView alloc] init];
    cellBinding.binding = binding;
    cellBinding.showShortCardNumber = YES;
    [bindings addObject:@{ CardKSavedCardsCellID: cellBinding}];
  }
  
  [bindings addObject:@{NewCardCellID: @[]}];
  [bindings addObject:@{AllPaymentMethodsCellID: @[]}];
  
  return @[@{CardKRows: bindings}];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  tableView.tag = 40001;
  
  for (NSString *cellID in @[CardKCloseIconCellID, CardKSavedCardsCellID, CardKPayCardButtonCellID, CardKDividerCellID, NewCardCellID, AllPaymentMethodsCellID]) {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  CardKTheme *theme = CardKConfig.shared.theme;
  
  tableView.backgroundColor = theme.colorBottomSheetBackground;
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  tableView.cellLayoutMarginsFollowReadableWidth = NO;
//  [tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
  
  
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  tableView.allowsSelectionDuringEditing = NO;
  tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  tableView.cellLayoutMarginsFollowReadableWidth = NO;
  
  CGSize size = self.view.bounds.size;
  
  _bankLogoView.frame = CGRectMake(size.width * 2, 0, 0, 0);
  
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    tableView.frame = CGRectMake(0, 0, size.width, tableView.contentSize.height + 44);
    tableView.center = CGPointMake(size.width / 2, size.height / 2);
  } else {
    tableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), size.width, tableView.contentSize.height + 44);
  }
}

- (void) _setUpTableViewWithAnimate: (BOOL) animate {
  [self.view layoutIfNeeded];
  
  
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    [self _animateViewForIpad:animate];
    
    return;
  }
  
  UITableView *tw = tableView;
  CGRect bounds = self.view.bounds;
  
  NSInteger yPostion = bounds.size.height - tw.contentSize.height - 44;
  NSInteger height = tw.contentSize.height + 44;
  
  if (yPostion <= 0) {
    yPostion =  0;
    height = tw.contentSize.height + 20;
  }
  
  CGRect twFrame = CGRectMake(0, yPostion, self.view.frame.size.width, height);
  
  if (animate) {
    [UIView animateWithDuration:0.3 animations:^{
      tw.frame = twFrame;
      self->_dimmedView.layer.opacity = 0.4;
    }];
  } else {
    tw.frame = twFrame;
    self->_dimmedView.layer.opacity = 0.4;
  }
}

- (void) _animateViewForIpad: (BOOL) animate {
  UITableView *tw = tableView;
  UIView *dimmedView = _dimmedView;
  
  if (animate) {
    [UIView animateWithDuration:0.3 animations:^{
      tw.layer.opacity = 1;
      dimmedView.layer.opacity = 0.4;
    }];
  } else {
    tw.layer.opacity = 0;
    dimmedView.layer.opacity = 0.4;
  }
}

- (void)_hideTableViewTap:(UITapGestureRecognizer *)recognizer {
  [self _hideTableViewWithDismiss:YES callback:nil];
}

- (void) _hideTableViewWithDismiss:(BOOL) dismiss callback:(nullable void(^)(void)) callback {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    [self _hideTableForIpadWithDissmiss:dismiss callback:callback];
    
    return;
  }
  
  [self _hideTableForIphoneWithDissmiss:dismiss callback:callback];
}

- (void) _hideTableForIphoneWithDissmiss:(BOOL) dismiss callback:(nullable void(^)(void)) callback {
  UITableView *tw = tableView;
  CGRect bounds = self.view.bounds;
  NSInteger speed = 0.3;
  
  if (callback) {
    speed = 0.2;
  }
  
  UIView * dimmedView = _dimmedView;
  
  [UIView animateWithDuration:0.3 animations:^{
    tw.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), bounds.size.width, tw.contentSize.height + 44);
    dimmedView.layer.opacity = 0;
    
  } completion:^(BOOL finished) {
    if (callback) {
      callback();
    }
    
    if (dismiss) {
      [self dismissViewControllerAnimated:NO completion:nil];
    }
  }];
}

- (void) _hideTableForIpadWithDissmiss:(BOOL) dismiss callback:(nullable void(^)(void)) callback {
  UITableView *tw = tableView;
  UIView *dimmedView = _dimmedView;
  
  [UIView animateWithDuration:0.3 animations:^{
    tw.layer.opacity = 0;
    dimmedView.layer.opacity = 0;
    
  } completion:^(BOOL finished) {
    if (callback) {
      callback();
    }
    
    if (dismiss) {
      [self dismissViewControllerAnimated:NO completion:nil];
    }
  }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections.firstObject[@"rows"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];
  
  NSInteger width = cell.contentView.frame.size.width;
  
  if ([CardKCloseIconCellID isEqual:cellID]) {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:_closeView];
  } else if ([CardKSavedCardsCellID isEqual:cellID]) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    BindingCellView *bindingCellView = _sections[indexPath.section][CardKRows][indexPath.row][CardKSavedCardsCellID];
    bindingCellView.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height);
    [cell.contentView addSubview:bindingCellView];
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
    _applePayButton.frame = CGRectMake(0, 0, width < 500 ? width : 500, 110);
    _applePayButton.center = CGPointMake(width * 0.5, 150 * 0.5);
    
    [cell.contentView addSubview:_applePayButton];
  } else if ([CardKDividerCellID isEqual:cellID]) {
    _dividerView.frame = CGRectMake(0, 0,  width - 40, 56);
    _dividerView.center = CGPointMake(width * 0.5, 56 * 0.5);
    [cell.contentView addSubview:_dividerView];
  } else if ([NewCardCellID isEqual:cellID]) {
    _newCardCellView.frame = cell.contentView.frame;
    cell.tag = 20000;
    [cell.contentView addSubview:_newCardCellView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  } else if ([AllPaymentMethodsCellID isEqual:cellID]) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"allPaymentMethods", nil, _languageBundle, @"allPaymentMethods");
    cell.textLabel.textColor = CardKConfig.shared.theme.colorLabel;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.tag = 40002;
  }
  
  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorBottomSheetBackground != nil) {
    cell.backgroundColor = theme.colorBottomSheetBackground;
  }
  
  
  return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  
  CGRect frame = cell.contentView.frame;
  NSInteger width = cell.contentView.frame.size.width;
  
  if ([CardKCloseIconCellID isEqual:cellID]) {
    _closeView.frame = CGRectMake(frame.size.width - 45, 10, 30, 30);
  } else if ([CardKDividerCellID isEqual:cellID]) {
    _dividerView.frame = CGRectMake(0, 0,  width - CGRectGetMinX(cell.contentView.frame) - 40, 56);
    _dividerView.center = CGPointMake(width * 0.5, 56 * 0.5);
    [cell.contentView addSubview:_dividerView];
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
    _applePayButton.frame = CGRectMake(0, 0, width < 500 ? width : 500, 110);
    _applePayButton.center = CGPointMake(width * 0.5, 150 * 0.5);
    
    [cell.contentView addSubview:_applePayButton];
  } else if ([CardKSavedCardsCellID isEqual:cellID]) {
    BindingCellView *bindingCellView = _sections[indexPath.section][CardKRows][indexPath.row][CardKSavedCardsCellID];
    bindingCellView.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height);
    [cell.contentView addSubview:bindingCellView];
  }  else if ([NewCardCellID isEqual:cellID]) {
    _newCardCellView.frame = CGRectMake(20, 0, frame.size.width - 20, frame.size.height);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorBottomSheetBackground != nil) {
    cell.backgroundColor = theme.colorBottomSheetBackground;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  
  if ([CardKCloseIconCellID isEqual:cellID]) {
    [self _hideTableViewWithDismiss:YES callback:nil];
  } else if ([CardKSavedCardsCellID isEqual:cellID]) {
    CardKBindingViewController *cardKBindingViewController = [[CardKBindingViewController alloc] init];
    
    BindingCellView *selectedBindingView = _sections[indexPath.section][CardKRows][indexPath.row][CardKSavedCardsCellID];
    
    cardKBindingViewController.cardKBinding = selectedBindingView.binding;
    cardKBindingViewController.bankLogoView = _bankLogoView;
    cardKBindingViewController.cKitDelegate = _cKitDelegate;
    
    [self.navigationController pushViewController:cardKBindingViewController animated:YES];
  } else if ([NewCardCellID isEqual:cellID]) {
    CardKViewController *controller = [CardKViewController alloc];
    controller.cKitDelegate = _cKitDelegate;
    controller = [controller init];
    [self.navigationController pushViewController:controller animated:YES];
  } else if ([AllPaymentMethodsCellID isEqual:cellID]) {
    CardKAllPaymentMethodsController *controller = [[CardKAllPaymentMethodsController alloc] init];
    controller.cKitDelegate = _cKitDelegate;
    
    [self.navigationController pushViewController:controller animated:YES];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"";
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{NSForegroundColorAttributeName:CardKConfig.shared.theme.colorLabel}];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  
  self.navigationController.toolbar.hidden = YES;
  
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
   _dimmedView.frame = self.view.bounds;
  
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    
    NSInteger width = self.view.bounds.size.width;
    NSInteger height = ([_sections.firstObject[@"rows"] count] - 4) * 70 + 56 * 4;
    
    if (width < 450) {
      tableView.frame = CGRectMake(0, 0, width, height);
    } else {
      tableView.frame = CGRectMake(0, 0, 450, height);
    }
    
    tableView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    tableView.layer.cornerRadius = 13;
  } else {
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.view.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){13.0, 13.0}].CGPath;
    tableView.layer.masksToBounds = YES;
    tableView.layer.mask = maskLayer;
    tableView.scrollEnabled = NO;
  }

  [self _setUpTableViewWithAnimate: YES];
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  
  if ([CardKPayCardButtonCellID isEqual:cellID] && self.verticalButtonsRendered) {
    return 70;
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
    return 70;
  }
  
  return 56;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  
  return [CardKSavedCardsCellID isEqual:cellID] || [NewCardCellID isEqual:cellID] || [AllPaymentMethodsCellID isEqual:cellID] || [CardKCloseIconCellID isEqual:cellID];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  
  if (CardKConfig.shared.isEditBindingListMode && [CardKSavedCardsCellID isEqual:cellID]) {
    return YES;
  } else {
    return NO;
  }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}


- (void)pressedApplePayButton:(PKPaymentAuthorizationViewController *) authController {
  [self.navigationController presentViewController:authController animated:YES completion:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
  self.view.frame = self.view.bounds;
  _closeView.image = [CardKitImageProvider namedImage:@"close" inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
  [tableView reloadData];
}

@end
