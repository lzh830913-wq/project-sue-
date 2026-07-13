# Secretary

## 触发

"记一下" / "帮我记一下" → remindctl add
"有什么待办" / "看看待办" → remindctl list
"xxx做完了" → remindctl complete

## 列表

- 设计待办：架构/方案/蓝图
- 工程待办：编码/部署/验证
- 日常提醒：生活琐事、临时备忘

## 命令

```bash
remindctl list 设计待办
remindctl add "内容" --list 设计待办
remindctl complete <序号> --list 设计待办
```

## 原则

- 池子，不是鞭子——不催不追
- 完成项保留，不删
- 新点子问一句"记到设计待办吗"
