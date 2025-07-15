.POSIX:

################################# The Prelude ##################################

.PHONY: test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12
.PHONY: test
.PHONY: _test

.PHONY: lib
.PHONY: release

.PHONY: libmcu
.PHONY: libarm
.PHONY: libarm-nums libarm-numerr libarm-full libarm-nums-bp libarm-numerr-bp libarm-full-bp
.PHONY: libarm-nums-nolut libarm-numerr-nolut libarm-full-nolut libarm-nums-bp-nolut libarm-numerr-bp-nolut libarm-full-bp-nolut
.PHONY: mcu-builds

.PHONY: libwx86-64-nums libwx86-64-numerr libwx86-64-full libwx86-64-nums-bp libwx86-64-numerr-bp libwx86-64-full-bp
.PHONY: libwx86-64-nums-nolut libwx86-64-numerr-nolut libwx86-64-full-nolut libwx86-64-nums-bp-nolut libwx86-64-numerr-bp-nolut libwx86-64-full-bp-nolut
.PHONY: wx86-64-builds

.PHONY: memstats
.PHONY: memstats-arm-nums memstats-arm-numerr memstats-arm-full memstats-arm-nums-bp memstats-arm-numerr-bp memstats-arm-full-bp
.PHONY: memstats-arm-nums-nolut memstats-arm-numerr-nolut memstats-arm-full-nolut memstats-arm-nums-bp-nolut memstats-arm-numerr-bp-nolut memstats-arm-full-bp-nolut
.PHONY: memstats-arm-all

.PHONY: unity_static_analysis

.PHONY: clean

BUILD_TYPE ?= RELEASE
REL_SUBDIR ?=

########################################################################################################################

