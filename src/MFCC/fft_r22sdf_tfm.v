`timescale 1ns/10ps
/******************************************************************************
 * Copyright (c) 2010-2012, XIONLOGIC LIMITED                                 *
 * Copyright (c) 2010-2012, Niroshan Mahasinghe                               *
 * All rights reserved.                                                       *
 *                                                                            *
 * Redistribution and use in source and binary forms, with or without         *
 * modification, are permitted provided that the following conditions         *
 * are met:                                                                   *
 *                                                                            *
 *  o  Redistributions of source code must retain the above copyright         *
 *     notice, this list of conditions and the following disclaimer.          *
 *                                                                            *
 *  o  Redistributions in binary form must reproduce the above copyright      *
 *     notice, this list of conditions and the following disclaimer in        *
 *     the documentation and/or other materials provided with the             *
 *     distribution.                                                          *
 *                                                                            *
 *  o  Neither the name of XIONLOGIC LIMITED nor the names of its             *
 *     contributors may be used to endorse or promote products                *
 *     derived from this software without specific prior                      *
 *     written permission.                                                    *
 *                                                                            *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS        *
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED  *
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR *
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR          *
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,      *
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,        *
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR         *
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF     *
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING       *
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS         *
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.               *
 *****************************************************************************/

/*****************************************************************************
 *  Original Author(s):
 *      Niroshan Mahasinghe, nmahasinghe@xionlogic.com
 *****************************************************************************/
/** \file
 * \ingroup ModMiscIpDspFftR22Sdc
 * Radix-2<sup>2</sup> FFT twiddle-factor multiplier.
 * This file implements the radix-2<sup>2</sup> FFT twiddle-factor multiplier.
 */

/***************************************************************************
 * Include files
 ***************************************************************************/
// `include "system.vh"

/***************************************************************************
 * Modules
 ***************************************************************************/
/** \addtogroup ModMiscIpDspFftR22Sdc
 * @{ */

/** Radix-2<sup>2</sup> FFT twiddle-factor multiplier.
 * This module implements the Radix-2<sup>2</sup> FFT twiddle-factor multiplier.
 *
 * \param[in]  clk      System clock.
 * \param[in]  rst_n    Active low asynchronous reset line.
 * \param[in]  c_in     Radix-2<sup>2</sup> butterfly control counter.
 * \param[in]  m_in     Meta-data to pass through the pipeline.
 * \param[in]  w_re     Real part of the twiddle factor, Re{w(n)}.
 * \param[in]  w_im     Imaginary part of the twiddle factor, Im{w(n)}.
 * \param[in]  x_re     Real part of the input data word, Re{x(n)}.
 * \param[in]  x_im     Imaginary part of the input data word, Im{x(n)}.
 * \param[in]  x_nd     Indicates new data on \a w_re/w_im inputs.
 * \param[out] c_out    Control counter passed through the pipeline.
 * \param[out] m_out    Meta-data passed through the pipeline.
 * \param[out] z_re     Real part of the result, Re{x(n).w(n)}.
 * \param[out] z_im     Imaginary part of the result, Im{x(n).w(n)}.
 * \param[out] z_nd     Indicates new data on \a z outputs.
 * \par
 * \param[in]  W_WDTH   Re{w(n)}/Im{w(n)} data width.
 * \param[in]  X_WDTH   Re{x(n)}/Im{x(n)} data width.
 * \param[in]  Z_WDTH   Re{Z(n)}/Im{Z(n)} data width.
 * \param[in]  C_WDTH   Butterfly control counter width.
 * \param[in]  M_WDTH   Meta-data width.
 */
