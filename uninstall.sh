#!/bin/bash
# Удалитель системы бесшовного переключения раскладок

INSTALL_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"

echo "=== Удаление системы бесшовного переключения раскладок ==="
echo

# Останавливаем процессы
stop_services() {
    echo "🛑 Остановка сервисов..."
    pkill -f "layout_final_monitor" 2>/dev/null || true
    pkill -f "layout_monitor" 2>/dev/null || true
    sleep 2
    echo "✅ Сервисы остановлены"
}

# Remove скрипты
remove_scripts() {
    echo "🗑️ Удаление скриптов..."
    if [ -f "$INSTALL_DIR/layout_final_monitor" ]; then
        rm "$INSTALL_DIR"/layout_* 2>/dev/null || true
        echo "✅ Скрипты удалены из $INSTALL_DIR"
    else
        echo "ℹ️ Скрипты не найдены в $INSTALL_DIR"
    fi
}

# Remove автозапуск
remove_autostart() {
    echo "🗑️ Удаление автозапуска..."
    if [ -f "$AUTOSTART_DIR/layout-monitor.desktop" ]; then
        rm "$AUTOSTART_DIR/layout-monitor.desktop"
        echo "✅ Автозапуск удален"
    else
        echo "ℹ️ Автозапуск не найден"
    fi
}

# Remove логи
remove_logs() {
    echo "🗑️ Удаление логов..."
    rm -f /tmp/layout_*.log 2>/dev/null || true
    echo "✅ Логи удалены"
}

# Check удаление
verify_removal() {
    echo
    echo "=== Проверка удаления ==="
    
    if pgrep -f "layout_monitor" > /dev/null; then
        echo "⚠️ Некоторые процессы все еще работают"
    else
        echo "✅ Все процессы остановлены"
    fi
    
    if ls "$INSTALL_DIR"/layout_* &> /dev/null; then
        echo "⚠️ Некоторые файлы остались"
    else
        echo "✅ Все файлы удалены"
    fi
    
    if [ -f "$AUTOSTART_DIR/layout-monitor.desktop" ]; then
        echo "⚠️ Автозапуск остался"
    else
        echo "✅ Автозапуск удален"
    fi
}

# Востанавливаем оригинальные настройки
restore_settings() {
    echo "🔄 Восстановление настроек..."
    
    # Remove кастомные xkb-options
    if gsettings get org.gnome.desktop.input-sources xkb-options 2>/dev/null | grep -q "grp:alt_shift_toggle"; then
        gsettings set org.gnome.desktop.input-sources xkb-options "@as []"
        echo "✅ XKB настройки восстановлены"
    fi
    
    # Remove кастомные привязки
    if gsettings get org.gnome.desktop.wm.keybindings switch-input-source 2>/dev/null | grep -q "Alt"; then
        gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space']"
        gsettings reset org.gnome.desktop.wm.keybindings switch-input-source-backward
        echo "✅ Привязки клавиш восстановлены"
    fi
}

# Main процесс
main() {
    read -p "Удалить систему бесшовного переключения раскладок? [y/N]: " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        stop_services
        restore_settings
        remove_scripts
        remove_autostart
        remove_logs
        verify_removal
        
        echo
        echo "=== Удаление завершено! ==="
        echo "Перезапустите сеанс для применения изменений."
    else
        echo "Отмена удаления."
    fi
}

# Start удаление
main "$@"