test:
	@echo -e "Test 1: \033[35mnumbers only version\033[0m /w other defaults..."
	@$(MAKE) --always-make test1 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 2: \033[35mnumbers + 'error' version\033[0m /w other defaults..."
	@$(MAKE) --always-make test2 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 3: \033[35mcomplete version\033[0m /w other defaults..."
	@$(MAKE) --always-make test3 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 4: \033[35mnumbers only version\033[0m /w \033[34mbit packing\033[0m..."
	@$(MAKE) --always-make test4 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 5: \033[35mnumbers + 'error' version\033[0m /w \033[34mbit packing\033[0m..."
	@$(MAKE) --always-make test5 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 6: \033[35mcomplete version\033[0m /w \033[34mbit packing\033[0m..."
	@$(MAKE) --always-make test6 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 7: \033[35mnumbers only version\033[0m \033[34m/wo LUT\033[0m..."
	@$(MAKE) --always-make test7 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 8: \033[35mnumbers + 'error' version\033[0m \033[34m/wo LUT\033[0m..."
	@$(MAKE) --always-make test8 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 9: \033[35mcomplete version\033[0m \033[34m/wo LUT\033[0m..."
	@$(MAKE) --always-make test9 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 10: \033[35mnumbers only version\033[0m with \033[34mbit packing\033[0m \033[36m/wo LUT\033[0m..."
	@$(MAKE) --always-make test10 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 11: \033[35mnumbers + 'error' version\033[0m with \033[34mbit packing\033[0m \033[36m/wo LUT\033[0m..."
	@$(MAKE) --always-make test11 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)
	@echo -e "Test 12: \033[35mcomplete version\033[0m with \033[34mbit packing\033[0m \033[36m/wo LUT\033[0m..."
	@$(MAKE) --always-make test12 > /dev/null
	cat $(RESULTS) | python $(COLORIZE_UNITY_SCRIPT)

# Targets to run only one config combo.
# NOTE: If you run testX and then want to run testY, make sure to clean first!
test1:
	@echo "----------------------------------------"
	@echo -e "Test 1: \033[35mnumbers only version\033[0m /w other defaults..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_ONLY _test

test2:
	@echo "----------------------------------------"
	@echo -e "Test 2: \033[35mnumbers + 'error' version\033[0m /w other defaults..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_AND_ERROR_ONLY _test

test3:
	@echo "----------------------------------------"
	@echo -e "Test 3: \033[35mcomplete version\033[0m /w other defaults..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST _test

test4:
	@echo "----------------------------------------"
	@echo -e "Test 4: \033[35mnumbers only version\033[0m /w \033[34mbit packing\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_ONLY BIT_PACK=1 _test

test5:
	@echo "----------------------------------------"
	@echo -e "Test 5: \033[35mnumbers + 'error' version\033[0m /w \033[34mbit packing\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 _test

test6:
	@echo "----------------------------------------"
	@echo -e "Test 6: \033[35mcomplete version\033[0m /w \033[34mbit packing\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST BIT_PACK=1 _test

test7:
	@echo "----------------------------------------"
	@echo -e "Test 7: \033[35mnumbers only version\033[0m \033[34m/wo LUT\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_ONLY NO_LUT=1 _test

test8:
	@echo "----------------------------------------"
	@echo -e "Test 8: \033[35mnumbers + 'error' version\033[0m \033[34m/wo LUT\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_AND_ERROR_ONLY NO_LUT=1 _test

test9:
	@echo "----------------------------------------"
	@echo -e "Test 9: \033[35mcomplete version\033[0m \033[34m/wo LUT\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST _test

test10:
	@echo "----------------------------------------"
	@echo -e "Test 10: \033[35mnumbers only version\033[0m with \033[34mbit packing\033[0m \033[36m/wo LUT\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_ONLY BIT_PACK=1 NO_LUT=1 _test

test11:
	@echo "----------------------------------------"
	@echo -e "Test 11: \033[35mnumbers + 'error' version\033[0m with \033[34mbit packing\033[0m \033[36m/wo LUT\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 NO_LUT=1 _test

test12:
	@echo "----------------------------------------"
	@echo -e "Test 12: \033[35mcomplete version\033[0m with \033[34mbit packing\033[0m \033[36m/wo LUT\033[0m..."
	@echo "----------------------------------------"
	@$(MAKE) BUILD_TYPE=TEST BIT_PACK=1 NO_LUT=1 _test

########################################################################################################################

mcu-builds:
	@echo -e "\033[35mMCU test build 1\033[0m (defaults)..."
	@$(MAKE) --always-make libarm-lazy > /dev/null
	@echo -e "\033[35mMCU test build 2\033[0m (nums only, default spacing)..."
	@$(MAKE) --always-make libarm-nums > /dev/null
	@echo -e "\033[35mMCU test build 3\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make libarm-numerr > /dev/null
	@echo -e "\033[35mMCU test build 4\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make libarm-full > /dev/null
	@echo -e "\033[35mMCU test build 5\033[0m (nums only, bit-packed)..."
	@$(MAKE) --always-make libarm-nums-bp > /dev/null
	@echo -e "\033[35mMCU test build 6\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make libarm-numerr-bp > /dev/null
	@echo -e "\033[35mMCU test build 7\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make libarm-full-bp > /dev/null
	@echo -e "\033[35mMCU test build 8\033[0m (nums only, default spacing, no lut)..."
	@$(MAKE) --always-make libarm-nums-nolut > /dev/null
	@echo -e "\033[35mMCU test build 9\033[0m (nums+err, default spacing, no lut)..."
	@$(MAKE) --always-make libarm-numerr-nolut > /dev/null
	@echo -e "\033[35mMCU test build 10\033[0m (full rng, default spacing, no lut)..."
	@$(MAKE) --always-make libarm-full-nolut > /dev/null
	@echo -e "\033[35mMCU test build 11\033[0m (nums only, bit packed, no lut)..."
	@$(MAKE) --always-make libarm-nums-bp-nolut > /dev/null
	@echo -e "\033[35mMCU test build 12\033[0m (nums+err, bit packed, no lut)..."
	@$(MAKE) --always-make libarm-numerr-bp-nolut > /dev/null
	@echo -e "\033[35mMCU test build 13\033[0m (full rng, bit packed, no lut)..."
	@$(MAKE) --always-make libarm-full-bp-nolut > /dev/null

libmcu:
	@$(MAKE) libarm BUILD_TYPE=RELEASE

libarm:
	@$(MAKE) libarm-nums BUILD_TYPE=RELEASE

libarm-nums:
	$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums

libarm-numerr:
	@$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr

libarm-full:
	@$(MAKE) lib CROSS=arm-none-eabi- BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full

libarm-nums-bp:
	$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums-bp

libarm-numerr-bp:
	$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr-bp

libarm-full-bp:
	$(MAKE) lib CROSS=arm-none-eabi- BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full-bp

libarm-nums-nolut:
	$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums-nolut

libarm-numerr-nolut:
	@$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr-nolut

libarm-full-nolut:
	@$(MAKE) lib CROSS=arm-none-eabi- NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full-nolut

libarm-nums-bp-nolut:
	$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums-bp-nolut

libarm-numerr-bp-nolut:
	$(MAKE) lib CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr-bp-nolut

libarm-full-bp-nolut:
	$(MAKE) lib CROSS=arm-none-eabi- BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full-bp-nolut

libarm-lazy:
	@echo "----------------------------------------"
	@echo -e "Building for an \033[35mARM target\033[0m..."
	$(MAKE) lib CROSS=arm-none-eabi- BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-defaults

########################################################################################################################

wx86-64-builds:
	@echo -e "\033[35mWindows x86-64 test build 1\033[0m (defaults)..."
	@$(MAKE) --always-make lib > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 2\033[0m (nums only, default spacing)..."
	@$(MAKE) --always-make libwx86-64-nums > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 3\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make libwx86-64-numerr > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 4\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make libwx86-64-full > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 5\033[0m (nums only, bit-packed)..."
	@$(MAKE) --always-make libwx86-64-nums-bp > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 6\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make libwx86-64-numerr-bp > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 7\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make libwx86-64-full-bp > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 8\033[0m (nums only, default spacing, no lut)..."
	@$(MAKE) --always-make libwx86-64-nums-nolut > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 9\033[0m (nums+err, default spacing, no lut)..."
	@$(MAKE) --always-make libwx86-64-numerr-nolut > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 10\033[0m (full rng, default spacing, no lut)..."
	@$(MAKE) --always-make libwx86-64-full-nolut > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 11\033[0m (nums only, bit packed, no lut)..."
	@$(MAKE) --always-make libwx86-64-nums-bp-nolut > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 12\033[0m (nums+err, bit packed, no lut)..."
	@$(MAKE) --always-make libwx86-64-numerr-bp-nolut > /dev/null
	@echo -e "\033[35mWindows x86-64 test build 13\033[0m (full rng, bit packed, no lut)..."
	@$(MAKE) --always-make libwx86-64-full-bp-nolut > /dev/null

libwx86-64-nums:
	$(MAKE) lib CHAR_RANGE=NUMS_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums

libwx86-64-numerr:
	@$(MAKE) lib CHAR_RANGE=NUMS_AND_ERROR_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr

libwx86-64-full:
	@$(MAKE) lib BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full

libwx86-64-nums-bp:
	$(MAKE) lib CHAR_RANGE=NUMS_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums-bp

libwx86-64-numerr-bp:
	$(MAKE) lib CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr-bp

libwx86-64-full-bp:
	$(MAKE) lib BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full-bp

libwx86-64-nums-nolut:
	$(MAKE) lib CHAR_RANGE=NUMS_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums-nolut

libwx86-64-numerr-nolut:
	@$(MAKE) lib CHAR_RANGE=NUMS_AND_ERROR_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr-nolut

libwx86-64-full-nolut:
	@$(MAKE) lib NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full-nolut

libwx86-64-nums-bp-nolut:
	$(MAKE) lib CHAR_RANGE=NUMS_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums-bp-nolut

libwx86-64-numerr-bp-nolut:
	$(MAKE) lib CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr-bp-nolut

libwx86-64-full-bp-nolut:
	$(MAKE) lib BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full-bp-nolut

########################################################################################################################

memstats-arm-all:
	@echo -e "\033[35mMCU mem stats 1\033[0m (defaults)..."
	@$(MAKE) --always-make memstats-arm-lazy MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 2\033[0m (nums only, default spacing)..."
	@$(MAKE) --always-make memstats-arm-nums MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 3\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make memstats-arm-numerr MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 4\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make memstats-arm-full MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 5\033[0m (nums only, bit-packed)..."
	@$(MAKE) --always-make memstats-arm-nums-bp MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 6\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make memstats-arm-numerr-bp MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 7\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make memstats-arm-full-bp MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 8\033[0m (nums only, default spacing, no lut)..."
	@$(MAKE) --always-make memstats-arm-nums-nolut MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 9\033[0m (nums+err, default spacing, no lut)..."
	@$(MAKE) --always-make memstats-arm-numerr-nolut MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 10\033[0m (full rng, default spacing, no lut)..."
	@$(MAKE) --always-make memstats-arm-full-nolut MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 11\033[0m (nums only, bit packed, no lut)..."
	@$(MAKE) --always-make memstats-arm-nums-bp-nolut MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 12\033[0m (nums+err, bit packed, no lut)..."
	@$(MAKE) --always-make memstats-arm-numerr-bp-nolut MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[35mMCU mem stats 13\033[0m (full rng, bit packed, no lut)..."
	@$(MAKE) --always-make memstats-arm-full-bp-nolut MEMSTATS_TO_FILE=1 > /dev/null
	@echo -e "\033[32;1mAll done!\033[0m"
	python scripts/mem_cmp_table.py
	@echo -e "\033[32;1mAll done!\033[0m"

memstats-arm-nums:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-nums-bp:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums-bp
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-nums-nolut:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-nums-bp-nolut:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-nums-bp-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-numerr:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-numerr-bp:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr-bp
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-numerr-nolut:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-numerr-bp-nolut:
	$(MAKE) memstats CROSS=arm-none-eabi- CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-numerr-bp-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-full:
	$(MAKE) memstats CROSS=arm-none-eabi- BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-full-bp:
	$(MAKE) memstats CROSS=arm-none-eabi- BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full-bp
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-full-nolut:
	$(MAKE) memstats CROSS=arm-none-eabi- NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-full-bp-nolut:
	$(MAKE) memstats CROSS=arm-none-eabi- BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-full-bp-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-arm-lazy:
	$(MAKE) memstats CROSS=arm-none-eabi- BUILD_TYPE=RELEASE REL_SUBDIR=arm-m0plus-defaults
	@echo -e "\033[32;1mDone!\033[0m"

########################################################################################################################

memstats-wx86-64-all:
	@echo -e "\033[35mMCU mem stats 1\033[0m (defaults)..."
	@$(MAKE) --always-make memstats-wx86-64-lazy MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 2\033[0m (nums only, default spacing)..."
	@$(MAKE) --always-make memstats-wx86-64-nums MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 3\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make memstats-wx86-64-numerr MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 4\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make memstats-wx86-64-full MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 5\033[0m (nums only, bit-packed)..."
	@$(MAKE) --always-make memstats-wx86-64-nums-bp MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 6\033[0m (nums+err, default spacing)..."
	@$(MAKE) --always-make memstats-wx86-64-numerr-bp MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 7\033[0m (full rng, default spacing)..."
	@$(MAKE) --always-make memstats-wx86-64-full-bp MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 8\033[0m (nums only, default spacing, no lut)..."
	@$(MAKE) --always-make memstats-wx86-64-nums-nolut MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 9\033[0m (nums+err, default spacing, no lut)..."
	@$(MAKE) --always-make memstats-wx86-64-numerr-nolut MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 10\033[0m (full rng, default spacing, no lut)..."
	@$(MAKE) --always-make memstats-wx86-64-full-nolut MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 11\033[0m (nums only, bit packed, no lut)..."
	@$(MAKE) --always-make memstats-wx86-64-nums-bp-nolut MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 12\033[0m (nums+err, bit packed, no lut)..."
	@$(MAKE) --always-make memstats-wx86-64-numerr-bp-nolut MEMSTATS_TO_FILE=1
	@echo -e "\033[35mMCU mem stats 13\033[0m (full rng, bit packed, no lut)..."
	@$(MAKE) --always-make memstats-wx86-64-full-bp-nolut MEMSTATS_TO_FILE=1
	python scripts/mem_cmp_table.py
	@echo -e "\033[32;1mAll done!\033[0m"

memstats-wx86-64-nums:
	$(MAKE) memstats CHAR_RANGE=NUMS_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-nums-bp:
	$(MAKE) memstats CHAR_RANGE=NUMS_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums-bp
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-nums-nolut:
	$(MAKE) memstats CHAR_RANGE=NUMS_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-nums-bp-nolut:
	$(MAKE) memstats CHAR_RANGE=NUMS_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-nums-bp-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-numerr:
	$(MAKE) memstats CHAR_RANGE=NUMS_AND_ERROR_ONLY BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-numerr-bp:
	$(MAKE) memstats CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr-bp
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-numerr-nolut:
	$(MAKE) memstats CHAR_RANGE=NUMS_AND_ERROR_ONLY NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-numerr-bp-nolut:
	$(MAKE) memstats CHAR_RANGE=NUMS_AND_ERROR_ONLY BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-numerr-bp-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-full:
	$(MAKE) memstats BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-full-bp:
	$(MAKE) memstats BIT_PACK=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full-bp
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-full-nolut:
	$(MAKE) memstats NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-full-bp-nolut:
	$(MAKE) memstats BIT_PACK=1 NO_LUT=1 BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-full-bp-nolut
	@echo -e "\033[32;1mDone!\033[0m"

memstats-wx86-64-lazy:
	$(MAKE) memstats BUILD_TYPE=RELEASE REL_SUBDIR=wx86-64-defaults
	@echo -e "\033[32;1mDone!\033[0m"

########################################################################################################################

CLEANUP = rm -f
MKDIR = mkdir -p
TARGET_EXTENSION=exe

# Set the OS-specific tool cmds / executable extensions
ifeq ($(OS),Windows_NT)
  TARGET_EXTENSION = exe
  STATIC_LIB_EXTENSION = lib

  ifeq ($(shell uname -s),) # not in a bash-like shell
    CLEANUP = del /F /Q
    MKDIR = mkdir
  else # in a bash-like shell, like msys
    CLEANUP = rm -f
    MKDIR = mkdir -p
  endif
else
  TARGET_EXTENSION = out
  STATIC_LIB_EXTENSION = a
  CLEANUP = rm -f
  MKDIR = mkdir -p
endif

# Override for cross-compiling the build artifact extensions...
ifneq ($(strip $(CROSS)),)
  TARGET_EXTENSION = hex
  STATIC_LIB_EXTENSION = a
endif

# Relevant paths
PATH_UNITY        = test/Unity/src/
PATH_SRC          = src/
PATH_INC          = inc/
PATH_TEST_FILES   = test/
PATH_BUILD        = build/
PATH_OBJECT_FILES = $(PATH_BUILD)objs/
PATH_RESULTS      = $(PATH_BUILD)results/
PATH_PROFILE      = $(PATH_BUILD)profile/
PATH_BENCHMARK    = benchmark/
PATH_SCRIPTS      = scripts/
PATH_RELEASE      = $(PATH_BUILD)release/
PATH_DEBUG        = $(PATH_BUILD)debug/
PATH_MEMSTATS     = $(PATH_BUILD)memstats/
BUILD_DIRS        = $(PATH_BUILD) $(PATH_OBJECT_FILES) $(PATH_RELEASE) $(PATH_DEBUG) $(PATH_RELEASE)$(REL_SUBDIR) $(PATH_MEMSTATS)

# Lists of files
# The pattern employed here is to generate lists of files which shall then be
# used as pre-requisities in downstream rules.
COLORIZE_CPPCHECK_SCRIPT = $(PATH_SCRIPTS)colorize_cppcheck.py
COLORIZE_UNITY_SCRIPT = $(PATH_SCRIPTS)colorize_unity.py

UNITY_SRC_FILES = $(wildcard $(PATH_UNITY)*.c)
UNITY_HDR_FILES = $(wildcard $(PATH_UNITY)*.h)
UNITY_OBJ_FILES = $(patsubst %.c, $(PATH_OBJECT_FILES)%.o, $(notdir $(UNITY_SRC_FILES)))

LIB_NAME = ascii7seg

# Relevant files
SRC_FILES = $(wildcard $(PATH_SRC)*.c)
HDR_FILES = $(wildcard $(PATH_INC)*.h)
SRC_TEST_FILES = $(wildcard $(PATH_TEST_FILES)*.c)
ifeq ($(BUILD_TYPE), RELEASE)
  LIB_FILE = $(PATH_RELEASE)$(REL_SUBDIR)/lib$(LIB_NAME).$(STATIC_LIB_EXTENSION)
else
  LIB_FILE = $(PATH_DEBUG)$(REL_SUBDIR)/lib$(LIB_NAME).$(STATIC_LIB_EXTENSION)
endif
LIB_OBJ_FILES = $(patsubst %.c, $(PATH_OBJECT_FILES)%.o, $(notdir $(SRC_FILES)))
TEST_EXECUTABLES = $(PATH_BUILD)test_$(LIB_NAME).$(TARGET_EXTENSION)
LIB_LIST_FILE = $(LIB_FILE:.$(STATIC_LIB_EXTENSION)=.lst)
TEST_LIST_FILE = $(patsubst %.$(TARGET_EXTENSION), $(PATH_BUILD)%.lst, $(notdir $(TEST_EXECUTABLES)))
TEST_OBJ_FILES = $(patsubst %.c, $(PATH_OBJECT_FILES)%.o, $(notdir $(SRC_TEST_FILES)))
RESULTS = $(patsubst %.$(TARGET_EXTENSION), $(PATH_RESULTS)%.txt, $(notdir $(TEST_EXECUTABLES)))
GCOV_FILES = $(SRC_FILES:.c=.c.gcov)

ifeq ($(BUILD_TYPE), TEST)
  BUILD_DIRS += $(PATH_RESULTS)
else ifeq ($(BUILD_TYPE), PROFILE)
  BUILD_DIRS += $(PATH_PROFILE)
endif

# Compiler setup
CROSS =
CC = $(CROSS)gcc

ifneq ($(strip $(CROSS)),)
  include mcu_opts.mk
endif

COMPILER_WARNINGS = \
    -Wall -Wextra -Wpedantic -pedantic-errors \
    -Wconversion -Wdouble-promotion -Wnull-dereference \
    -Wwrite-strings -Wformat=2 -Wformat-overflow=2 \
    -Wformat-signedness -Wuseless-cast -Wstrict-prototypes \
    -Wcast-align=strict -Wimplicit-fallthrough=3 -Wswitch-default \
    -Wswitch-enum -Wfloat-equal -Wuse-after-free=2 \
    -Wdeprecated-declarations -Wmissing-prototypes -Wparentheses \
    -Wreturn-type -Wlogical-op -Wstrict-aliasing \
    -Wuninitialized -Wmaybe-uninitialized -Wshadow \
    -Wduplicated-cond -Wduplicated-branches \
    -Walloc-zero -Walloc-size -Wpacked

# Includes some -Wno-... flags for warnings that I'd normally want for my lib
# src but **not** for my test file, which intentionally has all sorts of
# naughty shenanigans going on
COMPILER_WARNINGS_TEST_FILES = \
    -Wall -Wextra -Wpedantic -pedantic-errors \
    -Wconversion -Wdouble-promotion -Wnull-dereference \
    -Wwrite-strings -Wformat=2 -Wformat-overflow=2 \
    -Wformat-signedness \
    -Wcast-align=strict -Wimplicit-fallthrough=3 -Wswitch-default \
    -Wswitch-enum -Wfloat-equal -Wuse-after-free=2 \
    -Wdeprecated-declarations -Wmissing-prototypes -Wparentheses \
    -Wreturn-type -Wlogical-op -Wstrict-aliasing \
    -Wuninitialized -Wmaybe-uninitialized -Wshadow \
    -Walloc-zero -Walloc-size \
    -Wno-analyzer-use-of-uninitialized-value -Wno-uninitialized \
    -Wno-maybe-uninitialized

# Consider -Wmismatched-dealloc
COMPILER_SANITIZERS = \
    -fsanitize=undefined -fsanitize-trap \
    -fsanitize=enum  -fsanitize=bool -fsanitize=bounds
COMPILER_OPTIMIZATION_LEVEL_DEBUG = -Og -g3
COMPILER_OPTIMIZATION_LEVEL_SPEED = -O3
COMPILER_OPTIMIZATION_LEVEL_SPACE = -Os
COMPILER_STANDARD = -std=c99
INCLUDE_PATHS = -I. -I$(PATH_INC) -I$(PATH_UNITY)
TEST_DEFINES ?=

COMMON_DEFINES =
ifeq ($(CHAR_RANGE), NUMS_ONLY)
  COMMON_DEFINES += -DASCII_7SEG_NUMS_ONLY
else ifeq ($(CHAR_RANGE), NUMS_AND_ERROR_ONLY)
  COMMON_DEFINES += -DASCII_7SEG_NUMS_AND_ERROR_ONLY
endif
ifdef BIT_PACK
  COMMON_DEFINES += -DASCII_7SEG_BIT_PACK
endif
ifdef NO_LUT
  COMMON_DEFINES += -DASCII_7SEG_DONT_USE_LOOKUP_TABLE
endif
#COMMON_DEFINES = # -DASCII_7SEG_DONT_USE_LOOKUP_TABLE -DASCII_7SEG_BIT_PACK

DIAGNOSTIC_FLAGS = -fdiagnostics-color
COMPILER_STATIC_ANALYZER = -fanalyzer

# Compile up the compiler flags
CFLAGS = $(INCLUDE_PATHS) $(COMMON_DEFINES) \
			$(DIAGNOSTIC_FLAGS) $(COMPILER_WARNINGS) $(COMPILER_STATIC_ANALYZER) \
			$(COMPILER_STANDARD)

CFLAGS_TEST_FILES = \
         -DTEST $(COMMON_DEFINES) $(TEST_DEFINES) \
         $(INCLUDE_PATHS) \
         $(DIAGNOSTIC_FLAGS) $(COMPILER_WARNINGS_TEST_FILES) \
         $(COMPILER_STATIC_ANALYZER) $(COMPILER_STANDARD) \
         $(COMPILER_SANITIZERS) $(COMPILER_OPTIMIZATION_LEVEL_DEBUG)

ifeq ($(BUILD_TYPE), RELEASE)
CFLAGS += -DNDEBUG $(COMPILER_OPTIMIZATION_LEVEL_SPEED)

else ifeq ($(BUILD_TYPE), TEST)
# Flags for gcov
CFLAGS += -fcondition-coverage -fprofile-arcs -ftest-coverage $(COMPILER_OPTIMIZATION_LEVEL_DEBUG)

else ifeq ($(BUILD_TYPE), BENCHMARK)
CFLAGS += -DNDEBUG $(COMPILER_OPTIMIZATION_LEVEL_SPEED)

else ifeq ($(BUILD_TYPE), PROFILE)
CFLAGS += -DNDEBUG $(COMPILER_OPTIMIZATION_LEVEL_DEBUG) -pg
LDFLAGS += -pg

else
CFLAGS += $(COMPILER_SANITIZERS) $(COMPILER_OPTIMIZATION_LEVEL_DEBUG)
endif

ifneq ($(strip $(CROSS)),)
  CFLAGS += $(CC_ARM_OPTS) $(MCU_OPTS)
endif

# Compile up linker flags
LDFLAGS += $(DIAGNOSTIC_FLAGS)
ifneq ($(strip $(CROSS)),)
  LDFLAGS += -Wl,--start-group -lc -lm -Wl,-Wl,--gc-sections,-Wl,-Map--end-group # Need to think through link-time optimizations / garbage collection some more...
endif
ifeq ($(BUILD_TYPE), TEST)
   LDFLAGS += -lgcov --coverage
endif

# CppCheck flags/options

# Explanations for suppressions:
# 	- unknownEvaluationOrder:
#	  • CppCheck flagged as an error the following construct in ascii7seg.c:
# 		   const union Ascii7Seg_Encoding_U MasterLUT[ UINT8_MAX ] =
#        {
#           // cppcheck-suppress expressionDependOnOrderOfEvaluation
#           [(uint8_t)'0'] = { .segments = { .a = 1, .b = 1, .c = 1, .d = 1, .e = 1, .f = 1, .g = 0 }, },
#           ...
#
#    • This is _not_ an error. There are no internal side-effects being relied
#		 upon here. I think CppCheck is getting thrown off by the designated initializers.
CPPCHECK_SUPPRESSIONS = --suppress=unknownEvaluationOrder

CPPCHECK_OPTIONS = --std=c99 --cppcheck-build-dir=$(PATH_BUILD) $(CPPCHECK_SUPPRESSIONS)

# GCov
# gcov Flags
GCOV = gcov
GCOV_FLAGS = --conditions --function-summaries --branch-probabilities --branch-counts
ifeq ($(GCOV_CON), 1)
GCOV_FLAGS += --use-colors --stdout
endif
GCOV_CONSOLE_OUT_FILE = gcov_console_out.txt

# gcovr Flags
GCOVR_FLAGS = --html-details $(PATH_RESULTS)coverage.html


############################# The Rules & Recipes ##############################

######################### Lib Rules ########################
release: lib
# Build the static library files
lib: $(BUILD_DIRS) $(LIB_FILE) $(LIB_LIST_FILE)
	@echo
	@echo "----------------------------------------"
	@echo -e "Library \033[35m$(LIB_FILE) \033[32;1mbuilt\033[0m!"
	@echo "----------------------------------------"

$(LIB_FILE): $(LIB_OBJ_FILES) $(BUILD_DIRS) 
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mConstructing\033[0m the static library: $@..."
	@echo
	$(CROSS)ar rcs $@ $<

$(LIB_LIST_FILE): $(LIB_FILE)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mDisassembly\033[0m of $< into $@..."
	@echo
	$(CROSS)objdump -D $< > $@
	@echo "----------------------------------------"
	@echo -e "\033[36mAnnotated assembly file\033[0m of $(PATH_SRC)$(LIB_NAME).c into $(PATH_BUILD)$(LIB_NAME).s..."
	@echo
	$(CC) -S -fverbose-asm $(CC_ARM_OPTS) $(MCU_OPTS) $(COMPILER_OPTIMIZATION_LEVEL_DEBUG) $(COMPILER_WARNINGS) -fdiagnostics-color $(INCLUDE_PATHS) $(COMMON_DEFINES) -o $(PATH_BUILD)$(LIB_NAME).s $(PATH_SRC)$(LIB_NAME).c > /dev/null 2>&1

######################## Test Rules ########################
_test: $(BUILD_DIRS) $(TEST_EXECUTABLES) $(LIB_FILE) $(RESULTS) $(GCOV_FILES)
	@echo
	@echo -e "\033[36mAll tests completed!\033[0m"
	@echo

# Write the test results to a result .txt file
$(PATH_RESULTS)%.txt: $(PATH_BUILD)%.$(TARGET_EXTENSION) $(COLORIZE_UNITY_SCRIPT)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mRunning\033[0m $<..."
	@echo
	-./$< 2>&1 | tee $@ | python $(COLORIZE_UNITY_SCRIPT)

$(PATH_BUILD)%.$(TARGET_EXTENSION): $(TEST_OBJ_FILES) $(UNITY_OBJ_FILES) $(LIB_FILE)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mLinking\033[0m $(TEST_OBJ_FILES), $(UNITY_OBJ_FILES), and the static lib $(LIB_FILE) into an executable..."
	@echo
	$(CC) $(LDFLAGS) $(TEST_OBJ_FILES) $(UNITY_OBJ_FILES) -L$(dir $(LIB_FILE)) -l$(basename $(notdir $(LIB_FILE))) -o $@

######################### Generic ##########################

# Separate rules for the object files that belong to test files, Unity files,
# and module source files. This is primarily because I want different warning
# configurations.
$(PATH_OBJECT_FILES)%.o: $(PATH_TEST_FILES)%.c $(BUILD_DIRS)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mCompiling\033[0m the test file: $<..."
	@echo
	$(CC) -c $(CFLAGS_TEST_FILES) $< -o $@
	@echo

# Suppress -Wfloat-equal just for unity.c because I don't own that file...
# FIXME: Submit a PR/ticket to ThrowTheSwitch/Unity for this.
$(PATH_OBJECT_FILES)%.o: $(PATH_UNITY)%.c $(PATH_UNITY)%.h $(BUILD_DIRS)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mCompiling\033[0m the unity file: $<..."
	@echo
	$(CC) -c $(CFLAGS_TEST_FILES) -Wno-float-equal $< -o $@
	@echo

$(PATH_OBJECT_FILES)%.o : $(PATH_SRC)%.c $(PATH_INC)%.h $(BUILD_DIRS)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mCompiling\033[0m the primary source file: $<..."
	@echo
	$(CC) -c $(CFLAGS) $< -o $@
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mRunning static analysis\033[0m on $<..."
	@echo

# NOTE:
# gcov seems very picky about how the directory to look for .gcno and .gcda
# files is specified. The string for the directory must utilize forward slashes
# '/', not back slashes '\', and must not end with a forward slash. Otherwise,
# gcov exists with a cryptic
# 		<obj_dir>/.gcno:cannot open notes file
# kind of error. Hence, I use $(<path>:%/=%) /w PATH_OBJECT_FILES.
#
# Also, I've redirected gcov's output because I want to prioritize viewing the
# unit test results. Coverage results are meant to be inspected manually rather
# than fed back immediately to the developer.
$(PATH_SRC)%.c.gcov: $(PATH_SRC)%.c $(PATH_INC)%.h $(BUILD_DIRS)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mAnalyzing coverage\033[0m for $<..."
	$(GCOV) $(GCOV_FLAGS) --object-directory $(PATH_OBJECT_FILES:%/=%) $< > $(PATH_RESULTS)$(GCOV_CONSOLE_OUT_FILE)
	mv *.gcov $(PATH_RESULTS)
	gcovr $(GCOVR_FLAGS)
	@echo

#################### Profiling/Benchmarking ######################

ifdef MEMSTATS_TO_FILE
memstats: $(LIB_FILE)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mAnalyzing memory stats\033[0m for $<..."
	@echo
	$(CROSS)size $< > $(PATH_MEMSTATS)memstats_$(REL_SUBDIR).log
	@echo
	$(CROSS)nm -S --size-sort $< >> $(PATH_MEMSTATS)memstats_$(REL_SUBDIR).log
	@echo

else
memstats: $(LIB_FILE)
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mAnalyzing memory stats\033[0m for $<..."
	@echo
	$(CROSS)size $<
	@echo
	$(CROSS)nm -S --size-sort $<
	@echo

endif

######################### Miscellaneous ##########################

unity_static_analysis: $(PATH_UNITY)unity.c
	@echo
	@echo "----------------------------------------"
	@echo -e "\033[36mRunning static analysis\033[0m on $<..."
	@echo
	cppcheck $(CPPCHECK_OPTIONS) --template='{severity}: {file}:{line}: {message}' $< 2>&1 | tee $(PATH_BUILD)cppcheck.log | python $(COLORIZE_CPPCHECK_SCRIPT)


######################### Directories ##########################

$(PATH_RESULTS):
	$(MKDIR) $@

$(PATH_OBJECT_FILES):
	$(MKDIR) $@

$(PATH_BUILD):
	$(MKDIR) $@

$(PATH_PROFILE):
	$(MKDIR) $@

$(PATH_RELEASE):
	$(MKDIR) $@

$(PATH_RELEASE)$(REL_SUBDIR): $(PATH_RELEASE)
	$(MKDIR) $@

$(PATH_MEMSTATS):
	$(MKDIR) $@

$(PATH_DEBUG):
	$(MKDIR) $@

# Clean rule to remove generated files
clean:
	@echo
	$(CLEANUP) $(PATH_OBJECT_FILES)*.o
	$(CLEANUP) $(PATH_OBJECT_FILES)*.gcda
	$(CLEANUP) $(PATH_OBJECT_FILES)*.gcno
	$(CLEANUP) $(PATH_OBJECT_FILES)*.su
	$(CLEANUP) $(PATH_BUILD)*.$(TARGET_EXTENSION)
	$(CLEANUP) $(PATH_RESULTS)*.txt
	$(CLEANUP) $(PATH_RESULTS)*.html
	$(CLEANUP) $(PATH_RESULTS)*.css
	$(CLEANUP) $(PATH_BUILD)*.txt
	$(CLEANUP) $(PATH_BUILD)*.s1
	$(CLEANUP) $(PATH_BUILD)*.a1
	$(CLEANUP) $(PATH_BUILD)*.snalyzerinfo
	$(CLEANUP) $(PATH_BUILD)*.s
	$(CLEANUP) $(PATH_BUILD)*.a
	$(CLEANUP) $(PATH_BUILD)*.lib
	$(CLEANUP) $(PATH_BUILD)*.lst
	$(CLEANUP) $(PATH_BUILD)*.log
	$(CLEANUP) $(PATH_BUILD)*.md
	$(CLEANUP) $(PATH_BUILD)*.$(STATIC_LIB_EXTENSION)
	$(CLEANUP) $(PATH_BUILD)*.$(TARGET_EXTENSION)
	$(CLEANUP) $(PATH_BUILD)*.bin
	$(CLEANUP) $(PATH_BUILD)*.hex
	$(CLEANUP) -rf $(PATH_RELEASE)
	$(CLEANUP) -rf $(PATH_DEBUG)
	$(CLEANUP) $(PATH_BUILD)*.su
	@echo

.PRECIOUS: $(PATH_RESULTS)%.txt
