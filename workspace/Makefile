# Makefile for ROS1 catkin workspace
# Place this at the root of your workspace (alongside src/)

.PHONY: isolated isolated_debug release

PACKAGES := $(filter-out  isolated isolated_debug, $(MAKECMDGOALS))

# Swallow those extra words so make doesn't try to build them as real targets
$(PACKAGES):
	@:

isolated: $(PACKAGES)
	@if [ -z "$(PACKAGES)" ]; then \
		echo "Usage: make isolated <pkg1> [pkg2 …]"; \
		exit 1; \
	fi
	@echo "==> Isolated build for: $(PACKAGES)"
	catkin_make_isolated \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
		-DCMAKE_BUILD_TYPE=Release \
		--install --only-pkg-with-deps \
		$(PACKAGES)

isolated_debug: $(PACKAGES)
	@if [ -z "$(PACKAGES)" ]; then \
		echo "Usage: make isolated_debug <pkg1> [pkg2 …]"; \
		exit 1; \
	fi
	@echo "==> Isolated Debug build for: $(PACKAGES)"
	catkin_make_isolated \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
		-DCMAKE_BUILD_TYPE=Debug \
		--install --only-pkg-with-deps \
		$(PACKAGES)

release: $(PACKAGES)
	@if [ -z "$(PACKAGES)" ]; then \
		echo "Usage: make release <pkg1> [pkg2 …]"; \
		exit 1; \
	fi
	@echo "==> Isolated build for: $(PACKAGES)"
	catkin_make install \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
		-DCMAKE_BUILD_TYPE=Release \
		--only-pkg-with-deps \
		$(PACKAGES)
