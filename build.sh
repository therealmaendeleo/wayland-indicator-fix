#!/bin/bash
# Скрипт для упаковки дистрибутива

VERSION="1.0.0"
NAME="seamless-layout-indicator"
DIST_DIR="dist"

echo "=== Создание дистрибутива $NAME v$VERSION ==="
echo

# Очистка
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Копируем файлы
echo "📁 Копирование файлов..."
cp -r layout_*.sh "$DIST_DIR/" 2>/dev/null || true
cp -r layout_* "$DIST_DIR/"
cp -r *.md "$DIST_DIR/"
cp -r *.desktop "$DIST_DIR/"
cp -r .gitignore "$DIST_DIR/"

# Создаем установщик
echo "📦 Создание установщика..."
cat > "$DIST_DIR/setup.sh" << 'EOF'
#!/bin/bash
# Простой установщик

echo "=== Installation $NAME ==="
echo

# Check права
if [ ! -w "$(dirname "$0")" ]; then
    echo "❌ Нет прав на запись"
    exit 1
fi

# Start установку
chmod +x install.sh
./install.sh

echo "✅ Installation завершена!"
EOF

chmod +x "$DIST_DIR/setup.sh"

# Создаем архив
echo "📦 Создание архива..."
cd "$DIST_DIR"
tar -czf "../${NAME}-v${VERSION}.tar.gz" *
cd ..

# Показываем результат
echo "✅ Дистрибутив готов:"
echo "   $DIST_DIR/${NAME}-v${VERSION}.tar.gz"
echo
echo "Содержимое:"
ls -la "$DIST_DIR/"
echo
echo "Для установки:"
echo "1. Распаковать архив"
echo "2. Запустить: ./setup.sh"