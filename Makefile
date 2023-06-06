.PHONY: build

build:
	TARGET=$(filter-out $@,$(MAKECMDGOALS))
	flutter build $(TARGET) --dart-define=GITHUB_API_TOKEN=${APP_GITHUB_API_TOKEN}
%:
	@: