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
	tbSXGiam: .asciiz "Mang sap xep giam: "
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
	beq $t0, 9, _Func_BSort
	beq $t0, 10, _Func_Thoat
	j NhapSai

NhapSai:
	# xuat error
	li $v0,4
	la $a0,error
	syscall
	j XuatMenu
	
#----------------------------------------------------------------------------------
#1.Nhap mang ----------------------------------------------------------------------
#Label NhapMang
_Func_NhapMang:
	la $a1, arr
	jal _NhapMang
	sw $v0, n	
	j XuatMenu

#Ham nhap mang
#Tham so: $a1 = array, $v0 = n
#Gia tri tra ve: khong co
_NhapMang:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-12
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
	move $s1, $v0
	#kiem tra n < 0
	slt $t0, $s1, $0
	beq $t0, 1, _NhapMang.KetThuc
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
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $s1, 8($sp)
	addi $sp,$sp,12
	
	jr $ra
	
#----------------------------------------------------------------------------------
#2. Xuat Mang ---------------------------------------------------------------------
#Label XuatMang -------------------------------------------------------------------
_Func_XuatMang:
	#Xuat tb4
	li $v0,4
	la $a0,tbXuatMang
	syscall
	
	la $a1, arr
	lw $a2, n
	jal _XuatMang
	
	#tb xuat mang
	li $v0, 4
	la $a0, endl
	syscall
		
	j XuatMenu

#Mo ta ham: Ham xuat mang
#Tham so: $a1 = array, $a2 = n
#Gia tri tra ve: khong co
_XuatMang:
	addi $sp,$sp,-8
	sw $ra,($sp)
	sw $t0,4($sp)
	#kiem tra n < 0
	slt $t0, $a2, $0
	beq $t0, 1, _XuatMang.KetThuc
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
	
	#Tang bien dem
	addi $t0,$t0,1
	
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _XuatMang.Lap
_XuatMang.KetThuc:	
	lw $ra,($sp)
	lw $t0,4($sp)
	addi $sp,$sp,8
	jr $ra
	
#----------------------------------------------------------------------------------
#3. Liet ke cac so nguyen to trong mang -------------------------------------------
#Label LietKeNT.
_Func_LietKeNT:
	#Nhap doi so
	la $a1, arr
	lw $a2, n
	
	#goi ham
	jal _LietKeNT
	
	#xuong dong
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
	
#Ham liet_ke_nguyen_to 
#Tham so: $a1 = array, $a2 = n
#Gia tri tra ve: khong co
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
	#kiem tra n < 0
	slt $t0, $a2,  $0
	beq $t0, 1, _LietKeNT.KetThuc
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
	#xuat so trong mang
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
	lw $ra,($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8

	jr $ra
	
#Ham KTNT----------------------------------------------------------------
#Tham so: $a0
#Gia tri tra ve: $v0($v0 = 0 la khong phai snt, $v0 = 1 la snt)
_KTNT:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-12
	
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	
	#khoi tao vong lap
	li $v0,	1 # v0 = 0
	li $t0, 2 # i = 2
	
#Than thu tuc:
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
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	addi $sp,$sp,12

	jr $ra

#----------------------------------------------------------------------------------
#4. Liet ke so hoan thien trong mang ----------------------------------------------
#Label LietKeHT
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
	
#Ham Liet_ke_hoan_chinh
#Tham so: $a1 = array, $a2 = n
#Gia tri tra ve: khong co
_LietKeHT:
	addi $sp,$sp,-8
	sw $ra, ($sp)
	sw $t0, 4($sp)
	
	#Xuat tbXuatSoNT
	li $v0, 4
	la $a0, tbXuatSoHT
	syscall
	#kiem tra n < 0
	slt $t0, $a2,  $0
	beq $t0, 1, _LietKeHT.KetThuc
	#khoi tao vong lap
	li $t0, 0 # i = 0
	
_LietKeHT.Lap: 
	beq $t0, $a2, _LietKeHT.KetThuc

	lw $a0, ($a1)
	jal _KTHT

	#Kiem tra ket qua
	beq $v0,1, _LietKeHT.Xuat
	
	#Tang bien dem
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
	lw $ra,($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
#Ham kiem tra so hoan thien
#Tham so: $a0
#Gia tri tra ve: $v0 ($v0 = 1 thi $a0 la so hoan thien, $v0 = 0 thi $a0 khong la so hoan thien)
_KTHT:
	addi $sp,$sp,-20
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $s0, 12($sp)
	sw $s1, 16 ($sp)
	
#Than thu tuc:
	#khoi tao vong lap
	li $t0, 1 # i = 0
	li $s0, 0 # s = 0
	li $v0, 0
	
	#Neu n <= 0 thi thoat
	beq $a0, 0, _KTHT.KetThuc
	slt $t1, $a0, $v0
	beq $t1, 1, _KTHT.KetThuc
	
_KTHT.Lap:
	#kiem tra i = n
	beq $t0, $a0, _KTHT.KiemTra
	
	#kiem tra chia het
	div $a0,$t0
	mfhi $t1
	mflo $s1	
	slt $t1, $s1, $t0
	beq $t1, 1, _KTHT.KiemTra
	mfhi $t1 # gan lai du
	
	#Kiem tra phan du
	beq $t1,0,_KTHT.TangS
	
	#Tang i
	addi $t0, $t0, 1
	
	j _KTHT.Lap
	
_KTHT.TangS:
	# n = a*b 
	add $s0, $s0, $t0 # s += a
	add $s0, $s0, $s1 # s += b
	
	#Tang i
	addi $t0, $t0, 1
	j _KTHT.Lap
	
_KTHT.Return1:
	li $v0, 1
	j _KTHT.KetThuc
	
_KTHT.KiemTra:
	li $t0, 2
	div $s0, $t0
	mflo $s0
	mfhi $t1
	beq $t1, 1, _KTHT.KetThuc
	beq $s0, $a0, _KTHT.Return1
	
_KTHT.KetThuc:
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $s0, 12($sp)
	lw $s1, 16 ($sp)
	addi $sp,$sp, 20
	
	jr $ra	
#----------------------------------------------------------------------------------
#5. Tinh Tong cac so chinh phuong -------------------------------------------------

#Label TongCP --------------------------------------------------------------------
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

#Ham tinh tong cac so chinh phuong (In ra tong so chinh phuong trong mang)
#Tham so: $a1 = array, $a2 = n
#Gia tri tra ve: Khong co 
_TongSoCP:
	addi $sp,$sp,-16
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	
	#Xuat tb
	li $v0,4
	la $a0,tbTongCP
	syscall
	#kiem tra n <= 0?
	li $s0, 0 # s = 0
	slt $t0, $a2,  $0
	beq $t0, 1, _TongSoCP.KetThuc
	beq $a2, 0, _TongSoCP.KetThuc
	#khoi tao vong lap
	li $t0, 0 # i = 0
	li $s0, 0 #tong s = 0
	
_TongSoCP.Lap: 
	beq $t0, $a2, _TongSoCP.XuatTongCP

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
_TongSoCP.XuatTongCP:
	li $v0, 1
	la $a0, ($s0)
	syscall
_TongSoCP.KetThuc:
	#Restore thanh ghi
	lw $ra,($sp)
	lw $t0, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	addi $sp, $sp, 16

	jr $ra

#Ham kiem tra so chinh phuong.
#Tham so: $a0
#Gia tri tra ve: $v0 ($v0 = 1 la scp, $v0 = 0 ko la scp)
_KTCP:
	addi $sp,$sp,-16
	sw $ra,($sp)
	sw $s2,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)

	li $t0, 0 # i = 0 (gan de chia trong khoi tao)
	
#Than thu tuc:
_KTCP.Lap:
	mult $t0, $t0
	mflo $s2
	
	beq $s2, $a0, _KTCP.Return1 #s2 = i * i, a0 la so truyen vao
	
	slt $t1, $a0, $s2
	beq $t1, 1, _KTCP.Return0
	
	#tang dem
	addi $t0, $t0, 1
	
	j _KTCP.Lap

_KTCP.Return1:
	li $v0,1
	j _KTCP.KetThuc
	
_KTCP.Return0:
	li $v0, 0

_KTCP.KetThuc:
	lw $ra,($sp)
	lw $s2,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	addi $sp,$sp,16

	jr $ra
 
#----------------------------------------------------------------------------------
#6. TBC so doi xung trong mang ------------------------------------------------

#Label TBC
_Func_TBCSoDX:
	la $a1, arr
	lw $a2, n
	
	jal _TBCSoDX
	
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
	
#Ham tinh TBC so dx
#Tham so: $a1 = array, $a2 = n
#Gia tri tra ve: khong co.
_TBCSoDX:
	addi $sp,$sp,-20
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	
	#Xuat tb
	li $v0,4
	la $a0,tbTBCSoDX
	syscall
	#kiem tra n <= 0?
	li $s0, 0 # s = 0
	slt $t0, $a2,  $0
	beq $t0, 1, _TBCSoDX.KetThuc
	beq $a2, 0, _TBCSoDX.KetThuc
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
	
	#Tang bien dem len
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _TBCSoDX.Lap
	
_TBCSoDX.Cong: 
	#tang tong va m
	lw $s1, ($a1)
	add $s0, $s0, $s1
	addi $t1, $t1, 1
	
	#Tang bien dem len
	addi $t0,$t0,1
	#Tang dia chi mang
	addi $a1,$a1,4
	
	j _TBCSoDX.Lap

_TBCSoDX.Chia:
	#Neu m = 0 thi xuat s = 0
	beq $t1, 0, _TBCSoDX.XuatSoDX
	
	#nguoc lai thuc hien chia
	div $s0, $t1
	mflo $s0 #thuong
_TBCSoDX.XuatSoDX:
	#xuat ket qua
	li $v0, 1
	la $a0, ($s0)
	syscall
_TBCSoDX.KetThuc:
	#Restor thanh ghi
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	addi $sp,$sp,20

	#Nhay ve dia chi goi ham
	jr $ra

#Ham kiem tra so doi xung
#Tham so: $a0 (so can kiem tra)
#Gia tri tra ve: $v0 ($v0 = 1 la so dx, $v0 = 0 ko la so dx) 
_KTDX:		
	addi $sp,$sp,-20
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
	addi $sp,$sp,20

	jr $ra
	
#----------------------------------------------------------------------------------
#7. Tim Max trong mang ------------------------------------------------------------
#Label TimMax
_Func_TimMax:
	la $a1, arr
	lw $a2, n
	jal _TimMax
	
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	
	j XuatMenu
	
#Ham tim max
#Tham so: $a1 = array, $a2 = n
#Gia tri tra ve: Khong co
_TimMax:
	addi $sp,$sp,-20
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $t2, 12($sp)
	sw $s0, 16($sp)
	
	#Xuat tb
	li $v0,4
	la $a0,tbMax
	syscall
	#kiem tra n <= 0?
	li $s0, 0 # s = 0
	slt $t0, $a2,  $0
	beq $t0, 1, _TimMax.KetThuc
	beq $a2, 0, _TimMax.KetThuc
	#khoi tao vong lap
	li $t0, 0 # i = 0
	lw $t1, ($a1) #khoi tao Max tam la phan tu dau tien cua mang
	
_TimMax.Lap:
	beq $t0, $a2, _TimMax.XuatMax
	
	lw $s0, ($a1)
	slt $t2, $t1, $s0
	beq $t2, 1, _TimMax.Gan
	
	#Tang bien dem len
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
_TimMax.XuatMax:
	#xuat max
	li $v0, 1
	la $a0, ($t1)
	syscall
_TimMax.KetThuc:
	#Restore thanh ghi
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $t2, 12($sp)
	lw $s0, 16($sp)
	addi $sp,$sp,20
	
	jr $ra
	
#----------------------------------------------------------------------------------
#8. Ham tim min
#Tham so: $a1 = array, $a2 = n
#Gia tri tra ve: min mang la $v0
_TimMin:
	addi $sp,$sp,-24
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $t2, 12($sp)
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	
	li $t0, 0 # i = 0
	lw $t1, ($a1) #min tam la phan tu dau tien cua mang
	move $s1, $a1
	
_TimMin.Lap:
	beq $t0, $a0, _TimMin.KetThuc
	
	lw $s0, ($a3) #s = a[i]
	slt $t2, $s0, $t1 #neu a[i] < min
	beq $t2, 1, _TimMin.Gan #gan min = a[i]
	
	#Tang bien dem len
	addi $t0,$t0,1
	
	#Tang dia chi mang
	addi $a3,$a3,4
	
	j _TimMin.Lap

_TimMin.Gan:
	add $t1, $s0, $0
	move $s1, $a3

	#Tang bien dem len
	addi $t0,$t0,1
	
	#Tang dia chi mang
	addi $a3,$a3,4
	
	j _TimMin.Lap

_TimMin.KetThuc:
	#xuat min
	move $v0, $s1

	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	addi $sp,$sp,24
	
	jr $ra
	
#----------------------------------------------------------------------------------
#8. Sap xep mang tang theo Selection Sort -----------------------------------------
#Label SSort
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
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
	
#Ham sap xep mang tang thep SSort.
#Tham so: $a1 = array, $a2 = n.
#Gia tri tra ve: Khong co.
_SSort:	
	addi $sp,$sp,-24
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $t2, 12($sp)
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	#kiem tra n < 0
	slt $t0, $a2, $0
	beq $t0, 1, _SSort.KetThuc
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
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $t2, 12($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	addi $sp,$sp,24
	
	jr $ra

#----------------------------------------------------------------------------------
#9. Sap xep mang giam theo Bubble Sort --------------------------------------------
#Label BSort
_Func_BSort:
	la $a1, arr
	lw $a2, n
	jal _BSort
	
	#xuat tb
	li $v0, 4
	la $a0, tbSXGiam
	syscall
	
	la $a1, arr
	lw $a2, n
	
	jal _XuatMang	
	#endl
	li $v0, 4
	la $a0, endl
	syscall
	j XuatMenu
	
#Ham sap xep mang giam dan theo BSort.
#Tham so: $a1 = array, $a2 = n.
#Gia tri tra ve: Khong co.
_BSort:
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $s0, 24($sp)
	sw $s1, 28($sp)
	#kiem tra n < 0
	slt $t0, $a2, $0
	beq $t0, 1, _BSort.KetThuc
	beq $a2, 0 _BSort.KetThuc
	#khoi tao bien dem
	li $t0, -1 #i = -1
	addi $a2, $a2, -1#n = n - 1 

_BSort.LapI:
	addi $t0, $t0, 1 #i++
	beq $t0, $a2, _BSort.KetThuc #kiem tra i < n - 1
	
	li $t1, 0 #gan j = 0
	sub $s1, $a2, $t0 #m = n - 1 - i
	move $s0, $a1 #a[i]
	
	_BSort.LapJ:
		beq $t1, $s1, _BSort.LapI #kiem tra j < m
		lw $t2, ($s0) #a[j]
		lw $t3, 4($s0)#a[j+1]
		
		slt $t4, $t2, $t3#so sanh a[j] va a[j+1]
		beq $t4, 1, _BSort.swap 		

		#tang i va tang mang
		addi $t1, $t1, 1
		addi $s0, $s0, 4
		
		j _BSort.LapJ
		
	_BSort.swap:
		sw $t3, ($s0)
		sw $t2, 4($s0)
		
		#tang i va tang mang
		addi $t1, $t1, 1
		addi $s0, $s0, 4	
		
		j _BSort.LapJ
		
_BSort.KetThuc:
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $s0, 24($sp)
	lw $s1, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra
	
#----------------------------------------------------------------------------
#10. ham thoát---------------------------------------------------------------
_Func_Thoat:
	#ket thuc chuong trinh
	li $v0, 10
	syscall
