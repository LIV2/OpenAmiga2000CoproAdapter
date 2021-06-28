`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:21 05/23/2021 
// Design Name: 
// Module Name:    Boss2000 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Boss2000(
    // Coprocessor pins
    input c_E,
    input c_VMA,
    input c_RW,
    input c_LDS,
    input c_UDS,
    input c_AS,
    input c_FC0,
    input c_FC1,
    input c_FC2,
    input c_BG,
    output c_VPA,
    output c_BR,
    output c_BGACK,
    output c_RESET,
    output c_HALT,
    //
    // Amiga pins
    input a_E,
    output a_VMA,
    output a_RW,
    output a_LDS,
    output a_UDS,
    output a_FC0,
    output a_FC1,
    output a_FC2,
    inout a_BG,
    inout a_AS,
    inout a_BR,
    input a_BGACK,
    input a_RESET,
    input a_HALT,
    // Others
    input CLK,
    input VPA,
    output DTACK,
    input a_DTACK,
    output reg BOSSn
    );

reg BR;
reg intE;
reg VMA;
wire HARDRESET;
assign HARDRESET = !a_RESET & !a_HALT;

//assign c_VPA   = (BOSSn) ? 1'b1 : a_VPA;
//assign C_VPA = 1'b1;
assign c_BR    = (BOSSn) ? 1'bZ : a_BR;
assign c_BGACK = (BOSSn) ? 1'bZ : a_BGACK;
// Hold Copro in reset until we're the Boss
assign c_RESET = (BOSSn) ? 1'b0 : 1'bZ;
assign c_HALT  = (BOSSn) ? 1'b0 : 1'bZ;

assign a_AS  = (BOSSn | !a_BGACK) ? 1'bZ : c_AS;
assign a_BR  = (BOSSn | BR) ? !BR : 1'bZ;
assign a_VMA = (BOSSn | !a_BGACK) ? 1'bZ : (VMA) ? 1'bZ : 1'b0;
//assign a_VMA = c_VMA;
//assign c_VPA = VPA;
assign c_VPA = 1;
//assign a_E = 1'bZ;
assign a_RW  = (BOSSn | !a_BGACK) ? 1'bZ : c_RW;
assign a_LDS = (BOSSn | !a_BGACK) ? 1'bZ : c_LDS;
assign a_UDS = (BOSSn | !a_BGACK) ? 1'bZ : c_UDS;
assign a_FC0 = (BOSSn | !a_BGACK) ? 1'bZ : c_FC0;
assign a_FC1 = (BOSSn | !a_BGACK) ? 1'bZ : c_FC1;
assign a_FC2 = (BOSSn | !a_BGACK) ? 1'bZ : c_FC2;
assign a_BG  = (BOSSn) ? 1'bZ : c_BG;


reg [1:0] E_Sync;
reg E_Synced;

always @(posedge CLK or posedge HARDRESET)
begin
  if (HARDRESET) begin
    BOSSn <= 0;
    BR    <= 0;
  end else begin
    BR <= BOSSn;
    BOSSn <= BOSSn & (a_BG | !a_AS | !a_DTACK | !E_Synced);
  end
end


always @(posedge CLK or posedge HARDRESET) begin
  if (HARDRESET) begin
    E_Sync <= 2'b00;
  end else begin
    E_Sync <= {E_Sync[0], a_E};
  end
end
reg [3:0] E_Counter = 4'd0;

always @(posedge CLK or posedge HARDRESET) begin
  if (HARDRESET) begin
    E_Synced <= 0;
    E_Counter <= 0;
  end else if (E_Synced == 1'b0 & E_Sync == 2'b10) begin
    E_Counter <= 2;
    E_Synced <= 1;
  end else if (E_Synced) begin
    if (E_Counter == 4'd9) begin
      E_Counter <= 0;
    end else begin
      E_Counter <= E_Counter + 1;
    end
  end
end

always @(posedge CLK) begin
  if (E_Counter == 'd4)
    intE <= 1;
  else if (E_Counter == 'd8)
    intE <= 0;
end


reg vma_sync;
reg dtack_sync;

always @(posedge CLK or posedge VPA) begin
  if (VPA) begin
    VMA <= 1;
  end else begin
    if (E_Counter == 'd9) begin
      VMA <= 1;
    end
    if (E_Counter == 'd2) begin
      VMA <= VPA;
    end
  end
end

always @(posedge CLK or posedge c_AS) begin
  if (c_AS) begin
    dtack_sync <= 1;
  end else begin
    if (E_Counter == 'd9) begin
      dtack_sync <= 1;
    end
    if (E_Counter == 'd8) begin
      dtack_sync <= VMA;
    end
  end
end

assign DTACK = (BOSSn) ? 1'b1 : (dtack_sync) ? a_DTACK : 1'b0;

//assign DTACK = a_DTACK;
endmodule
