# ScrollRefresh
MJRefresh的swift简单版

##  实现效果
![screenShot](https://github.com/guiqiang107/ScrollRefresh/blob/master/ScrollViewRefresh-swift.gif)

##  目录结构
![2EE2C947-0CA9-4D53-8902-43C129E69011.png](http://upload-images.jianshu.io/upload_images/3286073-fe738729198c221a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##  用法
- 创建普通的箭头下拉刷新
```
//普通下拉刷新
self.tableView.refreshHeader = RefreshNormalHeader.headerWithRefreshingBlock {

// 定义刷新事件
self.headerRefresh()
}
```
```
// 结束刷新
self.tableView.refreshHeader?.endRefreshing()
```

- 创建自定义gif动图下拉刷新
```
// 自定义gif动图下拉刷新
self.tableView.refreshHeader = RefreshGifHeader.headerWithRefreshingBlock {

// 定义刷新事件
self.headerRefresh()
}
```
```
// 结束刷新
self.tableView.refreshHeader?.endRefreshing()
```
- 创建普通上拉加载
```
//普通上拉加载
self.tableView.refreshFooter = RefreshNormalFooter.footerWithRefreshingBlock {

// 定义加载事件
self.footerRefresh()
}
```
```
//  结束加载
self.tableView.refreshFooter?.endRefreshing()
```
```
//  加载完毕,没有更多数据了
self.tableView.refreshFooter?.setNoMoreData(noMoreData: true)
```
```
//  重置加载完毕
self.tableView.refreshFooter?.setNoMoreData(noMoreData: false)
```

## 自定义gif动图下拉刷新具体实现(一般根据自己的设计重新实现）
```
public class RefreshGifHeader: RefreshHeader {

// 下拉实现动画视图
lazy var imageView: UIImageView = {
let animateImageView = UIImageView()
animateImageView.image = UIImage(named: "dropdown_loading_01@2x.png")
return animateImageView
}()

//创建UI
override init(frame: CGRect) {
super.init(frame: frame)
self.addSubview(self.imageView)
}

required public init?(coder aDecoder: NSCoder) {
fatalError("init(coder:) has not been implemented")
}

//初始化
override func prepare() {
super.prepare()
self.height = 70
}

//布局
override func placeSubviews() {
super.placeSubviews()
self.imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
self.imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
}

//根据刷新的状态定义相关动画
override var state: RefreshState{
didSet{

super.state = state
//  正在刷新的动画
if(state == .refreshing){
let images = ["dropdown_loading_01","dropdown_loading_02","dropdown_loading_03"].map { (name) -> UIImage in
return UIImage(named:name)!
}
self.imageView.animationImages = images
self.imageView.animationDuration = Double(images.count) * 0.15
self.imageView.startAnimating()
}
}
}


/// 下拉时，根据下拉百分比实现动画
override var pullingPercent: CGFloat{
didSet{
let mappedIndex = Int(self.pullingPercent * 60)
let imageName = "dropdown_anim__000\(mappedIndex)"
let image = UIImage(named: imageName)
self.imageView.image = image
}
}

/// 结束刷新时,实现相关动画
override func endRefreshing() {
super.endRefreshing()
self.imageView.stopAnimating()
self.imageView.image = UIImage(named: "dropdown_loading_01@2x.png")
}
}
```

> `ScrollRefresh`是根据oc版的`MJRefresh`实现的swift基础版的下拉刷新控件:,详情请点击：[Demo地址](https://github.com/guiqiang107/ScrollRefresh)

