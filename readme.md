# POS Tag Highlight

POS Tag Highlight 是一个 Emacs 插件,用于使用词性(POS)标注来高亮显示文本中的介词和动词。

## 主要功能

1. **词性标注**: 使用 spaCy 库对文本进行词性标注。
2. **高亮显示**: 根据词性标注结果,高亮显示文本中的介词和动词。

## 安装

1. 确保你的系统中安装了 Python 和 pip。
2. 将 `pos-tag-highlight.el` 和 `pos-tagger.py` 文件放置在你的 Emacs 加载路径中。
3. 在你的 Emacs 配置文件中添加以下内容:

   ```elisp
   (require 'pos-tag-highlight)
   ```

## 使用方法

1. 激活 `pos-tag-highlight-mode` 次要模式:

   ```
   M-x pos-tag-highlight-mode
   ```

2. 使用以下快捷键或 M-x 命令执行高亮操作:
   - `C-c p h b`: 高亮整个缓冲区
   - `C-c p h r`: 高亮选定区域
   - `C-c p h c`: 清除所有高亮

## 主要命令

- `pos-tag-highlight-buffer`: 高亮整个缓冲区中的介词和动词。
- `pos-tag-highlight-region`: 高亮选定区域中的介词和动词。
- `pos-tag-highlight-remove-all-properties`: 移除所有高亮效果。

## 自定义选项

你可以通过自定义以下变量来修改插件的行为:

- `pos-tag-highlight-python-command`: Python 命令路径。
- `pos-tag-highlight-python-script-path`: Python 脚本路径。
- `pos-tag-highlight-face`: 高亮显示的样式。

## 技术实现

1. **Elisp 部分** (`pos-tag-highlight.el`):
   - 定义了插件的主要功能和用户界面。
   - 通过调用外部 Python 脚本来执行词性标注。
   - 处理标注结果并应用高亮效果。

2. **Python 部分** (`pos-tagger.py`):
   - 使用 spaCy 库进行词性标注。
   - 自动安装所需的 Python 包和语言模型。
   - 处理输入文本并返回标注结果。

## 贡献

欢迎提交 issues 和 pull requests 来帮助改进这个项目。

## 许可证

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。
