#!/bin/bash
# Простой установщик для пользователей

echo "=== Seamless Layout Indicator Installer ==="
echo "Fixes wingpanel indicator not updating in Wayland"
echo

# Check dependencies
check_deps() {
    local deps=("gsettings" "pgrep" "killall")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "❌ Error: $dep not found"
            exit 1
        fi
    done
    echo "✅ Dependencies OK"
}

# Installation
install() {
    local INSTALL_DIR="$HOME/.local/bin"
    local AUTOSTART_DIR="$HOME/.config/autostart"
    
    echo "📁 Installing to $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR" "$AUTOSTART_DIR"
    
    # Копируем скрипты
    chmod +x layout_*
    cp layout_* "$INSTALL_DIR/"
    chmod +x install.sh uninstall.sh build.sh
    cp install.sh uninstall.sh build.sh "$INSTALL_DIR/"
    
    # Автозапуск
    sed "s|%h|$HOME|g" layout-monitor.desktop > "$AUTOSTART_DIR/layout-monitor.desktop"
    
    # Обновляем пути
    sed -i "s|/home/user|$HOME|g" "$INSTALL_DIR/autostart_layout_monitor"
    sed -i "s|/home/user|$HOME|g" "$INSTALL_DIR/layout_status"
    
    # Запуск
    pkill -f "layout_final_monitor" 2>/dev/null || true
    sleep 2
    nohup "$INSTALL_DIR/layout_final_monitor" > /tmp/layout_autostart.log 2>&1 &
    
    echo "✅ Installation completed!"
    echo "Use: $INSTALL_DIR/layout_status to check status"
}

# Main процесс
main() {
    check_deps
    install
}

main "$@"