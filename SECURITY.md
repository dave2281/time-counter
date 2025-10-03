# 🔐 БЕЗОПАСНОСТЬ - ВАЖНАЯ ИНФОРМАЦИЯ

## ⚠️ НИКОГДА НЕ ДОБАВЛЯЙТЕ ЭТИ ФАЙЛЫ В GIT:

- `config/master.key` - главный ключ шифрования Rails
- `.env` - переменные окружения с секретами  
- `config/credentials/*.key` - ключи для credentials

## 🛡️ Текущий мастер-ключ:
```
bbedacd9029eb7a5fa46a68df44e0c5b
```

**ЭТОТ КЛЮЧ НУЖЕН ДЛЯ:**
- Запуска приложения в production
- Расшифровки credentials.yml.enc
- Деплоя на сервер

## 📝 Как использовать:

### Локальная разработка:
```bash
export RAILS_MASTER_KEY=bbedacd9029eb7a5fa46a68df44e0c5b
rails server
```

### Деплой:
```bash
# Ключ уже настроен в manual_deploy.sh
./manual_deploy.sh
```

## 🔄 Если ключ скомпрометирован:
1. Сгенерировать новый: `openssl rand -hex 16`
2. Обновить config/master.key
3. Пересоздать credentials: `rm config/credentials.yml.enc && EDITOR=nano rails credentials:edit`
4. Обновить деплой скрипты
5. Передеплоить приложение

## ✅ Что безопасно в Git:
- config/credentials.yml.enc (зашифрованный файл)
- Весь остальной код
- .gitignore (который исключает секреты)

---
*Последнее обновление: 3 октября 2025*