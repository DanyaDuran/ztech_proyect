SHELL := /bin/bash

FLUTTER_CMD := $(shell command -v flutter 2> /dev/null)

.PHONY: help check-flutter prepare run analyze test clean doctor

.DEFAULT_GOAL := help

help:
	@echo "========================================================"
	@echo "          ZTech App - Comandos de Desarrollo            "
	@echo "========================================================"
	@echo "Comandos disponibles:"
	@echo "  make help      - Muestra esta lista de comandos."
	@echo "  make prepare   - Verifica Flutter e instala las dependencias."
	@echo "  make run       - Ejecuta la aplicación ZTech."
	@echo "  make analyze   - Analiza el código fuente en busca de errores."
	@echo "  make test      - Ejecuta las pruebas unitarias y de widgets."
	@echo "  make clean     - Limpia la caché y los archivos de compilación."
	@echo "  make doctor    - Muestra el estado del entorno de desarrollo de Flutter."
	@echo "========================================================"

check-flutter:
	@if [ -z "$(FLUTTER_CMD)" ]; then \
		echo "ERROR: Flutter no está instalado o no está configurado en el PATH."; \
		echo "https://docs.flutter.dev/get-started/install"; \
		exit 1; \
	fi

prepare: check-flutter
	@echo "Preparando el entorno de ZTech..."
	flutter pub get
	@echo "Dependencias instaladas correctamente."

run: check-flutter
	@echo "Ejecutando ZTech App..."
	flutter run

analyze: check-flutter
	@echo "Analizando código..."
	flutter analyze

test: check-flutter
	@echo "Ejecutando pruebas del sistema..."
	flutter test

clean: check-flutter
	@echo "Limpiando los archivos generados..."
	flutter clean
	flutter pub get
	@echo "Proyecto limpio y dependencias recargadas."

doctor: check-flutter
	@echo "Revisando entorno de Flutter..."
	flutter doctor