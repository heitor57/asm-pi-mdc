        .data
dn1:    .double     -1.0
d0:     .double     0.0
d1:     .double     1.0
d2:     .double     2.0
d4:     .double     4.0
        .text
        j           main
pi:

        move        $t1,$sp             # guarda stack pointer antigo
        andi        $sp,$sp, 0xfffffff8 # alinha o sp
        addi        $sp,$sp,-40         # abre espaço no sp
        sdc1        $f2,0($sp)          # salva valores
        sdc1        $f4,8($sp)
        sdc1        $f6,16($sp)
        sdc1        $f8,24($sp)
        sdc1        $f12,32($sp)
        l.d         $f0,d0              # f0 = 0, variavel que guarda o resultado
        l.d         $f2,d1              # f2 = 1, divisor
        l.d         $f4,d1              # f4 = 1, sinal
        l.d         $f6,dn1             # f6 = -1, mudador de sinal
        l.d         $f8,d2              # f8 = 2, taxa de crescimento divisor
        l.d         $f12,d4             # f12 = 4, dividendo sempre 4
        move        $t0,$a0             # numero de termos
loop:
        beq         $t0,$zero,end       # checa se acabou os termos
        div.d       $f10,$f12,$f2       # 4/divisor
        mul.d       $f10,$f10,$f4       # sinal*(4/divisor)
        add.d       $f0,$f0,$f10        # resultado = resultado + sinal*(4/divisor)
        mul.d       $f4,$f4,$f6         # muda o sinal, $f4*-1
        add.d       $f2,$f2,$f8         # divisor + 2
        addi        $t0,$t0,-1          # diminui numero de termos
        j           loop
end:
        ldc1        $f2,0($sp)
        ldc1        $f4,8($sp)
        ldc1        $f6,16($sp)
        ldc1        $f8,24($sp)
        ldc1        $f12,32($sp)        # volta com os valores antigos
        move        $sp,$t1             # libera espaço sp, valor inicial
        jr          $ra                 # retorna

main:
        addi        $v0,$zero,5         # $v0 = 5, função le inteiro
        syscall                         # a função receberá o número de termos a serem somados
        add         $a0,$v0,$zero       # número de termos
        jal         pi
        mov.d       $f12,$f0
        addi        $v0,$zero,3         # imprime double
        syscall                         # imprime o registrador $f12
