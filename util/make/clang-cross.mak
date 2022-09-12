#  File : util/make/gcc-cross-linux.mak
#	GCC Tool Definitions, Host Compile and Run, cross from host to a linux target
#
#  EEMBC : Technical Advisory Group (TechTAG)
#------------------------------------------------------------------------------
# Copyright (c) 1998-2007 by the EDN Embedded Microprocessor 
# Benchmark Consortium (EEMBC), Inc. All Rights Reserved.
#==============================================================================

# RUN OPTIONS SECTION
# Build or run options (i.e. profiling, simulation)

# SYSTEM ENVIRONMENT SECTION

# Tools Root Directory
# This example uses a cross compiler built with crosstool targeting x86 linux.
TOOLS	= $(HOME)/software/llvm-arm
#TPREF = i386-unknown-linux-gnu- # On by default to ARM
# And this shows compiling to a big endian mips linux
# TOOLS	= /opt/crosstool/gcc-3.3.6-glibc-2.3.2/mips-unknown-linux-gnu
# TPREF = mips-unknown-linux-gnu-
# * remember to set big endian flags below for this setting!
#SHELL	= /bin/bash
TGT_ROOT=$(HOME)/Projects/s3lab/asan-stm/db-root

# Tools Executables, Output File Flag and Output File Types

# Variable: CC
#	name of the compiler
CC		= $(TOOLS)/bin/clang
# Solaris: /usr/ccs/bin/as requires space after -o passed from gcc.
OBJOUT	= -o 
COBJT	= -c 
CINCD	= -I 
CDEFN	= -D 
OEXT = .o

AS		= $(TOOLS)/bin/llvm-as

LD		= $(TOOLS)/bin/clang
EXEOUT	= -o 
EXE		= .exe

AR		= $(TOOLS)/bin/llvm-ar
LIBTYPE	= .a
LIBOUT	= 

# Some Tool Chains require specific perl version. 
# makefile default setting can be overridden here.
#PERL=`which perl`

# COMPILER SECTION

INCLUDE = $(TOOLS)/include

ASAN_FLAGS=-fsanitize=address
DECOUPLE_FLAGS=-mllvm -asan-decouple
COMPILER_FLAGS	= -g -O2 $(CDEFN)NDEBUG $(CDEFN)HOST_EXAMPLE_CODE=1
COMPILER_NOOPT	= -O0 $(CDEFN)NDEBUG $(CDEFN)HOST_EXAMPLE_CODE=1
COMPILER_DEBUG	= -O0 -g $(CDEFN)HOST_EXAMPLE_CODE=1 -DBMDEBUG=1 -DTHDEBUG=1
PACK_OPTS = $(ASAN_FLAGS) $(DECOUPLE_FLAGS) --sysroot=$(TGT_ROOT)

#Variable: CFLAGS 
#	Options for the compiler.
ifdef DDB
 CFLAGS = $(COMPILER_DEBUG) $(COMPILER_DEFS) $(PLATFORM_DEFS) $(PACK_OPTS)
else
 ifdef DDN
  CFLAGS = $(COMPILER_NOOPT) $(COMPILER_DEFS) $(PLATFORM_DEFS) $(PACK_OPTS) 
 else
  CFLAGS = $(COMPILER_FLAGS) $(COMPILER_DEFS) $(PLATFORM_DEFS) $(PACK_OPTS)
 endif
endif
ifdef DDT
 CFLAGS += -DTHDEBUG=1
endif

WARNING_OPTIONS	=	\
        -Wall -Wno-long-long -fno-asm -fsigned-char 

# Additional include files not in dependancies or system include.
COMPILER_INCLUDES = 
# Override harness thincs, make sure you take care of the harness paths
#THINCS=

#Variable: COMPILER_DEFINES
# Optional - Passed to compiler, here or in makefile to override THCFG defines.
COMPILER_DEFINES += HAVE_SYS_STAT_H=1 USE_NATIVE_PTHREAD=1 GCC_INLINE_MACRO=1
# For Big Endian Targets, using 0/1 also allows support for
# files that do not have EEMBC includes. (Don't quote the string)
#COMPILER_DEFINES += EE_BIG_ENDIAN=1 EE_LITTLE_ENDIAN=0
COMPILER_DEFS = $(addprefix $(CDEFN),$(COMPILER_DEFINES))
PLATFORM_DEFS = $(addprefix $(CDEFN),$(PLATFORM_DEFINES))

# ASSEMBLER SECTION

ASSEMBLER_FLAGS		= $(ASAN_FLAGS)
ASSEMBLER_INCLUDES	=

# LINKER SECTION
# -lm is optional. Some linkers (linux gcc) do not include math library by default.
LINKER_FLAGS	+= -lm -lpthread --sysroot=$(TGT_ROOT) -fuse-ld=$(TOOLS)/bin/ld.lld $(ASAN_FLAGS)

LINKER_INCLUDES	= 
# Some linkers do not re-scan libraries, and require some libraries 
# to be placed last on the command line to resolve references.
# some linkers require -lrt since they do not include realtime clock functions by default.
LINKER_LAST 	+= -lrt

# LIBRARIAN SECTION
LIBRARY_FLAGS	= scr

# SIZE SECTION
SIZE	= size
SIZE_FLAGS		= 

# CONTROL SECTION

ARFLAGS = $(LIBRARY_FLAGS)
LIBRARY     = $(AR) $(ARFLAGS)
LIBRARY_LAST =