module fft_r22sdf_tfm #(
    parameter                        W_WDTH  = 0,
    parameter                        X_WDTH  = 0,
    parameter                        Z_WDTH  = 0,
    parameter                        C_WDTH  = 0,
    parameter                        M_WDTH  = 0
  )
  (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire         [C_WDTH-1:0] c_in,
    input  wire         [M_WDTH-1:0] m_in,
    input  wire signed  [W_WDTH-1:0] w_re,
    input  wire signed  [W_WDTH-1:0] w_im,
    input  wire signed  [X_WDTH-1:0] x_re,
    input  wire signed  [X_WDTH-1:0] x_im,
    input  wire                      x_nd,
    output  reg         [C_WDTH-1:0] c_out,
    output  reg         [M_WDTH-1:0] m_out,
    output  reg signed  [Z_WDTH-1:0] z_re,
    output  reg signed  [Z_WDTH-1:0] z_im,
    output  reg                      z_nd
  );

  localparam                     P_WDTH    = X_WDTH + W_WDTH;
  localparam                     S_WDTH    = P_WDTH + 1;
  localparam signed [Z_WDTH-1:0] RND_CONST = 2**(S_WDTH-Z_WDTH-3);
  localparam                     PPLN_DPTH = 3;

  reg  signed [W_WDTH-1:0] ppln_w_re[0:0];
  reg  signed [W_WDTH-1:0] ppln_w_im[0:0];
  reg  signed [X_WDTH-1:0] ppln_x_re[0:0];
  reg  signed [X_WDTH-1:0] ppln_x_im[0:0];
  reg  signed [P_WDTH-1:0] ppln_mul0[1:1];
  reg  signed [P_WDTH-1:0] ppln_mul1[1:1];
  reg  signed [P_WDTH-1:0] ppln_mul2[1:1];
  reg  signed [P_WDTH-1:0] ppln_mul3[1:1];
  reg  signed [S_WDTH-1:0] ppln_z_re[2:2];
  reg  signed [S_WDTH-1:0] ppln_z_im[2:2];

  reg         [C_WDTH-1:0] ppln_cntr[PPLN_DPTH-1:0];
  reg         [M_WDTH-1:0] ppln_meta[PPLN_DPTH-1:0];
  reg      [PPLN_DPTH-1:0] ppln_nd;
  integer                  i;

  // initial
  //   begin
  //    `ifndef USE_RESET
  //     z_nd         = 1'b0;
  //     z_re         = {Z_WDTH{1'b0}};
  //     z_im         = {Z_WDTH{1'b0}};
  //     m_out        = {M_WDTH{1'b0}};
  //     ppln_w_re[0] = {W_WDTH{1'b0}};
  //     ppln_w_im[0] = {W_WDTH{1'b0}};
  //     ppln_x_re[0] = {X_WDTH{1'b0}};
  //     ppln_x_im[0] = {X_WDTH{1'b0}};
  //     ppln_mul0[1] = {P_WDTH{1'b0}};
  //     ppln_mul1[1] = {P_WDTH{1'b0}};
  //     ppln_mul2[1] = {P_WDTH{1'b0}};
  //     ppln_mul3[1] = {P_WDTH{1'b0}};
  //     ppln_z_re[2] = {S_WDTH{1'b0}};
  //     ppln_z_im[2] = {S_WDTH{1'b0}};
  //     ppln_nd      = {PPLN_DPTH{1'b0}};
  //     for (i = 0; i < PPLN_DPTH; i = i+1) ppln_cntr[i] = {C_WDTH{1'b0}};
  //     for (i = 0; i < PPLN_DPTH; i = i+1) ppln_meta[i] = {M_WDTH{1'b0}};
  //    `endif
  //   end

  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin
         //`ifdef USE_RESET
          z_nd         <= 1'b0;
          z_re         <= {Z_WDTH{1'b0}};
          z_im         <= {Z_WDTH{1'b0}};
          m_out        <= {M_WDTH{1'b0}};
          ppln_w_re[0] <= {W_WDTH{1'b0}};
          ppln_w_im[0] <= {W_WDTH{1'b0}};
          ppln_x_re[0] <= {X_WDTH{1'b0}};
          ppln_x_im[0] <= {X_WDTH{1'b0}};
          ppln_mul0[1] <= {P_WDTH{1'b0}};
          ppln_mul1[1] <= {P_WDTH{1'b0}};
          ppln_mul2[1] <= {P_WDTH{1'b0}};
          ppln_mul3[1] <= {P_WDTH{1'b0}};
          ppln_z_re[2] <= {S_WDTH{1'b0}};
          ppln_z_im[2] <= {S_WDTH{1'b0}};
          ppln_nd      <= {PPLN_DPTH{1'b0}};
          for (i = 0; i < PPLN_DPTH; i = i+1) ppln_cntr[i] <= {C_WDTH{1'b0}};
          for (i = 0; i < PPLN_DPTH; i = i+1) ppln_meta[i] <= {M_WDTH{1'b0}};
         //`endif
        end
      else
        begin
          /* PIPELINE STAGE 0:
           *   1. Locally register inputs.
           */
          ppln_cntr[0] <= c_in;
          ppln_meta[0] <= m_in;
          ppln_w_re[0] <= w_re;
          ppln_w_im[0] <= w_im;
          ppln_x_re[0] <= x_re;
          ppln_x_im[0] <= x_im;
          ppln_nd  [0] <= x_nd;

          /* PIPELINE STAGE 1:
           *   1. Compute the products.
           *        Note that we pre-add the rounding constants here instead of
           *        adding them after the summation. This allows synthesis to 
           *        infer built-in rounding logic available within DSP48A1
           *        tiles of Spartan-6 FPGAs. For Spartan-3 FPGAs, we have no
           *        choice other than to add the rounding constants after the 
           *        summation.
           */
        //  `ifdef USE_DSP48A1_TILES
        //   ppln_mul0[1] <= ppln_x_re[0] * ppln_w_re[0] + RND_CONST;
        //   ppln_mul1[1] <= ppln_x_im[0] * ppln_w_im[0];
        //   ppln_mul2[1] <= ppln_x_im[0] * ppln_w_re[0] + RND_CONST;
        //   ppln_mul3[1] <= ppln_x_re[0] * ppln_w_im[0];
        //  `else
          ppln_mul0[1] <= ppln_x_re[0] * ppln_w_re[0];
          ppln_mul1[1] <= ppln_x_im[0] * ppln_w_im[0];
          ppln_mul2[1] <= ppln_x_im[0] * ppln_w_re[0];
          ppln_mul3[1] <= ppln_x_re[0] * ppln_w_im[0];
        //  `endif
          ppln_cntr[1] <= ppln_cntr[0];
          ppln_meta[1] <= ppln_meta[0];
          ppln_nd  [1] <= ppln_nd  [0];

          /* PIPELINE STAGE 2:
           *   1. Compute the sums.
           *   2. Add the rounding constants here if synthesising for Spartan-3 
           *      FPGAs.
           */
        //  `ifdef USE_DSP48A1_TILES
        //   ppln_z_re[2] <= ppln_mul0[1] - ppln_mul1[1];
        //   ppln_z_im[2] <= ppln_mul2[1] + ppln_mul3[1];
        //  `else
          ppln_z_re[2] <= ppln_mul0[1] - ppln_mul1[1] + RND_CONST;
          ppln_z_im[2] <= ppln_mul2[1] + ppln_mul3[1] + RND_CONST;
        //  `endif
          ppln_cntr[2] <= ppln_cntr[1];
          ppln_meta[2] <= ppln_meta[1];
          ppln_nd  [2] <= ppln_nd  [1];

          /* PIPELINE STAGE 3:
           *   1. Scale the sums and update the outputs.
           */
          z_re         <= ppln_z_re[2][S_WDTH-3 -:Z_WDTH];
          z_im         <= ppln_z_im[2][S_WDTH-3 -:Z_WDTH];
          c_out        <= ppln_cntr[2];
          m_out        <= ppln_meta[2];
          z_nd         <= ppln_nd  [2];
        end
    end

endmodule

/** @} */ /* End of addtogroup ModMiscIpDspFftR22Sdc */
/* END OF FILE */
