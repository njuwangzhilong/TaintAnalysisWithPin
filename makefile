##############################################################
#
#                   DO NOT EDIT THIS FILE!
#
##############################################################

# If the tool is built out of the kit, PIN_ROOT must be specified in the make invocation and point to the kit root.
ifdef PIN_ROOT
CONFIG_ROOT := $(PIN_ROOT)/source/tools/Config
else
CONFIG_ROOT := ../Config
endif
#include $(CONFIG_ROOT)/makefile.config
#include makefile.rules 
#include $(TOOLS_ROOT)/Config/makefile.default.rules
INCLUDE_PATH = -Iinclude -I../../../source/include/pin -I../../../source/include/pin/gen -isystem ../../../extras/stlport/include -isystem ../../../extras/libstdc++/include -isystem ../../../extras/crt/include -isystem ../../../extras/crt/include/arch-x86 -isystem ../../../extras/crt/include/kernel/uapi -isystem ../../../extras/crt/include/kernel/uapi/asm-x86 -I../../../extras/components/include -I../../../extras/xed-ia32/include/xed -I../../../source/tools/InstLib
CXXFLAGS = -std=c++11 -g3 -Wall  -Wno-unknown-pragmas -D__PIN__=1 -DPIN_CRT=1 -fno-stack-protector -fno-exceptions -funwind-tables -fasynchronous-unwind-tables -fno-rtti -DTARGET_IA32 -DHOST_IA32 -DTARGET_LINUX -fabi-version=2  -O3 -fomit-frame-pointer -fno-strict-aliasing -m32 
ISYSTEM_PATH = -isystem ../../../extras/stlport/include -isystem ../../../extras/libstdc++/include -isystem ../../../extras/crt/include -isystem ../../../extras/crt/include/arch-x86_64 -isystem ../../../extras/crt/include/kernel/uapi -isystem ../../../extras/crt/include/kernel/uapi/asm-x86
LD_PATH = -L../../../ia32/runtime/pincrt -L../../../ia32/lib -L../../../ia32/lib-ext -L../../../extras/xed-ia32/lib -lpin -lxed ../../../ia32/runtime/pincrt/crtendS.o -lpin3dwarf  -ldl-dynamic -nostdlib -lstlport-dynamic -lm-dynamic -lc-dynamic -lunwind-dynamic
LD_FLAGS = -g3 -shared -Wl,--hash-style=sysv ../../../ia32/runtime/pincrt/crtbeginS.o -Wl,-Bsymbolic -Wl,--version-script=../../../source/include/pin/pintool.ver -fabi-version=2 -m32
OBJDIR = obj-ia32
OBJECTS = ${addprefix src/, ${patsubst %.cpp,%.o, ${filter %.cpp,${shell ls src/}}}} 
VPATH = src:include

${OBJDIR}/taint.so : $(OBJECTS)
	g++ ${LD_FLAGS} -o $@ $(OBJECTS) ${LD_PATH}  

$(OBJECTS) : %.o: %.cpp 
	g++ ${INCLUDE_PATH} ${CXXFLAGS}  ${ISYSTEM_PATH} -c -o $@ $<

exam3.1:
	../../../pin -t obj-ia32/taint.so -- ../TaintTest/test/exam3

exam3:
	../../../pin -t obj-ia32/taint.so -- test/exam3

exam2:
	../../../pin -t obj-ia32/taint.so -- test/exam2

exam1:
	../../../pin -t obj-ia32/taint.so -- test/exam1


exam1.1:
	../../../pin -t obj-ia32/taint.so -- test/exam1.1

gdb:
	gdb ../../../intel64/bin/pinbin

debug_exam3:
	../../../pin -pause_tool 20 -t obj-ia32/taint.so -- test/exam3

clean:
	rm -rf src/*.o
	rm ${OBJDIR}/taint.so

##############################################################
#
#                   DO NOT EDIT THIS FILE!
#
##############################################################
