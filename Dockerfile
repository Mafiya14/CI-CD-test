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
# Здесь нужно вставить ваш собственный скрипт установки Unity Editor
COPY unity-installer.sh /tmp/
RUN chmod +x /tmp/unity-installer.sh && /tmp/unity-installer.sh

# Копирование содержимого Unity проекта в /app внутри образа
COPY . /app

# Установка рабочей директории
WORKDIR /app

# Скрипт сборки проекта Unity
COPY build_script.sh /app/
RUN chmod +x /app/build_script.sh

# Запуск сборки проекта через скрипт
CMD ["/app/build_script.sh"]
