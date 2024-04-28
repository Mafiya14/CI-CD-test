# Используем официальный образ Ubuntu как базовый
FROM ubuntu:20.04

# Установите необходимые зависимости для работы Unity Hub и X11 (для xvfb)
RUN apt-get update && apt-get install -y \
    wget \
    libgtk-3-0 \
    libnss3 \
    libasound2 \
    libgconf-2-4 \
    libarchive13 \
    libxtst6 \
    libxss1 \
    xvfb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Скопируйте Unity Hub AppImage в контейнер
COPY unityhub.AppImage /opt/unityhub.AppImage

# Сделайте Unity Hub исполняемым
RUN chmod +x /opt/unityhub.AppImage

# Определите рабочую директорию
WORKDIR /opt

# Запуск Unity Hub (Запуск в режиме командной строки может потребовать дополнительной настройки)
CMD ["xvfb-run", "--auto-servernum", "--server-args='-screen 0 1024x768x24'", "/opt/unityhub.AppImage"]

# Копирование содержимого Unity проекта в /app внутри образа
COPY . /app

# Установка рабочей директории
WORKDIR /app

# Команды для сборки Unity проекта
CMD xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity \
    -batchmode \
    -nographics \
    -silent-crashes \
    -logFile /dev/stdout \
    -projectPath "$(pwd)" \
    -buildLinux64Player "Build/game" \
    -quit
