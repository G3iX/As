.intel_syntax noprefix

.section .text  

.global _start

_strlen:

  push  rcx            # save and clear out counter
  xor   rcx, rcx

_strlen_next:

  cmp byte ptr   [rdi], 0	# null byte yet?
  jz    _strlen_null   	# yes, get out

  inc   rcx            # char is ok, count it
  inc   rdi            # move to next char
  jmp   _strlen_next   # process again

_strlen_null:

  mov   rax, rcx       # rcx = the length (put in rax)

  pop   rcx            # restore rcx
  ret                  # get out

_start:
	
	mov rax, [rsp] # розіменування і запис до rax із стеку argc змінної
	cmp rax, 2
	jne exit
	mov r14, [rsp+16] # зберігаємо ім'я файлу (str address) -> перший аргумент системного виклику
	
	 
	mov rdi,r14
 	call _strlen
	mov rdx, rax	
	mov rsi, r14
	.equ writeto, 1
	mov rax, writeto
	mov rdi, writeto
	syscall
	
	.equ sysopen, 2
	mov rax, sysopen # для виклику syscall треба покласти номер цього системного виклику в rax
	mov rdi, r14 # 
	mov rsi, 0 # режим флаги відкриття 
	mov rdx, 0 #
	syscall 	# 11111111
	# rax will contain file-descriptor
	xchg rax,rdi 
	.equ syslseek, 8
	mov rax, syslseek 	# засунули в ракс цей файл (абстрактний курсор яким ми можепо читать з файла \ виймать з файла) -> 
				# -> повертає розмір від 0л до кінця
	mov rdx, 2 		# позиція відносно кінця файлу 
	mov rsi, 0      	# зсув курсора на 2
	mov r8, rdi		#
	syscall			# 222222222222
	mov rsi,rax		#
	.equ sysmmap, 9		# 
	mov rax, sysmmap
	mov rdi, 0 		# null pointer
	.equ sysprotread, 1
	mov rdx, sysprotread
	.equ mapshared, 1
	mov r10, mapshared
	mov r9, 0 	# offset
	syscall		# 333333333
	# in result - дає указник на цей відкритий файл
	mov rdx, rsi
	mov rsi, rax

	mov rdi, writeto # stdout = 1, same as writeto
	mov rax, writeto
	syscall
	mov rdi, rsi	# in write we've  pointer len, but we need them as 1 and 2 cor.
	mov rsi, rdx
	.equ munmap, 11
	mov rax, munmap
	syscall
	# then we need file descriptor
	mov rdi, r8
	.equ sysclose, 3
	mov rax, sysclose
	syscall
	
	
exit: # basis на виклик syscall
	.equ sexit, 60
	mov rax, sexit # sys_exit = 60
	mov rdi, 0 
	syscall  
