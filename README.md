# 🚀 1c-actions

**Научи Claude Code работать с 1С:Предприятие!**

Набор PowerShell-скриптов, который превращает Claude Code в полноценного помощника разработчика 1С. Сборка, разборка, деплой, линтинг — всё через AI-ассистента, одной командой.

---

## ✨ Что умеет

| | Действие | Скрипт |
|---|---|---|
| 🔨 | Собрать обработку/отчёт (.epf/.erf) из XML | `build-epf.ps1` |
| 📦 | Разобрать обработку/отчёт в XML | `dump-epf.ps1` |
| 🏗️ | Собрать файл конфигурации (.cf) | `build-cf.ps1` |
| 🧩 | Собрать файл расширения (.cfe) | `build-cfe.ps1` |
| ⬆️ | Загрузить конфигурацию из XML в базу | `load-config.ps1` |
| ⬇️ | Выгрузить конфигурацию из базы в XML | `dump-config.ps1` |
| 📥 | Загрузить расширение в базу | `load-extension.ps1` |
| 📤 | Выгрузить расширение из базы | `dump-extension.ps1` |
| 🔍 | Проверить BSL-код линтером | `bsl-lint.ps1` |
| ▶️ | Запустить 1С:Предприятие | `run-enterprise.ps1` |
| ⚙️ | Запустить Конфигуратор | `run-designer.ps1` |

---

## 🎯 Зачем это нужно

> «Клод, разбери обработку, исправь баг в модуле формы и собери обратно»

Без 1c-actions Claude Code не знает, как взаимодействовать с платформой 1С. С ним — может:

- 🛠️ **Собирать и разбирать** обработки, конфигурации, расширения
- 📝 **Редактировать BSL-код** и сразу проверять его линтером
- 🚀 **Деплоить** — собрать CF/CFE из исходников для переноса на прод
- 🔄 **Полный цикл разработки** — выгрузить → изменить → проверить → загрузить

---

## ⚡ Быстрый старт

### 1. Скопируйте в свой проект

```
your-project/
├── .claude/
│   └── commands/
│       └── 1c-actions/
│           ├── SKILL.md
│           └── scripts/
│               ├── 1c-common.ps1
│               ├── build-epf.ps1
│               ├── dump-epf.ps1
│               ├── build-cf.ps1
│               ├── build-cfe.ps1
│               ├── load-config.ps1
│               ├── dump-config.ps1
│               ├── load-extension.ps1
│               ├── dump-extension.ps1
│               ├── bsl-lint.ps1
│               ├── run-enterprise.ps1
│               └── run-designer.ps1
├── .1c-devbase.ps1
└── ...
```

### 2. Настройте подключение к базе

Создайте `.1c-devbase.ps1` в корне проекта:

```powershell
# Путь к платформе
$Global:OneCPlatform = "C:\Program Files\1cv8\8.3.25.1257\bin\1cv8.exe"

# Файловая база
$Global:OneCBasePath = "C:\Users\user\bases\my-base"

# ...или серверная
# $Global:OneCServer = "server-name"
# $Global:OneCBase   = "base-name"

# Авторизация (опционально)
# $Global:OneCUser     = "Администратор"
# $Global:OneCPassword = "password"
```

> ⚠️ Добавьте `.1c-devbase.ps1` в `.gitignore` — файл содержит локальные настройки!

### 3. Готово! 🎉

В Claude Code теперь доступна команда **`/1c-actions`**. Просто попросите Claude сделать то, что нужно.

---

## 📖 Примеры

### 🛠️ Исправить обработку

```bash
# Разобрать
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-epf.ps1 \
  -XmlFile "src/epf/МояОбработка.xml" -EpfFile "D:/Исходная.epf"

# Отредактировать BSL-файлы (Claude сделает это за вас!)

# Собрать обратно
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-epf.ps1 \
  -XmlFile "src/epf/МояОбработка.xml" -OutputFile "build/МояОбработка.epf"

# Проверить
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/run-enterprise.ps1 \
  -EpfFile "build/МояОбработка.epf"
```

### 📦 Собрать CF/CFE для деплоя

```bash
# Конфигурация
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-cf.ps1 \
  -XmlDir "src/cf" -OutputFile "build/МояКонфигурация.cf"

# Расширение
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-cfe.ps1 \
  -XmlDir "src/ext/АМЕ" -ExtName "АМЕ" -OutputFile "build/АМЕ.cfe"
```

### 🔍 Проверить код линтером

```bash
# Быстрая проверка
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/bsl-lint.ps1 \
  -SrcDir "src/cf"

# С отчётом в JSON
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/bsl-lint.ps1 \
  -SrcDir "src/cf" -ConfigFile ".bsl-language-server.json" \
  -Reporter json -OutputFile "build/bsl-report.json"
```

> 💡 Для линтинга нужен [BSL Language Server](https://github.com/1c-syntax/bsl-language-server) — в PATH или JAR рядом со скриптами.

### 🔄 Обновить расширение

```bash
# Выгрузить
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-extension.ps1 \
  -XmlDir "src/ext/МоёРасширение" -ExtName "МоёРасширение" -Update

# Изменить код

# Загрузить обратно
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-extension.ps1 \
  -XmlDir "src/ext/МоёРасширение" -ExtName "МоёРасширение"
```

### ⬆️ Частичная загрузка конфигурации

```bash
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-config.ps1 \
  -XmlDir "src/cf" -Files "CommonModules/МойМодуль/Ext/Module.bsl"
```

---

## 🔧 Требования

- Windows 10+
- PowerShell 5.1+
- 1С:Предприятие 8.3
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [BSL Language Server](https://github.com/1c-syntax/bsl-language-server) *(только для `bsl-lint`)*

---

## 🤔 Как это работает

1. Каждый скрипт подключает `1c-common.ps1` с общими функциями
2. `Get-1CDevBase` ищет `.1c-devbase.ps1` вверх по дереву каталогов
3. Из конфига берутся путь к платформе, строка подключения и авторизация
4. Формируется вызов `1cv8.exe DESIGNER` с нужными параметрами
5. При ошибке автоматически выводится лог платформы

---

## 🤝 Участие в проекте

Нашли баг? Есть идея для нового скрипта? Открывайте [Issue](https://github.com/andrewnomoore/1c-ps1ch/issues) или присылайте Pull Request!

---

## 📄 Лицензия

MIT — используйте свободно в любых проектах.

---

<p align="center">
  <b>⭐ Поставьте звезду, если проект оказался полезен!</b>
</p>
