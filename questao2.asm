        .text
j main

fmdc:
        addi        $sp,$sp,-12 # guarda valores na pilha
        sw          $a0,0($sp)
        sw          $a1,4($sp)
        sw          $ra,8($sp)
        jal         mdc
        lw          $a0,0($sp) # desempilha
        lw          $a1,4($sp)
        lw          $ra,8($sp)
        addi        $sp,$sp,12
        jr          $ra

mdc:                                    # mdc(a,b)
        bne         $a1,$zero,else      # if (b == 0)
        move        $v0,$a0             #
        jr          $ra                 # return a
else:
        addi        $sp,$sp,-4          # salva $ra
        sw          $ra,0($sp)
        move        $t0,$a1             # temp = b
        rem         $a1,$a0,$a1         # b = a % b
        move        $a0,$t0             # a = temp
        jal         mdc                 # mdc(b,a%b) chama a função recursivamente
        lw          $ra,0($sp)          # desempilha valor salvo
        addi        $sp,$sp,4
        jr          $ra

main:
        addi        $v0,$zero,5         # $v0 = 5, função le inteiro
        syscall                         # a função receberá o número de termos a serem somados
        add         $a0,$v0,$zero
        addi        $v0,$zero,5         # $v0 = 5, função le inteiro
        syscall                         # a função receberá o número de termos a serem somados
        add         $a1,$v0,$zero
        jal         fmdc
        move        $a0,$v0
        addi        $v0,$zero,1         # $v0 = 1, imprime inteiro
        syscall
