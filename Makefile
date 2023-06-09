.PHONY: build


TARGET := $(filter-out build,$(MAKECMDGOALS))

build:
	flutter build $(TARGET) --dart-define=MM_GITHUB_INSTALLMENT_ID=${GH_INSTALLMENT_ID} --dart-define=MM_GITHUB_APP_ID=${GH_APP_ID} --dart-define=MM_GITHUB_PRIVATE_KEY=${GH_PRIVATE_KEY}
%:
	@:
