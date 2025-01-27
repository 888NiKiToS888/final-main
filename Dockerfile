# Используем официальный образ Go
FROM golang:1.23.2-alpine as builder

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем go.mod и go.sum
COPY go.mod go.sum ./

# Скачиваем зависимости
RUN go mod download

# Копируем исходный код приложения
COPY . .

# Собираем приложение
RUN go build -o main .

# Создаем финальный образ
FROM alpine:latest

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем исполняемый файл и базу данных из билдера
COPY --from=builder /app/main /app/main
COPY --from=builder /app/tracker.db /app/tracker.db

# Запускаем приложение
CMD ["/app/main"]
