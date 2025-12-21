#!/bin/bash
# Установщик системы бесшовного переключения раскладок

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"

echo "=== Installation системы бесшовного переключения раскладок ==="
echo

# Check зависимости
check_dependencies() {
    local deps=("gsettings" "pgrep" "killall")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "❌ Ошибка: $dep не найден"
            exit 1
        fi
    done
    echo "✅ Все зависимости найдены"
}

# Создаем директории
create_directories() {
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$AUTOSTART_DIR"
    echo "✅ Директории созданы"
}

# Устанавливаем скрипты
install_scripts() {
    chmod +x "$SCRIPT_DIR"/layout_*
    cp "$SCRIPT_DIR"/layout_*.sh "$INSTALL_DIR/" 2>/dev/null || true
    cp "$SCRIPT_DIR"/layout_* "$INSTALL_DIR/"
    echo "✅ Скрипты установлены в $INSTALL_DIR"
}

# Устанавливаем автозапуск
install_autostart() {
    cat > "$AUTOSTART_DIR/layout-monitor.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Layout Monitor
Comment=Seamless keyboard layout indicator for Wayland
Exec=$INSTALL_DIR/autostart_layout_monitor
Icon=input-keyboard
Terminal=false
StartupNotify=false
Categories=Utility;System;
X-GNOME-Autostart-enabled=true
Hidden=false
EOF
    echo "✅ Автозапуск настроен"
}

# Обновляем пути в скриптах
update_paths() {
    # Обновляем путь в автостартовом скрипте
    sed -i "s|/home/maendeleo/|$HOME/|g" "$INSTALL_DIR/autostart_layout_monitor"
    
    # Обновляем путь в скрипте статуса
    if [ -f "$INSTALL_DIR/layout_status" ]; then
        sed -i "s|/home/maendeleo/|$HOME/|g" "$INSTALL_DIR/layout_status"
    fi
    
    echo "✅ Пути обновлены для текущего пользователя"
}

# Start систему
start_service() {
    # Останавливаем старые процессы
    pkill -f "layout_monitor" 2>/dev/null || true
    sleep 2
    
    # Start монитор
    nohup "$INSTALL_DIR/layout_final_monitor" > /tmp/layout_autostart.log 2>&1 &
    
    if pgrep -f "layout_final_monitor" > /dev/null; then
        echo "✅ Система запущена"
    else
        echo "❌ Ошибка запуска системы"
        exit 1
    fi
}

# Check установку
verify_installation() {
    echo
    echo "=== Проверка установки ==="
    
    if [ -f "$INSTALL_DIR/layout_final_monitor" ]; then
        echo "✅ Main скрипт установлен"
    else
        echo "❌ Main скрипт не найден"
    fi
    
    if [ -f "$AUTOSTART_DIR/layout-monitor.desktop" ]; then
        echo "✅ Автозапуск настроен"
    else
        echo "❌ Автозапуск не настроен"
    fi
    
    if pgrep -f "layout_final_monitor" > /dev/null; then
        echo "✅ Система работает"
    else
        echo "❌ Система не запущена"
    fi
}

# Main процесс
main() {
    check_dependencies
    create_directories
    install_scripts
    install_autostart
    update_paths
    start_service
    verify_installation
    
    echo
    echo "=== Installation завершена! ==="
    echo "Используйте: $INSTALL_DIR/layout_status для проверки статуса"
    echo "Текущая раскладка: $("$INSTALL_DIR"/layout_check)"
}

# Start установку
main "$@"