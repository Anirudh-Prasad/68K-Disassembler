*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program

*MOVE testing
    *Source Testing
    *Dn SRC AND DEST
    MOVE.B  D0, D1
    MOVE.W  D1, D2
    MOVE.L  D2, D3
    MOVE.B  D3, D4
    MOVE.W  D4, D5
    MOVE.L  D5, D6
    MOVE.B  D6, D7
    *An
    MOVE.W  A0, D0
    MOVE.L  A1, D1
    MOVE.W  A2, D2
    MOVE.L  A3, D3
    MOVE.W  A4, D4
    MOVE.L  A5, D5
    MOVE.W  A6, D6
    MOVE.L  A7, D7
    *(An)
    MOVE.B  (A0), D0
    MOVE.W  (A1), D1
    MOVE.L  (A2), D2
    MOVE.B  (A3), D3
    MOVE.W  (A4), D4
    MOVE.L  (A5), D5
    MOVE.B  (A6), D6
    MOVE.W  (A7), D7
    *(An)+
    MOVE.L  (A0)+, D0
    MOVE.B  (A1)+, D1
    MOVE.W  (A2)+, D2
    MOVE.L  (A3)+, D3
    MOVE.B  (A4)+, D4
    MOVE.W  (A5)+, D5
    MOVE.L  (A6)+, D6
    MOVE.B  (A7)+, D7
    *-(An)
    MOVE.W  -(A0), D0
    MOVE.L  -(A1), D1
    MOVE.B  -(A2), D2
    MOVE.W  -(A3), D3
    MOVE.L  -(A4), D4
    MOVE.B  -(A5), D5
    MOVE.W  -(A6), D6
    MOVE.L  -(A7), D7
    *(xxx).W
    MOVE.B  $2000, D0
    MOVE.W  $2000, D0
    MOVE.L  $2000, D0
    MOVE.B  $0200, D0
    MOVE.W  $0200, D0
    MOVE.L  $0200, D0
    MOVE.B  $0020, D0
    MOVE.W  $0020, D0
    MOVE.L  $0020, D0
    MOVE.B  $0002, D0
    MOVE.W  $0002, D0
    MOVE.L  $0002, D0
    *(xxx).L
    MOVE.B  $20000000, D1
    MOVE.W  $20000000, D1
    MOVE.L  $20000000, D1
    MOVE.B  $02000000, D1
    MOVE.W  $02000000, D1
    MOVE.L  $02000000, D1
    MOVE.B  $00200000, D1
    MOVE.W  $00200000, D1
    MOVE.L  $00200000, D1
    MOVE.B  $00020000, D1
    MOVE.W  $00020000, D1
    MOVE.L  $00020000, D1
    MOVE.B  $00002000, D1
    MOVE.W  $00002000, D1
    MOVE.L  $00002000, D1
    MOVE.B  $00000200, D1
    MOVE.W  $00000200, D1
    MOVE.L  $00000200, D1
    MOVE.B  $00000020, D1
    MOVE.W  $00000020, D1
    MOVE.L  $00000020, D1
    MOVE.B  $00000002, D1
    MOVE.W  $00000002, D1
    MOVE.L  $00000002, D1
    MOVE.B  $20000002, D1
    MOVE.W  $20000002, D1
    MOVE.L  $20000002, D1
    *#<data>
    MOVE.B  #$99, D2
    MOVE.B  #%10011001, D2
    MOVE.B  #153, D2
    MOVE.W  #$2710, D2
    MOVE.W  #%0010011100010000, D2
    MOVE.W  #10000, D2
    MOVE.L  #$3B9ACA00, D2
    MOVE.L  #%00111011100110101100101000000000, D2
    MOVE.L  #1000000000, D2
    

    *Destination Testing
    *(An)
    MOVE.B  D3, (A1)
    MOVE.W  D3, (A1)
    MOVE.L  D3, (A1)
    MOVE.B  D4, (A2)
    MOVE.W  D4, (A2)
    MOVE.L  D4, (A2)
    MOVE.B  D5, (A3)
    MOVE.W  D5, (A3)
    MOVE.L  D5, (A3)
    *(An)+
    MOVE.B  D3, (A4)+
    MOVE.W  D3, (A4)+
    MOVE.L  D3, (A4)+
    MOVE.B  D4, (A5)+
    MOVE.W  D4, (A5)+
    MOVE.L  D4, (A5)+
    MOVE.B  D5, (A6)+
    MOVE.W  D5, (A6)+
    MOVE.L  D5, (A6)+
    *-(An)
    MOVE.B  D6, -(A6)
    MOVE.W  D6, -(A6)
    MOVE.L  D6, -(A6)
    MOVE.B  D7, -(A7)
    MOVE.W  D7, -(A7)
    MOVE.L  D7, -(A7)
    MOVE.B  D0, -(A0)
    MOVE.W  D0, -(A0)
    MOVE.L  D0, -(A0)
    *(xxx).W
    MOVE.B  D0, $2000
    MOVE.W  D0, $0200
    MOVE.L  D0, $0020
    MOVE.B  D0, $0002
    *(xxx).L
    MOVE.B  D1, $20000000
    MOVE.W  D1, $20000000
    MOVE.L  D1, $20000000
    MOVE.B  D1, $02000000
    MOVE.W  D1, $02000000
    MOVE.L  D1, $02000000
    MOVE.B  D1, $00200000
    MOVE.W  D1, $00200000
    MOVE.L  D1, $00200000
    MOVE.B  D1, $00020000
    MOVE.W  D1, $00020000
    MOVE.L  D1, $00020000
    MOVE.B  D1, $00002000
    MOVE.W  D1, $00002000
    MOVE.L  D1, $00002000
    MOVE.B  D1, $00000200
    MOVE.W  D1, $00000200
    MOVE.L  D1, $00000200
    MOVE.B  D1, $00000020
    MOVE.W  D1, $00000020
    MOVE.L  D1, $00000020
    MOVE.B  D1, $00000002
    MOVE.W  D1, $00000002
    MOVE.L  D1, $00000002
    MOVE.B  D1, $20000002
    MOVE.W  D1, $20000002
    MOVE.L  D1, $20000002

*NOP
    NOP

*JSR
    JSR     (A1)
    JSR     (A2)
    JSR     (A3)
    JSR     (A4)
    JSR     (A5)
    JSR     (A6)
    JSR     (A7)
    JSR     $7004
    JSR     $0002
    JSR     $7000
    JSR     $00007098
    JSR     $70980000
    JSR     $70000098
    
