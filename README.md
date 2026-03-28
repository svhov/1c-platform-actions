# 1c-batch

Набор PowerShell-скриптов для пакетных операций с платформой 1С:Предприятие 8 через Claude Code (slash command / MCP skill).

Позволяет AI-ассистенту Claude Code выполнять типовые операции с базой 1С в пакетном режиме: собирать и разбирать внешние обработки, загружать и выгружать конфигурации и расширения, запускать предприятие и конфигуратор.

## Возможности

- **build-epf** — сборка внешней обработки/отчёта (.epf/.erf) из XML
- **dump-epf** — разборка обработки/отчёта в XML
- **load-config** — загрузка конфигурации из XML в базу (полная/частичная)
- **dump-config** — выгрузка конфигурации из базы в XML (полная/инкрементальная)
- **load-extension** — загрузка расширения из XML в базу
- **dump-extension** — выгрузка расширения из базы в XML
- **run-enterprise** — запуск 1С:Предприятие
- **run-designer** — запуск Конфигуратора

## Требования

- Windows 10+
- PowerShell 5.1+
- Платформа 1С:Предприятие 8.3 (путь к `1cv8.exe` задаётся в конфиге)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

## Установка

### Как slash command в Claude Code

Скопируйте содержимое репозитория в `.claude/commands/1c-batch/` вашего проекта:

```
your-project/
├── .claude/
│   └── commands/
│       └── 1c-batch/
│           ├── SKILL.md          # описание команды для Claude
│           └── scripts/
│               ├── 1c-common.ps1
│               ├── build-epf.ps1
│               ├── dump-epf.ps1
│               ├── load-config.ps1
│               ├── dump-config.ps1
│               ├── load-extension.ps1
│               ├── dump-extension.ps1
│               ├── run-enterprise.ps1
│               └── run-designer.ps1
├── .1c-devbase.ps1               # настройки подключения к базе
└── ...
```

После этого в Claude Code станет доступна команда `/1c-batch`.

## Настройка подключения

Создайте файл `.1c-devbase.ps1` в корне проекта:

```powershell
# Путь к платформе
$Global:OneCPlatform = "C:\Program Files\1cv8\8.3.25.1257\bin\1cv8.exe"

# Вариант 1: файловая база
$Global:OneCBasePath = "C:\Users\user\bases\my-base"

# Вариант 2: серверная база
# $Global:OneCServer = "server-name"
# $Global:OneCBase   = "base-name"

# Авторизация (опционально)
# $Global:OneCUser     = "Администратор"
# $Global:OneCPassword = "password"
```

> Добавьте `.1c-devbase.ps1` в `.gitignore` — файл содержит локальные настройки.

## Примеры использования

### Разобрать обработку, исправить код, собрать обратно

```bash
# 1. Разборка
powershell.exe -NoProfile -File .claude/commands/1c-batch/scripts/dump-epf.ps1 \
  -XmlFile "src/epf/МояОбработка.xml" -EpfFile "D:/Исходная.epf"

# 2. Редактируем BSL-файлы (вручную или через Claude Code)

# 3. Сборка
powershell.exe -NoProfile -File .claude/commands/1c-batch/scripts/build-epf.ps1 \
  -XmlFile "src/epf/МояОбработка.xml" -OutputFile "build/МояОбработка.epf"

# 4. Проверка
powershell.exe -NoProfile -File .claude/commands/1c-batch/scripts/run-enterprise.ps1 \
  -EpfFile "build/МояОбработка.epf"
```

### Обновить расширение

```bash
# Выгрузить (инкрементально)
powershell.exe -NoProfile -File .claude/commands/1c-batch/scripts/dump-extension.ps1 \
  -XmlDir "src/ext/МоёРасширение" -ExtName "МоёРасширение" -Update

# Внести изменения в XML/BSL

# Загрузить обратно
powershell.exe -NoProfile -File .claude/commands/1c-batch/scripts/load-extension.ps1 \
  -XmlDir "src/ext/МоёРасширение" -ExtName "МоёРасширение"
```

### Загрузить конфигурацию (частично)

```bash
powershell.exe -NoProfile -File .claude/commands/1c-batch/scripts/load-config.ps1 \
  -XmlDir "src/cf" -Files "CommonModules/МойМодуль/Ext/Module.bsl"
```

## Структура скриптов

| Скрипт | Назначение |
|---|---|
| `1c-common.ps1` | Общие функции: поиск конфига, формирование аргументов, вызов Designer |
| `build-epf.ps1` | Сборка EPF/ERF из XML |
| `dump-epf.ps1` | Разборка EPF/ERF в XML |
| `load-config.ps1` | Загрузка конфигурации из XML |
| `dump-config.ps1` | Выгрузка конфигурации в XML |
| `load-extension.ps1` | Загрузка расширения из XML |
| `dump-extension.ps1` | Выгрузка расширения в XML |
| `run-enterprise.ps1` | Запуск 1С:Предприятие |
| `run-designer.ps1` | Запуск Конфигуратора |

## Как это работает

1. Каждый скрипт подключает `1c-common.ps1` с общими функциями
2. `Get-1CDevBase` ищет файл `.1c-devbase.ps1` вверх по дереву каталогов от текущей директории
3. Из конфига берутся путь к платформе, строка подключения и авторизация
4. Формируется вызов `1cv8.exe DESIGNER /` с нужными параметрами пакетного режима
5. При ошибке автоматически выводится лог платформы

## Лицензия

MIT
