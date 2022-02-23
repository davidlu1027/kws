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
 * Radix-2<sup>2</sup> FFT butterfly Type-II.
 * This file implements the radix-2<sup>2</sup> FFT butterfly Type-II.
 */

/***************************************************************************
 * Include files
//  ***************************************************************************/
// `include "system.vh"

/***************************************************************************
 * Modules
 ***************************************************************************/
/** \addtogroup ModMiscIpDspFftR22Sdc
 * @{ */

/** Radix-2<sup>2</sup> FFT butterfly Type-II.
 * This module implements the Radix-2<sup>2</sup> FFT butterfly Type-II shown 
 * below:
 *
 * \param[in]  clk      System clock.
 * \param[in]  rst_n    Active low asynchronous reset line.
 * \param[in]  tgl      Trivial twiddle-factor multiplication mode select line.
 * \param[in]  sel      Butterfly select line.
 * \param[in]  m_in     Meta-data to pass through the pipeline.
 * \param[in]  x_re     \a Re{x(n+N/2)}.
 * \param[in]  x_im     \a Im{x(n+N/2)}.
 * \param[in]  x_nd     Indicates new data on \a x_re/x_im inputs.
 * \param[out] m_out    Meta-data passed through the pipeline.
 * \param[out] z_re     \a Re{Z(n)}.
 * \param[out] z_im     \a Im{Z(n)}.
 * \param[out] z_nd     Indicates new data on \a z_re/z_im outputs.
 * \par
 * \param[in]  FSR_LEN  Feedback shift-register length.
 * \param[in]  X_WDTH   \a Re{x(n+N/2)}/Im{x(n+N/2)} data width.
 * \param[in]  M_WDTH   Meta-data width.
 */
module fft_r22sdf_bf2ii #(
    parameter                        FSR_LEN = 0,
    parameter                        X_WDTH  = 0,
    parameter                        M_WDTH  = 0
  )
  (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire                      tgl,
    input  wire                      sel,
    input  wire         [M_WDTH-1:0] m_in,
    input  wire signed  [X_WDTH-1:0] x_re,
    input  wire signed  [X_WDTH-1:0] x_im,
    input  wire                      x_nd,
    output  reg         [M_WDTH-1:0] m_out,
    output  reg signed  [X_WDTH  :0] z_re,
    output  reg signed  [X_WDTH  :0] z_im,
    output  reg                      z_nd
  );

  localparam   Z_WDTH = X_WDTH + 1;

  reg         [Z_WDTH-1:0] fsr_re[FSR_LEN-1:0];
  reg         [Z_WDTH-1:0] fsr_im[FSR_LEN-1:0];
  integer                  i, k;

  wire signed [Z_WDTH-1:0] xa_re;
  wire signed [Z_WDTH-1:0] xa_im;
  wire signed [Z_WDTH-1:0] xb_re;
  wire signed [Z_WDTH-1:0] xb_im;
  reg  signed [Z_WDTH-1:0] za_re;
  reg  signed [Z_WDTH-1:0] za_im;
  reg  signed [Z_WDTH-1:0] zb_re;
  reg  signed [Z_WDTH-1:0] zb_im;

  assign xa_re = fsr_re[FSR_LEN-1];
  assign xa_im = fsr_im[FSR_LEN-1];
  assign xb_re = {{Z_WDTH-X_WDTH{x_re[X_WDTH-1]}}, x_re};
  assign xb_im = {{Z_WDTH-X_WDTH{x_im[X_WDTH-1]}}, x_im};

  // initial
  //   begin
  //    `ifndef USE_RESET
  //     z_nd  = 1'b0;
  //     z_re  = {Z_WDTH{1'b0}};
  //     z_im  = {Z_WDTH{1'b0}};
  //     m_out = {M_WDTH{1'b0}};
  //     for (i = 0; i < FSR_LEN; i = i+1) fsr_re[i] = {Z_WDTH{1'b0}};
  //     for (i = 0; i < FSR_LEN; i = i+1) fsr_im[i] = {Z_WDTH{1'b0}};
  //    `endif
  //   end

  always @*
    begin
      case ({sel, tgl})
        2'b10:
          begin
            za_re = xa_re + xb_im;
            za_im = xa_im - xb_re;
            zb_re = xa_re - xb_im;
            zb_im = xa_im + xb_re;
          end

        2'b11:
          begin
            za_re = xa_re + xb_re;
            za_im = xa_im + xb_im;
            zb_re = xa_re - xb_re;
            zb_im = xa_im - xb_im;
          end

        default:
          begin
            za_re = xa_re;
            za_im = xa_im;
            zb_re = xb_re;
            zb_im = xb_im;
          end
      endcase
    end

  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin
         //`ifdef USE_RESET
          z_nd <= 1'b0;
          z_re <= {Z_WDTH{1'b0}};
          z_im <= {Z_WDTH{1'b0}};
          for (i = 0; i < FSR_LEN; i = i+1) fsr_re[i] <= {Z_WDTH{1'b0}};
          for (i = 0; i < FSR_LEN; i = i+1) fsr_im[i] <= {Z_WDTH{1'b0}};
         //`endif
        end
      else
        begin
          if (x_nd)
            begin
              for (k = 0; k < FSR_LEN; k = k+1)
                begin
                  if (k == 0)
                    begin
                      fsr_re[k] <= zb_re;
                      fsr_im[k] <= zb_im;
                    end
                  else
                    begin
                      fsr_re[k] <= fsr_re[k-1];
                      fsr_im[k] <= fsr_im[k-1];
                    end
                end
            end
          m_out <= m_in;
          z_re  <= za_re;
          z_im  <= za_im;
          z_nd  <= x_nd;
        end
    end

endmodule

/** @} */ /* End of addtogroup ModMiscIpDspFftR22Sdc */
/* END OF FILE */
