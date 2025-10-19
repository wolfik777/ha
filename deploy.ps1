# PowerShell скрипт для деплоя на GitHub Pages
Write-Host "🚀 Деплой MamaHR Landing Page на GitHub Pages" -ForegroundColor Green

# Замените YOUR_USERNAME на ваш GitHub username
$GITHUB_USERNAME = "YOUR_USERNAME"
$REPO_NAME = "mama-hr-landing"

# Проверка, что репозиторий уже инициализирован
if (-not (Test-Path ".git")) {
    Write-Host "📦 Инициализация Git репозитория..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Initial commit: MamaHR landing page"
    git branch -M main
    
    Write-Host "🔗 Добавление remote origin..." -ForegroundColor Yellow
    git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    
    Write-Host "⬆️  Push в GitHub..." -ForegroundColor Yellow
    git push -u origin main
} else {
    Write-Host "📝 Коммит изменений..." -ForegroundColor Yellow
    git add .
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Update: $timestamp"
    
    Write-Host "⬆️  Push в GitHub..." -ForegroundColor Yellow
    git push
}

Write-Host ""
Write-Host "✅ Готово!" -ForegroundColor Green
Write-Host "📍 Ваш сайт будет доступен по адресу:" -ForegroundColor Cyan
Write-Host "   https://$GITHUB_USERNAME.github.io/$REPO_NAME/" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Не забудьте:" -ForegroundColor Yellow
Write-Host "   1. Создать репозиторий $REPO_NAME на GitHub"
Write-Host "   2. Включить GitHub Pages в Settings → Pages"
Write-Host "   3. Заменить YOUR_USERNAME на ваш username в этом скрипте"

