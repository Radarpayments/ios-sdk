//
//  UITableViewController+ConfirmChoosedCard.m
//  CardKit
//
//  Created by Alex Korotkov on 5/21/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKBindingViewController.h"
#import "CardKConfig.h"
#import "CardKBinding.h"
#import "BindingCellView.h"
#import "CardKTextField.h"
#import "CardKFooterView.h"
#import "CardKValidation.h"
#import "CardKBankLogoView.h"
#import "SeTokenGenerator.h"

const NSString *CardKBindingCardCellID = @"bindingCard";
const NSString *CardKBindingButtonCellID = @"button";
const NSString *CardKConfirmChoosedCardRows = @"rows";
NSString *CardKConfirmChoosedCardFooterID = @"footer";

@implementation CardKBindingViewController {
  UIButton *_button;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSMutableArray *_sections;
  CardKFooterView *_cardFooterView;
  NSString *_lastAnouncment;
  BindingCellView * _bindingCellView;
}
- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];

  if (self) {
    _button =  [UIButton buttonWithType:UIButtonTypeSystem];
    _button.tag = 30007;
    
    _bundle = [NSBundle bundleForClass:[CardKBindingViewController class]];
     
     NSString *language = CardKConfig.shared.language;
    
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }

    [_button
      setTitle: NSLocalizedStringFromTableInBundle(@"doneButton", nil, _languageBundle, @"Pay")
      forState: UIControlStateNormal];
    [_button addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];

    _sections = [self _defaultSections];
    _bindingCellView = [[BindingCellView alloc] init];
    _bindingCellView.binding = _cardKBinding;
  }
  return self;
}

- (void)_refreshErrors {
  _cardFooterView.errorMessages = _bindingCellView.errorMessages;
  [self _announceError];
}

- (void)_announceError {
  NSString *errorMessage = [_bindingCellView.errorMessages firstObject];
  if (errorMessage.length > 0 && ![_lastAnouncment isEqualToString:errorMessage]) {
    _lastAnouncment = errorMessage;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _lastAnouncment);
  }
}

- (BOOL)_isFormValid {
  if (!CardKConfig.shared.bindingCVCRequired) {
    return YES;
  }
  
  [_bindingCellView validate];
  [self _refreshErrors];
  return _cardFooterView.errorMessages.count == 0;
}

- (void)_buttonPressed:(UIButton *)button {
  if (![self _isFormValid]) {
    [self _animateError];
    _lastAnouncment = nil;
    [self _announceError];
    return;
  }
  
  NSString *seToken = [SeTokenGenerator generateSeTokenWithBinding:_cardKBinding];

  [_cKitDelegate bindingViewController:self didCreateSeToken:seToken allowSaveBinding:NO isNewCard: NO];
}

- (void)_animateError {
  [_button animateError];
}

- (NSMutableArray *)_defaultSections {
  NSMutableArray *defaultSections = [[NSMutableArray alloc] initWithArray: @[
    @{CardKConfirmChoosedCardRows: @[CardKBindingCardCellID]},
    @{CardKConfirmChoosedCardRows: @[CardKBindingButtonCellID] },
  ] copyItems:YES];
  
  return defaultSections;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  for (NSString *cellID in @[CardKBindingCardCellID, CardKBindingButtonCellID]) {
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  CardKTheme *theme = CardKConfig.shared.theme;

  self.tableView.tableHeaderView = _bankLogoView;
  self.tableView.separatorColor = theme.colorSeparatar;
  self.tableView.backgroundColor = theme.colorTableBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
  
  UINavigationBar *bar = [self.navigationController navigationBar];
  bar.barTintColor = theme.colorCellBackground;
  
  _button.tintColor = theme.colorButtonText;
  _bankLogoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);
  _bankLogoView.title = @"";
  [_bankLogoView fetchBankInfo: CardKConfig.shared.mrBinApiURL cardNumber: [self _getKnowsCardDigit]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_bindingCellView focusSecureCode];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGRect bounds = _button.superview.bounds;
  _button.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5);
  
  _button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
}

- (NSString *) _getKnowsCardDigit {
  NSArray *digits = [_cardKBinding.cardNumber componentsSeparatedByString:@"X"];
  
  return digits[0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier: CardKConfirmChoosedCardFooterID];
  if (view == nil) {
    view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier: CardKConfirmChoosedCardFooterID];
  }

  if (section == 0) {
    if (_cardFooterView == nil) {
      _cardFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
    }
    
    [view.contentView addSubview:_cardFooterView];
  }
  
  return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return  [_sections[section][CardKConfirmChoosedCardRows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = _sections[indexPath.section][CardKConfirmChoosedCardRows][indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];

  if ([CardKBindingCardCellID isEqual:cellID] || ([CardKBindingCardCellID isEqual:cellID] && CardKConfig.shared.bindingCVCRequired)) {
    _bindingCellView.binding = _cardKBinding;
    _bindingCellView.showCVCField = YES;
    _bindingCellView.showShortCardNumber = NO;
    
    [cell.contentView addSubview:_bindingCellView];
  } else if ([CardKBindingButtonCellID isEqual:cellID]) {
    [cell.contentView addSubview:_button];
  }

  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    CGRect r = tableView.readableContentGuide.layoutFrame;
    UITableViewHeaderFooterView * v = (UITableViewHeaderFooterView *)view;
    v.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x, 0, v.contentView.bounds.size.width, v.contentView.bounds.size.height);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  CGRect r = tableView.readableContentGuide.layoutFrame;

  cell.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x, 0, r.size.width - r.origin.x, cell.contentView.bounds.size.height);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 38;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}


@end
