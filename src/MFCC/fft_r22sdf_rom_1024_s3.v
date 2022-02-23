`timescale 1ns/10ps

module fft_r22sdf_rom_1024_s3 (
    input  wire               clk,
    input  wire               rst_n,
    input  wire        [ 3:0] addr,
    input  wire               addr_vld,
    output reg signed [ 9:0] tf_re,
    output reg signed [ 9:0] tf_im
  );



  // assign tf_re = dout[19:10];
  // assign tf_im = dout[ 9: 0];

  // initial
  //   begin
  //    `ifndef USE_RESET
  //     dout = 20'd0;
  //    `endif
  //   end

 reg  [19:0] dout[0:1023];

initial begin
dout[0] = { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */
dout[1] = { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */
dout[2] = { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */
dout[3] = { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */
dout[4] = { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */
dout[5] = { 10'sd362   , -10'sd362   }; /* W[ 128] =  0.7070  -0.7070i */
dout[6] = { 10'sd0     , -10'sd512   }; /* W[ 256] =  0.0000  -1.0000i */
dout[7] = {-10'sd362   , -10'sd362   }; /* W[ 384] = -0.7070  -0.7070i */
dout[8] = { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */
dout[9] = { 10'sd473   , -10'sd196   }; /* W[  64] =  0.9238  -0.3828i */
dout[10] = { 10'sd362   , -10'sd362   }; /* W[ 128] =  0.7070  -0.7070i */
dout[11] = { 10'sd196   , -10'sd473   }; /* W[ 192] =  0.3828  -0.9238i */
dout[12] = { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */
dout[13] = { 10'sd196   , -10'sd473   }; /* W[ 192] =  0.3828  -0.9238i */
dout[14] = {-10'sd362   , -10'sd362   }; /* W[ 384] = -0.7070  -0.7070i */
dout[15] = {-10'sd473   ,  10'sd196   }; /* W[ 576] = -0.9238   0.3828i */
end

always @ (posedge clk) begin
  tf_re<=dout[addr][19:10];
  tf_im<=dout[addr][9:0];
end


endmodule

/** @} */ /* End of addtogroup ModMiscIpDspFftR22Sdc */
/* END OF FILE */
