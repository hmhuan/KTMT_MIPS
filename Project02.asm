.data
	menu: .asciiz "\n============= Menu ============\n1. Nhap Mang\n2. Xuat Mang\n3. Liet ke so nguyen to trong mang\n4. Liet ke so hoan thien trong mang\n5. Tinh tong cac so chinh phuong trong mang\n6. Tinh trung binh cong cac so doi xung trong mang\n7. Tim gia tri lon nhat trong mang\n8. Sap xep mang tang dan theo Selection sort\n9. Sap xep mang giam dan theo Bubble sort\n10. Thoat\n================================\nChon: "
	error: .asciiz "Nhap sai gia tri chon.\n"
	tbNhapN: .asciiz "Nhap n: "
	tb1: .asciiz "a["
	tb2: .asciiz "] = "
	tbXuatMang: .asciiz "Mang vua nhap la: "
	tbXuatSoNT: .asciiz "Cac so nguyen to trong mang: "
	tbXuatSoHT: .asciiz "Cac so hoan thien trong mang: "
	tbTongCP: .asciiz "Tong cac so chinh phuong: "
	tbTBCSoDX: .asciiz "Trung binh cong cac so doi xung: "
	tbMax: .asciiz "Gia tri lon nhat: "
	tbSXTang: .asciiz "Mang sap xep tang: "
	endl: .asciiz "\n"
	n: .word 0
	arr: .space 4000
.text
	.globl main
main:

XuatMenu:
	#Xuat menu
	li $v0,4
	la $a0,menu
	syscall

	#Nhap gia tri chon
	li $v0,5
	syscall

	#Luu chon vao $t0
	move $t0,$v0
	
	beq $t0, 1, _Func_NhapMang
	beq $t0, 2, _Func_XuatMang
	beq $t0, 3, _Func_LietKeNT
	beq $t0, 4, _Func_LietKeHT
	beq $t0, 5, _Func_TongCP
	beq $t0, 6, _Func_TBCSoDX
	beq $t0, 7, _Func_TimMax
	beq $t0, 8, _Func_SSort
	#beq $t0, 9, SortGiam
	beq $t0, 10, Thoat
	j NhapSai

NhapSai:
	# xuat tb8
	li $v0,4
	la $a0,error
	syscall
	j XuatMenu

Thoat:
	#ket thuc chuong trinh
	li $v0, 10
	syscall

#1. Ham nhap mang -----------------------------------------------------------------
_Func_NhapMang:
	la $a1, arr
	#la $a2, n
	jal _NhapMang
	
	sw $v0, n
		
	j XuatMenu
_NhapMang:
	
	#Khai bao kich thuoc stack
	addi $sp,$sp,-12
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $s1, 8($sp)
	#Xuat tb1
	li $v0,4
	la $a0,tbNhapN
	syscall
	
	#Nhap so nguyen
	li $v0,5
	syscall
	#la $a2, ($v0)
	move $s1, $v0
	#khoi tao vong lap
	li $t0, 0 # i = 0
	
#Than thu tuc:	
_NhapMang.Lap:
	
	beq $t0, $s1, _NhapMang.KetThuc
	#Xuat tb2 a[
	li $v0,4
	la $a0,tb1
	syscall
	#xuat chi so i
	li $v0,1
	move $a0,$t0
	syscall
	#Xuat tb3 ]:
	li $v0,4
	la $a0,tb2
	syscall
	#load gia tri vao a[i]
	li $v0, 5
	syscall
	sw $v0, ($a1)
	
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _NhapMang.Lap

_NhapMang.KetThuc:

	move $v0, $s1
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $s1, 8($sp)
	#Xoa stack
	addi $sp,$sp,12
	#Nhay ve dia chi goi ham
	jr $ra
#----------------------------------------------------------------------------------
#2. Ham Xuat Mang -----------------------------------------------------------------
_Func_XuatMang:
	
	#Xuat tb4
	li $v0,4
	la $a0,tbXuatMang
	syscall
	
	la $a1, arr
	lw $a2, n
	jal _XuatMang
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
_XuatMang:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-8
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0,4($sp)
	#khoi tao vong lap
	li $t0, 0 # i = 0
	
