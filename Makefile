.PHONY: build

build:
	TARGET=$(filter-out $@,$(MAKECMDGOALS))
	flutter build $(TARGET)
%:
	@: