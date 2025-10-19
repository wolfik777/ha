# 🚀 Скрипт деплоя на GitHub

Write-Host "🔐 Проверка безопасности перед деплоем..." -ForegroundColor Cyan
Write-Host ""

# Проверяем наличие telegram-config.js
if (Test-Path "telegram-config.js") {
    Write-Host "❌ ОШИБКА: Найден файл telegram-config.js!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Этот файл содержит секретные токены и НЕ ДОЛЖЕН быть в Git!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Что делать:" -ForegroundColor Cyan
    Write-Host "  1. Убедитесь что telegram-config.js в .gitignore" -ForegroundColor White
    Write-Host "  2. Выполните: git rm --cached telegram-config.js" -ForegroundColor White
    Write-Host "  3. Попробуйте снова" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Проверяем .gitignore
if (!(Test-Path ".gitignore")) {
    Write-Host "⚠️ ПРЕДУПРЕЖДЕНИЕ: Файл .gitignore не найден!" -ForegroundColor Yellow
    exit 1
}

$gitignoreContent = Get-Content ".gitignore" -Raw
if ($gitignoreContent -notmatch "telegram-config\.js") {
    Write-Host "⚠️ ПРЕДУПРЕЖДЕНИЕ: telegram-config.js не в .gitignore!" -ForegroundColor Yellow
    Write-Host "Добавляю..." -ForegroundColor Cyan
    Add-Content ".gitignore" "`ntelegram-config.js"
}

Write-Host "✅ Проверка безопасности пройдена!" -ForegroundColor Green
Write-Host ""

# Git status
Write-Host "📊 Проверка изменений..." -ForegroundColor Cyan
git status --short

Write-Host ""
Write-Host "⚠️ ВАЖНО: Убедитесь что в списке НЕТ telegram-config.js!" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Продолжить деплой? (y/n)"

if ($confirm -ne "y") {
    Write-Host "❌ Деплой отменён" -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "🚀 Запуск деплоя..." -ForegroundColor Cyan

# Добавляем все файлы
git add .

# Коммитим
$commitMessage = Read-Host "Введите сообщение коммита"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Update landing page"
}

git commit -m "$commitMessage"

# Пушим
Write-Host ""
Write-Host "📤 Отправка на GitHub..." -ForegroundColor Cyan
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Деплой успешно завершён!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Ваш сайт будет доступен через 1-2 минуты" -ForegroundColor Cyan
    Write-Host ""
    
    # Получаем remote URL
    $remoteUrl = git config --get remote.origin.url
    if ($remoteUrl -match "github\.com[:/](.+?)\.git") {
        $repoPath = $matches[1]
        $username = $repoPath.Split("/")[0]
        $repoName = $repoPath.Split("/")[1]
        
        Write-Host "📝 Ссылки:" -ForegroundColor Cyan
        Write-Host "  Репозиторий: https://github.com/$repoPath" -ForegroundColor White
        Write-Host "  GitHub Pages: https://$username.github.io/$repoName/" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "⚠️ НАПОМИНАНИЕ:" -ForegroundColor Yellow
    Write-Host "  GitHub Pages НЕ может скрывать секретные токены!" -ForegroundColor White
    Write-Host "  Для продакшена используйте Vercel, Netlify или Cloudflare Workers" -ForegroundColor White
    Write-Host "  Подробнее в SECURITY.md" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Ошибка при деплое!" -ForegroundColor Red
    Write-Host "Проверьте что у вас есть доступ к репозиторию" -ForegroundColor Yellow
}
