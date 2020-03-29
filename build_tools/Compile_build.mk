#TOP_DIR := $(shell pwd)
Compile_RootIncludeDir_Default := $(TOP_DIR)/MaxCLib/unity_tools/ \
	$(shell find ${TOP_DIR} -name "include")

Compile_CCPrefix := ${COMPILE_CC_PREFIX}

Compile_CC := ${Compile_CCPrefix}gcc
Compile_CPP := ${Compile_CCPrefix}g++
Compile_AR := ${Compile_CCPrefix}ar

CC_COMPILE_FLAG := -std=gnu99
CC_LINK_FLAG := -lpthread
CPP_COMPILE_FLAG :=
CPP_LINK_FLAG :=
SYS_INC := $(addprefix -I,$(Compile_RootIncludeDir_Default))

# Default params
Compile_RootIncludeDir_Default := ${SYS_INC}
CompileHeaderFiles_Default :=
CompileSrcFiles_Default :=
CompileCCFlags_Default := ${CC_COMPILE_FLAG}
CompileCCLinkFlags_Default := ${CC_LINK_FLAG}
CompileCPPFlags_Default := ${CPP_COMPILE_FLAG}
CompileCPPLinkFlags_Default := ${CPP_LINK_FLAG}
CompileTarget_Default :=
CompileTargetLists :=
SplittedCompileSrcFiles_Default :=
CompileCleanDirs_Default :=

#to make the sub-make can use it
export Compile_CC Compile_CPP Compile_AR
export Compile_RootIncludeDir_Default CompileHeaderFiles_Default
export SplittedCompileSrcFiles_Default CompileSrcFiles_Default
export CompileCCFlags_Default CompileCPPFlags_Default CompileCCLinkFlags_Default CompileCPPLinkFlags_Default
export CompileTarget_Default CompileTargetLists CompileCleanDirs_Default

-include $(TOP_DIR)/$(BUILD_DEFAULT_SUB_LISTS_SCRIPT)

# If we got a unempty ${CUR_DIR}/Compile.mk file,
# then just build the Compile.mk target.
# else build all Compile_list.mk targets.
ifeq ($(BUILD_SCRIPT_FILE), $(wildcard $(BUILD_SCRIPT_FILE)))
CompileTargetLists := $(MAXBUILD_DIR)
endif

all:
	@ $(foreach module,${CompileTargetLists},@ make -C ${module} -f $(BUILD_DEFAULT_SUB_SCRIPT) BUILD_DBG=$(BUILD_DBG) all)

clean:
	@ $(foreach module,${CompileTargetLists},@ make -C ${module} -f $(BUILD_DEFAULT_SUB_SCRIPT) BUILD_DBG=$(BUILD_DBG) clean)

distclean:
	@ $(foreach module,${CompileTargetLists},@ make -C ${module} -f $(BUILD_DEFAULT_SUB_SCRIPT) BUILD_DBG=$(BUILD_DBG) distclean)

.PHONY : clean distclean