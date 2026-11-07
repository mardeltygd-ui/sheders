# sheders — Potato Lite Shaders

Очень лёгкие шейдеры для Minecraft (Iris / OptiFine) в стиле «картошка».

## Что есть
- Лёгкие мягкие тени от блоков
- Простое небо с градиентом
- Лучи солнца (god rays)

Тумана и прочих эффектов нет.

## Установка
1. Скачай репозиторий как ZIP (Code → Download ZIP) или собери ZIP так, чтобы внутри лежала папка `shaders`.
2. Положи ZIP в папку `.minecraft/shaderpacks`.
3. В игре: Настройки → Шейдеры → выбери пак.

## Настройка под слабое железо
- `shaders/gbuffers_textured_lit.fsh`
  - `shadowMapResolution` — сейчас 512 (минимум нагрузки)
  - `shadowDistance` — дальность теней
  - `SHADOW_STRENGTH` — насколько тёмные тени
- `shaders/composite.fsh`
  - `RAY_SAMPLES` — меньше = быстрее
  - `RAY_STRENGTH` — яркость лучей