#Than thu tuc:	
_XuatMang.Lap:
	
	beq $t0, $a2, _XuatMang.KetThuc

	#xuat a[i]
	li $v0, 1
	lw $a0, ($a1)
	syscall
	#Xuat dau cach
	li $v0, 11
	li $a0, 32
	syscall
	
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _XuatMang.Lap

_XuatMang.KetThuc:

	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0,4($sp)
	#Xoa stack
	addi $sp,$sp,8

	#Nhay ve dia chi goi ham
	jr $ra
#----------------------------------------------------------------------------------
#3. Liet ke cac so nguyen to trong mang -------------------------------------------
_Func_LietKeNT:
	#Nhap doi so
	la $a1, arr
	lw $a2, n
	#goi ham
	jal _LietKeNT
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
	
_LietKeNT:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-8
	#Backup thanh ghi
	sw $ra, ($sp)
	sw $t0, 4($sp)
	#Xuat tbXuatSoNT
	li $v0, 4
	la $a0, tbXuatSoNT
	syscall

	#khoi tao vong lap
	li $t0, 0 # i = 0
_LietKeNT.Lap: 
	beq $t0, $a2, _LietKeNT.KetThuc

	lw $a0, ($a1)
	jal _KTNT

	#Kiem tra ket qua
	beq $v0,1, _LietKeNT.Xuat
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _LietKeNT.Lap
_LietKeNT.Xuat:
	#tang tong va m
	li $v0, 1
	syscall
	#Xuat dau cach
	li $v0, 11
	li $a0, 32
	syscall
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	j _LietKeNT.Lap

_LietKeNT.KetThuc:
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0, 4($sp)
	#Xoa stack
	addi $sp, $sp, 8

	#Nhay ve dia chi goi ham
	jr $ra
	
#Ham KTNT
#dau thu tuc
_KTNT:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-12
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)

#Than thu tuc:
	#khoi tao vong lap
	li $v0,	1 # v0 = 0
	li $t0, 2 # i = 2
_KTNT.Lap:
	slt $t1, $a0, $t0
	beq $t1, 1, _KTNT.Return0
	beq $t0, $a0, _KTNT.KetThuc
	div $a0,$t0
	mfhi $t1
	
	#Kiem tra phan du
	beq $t1,0,_KTNT.Return0
	addi $t0,$t0,1
	j _KTNT.Lap
_KTNT.Return0:
	li $v0,0

_KTNT.KetThuc:
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)

	#Xoa stack
	addi $sp,$sp,12

	#Nhay ve dia chi goi ham
	jr $ra

#----------------------------------------------------------------------------------
#4. Liet ke so hoan thien trong mang ----------------------------------------------
_Func_LietKeHT:
	#Nhap doi so
	la $a1, arr
	lw $a2, n
	#goi ham
	jal _LietKeHT
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
_LietKeHT:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-8
	#Backup thanh ghi
	sw $ra, ($sp)
	sw $t0, 4($sp)
	#Xuat tbXuatSoNT
	li $v0, 4
	la $a0, tbXuatSoHT
	syscall

	#khoi tao vong lap
	li $t0, 0 # i = 0
_LietKeHT.Lap: 
	beq $t0, $a2, _LietKeHT.KetThuc

	lw $a0, ($a1)
	jal _KTHT

	#Kiem tra ket qua
	beq $v0,1, _LietKeHT.Xuat
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _LietKeHT.Lap
_LietKeHT.Xuat:
	
	li $v0, 1
	syscall
	#Xuat dau cach
	li $v0, 11
	li $a0, 32
	syscall
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	j _LietKeHT.Lap

_LietKeHT.KetThuc:
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0, 4($sp)
	#Xoa stack
	addi $sp, $sp, 8
	#Nhay ve dia chi goi ham
	jr $ra
#Ham kiem tra so hoan thien
_KTHT:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-16
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $s0, 12($sp)
#Than thu tuc:
	#khoi tao vong lap
	li $t0, 0 # i = 0
	li $s0, 0 # s = 0
	li $v0, 0
	beq $a0, 0, _KTHT.KetThuc #Neu n = 0
_KTHT.Lap:
	addi $t0, $t0, 1
	#kiem tra i = n
	beq $t0, $a0, _KTHT.KiemTra
	
	div $a0,$t0
	mfhi $t1	
	#Kiem tra phan du
	beq $t1,0,_KTHT.TangS
	j _KTHT.Lap
