# 032. Клиент Telegram

Срез: Бот

Зависит от: 001, 009, 016

## Зачем

Один процесс принимает вебхук и вызывает Bot API.

## Готово, когда

Локально можно принять тестовый update через `POST /telegram/webhook` с секретным заголовком. Чужой запрос без секрета получает 401.

## Шаги

1. Пакет `internal/bot`: SendMessage, EditMessageText, AnswerCallbackQuery, SendPoll, StopPoll не обязателен.
2. `POST /telegram/webhook`. Секрет в заголовке `X-Telegram-Bot-Api-Secret-Token`, значение из `TELEGRAM_WEBHOOK_SECRET`.
3. Разбор callback_query и poll_answer. Пока только лог типа update.
4. На проде вебхук включит задача 046. Локально достаточно ручного POST.
5. Таймаут исходящих вызовов Telegram 10 секунд. Ответ на callback всегда уходит, чтобы у пользователя не крутилась кнопка.

## Проверить

Запрос без секрета не доходит до обработчика логики.
