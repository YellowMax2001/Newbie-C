TmpVarNormalCppFiles := $(filter %.cpp, ${CompileSrcFiles})
TmpVarNormalCFiles   := $(filter %.c, ${CompileSrcFiles})

.PHONY: splitted_targets CompilePhonyAdditionalTarget

all:: splitted_targets ${CompileTarget}

all:: CompilePhonyAdditionalTarget

ifneq ($(strip ${SplittedCompileSrcFiles}),)
splitted_targets: $(patsubst %.c, %.c.o, $(filter %.c, ${SplittedCompileSrcFiles})) \
 $(patsubst %.cpp, %.cpp.o, $(filter %.cpp, ${SplittedCompileSrcFiles}))
	@echo "\033[31mCompile splitted targets is not empty, built it:\033[0m"
	@echo "\033[32m$(notdir $^)\033[0m"
	$(COMPILE_OPTION_PREFIX) $(foreach c_o, \
		$(filter %.c.o, $^), \
		echo "Out: $(notdir $(patsubst %.c.o, %, ${c_o}))"; \
		$(Compile_CC) -o $(patsubst %.c.o, %, ${c_o}) ${c_o} $(strip ${CompileCCLinkFlags});)
	$(COMPILE_OPTION_PREFIX) $(foreach cpp_o, \
		$(filter %.cpp.o, $^), \
		echo "Out: $(notdir $(patsubst %.cpp.o, %, ${cpp_o}))"; \
		$(Compile_CPP) -o $(patsubst %.cpp.o, %, ${cpp_o}) ${cpp_o} $(strip $(CompileCPPLinkFlags));)
endif

ifneq ($(strip ${CompileSrcFiles}),)
${CompileTarget}: $(patsubst %.cpp, %.cpp.o, $(filter %.cpp, ${CompileSrcFiles})) \
 $(patsubst %.c, %.c.o, $(filter %.c, ${CompileSrcFiles}))
	@echo "\033[31mCompile source is not empty, built it:\033[0m"
	@echo "\033[32m$(notdir $^)\033[0m"
ifeq (${TmpVarNormalCppFiles},)
	$(COMPILE_OPTION_PREFIX) $(Compile_CC) -o $@ $^ $(strip $(CompileCCFlags))
else
	$(COMPILE_OPTION_PREFIX) $(Compile_CPP) -o $@ $^ $(strip $(CompileCPPFlags))
endif
endif

%.c.o : %.c $(CompileHeaderFiles)
ifeq ($(BUILD_DBG),1)
	@echo "\033[31mCompile_CC:\033[0m \033[34m $(Compile_CC) \033[0m"
	@echo "\033[31mCompile_RootIncludeDir:\033[0m \033[34m $(Compile_RootIncludeDir) $(CompileHeaderFiles) \033[0m"
	@echo "\033[31mCompileCCFlags:\033[0m \033[34m $(CompileCCFlags) \033[0m"
	@echo "\033[31m$@:\033[0m \033[34m $^ \033[0m"
endif
ifeq (${TmpVarNormalCppFiles},)
	@ echo "CC  $(notdir $<)"
	$(COMPILE_OPTION_PREFIX)  $(Compile_CC) $(strip $(Compile_RootIncludeDir)) $(strip $(addprefix -I,$(CompileHeaderDirs))) -c -o $@ $< $(strip $(CompileCCFlags))
else
	@ echo "CPP $(notdir $<)"
	$(COMPILE_OPTION_PREFIX)  $(Compile_CPP) $(strip $(Compile_RootIncludeDir)) $(strip $(addprefix -I,$(CompileHeaderDirs)))  -c -o $@ $< $(strip $(CompileCPPFlags))
endif

%.cpp.o : %.cpp $(CompileHeaderFiles)
ifeq ($(BUILD_DBG),1)
	@echo "\033[31mCompile_CPP:\033[0m \033[34m $(Compile_CPP) \033[0m"
	@echo "\033[31mCompile_RootIncludeDir:\033[0m \033[34m $(Compile_RootIncludeDir) $(CompileHeaderFiles) \033[0m"
	@echo "\033[31mCompileCPPFlags:\033[0m \033[34m $(CompileCPPFlags) \033[0m"
	@echo "\033[31m$@:\033[0m \033[34m $^ \033[0m"
endif
	@ echo "CPP $(notdir $<)"
	$(COMPILE_OPTION_PREFIX) $(Compile_CPP) $(strip $(Compile_RootIncludeDir)) $(strip $(addprefix -I,$(CompileHeaderDirs)))  -c -o $@ $< $(strip $(CompileCPPFlags))

distclean:: clean
	@echo "\033[31m Distclean \033[0m \033[34m \033[0m"
	@$(call rm_files, ${CompileTarget})
	@$(call rm_files, $(patsubst %.cpp, %, $(filter %.cpp, ${SplittedCompileSrcFiles})))
	@$(call rm_files, $(patsubst %.c, %, $(filter %.c, ${SplittedCompileSrcFiles})))

clean:
	@echo "\033[31m Clean\033[0m \033[34m \033[0m"
	@$(call rm_files, $(patsubst %.c, %.c.o, $(filter %.c, ${CompileSrcFiles})))
	@$(call rm_files, $(patsubst %.cpp, %.cpp.o, $(filter %.cpp, ${CompileSrcFiles})))
	@$(call rm_files, $(patsubst %.c, %.c.o, $(filter %.c, ${SplittedCompileSrcFiles})))
	@$(call rm_files, $(patsubst %.cpp, %.cpp.o, $(filter %.cpp, ${SplittedCompileSrcFiles})))

.PHONY : clean distclean