_KTHT.TangS:
	add $s0, $s0, $t0
	j _KTHT.Lap
_KTHT.Return1:
	li $v0, 1
	j _KTHT.KetThuc
_KTHT.KiemTra:
	beq $s0, $a0, _KTHT.Return1

_KTHT.KetThuc:
	
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $s0, 12($sp)
	#Xoa stack
	addi $sp,$sp,16

	#Nhay ve dia chi goi ham
	jr $ra
#----------------------------------------------------------------------------------
#5. Tinh Tong cac so chinh phuong -------------------------------------------------
_Func_TongCP:
	#Nhap doi so
	la $a1, arr
	lw $a2, n
	#goi ham
	jal _TongSoCP
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu

_TongSoCP:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-16
	#Backup thanh ghi
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	#Xuat tb5
	li $v0,4
	la $a0,tbTongCP
	syscall

	#khoi tao vong lap
	li $t0, 0 # i = 0
	li $s0, 0 # s = 0
_TongSoCP.Lap: 
	beq $t0, $a2, _TongSoCP.KetThuc

	lw $a0, ($a1)
	jal _KTCP

	#Kiem tra ket qua
	beq $v0,1, _TongSoCP.Cong
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _TongSoCP.Lap
_TongSoCP.Cong: 
	#tang tong va m
	lw $s1, ($a1)
	add $s0, $s0, $s1
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _TongSoCP.Lap

_TongSoCP.KetThuc:
	
	li $v0, 1
	la $a0, ($s0)
	syscall
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	#Xoa stack
	addi $sp, $sp, 16

	#Nhay ve dia chi goi ham
	jr $ra

#Ham kiem tra so chinh phuong
_KTCP:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-16
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $s2,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)

	li $t0, 0 # i = 0 (gan de chia trong khoi tao)
#Than thu tuc:
_KTCP.Lap:
	mult $t0, $t0
	mflo $s2
	#mfhi $s1
	beq $s2, $a0, _KTCP.Return1 #s1 = i * i, s0 = n
	slt $t1, $a0, $s2
	beq $t1, 1, _KTCP.Return0
	addi $t0, $t0, 1
	j _KTCP.Lap

_KTCP.Return1:
	li $v0,1
	j _KTCP.KetThuc
_KTCP.Return0:
	li $v0, 0

_KTCP.KetThuc:
	#Restor thanh ghi
	lw $ra,($sp)
	lw $s2,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	#Xoa stack
	addi $sp,$sp,16

	#Nhay ve dia chi goi ham
	jr $ra
 
#----------------------------------------------------------------------------------
#6. Ham TBC so doi xung trong mang ------------------------------------------------
_Func_TBCSoDX:
	la $a1, arr
	lw $a2, n
	jal _TBCSoDX
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
	
_TBCSoDX:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-20
	
	#Backup thanh ghi
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	#Xuat tb5
	li $v0,4
	la $a0,tbTBCSoDX
	syscall

	#khoi tao vong lap
	li $t0, 0 # i = 0
	li $s0, 0 # s = 0
	li $t1, 0 # m = 0
_TBCSoDX.Lap: 
	
	beq $t0, $a2, _TBCSoDX.Chia

	lw $a0, ($a1)
	jal _KTDX

	#Kiem tra ket qua
	beq $v0,1, _TBCSoDX.Cong
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _TBCSoDX.Lap
_TBCSoDX.Cong: 
	#tang tong va m
	lw $s1, ($a1)
	add $s0, $s0, $s1
	addi $t1, $t1, 1
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _TBCSoDX.Lap

_TBCSoDX.Chia:
	#Neu m = 0 thi xuat s = 0
	beq $t1, 0, _TBCSoDX.KetThuc
	#nguoc lai thuc hien chia
	div $s0, $t1
	#mfhi $t1 #t1 la so du
	mflo $s0 #t2 la thuong
	
_TBCSoDX.KetThuc:
	
	li $v0, 1
	la $a0, ($s0)
	syscall
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	#Xoa stack
	addi $sp,$sp,20

	#Nhay ve dia chi goi ham
	jr $ra

#Ham kiem tra so doi xung
_KTDX:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-20
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $s1,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2, 16($sp)
#Than thu tuc:
	#khoi tao vong lap
	li $s1,	0 # bien s = 0 luu gia tri dao cua so
	li $t0, 10 # t = 10 nhan voi 10
	addi $t2, $a0, 0
