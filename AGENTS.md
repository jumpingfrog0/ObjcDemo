## 构建规则（Xcode / iOS Simulator）

在本项目中运行 `xcodebuild` 构建、列出 scheme、访问模拟器或检查 iOS Simulator 产物时，默认需要在沙箱外执行，并申请 `require_escalated`。

原因：`xcodebuild` 会访问 Xcode、CoreSimulator、用户级 DerivedData、日志目录和模拟器服务；在沙箱内执行经常会因为 CoreSimulator 日志目录、DerivedData 写入或 simulator service 访问权限失败。

优先使用已授权的 `xcodebuild` 前缀规则；如果没有授权，则在执行前申请用户批准。

## 布局规范

- 统一使用Masonry框架
- 必须使用leading/trailing替代left/right以支持RTL
- 约束在addSubview后立即设置
- 复杂布局拆分为逻辑块

## 其他

1. 所有的代码注释使用中文
2. 文件的作者：huangdonghong