*LEA
    *(An)
    LEA     (A0), A1
    LEA     (A1), A2
    LEA     (A2), A3
    LEA     (A3), A4
    LEA     (A4), A5
    LEA     (A5), A6
    LEA     (A6), A7
    
    LEA     (A7), A6
    LEA     (A6), A5
    LEA     (A5), A4
    LEA     (A4), A3
    LEA     (A3), A2
    LEA     (A2), A1
    LEA     (A1), A0
    
    LEA     (A7), A0
    LEA     (A6), A1
    LEA     (A5), A2
    LEA     (A4), A3


    *(xxx).W
    LEA     $2000, A1
    LEA     $0200, A1
    LEA     $0020, A1
    LEA     $0002, A1
    LEA     $0000, A1

    
    *(xxx).L
    LEA     $20000000, A1
    LEA     $02000000, A1
    LEA     $00200000, A1
    LEA     $00020000, A1
    LEA     $00002000, A1
    LEA     $00000200, A1
    LEA     $00000020, A1
    LEA     $00000002, A1
    LEA     $20000002, A1
    LEA     $00000000, A1

*NOT
    *Data Register
    NOT     D0
    NOT.B   D0
    NOT.W   D0
    NOT.L   D0
    NOT     D1
    NOT.B   D1
    NOT.W   D1
    NOT.L   D1
    NOT     D2
    NOT.B   D2
    NOT.W   D2
    NOT.L   D2
    NOT     D3
    NOT.B   D3
    NOT.W   D3
    NOT.L   D3
    NOT     D4
    NOT.B   D4
    NOT.W   D4
    NOT.L   D4
    NOT     D5
    NOT.B   D5
    NOT.W   D5
    NOT.L   D5
    NOT     D6
    NOT.B   D6
    NOT.W   D6
    NOT.L   D6
    NOT     D7
    NOT.B   D7
    NOT.W   D7
    NOT.L   D7
    
    *(An)
    NOT     (A0)
    NOT.B   (A0)
    NOT.W   (A0)
    NOT.L   (A0)
    NOT     (A1)
    NOT.B   (A1)
    NOT.W   (A1)
    NOT.L   (A1)
    NOT     (A2)
    NOT.B   (A2)
    NOT.W   (A2)
    NOT.L   (A2)
    NOT     (A3)
    NOT.B   (A3)
    NOT.W   (A3)
    NOT.L   (A3)
    NOT     (A4)
    NOT.B   (A4)
    NOT.W   (A4)
    NOT.L   (A4)
    NOT     (A5)
    NOT.B   (A5)
    NOT.W   (A5)
    NOT.L   (A5)
    NOT     (A6)
    NOT.B   (A6)
    NOT.W   (A6)
    NOT.L   (A6)
    NOT     (A7)
    NOT.B   (A7)
    NOT.W   (A7)
    NOT.L   (A7)

    *(An)+
    NOT     (A0)+
    NOT.B   (A0)+
    NOT.W   (A0)+
    NOT.L   (A0)+
    NOT     (A1)+
    NOT.B   (A1)+
    NOT.W   (A1)+
    NOT.L   (A1)+
    NOT     (A2)+
    NOT.B   (A2)+
    NOT.W   (A2)+
    NOT.L   (A2)+
    NOT     (A3)+
    NOT.B   (A3)+
    NOT.W   (A3)+
    NOT.L   (A3)+
    NOT     (A4)+
    NOT.B   (A4)+
    NOT.W   (A4)+
    NOT.L   (A4)+
    NOT     (A5)+
    NOT.B   (A5)+
    NOT.W   (A5)+
    NOT.L   (A5)+
    NOT     (A6)+
    NOT.B   (A6)+
    NOT.W   (A6)+
    NOT.L   (A6)+
    NOT     (A7)+
    NOT.B   (A7)+
    NOT.W   (A7)+
    NOT.L   (A7)+


    *(An)-
    NOT     -(A0)
    NOT.B   -(A0)
    NOT.W   -(A0)
    NOT.L   -(A0)
    NOT     -(A1)
    NOT.B   -(A1)
    NOT.W   -(A1)
    NOT.L   -(A1)
    NOT     -(A2)
    NOT.B   -(A2)
    NOT.W   -(A2)
    NOT.L   -(A2)
    NOT     -(A3)
    NOT.B   -(A3)
    NOT.W   -(A3)
    NOT.L   -(A3)
    NOT     -(A4)
    NOT.B   -(A4)
    NOT.W   -(A4)
    NOT.L   -(A4)
    NOT     -(A5)
    NOT.B   -(A5)
    NOT.W   -(A5)
    NOT.L   -(A5)
    NOT     -(A6)
    NOT.B   -(A6)
    NOT.W   -(A6)
    NOT.L   -(A6)
    NOT     -(A7)
    NOT.B   -(A7)
    NOT.W   -(A7)
    NOT.L   -(A7)

    *(xxx).W
    NOT     $2000
    NOT.B   $2000
    NOT.W   $2000
    NOT.L   $2000
    
    NOT     $0200
    NOT.B   $0200
    NOT.W   $0200
    NOT.L   $0200

    
    NOT     $0020
    NOT.B   $0020
    NOT.W   $0020
    NOT.L   $0020
    
    NOT     $0002
    NOT.B   $0002
    NOT.W   $0002
    NOT.L   $0002
    
    *(xxx).L
    NOT     $20000000
    NOT.B   $20000000
    NOT.W   $20000000
    NOT.L   $20000000
    
    NOT     $02000000
    NOT.B   $02000000
    NOT.W   $02000000
    NOT.L   $02000000

    NOT     $00200000
    NOT.B   $00200000
    NOT.W   $00200000
    NOT.L   $00200000
    
    NOT     $00020000
    NOT.B   $00020000
    NOT.W   $00020000
    NOT.L   $00020000
    
    NOT     $20000002
    NOT.B   $20000002
    NOT.W   $20000002
    NOT.L   $20000002
    
    NOT     $20020000
    NOT.B   $20020000
    NOT.W   $20020000
    NOT.L   $20020000
    
*MOVEM
    *MOVEM list, <ea>
    *(An), Dn/An
    MOVEM.W D0-D7/A0-A6,(A6)
    MOVEM.L D0-D7/A0-A6,(A6)
    MOVEM.W D0-D6/A0-A5,(A5)
    MOVEM.L D0-D6/A0-A5,(A5)
    MOVEM.W D0-D5/A0-A4,(A4)
    MOVEM.L D0-D5/A0-A4,(A4)
    MOVEM.W D0-D4/A0-A3,(A3)
    MOVEM.L D0-D4/A0-A3,(A3)
    MOVEM.W D0-D3/A0-A2,(A2)
    MOVEM.L D0-D3/A0-A2,(A2)
    MOVEM.W D0-D2/A0-A1,(A1)
    MOVEM.L D0-D2/A0-A1,(A1)
    MOVEM.W D0-D1/A0,(A0)
    MOVEM.L D0-D1/A0,(A0)
    MOVEM.W D0/A7,(A7)
    MOVEM.L D0/A7,(A7)

    *(An), An/Dn
    MOVEM.W A0-A6/D0-D7,(A6)
    MOVEM.L A0-A6/D0-D7,(A6)
    MOVEM.W A0-A5/D0-D6,(A5)
    MOVEM.L A0-A5/D0-D6,(A5)
    MOVEM.W A0-A4/D0-D5,(A4)
    MOVEM.L A0-A4/D0-D5,(A4)
    MOVEM.W A0-A3/D0-D4,(A3)
    MOVEM.L A0-A3/D0-D4,(A3)
    MOVEM.W A0-A2/D0-D3,(A2)
    MOVEM.L A0-A2/D0-D3,(A2)
    MOVEM.W A0-A1/D0-D2,(A1)
    MOVEM.L A0-A1/D0-D2,(A1)
    MOVEM.W A0/D0-D1,(A0)
    MOVEM.L A0/D0-D1,(A0)
    MOVEM.W A7/D0,(A7)
    MOVEM.L A7/D0,(A7)
    
    *-(An)
    MOVEM.W D0-D7/A0-A6,-(A6)
    MOVEM.L D0-D7/A0-A6,-(A6)
    MOVEM.W D0-D6/A0-A5,-(A5)
    MOVEM.L D0-D6/A0-A5,-(A5)
    MOVEM.W D0-D5/A0-A4,-(A4)
    MOVEM.L D0-D5/A0-A4,-(A4)
    MOVEM.W D0-D4/A0-A3,-(A3)
    MOVEM.L D0-D4/A0-A3,-(A3)
    MOVEM.W D0-D3/A0-A2,-(A2)
    MOVEM.L D0-D3/A0-A2,-(A2)
    MOVEM.W D0-D2/A0-A1,-(A1)
    MOVEM.L D0-D2/A0-A1,-(A1)
    MOVEM.W D0-D1/A0,-(A0)
    MOVEM.L D0-D1/A0,(A0)
    MOVEM.W D0/A7,-(A7)
    MOVEM.L D0/A7,-(A7)

    *(xxx).W
    MOVEM.W A0-A6/D0-D7,$5000
    MOVEM.L A0-A6/D0-D7,$5002
    MOVEM.W A0-A5/D0-D6,$5004
    MOVEM.L A0-A5/D0-D6,$5006
    MOVEM.W A0-A4/D0-D5,$5008
    MOVEM.L A0-A4/D0-D5,$500A
    MOVEM.W A0-A3/D0-D4,$500C
    MOVEM.L A0-A3/D0-D4,$500E
    MOVEM.W A0-A2/D0-D3,$5010
    MOVEM.L A0-A2/D0-D3,$5012
    MOVEM.W A0-A1/D0-D2,$5014
    MOVEM.L A0-A1/D0-D2,$5016
    MOVEM.W A0/D0-D1,$5018
    MOVEM.L A0/D0-D1,$501A
    MOVEM.W A7/D0,$501C
    MOVEM.L A7/D0,$501E
    
    *(xxx).L
    MOVEM.W A0-A6/D0-D7,$50000000
    MOVEM.L A0-A6/D0-D7,$50000002
    MOVEM.W A0-A5/D0-D6,$50000040
    MOVEM.L A0-A5/D0-D6,$50000600
    MOVEM.W A0-A4/D0-D5,$50008000
    MOVEM.L A0-A4/D0-D5,$500A0000
    MOVEM.W A0-A3/D0-D4,$50C00000
    MOVEM.L A0-A3/D0-D4,$5E000000
    MOVEM.W A0-A2/D0-D3,$00005010
    MOVEM.L A0-A2/D0-D3,$00050120
    MOVEM.W A0-A1/D0-D2,$00501400
    MOVEM.L A0-A1/D0-D2,$05016000
    MOVEM.W A0/D0-D1,$50180000

    *MOVEM <ea>, list
     *(An), Dn/An
    MOVEM.W (A6),D0-D7/A0-A6
    MOVEM.L (A6),D0-D7/A0-A6
    MOVEM.W (A5),D0-D6/A0-A5
    MOVEM.L (A5),D0-D6/A0-A5
    MOVEM.W (A4),D0-D5/A0-A4
    MOVEM.L (A4),D0-D5/A0-A4
    MOVEM.W (A3),D0-D4/A0-A3
    MOVEM.L (A3),D0-D4/A0-A3
    MOVEM.W (A2),D0-D3/A0-A2
    MOVEM.L (A2),D0-D3/A0-A2
    MOVEM.W (A1),D0-D2/A0-A1
    MOVEM.L (A1),D0-D2/A0-A1
    MOVEM.W (A0),D0-D1/A0
    MOVEM.L (A0),D0-D1/A0
    MOVEM.W (A7),D0/A7
    MOVEM.L (A7),D0/A7

    *(An), An/Dn
    MOVEM.W (A6),A0-A6/D0-D7
    MOVEM.L (A6),A0-A6/D0-D7
    MOVEM.W (A5),A0-A5/D0-D6
    MOVEM.L (A5),A0-A5/D0-D6
    MOVEM.W (A4),A0-A4/D0-D5
    MOVEM.L (A4),A0-A4/D0-D5
    MOVEM.W (A3),A0-A3/D0-D4
    MOVEM.L (A3),A0-A3/D0-D4
    MOVEM.W (A2),A0-A2/D0-D3
    MOVEM.L (A2),A0-A2/D0-D3
    MOVEM.W (A1),A0-A1/D0-D2
    MOVEM.L (A1),A0-A1/D0-D2
    MOVEM.W (A0),A0/D0-D1
    MOVEM.L (A0),A0/D0-D1
    MOVEM.W (A7),A7/D0
    MOVEM.L (A7),A7/D0

    *(An)+, Dn/An
    MOVEM.W (A6)+,D0-D7/A0-A6
    MOVEM.L (A6)+,D0-D7/A0-A6
    MOVEM.W (A5)+,D0-D6/A0-A5
    MOVEM.L (A5)+,D0-D6/A0-A5
    MOVEM.W (A4)+,D0-D5/A0-A4
    MOVEM.L (A4)+,D0-D5/A0-A4
    MOVEM.W (A3)+,D0-D4/A0-A3
    MOVEM.L (A3)+,D0-D4/A0-A3
    MOVEM.W (A2)+,D0-D3/A0-A2
    MOVEM.L (A2)+,D0-D3/A0-A2
    MOVEM.W (A1)+,D0-D2/A0-A1
    MOVEM.L (A1)+,D0-D2/A0-A1
    MOVEM.W (A0)+,D0-D1/A0
    MOVEM.L (A0)+,D0-D1/A0
    MOVEM.W (A7)+,D0/A7
    MOVEM.L (A7)+,D0/A7
    
    *(xxx).W
    MOVEM.W $6000,A0-A6/D0-D7
    MOVEM.L $6002,A0-A6/D0-D7
    MOVEM.W $6004,A0-A5/D0-D6
    MOVEM.L $6006,A0-A5/D0-D6
    MOVEM.W $6008,A0-A4/D0-D5
    MOVEM.L $600A,A0-A4/D0-D5
    MOVEM.W $600C,A0-A3/D0-D4
    MOVEM.L $600E,A0-A3/D0-D4
    MOVEM.W $6010,A0-A2/D0-D3
    MOVEM.L $6012,A0-A2/D0-D3
    MOVEM.W $6014,A0-A1/D0-D2
    MOVEM.L $6016,A0-A1/D0-D2
    MOVEM.W $6018,A0/D0-D1
    MOVEM.L $601A,A0/D0-D1
    MOVEM.W $601C,A7/D0
    MOVEM.L $601E,A7/D0
    
    *(xxx).L
    MOVEM.W $60000000,A0-A6/D0-D7
    MOVEM.L $60000002,A0-A6/D0-D7
    MOVEM.W $60000040,A0-A5/D0-D6
    MOVEM.L $60000600,A0-A5/D0-D6
    MOVEM.W $60008000,A0-A4/D0-D5
    MOVEM.L $600A0000,A0-A4/D0-D5
    MOVEM.W $60C00000,A0-A3/D0-D4
    MOVEM.L $6E000000,A0-A3/D0-D4
    MOVEM.W $00006010,A0-A2/D0-D3
    MOVEM.L $00060120,A0-A2/D0-D3
    MOVEM.W $00601400,A0-A1/D0-D2
    MOVEM.L $06016000,A0-A1/D0-D2
    MOVEM.W $60180000,A0/D0-D1
    
