`timescale 1ns/10ps
module pre_emphasis#
    (
      parameter   OUTPUT_WDTH = 12
    )
    (
    //input
        clk,
        rst_n,
        in,
        in_valid,
        out,
        out_valid,
        out_num,//
        out_state//
    );
    // Definition of ports
      input  clk; 
      input  rst_n;
      input signed [15:0] in ;
      input  in_valid;
      output signed [OUTPUT_WDTH-1:0] out;
      output out_valid;
      output [14:0]out_num;
      output [1:0]out_state;
    // Definition of wire/reg 
      reg signed [15:0] input_r[1:0];
      reg signed [15:0] input_w[1:0];
      reg valid_r[0:0],valid_w[0:0];
      wire signed [20:0] input_17;
      wire signed [20:0] out_exp;
      reg [1:0]state_r,state_w;
      reg [14:0]counter;

      assign out_state=state_r;
      assign out_num=counter;
      assign input_17=input_r[0]*17;
      assign out_exp=(input_17-input_r[1]*16);
      assign out={out_exp[20:20-OUTPUT_WDTH+1]};
      assign out_valid=valid_r[0];
      always @(*) begin
        input_w[0]=(in_valid)?in:0;
        valid_w[0]=in_valid;
        input_w[1]=input_r[0];
        case(state_r)
          0:begin
            state_w=(in_valid)?1:0;
          end
          1:begin
            if(counter==15872)begin
              input_w[0]=0;
              valid_w[0]=0;
              input_w[1]=0;
              state_w=3;
            end
            else begin
              state_w=(in_valid)?1:2;
            end
          end
          2:begin
            if(counter==15872)begin
              input_w[0]=0;
              valid_w[0]=0;
              input_w[1]=0;
              state_w=3;
            end
            else begin
              state_w=(in_valid)?1:2;
            end
            input_w[1]<=input_r[1];
          end
          3:begin
            input_w[0]=0;
            valid_w[0]=0;
            input_w[1]=0;
            state_w=3;
          end
        endcase
      end
      always @ (posedge clk or negedge rst_n)begin
        if(!rst_n) begin
          input_r[0]<=0;
          input_r[1]<=0;
          valid_r[0]<=0;
          state_r<=0;
          counter<=0;
        end
        else begin
          counter<=(in_valid)?counter+1:counter;
          state_r<=state_w;
          //stage0
          input_r[0]<=input_w[0];
          valid_r[0]<=valid_w[0];
          //$display("At %5d NS , The valid_r[0], %f,",$time,valid_r[0]);
          //stage1
          input_r[1]<=input_w[1];
          // $display("----------------------------------------------------");
          // $display("At %5dns , \nThe input_r[0], %f,",$time,input_r[0]/(32768.0));
          // $display("The valid_r[0], %f,",valid_r[0]);
          // $display("The input_r[1], %f,",input_r[1]/(32768.0));
          // $display("The input_17, %f,",input_17/(32768.0));
          // $display("The out_exp, %f,",out_exp/(32768.0));
          // $display("The out, %f,",out/((2**(OUTPUT_WDTH-2))*1.0));
          // $display("----------------------------------------------------");
          // $display("The OUTPUT_WDTH, %d,",OUTPUT_WDTH);
        end
      end
endmodule
