# Интеграция опросов для GitHub Pages

Поскольку GitHub Pages — это статический хостинг без backend, нужно использовать внешние сервисы для сбора данных. Вот несколько вариантов:

## 🔥 Вариант 1: Telegram Bot (РЕКОМЕНДУЕТСЯ)

### Преимущества:
- ✅ Бесплатно
- ✅ Мгновенные уведомления
- ✅ Легко настроить
- ✅ Данные сразу в удобном виде

### Настройка:

1. **Создайте Telegram бота:**
   - Откройте [@BotFather](https://t.me/BotFather) в Telegram
   - Отправьте `/newbot`
   - Следуйте инструкциям
   - Сохраните токен бота (например: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

2. **Создайте канал/группу для уведомлений:**
   - Создайте приватный канал/группу
   - Добавьте бота как администратора
   - Получите Chat ID (можно через [@userinfobot](https://t.me/userinfobot))

3. **Добавьте код в index.html:**

```javascript
// В функции submitForm добавьте:
async function sendToTelegram(formData) {
    const BOT_TOKEN = 'ВАШ_ТОКЕН_БОТА';
    const CHAT_ID = 'ВАШ_CHAT_ID';
    
    let message = `🎯 <b>Новая заявка MamaHR</b>\n\n`;
    
    if (formData.type === 'parent') {
        message += `👩‍👦 <b>РОДИТЕЛЬ</b>\n`;
        message += `━━━━━━━━━━━━━━━━\n`;
        message += `👤 Имя: ${formData.name}\n`;
        message += `📧 Email: ${formData.email}\n`;
        message += `📱 Телефон: ${formData.phone}\n`;
        message += `🎓 Студент: ${formData.studentName || 'не указано'}\n`;
        message += `💼 Сфера: ${formData.field}\n\n`;
        message += `💰 <b>Готовность платить:</b> ${formData.willingToPay === 'yes' ? '✅ Да' : formData.willingToPay === 'maybe' ? '🤔 Возможно' : '❌ Нет'}\n`;
        if (formData.paymentAmount) {
            message += `💵 Сумма: ${formData.paymentAmount}\n`;
        }
        if (formData.comment) {
            message += `\n📝 Комментарий: ${formData.comment}`;
        }
    } else {
        message += `💼 <b>HR</b>\n`;
        message += `━━━━━━━━━━━━━━━━\n`;
        message += `👤 Имя: ${formData.name}\n`;
        message += `📧 Email: ${formData.email}\n`;
        message += `📱 Телефон: ${formData.phone}\n`;
        message += `🏢 Компания: ${formData.company}\n`;
        message += `👥 Размер: ${formData.companySize || 'не указано'}\n`;
        message += `🎯 Вакансий: ${formData.vacancies || 'не указано'}\n\n`;
        message += `💡 <b>Интерес к платформе:</b> ${formData.platformInterest === 'yes' ? '✅ Да' : formData.platformInterest === 'maybe' ? '🤔 Возможно' : '❌ Нет'}\n`;
        if (formData.comment) {
            message += `\n📝 Комментарий: ${formData.comment}`;
        }
    }
    
    message += `\n\n🕐 ${new Date().toLocaleString('ru-RU')}`;
    
    const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`;
    
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                chat_id: CHAT_ID,
                text: message,
                parse_mode: 'HTML'
            })
        });
        
        if (!response.ok) {
            throw new Error('Telegram API error');
        }
        
        console.log('✅ Отправлено в Telegram');
    } catch (error) {
        console.error('❌ Ошибка отправки в Telegram:', error);
    }
}