*BRANCHING
    MOVE.L  $00000000, D0
    MOVE.L  $00000000, D1
    MOVE.L  $00000000, D2
    MOVE.L  $00000000, D3
    MOVE.L  $00000000, D4
    MOVE.L  $00000000, D5
    MOVE.L  $00000000, D6
    MOVE.L  $00000000, D7
    JSR     TEST0
    JSR     TEST1
    
TEST0
    LEA     $00007012, A0
    RTS
BUFFER0
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST1
    MOVE.B  D0, D1
    MOVE.W  $1000, D2
    MOVE.L  $10000000, D3
    MOVE.B  #5, D1
    NOT     D1
    BRA     TEST2
BUFFER1
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST2
    ADD.B   D0, D2
    SUB.W   D2, D3
    BCC     TEST3
BUFFER2
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST3
    MOVE.B  #6, D6
    BGT     TEST4
BUFFER3
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST4
    LSL.L   #1, D3
    BLE     TEST5
BUFFER4
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST5
    MOVE.B  #0, D7
    BEQ     TEST6
BUFFER5
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST6
    AND.B   #7, D0
    BLE     TEST7
BUFFER6
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST7
    MULS.W  #6, D1
    BLE TEST8
BUFFER7
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST8
    DIVU.W  #60, D1
    BGT     TEST9
BUFFER8
    MOVE.L  #11111111, D0
    BRA     FINISH
TEST9
    ASL.W   #8, D2
    BLE     FINISH
BUFFER9
    MOVE.L  #11111111, D0
    BRA     FINISH
FINISH


*SUB
    *SUB <ea>,Dn
    *Dn
    SUB.W   D0, D1
    SUB.B   D1, D2
    SUB.B   D2, D3
    SUB.W   D3, D4
    SUB.W   D4, D5
    SUB.L   D5, D6
    SUB.L   D6, D7
    *An
    SUB.W   A0, D0
    SUB.W   A1, D1
    SUB.W   A2, D2
    SUB.W   A3, D3
    SUB.W   A4, D4
    SUB.L   A5, D5
    SUB.L   A6, D6
    SUB.L   A7, D7
    *(An)
    SUB.B   (A0), D0
    SUB.B   (A1), D1
    SUB.B   (A2), D2
    SUB.W   (A3), D3
    SUB.W   (A4), D4
    SUB.W   (A5), D5
    SUB.L   (A6), D6
    SUB.L   (A7), D7
    *(An)+
    SUB.B   (A0)+, D0
    SUB.B   (A1)+, D1
    SUB.B   (A2)+, D2
    SUB.W   (A3)+, D3
    SUB.W   (A4)+, D4
    SUB.W   (A5)+, D5
    SUB.L   (A6)+, D6
    SUB.L   (A7)+, D7
    *-(An)
    SUB.B   -(A0), D0
    SUB.B   -(A1), D1
    SUB.B   -(A2), D2
    SUB.W   -(A3), D3
    SUB.W   -(A4), D4
    SUB.W   -(A5), D5
    SUB.L   -(A6), D6
    SUB.L   -(A7), D7
    *(xxx).W
    SUB.B   $2000, D0
    SUB.B   $0200, D1
    SUB.W   $0020, D2
    SUB.L   $0002, D3
    SUB.L   $0000, D4
    *(xxx).L
    SUB.B   $20000000, D0
    SUB.B   $02000000, D1
    SUB.B   $00200000, D2
    SUB.W   $00020000, D3
    SUB.W   $00002000, D4
    SUB.W   $00000200, D5
    SUB.W   $00000020, D6
    SUB.L   $00000002, D7
    SUB.L   $20000002, D0
    SUB.L   $00000000, D1

    
    *SUB Dn,<ea>   
    *(An)
    SUB     D0,(A0)
    SUB     D1,(A1)
    SUB     D2,(A2)
    SUB     D3,(A3)
    SUB     D4,(A4)
    SUB     D5,(A5)
    SUB     D6,(A6)
    SUB     D7,(A7)
    *(An)+
    SUB     D0,(A0)+
    SUB     D1,(A1)+
    SUB     D2,(A2)+ 
    SUB     D3,(A3)+
    SUB     D4,(A4)+
    SUB     D5,(A5)+
    SUB     D6,(A6)+
    SUB     D7,(A7)+
    *-(An)
    SUB     D0,-(A0)
    SUB     D1,-(A1)
    SUB     D2,-(A2) 
    SUB     D3,-(A3)
    SUB     D4,-(A4)
    SUB     D5,-(A5)
    SUB     D6,-(A6)
    SUB     D7,-(A7)
    *(xxx).W
    SUB     D0,$2000
    SUB     D1,$0200
    SUB     D2,$0020
    SUB     D3,$0002
    SUB     D4,$0000
    *(xxx).L
    SUB     D0,$20000000
    SUB     D1,$02000000
    SUB     D2,$00200000
    SUB     D3,$00020000
    SUB     D4,$00002000
    SUB     D5,$00000200
    SUB     D6,$00000020
    SUB     D7,$00000002
    SUB     D0,$20000002
    SUB     D1,$00000000

