/* ======================================================================
Estudiante: Marvin Castro Castro, C01884
Circuitos Digitales I IE0323
Entrega: 09/12/22
Módulo Mezcladora 
==========================================================================*/


module Mezcladora (input Clk, Reset,
                   input IN, P1, P2, TOK,
                   output V1, V2, V3, M, B, S ,T);


reg [6:0] EstPres, ProxEstado;


// Asignación de estados
parameter a = 4'b1000;          //10
parameter b = 4'b1100;          //14
parameter c = 4'b1110;          //16

parameter d = 4'b1111;          //17
parameter e = 4'b0111;          //7
parameter f = 4'b0011;          //3

parameter g = 4'b0001;          //01
parameter h = 4'b0000;          //00
parameter i = 4'b0100;          //4

parameter j = 4'b0010;          //2

// Memoria de estados
always @(posedge Clk, posedge Reset)
    if (Reset) EstPres <= a;
    else       EstPres <= ProxEstado;


// Lógica de cálculo de próximos estados
always @(*)
    case (EstPres)
    a   : if (IN)  ProxEstado = b;
          else     ProxEstado = a;
    b   : case({P1, P2})
            2'b00 : ProxEstado = b;
            2'b01 : ProxEstado = c;
            2'b10 : ProxEstado = e;
            2'b11 : ProxEstado = d;

    endcase
    c   : if (P1)  ProxEstado = d;
          else     ProxEstado = c;
    d   :          ProxEstado = g;
    e   :          ProxEstado = f;
    f   : if (P2)  ProxEstado = g;
          else     ProxEstado = f;
    g   : if (TOK) ProxEstado = h;
          else     ProxEstado = g;
    h   :          ProxEstado = i;
    i   : if (TOK) ProxEstado = j;
          else     ProxEstado = i;
    j   : case({P1, P2})
            2'b00 : ProxEstado = a;
            2'b10 : ProxEstado = j;
            2'b01 : ProxEstado = j;
            2'b11 : ProxEstado = j;
          endcase

endcase
    
// Lógica de cálculo de salidas
assign V1 = (EstPres == b | EstPres == c);

assign V2 = (EstPres == b | EstPres == e | EstPres == f);

assign V3 = (TOK & EstPres == g | EstPres == h | EstPres == i);

assign M = (EstPres == d | EstPres == e | EstPres == f| EstPres == g| EstPres == h | EstPres == i);

// Inclusión del Clk activo, para que la salida S se active en medio ciclo activo de Clk
assign S = (Clk & EstPres == d| Clk & EstPres == e |Clk &  EstPres == h);

assign T = (EstPres == h  | EstPres == i );

assign B = (EstPres == j);


endmodule