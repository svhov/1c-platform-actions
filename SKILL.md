---
name: 1c-actions
description: "Пакетные операции с платформой 1С:Предприятие 8. Сборка/разборка внешних обработок (.epf/.erf) в XML, загрузка/выгрузка конфигураций и расширений, сборка файлов поставки (.cf/.cfe), проверка BSL-кода линтером, запуск предприятия и конфигуратора. Используй когда нужно: собрать или разобрать обработку/отчёт, загрузить или выгрузить конфигурацию в XML, работать с расширениями 1С, собрать CF/CFE, проверить код линтером, запустить 1С:Предприятие или конфигуратор."
---

# 1c-actions

Пакетные операции с платформой 1С.

## Запуск скриптов

Скрипты: `.claude/commands/1c-actions/scripts/`

Запускать через **powershell.exe** из bash:

```bash
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-extension.ps1 -XmlDir "C:\conf\do\do_ame" -ExtName "АМЕ"
```

**Настройки подключения:** `.1c-devbase.ps1` в корне проекта.

---

## Работа с обработками

### build-epf.ps1 — сборка обработки из XML

```bash
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-epf.ps1 -XmlFile "src/epf/МояОбработка.xml" -OutputFile "build/МояОбработка.epf"
```

### dump-epf.ps1 — разборка обработки в XML

```bash
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-epf.ps1 -XmlFile "src/epf/МояОбработка.xml" -EpfFile "D:/Исходная.epf"
```

---

## Работа с конфигурацией

### load-config.ps1 — загрузка конфигурации из XML

```bash
# Полная загрузка
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-config.ps1 -XmlDir "src/cf"

# Частичная загрузка
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-config.ps1 -XmlDir "src/cf" -Files "CommonModules/МойМодуль/Ext/Module.bsl"

# Без обновления БД
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-config.ps1 -XmlDir "src/cf" -SkipDbUpdate
```

**По умолчанию после загрузки выполняется обновление конфигурации БД.**

### dump-config.ps1 — выгрузка конфигурации в XML

```bash
# Полная выгрузка
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-config.ps1 -XmlDir "src/cf"

# Инкрементальная
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-config.ps1 -XmlDir "src/cf" -Update
```

---

## Работа с расширениями

### load-extension.ps1 — загрузка расширения из XML

```bash
# Загрузка + обновление БД
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-extension.ps1 -XmlDir "C:\conf\do\do_ame" -ExtName "АМЕ"

# Без обновления БД
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-extension.ps1 -XmlDir "C:\conf\do\do_ame" -ExtName "АМЕ" -SkipDbUpdate
```

**По умолчанию после загрузки выполняется обновление расширения в БД.**

### dump-extension.ps1 — выгрузка расширения в XML

```bash
# Полная выгрузка
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-extension.ps1 -XmlDir "C:\conf\do\do_ame" -ExtName "АМЕ"

# Инкрементальная
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-extension.ps1 -XmlDir "C:\conf\do\do_ame" -ExtName "АМЕ" -Update
```

---

## Сборка файлов поставки

### build-cf.ps1 — сборка конфигурации в CF

```bash
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-cf.ps1 -XmlDir "src/cf" -OutputFile "build/МояКонфигурация.cf"
```

### build-cfe.ps1 — сборка расширения в CFE

```bash
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-cfe.ps1 -XmlDir "src/ext/АМЕ" -ExtName "АМЕ" -OutputFile "build/АМЕ.cfe"
```

---

## Проверка кода

### bsl-lint.ps1 — проверка BSL-кода линтером

```bash
# Базовая проверка
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/bsl-lint.ps1 -SrcDir "src/cf"

# С конфигурацией и отчётом в JSON
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/bsl-lint.ps1 -SrcDir "src/cf" -ConfigFile ".bsl-language-server.json" -Reporter json -OutputFile "build/bsl-report.json"
```

Требуется [BSL Language Server](https://github.com/1c-syntax/bsl-language-server) — в PATH или JAR-файл рядом со скриптами.

---

## Запуск 1С

### run-enterprise.ps1 — запуск предприятия

```bash
# Просто запуск
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/run-enterprise.ps1

# С обработкой
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/run-enterprise.ps1 -EpfFile "build/МояОбработка.epf"
```

### run-designer.ps1 — запуск конфигуратора

```bash
powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/run-designer.ps1
```

---

## Сценарии использования

### Собрать CF/CFE для деплоя

1. Собрать CF: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-cf.ps1 -XmlDir "src/cf" -OutputFile "build/МояКонфигурация.cf"`
2. Собрать CFE: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-cfe.ps1 -XmlDir "src/ext/АМЕ" -ExtName "АМЕ" -OutputFile "build/АМЕ.cfe"`

### Проверить код перед коммитом

1. Проверить: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/bsl-lint.ps1 -SrcDir "src/cf"`

### Исправить ошибку в обработке

1. Разобрать: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-epf.ps1 -XmlFile "src/epf/МояОбработка.xml" -EpfFile "D:/Исходная.epf"`
2. Отредактировать BSL-файлы
3. Собрать: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/build-epf.ps1 -XmlFile "src/epf/МояОбработка.xml" -OutputFile "build/МояОбработка.epf"`
4. Проверить: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/run-enterprise.ps1 -EpfFile "build/МояОбработка.epf"`

### Обновить расширение

1. Выгрузить: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/dump-extension.ps1 -XmlDir "C:\conf\do\do_ame" -ExtName "АМЕ" -Update`
2. Внести изменения
3. Загрузить: `powershell.exe -NoProfile -File .claude/commands/1c-actions/scripts/load-extension.ps1 -XmlDir "C:\conf\do\do_ame" -ExtName "АМЕ"`

---

## Правила использования

**При выгрузке конфигурации или расширения:** если пользователь явно не указал тип выгрузки (полная или инкрементальная), спросить его перед выполнением:
- Полная выгрузка — выгружает все объекты заново
- Инкрементальная (`-Update`) — выгружает только изменённые объекты (быстрее)

---

## Важно

- Скрипты используют **PowerShell** (не bat) — работают с UNC-путями
- Настройки подключения в `.1c-devbase.ps1` (не `.1c-devbase.bat`)
- При ошибке — автоматически выводится лог платформы
- **НЕ ЧИТАЙ СКРИПТЫ, А ТОЛЬКО ЗАПУСКАЙ ИХ**