*DIVU.W
    *Dn
    DIVU.W  D0, D1
    DIVU.W  D1, D2
    DIVU.W  D2, D3
    DIVU.W  D3, D4
    DIVU.W  D4, D5
    DIVU.W  D5, D6
    DIVU.W  D6, D7
    *(An)
    DIVU.W  (A0), D0
    DIVU.W  (A1), D1
    DIVU.W  (A2), D2
    DIVU.W  (A3), D3
    DIVU.W  (A4), D4
    DIVU.W  (A5), D5
    DIVU.W  (A6), D6
    DIVU.W  (A7), D7
    *(An)+
    DIVU.W  (A0)+, D0
    DIVU.W  (A1)+, D1
    DIVU.W  (A2)+, D2
    DIVU.W  (A3)+, D3
    DIVU.W  (A4)+, D4
    DIVU.W  (A5)+, D5
    DIVU.W  (A6)+, D6
    DIVU.W  (A7)+, D7
    *-(An)
    DIVU.W  -(A0), D0
    DIVU.W  -(A1), D1
    DIVU.W  -(A2), D2
    DIVU.W  -(A3), D3
    DIVU.W  -(A4), D4
    DIVU.W  -(A5), D5
    DIVU.W  -(A6), D6
    DIVU.W  -(A7), D7
    *(xxx).W
    DIVU.W  $2000, D0
    DIVU.W  $0200, D1
    DIVU.W  $0020, D2
    DIVU.W  $0002, D3
    DIVU.W  $0000, D4
    *(xxx).L
    DIVU.W  $20000000, D0
    DIVU.W  $02000000, D1
    DIVU.W  $00200000, D2
    DIVU.W  $00020000, D3
    DIVU.W  $00002000, D4
    DIVU.W  $00000200, D5
    DIVU.W  $00000020, D6
    DIVU.W  $00000002, D7
    DIVU.W  $20000002, D0
    DIVU.W  $00000000, D1
    *#<data>
    DIVU.W  #$99, D2
    DIVU.W  #%10011001, D1
    DIVU.W  #153, D5
    DIVU.W  #$2710, D3
    DIVU.W  #%0010011100010000, D6
    DIVU.W  #10000, D7
    DIVU.W  #$CA00, D3
    DIVU.W  #%1100101000000000, D0
    DIVU.W  #10000, D1
    
*MULS.W
    *Dn
    MULS.W  D0, D1
    MULS.W  D1, D2
    MULS.W  D2, D3
    MULS.W  D3, D4
    MULS.W  D4, D5
    MULS.W  D5, D6
    MULS.W  D6, D7
    *(An)
    MULS.W  (A0), D0
    MULS.W  (A1), D1
    MULS.W  (A2), D2
    MULS.W  (A3), D3
    MULS.W  (A4), D4
    MULS.W  (A5), D5
    MULS.W  (A6), D6
    MULS.W  (A7), D7
    *(An)+
    MULS.W  (A0)+, D0
    MULS.W  (A1)+, D1
    MULS.W  (A2)+, D2
    MULS.W  (A3)+, D3
    MULS.W  (A4)+, D4
    MULS.W  (A5)+, D5
    MULS.W  (A6)+, D6
    MULS.W  (A7)+, D7
    *-(An)
    MULS.W  -(A0), D0
    MULS.W  -(A1), D1
    MULS.W  -(A2), D2
    MULS.W  -(A3), D3
    MULS.W  -(A4), D4
    MULS.W  -(A5), D5
    MULS.W  -(A6), D6
    MULS.W  -(A7), D7
    *(xxx).W
    MULS.W  $2000, D0
    MULS.W  $0200, D1
    MULS.W  $0020, D2
    MULS.W  $0002, D3
    MULS.W  $0000, D4
    *(xxx).L
    MULS.W  $20000000, D0
    MULS.W  $02000000, D1
    MULS.W  $00200000, D2
    MULS.W  $00020000, D3
    MULS.W  $00002000, D4
    MULS.W  $00000200, D5
    MULS.W  $00000020, D6
    MULS.W  $00000002, D7
    MULS.W  $20000002, D0
    MULS.W  $00000000, D1
    *#<data>
    MULS.W  #$99, D2
    MULS.W  #%10011001, D1
    MULS.W  #153, D5
    MULS.W  #$2710, D3
    MULS.W  #%0010011100010000, D6
    MULS.W  #10000, D7
    MULS.W  #$CA00, D3
    MULS.W  #%1100101000000000, D0
    MULS.W  #10000, D1

