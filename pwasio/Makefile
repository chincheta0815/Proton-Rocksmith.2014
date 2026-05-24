LIB_NAME := pwasio.dll
DRIVER_REG := Software\\ASIO\\pwasio

VERSION_MAJOR := 0
VERSION_MINOR := 1
VERSION_PATCH := 0

DIR_LIB := lib
DIR_BLD := build
DIR_SRC := src

DIR_GUARD = mkdir -p $(@D)

CC := $(CC)
LIBS := -lodbc32 -lole32 -luuid -lwinmm -lshlwapi -lgdi32 -lcomctl32
PKG_CONFIG := libpipewire-0.3
CFLAGS := -fPIC -Wextra -Wall -Wno-missing-field-initializers -std=gnu2x
DEFNS := -D_REENTRANT -D_GNU_SOURCE -DLIB_NAME='"$(LIB_NAME)"' -DDRIVER_REG='"$(DRIVER_REG)"'
DEFNS += -DPWASIO_VERSION_MAJOR=$(VERSION_MAJOR)
DEFNS += -DPWASIO_VERSION_MINOR=$(VERSION_MINOR)
DEFNS += -DPWASIO_VERSION_PATCH=$(VERSION_PATCH)

ifeq ($(DEBUG),true)
CFLAGS += -O0 -g
DEFNS += -DDEBUG
else
CFLAGS += -O3 
DEFNS += -DNDEBUG
endif

#TARGET := $(DIR_LIB)/wine/x86_64-unix/$(LIB_NAME).so
TARGET := $(LIB_NAME:%.dll=%.so)
HEADERS := $(wildcard $(DIR_SRC)/*.h)
#BINARIES := $(patsubst $(DIR_SRC)/%.c, $(DIR_BLD)/%.o, $(wildcard $(DIR_SRC)/*.c))
BINARIES := $(patsubst $(DIR_SRC)/%.c, $(DIR_BLD)-$(M)/%.c.o, $(wildcard $(DIR_SRC)/*.c))
#RESOURCES := $(patsubst $(DIR_SRC)/%.rc, $(DIR_BLD)/%.res, $(wildcard $(DIR_SRC)/*.rc))
RESOURCES := $(patsubst $(DIR_SRC)/%.rc, $(DIR_BLD)-$(M)/%.res, $(wildcard $(DIR_SRC)/*.rc))

WINEBUILD := winebuild
WINECC := winegcc
WINERC := wrc
WINETARGET := $(LIB_NAME)

WINDOWSINC := /usr/include/wine/windows

32:
	$(MAKE) $(DIR_BLD)-32/$(TARGET) M=32
	$(MAKE) $(DIR_BLD)-32/$(WINETARGET) M=32

64:
	$(MAKE) $(DIR_BLD)-64/$(TARGET) M=64
	$(MAKE) $(DIR_BLD)-64/$(WINETARGET) M=64

$(DIR_BLD)-$(M)/%.c.o: $(DIR_SRC)/%.c $(HEADERS)
	$(DIR_GUARD)
	$(CC) $(DEFNS) $(CFLAGS) $(shell pkg-config --cflags $(PKG_CONFIG)) -I$(WINDOWSINC) $(WINEBUILD_EXTRA_INCLUDEDIR) -c $< -o $@

$(DIR_BLD)-$(M)/%.res: $(DIR_SRC)/%.rc $(HEADERS)
	$(DIR_GUARD)
	$(WINERC) -o $@ $<

$(DIR_BLD)-$(M)/$(TARGET): $(BINARIES) $(RESOURCES)
	$(DIR_GUARD)
	$(WINECC) --winebuild=$(WINEBUILD) \
	$^ -shared -m$(patsubst $(DIR_BLD)-%/$(TARGET),%,$@) $(LIB_NAME).spec $(shell pkg-config --libs $(PKG_CONFIG)) $(LIBS) $(WINEBUILD_EXTRA_LIBDIR) -o $@

$(DIR_BLD)-$(M)/$(WINETARGET): $(BINARIES) $(RESOURCES)
	$(DIR_GUARD)
	$(WINEBUILD) -m$(patsubst $(DIR_BLD)-%/$(WINETARGET),%,$@) --dll --fake-module -E $(LIB_NAME).spec $^ -o $@

clean:
	rm -rf $(DIR_BLD)
	rm -rf $(DIR_LIB)

all: 32 64

.PHONY: clean 32 64
