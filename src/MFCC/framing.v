

module framing#(
    parameter INPUT_LENGTH=20
)(
    clk,
    rst_n,
    in,
    in_valid,
    out,
    out_valid,
    out_num,
    out_state
);  
    integer i;
    // Definition of ports
    input  wire clk; 
    input  wire rst_n;
    input wire signed [INPUT_LENGTH-1:0] in ;
    input  wire in_valid;
    output wire signed [INPUT_LENGTH-1:0] out;
    output wire out_valid;
    output wire [2:0]out_state;
    output wire [14:0]out_num;
    // Definition of wire/reg 
    reg [INPUT_LENGTH-1:0]shift_r[511:0];
    reg [INPUT_LENGTH-1:0]shift_w[511:0];
    reg [9:0] counter_r,counter_w;
    reg control_r,control_w;
    reg [2:0]state_r,state_w;
    reg [9:0]addr_r,addr_w;
    wire shift;
    reg [INPUT_LENGTH-1:0]out_cal;
    reg valid_cal;
    reg [14:0]counter;
    reg [14:0]out_num_cal;
    assign out_state=state_r;
    assign shift=in_valid;
    assign out=out_cal;
    assign out_valid=valid_cal;
    assign out_num=out_num_cal;
    //out_num_cal
    always @(*) begin
        if(out_valid&&(counter==0))begin
            out_num_cal=1;
        end
        else if(out_valid&&(counter!=0))begin
            out_num_cal=counter+1;
        end
        else begin
            out_num_cal=0;
        end
    end
    //valid_cal
        always @(*) begin
            if((state_w==3)||(state_w==4))begin
                valid_cal=1;
            end
            else begin
                valid_cal=0;
            end
        end
    //addr_w
        always @(*) begin
            if((state_r==3)&&(state_w==4))begin
                addr_w=510;
            end
            else if(state_w==4&&(addr_r!=0))begin
                addr_w=addr_r-1;
            end
            else if((state_r==4)&&(addr_r==0))begin
                addr_w=511;
            end
            else begin
                addr_w=0;
            end
        end
    //out_cal
        always @(*) begin
            case(state_r)
                0:out_cal=0;
                1:out_cal=0;
                2:out_cal=(in_valid)?shift_r[511]:0;
                3:out_cal=shift_r[511];
                4:out_cal=shift_r[addr_r];
                default:out_cal=0;
            endcase
        end
    //shift_w
        always @(*) begin
            if(shift)begin
                for (i=1; i<=511; i=i+1)begin
                shift_w[i]<=shift_r[i-1];
                end
                shift_w[0]<=in;
            end
            else begin
                for (i=0; i<=511; i=i+1)begin
                shift_w[i]<=shift_r[i];
                end
            end
        end
    //counter_w
        always @(*) begin
            if(in_valid)begin
                counter_w=counter_r+1;
            end
            else begin
                counter_w=0;    
            end
        end
    //control_w
        always @(*) begin
            if(control_r==1)begin
                control_w=1;
            end
            else begin
                control_w=(counter_r==512)?1:0;            
            end
        end
    //state_w
        always @(*) begin
            case(state_r)
                0:state_w=(in_valid)?1:0;
                1:state_w=(in_valid)?1:2;
                2:state_w=(in_valid)?3:2;
                3:begin
                    if(counter==30720)begin
                        state_w=5;
                    end
                    else begin
                        state_w=(in_valid)?3:4;
                    end
                end
                4:begin
                    if(counter==30720)begin
                        state_w=5;
                    end
                    else begin
                        state_w=(in_valid)?3:4;
                    end
                end
                default:state_w=5;
            endcase
        end
    always @ (posedge clk or negedge rst_n)begin
      if(!rst_n) begin
        for (i=0; i<=511; i=i+1)begin
            shift_r[i]<=0;
        end
        addr_r<=0;
        counter_r<=0;
        control_r<=0;
        state_r<=0;
        counter<=0;
      end
      else begin
          counter<=(valid_cal)?counter+1:counter;
        for (i=0; i<=511; i=i+1)begin
            shift_r[i]<=shift_w[i];
        end
        addr_r<=addr_w;
        counter_r<=counter_w;
        control_r<=control_w;
        state_r<=state_w;    
        // $display("----------------------------------------------------");
        // $display("At %5dns , \nThe in[0], %f,",$time,in/((2**(INPUT_LENGTH-2))*1.0));
        // $display("The in_valid, %f,",in_valid);
        // $display("The addr_r, %d,",addr_r);
        // $display("The counter_r, %d,",counter_r);
        // $display("The control_r, %d,",control_r);
        // $display("The out, %f,",out/((2**(INPUT_LENGTH-2))*1.0));
        // $display("----------------------------------------------------");
      end
    end
endmodule




