.PHONY: all install

all: install

install:
	@echo "Fetching Dart dependencies..."
	@dart pub get
	@echo "Activating package globally..."
	@dart pub global activate . --source path --overwrite
	@echo "Setup complete."
