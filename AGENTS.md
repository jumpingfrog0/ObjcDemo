## 删除安全规则（macOS）

不要自动执行批量删除或递归删除文件/目录的命令，除非用户在执行前明确同意。

未经明确同意，禁止使用：

- `rm -r`
  - 递归删除目录及其内容。

- `rm -rf`
  - 强制递归删除目录及其内容，风险更高。

- `find ... -delete`
  - 按条件批量查找并删除文件。

- `find ... -exec rm`
  - 按条件批量查找并调用 `rm` 删除文件。

同时禁止未经确认使用：
- 带通配符的删除命令，例如 `rm *.log`
- 范围过宽的路径，例如当前目录、项目根目录、用户目录
- 任何等价的批量删除或递归删除命令

如果需要删除文件，只能一次删除一个明确路径的文件。

允许示例：

```bash
rm "/path/to/file.txt"
```

## 构建规则（Xcode / iOS Simulator）

在本项目中运行 `xcodebuild` 构建、列出 scheme、访问模拟器或检查 iOS Simulator 产物时，默认需要在沙箱外执行，并申请 `require_escalated`。

原因：`xcodebuild` 会访问 Xcode、CoreSimulator、用户级 DerivedData、日志目录和模拟器服务；在沙箱内执行经常会因为 CoreSimulator 日志目录、DerivedData 写入或 simulator service 访问权限失败。

优先使用已授权的 `xcodebuild` 前缀规则；如果没有授权，则在执行前申请用户批准。
