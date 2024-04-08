module cegen_v2 (
  input        CLK,
  input        RST_N,
  input [27:0] IN_CLK,   // 28 bits deberian ser suficientes para que
  input [27:0] OUT_CLK,  // el oscilador por fase-acumulacion no desborde
  output reg   CE
  );
  
  reg [27:0] CLK_SUM = 'b0;
  initial CE = 1'b0;

  wire [27:0] CLK_DIF = CLK_SUM + OUT_CLK + ~IN_CLK + 28'b1;  // CLK_DIF = CLK_SUM + OUT_CLK - IN_CLK
  
  always @(posedge CLK) begin
    if (RST_N == 1'b0) begin
      CLK_SUM <= 'b0;
      CE <= 1'b0;
    end
    else begin
      CE <= 1'b0;
      CLK_SUM <= CLK_SUM + OUT_CLK;
      if (CLK_DIF[27] == 1'b0) begin
        CLK_SUM <= CLK_DIF;
        CE <= 1'b1;
      end
    end
  end
endmodule