*ADD
    *AND <EA>,DN
    *AND.B
    *Dn
    AND.B   D0, D1
    AND.B   D1, D2
    AND.B   D2, D3
    AND.B   D3, D4
    AND.B   D4, D5
    AND.B   D5, D6
    AND.B   D6, D7
    *(An)
    AND.B   (A0), D0
    AND.B   (A1), D1
    AND.B   (A2), D2
    AND.B   (A3), D3
    AND.B   (A4), D4
    AND.B   (A5), D5
    AND.B   (A6), D6
    AND.B   (A7), D7
    *(An)+
    AND.B   (A0)+, D0
    AND.B   (A1)+, D1
    AND.B   (A2)+, D2
    AND.B   (A3)+, D3
    AND.B   (A4)+, D4
    AND.B   (A5)+, D5
    AND.B   (A6)+, D6
    AND.B   (A7)+, D7
    *-(An)
    AND.B   -(A0), D0
    AND.B   -(A1), D1
    AND.B   -(A2), D2
    AND.B   -(A3), D3
    AND.B   -(A4), D4
    AND.B   -(A5), D5
    AND.B   -(A6), D6
    AND.B   -(A7), D7
    *(xxx).W
    AND.B   $2000, D0
    AND.B   $0200, D1
    AND.B   $0020, D2
    AND.B   $0002, D3
    AND.B   $0000, D4
    *(xxx).L
    AND.B   $20000000, D0
    AND.B   $02000000, D1
    AND.B   $00200000, D2
    AND.B   $00020000, D3
    AND.B   $00002000, D4
    AND.B   $00000200, D5
    AND.B   $00000020, D6
    AND.B   $00000002, D7
    AND.B   $20000002, D0
    AND.B   $00000000, D1
    *#<data>
    AND.B   #$99, D2
    AND.B   #%10011001, D1
    AND.B   #153, D5
    AND.B   #$10, D3
    AND.B   #%10000, D6
    AND.B   #10, D7
    AND.B   #$CA, D3
    AND.B   #%00000, D0
    AND.B   #100, D1
       
    *AND.W
    *Dn
    AND.W   D0, D1
    AND.W   D1, D2
    AND.W   D2, D3
    AND.W   D3, D4
    AND.W   D4, D5
    AND.W   D5, D6
    AND.W   D6, D7
    *(An)
    AND.W   (A0), D0
    AND.W   (A1), D1
    AND.W   (A2), D2
    AND.W   (A3), D3
    AND.W   (A4), D4
    AND.W   (A5), D5
    AND.W   (A6), D6
    AND.W   (A7), D7
    *(An)+
    AND.W   (A0)+, D0
    AND.W   (A1)+, D1
    AND.W   (A2)+, D2
    AND.W   (A3)+, D3
    AND.W   (A4)+, D4
    AND.W   (A5)+, D5
    AND.W   (A6)+, D6
    AND.W   (A7)+, D7
    *-(An)
    AND.W   -(A0), D0
    AND.W   -(A1), D1
    AND.W   -(A2), D2
    AND.W   -(A3), D3
    AND.W   -(A4), D4
    AND.W   -(A5), D5
    AND.W   -(A6), D6
    AND.W   -(A7), D7
    *(xxx).W
    AND.W   $2000, D0
    AND.W   $0200, D1
    AND.W   $0020, D2
    AND.W   $0002, D3
    AND.W   $0000, D4
    *(xxx).L
    AND.W   $20000000, D0
    AND.W   $02000000, D1
    AND.W   $00200000, D2
    AND.W   $00020000, D3
    AND.W   $00002000, D4
    AND.W   $00000200, D5
    AND.W   $00000020, D6
    AND.W   $00000002, D7
    AND.W   $20000002, D0
    AND.W   $00000000, D1
    *#<data>
    AND.W   #$99, D2
    AND.W   #%10011001, D1
    AND.W   #153, D5
    AND.W   #$2710, D3
    AND.W   #%0010011100010000, D6
    AND.W   #10000, D7
    AND.W   #$CA00, D3
    AND.W   #%1100101000000000, D0
    AND.W   #10000, D1
        
    *AND.L
    *Dn
    AND.L   D0, D1
    AND.L   D1, D2
    AND.L   D2, D3
    AND.L   D3, D4
    AND.L   D4, D5
    AND.L   D5, D6
    AND.L   D6, D7
    *(An)
    AND.L   (A0), D0
    AND.L   (A1), D1
    AND.L   (A2), D2
    AND.L   (A3), D3
    AND.L   (A4), D4
    AND.L   (A5), D5
    AND.L   (A6), D6
    AND.L   (A7), D7
    *(An)+
    AND.L   (A0)+, D0
    AND.L   (A1)+, D1
    AND.L   (A2)+, D2
    AND.L   (A3)+, D3
    AND.L   (A4)+, D4
    AND.L   (A5)+, D5
    AND.L   (A6)+, D6
    AND.L   (A7)+, D7
    *-(An)
    AND.L   -(A0), D0
    AND.L   -(A1), D1
    AND.L   -(A2), D2
    AND.L   -(A3), D3
    AND.L   -(A4), D4
    AND.L   -(A5), D5
    AND.L   -(A6), D6
    AND.L   -(A7), D7
    *(xxx).W
    AND.L   $2000, D0
    AND.L   $0200, D1
    AND.L   $0020, D2
    AND.L   $0002, D3
    AND.L   $0000, D4
    *(xxx).L
    AND.L   $20000000, D0
    AND.L   $02000000, D1
    AND.L   $00200000, D2
    AND.L   $00020000, D3
    AND.L   $00002000, D4
    AND.L   $00000200, D5
    AND.L   $00000020, D6
    AND.L   $00000002, D7
    AND.L   $20000002, D0
    AND.L   $00000000, D1
    *#<data>
    AND.L   #$99, D2
    AND.L   #%10011001, D1
    AND.L   #153, D5
    AND.L   #$2710, D3
    AND.L   #%0010011100010000, D6
    AND.L   #10000, D7
    AND.L   #$CA00, D3
    AND.L   #%1100101000000000, D0
    AND.L   #10000, D1
    

    *AND DN,<EA>
    *AND.B
    *(An)
    AND.B   D0,(A0) 
    AND.B   D1,(A1)
    AND.B   D2,(A2)
    AND.B   D3,(A3)
    AND.B   D4,(A4)
    AND.B   D5,(A5)
    AND.B   D6,(A6)
    AND.B   D7,(A7)
    *(An)+
    AND.B   D0,(A0)+
    AND.B   D1,(A1)+
    AND.B   D2,(A2)+
    AND.B   D3,(A3)+
    AND.B   D4,(A4)+
    AND.B   D5,(A5)+
    AND.B   D6,(A6)+
    AND.B   D7,(A7)+
    *-(An)
    AND.B   D0,-(A0)
    AND.B   D1,-(A1)
    AND.B   D2,-(A2)
    AND.B   D3,-(A3)
    AND.B   D4,-(A4)
    AND.B   D5,-(A5)
    AND.B   D6,-(A6)
    AND.B   D7,-(A7)
    *(xxx).W
    AND.B   D0,$2000
    AND.B   D1,$0200
    AND.B   D2,$0020 
    AND.B   D3,$0002
    AND.B   D4,$0000
    *(xxx).L
    AND.B   D0,$20000000
    AND.B   D1,$02000000
    AND.B   D2,$00200000
    AND.B   D3,$00020000
    AND.B   D4,$00002000
    AND.B   D5,$00000200
    AND.B   D6,$00000020
    AND.B   D7,$00000002
    AND.B   D0,$20000002
    AND.B   D1,$00000000
    
    
    *AND.W
    *(An)
    AND.W   D0,(A0) 
    AND.W   D1,(A1)
    AND.W   D2,(A2)
    AND.W   D3,(A3)
    AND.W   D4,(A4)
    AND.W   D5,(A5)
    AND.W   D6,(A6)
    AND.W   D7,(A7)
    *(An)+
    AND.W   D0,(A0)+
    AND.W   D1,(A1)+
    AND.W   D2,(A2)+
    AND.W   D3,(A3)+
    AND.W   D4,(A4)+
    AND.W   D5,(A5)+
    AND.W   D6,(A6)+
    AND.W   D7,(A7)+
    *-(An)
    AND.W   D0,-(A0)
    AND.W   D1,-(A1)
    AND.W   D2,-(A2)
    AND.W   D3,-(A3)
    AND.W   D4,-(A4)
    AND.W   D5,-(A5)
    AND.W   D6,-(A6)
    AND.W   D7,-(A7)
    *(xxx).W
    AND.W   D0,$2000
    AND.W   D1,$0200
    AND.W   D2,$0020 
    AND.W   D3,$0002
    AND.W   D4,$0000
    *(xxx).L
    AND.W   D0,$20000000
    AND.W   D1,$02000000
    AND.W   D2,$00200000
    AND.W   D3,$00020000
    AND.W   D4,$00002000
    AND.W   D5,$00000200
    AND.W   D6,$00000020
    AND.W   D7,$00000002
    AND.W   D0,$20000002
    AND.W   D1,$00000000

    *AND.L
    *(An)
    AND.L   D0,(A0) 
    AND.L   D1,(A1)
    AND.L   D2,(A2)
    AND.L   D3,(A3)
    AND.L   D4,(A4)
    AND.L   D5,(A5)
    AND.L   D6,(A6)
    AND.L   D7,(A7)
    *(An)+
    AND.L   D0,(A0)+
    AND.L   D1,(A1)+
    AND.L   D2,(A2)+
    AND.L   D3,(A3)+
    AND.L   D4,(A4)+
    AND.L   D5,(A5)+
    AND.L   D6,(A6)+
    AND.L   D7,(A7)+
    *-(An)
    AND.L   D0,-(A0)
    AND.L   D1,-(A1)
    AND.L   D2,-(A2)
    AND.L   D3,-(A3)
    AND.L   D4,-(A4)
    AND.L   D5,-(A5)
    AND.L   D6,-(A6)
    AND.L   D7,-(A7)
    *(xxx).W
    AND.L   D0,$2000
    AND.L   D1,$0200
    AND.L   D2,$0020 
    AND.L   D3,$0002
    AND.L   D4,$0000
    *(xxx).L
    AND.L   D0,$20000000
    AND.L   D1,$02000000
    AND.L   D2,$00200000
    AND.L   D3,$00020000
    AND.L   D4,$00002000
    AND.L   D5,$00000200
    AND.L   D6,$00000020
    AND.L   D7,$00000002
    AND.L   D0,$20000002
    AND.L   D1,$00000000
    
