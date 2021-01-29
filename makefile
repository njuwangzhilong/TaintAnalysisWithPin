##############################################################
#
#                   DO NOT EDIT THIS FILE!
#
##############################################################

# If the tool is built out of the kit, PIN_ROOT must be specified in the make invocation and point to the kit root.
ifdef PIN_ROOT
CONFIG_ROOT := $(PIN_ROOT)/source/tools/Config
else
CONFIG_ROOT := ./pin
endif
#include $(CONFIG_ROOT)/makefile.config
#include makefile.rules 
#include $(TOOLS_ROOT)/Config/makefile.default.rules

INCLUDE_PATH = -Iinclude -I$(CONFIG_ROOT)/source/include/pin -I$(CONFIG_ROOT)/source/include/pin/gen -isystem $(CONFIG_ROOT)/extras/stlport/include -isystem $(CONFIG_ROOT)/extras/libstdc++/include -isystem $(CONFIG_ROOT)/extras/crt/include -isystem $(CONFIG_ROOT)/extras/crt/include/arch-x86 -isystem $(CONFIG_ROOT)/extras/crt/include/kernel/uapi -isystem $(CONFIG_ROOT)/extras/crt/include/kernel/uapi/asm-x86 -I$(CONFIG_ROOT)/extras/components/include -I$(CONFIG_ROOT)/extras/xed-ia32/include/xed -I$(CONFIG_ROOT)/source/tools/InstLib
CXXFLAGS = -std=c++11 -g3 -Wall  -Wno-unknown-pragmas -D__PIN__=1 -DPIN_CRT=1 -fno-stack-protector -fno-exceptions -funwind-tables -fasynchronous-unwind-tables -fno-rtti -DTARGET_IA32 -DHOST_IA32 -DTARGET_LINUX -fabi-version=2  -O3 -fomit-frame-pointer -fno-strict-aliasing -m32 
ISYSTEM_PATH = -isystem $(CONFIG_ROOT)/extras/stlport/include -isystem $(CONFIG_ROOT)/extras/libstdc++/include -isystem $(CONFIG_ROOT)/extras/crt/include -isystem $(CONFIG_ROOT)/extras/crt/include/arch-x86 -isystem $(CONFIG_ROOT)/extras/crt/include/kernel/uapi -isystem $(CONFIG_ROOT)/extras/crt/include/kernel/uapi/asm-x86
LD_PATH = -L$(CONFIG_ROOT)/ia32/runtime/pincrt -L$(CONFIG_ROOT)/ia32/lib -L$(CONFIG_ROOT)/ia32/lib-ext -L$(CONFIG_ROOT)/extras/xed-ia32/lib -lpin -lxed $(CONFIG_ROOT)/ia32/runtime/pincrt/crtendS.o -lpin3dwarf  -ldl-dynamic -nostdlib -lstlport-dynamic -lm-dynamic -lc-dynamic -lunwind-dynamic
LD_FLAGS = -g3 -shared -Wl,--hash-style=sysv $(CONFIG_ROOT)/ia32/runtime/pincrt/crtbeginS.o -Wl,-Bsymbolic -Wl,--version-script=$(CONFIG_ROOT)/source/include/pin/pintool.ver -fabi-version=2 -m32
OBJDIR = obj-ia32
OBJECTS = ${addprefix src/, ${patsubst %.cpp,%.o, ${filter %.cpp,${shell ls src/}}}} 
VPATH = src:include

${OBJDIR}/taint.so : $(OBJECTS)
	g++ ${LD_FLAGS} -o $@ $(OBJECTS) ${LD_PATH}  

$(OBJECTS) : %.o: %.cpp 
	g++ ${INCLUDE_PATH} ${CXXFLAGS}  ${ISYSTEM_PATH} -c -o $@ $<

exam3.1:
	$(CONFIG_ROOT)/pin -t obj-ia32/taint.so -- ../TaintTest/test/exam3

exam3:
	$(CONFIG_ROOT)/pin -t obj-ia32/taint.so -- test/exam3

exam2:
	$(CONFIG_ROOT)/pin -t obj-ia32/taint.so -- test/exam2

exam1:
	$(CONFIG_ROOT)/pin -t obj-ia32/taint.so -- test/exam1


exam1.1:
	$(CONFIG_ROOT)/pin -t obj-ia32/taint.so -- test/exam1.1

gdb:
	gdb $(CONFIG_ROOT)/intel64/bin/pinbin

debug_exam3:
	$(CONFIG_ROOT)/pin -pause_tool 20 -t obj-ia32/taint.so -- test/exam3

clean:
	rm -rf src/*.o
	rm ${OBJDIR}/taint.so

##############################################################
#
#                   DO NOT EDIT THIS FILE!
#
##############################################################
