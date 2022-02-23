module framing_memory#(
    parameter BITS = 12,
    parameter word_depth = 128
    )(
        clk,
        rst_n,
        wen,
        a,
        d,
        out,
    );
       
    input clk, rst_n, wen; // wen: 0:read | 1:write
    input [BITS-1:0] d;
    input [6:0] a;
    output [BITS-1:0] out;

    reg  [BITS-1:0] out;
    reg  [BITS-1:0] mem [0:word_depth-1];
    reg  [BITS-1:0] mem_nxt [0:word_depth-1];
    reg  [BITS-1:0] mem_addr [0:word_depth-1];

    integer i;

    always @(*) begin //read
        //out = {(BITS){1'bz}};
        for (i=0; i<word_depth; i=i+1) begin
            if (i == a)
                out = mem[i];
        end
    end

    always @(*) begin// write
        for (i=0; i<word_depth; i=i+1)
            mem_nxt[i] = (wen && (i == a)) ? d : mem[i];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<word_depth; i=i+1)
                mem[i] <= 0;
        end
        else begin
            for (i=0; i<word_depth; i=i+1)
                mem[i] <= mem_nxt[i];    
        end
    end

endmodule