

where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(E3_REQUIRE_TOOLS)/driver.makefile

APP:=StreamDevice
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

PCRE:=$(where_am_I)pcre

BUSSES  += AsynDriver
BUSSES  += Dummy

FORMATS += Enum
FORMATS += BCD
FORMATS += Raw
FORMATS += RawFloat
FORMATS += Binary
FORMATS += Checksum
FORMATS += Regexp
FORMATS += MantissaExponent
FORMATS += Timestamp


RECORDTYPES += ao ai
RECORDTYPES += bo bi
RECORDTYPES += mbbo mbbi
RECORDTYPES += mbboDirect mbbiDirect
RECORDTYPES += longout longin
RECORDTYPES += stringout stringin
RECORDTYPES += waveform
RECORDTYPES += calcout
RECORDTYPES += aai aao

SOURCES += $(RECORDTYPES:%=$(APPSRC)/dev%Stream.c)
SOURCES += $(FORMATS:%=$(APPSRC)/%Converter.cc)
SOURCES += $(BUSSES:%=$(APPSRC)/%Interface.cc)
SOURCES += $(wildcard $(APPSRC)/Stream*.cc)
SOURCES += $(APPSRC)/StreamVersion.c


HEADERS += $(APPSRC)/devStream.h
HEADERS += $(APPSRC)/StreamFormat.h
HEADERS += $(APPSRC)/StreamFormatConverter.h
HEADERS += $(APPSRC)/StreamBuffer.h
HEADERS += $(APPSRC)/StreamError.h

ifeq (linux-ppc64e6500, $(T_A))
PCRE_LIB=$(PCRE)/O.$(T_A)
PCRE_INCLUDE=$(PCRE)
USR_INCLUDES += -I$(PCRE_INCLUDE)
USR_LDFLAGS  += -L $(PCRE_LIB)
USR_LDFLAGS += -lpcre
USR_LDFLAGS += -Wl,-rpath=$(PCRE_LIB)
else
USR_LIBS += pcre
USR_LIBS += pcrecpp
endif


StreamVersion$(DEP): pcre pcre-clean

StreamCore$(DEP): streamReferences 

# the original StreamDevice GNUMakefile uses perl
# I would like to use EPICS PERL instead of perl
# $PERL = perl -CSD 

streamReferences:
	$(PERL) $(where_am_I)$(APPSRC)/makeref.pl Interface $(BUSSES)   > $@
	$(PERL) $(where_am_I)$(APPSRC)/makeref.pl Converter $(FORMATS) >> $@

export DBDFILES = streamSup.dbd


streamSup.dbd: 
	@echo Creating $@
	$(PERL) $(where_am_I)$(APPSRC)/makedbd.pl $(RECORDTYPES) > $@


# db rule is the default in RULES_E3, so add the empty one

db:






# #where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# include $(E3_REQUIRE_TOOLS)/driver.makefile

# #APP:=modbusApp
# #APPDB:=$(APP)/Db
# #APPSRC:=$(APP)/src

# #USR_INCLUDES += -I$(where_am_I)/$(APPSRC)

# #TEMPLATES += $(wildcard $(APPDB)/*.template)


# #SOURCES   += $(APPSRC)/modbusInterpose.c
# #SOURCES   += $(APPSRC)/drvModbusAsyn.c
# #DBDS      += $(APPSRC)/modbusSupport.dbd
# #HEADERS   += $(APPSRC)/drvModbusAsyn.h


# # 
# #USR_CFLAGS   += -Wno-unused-variable
# #USR_CFLAGS   += -Wno-unused-function
# #USR_CPPFLAGS += -Wno-unused-variable
# #USR_CPPFLAGS += -Wno-unused-function

# #
# #
# # The following lines must be updated according to your stream
# #
# # Examples...
# # 
# # USR_CFLAGS += -fPIC
# # USR_CFLAGS   += -DDEBUG_PRINT
# # USR_CPPFLAGS += -DDEBUG_PRINT
# # USR_CPPFLAGS += -DUSE_TYPED_RSET
# # USR_INCLUDES += -I/usr/include/libusb-1.0
# # USR_LDFLAGS += -lusb-1.0

# # USR_LDFLAGS += -L /opt/etherlab/lib
# # USR_LDFLAGS += -lethercat
# # USR_LDFLAGS += -Wl,-rpath=/opt/etherlab/lib
# #
# #
# # PCIAPP:= pciApp
# #
# # HEADERS += $(PCIAPP)/devLibPCI.h
# # HEADERS += $(PCIAPP)/devLibPCIImpl.h

# # SOURCES += $(wildcard $(PCIAPP)/devLib*.c)
# # SOURCES += $(PCIAPP)/pcish.c
# # SOURCES_Linux += $(PCIAPP)/os/Linux/devLibPCIOSD.c

# # DBDS += $(PCIAPP)/epicspci.dbd

# # MRMSHARED:= mrmShared
# # MRMSHAREDSRC:=$(MRMSHARED)/src
# # MRMSHAREDDB:=$(MRMSHARED)/Db
# # TEMPLATES += $(wildcard $(MRMSHAREDDB)/*.db)
# # TEMPLATES += $(wildcard $(MRMSHAREDDB)/*.template)
# # TEMPLATES += $(wildcard $(MRMSHAREDDB)/*.substitutions)

