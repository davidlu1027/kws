`include "pre_emphasis.v"
`include "framing.v"
`include "fft_r22sdf.v"
`include "mel.v"
`include "dnn.v"
module kws (
    input clk,
    input rst,
    input signed [15:0]in,
    input in_valid,
    output [3:0]out,
    output out_valid
);
parameter pre_width=20;
parameter HAMING_OUT_WITH=32;
wire signed[pre_width-1:0] out_fra;
wire signed[pre_width-1:0] out_pre;
wire signed[13+pre_width-2:0] out_ham;
wire valid_pre;
wire valid_fra;
wire valid_ham;
wire valid_fft;
wire valid_mel;
wire valid_dnn;
wire [10:0]meta;
wire [14:0]pre_out_num;
wire [14:0]fram_out_num;
wire [14:0]ham_out_num;
wire [4:0]mel_out_num;
wire [10:0]zero;
//wire [879:0] mel_out;
//wire [69:0] mel_out;
wire [47*10-1:0] mel_out;
wire [3:0]dnn_out;
wire [1:0]pre_state;
wire [2:0]fra_state;
wire signed[39:0] re_out;
wire signed[39:0] im_out;
wire signed [31:0]  im;
wire [9:0]fft_out_num;
assign zero=0;
assign im=0;
assign out=dnn_out;
assign out_valid=valid_dnn;
pre_emphasis #(
   .OUTPUT_WDTH(pre_width)
  ) 
  DUT
  (
    .clk(clk),
    .rst_n(rst),
    .in(in),
    .in_valid(in_valid),
    .out(out_pre),
    .out_valid(valid_pre),
    .out_num(pre_out_num),
    .out_state(pre_state)
  );
framing #(
  .INPUT_LENGTH(pre_width)
)
frame(
  .clk(clk),
  .rst_n(rst),
  .in(out_pre),
  .in_valid(valid_pre),
  .out(out_fra),
  .out_valid(valid_fra),
  .out_num(fram_out_num),
  .out_state(fra_state)
);
hamming_window #(
   .INPUTLENGTH(20)
)ham(
    .clk(clk),
    .rst_n(rst),
    .in(out_fra),
    .in_valid(valid_fra),
    .out(out_ham),
    .out_valid(valid_ham),
    .out_num(ham_out_num)
);
fft_r22sdf #(
    .N_LOG2(10),
    .TF_WDTH(10),
    .DIN_WDTH(32),
    .META_WDTH(11),
    .DOUT_WDTH(40) 

)
fft(
    .clk(clk),
    .rst_n(rst),
    .din_meta(zero),
    .dout_meta(meta),
    .din_re(out_ham),
    .din_im(im),
    .din_nd(valid_ham),
    .dout_re(re_out),
    .dout_im(im_out),
    .dout_nd(valid_fft),
    .out_num(fft_out_num)
);
mel mel_filter(  
    .clk(clk),
    .rst_n(rst),
    .in_re(re_out),
    .in_im(im_out),
    .in_valid(valid_fft),
    .in_num(fft_out_num),
    .out(mel_out),
    .out_valid(valid_mel),
    .out_num(mel_out_num)
);
dnn DNN(
    .clk(clk),
    .rst_n(rst),
    .in_valid(valid_mel),
    .in(mel_out),
    .out(dnn_out),
    .out_valid(valid_dnn)
);
endmodule