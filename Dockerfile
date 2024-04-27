# Используем официальный образ Ubuntu как базовый
FROM ubuntu:20.04

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y \
    wget \
    libgtk2.0-0 \
    libxtst6 \
    libxss1 \
    libgconf-2-4 \
    libnss3 \
    libasound2 \
    xvfb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Скачиваем и устанавливаем Unity Editor
ADD https://download.unity3d.com/download_unity/XXXXX/unity-editor_amd64.deb /tmp/unity.deb
RUN gdebi -n /tmp/unity.deb && \
    rm /tmp/unity.deb

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
