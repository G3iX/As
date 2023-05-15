DEPS = $(wildcard *.h)  # зависимости - хеадер файлы
SRCS = $(wildcard *.s)  # ресурсы
OBJS = $(SRCS:.s=.o) 	# объекты
EXES = $(SRCS:.s=) 	# исполняемые файлы
ASFLAGS = # -g dwarf	# ? CFLAGS = -c -Wall		# flags from us to compiler
LDFLAGS =		# ?

all: $(EXES) 		# target all собирает все файлы

$(OBJS): %.o: %.s $(DEPS) 
	#@echo "[ASSEM] $‹ -> $@" 
	$(AS) $(ASFLAGS) -o $@ $< 

$(EXES): %: %.o 
	#@echo "[LINK] $‹ -> $@" 	
	$(LD) $(LDFLAGS) -o $@ $< 

.PHONY: test clean 

clean: 
	rm -fv $(OBJS) $(EXES)

test: 
	#@echo "DEPS = $(DEPS)"
	#@echo "SRCS = $(SRCS)"
	#@echo "OBJS = $(OBJS)"
	#@echo "EXES = $(EXES)"
