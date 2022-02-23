`timescale 1ns/10ps
`include "fft_r22sdf_tfm.v"
`include "fft_r22sdf_bf2.v"
`include "fft_r22sdf_bf2i.v"
`include "fft_r22sdf_bf2ii.v"
`include "fft_r22sdf_rom_1024_s0.v"
`include "fft_r22sdf_rom_1024_s1.v"
`include "fft_r22sdf_rom_1024_s2.v"
`include "fft_r22sdf_rom_1024_s3.v"
// `include "system.vh"

module fft_r22sdf #(
    parameter                          N_LOG2    = 8,//10
    parameter                          TF_WDTH   = 10,
    parameter                          DIN_WDTH  = 12,//32
    parameter                          META_WDTH = 11,
    parameter                          DOUT_WDTH = 16//40
  )
  (
    input  wire                        clk,
    input  wire                        rst_n,
    input  wire        [META_WDTH-1:0] din_meta,
    input  wire signed  [DIN_WDTH-1:0] din_re,
    input  wire signed  [DIN_WDTH-1:0] din_im,
    input  wire                        din_nd,
    output  reg        [META_WDTH-1:0] dout_meta,
    output  reg signed [DOUT_WDTH-1:0] dout_re,
    output  reg signed [DOUT_WDTH-1:0] dout_im,
    output  reg                        dout_nd,
    output  wire        [9:0]           out_num
  );

  /* Define the FFT length. */
  localparam  N = 2**N_LOG2;

  /* Compute the number of radix-22 stages required. */
  localparam  NUM_BF2_STAGES = N_LOG2/2;

  /* Define butterfly bus widths for N >= 4. */
  localparam  BF0_X_WDTH = DIN_WDTH;
  localparam  BF0_Z_WDTH = BF0_X_WDTH + 2;
  localparam  TM0_X_WDTH = BF0_Z_WDTH;
  localparam  TM0_Z_WDTH = TF_WDTH > TM0_X_WDTH ? TF_WDTH : TM0_X_WDTH;

  /* Define butterfly bus widths for N >= 16. */
  localparam  BF1_X_WDTH = TM0_Z_WDTH;
  localparam  BF1_Z_WDTH = BF1_X_WDTH + 2;
  localparam  TM1_X_WDTH = BF1_Z_WDTH;
  localparam  TM1_Z_WDTH = TF_WDTH > TM1_X_WDTH ? TF_WDTH : TM1_X_WDTH;

  /* Define butterfly bus widths for N >= 64. */
  localparam  BF2_X_WDTH = TM1_Z_WDTH;
  localparam  BF2_Z_WDTH = BF2_X_WDTH + 2;
  localparam  TM2_X_WDTH = BF2_Z_WDTH;
  localparam  TM2_Z_WDTH = TF_WDTH > TM2_X_WDTH ? TF_WDTH : TM2_X_WDTH;

  /* Define butterfly bus widths for N >= 256. */
  localparam  BF3_X_WDTH = TM2_Z_WDTH;
  localparam  BF3_Z_WDTH = BF3_X_WDTH + 2;
  localparam  TM3_X_WDTH = BF3_Z_WDTH;
  localparam  TM3_Z_WDTH = TF_WDTH > TM3_X_WDTH ? TF_WDTH : TM3_X_WDTH;

  /* Define butterfly bus widths for N >= 1024. */
  localparam  BF4_X_WDTH = TM3_Z_WDTH;
  localparam  BF4_Z_WDTH = BF4_X_WDTH + 2;
  localparam  TM4_X_WDTH = BF4_Z_WDTH;
  localparam  TM4_Z_WDTH = TF_WDTH > TM4_X_WDTH ? TF_WDTH : TM4_X_WDTH;

  /* Define butterfly bus widths for N >= 4096. */
  localparam  BF5_X_WDTH = TM4_Z_WDTH;
  localparam  BF5_Z_WDTH = BF5_X_WDTH + 2;
  localparam  TM5_X_WDTH = BF5_Z_WDTH;
  localparam  TM5_Z_WDTH = TF_WDTH > TM5_X_WDTH ? TF_WDTH : TM5_X_WDTH;

  /* Declare butterfly inter-connection wires for N >= 4. */
  wire signed   [BF0_Z_WDTH-1:0] bf0_z_re;
  wire signed   [BF0_Z_WDTH-1:0] bf0_z_im;
  wire                           bf0_z_nd;
  wire              [N_LOG2-1:0] bf0_c_out;
  wire           [META_WDTH-1:0] bf0_m_out;
  wire             [TF_WDTH-1:0] tf0_re;
  wire             [TF_WDTH-1:0] tf0_im;
  wire          [TM0_Z_WDTH-1:0] tm0_z_re;
  wire          [TM0_Z_WDTH-1:0] tm0_z_im;
  wire                           tm0_z_nd;
  wire              [N_LOG2-1:0] tm0_c_out;
  wire           [META_WDTH-1:0] tm0_m_out;

  /* Declare butterfly inter-connection wires for N >= 16. */
  wire signed   [BF1_Z_WDTH-1:0] bf1_z_re;
  wire signed   [BF1_Z_WDTH-1:0] bf1_z_im;
  wire                           bf1_z_nd;
  wire              [N_LOG2-1:0] bf1_c_out;
  wire           [META_WDTH-1:0] bf1_m_out;
  wire             [TF_WDTH-1:0] tf1_re;
  wire             [TF_WDTH-1:0] tf1_im;
  wire          [TM1_Z_WDTH-1:0] tm1_z_re;
  wire          [TM1_Z_WDTH-1:0] tm1_z_im;
  wire                           tm1_z_nd;
  wire              [N_LOG2-1:0] tm1_c_out;
  wire           [META_WDTH-1:0] tm1_m_out;

  /* Declare butterfly inter-connection wires for N >= 64. */
  wire signed   [BF2_Z_WDTH-1:0] bf2_z_re;
  wire signed   [BF2_Z_WDTH-1:0] bf2_z_im;
  wire                           bf2_z_nd;
  wire              [N_LOG2-1:0] bf2_c_out;
  wire           [META_WDTH-1:0] bf2_m_out;
  wire             [TF_WDTH-1:0] tf2_re;
  wire             [TF_WDTH-1:0] tf2_im;
  wire          [TM2_Z_WDTH-1:0] tm2_z_re;
  wire          [TM2_Z_WDTH-1:0] tm2_z_im;
  wire                           tm2_z_nd;
  wire              [N_LOG2-1:0] tm2_c_out;
  wire           [META_WDTH-1:0] tm2_m_out;

  /* Declare butterfly inter-connection wires for N >= 256. */
  wire signed   [BF3_Z_WDTH-1:0] bf3_z_re;
  wire signed   [BF3_Z_WDTH-1:0] bf3_z_im;
  wire                           bf3_z_nd;
  wire              [N_LOG2-1:0] bf3_c_out;
  wire           [META_WDTH-1:0] bf3_m_out;
  wire             [TF_WDTH-1:0] tf3_re;
  wire             [TF_WDTH-1:0] tf3_im;
  wire          [TM3_Z_WDTH-1:0] tm3_z_re;
  wire          [TM3_Z_WDTH-1:0] tm3_z_im;
  wire                           tm3_z_nd;
  wire              [N_LOG2-1:0] tm3_c_out;
  wire           [META_WDTH-1:0] tm3_m_out;

  /* Declare butterfly inter-connection wires for N >= 1024. */
  wire signed   [BF4_Z_WDTH-1:0] bf4_z_re;
  wire signed   [BF4_Z_WDTH-1:0] bf4_z_im;
  wire                           bf4_z_nd;
  wire              [N_LOG2-1:0] bf4_c_out;
  wire           [META_WDTH-1:0] bf4_m_out;
  wire             [TF_WDTH-1:0] tf4_re;
  wire             [TF_WDTH-1:0] tf4_im;
  wire          [TM4_Z_WDTH-1:0] tm4_z_re;
  wire          [TM4_Z_WDTH-1:0] tm4_z_im;
  wire                           tm4_z_nd;
  wire              [N_LOG2-1:0] tm4_c_out;
  wire           [META_WDTH-1:0] tm4_m_out;

  /* Declare butterfly inter-connection wires for N >= 4096. */
  wire signed   [BF5_Z_WDTH-1:0] bf5_z_re;
  wire signed   [BF5_Z_WDTH-1:0] bf5_z_im;
  wire                           bf5_z_nd;
  wire              [N_LOG2-1:0] bf5_c_out;
  wire           [META_WDTH-1:0] bf5_m_out;

  /* Declare wires to connect the outputs of the last butterfly stage to the 
   * external port-map. 
   */
  wire           [META_WDTH-1:0] bf_out_meta;
  wire              [N_LOG2-1:0] bf_out_cntr;
  wire signed    [DOUT_WDTH-1:0] bf_out_re;
  wire signed    [DOUT_WDTH-1:0] bf_out_im;
  wire                           bf_out_nd;

  /* Declare storage for the FFT controller (N-bit up-counter) and output enable
   * logic. 
   */
  reg               [N_LOG2-1:0] ctrl_cntr;
  reg                            oe;
  
  integer i;
  reg [9:0]counter_r,counter_w;
  // reg [3:0]try_r[9:0],try_w[9:0];
  always @(*) begin
    counter_w=(dout_nd)?counter_r+1:counter_r;
    // for (i=1; i<=511; i=i+1)begin
    //   try_w[i]<=(i>try_r[i])?1:0;
    // end
  end
  always @ (posedge clk or negedge rst_n)begin
    if (!rst_n)begin
      counter_r<=0;
      // for (i=0; i<=9; i=i+1)begin
      // try_r[i]<=5;
      // end
    end
    else begin
      counter_r<=counter_w;
      // for (i=0; i<=9; i=i+1)begin
      //   try_r[i]<=try_w[i];
      //   $display("try %d = 5d",i ,try_r[i]);
      // end
      
    end
  end
  //assign out_num=counter_r;
  assign out_num={counter_r[0],counter_r[1],counter_r[2],counter_r[3],counter_r[4],counter_r[5],counter_r[6],counter_r[7],counter_r[8],counter_r[9]};
  /* Connect bf_out_xxx wires to the outputs of the last butterfly stage based
   * on the requested FFT length.
   */
  generate
    case (N)
      4:
        begin
          assign bf_out_nd   = bf0_z_nd;
          assign bf_out_re   = bf0_z_re;
          assign bf_out_im   = bf0_z_im;
          assign bf_out_meta = bf0_m_out;
          assign bf_out_cntr = bf0_c_out;
        end

      16:
        begin
          assign bf_out_nd   = bf1_z_nd;
          assign bf_out_re   = bf1_z_re;
          assign bf_out_im   = bf1_z_im;
          assign bf_out_meta = bf1_m_out;
          assign bf_out_cntr = bf1_c_out;
        end

      64:
        begin
          assign bf_out_nd   = bf2_z_nd;
          assign bf_out_re   = bf2_z_re;
          assign bf_out_im   = bf2_z_im;
          assign bf_out_meta = bf2_m_out;
          assign bf_out_cntr = bf2_c_out;
        end

      256:
        begin
          assign bf_out_nd   = bf3_z_nd;
          assign bf_out_re   = bf3_z_re;
          assign bf_out_im   = bf3_z_im;
          assign bf_out_meta = bf3_m_out;
          assign bf_out_cntr = bf3_c_out;
        end

      1024:
        begin
          assign bf_out_nd   = bf4_z_nd;
          assign bf_out_re   = bf4_z_re;
          assign bf_out_im   = bf4_z_im;
          assign bf_out_meta = bf4_m_out;
          assign bf_out_cntr = bf4_c_out;
        end

      4096:
        begin
          assign bf_out_nd   = bf5_z_nd;
          assign bf_out_re   = bf5_z_re;
          assign bf_out_im   = bf5_z_im;
          assign bf_out_meta = bf5_m_out;
          assign bf_out_cntr = bf5_c_out;
        end

      default:
        begin
          assign bf_out_nd   = 1'b0;
          assign bf_out_re   = {DOUT_WDTH{1'b0}};
          assign bf_out_im   = {DOUT_WDTH{1'b0}};
          assign bf_out_meta = {META_WDTH{1'b0}};
          assign bf_out_cntr = {N_LOG2   {1'b0}};
        end
    endcase
  endgenerate

  /* Instantiate stage-0 butterflies. */
  fft_r22sdf_bf2 #(
      .S_INDX   (0),
      .N_LOG2   (N_LOG2),
      .X_WDTH   (BF0_X_WDTH),
      .M_WDTH   (META_WDTH)
    )
    fft_r22sdf_bf2_s0 (
      .clk      (clk),
      .rst_n    (rst_n),
      .c_in     (ctrl_cntr),
      .m_in     (din_meta),
      .x_re     (din_re),
      .x_im     (din_im),
      .x_nd     (din_nd),
      .c_out    (bf0_c_out),
      .m_out    (bf0_m_out),
      .z_re     (bf0_z_re),
      .z_im     (bf0_z_im),
      .z_nd     (bf0_z_nd)
    );

  /* Instantiate stage-1 butterflies (if required). */
  generate
    if (NUM_BF2_STAGES > 1)
      begin: bf_stage1
        fft_r22sdf_tfm #(
            .W_WDTH   (TF_WDTH),
            .X_WDTH   (TM0_X_WDTH),
            .Z_WDTH   (TM0_Z_WDTH),
            .M_WDTH   (META_WDTH),
            .C_WDTH   (N_LOG2)
          )
          fft_r22sdf_tfm_tm0 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (bf0_c_out),
            .m_in     (bf0_m_out),
            .w_re     (tf0_re),
            .w_im     (tf0_im),
            .x_re     (bf0_z_re),
            .x_im     (bf0_z_im),
            .x_nd     (bf0_z_nd),
            .c_out    (tm0_c_out),
            .m_out    (tm0_m_out),
            .z_re     (tm0_z_re),
            .z_im     (tm0_z_im),
            .z_nd     (tm0_z_nd)
          );

        fft_r22sdf_bf2 #(
            .S_INDX   (1),
            .N_LOG2   (N_LOG2),
            .X_WDTH   (BF1_X_WDTH),
            .M_WDTH   (META_WDTH)
          )
          fft_r22sdf_bf2_s1 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (tm0_c_out),
            .m_in     (tm0_m_out),
            .x_re     (tm0_z_re),
            .x_im     (tm0_z_im),
            .x_nd     (tm0_z_nd),
            .c_out    (bf1_c_out),
            .m_out    (bf1_m_out),
            .z_re     (bf1_z_re),
            .z_im     (bf1_z_im),
            .z_nd     (bf1_z_nd)
          );
      end
  endgenerate

  /* Instantiate stage-2 butterflies (if required). */
  generate
    if (NUM_BF2_STAGES > 2)
      begin: bf_stage2
        fft_r22sdf_tfm #(
            .W_WDTH   (TF_WDTH),
            .X_WDTH   (TM1_X_WDTH),
            .Z_WDTH   (TM1_Z_WDTH),
            .M_WDTH   (META_WDTH),
            .C_WDTH   (N_LOG2)
          )
          fft_r22sdf_tfm_tm1 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (bf1_c_out),
            .m_in     (bf1_m_out),
            .w_re     (tf1_re),
            .w_im     (tf1_im),
            .x_re     (bf1_z_re),
            .x_im     (bf1_z_im),
            .x_nd     (bf1_z_nd),
            .c_out    (tm1_c_out),
            .m_out    (tm1_m_out),
            .z_re     (tm1_z_re),
            .z_im     (tm1_z_im),
            .z_nd     (tm1_z_nd)
          );

        fft_r22sdf_bf2 #(
            .S_INDX   (2),
            .N_LOG2   (N_LOG2),
            .X_WDTH   (BF2_X_WDTH),
            .M_WDTH   (META_WDTH)
          )
          fft_r22sdf_bf2_s2 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (tm1_c_out),
            .m_in     (tm1_m_out),
            .x_re     (tm1_z_re),
            .x_im     (tm1_z_im),
            .x_nd     (tm1_z_nd),
            .c_out    (bf2_c_out),
            .m_out    (bf2_m_out),
            .z_re     (bf2_z_re),
            .z_im     (bf2_z_im),
            .z_nd     (bf2_z_nd)
          );
      end
  endgenerate

  /* Instantiate stage-3 butterflies (if required). */
  generate
    if (NUM_BF2_STAGES > 3)
      begin: bf_stage3
        fft_r22sdf_tfm #(
            .W_WDTH   (TF_WDTH),
            .X_WDTH   (TM2_X_WDTH),
            .Z_WDTH   (TM2_Z_WDTH),
            .M_WDTH   (META_WDTH),
            .C_WDTH   (N_LOG2)
          )
          fft_r22sdf_tfm_tm2 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (bf2_c_out),
            .m_in     (bf2_m_out),
            .w_re     (tf2_re),
            .w_im     (tf2_im),
            .x_re     (bf2_z_re),
            .x_im     (bf2_z_im),
            .x_nd     (bf2_z_nd),
            .c_out    (tm2_c_out),
            .m_out    (tm2_m_out),
            .z_re     (tm2_z_re),
            .z_im     (tm2_z_im),
            .z_nd     (tm2_z_nd)
          );

        fft_r22sdf_bf2 #(
            .S_INDX   (3),
            .N_LOG2   (N_LOG2),
            .X_WDTH   (BF3_X_WDTH),
            .M_WDTH   (META_WDTH)
          )
          fft_r22sdf_bf2_s3 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (tm2_c_out),
            .m_in     (tm2_m_out),
            .x_re     (tm2_z_re),
            .x_im     (tm2_z_im),
            .x_nd     (tm2_z_nd),
            .c_out    (bf3_c_out),
            .m_out    (bf3_m_out),
            .z_re     (bf3_z_re),
            .z_im     (bf3_z_im),
            .z_nd     (bf3_z_nd)
          );
      end
  endgenerate

  /* Instantiate stage-4 butterflies (if required). */
  generate
    if (NUM_BF2_STAGES > 4)
      begin: bf_stage4
        fft_r22sdf_tfm #(
            .W_WDTH   (TF_WDTH),
            .X_WDTH   (TM3_X_WDTH),
            .Z_WDTH   (TM3_Z_WDTH),
            .M_WDTH   (META_WDTH),
            .C_WDTH   (N_LOG2)
          )
          fft_r22sdf_tfm_tm3 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (bf3_c_out),
            .m_in     (bf3_m_out),
            .w_re     (tf3_re),
            .w_im     (tf3_im),
            .x_re     (bf3_z_re),
            .x_im     (bf3_z_im),
            .x_nd     (bf3_z_nd),
            .c_out    (tm3_c_out),
            .m_out    (tm3_m_out),
            .z_re     (tm3_z_re),
            .z_im     (tm3_z_im),
            .z_nd     (tm3_z_nd)
          );

        fft_r22sdf_bf2 #(
            .S_INDX   (4),
            .N_LOG2   (N_LOG2),
            .X_WDTH   (BF4_X_WDTH),
            .M_WDTH   (META_WDTH)
          )
          fft_r22sdf_bf2_s4 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (tm3_c_out),
            .m_in     (tm3_m_out),
            .x_re     (tm3_z_re),
            .x_im     (tm3_z_im),
            .x_nd     (tm3_z_nd),
            .c_out    (bf4_c_out),
            .m_out    (bf4_m_out),
            .z_re     (bf4_z_re),
            .z_im     (bf4_z_im),
            .z_nd     (bf4_z_nd)
          );
      end
  endgenerate

  /* Instantiate stage-5 butterflies (if required). */
  generate
    if (NUM_BF2_STAGES > 5)
      begin: bf_stage5
        fft_r22sdf_tfm #(
            .W_WDTH   (TF_WDTH),
            .X_WDTH   (TM4_X_WDTH),
            .Z_WDTH   (TM4_Z_WDTH),
            .M_WDTH   (META_WDTH),
            .C_WDTH   (N_LOG2)
          )
          fft_r22sdf_tfm_tm4 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (bf4_c_out),
            .m_in     (bf4_m_out),
            .w_re     (tf4_re),
            .w_im     (tf4_im),
            .x_re     (bf4_z_re),
            .x_im     (bf4_z_im),
            .x_nd     (bf4_z_nd),
            .c_out    (tm4_c_out),
            .m_out    (tm4_m_out),
            .z_re     (tm4_z_re),
            .z_im     (tm4_z_im),
            .z_nd     (tm4_z_nd)
          );

        fft_r22sdf_bf2 #(
            .S_INDX   (5),
            .N_LOG2   (N_LOG2),
            .X_WDTH   (BF5_X_WDTH),
            .M_WDTH   (META_WDTH)
          )
          fft_r22sdf_bf2_s5 (
            .clk      (clk),
            .rst_n    (rst_n),
            .c_in     (tm4_c_out),
            .m_in     (tm4_m_out),
            .x_re     (tm4_z_re),
            .x_im     (tm4_z_im),
            .x_nd     (tm4_z_nd),
            .c_out    (bf5_c_out),
            .m_out    (bf5_m_out),
            .z_re     (bf5_z_re),
            .z_im     (bf5_z_im),
            .z_nd     (bf5_z_nd)
          );
      end
  endgenerate

  /* Instantiate twiddle-factor ROMs for the requested FFT length. */
  generate
    case (N)
      16:
        begin
          fft_r22sdf_rom_16_s0 fft_r22sdf_rom_16_s0_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf0_c_out[3:0] - 4'd11),
              .addr_vld (bf0_z_nd),
              .tf_re    (tf0_re),
              .tf_im    (tf0_im)
            );
        end

      64:
        begin
          fft_r22sdf_rom_64_s0 fft_r22sdf_rom_64_s0_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf0_c_out[5:0] - 6'd47),
              .addr_vld (bf0_z_nd),
              .tf_re    (tf0_re),
              .tf_im    (tf0_im)
            );

          fft_r22sdf_rom_64_s1 fft_r22sdf_rom_64_s1_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf1_c_out[3:0] - 4'd11),
              .addr_vld (bf1_z_nd),
              .tf_re    (tf1_re),
              .tf_im    (tf1_im)
            );
        end

      256:
        begin
          fft_r22sdf_rom_256_s0 fft_r22sdf_rom_256_s0_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf0_c_out[7:0] - 8'd191),
              .addr_vld (bf0_z_nd),
              .tf_re    (tf0_re),
              .tf_im    (tf0_im)
            );

          fft_r22sdf_rom_256_s1 fft_r22sdf_rom_256_s1_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf1_c_out[5:0] - 6'd47),
              .addr_vld (bf1_z_nd),
              .tf_re    (tf1_re),
              .tf_im    (tf1_im)
            );

          fft_r22sdf_rom_256_s2 fft_r22sdf_rom_256_s2_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf2_c_out[3:0] - 4'd11),
              .addr_vld (bf2_z_nd),
              .tf_re    (tf2_re),
              .tf_im    (tf2_im)
            );
        end

      1024:
        begin
          fft_r22sdf_rom_1024_s0 fft_r22sdf_rom_1024_s0_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf0_c_out[9:0] - 10'd767),
              .addr_vld (bf0_z_nd),
              .tf_re    (tf0_re),
              .tf_im    (tf0_im)
            );

          fft_r22sdf_rom_1024_s1 fft_r22sdf_rom_1024_s1_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf1_c_out[7:0] - 8'd191),
              .addr_vld (bf1_z_nd),
              .tf_re    (tf1_re),
              .tf_im    (tf1_im)
            );

          fft_r22sdf_rom_1024_s2 fft_r22sdf_rom_1024_s2_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf2_c_out[5:0] - 6'd47),
              .addr_vld (bf2_z_nd),
              .tf_re    (tf2_re),
              .tf_im    (tf2_im)
            );

          fft_r22sdf_rom_1024_s3 fft_r22sdf_rom_1024_s3_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf3_c_out[3:0] - 4'd11),
              .addr_vld (bf3_z_nd),
              .tf_re    (tf3_re),
              .tf_im    (tf3_im)
            );
        end

      4096:
        begin
          fft_r22sdf_rom_4096_s0 fft_r22sdf_rom_4096_s0_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf0_c_out[11:0] - 12'd3071),
              .addr_vld (bf0_z_nd),
              .tf_re    (tf0_re),
              .tf_im    (tf0_im)
            );
       
          fft_r22sdf_rom_4096_s1 fft_r22sdf_rom_4096_s1_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf1_c_out[9:0] - 10'd767),
              .addr_vld (bf1_z_nd),
              .tf_re    (tf1_re),
              .tf_im    (tf1_im)
            );

          fft_r22sdf_rom_4096_s2 fft_r22sdf_rom_4096_s2_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf2_c_out[7:0] - 8'd191),
              .addr_vld (bf2_z_nd),
              .tf_re    (tf2_re),
              .tf_im    (tf2_im)
            );

          fft_r22sdf_rom_4096_s3 fft_r22sdf_rom_4096_s3_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf3_c_out[5:0] - 6'd47),
              .addr_vld (bf3_z_nd),
              .tf_re    (tf3_re),
              .tf_im    (tf3_im)
            );

          fft_r22sdf_rom_4096_s4 fft_r22sdf_rom_4096_s4_u1 (
              .clk      (clk),
              .rst_n    (rst_n),
              .addr     (bf4_c_out[3:0] - 4'd11),
              .addr_vld (bf4_z_nd),
              .tf_re    (tf4_re),
              .tf_im    (tf4_im)
            );
        end

      default:
        begin
          assign tf0_re = {TF_WDTH{1'b0}};
          assign tf0_im = {TF_WDTH{1'b0}};
        end
    endcase
  endgenerate

  // initial
  //   begin
  //    `ifndef USE_RESET
  //     dout_re   = {DOUT_WDTH{1'b0}};
  //     dout_im   = {DOUT_WDTH{1'b0}};
  //     dout_meta = {META_WDTH{1'b0}};
  //     dout_nd   =  1'b0;
  //     oe        =  1'b0;
  //     ctrl_cntr = {N_LOG2{1'b0}};
  //    `endif
  //   end

  /* Create the FFT controller logic. */
  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin
         //`ifdef USE_RESET
          dout_re   <= {DOUT_WDTH{1'b0}};
          dout_im   <= {DOUT_WDTH{1'b0}};
          dout_meta <= {META_WDTH{1'b0}};
          dout_nd   <=  1'b0;
          oe        <=  1'b0;
          ctrl_cntr <= {N_LOG2{1'b0}};
        // `endif
        end
      else
        begin
          dout_re   <= bf_out_re;
          dout_im   <= bf_out_im;
          dout_meta <= bf_out_meta;
          dout_nd   <= bf_out_nd & oe;

          if (bf_out_nd && (bf_out_cntr == N-2))
            begin
              oe <= 1'b1;
            end

          if (din_nd)
            begin
              ctrl_cntr <= ctrl_cntr + 1'b1;
            end
        end
    end

endmodule

/** @} */ /* End of addtogroup TopMiscIpDspFftR22Sdc */
/* END OF FILE */