*ADD
    *ADD <ea>,Dn
    *Dn
    ADD.B   D0, D1
    ADD.B   D1, D2
    ADD.W   D2, D3
    ADD.W   D3, D4
    ADD.W   D4, D5
    ADD.L   D5, D6
    ADD.L   D6, D7
    *An
    ADD.W   A0, D0
    ADD.W   A1, D1
    ADD.W   A2, D2
    ADD.W   A3, D3
    ADD.W   A4, D4
    ADD.L   A5, D5
    ADD.L   A6, D6
    ADD.L   A7, D7
    *(An)
    ADD.B   (A0), D0
    ADD.B   (A1), D1
    ADD.W   (A2), D2
    ADD.W   (A3), D3
    ADD.W   (A4), D4
    ADD.L   (A5), D5
    ADD.L   (A6), D6
    ADD.L   (A7), D7
    *(An)+
    ADD.B   (A0)+, D0
    ADD.B   (A1)+, D1
    ADD.B   (A2)+, D2
    ADD.W   (A3)+, D3
    ADD.W   (A4)+, D4
    ADD.L   (A5)+, D5
    ADD.L   (A6)+, D6
    ADD.L   (A7)+, D7
    *-(An)
    ADD.B   -(A0), D0
    ADD.B   -(A1), D1
    ADD.B   -(A2), D2
    ADD.W   -(A3), D3
    ADD.W   -(A4), D4
    ADD.W   -(A5), D5
    ADD.L   -(A6), D6
    ADD.L   -(A7), D7
    *(xxx).W
    ADD.B   $2000, D0
    ADD.B   $0200, D1
    ADD.B   $0020, D2
    ADD.W   $0002, D3
    ADD.L   $0000, D4
    *(xxx).L
    ADD.B   $20000000, D0
    ADD.W   $02000000, D1
    ADD.L   $00200000, D2
    ADD.L   $00020000, D3
    ADD.W   $00002000, D4
    ADD.W   $00000200, D5
    ADD.L   $00000020, D6
    ADD.W   $00000002, D7
    ADD.W   $20000002, D0
    ADD.L   $00000000, D1

    
    *ADD_Dn_EA
    *(An)
    ADD.B   D0,(A0)
    ADD.B   D1,(A1)
    ADD.B   D2,(A2)
    ADD.W   D3,(A3)
    ADD.W   D4,(A4)
    ADD.L   D5,(A5)
    ADD.L   D6,(A6)
    ADD.L   D7,(A7)
    *(An)+
    ADD.B   D0,(A0)+
    ADD.B   D1,(A1)+
    ADD.B   D2,(A2)+ 
    ADD.W   D3,(A3)+
    ADD.W   D4,(A4)+
    ADD.W   D5,(A5)+
    ADD.L   D6,(A6)+
    ADD.L   D7,(A7)+
    *-(An)
    ADD.B   D0,-(A0)
    ADD.B   D1,-(A1)
    ADD.B   D2,-(A2) 
    ADD.W   D3,-(A3)
    ADD.W   D4,-(A4)
    ADD.L   D5,-(A5)
    ADD.L   D6,-(A6)
    ADD.L   D7,-(A7)
    *(xxx).W
    ADD.B   D0,$2000
    ADD.B   D1,$0200
    ADD.W   D2,$0020
    ADD.W   D3,$0002
    ADD.L   D4,$0000
    *(xxx).L
    ADD.B   D0,$20000000
    ADD.B   D1,$02000000
    ADD.B   D2,$00200000
    ADD.W   D3,$00020000
    ADD.W   D4,$00002000
    ADD.L   D5,$00000200
    ADD.L   D6,$00000020
    ADD.L   D7,$00000002
    ADD.L   D0,$20000002
    ADD.W   D1,$00000000

