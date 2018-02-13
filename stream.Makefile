

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

#ifeq ($(BUILD_PCRE), YES)
PCRE_LIB=$(PCRE)/O.$(T_A)
PCRE_INCLUDE=$(PCRE)
USR_INCLUDES += -I$(PCRE_INCLUDE)
USR_LDFLAGS  += -L $(PCRE_LIB)
USR_LDFLAGS += -lpcre
USR_LDFLAGS += -Wl,-rpath=$(PCRE_LIB)
#else
#USR_LIBS += pcre
#USR_LIBS += pcrecpp
#endif


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



