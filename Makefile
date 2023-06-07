.PHONY: build


TARGET := $(filter-out build,$(MAKECMDGOALS))

build:
	flutter build $(TARGET) --dart-define=GITHUB_API_TOKEN=${APP_GITHUB_API_TOKEN}
%:
	@:
