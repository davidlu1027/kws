module bias_rom (
    input  wire        [ 3:0] addr,
    input  wire               in_valid,
    input  wire               clk,
    output reg signed [ 287:0] w
  );

reg [287:0] dout [0:12];


initial begin
dout[0]={ -8'd16,8'd38,-8'd25,-8'd59,8'd20,-8'd11,8'd6,-8'd14,-8'd3,8'd14,8'd29,-8'd11,8'd30,8'd138,-8'd11,8'd11,8'd97,-8'd22,8'd6,-8'd4,8'd9,-8'd10,-8'd9,8'd76,8'd7,-8'd5,-8'd9,8'd2,8'd20,8'd14,8'd10,8'd19,8'd24,8'd31,8'd54,8'd50};
dout[1]={ -8'd55,8'd97,-8'd21,8'd40,8'd76,8'd72,8'd27,8'd0,-8'd1,8'd30,8'd38,-8'd17,8'd15,-8'd34,8'd33,8'd7,8'd1,-8'd38,8'd54,8'd96,-8'd16,-8'd2,8'd31,8'd98,-8'd13,-8'd17,-8'd12,8'd96,8'd3,8'd50,-8'd7,-8'd13,8'd33,-8'd3,-8'd19,-8'd24};
dout[2]={ 8'd15,8'd25,8'd2,-8'd5,8'd44,-8'd7,8'd6,8'd42,8'd14,8'd14,-8'd11,8'd57,8'd1,8'd1,-8'd35,-8'd16,8'd29,-8'd12,-8'd60,8'd69,8'd40,8'd1,8'd12,-8'd58,-8'd6,8'd82,-8'd27,-8'd14,8'd0,-8'd2,8'd19,8'd3,-8'd5,8'd36,8'd18,8'd5};
dout[3]={ 8'd0,8'd57,-8'd80,8'd16,-8'd39,8'd68,8'd2,8'd16,8'd21,8'd22,8'd25,8'd17,8'd18,8'd3,-8'd9,8'd90,8'd36,-8'd20,8'd34,8'd66,8'd48,-8'd5,8'd69,-8'd56,-8'd11,8'd20,8'd32,8'd36,8'd6,8'd4,8'd67,8'd16,-8'd17,-8'd24,8'd0,8'd13};
dout[4]={ 8'd26,8'd165,8'd6,8'd13,8'd11,-8'd11,8'd65,8'd20,8'd88,-8'd21,8'd19,8'd27,-8'd20,-8'd65,-8'd7,8'd43,8'd20,-8'd37,8'd0,8'd2,8'd109,-8'd5,-8'd6,-8'd67,8'd115,8'd41,8'd35,-8'd4,8'd39,8'd7,8'd143,8'd39,8'd133,-8'd6,8'd1,8'd22};
dout[5]={ -8'd22,8'd32,-8'd13,8'd36,-8'd47,-8'd2,-8'd7,-8'd51,8'd118,8'd44,8'd43,8'd56,8'd3,8'd6,8'd26,8'd1,-8'd8,8'd11,8'd83,-8'd79,-8'd15,-8'd2,-8'd2,-8'd30,8'd21,-8'd53,8'd65,8'd88,8'd72,8'd40,8'd28,8'd62,8'd16,8'd27,-8'd10,-8'd59};
dout[6]={ 8'd16,-8'd14,8'd0,-8'd65,-8'd49,8'd71,-8'd9,8'd3,8'd45,8'd73,8'd133,8'd12,8'd17,-8'd19,8'd41,-8'd10,8'd51,8'd46,-8'd23,8'd31,8'd49,8'd12,8'd23,8'd149,8'd25,8'd105,8'd55,8'd35,8'd94,8'd70,-8'd33,8'd26,-8'd45,-8'd27,8'd24,-8'd33};
dout[7]={ -8'd23,8'd133,-8'd23,8'd108,8'd58,-8'd28,8'd2,8'd6,8'd30,8'd30,8'd63,8'd99,-8'd29,8'd27,8'd38,-8'd2,8'd93,8'd107,8'd129,8'd35,8'd0,-8'd8,-8'd17,-8'd36,8'd101,8'd53,8'd18,8'd7,8'd20,8'd41,8'd127,8'd37,-8'd4,8'd2,8'd35,8'd5};
dout[8]={ 8'd37,-8'd14,-8'd11,8'd14,8'd17,8'd31,8'd68,-8'd6,8'd72,8'd60,8'd29,8'd166,8'd115,-8'd28,8'd87,-8'd10,-8'd14,8'd23,8'd17,-8'd9,-8'd16,8'd50,8'd31,8'd75,8'd133,8'd20,8'd28,-8'd21,8'd40,8'd59,8'd22,8'd77,8'd1,8'd103,8'd65,8'd148};
dout[9]={ 8'd6,8'd35,8'd18,8'd12,-8'd12,-8'd23,-8'd10,8'd104,8'd122,-8'd23,8'd94,8'd42,-8'd10,-8'd30,8'd79,8'd30,8'd64,8'd78,8'd34,8'd52,8'd76,8'd19,8'd10,-8'd12,8'd115,-8'd5,8'd48,8'd32,8'd10,8'd88,8'd29,-8'd15,8'd42,8'd44,8'd109,8'd154};
dout[10]={ 8'd111,8'd80,-8'd21,8'd121,-8'd15,8'd79,8'd63,8'd89,8'd41,-8'd10,8'd45,-8'd37,8'd49,-8'd8,8'd42,8'd34,8'd58,-8'd53,8'd23,8'd2,8'd12,8'd73,-8'd18,8'd95,8'd0,8'd39,8'd17,8'd55,-8'd16,8'd43,8'd24,8'd46,8'd20,8'd37,8'd45,8'd106};
dout[11]={ 8'd46,8'd114,8'd79,-8'd4,8'd96,8'd58,8'd91,8'd18,8'd0,-8'd7,-8'd16,8'd20,8'd1,-8'd21,8'd25,-8'd23,8'd83,-8'd15,8'd23,8'd57,8'd52,-8'd8,8'd18,8'd103,8'd38,8'd43,8'd55,8'd3,8'd65,-8'd10,8'd45,8'd37,8'd137,8'd66,8'd6,8'd97};
dout[12]={ 8'd85,-8'd27,-8'd14,8'd50,-8'd9,8'd11,8'd3,-8'd14,8'd15,-8'd68,-8'd77,8'd4,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0,-8'd0};
end

always @ (posedge clk) begin
  w <= dout[addr];
end


endmodule

/** @} */ /* End of addtogroup ModMiscIpDspFftR22Sdc */
/* END OF FILE */