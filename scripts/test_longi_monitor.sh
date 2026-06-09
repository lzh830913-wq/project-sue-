#!/bin/bash
# 隆基绿能底部放量监控测试脚本
# 用 web_fetch 方式验证数据源

echo "=== 隆基绿能(601012) 实时行情 ==="
echo ""

# 字段说明:
# f43: 最新价, f44: 最高价, f45: 最低价, f46: 开盘价, f47: 成交量(手)
# f48: 成交额, f50: 量比, f51: 涨停价, f52: 跌停价
# f57: 代码, f58: 名称, f60: 昨收
# f116: 总市值, f117: 流通市值
# f169: 换手率, f170: 振幅

API="https://push2.eastmoney.com/api/qt/stock/get?secid=1.601012&fields=f43,f44,f45,f46,f47,f48,f50,f51,f52,f57,f58,f60,f116,f117,f169,f170"

echo "请求URL: $API"
echo ""
echo "(请在OpenClaw环境中用web_fetch调用此URL)"
echo ""
echo "---"
echo "历史均量API:"
echo "https://push2.eastmoney.com/api/qt/stock/kline/get?secid=1.601012&fields1=f1,f2,f3,f4,f5,f6&fields2=f51,f52,f53,f54,f55,f56,f57,f58,f59,f60,f61&klt=101&fqt=0&end=20500101&lmt=30"
echo ""
echo "这个返回30个交易日的K线数据，f5=成交量，可以用来算20日均量"