// Вызовите эту функцию в submitForm:
await sendToTelegram(formData);
```

---

## 📊 Вариант 2: Google Forms

### Настройка:

1. Создайте Google Form с нужными полями
2. Получите URL формы
3. Используйте этот скрипт для отправки:

```javascript
async function sendToGoogleForms(formData) {
    const FORM_URL = 'https://docs.google.com/forms/d/e/YOUR_FORM_ID/formResponse';
    
    const formBody = new URLSearchParams();
    formBody.append('entry.123456', formData.name); // Замените на ваши Entry IDs
    formBody.append('entry.234567', formData.email);
    // ... добавьте все поля
    
    try {
        await fetch(FORM_URL, {
            method: 'POST',
            mode: 'no-cors',
            body: formBody
        });
        console.log('✅ Отправлено в Google Forms');
    } catch (error) {
        console.error('❌ Ошибка:', error);
    }
}
```

---

## 📧 Вариант 3: Email через EmailJS

### Бесплатный сервис для отправки email:

1. Зарегистрируйтесь на [EmailJS](https://www.emailjs.com/)
2. Создайте email service и template
3. Добавьте в HTML:

```html
<script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
<script>
    emailjs.init('YOUR_PUBLIC_KEY');
    
    async function sendEmail(formData) {
        try {
            await emailjs.send('YOUR_SERVICE_ID', 'YOUR_TEMPLATE_ID', {
                from_name: formData.name,
                from_email: formData.email,
                message: JSON.stringify(formData, null, 2)
            });
            console.log('✅ Email отправлен');
        } catch (error) {
            console.error('❌ Ошибка:', error);
        }
    }
</script>
```

---

## 🔌 Вариант 4: Webhook сервисы

### Make.com (бывший Integromat) или Zapier:

1. Создайте webhook в Make.com/Zapier
2. Настройте отправку в Google Sheets, Email, Telegram и т.д.
3. Используйте в коде:

```javascript
async function sendToWebhook(formData) {
    const WEBHOOK_URL = 'https://hook.eu1.make.com/YOUR_WEBHOOK_ID';
    
    try {
        await fetch(WEBHOOK_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(formData)
        });
        console.log('✅ Отправлено через webhook');
    } catch (error) {
        console.error('❌ Ошибка:', error);
    }
}
```

---

## 🚀 Быстрый старт с Telegram (пошагово)

### 1. Создайте бота:
```
Откройте Telegram → @BotFather
/newbot
Название: MamaHR Bot
Username: mamaHR_leads_bot (или другой доступный)
```

### 2. Получите Chat ID:
```
Создайте канал "MamaHR Заявки"
Добавьте бота как администратора
Откройте @userinfobot и перешлите любое сообщение из канала
Скопируйте Chat ID (например: -1001234567890)
```

### 3. Замените в index.html:

Найдите функцию `submitForm` и добавьте после строки `console.log('📝 Заявка отправлена:', formData);`:

```javascript
// Отправка в Telegram
await sendToTelegram(formData);
```

И добавьте функцию перед `submitForm`:

```javascript
async function sendToTelegram(formData) {
    const BOT_TOKEN = '123456789:ABCdefGHIjklMNOpqrsTUVwxyz'; // ВАШ ТОКЕН
    const CHAT_ID = '-1001234567890'; // ВАШ CHAT ID
    
    let message = `🎯 Новая заявка MamaHR!\n\n`;
    message += `Тип: ${formData.type === 'parent' ? '👩‍👦 Родитель' : '💼 HR'}\n`;
    message += `Имя: ${formData.name}\n`;
    message += `Email: ${formData.email}\n`;
    message += `Телефон: ${formData.phone}\n`;
    
    if (formData.type === 'parent') {
        message += `\n💰 Готов платить: ${formData.willingToPay}\n`;
        if (formData.paymentAmount) message += `Сумма: ${formData.paymentAmount}₽\n`;
    }
    
    const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`;
    
    await fetch(url, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            chat_id: CHAT_ID,
            text: message,
            parse_mode: 'HTML'
        })
    });
}
```

### 4. Готово! 🎉

Теперь при каждой заявке вы будете получать уведомление в Telegram!

---

## 📊 Статистика и аналитика

### Экспорт данных из LocalStorage:

Откройте консоль браузера (F12) и введите:
```javascript
exportData()  // Скачает JSON файл со всеми заявками
```

### Просмотр статистики:
```javascript
updateStats()       // Показать общую статистику
viewRegistrations() // Показать все заявки в таблице
```

---

## 🔒 Безопасность

⚠️ **ВАЖНО:** Никогда не храните API ключи прямо в коде для production!

Для GitHub Pages токены будут видны в исходном коде. Для продакшена используйте:
- Backend API (Node.js, Python, PHP)
- Serverless функции (Vercel, Netlify Functions, AWS Lambda)
- Proxy сервисы

Но для MVP и тестирования можно использовать прямую интеграцию.

---

## 💡 Рекомендация

Для быстрого старта используйте **Telegram Bot** — это самый простой и удобный способ!