*LSL
    *Register Shift
    LSL.B   #1, D0
    LSL.B   #2, D1
    LSL.B   #3, D2
    LSL.B   #4, D3
    LSL.B   #5, D4
    LSL.B   #6, D5
    LSL.B   #7, D6
    LSL.B   #8, D7
    
    LSL.W   #1, D0
    LSL.W   #2, D1
    LSL.W   #3, D2
    LSL.W   #4, D3
    LSL.W   #5, D4
    LSL.W   #6, D5
    LSL.W   #7, D6
    LSL.W   #8, D7
    
    LSL.L   #1, D0
    LSL.L   #2, D1
    LSL.L   #3, D2
    LSL.L   #4, D3
    LSL.L   #5, D4
    LSL.L   #6, D5
    LSL.L   #7, D6
    LSL.L   #8, D7
    
    *Count Shift
    LSL.B   D0, D1
    LSL.B   D1, D2
    LSL.B   D2, D3
    LSL.B   D3, D4
    LSL.B   D4, D5
    LSL.B   D5, D6
    LSL.B   D6, D7
    
    LSL.W   D7, D6
    LSL.W   D6, D5
    LSL.W   D5, D4
    LSL.W   D4, D3
    LSL.W   D3, D2
    LSL.W   D2, D1
    LSL.W   D1, D0
    
    LSL.L   D0, D1
    LSL.L   D1, D2
    LSL.L   D2, D3
    LSL.L   D3, D4
    LSL.L   D4, D5
    LSL.L   D5, D6
    LSL.L   D6, D7
    
    *Memory Shift
    *(An)
    LSL.W   (A0)
    LSL.W   (A1)
    LSL.W   (A2)
    LSL.W   (A3)
    LSL.W   (A4)
    LSL.W   (A5)
    LSL.W   (A6)
    LSL.W   (A7)
    
    *(An)+
    LSL.W   (A0)+
    LSL.W   (A1)+
    LSL.W   (A2)+
    LSL.W   (A3)+
    LSL.W   (A4)+
    LSL.W   (A5)+
    LSL.W   (A6)+
    LSL.W   (A7)+
    
    *-(An)
    LSL.W   -(A0)
    LSL.W   -(A1)
    LSL.W   -(A2)
    LSL.W   -(A3)
    LSL.W   -(A4)
    LSL.W   -(A5)
    LSL.W   -(A6)
    LSL.W   -(A7)
    
    *(xxx).W
    LSL.W   $2000
    LSL.W   $0200
    LSL.W   $0020
    LSL.W   $0002
    LSL.W   $2002
    
    *(xxx).L
    LSL.W   $20000000
    LSL.W   $02000000
    LSL.W   $00200000
    LSL.W   $00020000
    LSL.W   $00002000
    LSL.W   $00000200
    LSL.W   $00000020
    LSL.W   $00000002
    LSL.W   $20000002
    
*ASL
    *Register Shift
    ASL.B   #1, D0
    ASL.B   #2, D1
    ASL.B   #3, D2
    ASL.B   #4, D3
    ASL.B   #5, D4
    ASL.B   #6, D5
    ASL.B   #7, D6
    ASL.B   #8, D7
    
    ASL.W   #1, D0
    ASL.W   #2, D1
    ASL.W   #3, D2
    ASL.W   #4, D3
    ASL.W   #5, D4
    ASL.W   #6, D5
    ASL.W   #7, D6
    ASL.W   #8, D7
    
    ASL.L   #1, D0
    ASL.L   #2, D1
    ASL.L   #3, D2
    ASL.L   #4, D3
    ASL.L   #5, D4
    ASL.L   #6, D5
    ASL.L   #7, D6
    ASL.L   #8, D7
    
    *Count Shift
    ASL.B   D0, D1
    ASL.B   D1, D2
    ASL.B   D2, D3
    ASL.B   D3, D4
    ASL.B   D4, D5
    ASL.B   D5, D6
    ASL.B   D6, D7
    
    ASL.W   D7, D6
    ASL.W   D6, D5
    ASL.W   D5, D4
    ASL.W   D4, D3
    ASL.W   D3, D2
    ASL.W   D2, D1
    ASL.W   D1, D0
    
    ASL.L   D0, D1
    ASL.L   D1, D2
    ASL.L   D2, D3
    ASL.L   D3, D4
    ASL.L   D4, D5
    ASL.L   D5, D6
    ASL.L   D6, D7
    
    *Memory Shift
    *(An)
    ASL.W   (A0)
    ASL.W   (A1)
    ASL.W   (A2)
    ASL.W   (A3)
    ASL.W   (A4)
    ASL.W   (A5)
    ASL.W   (A6)
    ASL.W   (A7)
    
    *(An)+
    ASL.W   (A0)+
    ASL.W   (A1)+
    ASL.W   (A2)+
    ASL.W   (A3)+
    ASL.W   (A4)+
    ASL.W   (A5)+
    ASL.W   (A6)+
    ASL.W   (A7)+
    
    *-(An)
    ASL.W   -(A0)
    ASL.W   -(A1)
    ASL.W   -(A2)
    ASL.W   -(A3)
    ASL.W   -(A4)
    ASL.W   -(A5)
    ASL.W   -(A6)
    ASL.W   -(A7)
    
    *(xxx).W
    ASL.W   $2000
    ASL.W   $0200
    ASL.W   $0020
    ASL.W   $0002
    ASL.W   $2002
    
    *(xxx).L
    ASL.W   $20000000
    ASL.W   $02000000
    ASL.W   $00200000
    ASL.W   $00020000
    ASL.W   $00002000
    ASL.W   $00000200
    ASL.W   $00000020
    ASL.W   $00000002
    ASL.W   $20000002
    

*Invalid instructions for dissassembler
    ANDI.W  #1234, D0 
    ASR.B   #1, D0     
    LSR.B   #$2, D2     
    BCLR    D0, D2
    ROL.B   D1, D2     
    ROR.B   #%101, D3          
    ADDQ.W  #6, D4
    SUBQ.B  #8, D5
    MOVEQ   #$A, D7
    CMPA.L  A0, A1
 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
