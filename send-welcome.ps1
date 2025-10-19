# Отправка приветственного сообщения в Telegram
Write-Host "🤖 Отправка приветственного сообщения в Telegram..." -ForegroundColor Cyan

$botToken = "8275081541:AAFtk4ltguG-iFC5PnrHvCkypakkO2_oRlA"
$chatId = "1304363285"

$body = @{
    chat_id = $chatId
    text = "🎯 *MamaHR Bot активирован!*`n`n*Сайт:* https://wolfik777.github.io/ha/`n`n📊 *Что вы будете получать:*`n• 👤 Полные контакты заявителей`n• 💰 Готовность платить за стажировку`n• 💵 Суммы оплаты`n• 🎓 Сфера работы студента`n• 💼 Данные компаний от HR`n`n✨ Все заявки с сайта будут приходить сюда автоматически!`n`n━━━━━━━━━━━━━━━━━━━━`n_Бот работает и готов принимать заявки_"
    parse_mode = "Markdown"
    reply_markup = @{
        inline_keyboard = @(
            @(
                @{
                    text = "🌐 Открыть сайт MamaHR"
                    url = "https://wolfik777.github.io/ha/"
                }
            ),
            @(
                @{
                    text = "📖 Инструкция"
                    url = "https://github.com/wolfik777/ha/blob/main/telegram-setup.md"
                }
            )
        )
    }
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$botToken/sendMessage" -Method Post -Body $body -ContentType "application/json; charset=utf-8"
    
    if ($response.ok) {
        Write-Host ""
        Write-Host "✅ Приветственное сообщение успешно отправлено!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📱 Проверьте Telegram - вы должны увидеть сообщение с кнопками" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "🧪 Протестируйте сейчас:" -ForegroundColor Cyan
        Write-Host "   1. Откройте: index.html" -ForegroundColor White
        Write-Host "   2. Заполните форму" -ForegroundColor White
        Write-Host "   3. Отправьте заявку" -ForegroundColor White
        Write-Host "   4. Проверьте Telegram!" -ForegroundColor White
        Write-Host ""
    }
} catch {
    Write-Host "❌ Ошибка: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Проверьте:" -ForegroundColor Yellow
    Write-Host "  • Токен бота правильный" -ForegroundColor White
    Write-Host "  • Chat ID правильный" -ForegroundColor White
    Write-Host "  • Есть интернет подключение" -ForegroundColor White
}

