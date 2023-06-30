.PHONY: build


TARGET := $(filter-out build,$(MAKECMDGOALS))

build: $(TARGET)
	flutter build $(TARGET) --build-name ${VERSION} --dart-define=MM_GITHUB_INSTALLMENT_ID=${GH_INSTALLMENT_ID} --dart-define=MM_GITHUB_APP_ID=${GH_APP_ID} --dart-define=MM_GITHUB_PRIVATE_KEY=${GH_PRIVATE_KEY} --dart-define=MM_SENTRY_DSN=${SENTRY_DSN} --dart-define=MM_SENTRY_TRACE_SAMPLE_RATE=${SENTRY_TRACE_SAMPLE_RATE} --dart-define=FLUTTER_BUILD_NUMBER=${BUILD_NUMBER} --dart-define=FLUTTER_BUILD_NAME=${VERSION}
%:
	@:
