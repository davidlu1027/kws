`default_nettype wire
`include "mel_rom.v"
module mel(  
    clk,
    rst_n,
    in_re,
    in_im,
    in_valid,
    in_num,
    out,
    out_valid,
    out_num
);
    // Definition of ports
    input  wire clk; 
    input  wire rst_n;
    input  wire signed [39:0] in_re ;
    input  wire signed [39:0] in_im ;
    input  wire in_valid;
    input wire [9:0]in_num;
    output wire out_valid;
    //output wire [879:0] out;/////////////////////////////////////////
    output wire [47*10-1:0] out;/////////////////////////////////////////
    output wire [4:0]out_num;

    integer i;
    integer count=0;
    // Definition of wire/reg 
    reg signed[39:0] abs_r,abs_w;//40+40+1
    reg first_in_r,first_in_w;
    reg last_in_r,last_in_w;
    reg [46:0]acum_r[9:0];//7 bits more than ans
    reg [46:0]acum_w[9:0];//
    reg valid_r,valid_w;
    reg out_valid_r,out_valid_w;
    reg state_r,state_w;
    reg [4:0]counter_r,counter_w;
    wire [39:0]rom_out;
    wire [3:0]addr1,addr2;
    wire [15:0]mul1,mul2;
    wire [39:0]ans1,ans2;
    wire [55:0]pre_ans1;
    wire [55:0]pre_ans2;
    //wire [6:0] out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_0;
    wire [39:0] sqrt_out;
    assign addr1=rom_out[39:36];
    assign addr2=rom_out[35:32];
    assign mul1=rom_out[31:16];
    assign mul2=rom_out[15:0];
    assign ans1=pre_ans1>>16;
    assign ans2=pre_ans2>>16;
    assign pre_ans1=abs_r*mul1;
    assign pre_ans2=abs_r*mul2;
    assign out_valid=out_valid_r;
    assign out={acum_r[9],acum_r[8],acum_r[7],acum_r[6],acum_r[5],acum_r[4],acum_r[3],acum_r[2],acum_r[1],acum_r[0]};
    //assign out={out_9,out_8,out_7,out_6,out_5,out_4,out_3,out_2,out_1,out_0};
    assign out_num=counter_r;
    sqrt #(
       .DATA_IN_WIDTH(40)
      ) 
      s0
      (
        .clk(clk),
        .x1(in_re),
        .x2(in_im),
        .y(sqrt_out)
      );    
    // log c0(
    //   .in(acum_r[0]),
    //   .out(out_0)
    //   );
    // log c1(
    //   .in(acum_r[1]),
    //   .out(out_1)
    //   );
    // log c2(
    //   .in(acum_r[2]),
    //   .out(out_2)
    //   );
    // log c3(
    //   .in(acum_r[3]),
    //   .out(out_3)
    //   );
    // log c4(
    //   .in(acum_r[4]),
    //   .out(out_4)
    //   );
    // log c5(
    //   .in(acum_r[5]),
    //   .out(out_5)
    //   );
    // log c6(
    //   .in(acum_r[6]),
    //   .out(out_6)
    //   );
    // log c7(
    //   .in(acum_r[7]),
    //   .out(out_7)
    //   );
    // log c8(
    //   .in(acum_r[8]),
    //   .out(out_8)
    //   );
    // log c9(
    //   .in(acum_r[9]),
    //   .out(out_9)
    //   );
    mel_rom m0(
      .clk(clk),
      .rst_n(rst_n),
      .in_nd(in_valid),
      .addr(in_num),
      .w(rom_out)//41~37 filter1 36~32 filter2 31~16 filter1_mul 15~0 filter2_mul
    );
    //-------------------------------------------------------abs_w first_in_w last_in_w valid_w counter_w
    always @(*) begin
      
      if(out_valid_w)begin
        counter_w=counter_r+1;
      end
      else begin
        counter_w=counter_r;
      end
      case(state_r)
        0:state_w=(in_valid)?1:0;
        1:state_w=1;
      endcase
      if(state_r)begin
        //if(in_valid)begin
          //abs_w=in_re*in_re+in_im*in_im;
          abs_w=sqrt_out;
          first_in_w=((in_num==0)&&(in_valid))?1:0;
          last_in_w=((in_num==1023)&&(in_valid))?1:0;
          valid_w=in_valid;
          out_valid_w=last_in_r;
        // end
        // else begin
        //   abs_w=0;
        //   first_in_w=0;
        //   last_in_w=0;
        //   valid_w=0;
        //   out_valid_w=0;
        // end
      end
      else begin
        if(in_valid)begin
          abs_w=sqrt_out;
          //abs_w=in_re*in_re+in_im*in_im;
          // $display("      in_re=%d",in_re);
          // $display("      in_im=%d",in_im);
          // $display("      abs_w=%d",abs_w);
          first_in_w=((in_num==0)&&(in_valid))?1:0;
          last_in_w=((in_num==1023)&&(in_valid))?1:0;
          valid_w=in_valid;
          out_valid_w=last_in_r;
        end
        else begin
          abs_w=0;
          first_in_w=0;
          last_in_w=0;
          valid_w=0;
          out_valid_w=0;
        end
        
      end
      
    end
    //--------------------------------------------------acum_w
    always @(*) begin
      for(i=0;i<=10;i=i+1)begin
        if(valid_r==0)begin
          acum_w[i]=0;
        end
        else begin
          if(first_in_r)begin
            if((i+1)==addr1)begin
              acum_w[i]=ans1;
            end
            else if((i+1)==addr2)begin
              acum_w[i]=ans2;
            end
            else begin
              acum_w[i]=0;
            end
          end
          else begin
            if((i+1)==addr1)begin
              acum_w[i]=ans1+acum_r[i];
            end
            else if((i+1)==addr2)begin
              acum_w[i]=ans2+acum_r[i];
            end
            else begin
              acum_w[i]=acum_r[i];
            end
          end
        end       
      end
    end
    
    always @ (posedge clk or negedge rst_n)begin
      count<=count+1;
      if(!rst_n) begin//
        abs_r<=0;
        first_in_r<=0;
        last_in_r<=0;
        valid_r<=0;
        out_valid_r<=0;
        for(i=0;i<=10;i=i+1)begin
          acum_r[i]<=0;
        end
        state_r<=0;
        counter_r<=0;
      end
      else begin      
        abs_r<=abs_w;
        first_in_r<=first_in_w;
        last_in_r<=last_in_w;
        valid_r<=valid_w;
        out_valid_r<=out_valid_w;
        for(i=0;i<=10;i=i+1)begin
          acum_r[i]<=acum_w[i];
        end
        state_r<=state_w;
        counter_r<=counter_w;
        // $display("      in_re=%d",in_re);
        // $display("      in_im=%d",in_im);
        // $display("      abs_w=%d",abs_w);
        // $display("      sqrt_out=%d",sqrt_out);
        //$display("      in_re=%f",in_re/((2**(pre_width-2+12))*1.0));
        //$display("      in_im=%f",in_im/((2**(pre_width-2+12))*1.0));
        //$display("      abs_r=%f",abs_r/((2**(2*pre_width-4+24))*1.0));
        // if((count>=2081)&&(count<=2093))begin
        // $display("count=%d",count);
        // $display("ans1=abs_r*mul1>>>16");
        // $display("abs_r=abs_r/2^60");
        // $display("mul1=mul1/2^16");
        // $display("ans1=ans1/2^60");        
        // $display("      abs_r=%d",abs_r);
        // $display("      mul1=%d",mul1);
        // $display("      ans1=  %d",ans1);
        // $display("      in_num=  %d",in_num);
        // end
      end
    end
endmodule

// module log(in,out);

// 	input wire[87:0]  in;
// 	output reg[6:0]  out;

  
// 	always @(*) begin
//     if (in[ 87 ]==1) begin
//      out= 88 ;
//     end
//     else if (in[ 86 ]==1) begin
//      out= 87 ;
//     end
//     else if (in[ 85 ]==1) begin
//      out= 86 ;
//     end
//     else if (in[ 84 ]==1) begin
//      out= 85 ;
//     end
//     else if (in[ 83 ]==1) begin
//      out= 84 ;
//     end
//     else if (in[ 82 ]==1) begin
//      out= 83 ;
//     end
//     else if (in[ 81 ]==1) begin
//      out= 82 ;
//     end
//     else if (in[ 80 ]==1) begin
//      out= 81 ;
//     end
//     else if (in[ 79 ]==1) begin
//      out= 80 ;
//     end
//     else if (in[ 78 ]==1) begin
//      out= 79 ;
//     end
//     else if (in[ 77 ]==1) begin
//      out= 78 ;
//     end
//     else if (in[ 76 ]==1) begin
//      out= 77 ;
//     end
//     else if (in[ 75 ]==1) begin
//      out= 76 ;
//     end
//     else if (in[ 74 ]==1) begin
//      out= 75 ;
//     end
//     else if (in[ 73 ]==1) begin
//      out= 74 ;
//     end
//     else if (in[ 72 ]==1) begin
//      out= 73 ;
//     end
//     else if (in[ 71 ]==1) begin
//      out= 72 ;
//     end
//     else if (in[ 70 ]==1) begin
//      out= 71 ;
//     end
//     else if (in[ 69 ]==1) begin
//      out= 70 ;
//     end
//     else if (in[ 68 ]==1) begin
//      out= 69 ;
//     end
//     else if (in[ 67 ]==1) begin
//      out= 68 ;
//     end
//     else if (in[ 66 ]==1) begin
//      out= 67 ;
//     end
//     else if (in[ 65 ]==1) begin
//      out= 66 ;
//     end
//     else if (in[ 64 ]==1) begin
//      out= 65 ;
//     end
//     else if (in[ 63 ]==1) begin
//      out= 64 ;
//     end
//     else if (in[ 62 ]==1) begin
//      out= 63 ;
//     end
//     else if (in[ 61 ]==1) begin
//      out= 62 ;
//     end
//     else if (in[ 60 ]==1) begin
//      out= 61 ;
//     end
//     else if (in[ 59 ]==1) begin
//      out= 60 ;
//     end
//     else if (in[ 58 ]==1) begin
//      out= 59 ;
//     end
//     else if (in[ 57 ]==1) begin
//      out= 58 ;
//     end
//     else if (in[ 56 ]==1) begin
//      out= 57 ;
//     end
//     else if (in[ 55 ]==1) begin
//      out= 56 ;
//     end
//     else if (in[ 54 ]==1) begin
//      out= 55 ;
//     end
//     else if (in[ 53 ]==1) begin
//      out= 54 ;
//     end
//     else if (in[ 52 ]==1) begin
//      out= 53 ;
//     end
//     else if (in[ 51 ]==1) begin
//      out= 52 ;
//     end
//     else if (in[ 50 ]==1) begin
//      out= 51 ;
//     end
//     else if (in[ 49 ]==1) begin
//      out= 50 ;
//     end
//     else if (in[ 48 ]==1) begin
//      out= 49 ;
//     end
//     else if (in[ 47 ]==1) begin
//      out= 48 ;
//     end
//     else if (in[ 46 ]==1) begin
//      out= 47 ;
//     end
//     else if (in[ 45 ]==1) begin
//      out= 46 ;
//     end
//     else if (in[ 44 ]==1) begin
//      out= 45 ;
//     end
//     else if (in[ 43 ]==1) begin
//      out= 44 ;
//     end
//     else if (in[ 42 ]==1) begin
//      out= 43 ;
//     end
//     else if (in[ 41 ]==1) begin
//      out= 42 ;
//     end
//     else if (in[ 40 ]==1) begin
//      out= 41 ;
//     end
//     else if (in[ 39 ]==1) begin
//      out= 40 ;
//     end
//     else if (in[ 38 ]==1) begin
//      out= 39 ;
//     end
//     else if (in[ 37 ]==1) begin
//      out= 38 ;
//     end
//     else if (in[ 36 ]==1) begin
//      out= 37 ;
//     end
//     else if (in[ 35 ]==1) begin
//      out= 36 ;
//     end
//     else if (in[ 34 ]==1) begin
//      out= 35 ;
//     end
//     else if (in[ 33 ]==1) begin
//      out= 34 ;
//     end
//     else if (in[ 32 ]==1) begin
//      out= 33 ;
//     end
//     else if (in[ 31 ]==1) begin
//      out= 32 ;
//     end
//     else if (in[ 30 ]==1) begin
//      out= 31 ;
//     end
//     else if (in[ 29 ]==1) begin
//      out= 30 ;
//     end
//     else if (in[ 28 ]==1) begin
//      out= 29 ;
//     end
//     else if (in[ 27 ]==1) begin
//      out= 28 ;
//     end
//     else if (in[ 26 ]==1) begin
//      out= 27 ;
//     end
//     else if (in[ 25 ]==1) begin
//      out= 26 ;
//     end
//     else if (in[ 24 ]==1) begin
//      out= 25 ;
//     end
//     else if (in[ 23 ]==1) begin
//      out= 24 ;
//     end
//     else if (in[ 22 ]==1) begin
//      out= 23 ;
//     end
//     else if (in[ 21 ]==1) begin
//      out= 22 ;
//     end
//     else if (in[ 20 ]==1) begin
//      out= 21 ;
//     end
//     else if (in[ 19 ]==1) begin
//      out= 20 ;
//     end
//     else if (in[ 18 ]==1) begin
//      out= 19 ;
//     end
//     else if (in[ 17 ]==1) begin
//      out= 18 ;
//     end
//     else if (in[ 16 ]==1) begin
//      out= 17 ;
//     end
//     else if (in[ 15 ]==1) begin
//      out= 16 ;
//     end
//     else if (in[ 14 ]==1) begin
//      out= 15 ;
//     end
//     else if (in[ 13 ]==1) begin
//      out= 14 ;
//     end
//     else if (in[ 12 ]==1) begin
//      out= 13 ;
//     end
//     else if (in[ 11 ]==1) begin
//      out= 12 ;
//     end
//     else if (in[ 10 ]==1) begin
//      out= 11 ;
//     end
//     else if (in[ 9 ]==1) begin
//      out= 10 ;
//     end
//     else if (in[ 8 ]==1) begin
//      out= 9 ;
//     end
//     else if (in[ 7 ]==1) begin
//      out= 8 ;
//     end
//     else if (in[ 6 ]==1) begin
//      out= 7 ;
//     end
//     else if (in[ 5 ]==1) begin
//      out= 6 ;
//     end
//     else if (in[ 4 ]==1) begin
//      out= 5 ;
//     end
//     else if (in[ 3 ]==1) begin
//      out= 4 ;
//     end
//     else if (in[ 2 ]==1) begin
//      out= 3 ;
//     end
//     else if (in[ 1 ]==1) begin
//      out= 2 ;
//     end
//     else if (in[ 0 ]==1) begin
//      out= 1 ;
//     end    
//     else begin
//       out=0;
//     end
// 	end
// endmodule

module sqrt
    #(parameter DATA_IN_WIDTH = 16)
    (
    input   wire                                    clk,
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x1,
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x2,
    output  wire            [ DATA_IN_WIDTH-1:  0 ] y
    );

localparam DATA_WIDTH_SQUARING = (2*DATA_IN_WIDTH) - 1;
wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x1_2 = x1*x1;
wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x2_2 = x2*x2;

localparam DATA_WIDTH_SUM = DATA_WIDTH_SQUARING+1;
wire    [ DATA_WIDTH_SUM-1 :  0 ] x = x1_2 + x2_2;

assign y[DATA_IN_WIDTH-1] = x[(DATA_WIDTH_SUM-1)-:2] == 2'b00 ? 1'b0 : 1'b1;
genvar k;
generate
    for(k = DATA_IN_WIDTH-2; k >= 0; k = k - 1)
    begin: gen
        assign y[k] = x[(DATA_WIDTH_SUM-1)-:(2*(DATA_IN_WIDTH-k))] < 
        {y[DATA_IN_WIDTH-1:k+1],1'b1}*{y[DATA_IN_WIDTH-1:k+1],1'b1} ? 1'b0 : 1'b1;
    end
endgenerate

endmodule