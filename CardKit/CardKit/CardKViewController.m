//
//  CKitViewController.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKViewController.h"
#import "CardKTextField.h"
#import "CardKCardView.h"
#import "CardKBankLogoView.h"
#import "CardKConfig.h"
#import "CardKSwitchView.h"
#import "CardKKindPaymentViewController.h"
#import "CardKButtonView.h"

#import "CardKCardNumberTextField.h"
#import "CardKExpireDateTextField.h"
#import "CardKCVCTextField.h"

#import "Constants.h"
#import "VerifyCompaniesView.h"
#import "CardKCard.h"

#import <CardKitCore/CardKitCore.h>


@interface ScanViewWrapper: UIView

@property UIButton *backButton;

@end

@implementation ScanViewWrapper {
  UIView *_clippingView;
  UIView *_scanView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _clippingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _clippingView.clipsToBounds = YES;
    _clippingView.autoresizesSubviews = NO;
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:_clippingView];
    [self addSubview:_backButton];
  }
  return self;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  
  _clippingView.frame = self.bounds;
  _scanView.frame = self.bounds;
  [_scanView layoutSubviews];
  
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone && _clippingView.frame.size.height > _clippingView.frame.size.width) {
    _clippingView.frame = CGRectMake(0, 0, _clippingView.frame.size.width, 300);
  }
  _scanView.center = CGPointMake(_clippingView.bounds.size.width * 0.5, _clippingView.bounds.size.height * 0.5);
  _backButton.frame = CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44);
  if (@available(iOS 11.0, *)) {
    if (self.safeAreaInsets.bottom > 0) {
      _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 72 - self.safeAreaInsets.bottom);
    } else {
      _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 62);
    }
  } else {
    _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 62);
  }
}

-(void)setScanView:(UIView *)scanView {
  _scanView = scanView;
  [_clippingView addSubview:scanView];
}


@end


@implementation CardKViewController {
  BOOL _allowSaveBinding;
  ScanViewWrapper *_scanViewWrapper;
  CardKBankLogoView *_bankLogoView;
  CardKCardNumberTextField *_cardNumberCell;
  CardKExpireDateTextField *_expireDateTextField;
  CardKCVCTextField *_cvcTextField;
  CardKButtonView *_doneButton;
  NSMutableArray *_sections;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  CardKSwitchView *_switchView;
  VerifyCompaniesView *_verifyCompanies;
}


- (instancetype)init {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _bundle = [NSBundle bundleForClass:[CardKViewController class]];

    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }

    _bankLogoView = [[CardKBankLogoView alloc] init];

    _cardNumberCell = [[CardKCardNumberTextField alloc] init];
    [_cardNumberCell addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    [_cardNumberCell addTarget:self action:@selector(_switchToExpireDate) forControlEvents:UIControlEventEditingDidEndOnExit];


    _expireDateTextField = [[CardKExpireDateTextField alloc] init];
    [_expireDateTextField addTarget:self action:@selector(_switchToSecureCode) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _cvcTextField = [[CardKCVCTextField alloc] init];


    _doneButton = [[CardKButtonView alloc] init];
    _doneButton.tag = 30005;
    [_doneButton
      setTitle: NSLocalizedStringFromTableInBundle(@"doneButton", nil, _languageBundle, "Submit payment button")
      forState: UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 200, 44);

    [_doneButton addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];

    _switchView = [[CardKSwitchView alloc] init];
    _switchView.tag = 30004;
    _sections = [self _defaultSections];
    
    self.tableView.backgroundColor = CardKConfig.shared.theme.colorTableBackground;
    self.view.backgroundColor = CardKConfig.shared.theme.colorTableBackground;
  }
  
  return self;
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  if (self.view.frame.size.height > 400) {
    _verifyCompanies.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 50);
  } else {
    _verifyCompanies.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.frame.size.width, 50);
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
}

+(UIViewController *) create:(id<CardKDelegate>)cardKViewControllerDelegate controller:(CardKViewController *) controller {
  
  
  CardKKindPaymentViewController *cardKKindPaymentViewController = [[CardKKindPaymentViewController alloc] init];
  cardKKindPaymentViewController.cKitDelegate = cardKViewControllerDelegate;

  
  return cardKKindPaymentViewController;
}

- (NSMutableArray *)_defaultSections {
  NSArray *sections = @[
    @{CardKRows: @[CardKBankLogoCellID]},
    @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"card", nil, _languageBundle, @"Card section title"), CardKRows: @[CardKCardCellID]},
    @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"cardholder", nil, _languageBundle, @"Cardholder section title"), CardKRows: @[CardKCVCAndExpireDateCellID]},
    @{CardKRows: @[CardKButtonCellID]},
  ];
  
  NSMutableArray *defaultSections = [[NSMutableArray alloc] initWithCapacity:3];
  
  [defaultSections setArray:sections];

  return defaultSections;
}

- (void)_animateError {
  [_doneButton animateError];
}


