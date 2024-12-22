`include "types.sv"
`default_nettype none
module core (
  input logic clk,
  input logic reset
);

  logic [1:0] pcWrSel;
  logic pcCtrl;
  logic memAdrSel, memWrCtl;
  logic [`ALU_SEL_SIZE-1:0] aluOp; 
  logic aluASel;
  logic [1:0] aluBSel;
  logic regWCtl, regDataSel;
  logic [1:0] regWSel;
  logic [`OPCODE_WIDTH - 1:0] codop;

  controlUnit control_unit (
    .clk(clk),
    .reset(reset),
    .pcWrSel(pcWrSel),
    .pcCtrl(pcCtrl),
    .memAdrSel(memAdrSel),
    .memWrCtl(memWrCtl),
    .aluOp(aluOp),
    .aluASel(aluASel),
    .aluBSel(aluBSel),
    .regWCtl(regWCtl),
    .regDataSel(regDataSel),
    .regWSel(regWSel),
    .codop(codop)
  );

  datapath data_path (
    .clk(clk),
    .pcWrSel(pcWrSel),
    .pcCtrl(pcCtrl),
    .memAdrSel(memAdrSel),
    .memWrCtl(memWrCtl),
    .aluOp(aluOp),
    .aluASel(aluASel),
    .aluBSel(aluBSel),
    .regWCtl(regWCtl),
    .regDataSel(regDataSel),
    .regWSel(regWSel),
    .codop(codop)
  );

endmodule
