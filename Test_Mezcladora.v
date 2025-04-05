/* ======================================================================
Estudiante: Marvin Castro Castro, C01884
Circuitos Digitales I IE0323
Entrega: 09/12/22
Módulo Testbench Mezcladora
==========================================================================*/



`timescale 1ns/1ps

module Test_Mezcladora;


// Declaración de entradas y salidas
reg Clk, Reset;
reg IN, P1, P2, TOK; 

wire V1, V2, V3, M, B, S ,T;

// Declaración de arrays para almacenar vectores de prueba
reg [3:0] testvectors [13:0];
integer vectornum;

// Instanciación de módulo de prueba
Mezcladora uut (
        .Clk(Clk), .Reset(Reset),
        .IN(IN), .P1(P1), .P2(P2), .TOK(TOK),
        .V1(V1), .V2(V2), .V3(V3), .M(M), .B(B), .S(S), .T(T)
);


// 1. Generación de secuencias de entradas
initial
    begin
                        // IN : P1 : P2 : TOK
        testvectors[0] = 4'b0000;  //ESTADO a
        testvectors[1] = 4'b1000;  //ESTADO b
        testvectors[2] = 4'b1010;  //ESTADO c
        testvectors[3] = 4'b1110;  //ESTADO d
        testvectors[4] = 4'b0000;  //ESTADO g
        testvectors[5] = 4'b1110;  //ESTADO g
        testvectors[6] = 4'b1111;  //ESTADO h
        testvectors[7] = 4'b1101;  //ESTADO i
        testvectors[8] = 4'b1001;  //ESTADO j
        testvectors[9] = 4'b0100;  //ESTADO j
        testvectors[10] = 4'b0000; //ESTADO a
        testvectors[11] = 4'b1000; //ESTADO b
        testvectors[12] = 4'b1100; //ESTADO e
        testvectors[13] = 4'b0010; //ESTADO f
        
        // 2. Inicio de puntero de vector de prueba
        vectornum = 0;

        // 3. Reset a los FF 
        Reset = 1;
        #3 Reset = 0;

    //creación de archivos para diagrama de tiempo GTKwave
    $dumpfile("Mezcladora.vcd");
    $dumpvars(0, Test_Mezcladora);

      end 

// CLK cíclico 
always
    begin
        Clk = 1; #5;
        Clk = 0; #5;
    end 

// Aplicación de los vectores de prueba en el flanco inactivo del FF 
// (flanco decreciente)
always @ (negedge Clk)
    begin 
        {IN, P1, P2, TOK} = testvectors [vectornum];
        $display;
        $display("Las entradas son IN = %b, P1 = %b, P2 = %b, TOK = %b,", IN, P1, P2, TOK);
    end

// Cambio de estado en el flanco activo del FF (flanco creciente)
    always @ (posedge Clk)
    #1 if (!Reset)
        begin 
            $display ("SALIDAS V1 = %b, V2 = %b, V3 = %b, M = %b, B = %b, S = %b, T = %b "
            ,V1, V2, V3, M, B, S ,T );
            vectornum = vectornum + 1;
            if (vectornum == 15)
                $finish;
        end
    endmodule