- (void)setAllowedCardScaner:(BOOL)allowedCardScaner {
  _cardNumberCell.allowedCardScaner = allowedCardScaner;
  
  if (allowedCardScaner) {
    [_cardNumberCell.scanCardTapRecognizer addTarget:self action:@selector(_scanCard:)];
  }
}

- (BOOL)allowedCardScaner {
  return _cardNumberCell.allowedCardScaner;
}

- (void)setAllowSaveBinding:(BOOL)allowSaveBinding {
  if (allowSaveBinding) {
    [_sections insertObject:@{CardKRows: @[CardKSwitchCellID]} atIndex:[_sections count] - 1];
  }
  _allowSaveBinding = allowSaveBinding;
}

- (BOOL)allowSaveBinding {
  return _allowSaveBinding;
}

- (void)setIsSaveBinding:(BOOL)isSaveBinding {
  _switchView.isSaveBinding = isSaveBinding;
}

- (BOOL)isSaveBinding {
  return self.isSaveBinding;
}

- (void)_cardChanged {
  NSString *number = _cardNumberCell.number;
  [_bankLogoView fetchBankInfo: CardKConfig.shared.mrBinApiURL cardNumber: number];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_cKitDelegate didLoadController:self];
  
  CardKTheme *theme = CardKConfig.shared.theme;
  
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;

  self.tableView.tableHeaderView.frame = CGRectMake(20, 0, 40, 40);
  
  for (NSString *cellID in @[CardKBankLogoCellID, CardKCardCellID, CardKCVCAndExpireDateCellID, CardKButtonCellID, CardKSwitchCellID]) {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:CardKFooterID];
  
  self.title = NSLocalizedStringFromTableInBundle(@"payment", nil, _languageBundle, "payment");
  
  
  [_cardNumberCell becomeFirstResponder];
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{NSForegroundColorAttributeName:theme.colorLabel}];
  
    _verifyCompanies = [[VerifyCompaniesView alloc] init];

    [self.view addSubview:_verifyCompanies];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [self.tableView reloadData];
}

- (NSString *)purchaseButtonTitle {
  return _doneButton.currentTitle;
}

- (void)setPurchaseButtonTitle:(NSString *)purchaseButtonTitle {
  [_doneButton setTitle:purchaseButtonTitle forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  [[self navigationController] setNavigationBarHidden:NO animated:YES];
  self.navigationItem.backBarButtonItem.tintColor = CardKConfig.shared.theme.colorLabel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections[section][CardKRows] count];
}

- (void)_centeredViewForIpad: (UIView *) view center:(CGPoint) center {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    view.center = center;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CardKTheme *theme = CardKConfig.shared.theme;
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
  CGSize size = self.view.bounds.size;
  CGPoint center = CGPointMake(cell.frame.size.width / 2, cell.contentView.frame.size.height / 2);

  
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad && size.width > 468) {
    cell.contentView.frame = CGRectMake(0, 0, 468, cell.contentView.frame.size.height);
  }
  
  NSInteger width = cell.contentView.bounds.size.width;
  NSInteger height = cell.contentView.bounds.size.height;

  if ([CardKBankLogoCellID isEqual:cellID]) {
    UIView *mainContainer  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _bankLogoView.frame = CGRectMake(20, 0, 40, 40);
    _bankLogoView.title = @"";
    
    [mainContainer addSubview:_bankLogoView];
      
    [self _centeredViewForIpad:mainContainer center:center];
    [cell.contentView addSubview:mainContainer];
  } else if ([CardKCardCellID isEqual:cellID]) {
    UIView *cardNumberCellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _cardNumberCell.frame = CGRectMake(20, 0, width - 40, height);
    [cardNumberCellContainer addSubview:_cardNumberCell];
    
    [self _centeredViewForIpad:_cardNumberCell center:center];

    [cell.contentView addSubview:cardNumberCellContainer];
  } else if ([CardKCVCAndExpireDateCellID isEqual:cellID]) {
    UIView *mainContainer  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    UIView *expireView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, width / 2 - 40, height)];
    
    [expireView addSubview:_expireDateTextField];
    _expireDateTextField.frame = CGRectMake(0, 0, expireView.frame.size.width, height);
    [mainContainer addSubview:expireView];
    
    UIView *cvcView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(expireView.frame) + 20, 0, width / 2 - 20, height)];
    _cvcTextField.frame = CGRectMake(0, 0, cvcView.frame.size.width, height);
    [cvcView addSubview:_cvcTextField];
    [mainContainer addSubview:cvcView];
    
    [self _centeredViewForIpad:mainContainer center:center];

    [cell.contentView addSubview:mainContainer];
  } else if ([CardKButtonCellID isEqual:cellID]) {
    _doneButton.frame = CGRectMake(20, 0, width - 40, height);
    [self _centeredViewForIpad:_doneButton center:center];

    [cell.contentView addSubview:_doneButton];
  } else if ([CardKSwitchCellID isEqual:cellID]) {
    _switchView.frame = CGRectMake(20, 0, width - 40, height);
    
    [self _centeredViewForIpad:_switchView center:center];

    [cell.contentView addSubview:_switchView];
  }
  
  if (theme.colorCellBackground != nil) {
    cell.backgroundColor = theme.colorCellBackground;
  }
  

  cell.textLabel.textColor = theme.colorLabel;
  return cell;
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row];
  if ([CardKButtonCellID isEqual:cellID]) {
    return 50;
  } else if ([CardKSwitchCellID isEqual:cellID]) {
    return 40;
  } else if ([CardKBankLogoCellID isEqual:cellID]) {
    return 40;
  }
  
  return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
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

