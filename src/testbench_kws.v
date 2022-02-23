`timescale 1ns/10ps

`define CYCLE 10
`define ENDCYCLE  45000
`define INFILE "indata1.dat"
`include "kws.v"


module testfixtrue();
initial $readmemb(`INFILE, indata_mem);
reg [15:0] indata_mem [ 0:16000];
parameter pre_width=20;
parameter HAMING_OUT_WITH=32;
reg clk = 1;
reg rst = 0;
reg in_nd=0;
reg signed [15:0] in=0;
wire signed[pre_width-1:0] out_fra;
wire signed[pre_width-1:0] out_pre;
wire signed[13+pre_width-2:0] out_ham;
wire out_nd;
wire valid_pre;
wire valid_fra;
wire valid_ham;
wire valid_fft;
wire valid_mel;
wire valid_dnn;
reg [31:0]x=0;
wire [14:0]pre_out_num;
wire [14:0]fram_out_num;
wire [14:0]ham_out_num;
wire [4:0]mel_out_num;
//wire [879:0] mel_out;
//wire [69:0] mel_out;
wire [47*10-1:0] mel_out;
wire [3:0]dnn_out;
wire [1:0]pre_state;
wire [2:0]fra_state;
wire [10:0]meta;
reg [10:0]y=0;
wire signed[39:0] re_out;
wire signed[39:0] im_out;
reg signed [31:0]  im=0;
wire [9:0]fft_out_num;
integer out_num=1;
integer i;
kws dut(
    .clk(clk),
    .rst(rst),
    .in(in),
    .in_valid(in_nd),
    .out(dnn_out),
    .out_valid(valid_dnn)
);
// pre_emphasis #(
//    .OUTPUT_WDTH(pre_width)
//   ) 
//   DUT
//   (
//     .clk(clk),
//     .rst_n(rst),
//     .in(in),
//     .in_valid(in_nd),
//     .out(out_pre),
//     .out_valid(valid_pre),
//     .out_num(pre_out_num),
//     .out_state(pre_state)
//   );
// framing #(
//   .INPUT_LENGTH(pre_width)
// )
// frame(
//   .clk(clk),
//   .rst_n(rst),
//   .in(out_pre),
//   .in_valid(valid_pre),
//   .out(out_fra),
//   .out_valid(valid_fra),
//   .out_num(fram_out_num),
//   .out_state(fra_state)
// );
// hamming_window #(
//    .INPUTLENGTH(20)
// )ham(
//     .clk(clk),
//     .rst_n(rst),
//     .in(out_fra),
//     .in_valid(valid_fra),
//     .out(out_ham),
//     .out_valid(valid_ham),
//     .out_num(ham_out_num)
// );
// fft_r22sdf #(
//     .N_LOG2(10),
//     .TF_WDTH(10),
//     .DIN_WDTH(32),
//     .META_WDTH(11),
//     .DOUT_WDTH(40) 

// )
// fft(
//     .clk(clk),
//     .rst_n(rst),
//     .din_meta(y),
//     .dout_meta(meta),
//     .din_re(out_ham),
//     .din_im(im),
//     .din_nd(valid_ham),
//     .dout_re(re_out),
//     .dout_im(im_out),
//     .dout_nd(valid_fft),
//     .out_num(fft_out_num)
// );
// mel mel_filter(  
//     .clk(clk),
//     .rst_n(rst),
//     .in_re(re_out),
//     .in_im(im_out),
//     .in_valid(valid_fft),
//     .in_num(fft_out_num),
//     .out(mel_out),
//     .out_valid(valid_mel),
//     .out_num(mel_out_num)
// );
// dnn DNN(
//     .clk(clk),
//     .rst_n(rst),
//     .in_valid(valid_mel),
//     .in(mel_out),
//     .out(dnn_out),
//     .out_valid(valid_dnn)
// );
initial begin
   `ifdef SDFSYN
     $sdf_annotate("kws.sdf", DUT);
   `endif
   `ifdef SDFAPR
     $sdf_annotate("kws.sdf", DUT);
   `endif	 	 
   `ifdef FSDB
     $fsdbDumpfile("kws.fsdb");
     $fsdbDumpvars(0,testfixtru"+mda");
   `endif
   `ifdef VCD
     $dumpfile("kws.vcd");
	 $dumpvars();
   `endif
end
always #(`CYCLE/2) clk = ~clk;
initial begin
  rst=1;
  #20 rst=0;
  #10 rst=1;
end
initial begin
  // rst=0;
  // #15 rst=1;
  // #10 ;
  #25;
  for(i=0;i<=16031;i=i+1)begin
    if((i!=0)&&(i%513==512))begin
      #(`CYCLE);
      in =0;
      in_nd=0;
      #(511*`CYCLE);
      // $display("t:%d in:%f",$time,in/32768.0);
      // $display("indata_mem %b",indata_mem[x]);
      // $display("x=%d",x);
    end
    else begin
      #(`CYCLE);
      in = indata_mem[x];
      in_nd=1;
      // $display("t:%d in:%f",$time,in/32768.0);
      // $display("indata_mem %b",indata_mem[x]);
      // $display("x=%d",x);
      x=x+1;
    end
  end   
  in_nd=0;
  in=0;
  #50000;
  #25 rst=0;
  #10 rst=1;
  x=0;
  for(i=0;i<=16031;i=i+1)begin
    if((i!=0)&&(i%513==512))begin
      #(`CYCLE);
      in =0;
      in_nd=0;
      #(511*`CYCLE);
      // $display("t:%d in:%f",$time,in/32768.0);
      // $display("indata_mem %b",indata_mem[x]);
      // $display("x=%d",x);
    end
    else begin
      if(i==0)begin
        #(`CYCLE*0.5);
      end
      else begin
        #(`CYCLE);
      end
      in = indata_mem[x];
      in_nd=1;
      // $display("t:%d in:%f",$time,in/32768.0);
      // $display("indata_mem %b",indata_mem[x]);
      // $display("x=%d",x);
      x=x+1;
    end
  end   
end

always@(negedge clk)begin
 if(valid_dnn)begin
   case(dnn_out)
    1:$display("The prediction from ncverilog is silence"); 
    2:$display("The prediction from ncverilog is unknown"); 
    3:$display("The prediction from ncverilog is yes"); 
    4:$display("The prediction from ncverilog is no"); 
    5:$display("The prediction from ncverilog is up"); 
    6:$display("The prediction from ncverilog is down"); 
    7:$display("The prediction from ncverilog is left"); 
    8:$display("The prediction from ncverilog is right"); 
    9:$display("The prediction from ncverilog is on"); 
    10:$display("The prediction from ncverilog is off"); 
    11:$display("The prediction from ncverilog is stop",); 
    12:$display("The prediction from ncverilog is go",); 
    default:$display("");
   endcase
 end
end

initial begin
  #(`CYCLE*`ENDCYCLE);
  $display(" =================== TIME OUT ======================\n");
  $display("           If you need more simulation time         ");
  $display("  You can try to modify ENDCYCLE in the testfixture.\n");
  $display(" =================== TIME OUT ======================\n");
  
  $finish;
end

endmodule
