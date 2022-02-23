`include "hamming_window_rom.v"
module hamming_window #(
  parameter INPUTLENGTH=20
)(
    clk,
    rst_n,
    in,
    in_valid,
    out,
    out_valid,
    out_num
);
    // Definition of ports
    input  wire clk; 
    input  wire rst_n;
    input wire signed [INPUTLENGTH-1:0] in ;
    input  wire in_valid;
    output  signed [13+INPUTLENGTH-2:0] out;
    output  wire out_valid;
    output wire signed[14:0]out_num;
    // Definition of wire/reg 
    reg[9:0]counter;
    //----------stage0
    reg signed [INPUTLENGTH-1:0] in_0_r,in_0_w;
    reg in_valid_0_r,in_valid_0_w;
    //----------stage1
    //reg [11:0]ppl_in_nd[1];
    reg in_valid_1_r,in_valid_1_w;
    reg signed[13+INPUTLENGTH-2:0]mul_1_r,mul_1_w;
    //----------output stage
    reg out_valid_r,out_valid_w;
    reg signed[13+INPUTLENGTH-2:0]out,out_w;
    reg [14:0]counter_ex_r,counter_ex_w;
    reg state_count_r,state_count_w;
    reg state_r,state_w;
    wire [11:0]mem_out_0;
    wire signed [12:0]mem_out_ext;
    wire true_valid;
    reg [14:0]output_counter;
    assign mem_out_ext={1'b0,mem_out_0};
    assign out_num=output_counter;
    assign out_valid=out_valid_r||true_valid;
    assign true_valid=((counter_ex_r<=1022)&&(state_count_r==1));
    hamming_window_rom h0(
    .clk(clk),
    .rst_n(rst_n),
    .addr(counter),
    .in_valid(in_valid),
    .w(mem_out_0)
    );
    always @(*) begin
      counter_ex_w=(state_count_r)?counter_ex_r+1:counter_ex_r;
      
      if(state_count_r==1) begin
        state_count_w=1;
      end
      else begin
        state_count_w=((out_valid_r==1)&&(out_valid_w==0))?1:0;
      end
      
    end
    always @(*) begin
      if(state_r==1)begin
        state_w=1;
      end
      else begin
        state_w=(in_valid)?1:0;
      end
    end
    always @(*) begin
      case(state_r)
        0:begin
          if(in_valid)begin
            //stage0
            in_0_w=in;
            in_valid_0_w=in_valid;
            //stage1
            in_valid_1_w=in_valid_0_r;
            mul_1_w=$signed(in_0_r)*$signed(mem_out_ext);
            //stage3
            out_w=mul_1_r;
            out_valid_w=in_valid_1_r;
          end
          else begin
            //stage0
            in_0_w=0;
            in_valid_0_w=in_valid;
            //stage1
            in_valid_1_w=0;
            mul_1_w=0;
            //stage3
            out_w=0;
            out_valid_w=0;
          end
        end
        1:begin
          //stage0
          in_0_w=in;
          in_valid_0_w=in_valid;
          //stage1
          in_valid_1_w=in_valid_0_r;
          mul_1_w=$signed(in_0_r)*$signed(mem_out_ext);
          //stage3
          out_w=mul_1_r;
          out_valid_w=in_valid_1_r;
        end
      endcase
    end
    always @ (posedge clk)begin
      if(!rst_n) begin
        in_0_r<=0;
        in_valid_0_r<=0;
        in_valid_1_r<=0;
        mul_1_r<=0;
        out<=0;
        out_valid_r<=0;  
        state_r<=0;
        state_count_r<=0;
        counter<=0;
        output_counter<=0;
        counter_ex_r<=0;
      end
      else begin
        //$display(true_valid);
        counter<=counter+1;
        in_0_r<=in_0_w;
        in_valid_0_r<=in_valid_0_w;
        in_valid_1_r<=in_valid_1_w;
        mul_1_r<=mul_1_w;
        out<=out_w;
        out_valid_r<=out_valid_w;  
        state_r<=state_w;
        output_counter<=(in_valid_1_r)?output_counter+1:output_counter;
        counter_ex_r<=counter_ex_w;
        state_count_r<=state_count_w;
        // $display("mem_out_ext=%f",mem_out_ext/(4096.0));
        // $display("     in_0_r=%f",in_0_r/(((2**(20-2))*1.0)));
        // $display("    mul_1_w=%f",mul_1_w/(((2**(20-2+12))*1.0)));
        // $display("    mul_1_r=%f",mul_1_r/(((2**(20-2+12))*1.0)));
        // $display("      out_w=%f",out_w/(((2**(20-2+12))*1.0)));
        // $display("      out=%f",out/(((2**(20-2+12))*1.0)));
      end
    end
endmodule
