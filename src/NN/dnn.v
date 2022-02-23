`include "bias_rom.v"
`include "kernel_3_rom.v"
`include "kernel_2_rom.v"
`include "kernel_1_rom.v"
`include "kernel_0_rom.v"
module dnn(
  //interface
    input           clk,
    input           rst_n,
    input           in_valid,
    input   [469:0] in,
    //output  [563:0] out,//47*12-1
    output  [3:0]   out,
    output          out_valid      
    ); 
    integer i;
  //parameter
    localparam      IDLE        =0;
    localparam      LAYER_1     =1;
    localparam      LAYER_2     =2;
    localparam      LAYER_3     =3;
    localparam      LAYER_4     =4;
    integer j=0;
  //reg
    reg signed [46:0]       in_r[299:0],in_w[299:0];
    reg [11:0]              counter_r,counter_w;
    reg signed [46:0]       acum_r[35:0],acum_w[35:0];
    reg signed [46:0]       shift_reg_r[143:0],shift_reg_w[143:0];
    reg                     valid_acum_r,valid_acum_w;
    reg                     valid_out_r,valid_out_w;
    reg [2:0]               state_r ,state_w;
    reg [4:0]               in_counter_r,in_counter_w;
    reg [10:0]              addr_r,addr_w;
    reg [3:0]               bias_counter_r,bias_counter_w;
    reg [8:0]               mul_counter_r,mul_counter_w;
    reg                     valid_shift_r,valid_shift_w;
    reg [2:0]               buff_r,buff_w;
    reg                     buff_out_valid_r,buff_out_valid_w;
    reg [3:0]               buff_out_r,buff_out_w;
  //wire
    reg signed [46:0]       mul_w;
    reg signed [15:0]       weight_w[35:0];
    reg signed [62:0]       mid_ans[35:0];
    reg signed [46:0]       ans_w[35:0];
    reg                     add_bias_w; 
    reg                     acum_clear_w;  
    reg                     stay_w;   
    wire                    one;
    wire signed [575:0]     rom_0_out;
    wire signed [575:0]     rom_1_out;
    wire signed [575:0]     rom_2_out;
    wire signed [191:0]     rom_3_out;
    wire signed [287:0]     bias_out;
    reg  [1:0]              game_1_1_winner;//0 3 6 9  *3 
    reg  [1:0]              game_1_2_winner;//1 4 7 10 *3+1
    reg  [1:0]              game_1_3_winner;//2 5 8 11 *3+2
    reg  signed[46:0]       game_1_1_winner_num;
    reg  signed[46:0]       game_1_2_winner_num;
    reg  signed[46:0]       game_1_3_winner_num; 
    reg [3:0]               winner;                  
  //assign
    assign out_valid=buff_out_valid_r;
    assign out=buff_out_r;
    //assign out_valid=(state_r==4)&&(counter_r==146);
    //assign out=winner;
    assign one=1;
  //module
    bias_rom b0(//      bias_counter_r
            .addr(bias_counter_w),
            .clk(clk),
            .in_valid(one),
            .w(bias_out)
        );
    kernel_0_rom m0(//  addr_r
            .addr(addr_w),
            .in_valid(one),
            .clk(clk),
            .w(rom_0_out)
        );
    kernel_1_rom m1(//  addr_r[9:0]
            .addr(addr_w[9:0]),
            .in_valid(one),
            .clk(clk),
            .w(rom_1_out)
        );
    kernel_2_rom m2(//  addr_r[9:0]
            .addr(addr_w[9:0]),
            .in_valid(one),
            .clk(clk),
            .w(rom_2_out)
        );
    kernel_3_rom m3(//  addr_r[7:0]
            .addr(addr_w[7:0]),
            .in_valid(one),
            .clk(clk),
            .w(rom_3_out)
        );
  //combinational-------------------------------------------------------------
   //buff
    always @(*) begin
        buff_out_w=winner;
        buff_out_valid_w=(state_r==4)&&(counter_r==146);
    end
    initial begin
        if((state_r==4)&&(counter_r==146))begin
            $display("0=%d",acum_r[0]);
            $display("1=%d",acum_r[1]);
            $display("2=%d",acum_r[2]);
            $display("3=%d",acum_r[3]);
            $display("4=%d",acum_r[4]);
            $display("5=%d",acum_r[5]);
            $display("6=%d",acum_r[6]);
            $display("7=%d",acum_r[7]);
            $display("8=%d",acum_r[8]);
            $display("9=%d",acum_r[9]);
            $display("10=%d",acum_r[10]);
            $display("11=%d",acum_r[11]);
        end
    end 
   //compare
    always @(*) begin
        if((acum_r[9]>acum_r[6])&&(acum_r[9]>acum_r[3])&&(acum_r[9]>acum_r[0]))begin
            game_1_1_winner=3;
            game_1_1_winner_num=acum_r[9];
        end
        else if((acum_r[6]>acum_r[3])&&(acum_r[6]>acum_r[0]))begin
            game_1_1_winner=2;
            game_1_1_winner_num=acum_r[6];
        end
        else if(acum_r[3]>acum_r[0])begin
            game_1_1_winner=1;
            game_1_1_winner_num=acum_r[3];
        end
        else begin
            game_1_1_winner=0;
            game_1_1_winner_num=acum_r[0];
        end
        if((acum_r[10]>acum_r[7])&&(acum_r[10]>acum_r[4])&&(acum_r[10]>acum_r[1]))begin
            game_1_2_winner=3;
            game_1_2_winner_num=acum_r[10];
        end
        else if((acum_r[7]>acum_r[4])&&(acum_r[7]>acum_r[1]))begin
            game_1_2_winner=2;
            game_1_2_winner_num=acum_r[7];
        end
        else if(acum_r[4]>acum_r[1])begin
            game_1_2_winner=1;
            game_1_2_winner_num=acum_r[4];
        end
        else begin
            game_1_2_winner=0;
            game_1_2_winner_num=acum_r[1];
        end
        if((acum_r[11]>acum_r[8])&&(acum_r[11]>acum_r[5])&&(acum_r[11]>acum_r[2]))begin
            game_1_3_winner=3;
            game_1_3_winner_num=acum_r[11];
        end
        else if((acum_r[8]>acum_r[5])&&(acum_r[8]>acum_r[2]))begin
            game_1_3_winner=2;
            game_1_3_winner_num=acum_r[8];
        end
        else if(acum_r[5]>acum_r[2])begin
            game_1_3_winner=1;
            game_1_3_winner_num=acum_r[5];
        end
        else begin
            game_1_3_winner=0;
            game_1_3_winner_num=acum_r[2];
        end
        if((game_1_3_winner_num>game_1_2_winner_num)&&(game_1_3_winner_num>game_1_1_winner_num))begin
            winner=game_1_3_winner*3+3;
        end
        else if(game_1_2_winner_num>game_1_1_winner_num)begin
            winner=game_1_2_winner*3+2;
        end
        else begin
            winner=game_1_1_winner*3+1;
        end
    end
   //weight_w mul_w state_r mul_counter_r
    always @(*) begin
        case(state_r)
            IDLE:begin
                for(i=0;i<36;i=i+1)begin
                    weight_w[i]=0;
                end    
            end
            LAYER_1:begin
                for(i=0;i<36;i=i+1)begin
                    weight_w[i]=rom_0_out[575-16*i-:16];
                end 
            end
            LAYER_2:begin
                for(i=0;i<36;i=i+1)begin
                    weight_w[i]=rom_1_out[575-16*i-:16];
                end
            end
            LAYER_3:begin
                for(i=0;i<36;i=i+1)begin
                    weight_w[i]=rom_2_out[575-16*i-:16];
                end
            end
            LAYER_4:begin
                for(i=0;i<=11;i=i+1)begin
                    weight_w[i]=rom_3_out[191-16*i-:16];
                end
                for(i=12;i<36;i=i+1)begin
                    weight_w[i]=0;
                end
            end
            default:begin
                for(i=0;i<36;i=i+1)begin
                    weight_w[i]=0;
                end
            end
        endcase
    end
   //mul_w
    always @(*) begin
        mul_w=in_r[mul_counter_r];
    end
   //ans_w[i] mul_counter_r
    always @(*) begin
        for(i=0;i<36;i=i+1)begin
            mid_ans[i]=mul_w*weight_w[i];
            ans_w[i]=mid_ans[i]>>>16;
            if((state_r==1)&&(j<60))begin
                j=j+1;
            //    $display("----------------------------------------");
            //    $display("      mul_w=%d",mul_w);
            //    $display("      weight_w[%d]=%d",i,weight_w[i]);
            //    $display("      mid_ans[%d]=%d",i,mid_ans[i]);
            //    $display("      ans_w[%d]=%d",i,ans_w[i]);
            //    $display("      add_bias_w=%d",add_bias_w);
            //    $display("      acum_clear_w=%d",acum_clear_w);
            //    $display("      acum_r[%d]=%d",i,acum_r[i]);
            //    $display("      acum_w[%d]=%d",i,acum_w[i]); 
            end
            
        end 
    end
   //in_w           state_r in_valid
    always @(*) begin
        if((state_r==IDLE)&&(in_valid))begin
            // for(i=0;i<=9;i=i+1)begin
            //     in_w[i]=in[47*i+47-1-:47];
            // end
            // for(i=10;i<=299;i=i+1)begin
            //     in_w[i]=in_r[i-10];
            // end 
            for(i=0;i<=289;i=i+1)begin
                in_w[i]=in_r[i+10];
            end
            in_w[290]=in[47*(0)+46-:47];
            in_w[291]=in[47*(1)+46-:47];
            in_w[292]=in[47*(2)+46-:47];
            in_w[293]=in[47*(3)+46-:47];
            in_w[294]=in[47*(4)+46-:47];
            in_w[295]=in[47*(5)+46-:47];
            in_w[296]=in[47*(6)+46-:47];
            in_w[297]=in[47*(7)+46-:47];
            in_w[298]=in[47*(8)+46-:47];
            in_w[299]=in[47*(9)+46-:47];
        end
        else begin
            if(valid_shift_r)begin
                for(i=0;i<=143;i=i+1)begin
                    in_w[i]=(shift_reg_r[i]>0)?shift_reg_r[i]:0;
                end
                for(i=144;i<=299;i=i+1)begin
                    in_w[i]=0;
                end
            end
            else begin
                for(i=0;i<=299;i=i+1)begin
                    in_w[i]=in_r[i];
                end    
            end
        end
    end
   //acum_w         state_r acum_clear_w add_bias_w stay_w
    always @(*) begin
        if(state_r==IDLE)begin
            for(i=0;i<36;i=i+1)begin
                acum_w[i]=0;
            end
        end
        else begin
            for(i=0;i<36;i=i+1)begin
                if(acum_clear_w)begin
                    acum_w[i]=0;
                end
                else if(add_bias_w)begin
                    acum_w[i]=$signed(acum_r[i])+$signed({bias_out[287-8*i-:8],22'b0});
                end
                else if(stay_w)begin
                    acum_w[i]=acum_r[i]+ans_w[i];
                end
                else begin
                    acum_w[i]=acum_r[i]+ans_w[i];
                end
            end   
        end
    end
   //shift_reg_w    state_r valid_acum_r
    always @(*) begin
        if(state_r==IDLE)begin
            for(i=0;i<144;i=i+1)begin
                shift_reg_w[i]=0;
            end
        end
        else begin
            if(valid_acum_r)begin
                // for(i=0;i<=35;i=i+1)begin
                //     shift_reg_w[i]=acum_r[i];
                // end
                // for(i=36;i<144;i=i+1)begin
                //     shift_reg_w[i]=shift_reg_r[i-36];
                // end    
                for(i=0;i<=107;i=i+1)begin
                    shift_reg_w[i]=shift_reg_r[i+36];
                end
                for(i=108;i<=143;i=i+1)begin
                    shift_reg_w[i]=acum_r[i-108];
                end  
            end
            else begin
                for(i=0;i<144;i=i+1)begin
                    shift_reg_w[i]=shift_reg_r[i];
                end
            end  
        end
    end
  //control counter_w in_counter_w valid_acum_r add_bias_w stay_w acum_clear_w mul_counter_r bias_counter_r state_r valid_shift_r
   //control
    always @(*) begin
        stay_w=0;
        bias_counter_w=(buff_r==1)?bias_counter_r+1:bias_counter_r;
        case(state_r)
            IDLE:begin
                state_w=(in_counter_r==30)?LAYER_1:IDLE;
                in_counter_w=(in_valid)?in_counter_r+1:in_counter_r;
                counter_w=0;
                addr_w=0;
                buff_w=0;
                mul_counter_w=0;
                valid_acum_w=0;
                valid_shift_w=0;
                add_bias_w=0;
            end
            LAYER_1:begin
                state_w=((addr_r==1199)&&(buff_r==3))?LAYER_2:LAYER_1;
                valid_shift_w=(valid_acum_r&&(addr_r==1199));
                if(state_w==LAYER_2)begin
                    in_counter_w=0;
                    counter_w=0;
                    add_bias_w=0;
                    acum_clear_w=1;
                    mul_counter_w=0;
                    addr_w=0;
                    buff_w=0;
                    valid_acum_w=0;
                end
                else begin
                    in_counter_w=(in_valid)?in_counter_r+1:in_counter_r;
                    counter_w=(state_w==LAYER_2)?0:counter_r+1;
                    add_bias_w=(buff_r==1);
                    acum_clear_w=(buff_r==2);
                    valid_acum_w=add_bias_w;
                    //mul_counter_w
                        if(counter_r>=2)begin
                            if(buff_r==2)begin
                                mul_counter_w=(addr_r==1199)?mul_counter_r:0;
                            end
                            else if(buff_r==1)begin
                                mul_counter_w=mul_counter_r;
                            end
                            else if(buff_r==0)begin
                                if((mul_counter_r==299)||(mul_counter_r==599||(mul_counter_r==899)||(mul_counter_r==1199)))begin
                                    mul_counter_w=mul_counter_r;
                                end
                                else begin
                                    mul_counter_w=mul_counter_r+1;
                                end
                            end
                            else if(buff_r==3)begin
                                mul_counter_w=mul_counter_r+1;
                            end
                            else begin
                                mul_counter_w=mul_counter_r;
                            end
                        end
                        else begin
                            mul_counter_w=0;
                        end
                    //addr_w
                        if(counter_r>=2)begin
                            if((buff_r==2))begin
                                addr_w=(addr_r==1199)?addr_r:addr_r+1;
                            end
                            else if((buff_r==0))begin
                                addr_w=((mul_counter_r==299)||(mul_counter_r==599||(mul_counter_r==899)||(mul_counter_r==1199)))?addr_r:addr_r+1;
                            end
                            else if((buff_r==1))begin
                                addr_w=addr_r;
                            end
                            else if (buff_r==3)begin
                                addr_w=addr_r+1;
                            end
                            else begin
                                addr_w=addr_r;
                            end
                        end
                        else begin
                            addr_w=0;
                        end
                    //buff_w
                        if(buff_r==1)begin
                            buff_w=2;
                        end
                        else if(buff_r==2) begin
                            buff_w=3;
                        end
                        else begin
                            if((mul_counter_r==299)||(mul_counter_r==599)||(mul_counter_r==899)||(mul_counter_r==1199))begin
                                buff_w=1;
                            end
                            else begin
                                buff_w=0;
                            end
                        end
                end
            end
            LAYER_2:begin
                state_w=((addr_r==575)&&(buff_r==3))?LAYER_3:LAYER_2;
                valid_shift_w=(valid_acum_r&&(addr_r==575));
                if(state_w==LAYER_3)begin
                    in_counter_w=0;
                    counter_w=0;
                    add_bias_w=0;
                    acum_clear_w=1;
                    mul_counter_w=0;
                    addr_w=0;
                    buff_w=0;
                    valid_acum_w=0;
                end
                else begin
                    in_counter_w=(in_valid)?in_counter_r+1:in_counter_r;
                    counter_w=(state_w==LAYER_3)?0:counter_r+1;
                    add_bias_w=(buff_r==1);
                    acum_clear_w=(buff_r==2)||(counter_r==0);
                    valid_acum_w=add_bias_w;
                    //mul_counter_w
                        if(counter_r>=1)begin
                            if(buff_r==2)begin
                                mul_counter_w=(addr_r==575)?mul_counter_r:0;
                            end
                            else if(buff_r==1)begin
                                mul_counter_w=mul_counter_r;
                            end
                            else if(buff_r==0)begin
                                if((mul_counter_r==143)||(mul_counter_r==287||(mul_counter_r==431)||(mul_counter_r==575)))begin
                                    mul_counter_w=mul_counter_r;
                                end
                                else begin
                                    mul_counter_w=mul_counter_r+1;
                                end
                            end
                            else if(buff_r==3)begin
                                mul_counter_w=mul_counter_r+1;
                            end
                            else begin
                                mul_counter_w=mul_counter_r;
                            end
                        end
                        else begin
                            mul_counter_w=0;
                        end
                    //addr_w
                        if(counter_r>=1)begin
                            if((buff_r==2))begin
                                addr_w=(addr_r==575)?addr_r:addr_r+1;
                            end
                            else if((buff_r==0))begin
                                addr_w=((mul_counter_r==143)||(mul_counter_r==287||(mul_counter_r==431)||(mul_counter_r==575)))?addr_r:addr_r+1;
                            end
                            else if((buff_r==1))begin
                                addr_w=addr_r;
                            end
                            else if (buff_r==3)begin
                                addr_w=addr_r+1;
                            end
                            else begin
                                addr_w=addr_r;
                            end
                        end
                        else begin
                            addr_w=0;
                        end
                    //buff_w
                        if(buff_r==1)begin
                            buff_w=2;
                        end
                        else if(buff_r==2) begin
                            buff_w=3;
                        end
                        else begin
                            if((mul_counter_r==143)||(mul_counter_r==287)||(mul_counter_r==431)||(mul_counter_r==575))begin
                                buff_w=1;
                            end
                            else begin
                                buff_w=0;
                            end
                        end
                end
            end
            LAYER_3:begin
                state_w=((addr_r==575)&&(buff_r==3))?LAYER_4:LAYER_3;
                valid_shift_w=(valid_acum_r&&(addr_r==575));
                if(state_w==LAYER_4)begin
                    in_counter_w=0;
                    counter_w=0;
                    add_bias_w=0;
                    acum_clear_w=1;
                    mul_counter_w=0;
                    addr_w=0;
                    buff_w=0;
                    valid_acum_w=0;
                end
                else begin
                    in_counter_w=(in_valid)?in_counter_r+1:in_counter_r;
                    counter_w=(state_w==LAYER_4)?0:counter_r+1;
                    add_bias_w=(buff_r==1);
                    acum_clear_w=(buff_r==2)||(counter_r==0);
                    valid_acum_w=add_bias_w;
                    //mul_counter_w
                        if(counter_r>=1)begin
                            if(buff_r==2)begin
                                mul_counter_w=(addr_r==575)?mul_counter_r:0;
                            end
                            else if(buff_r==1)begin
                                mul_counter_w=mul_counter_r;
                            end
                            else if(buff_r==0)begin
                                if((mul_counter_r==143)||(mul_counter_r==287||(mul_counter_r==431)||(mul_counter_r==575)))begin
                                    mul_counter_w=mul_counter_r;
                                end
                                else begin
                                    mul_counter_w=mul_counter_r+1;
                                end
                            end
                            else if(buff_r==3)begin
                                mul_counter_w=mul_counter_r+1;
                            end
                            else begin
                                mul_counter_w=mul_counter_r;
                            end
                        end
                        else begin
                            mul_counter_w=0;
                        end
                    //addr_w
                        if(counter_r>=1)begin
                            if((buff_r==2))begin
                                addr_w=(addr_r==575)?addr_r:addr_r+1;
                            end
                            else if((buff_r==0))begin
                                addr_w=((mul_counter_r==143)||(mul_counter_r==287||(mul_counter_r==431)||(mul_counter_r==575)))?addr_r:addr_r+1;
                            end
                            else if((buff_r==1))begin
                                addr_w=addr_r;
                            end
                            else if (buff_r==3)begin
                                addr_w=addr_r+1;
                            end
                            else begin
                                addr_w=addr_r;
                            end
                        end
                        else begin
                            addr_w=0;
                        end
                    //buff_w
                        if(buff_r==1)begin
                            buff_w=2;
                        end
                        else if(buff_r==2) begin
                            buff_w=3;
                        end
                        else begin
                            if((mul_counter_r==143)||(mul_counter_r==287)||(mul_counter_r==431)||(mul_counter_r==575))begin
                                buff_w=1;
                            end
                            else begin
                                buff_w=0;
                            end
                        end
                end
            end
            LAYER_4:begin
                state_w=((addr_r==144)&&(buff_r==3))?IDLE:LAYER_4;
                valid_shift_w=(valid_acum_r&&(addr_r==143));
                if(state_w==IDLE)begin
                    in_counter_w=0;
                    counter_w=0;
                    add_bias_w=0;
                    acum_clear_w=1;
                    mul_counter_w=0;
                    addr_w=0;
                    buff_w=0;
                    valid_acum_w=0;
                end
                else begin
                    in_counter_w=(in_valid)?in_counter_r+1:in_counter_r;
                    counter_w=(state_w==IDLE)?0:counter_r+1;
                    add_bias_w=(buff_r==1);
                    acum_clear_w=(buff_r==2)||(counter_r==0);
                    valid_acum_w=add_bias_w;
                    //mul_counter_w
                        if(counter_r>=1)begin
                            if(buff_r==2)begin
                                mul_counter_w=(addr_r==143)?mul_counter_r:0;
                            end
                            else if(buff_r==1)begin
                                mul_counter_w=mul_counter_r;
                            end
                            else if(buff_r==0)begin
                                if((mul_counter_r==143))begin
                                    mul_counter_w=mul_counter_r;
                                end
                                else begin
                                    mul_counter_w=mul_counter_r+1;
                                end
                            end
                            else if(buff_r==3)begin
                                mul_counter_w=mul_counter_r+1;
                            end
                            else begin
                                mul_counter_w=mul_counter_r;
                            end
                        end
                        else begin
                            mul_counter_w=0;
                        end
                    //addr_w
                        if(counter_r>=1)begin
                            if((buff_r==2))begin
                                addr_w=(addr_r==431)?addr_r:addr_r+1;
                            end
                            else if((buff_r==0))begin
                                addr_w=((mul_counter_r==143))?addr_r:addr_r+1;
                            end
                            else if((buff_r==1))begin
                                addr_w=addr_r;
                            end
                            else if (buff_r==3)begin
                                addr_w=addr_r+1;
                            end
                            else begin
                                addr_w=addr_r;
                            end
                        end
                        else begin
                            addr_w=0;
                        end
                    //buff_w
                        if(buff_r==1)begin
                            buff_w=2;
                        end
                        else if(buff_r==2) begin
                            buff_w=3;
                        end
                        else begin
                            if((mul_counter_r==143))begin
                                buff_w=1;
                            end
                            else begin
                                buff_w=0;
                            end
                        end
                end
            end
            default:begin
                valid_shift_w=0;
                state_w=((addr_r==143)&&(buff_r==3))?LAYER_4:IDLE;
                in_counter_w=0;
                counter_w=0;
                add_bias_w=0;
                acum_clear_w=1;
                mul_counter_w=0;
                addr_w=0;
                buff_w=0;
            end
        endcase
    end
   

   

  //sequential----------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            buff_out_r<=0;
            buff_out_valid_r<=0;
            for(i=0;i<=299;i=i+1)begin
                in_r[i]<=0;
            end
            for(i=0;i<=35;i=i+1)begin
                acum_r[i]<=0;
            end 
            for(i=0;i<=143;i=i+1)begin
                shift_reg_r[i]<=0;
            end
            counter_r<=0;
            valid_acum_r<=0;
            valid_out_r<=0;
            state_r<=0;
            in_counter_r<=0;
            addr_r<=0;
            bias_counter_r<=0;
            mul_counter_r<=0;
            valid_shift_r<=0;
            buff_r<=0;
        end
        else begin
            buff_out_r<=buff_out_w;
            buff_out_valid_r<=buff_out_valid_w;
            for(i=0;i<=299;i=i+1)begin
                in_r[i]<=in_w[i];
            end
            for(i=0;i<=35;i=i+1)begin
                acum_r[i]<=acum_w[i];
            end 
            for(i=0;i<=143;i=i+1)begin
                shift_reg_r[i]<=shift_reg_w[i];
            end
            counter_r<=counter_w;
            valid_acum_r<=valid_acum_w;
            valid_out_r<=valid_out_w;
            state_r<=state_w;
            in_counter_r<=in_counter_w;
            addr_r<=addr_w;
            bias_counter_r<=bias_counter_w;
            mul_counter_r<=mul_counter_w;
            valid_shift_r<=valid_shift_w;
            buff_r<=buff_w;
            if((state_r==4)&&(counter_r==146))begin
            $display("Possibility of silence=%d",acum_r[0]);
            $display("Possibility of unknown=%d",acum_r[1]);
            $display("Possibility of yes=    %d",acum_r[2]);
            $display("Possibility of no=     %d",acum_r[3]);
            $display("Possibility of up=     %d",acum_r[4]);
            $display("Possibility of down=   %d",acum_r[5]);
            $display("Possibility of left=   %d",acum_r[6]);
            $display("Possibility of right=  %d",acum_r[7]);
            $display("Possibility of on=     %d",acum_r[8]);
            $display("Possibility of off=    %d",acum_r[9]);
            $display("Possibility of stop=   %d",acum_r[10]);
            $display("Possibility of go=     %d",acum_r[11]);
            end
        end
    end
endmodule