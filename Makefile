.PHONY: build

OS := $(firstword $(filter-out build,$(MAKECMDGOALS)))
TARGET := $(wordlist 3,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

build:
	flutter_distributor package --platform $(OS) --targets $(TARGET) --build-dart-define=MM_GITHUB_INSTALLMENT_ID=${GH_INSTALLMENT_ID} --build-dart-define=MM_GITHUB_APP_ID=${GH_APP_ID} --build-dart-define=MM_GITHUB_PRIVATE_KEY=${GH_PRIVATE_KEY} --build-dart-define=MM_SENTRY_DSN=${SENTRY_DSN} --build-dart-define=MM_SENTRY_TRACE_SAMPLE_RATE=${SENTRY_TRACE_SAMPLE_RATE}
%:
	@:
