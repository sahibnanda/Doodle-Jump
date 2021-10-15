#####################################################################
#
# CSC258H5S Winter 2021 Assembly Programming Project
# University of Toronto Mississauga
#
# Group members:
# - Student 1: Stephan Motha, 1005785189
# - Student 2: Sahib Nanda, 1006013216
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone: 5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Background music
# 2. Shooting
# 3. Dynamic on-screen notification messages
#
# Any additional information that the TA needs to know:
# - The user can shoot with any key other than j and k
# - To avoid spam, there can only be one bullet on the screen at all times

# CONTROLS
# s -- start the game
# j -- moves the player left
# k -- moves the player right
# any other key -- shoot

#####################################################################
                    
.data
	displayAddress:	.word	0x10008000 # stores the base address for display
	keystroke: .word 0xffff0000
	keyvalue: .word 0xffff0004
	jkey: .word 106
	kkey: .word 107
	skey: .word 115
	spacekey: .word 32
	flag: .word 0 # flag for going up or down
	numunits: .word 1058 # stores number of units on screen plus one extra row
	bottomleft: .word 3965 # stores bottom left
	blue: .word 0x9ed2f7 # holds blue
	music: .word 60,62,64,60,62,64,60,60,65,67,69,71,72,71,69,67,65,64,62
	notes: .word 0 # note counter
	platforms: .word 0, 0, 0 # holds middle of every platform
	plat_remove: .word 0 # which platform to delete next
	bullet: .word -128
	
	score: .word 0
	message: .word 0
	messagecounter: .word 0

	
.text
	# using v0 for bottom left below of doodle guy
	# using v1 for bottom right below  of doodle guy
	# s3 for music
	lw $t0, displayAddress	# holds top left unit address of display
	li $t1, 0xff0000	# $t1 stores the red colour code
	li $s0, 0xffffff	# $s0 stores the white colour code
	li $t4, 0 		# counter for filling background / can use for temporary stuff too
	li $t9, 2108 		# stores current position of doodle guy
	

# enter s to start
START:
	lw $s6, keystroke
	lw $s6, 0($s6)
	li $s7, 1
	beq $s6, $s7 CHECK_START
	j START
	
CHECK_START:
	lw $s6, keyvalue
	lw $s6, 0($s6)
	lw $s7, skey
	beq $s6, $s7, INIT
	j START
	

	
# Function for repainting screen - return when done
BACKGROUND:
	beq $t4, $t6, DONE
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	addi $t4, $t4, 1
	j BACKGROUND
DONE:
	jr $ra
	
# Function for Music
MUSIC:
	
	beq $s3, 80, RESET # reset to first note if tune is over
	
	# play current note
	la $t3, music
	add $t3, $t3, $s3
	li $v0 31
	lw $t5, 0($t3)
	move $a0, $t5
	li $a1, 600
	li $a2, 0
	li $a3, 30
	syscall
	
	# move to next note for next music call
	addi $s3, $s3, 4
	la $t3, notes
	sw $s3, 0($t3) 
	jr $ra
RESET:
	li $s3, 0
	la $t3, notes
	sw $s3, 0($t3) 
	j MUSIC

	

MOVE_PLATFORMS_DOWN:
	
	la $t2, platforms
	lw $t3, 0($t2)
	sw $s0, 128($t3)
	sw $s0, 132($t3)
	sw $s0, 136($t3)
	sw $s0, 140($t3)
	sw $s0, 144($t3)
	sw $s0, 124($t3)
	sw $s0, 120($t3)
	sw $s0, 116($t3)
	sw $s0, 112($t3)
	addi $t3, $t3, 128
	sw $t3, 0($t2)
	
	lw $t3, 4($t2)
	sw $s0, 128($t3)
	sw $s0, 132($t3)
	sw $s0, 136($t3)
	sw $s0, 140($t3)
	sw $s0, 144($t3)
	sw $s0, 124($t3)
	sw $s0, 120($t3)
	sw $s0, 116($t3)
	sw $s0, 112($t3)
	addi $t3, $t3 128
	sw $t3, 4($t2)
	
	lw $t3, 8($t2)
	sw $s0, 128($t3)
	sw $s0, 132($t3)
	sw $s0, 136($t3)
	sw $s0, 140($t3)
	sw $s0, 144($t3)
	sw $s0, 124($t3)
	sw $s0, 120($t3)
	sw $s0, 116($t3)
	sw $s0, 112($t3)
	addi $t3, $t3, 128
	sw $t3, 8($t2)
	jr $ra
	
	
	

#HELPER:
	#sw $s0, 128($t3)
	#sw $s0, 132($t3)
	#sw $s0, 136($t3)
	#sw $s0, 140($t3)
	#sw $s0, 144($t3)
	#sw $s0, 124($t3)
	#sw $s0, 120($t3)
	#sw $s0, 116($t3)
	#sw $s0, 112($t3)
	#jr $ra


	
	

# resets the display address to first unit and draw doodle guy and starting platforms
INIT:
	la $t3, blue
	lw $t3, 0($t3)
	la $t6, numunits
	lw $t6, 0($t6)
	jal BACKGROUND
	
	lw $t0, displayAddress 
	sw $t1, 2108($t0)
	sw $t1, 1980($t0)
	sw $t1, 2112($t0)
	sw $t1, 2104($t0)
	sw $t1, 2240($t0)
	sw $t1, 2232($t0)

	#li $v0, 42  # 42 is system call code to generate random int
	#li $a1, 24 # $a1 is where you set the upper bound
	#syscall     # your generated number will be at $a0
	li $a0, 7
	li $s1, 4
	addi $a0, $a0, 4
	mult $s1, $a0
	mflo $s1
	
	lw $t0, displayAddress
	addi $t0, $t0, 3984
	addu $t0, $t0, $s1 
	
	jal MAKE_PLATFORM
	la $t2, platforms
	sw $t0, 0($t2)
	
	
	li $v0, 42  # 42 is system call code to generate random int
	li $a1, 24 # $a1 is where you set the upper bound
	syscall     # your generated number will be at $a0
	
	li $s1, 4
	addi $a0, $a0, 4
	mult $s1, $a0
	mflo $s1
	
	lw $t0, displayAddress
	addi $t0, $t0, 2560
	addu $t0, $t0, $s1
	
	jal MAKE_PLATFORM
	la $t2, platforms
	sw $t0, 4($t2)
	
	
	li $v0, 42  # 42 is system call code to generate random int
	li $a1, 24 # $a1 is where you set the upper bound
	syscall     # your generated number will be at $a0
	
	li $s1, 4
	addi $a0, $a0, 4
	mult $s1, $a0
	mflo $s1
	
	lw $t0, displayAddress
	addi $t0, $t0, 1152
	addu $t0, $t0, $s1
	
	jal MAKE_PLATFORM
	la $t2, platforms
	sw $t0, 8($t2)
	
	j IF
	
# make doodly guy fall
FALL:
	# FIX - doodle guy goes through platform - use $v0, v1
	
	lw $t0, displayAddress
	add $t0, $t0, $v0
	lw $v0, 0($t0)
	beq $v0, $s0, TOGGLE
	lw $t0, displayAddress
	add $t0, $t0, $v1
	lw $v1, 0($t0)
	beq $v1, $s0, TOGGLE
	
	
	addi $s5, $zero, 132
	addu $s5, $s5, $t9 
	la $s4, bottomleft
	lw $s4, 0($s4)
	ble $s5, $s4, IF
	lw $t0, displayAddress
	addi $t0, $t0, 3984
	addu $t0, $t0, $s1 
	addi $t0, $t0, 20
	addi $t5, $t9, 124
	bge $t5, $t0, BYE
	addi $t5, $t9, -124
	addi $t0, $t0, -20
	addi $t0, $t0, -20
	addi $t5, $t9, 132
	ble $t5, $t0, BYE
	addi $t5, $t9, -132
	addi $t0, $t0, 20
	
	
	
	j Exit

# add 11 units that doodler must travel up




TOGGLE:
	la $t4, flag
	li $t0, 11
	sw $t0, 0($t4)
	la $t5, score
	lw $t4, 0($t5)
	addi $t4, $t4, 1
	sw $t4, 0($t5)
	
	jal MESSAGE
	
	j UPDATE_PLATFORMS
	

MAKE_PLATFORM:
	sw $s0, 0($t0)
	sw $s0, 4($t0)
	sw $s0, 8($t0)
	sw $s0, 12($t0)
	sw $s0, 16($t0)
	sw $s0, -4($t0)
	sw $s0, -8($t0)
	sw $s0, -12($t0)
	sw $s0, -16($t0)
	jr $ra

#DRAW_PLATFORMS:
	#beq $a0 $a1, FINISHED
	#addi $t0, $t0, 4
	#addi $a0, $a0, 4
	#sw $s0, 0($t0)
	#j MAKE_PLATFORM
	
#FINISHED:
	#jr $ra
	
	
RANDOM:
	li $v0, 42  # 42 is system call code to generate random int
	li $a1, 24 # $a1 is where you set the upper bound
	syscall     # your generated number will be at $a0
	
	li $s1, 4
	addi $a0, $a0, 4
	mult $s1, $a0
	mflo $s1
	lw $t0, displayAddress
	addi $t0, $t0, -256# where to put the new platform
	addu $t0, $t0, $s1

	jr $ra


UPDATE_PLATFORMS:
	
	#la $t2, platforms
	la $t3, plat_remove
	lw $t3, 0($t3)
	
	beq $t3, 0, ZERO
	beq $t3, 1, ONE
	beq $t3, 2, TWO

	
	
ZERO:
	la $t3, plat_remove
	li $t2, 1
	sw $t2, 0($t3)
	
	jal RANDOM
	
	#lw $t0, displayAddress
	
	jal MAKE_PLATFORM
	la $t2, platforms
	sw $t0, 0($t2)
	j IF
ONE:
	la $t3, plat_remove
	li $t2, 2
	sw $t2, 0($t3)
	
	jal RANDOM
	
	jal MAKE_PLATFORM
	la $t2, platforms
	sw $t0, 4($t2)
	j IF
TWO:
	la $t3, plat_remove
	li $t2, 0
	sw $t2, 0($t3)
	
	jal RANDOM
	
	jal MAKE_PLATFORM
	la $t2, platforms
	sw $t0, 8($t2)
	j IF


BULLET:
	la $t3, bullet
	lw $t2, 0($t3)
	blez $t2, BAD_BULLET
	addi $t2, $t2, -256
	
	lw $t3, displayAddress
	add $t3, $t3, $t2
	sw $t1, 0($t3)
	
	la $t3, bullet
	sw $t2, 0($t3)
	jr $ra
	
BAD_BULLET:
	jr $ra


MESSAGE:
	li $v0, 42  # 42 is system call code to generate random int
	li $a1, 3 # $a1 is where you set the upper bound
	syscall  # your generated number will be at $a0
	
	andi $t4, $t4, 1
	beq $t4, 0, DONE
	
	la $t2, messagecounter
	li $t4, 8
	sw $t4, 0($t2)
	
	beq $a0, 0, FIRST
	beq $a0, 1, SECOND
	beq $a0, 2, THIRD
	
FIRST:
	la $t8, WOW
	
	jr $ra
	
SECOND:
	la $t8, GOOD
	
	jr $ra
THIRD:
	la $t8, NICE


	jr $ra
	
BACK:
	la $t8, OTHER
	jr $ra

# Main program loop	
IF:
	# sleep
	li $v0, 32 
	li $a0, 80
	syscall
	
	# uncomment these for music:
	lw $s3, notes
	jal MUSIC
	
	# repaint background
	la $t3, blue
	lw $t3, 0($t3)
	li $t4, 0
	la $t6, numunits
	lw $t6, 0($t6)
	lw $t0, displayAddress 
	jal BACKGROUND 
	
CHECK_MESSAGE:
	la $t2, messagecounter
	lw $t2, 0($t2)
	blez $t2, OTHER
	jr $t8

OTHER:
	jal BULLET
	# move based on key clicked
	lw $t0, displayAddress 
	lw $s6, keystroke
	lw $s6, 0($s6)
	li $s7, 1
	beq $s6, $s7, MOVE_DETECTED # check if keystroke is 1 => move detected
	
	j REPAINT_DOWN
	# reset current display pixel and make doodle guy fall straight down



MOVE_DETECTED:
	lw $s6, keyvalue
	lw $s6, 0($s6)
	
	lw $s7, jkey
	beq $s6, $s7, REPAINT_LEFT # move left
	lw $s7, kkey
	beq $s6, $s7, REPAINT_RIGHT  # move right
	
	j SHOOT
	

SHOOT:
	la $t2, bullet
	lw $t2, 0($t2)
	bgez $t2, IF
	
	
	la $t2, displayAddress
	add $t2, $t2, $t9
	sw $t1, -256($t2)
	addi $t2, $t9, -256
	
	la $t3, bullet
	sw $t2, 0($t3)


REPAINT_DOWN:
	# check if it should be moving down, else move up and subtract one
	la $t4, flag
	lw $s6, 0($t4)
	beq $s6, $zero, DOWN
	addi $s6, $s6, -1
	sw $s6, 0($t4)
	j UP
	

	
REPAINT_LEFT:
	# check if it should be moving down, else move up and subtract one
	la $t4, flag
	lw $s6, 0($t4)
	beq $s6, $zero, DOWN_LEFT
	addi $s6, $s6, -1
	sw $s6, 0($t4)
	j UP_LEFT


REPAINT_RIGHT:
	# check if it should be moving down, else move up and subtract one
	la $t4, flag
	lw $s6, 0($t4)
	beq $s6, $zero, DOWN_RIGHT
	addi $s6, $s6, -1
	sw $s6, 0($t4)
	j UP_RIGHT
	

	
# move down left
DOWN_LEFT:


	la $t2, platforms
	lw $t0, 0($t2)
	jal MAKE_PLATFORM
	
	lw $t0, 4($t2)
	jal MAKE_PLATFORM
	
	lw $t0, 8($t2)
	jal MAKE_PLATFORM
	
	lw $t0, displayAddress 
	addu $t0, $t0, $t9
	sw $t1, -4($t0)
	sw $t1, 124($t0)
	sw $t1, 128($t0)
	sw $t1, 120($t0)
	sw $t1, 256($t0)
	sw $t1, 248($t0)
	addi $t9, $t9, 124
	addi $v0, $t9, 252  # update doodle bottom left below unit
	addi $v1, $t9, 260 # update doodle bottom right below unit
	j FALL
	
# move down right
DOWN_RIGHT:
	
	la $t2, platforms
	lw $t0, 0($t2)
	jal MAKE_PLATFORM
	
	lw $t0, 4($t2)
	jal MAKE_PLATFORM
	
	lw $t0, 8($t2)
	jal MAKE_PLATFORM
	
	lw $t0, displayAddress 
	addu $t0, $t0, $t9
	sw $t1, 4($t0)
	sw $t1, 132($t0)
	sw $t1, 136($t0)
	sw $t1, 128($t0)
	sw $t1, 264($t0)
	sw $t1, 256($t0)
	addi $t9, $t9, 132
	addi $v0, $t9, 252  # update doodle bottom left below unit
	addi $v1, $t9, 260 # update doodle bottom right below unit
	j FALL

# move down
DOWN:

	la $t2, platforms
	lw $t0, 0($t2)
	jal MAKE_PLATFORM
	
	lw $t0, 4($t2)
	jal MAKE_PLATFORM
	
	lw $t0, 8($t2)
	jal MAKE_PLATFORM
	
	lw $t0, displayAddress 
	addu $t0, $t0, $t9
	sw $t1, 0($t0)
	sw $t1, 128($t0)
	sw $t1, 132($t0)
	sw $t1, 124($t0)
	sw $t1, 260($t0)
	sw $t1, 252($t0)
	addi $t9, $t9, 128
	addi $v0, $t9, 252  # update doodle bottom left below unit
	addi $v1, $t9, 260 # update doodle bottom right below unit
	j FALL


HIT_TOP:
	la $t2, flag
	sw $zero, 0($t2)
	J IF
	
	
	
# move up left
UP_RIGHT:
	jal MOVE_PLATFORMS_DOWN
	
	la $t2, flag
	lw $t3, 0($t2)
	addi $t7, $t9, -256
	blez $t7, HIT_TOP
	
	
	
	
	lw $t0, displayAddress 
	addu $t0, $t0, $t9
	sw $t1, -128($t0)
	sw $t1, -124($t0)
	sw $t1, -252($t0)
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, -120($t0)
	addi $t9, $t9, -124
	addi $v0, $t9, 252  # update doodle bottom left below unit
	addi $v1, $t9, 260 # update doodle bottom right below unit
	j IF
	
# move up right
UP_LEFT:
	jal MOVE_PLATFORMS_DOWN

	la $t2, flag
	lw $t3, 0($t2)
	addi $t7, $t9, -256
	blez $t7, HIT_TOP
	
	lw $t0, displayAddress 
	addu $t0, $t0, $t9
	sw $t1, 0($t0)
	sw $t1, -132($t0)
	sw $t1, -136($t0)
	sw $t1, -128($t0)
	sw $t1, -8($t0)
	sw $t1, -260($t0)
	addi $t9, $t9, -132
	addi $v0, $t9, 252  # update doodle bottom left below unit
	addi $v1, $t9, 260 # update doodle bottom right below unit
	j IF

# move up
UP:
	
	jal MOVE_PLATFORMS_DOWN
	
	la $t2, flag
	lw $t3, 0($t2)
	addi $t7, $t9, -256
	blez $t7, HIT_TOP

	lw $t0, displayAddress 
	addu $t0, $t0, $t9
	sw $t1, -128($t0)
	sw $t1, -4($t0)
	sw $t1, 4($t0)
	sw $t1, -132($t0)
	sw $t1, -124($t0)
	sw $t1, -256($t0)
	addi $t9, $t9, -128
	addi $v0, $t9, 252  # update doodle bottom left below unit
	addi $v1, $t9, 260 # update doodle bottom right below unit
	j IF
	
	
GOOD:
	li $t2, 0xfcba03	# $t2 stores the yellow colour code
	lw $t0, displayAddress 
	
	sw $t2, 1436($t0)
	sw $t2, 1564($t0)
	sw $t2, 1692($t0)
	sw $t2, 1824($t0)
	sw $t2, 1828($t0)
	sw $t2, 1832($t0)
	sw $t2, 1708($t0)
	sw $t2, 1580($t0)
	sw $t2, 1312($t0)
	sw $t2, 1316($t0)
	sw $t2, 1320($t0)
	sw $t2, 1572($t0)
	sw $t2, 1576($t0)
	
	sw $t2, 1336($t0)
	sw $t2, 1340($t0)
	sw $t2, 1460($t0)
	sw $t2, 1588($t0)
	sw $t2, 1716($t0)
	sw $t2, 1848($t0)
	sw $t2, 1852($t0)
	sw $t2, 1728($t0)
	sw $t2, 1600($t0)
	sw $t2, 1472($t0)
	
	sw $t2, 1356($t0)
	sw $t2, 1360($t0)
	sw $t2, 1480($t0)
	sw $t2, 1608($t0)
	sw $t2, 1736($t0)
	sw $t2, 1868($t0)
	sw $t2, 1872($t0)
	sw $t2, 1748($t0)
	sw $t2, 1620($t0)
	sw $t2, 1492($t0)
	
	sw $t2, 1372($t0)
	sw $t2, 1500($t0)
	sw $t2, 1628($t0)
	sw $t2, 1756($t0)
	sw $t2, 1884($t0)
	sw $t2, 1888($t0)
	sw $t2, 1376($t0)
	sw $t2, 1380($t0)
	sw $t2, 1892($t0)
	sw $t2, 1512($t0)
	sw $t2, 1640($t0)
	sw $t2, 1768($t0)
	
	la $t2, messagecounter
	lw $t2, 0($t2)
	addi $t2, $t2, -1
	la $t3, messagecounter
	sw $t2, 0($t3)
	
	la $t7, OTHER
	la $t8, GOOD
	jr $t7

NICE:
	li $t2, 0x1bb816	# $t2 stores the green colour code
	lw $t0, displayAddress 
	
	sw $t2, 1312($t0)
	sw $t2, 1440($t0)
	sw $t2, 1568($t0)
	sw $t2, 1696($t0)
	sw $t2, 1824($t0)
	sw $t2, 1444($t0)
	sw $t2, 1576($t0)
	sw $t2, 1708($t0)
	sw $t2, 1328($t0)
	sw $t2, 1456($t0)
	sw $t2, 1584($t0)
	sw $t2, 1712($t0)
	sw $t2, 1840($t0)
	
	sw $t2, 1336($t0)
	sw $t2, 1464($t0)
	sw $t2, 1592($t0)
	sw $t2, 1720($t0)
	sw $t2, 1848($t0)
	
	sw $t2, 1472($t0)
	sw $t2, 1600($t0)
	sw $t2, 1728($t0)
	sw $t2, 1348($t0)
	sw $t2, 1352($t0)
	sw $t2, 1484($t0)
	sw $t2, 1740($t0)
	sw $t2, 1864($t0)
	sw $t2, 1860($t0)
	
	sw $t2, 1364($t0)
	sw $t2, 1368($t0)
	sw $t2, 1372($t0)
	sw $t2, 1376($t0)
	sw $t2, 1492($t0)
	sw $t2, 1620($t0)
	sw $t2, 1624($t0)
	sw $t2, 1628($t0)
	sw $t2, 1748($t0)
	sw $t2, 1876($t0)
	sw $t2, 1880($t0)
	sw $t2, 1884($t0)
	sw $t2, 1888($t0)
	
	la $t2, messagecounter
	lw $t2, 0($t2)
	addi $t2, $t2, -1
	la $t3, messagecounter
	sw $t2, 0($t3)
	
	la $t7, OTHER
	la $t8, NICE
	jr $t7
	


WOW:
	li $t2, 0x8216b8	# $t2 stores the purple colour code
	lw $t0, displayAddress 
	sw $t2, 1312($t0)
	sw $t2, 1440($t0)
	sw $t2, 1568($t0)
	sw $t2, 1696($t0)
	sw $t2, 1828($t0)
	sw $t2, 1704($t0)
	sw $t2, 1836($t0)
	sw $t2, 1712($t0)
	sw $t2, 1320($t0)
	sw $t2, 1448($t0)
	sw $t2, 1576($t0)
	sw $t2, 1328($t0)
	sw $t2, 1456($t0)
	sw $t2, 1584($t0)
	
	sw $t2, 1340($t0)
	sw $t2, 1344($t0)
	sw $t2, 1464($t0)
	sw $t2, 1592($t0)
	sw $t2, 1720($t0)
	sw $t2, 1852($t0)
	sw $t2, 1856($t0)
	sw $t2, 1732($t0)
	sw $t2, 1604($t0)
	sw $t2, 1476($t0)
	
	sw $t2, 1356($t0)
	sw $t2, 1484($t0)
	sw $t2, 1568($t0)
	sw $t2, 1740($t0)
	sw $t2, 1612($t0)
	sw $t2, 1872($t0)
	sw $t2, 1748($t0)
	sw $t2, 1880($t0)
	sw $t2, 1756($t0)
	sw $t2, 1364($t0)
	sw $t2, 1492($t0)
	sw $t2, 1620($t0)
	sw $t2, 1372($t0)
	sw $t2, 1500($t0)
	sw $t2, 1628($t0)
	
	la $t2, messagecounter
	lw $t2, 0($t2)
	addi $t2, $t2, -1
	la $t3, messagecounter
	sw $t2, 0($t3)
	
	la $t7, OTHER
	la $t8, WOW
	jr $t7
	


BYE:
	li $t2, 0xfcba03	# $t2 stores the yellow colour code
	lw $t0, displayAddress 
	sw $t2, 1320($t0)
	sw $t2, 1448($t0)
	sw $t2, 1576($t0)
	sw $t2, 1704($t0)
	sw $t2, 1832($t0)
	sw $t2, 1580($t0)
	sw $t2, 1584($t0)
	sw $t2, 1712($t0)
	sw $t2, 1840($t0)
	sw $t2, 1836($t0)
	
	sw $t2, 1592($t0)
	sw $t2, 1720($t0)
	sw $t2, 1848($t0)
	sw $t2, 1852($t0)
	sw $t2, 1856($t0)
	sw $t2, 1728($t0)
	sw $t2, 1600($t0)
	sw $t2, 1984($t0)
	sw $t2, 2112($t0)
	sw $t2, 2108($t0)
	sw $t2, 2104($t0)
	
	sw $t2, 1608($t0)
	sw $t2, 1612($t0)
	sw $t2, 1616($t0)
	sw $t2, 1736($t0)
	sw $t2, 1864($t0)
	sw $t2, 1868($t0)
	sw $t2, 1872($t0)
	sw $t2, 1480($t0)
	sw $t2, 1352($t0)
	sw $t2, 1356($t0)
	sw $t2, 1360($t0)
	
	sw $t2, 1624($t0)
	sw $t2, 1496($t0)
	sw $t2, 1368($t0)
	sw $t2, 1880($t0)
	j Exit
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
