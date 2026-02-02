# Task Manager

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fvladkostikov%2Fdual%2Fbadge%3Fref%3Ddevelop&style=flat)](https://actions-badge.atrox.dev/vladkostikov/dual/goto?ref=develop)
[![Coverage Status](https://coveralls.io/repos/github/vladkostikov/dual/badge.svg?branch=develop)](https://coveralls.io/github/vladkostikov/dual?branch=develop)
[![Ruby](https://img.shields.io/badge/Ruby-3.2.9-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-6.1.7-blue.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)](https://www.postgresql.org/)

Современное приложение для управления задачами, построенное на Ruby on Rails и React. Этот проект служит отличным учебным ресурсом для изучения full-stack веб-разработки с современными технологиями.

## 🚀 Возможности

### Основные функции
- **Управление пользователями**: Полная система регистрации, аутентификации и сброса пароля
- **Управление задачами**: Создание, назначение, обновление и отслеживание задач через жизненный цикл разработки
- **Kanban доска**: Интерактивная доска с перетаскиванием для визуального управления задачами
- **Ролевой доступ**: Разные права для разработчиков и менеджеров
- **Реальные уведомления**: Email-уведомления о обновлениях и назначениях задач

### Жизненный цикл задач
- **Новая задача** → **В разработке** → **В QA** → **В Code Review** → **Готово к релизу** → **Релиз**
- **Архивация** для завершенных или устаревших задач
- Реализация state machine для надежного управления рабочими процессами

### Технические особенности
- **API-First дизайн**: RESTful API с JSON сериализацией
- **Фоновые задачи**: Sidekiq для асинхронных email-уведомлений
- **Современный фронтенд**: React с Redux для управления состоянием
- **Безопасность**: bcrypt хеширование паролей, безопасное управление сессиями

## 🛠️ Технологический стек

### Backend
- **Ruby on Rails 6.1.7** - Веб-фреймворк
- **PostgreSQL** - База данных
- **Sidekiq** - Обработка фоновых задач
- **Active Model Serializers** - JSON API ответы
- **State Machines** - Управление рабочим процессом задач
- **Puma** - Сервер приложений

### Frontend
- **React 17** - Библиотека UI
- **Redux** - Управление состоянием
- **Material-UI** - Библиотека компонентов
- **Webpack** - Сборка модулей
- **Sass** - CSS препроцессор
- **React Kanban** - Доска с перетаскиванием

### Разработка и деплой
- **RSpec** - Фреймворк для тестирования
- **Factory Bot** - Генерация тестовых данных
- **Docker** - Контейнеризация
- **Dokku** - Платформа для деплоя
- **New Relic** - Мониторинг производительности
- **Rollbar** - Отслеживание ошибок

## 📋 Требования

### Системные зависимости
- **Ruby**: 3.2.9
- **Node.js**: 16+ (для frontend ресурсов)
- **PostgreSQL**: 13+
- **Redis**: 6+ (для Sidekiq)

### Инструменты разработки
- **Git** - Система контроля версий
- **Bundler** - Управление зависимостями Ruby
- **Yarn** - Управление JavaScript пакетами

## 🚀 Быстрый старт

### 1. Клонирование репозитория
```bash
git clone https://github.com/vladkostikov/dualboot-rails.git
cd dualboot-rails
```

### 2. Вход в контейнер
```bash
docker compose run --rm --service-ports web /bin/bash
```

### 3. Установка зависимостей
```bash
# Ruby зависимости
bundle install

# JavaScript зависимости
yarn install
```

### 4. Настройка базы данных
```bash
# Создание и миграция базы данных
rails db:create
rails db:migrate
rails db:seed
```

### 5. Запуск приложения
```bash
# Внутри контейнера
bundle exec rails s -b 0.0.0.0 -p 3000 

# Или так из директории проекта
docker compose up 
```

### 6. Доступ к приложению
- **Веб-интерфейс**: http://localhost:3000

## 🧪 Тестирование

### Запуск тестов
```bash
# Вход в контейнер
docker compose run --rm --service-ports web /bin/bash

# Запуск тестов
bundle exec rails test

# Запуск rubocop
bundle exec rubocop --auto-correct

# Запуск ESLint
yarn lint --fix
```

## 🚀 Деплой

### Продакшн деплой с Dokku
Смотрите [DOKKU_SETUP.md](./DOKKU_SETUP.md) для подробной инструкции по деплою.

## 🔧 Разработка

### Стиль кода
- **Ruby**: Следуйте конфигурации RuboCop
- **JavaScript**: ESLint с конфигурацией Airbnb
- **SCSS**: Согласованное именование и организация

## 📊 Мониторинг и производительность

### Интеграция New Relic
Мониторинг производительности настроен с New Relic для продакшн деплоя.

### Rollbar отслеживание ошибок
Автоматическое отслеживание и reporting ошибок настроено для продакшена.

### Sidekiq Dashboard
Доступ к дашборду Sidekiq по адресу `/admin/sidekiq` для мониторинга задач.

---

**Сделано с ❤️ на Ruby on Rails и React**
