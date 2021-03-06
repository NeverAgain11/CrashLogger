//
//  DoraemonCrashListViewController.m
//  DoraemonKit
//
//  Created by wenquan on 2018/11/22.
//

#import "STCrashListViewController.h"
#import "STCrashListCell.h"
//#import "DoraemonSanboxDetailViewController.h"
#import "STSandboxModel.h"
#import "DoraemonCrashTool.h"

static NSString *const kDoraemonCrashListCellIdentifier = @"kDoraemonCrashListCellIdentifier";

@interface STCrashListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<STSandboxModel *> *dataArray;

@end

@implementation STCrashListViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self commonInit];
    
    [self loadCrashData];
}

- (void)commonInit {
    self.dataArray = [NSArray array];
    
    self.title = @"Crash日志列表";
    [self.view addSubview:self.tableView];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
}

#pragma mark - Private

#pragma mark CrashData

- (void)loadCrashData {
    // 获取crash目录
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *crashDirectory = [DoraemonCrashTool crashDirectory];
    
    if (crashDirectory && [manager fileExistsAtPath:crashDirectory]) {
        [self loadPath:crashDirectory];
    }
}

- (void)loadPath:(NSString *)filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *targetPath = NSHomeDirectory();
    if ([filePath isKindOfClass:[NSString class]] && (filePath.length > 0)) {
        targetPath = filePath;
    }
    
    //该目录下面的内容信息
    NSError *error = nil;
    NSArray *paths = [fm contentsOfDirectoryAtPath:targetPath error:&error];
    
    // 对paths按照创建时间的降序进行排列
    NSArray *sortedPaths = [paths sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
            // 获取文件完整路径
            NSString *firstPath = [targetPath stringByAppendingPathComponent:obj1];
            NSString *secondPath = [targetPath stringByAppendingPathComponent:obj2];
            
            // 获取文件信息
            NSDictionary *firstFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firstPath error:nil];
            NSDictionary *secondFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secondPath error:nil];
            
            // 获取文件创建时间
            id firstData = [firstFileInfo objectForKey:NSFileCreationDate];
            id secondData = [secondFileInfo objectForKey:NSFileCreationDate];
            
            // 按照创建时间降序排列
            return [secondData compare:firstData];
        }
        return NSOrderedSame;
    }];
    
    // 构造数据源
    NSMutableArray *files = [NSMutableArray array];
    [sortedPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *sortedPath = obj;
            
            BOOL isDir = false;
            NSString *fullPath = [targetPath stringByAppendingPathComponent:sortedPath];
            [fm fileExistsAtPath:fullPath isDirectory:&isDir];
            
            STSandboxModel *model = [[STSandboxModel alloc] init];
            model.path = fullPath;
            if (isDir) {
                model.type = DoraemonSandboxFileTypeDirectory;
            }else{
                model.type = DoraemonSandboxFileTypeFile;
            }
            model.name = sortedPath;
            
            [files addObject:model];
        }
    }];
    self.dataArray = files.copy;
    
    [self.tableView reloadData];
}

- (void)deleteByDoraemonSandboxModel:(STSandboxModel *)model{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:model.path error:nil];
    
    [self loadCrashData];
}

#pragma mark HandleFile

- (BOOL)isIpad{
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

- (void)handleFileWithPath:(NSString *)filePath{
    UIAlertControllerStyle style;
    if ([self isIpad]) {
        style = UIAlertControllerStyleAlert;
    }else{
        style = UIAlertControllerStyleActionSheet;
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择操作方式" message:nil preferredStyle:style];
    __weak typeof(self) weakSelf = self;
//    UIAlertAction *previewAction = [UIAlertAction actionWithTitle:@"本地预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        __strong typeof(self) strongSelf = weakSelf;
//        [strongSelf previewFile:filePath];
//    }];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf shareFileWithPath:filePath];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
//    [alertVc addAction:previewAction];
    [alertVc addAction:shareAction];
    [alertVc addAction:cancelAction];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)previewFile:(NSString *)filePath{
//    DoraemonSanboxDetailViewController *detalVc = [[DoraemonSanboxDetailViewController alloc] init];
//    detalVc.filePath = filePath;
//    [self.navigationController pushViewController:detalVc animated:YES];
}

- (void)shareFileWithPath:(NSString *)filePath{
    [self shareURL:[NSURL fileURLWithPath:filePath] formVC:self];
}
//share url
- (void)shareURL:(NSURL *)url formVC:(UIViewController *)vc{
    [self share:url formVC:vc];
}

- (void)share:(id)object formVC:(UIViewController *)vc{
    if (!object) {
        return;
    }
    NSArray *objectsToShare = @[object];//support NSString、NSURL、UIImage

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    if([self isIpad]){
        if ( [controller respondsToSelector:@selector(popoverPresentationController)] ) {
            controller.popoverPresentationController.sourceView = vc.view;
        }
        [vc presentViewController:controller animated:YES completion:nil];
    }else{
        [vc presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - Delegate

#pragma mark <UITableViewDataSource>

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STCrashListCell *cell = [tableView dequeueReusableCellWithIdentifier:kDoraemonCrashListCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[STCrashListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDoraemonCrashListCellIdentifier];
    }
    
    if (indexPath.row < self.dataArray.count) {
        STSandboxModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell renderUIWithData:model];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [STCrashListCell cellHeight];
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        STSandboxModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if (model.type == DoraemonSandboxFileTypeFile) {
            [self handleFileWithPath:model.path];
        }else if(model.type == DoraemonSandboxFileTypeDirectory){
            [self loadPath:model.path];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArray.count) {
        STSandboxModel *model = self.dataArray[indexPath.row];
        [self deleteByDoraemonSandboxModel:model];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[STCrashListCell class] forCellReuseIdentifier:kDoraemonCrashListCellIdentifier];
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
