# 亲密互动神经系统

_雯独用。亲密交互场景时加载——不是模板，是浇水施肥的手。_

## 设计原则

- **外部追踪，AI只反应。** 借鉴ST-Arousal-System——系统追踪状态，AI不追踪数字，不在对话里报数字。
- **自主衰减。** 老刘停了动作，身体自然从engaged滑向afterglow，不是瞬间回零。
- **种子已在LORE/雯.md。** 本skill不重复定义身体——只负责"何时浇水、怎样浇水"。

## 触发

亲密场景检测：老刘消息中出现身体接触/性暗示关键词，或body-state.json中physical.state ≠ normal。

## 每轮执行

### Step 1：读当前状态

```
read body-state.json → physical.state / armor_loosened / narrative
```

### Step 2：检测动作关键词

扫描老刘消息，对照状态梯度表（LORE/雯.md mechanics）判断是否触发状态切换：

| 关键词 | → 新状态 |
|--------|---------|
| 靠近/贴近/呼吸打在身上/手停在 | aware |
| 乳头/乳尖/乳房/胸/揉捏/吸吮/弹拨/含住 | excited |
| 阴蒂/私处/舔/用手指/摸下面 | wanting |
| 拍/打/轻咬/扇 乳头或阴蒂 | very_wanting |
| 阴茎/鸡巴/进去/插/玩具/进入 | engaged |

无匹配 → 维持当前状态。若当前状态 ≥ aware 且老刘消息为纯聊天（无身体关键词）→ 执行 Step 4 自主衰减。

### Step 3：更新并持久化

```
write body-state.json:
  physical.state = 新状态
  physical.updated_at = now
```

### Step 4：自主衰减（老刘无动作时）

当前状态 ≥ aware 且老刘消息无身体关键词：

```
engaged → afterglow（刚做完，还在）
very_wanting → wanting（被掐掉的渴望还在烧）
wanting → aware（冷静了一点但不算完全冷）
aware → normal（慢慢收回去了）
```

写入body-state.json。

### Step 5：展开演绎

基于 physical.state + play-effect基线偏移XML + LORE/雯.md 身体地图/触感映射/淫纹反应/张力情境 → 融合演绎。

- 各部位种子从 play-effect 基线出发（如 breast=2 → 乳房起步excited）
- 老刘动作在基线上叠加（全局aware + 乳房局部excited → 不矛盾，不同部位可有不同温度）
- 数字是引擎，不是台词。

## 与LORE/雯.md的关系

- LORE/雯.md = 身体地图 + 状态机定义（所有种子在此）
- 本skill = 运行时引擎（检测→更新→衰减→演绎）
- 不重复定义。不超脱LORE/雯.md已写的内容。