_KTDX.Lap:
	#div 10
	div $t2,$t0
	mfhi $t1 #t1 la so du
	mflo $t2 #t2 la thuong

	#nhan 10 luu vao s1	
	mult $s1, $t0
	mflo $s1
	add $s1,$s1,$t1
	
	beq $t2, 0, _KTDX.SoSanh
	j _KTDX.Lap
_KTDX.SoSanh:
	beq $s1, $a0, _KTDX.Return1
	
	li $v0,0
	j _KTDX.KetThuc
_KTDX.Return1:
	li $v0,1

_KTDX.KetThuc:
	#Restor thanh ghi
	lw $ra,($sp)
	lw $s1,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2, 16($sp)
	#Xoa stack
	addi $sp,$sp,20

	#Nhay ve dia chi goi ham
	jr $ra
#----------------------------------------------------------------------------------
#7. Tim Max trong mang ------------------------------------------------------------
_Func_TimMax:
	la $a1, arr
	lw $a2, n
	jal _TimMax
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
_TimMax:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-24
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2, 16($sp)
	sw $s0, 20($sp)
	#Xuat tb5
	li $v0,4
	la $a0,tbMax
	syscall
	
	li $t0, 0 # i = 0
	lw $t1, ($a1) #Max tam
_TimMax.Lap:
	beq $t0, $a2, _TimMax.KetThuc
	lw $s0, ($a1)
	slt $t2, $t1, $s0
	beq $t2, 1, _TimMax.Gan
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	j _TimMax.Lap
_TimMax.Gan:
	addi $t1, $s0, 0
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	j _TimMax.Lap
_TimMax.KetThuc:
	#xuat max
	li $v0, 1
	la $a0, ($t1)
	syscall
	
	lw $ra,($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2, 16($sp)
	lw $s0, 20($sp)
	#Xoa stack
	addi $sp,$sp,24
	#Nhay ve dia chi goi ham
	jr $ra
#----------------------------------------------------------------------------------
#8. 
_TimMin:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-28
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2, 16($sp)
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	
	li $t0, 0 # i = 0
	lw $t1, ($a1) #min tam
	move $s1, $a1
_TimMin.Lap:
	beq $t0, $a0, _TimMin.KetThuc
	lw $s0, ($a3) #s = a[i]
	slt $t2, $s0, $t1 #neu a[i] < min
	beq $t2, 1, _TimMin.Gan #gan min = a[i]
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a3,$a3,4
	j _TimMin.Lap
_TimMin.Gan:
	add $t1, $s0, $0
	move $s1, $a3
	#Tang bien dem len va kiem tra i < n
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a3,$a3,4
	j _TimMin.Lap
_TimMin.KetThuc:
	#xuat min
	move $v0, $s1

	lw $ra,($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2, 16($sp)
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	#Xoa stack
	addi $sp,$sp,28
	#Nhay ve dia chi goi ham
	jr $ra
#----------------------------------------------------------------------------------
_Func_SSort:
	la $a1, arr
	lw $a2, n
	jal _SSort
	#xuat tb
	li $v0, 4
	la $a0, tbSXTang
	syscall
	
	la $a1, arr
	lw $a2, n
	jal _XuatMang
	j XuatMenu
_SSort:
	#khai bao kich thuoc stack
	addi $sp,$sp,-28
	#backup thanh ghi
	sw $ra,($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2, 16($sp)
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	#khoi tao bien dem
	li $t0, 0 #i = 0
	move $a0, $a2 #gan a0 = n
_SSort.Lap:
	beq $t0, $a2, _SSort.KetThuc
	move $a3, $a1
	jal _TimMin
	#swap	
	lw $t1, ($v0)
	lw $t2, ($a1)
	sw $t1, ($a1)
	sw $t2, ($v0)
	#tang i
	addi $t0, $t0, 1
	addi $a1, $a1, 4
	addi $a0, $a0, -1
	j _SSort.Lap
_SSort.KetThuc:
	#Restore thanh ghi
	lw $ra,($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2, 16($sp)
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	#khai bao kich thuoc stack
	addi $sp,$sp,28
	#Nhay ve dia chi goi ham
	jr $ra

#----------------------------------------------------------------------------------