- (void)_switchToExpireDate {
  [_expireDateTextField becomeFirstResponder];
}

- (void)_switchToSecureCode {
  [_cvcTextField becomeFirstResponder];
}

- (BOOL)_isFormValid {
  return [_cardNumberCell validate] && [_cvcTextField validate] && [_expireDateTextField validate];
}

- (void)_buttonPressed:(UIButton *)button {
  if (![self _isFormValid]) {
    [self _animateError];
    [Logger logWithClass:[CardKViewController class]
          tag:TAG message:[NSString stringWithFormat:@"The new card from is not valid"]
          exception:nil];
    return;
  }
  
  CKCCardParams *ckcCardParams = [[CKCCardParams alloc] init];

  ckcCardParams.pan = [_cardNumberCell number];
  ckcCardParams.cvc = _cvcTextField.secureCode;
  ckcCardParams.expiryMMYY = _expireDateTextField.expirationDate;
  ckcCardParams.mdOrder = CardKConfig.shared.mdOrder;
  ckcCardParams.pubKey = CardKConfig.shared.pubKey;


  CKCTokenResult *seToken = [CKCToken generateWithCard:ckcCardParams];
  [Logger logWithClass:[CardKViewController class]
          tag:TAG message:[NSString stringWithFormat:@"Generate seToken:  %@", seToken.token]
          exception:nil];

  [_cKitDelegate cardKitViewController:self didCreateSeToken:seToken.token allowSaveBinding: _switchView.getSwitch.isOn isNewCard: YES];
  
}

- (void)_scanCard:(UITapGestureRecognizer *)gestureRecognizer {
  if (_cardNumberCell.allowedCardScaner && _cardNumberCell.number.length != 0) {
    return;
  }
  
  [_cardNumberCell resignFirstResponder];
  
  
  [Logger logWithClass:[CardKViewController class]
        tag:TAG message:[NSString stringWithFormat:@"Call cardKitViewControllerScanCardRequest delegate"]
        exception:nil];
  
  [_cKitDelegate cardKitViewControllerScanCardRequest:self];
}

- (CardKCard *)getCard {
  CardKCard *card = [[CardKCard alloc] init];
  
  card.cardNumber = _cardNumberCell.number;
  card.secureCode = _cvcTextField.secureCode;
  card.expireDate = _expireDateTextField.expirationDate;

  return card;
}

- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc bindingId:(nullable NSString *)bindingId {
  if (holderName.length > 0) {
    _cardNumberCell.number = number;
  }
  
  if (date.length > 0) {
    _expireDateTextField.expirationDate = date;
  }
  
  if (cvc.length > 0) {
    _cvcTextField.secureCode = cvc;
  }
  
  if (bindingId.length > 0) {
    _cardNumberCell.bindingId = bindingId;
  }
  
  [_scanViewWrapper removeFromSuperview];
}

- (void)showScanCardView:(UIView *)view animated:(BOOL)animated {
  CardKTheme *theme = CardKConfig.shared.theme;
  
  _scanViewWrapper = [[ScanViewWrapper alloc] initWithFrame:self.view.bounds];
  _scanViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _scanViewWrapper.backgroundColor = theme.colorTableBackground;
  _scanViewWrapper.scanView = view;
  _scanViewWrapper.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
  [_scanViewWrapper.backButton
    setTitle: NSLocalizedStringFromTableInBundle(@"scanBackButton", nil, _languageBundle, "scanBackButton")
    forState:UIControlStateNormal
  ];
  
  [_scanViewWrapper.backButton addTarget:self action:@selector(_cancelScan) forControlEvents:UIControlEventTouchUpInside];
  
  _scanViewWrapper.alpha = 0;
  [self.view addSubview:_scanViewWrapper];
  
  [UIView animateWithDuration:0.4 animations:^{
    self->_scanViewWrapper.alpha = 1;
  }];
}

- (void)_cancelScan {
  _scanViewWrapper.alpha = 1;
  [UIView animateWithDuration:0.3 animations:^{
    self->_scanViewWrapper.alpha = 0;
  } completion:^(BOOL finished) {
    [self->_scanViewWrapper removeFromSuperview];
    self->_scanViewWrapper = nil;
  }];
}

@end
