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
 * Radix-2<sup>2</sup> SDF FFT butterfly.
 * This file implements a radix-2<sup>2</sup> SDF FFT butterfly.
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

/** Radix-2<sup>2</sup> SDF FFT butterfly.
 * This module implements a radix-2<sup>2</sup> single-path delay feedback FFT
 * butterfly stage. It computes a 4-point DFT and is used as the basic building
 * block for constructing radix-2<sup>2</sup> SDF pipelined FFT structure shown
 * below. The composite butterfly stage consists of 2 sub-components, referred
 * to as BF2-I and BF2-II, connected in series. The BF2-I unit performs a standard
 * radix-2 butterfly operation while the later unit performs either a standard
 * radix-2 butterfly operation or multiplication by \a -j followed by a standard
 * radix-2 butterfly operation. The shift registers are pre-built into the
 * butterfly units for convenience.
 * \image html fft_r22sdf.svg "Radix-2^2 SDF FFT Architecture"
 *
 * \param[in]  clk       System clock.
 * \param[in]  rst_n     Active low asynchronous reset line.
 * \param[in]  c_in      Radix-2<sup>2</sup> butterfly control counter.
 * \param[in]  m_in      Meta-data to pass through the pipeline.
 * \param[in]  x_re      Real part of the input, \a Re{x(n)}.
 * \param[in]  x_im      Imaginary part of the input, \a Im{x(n)}.
 * \param[in]  x_nd      Indicates new data on \a x_re/x_im inputs.
 * \param[out] c_out     Control counter passed through the pipeline.
 * \param[out] m_out     Meta-data passed through the pipeline.
 * \param[out] z_re      Real part of the output, \a Re{Z(n)}.
 * \param[out] z_im      Imaginary part of the output, \a Im{Z(n)}.
 * \param[out] z_nd      Indicates new data on \a z_re/x_im outputs.
 * \par
 * \param[in]  N_LOG2    FFT length in log<sub>2</sub>.
 * \param[in]  S_INDX    Butterfly stage index, {0..log<sub>4</sub>(N)-1}.
 * \param[in]  X_WDTH    \a Re{x(n)}/Im{x(n)} data width.
 * \param[in]  M_WDTH    Meta-data width (must be at least 1).
 */
module fft_r22sdf_bf2 #(
    parameter                        N_LOG2 = 0,
    parameter                        S_INDX = 0,
    parameter                        X_WDTH = 0,
    parameter                        M_WDTH = 0
  )
  (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire         [N_LOG2-1:0] c_in,
    input  wire         [M_WDTH-1:0] m_in,
    input  wire signed  [X_WDTH-1:0] x_re,
    input  wire signed  [X_WDTH-1:0] x_im,
    input  wire                      x_nd,
    output wire         [N_LOG2-1:0] c_out,
    output wire         [M_WDTH-1:0] m_out,
    output wire signed  [X_WDTH+1:0] z_re,
    output wire signed  [X_WDTH+1:0] z_im,
    output wire                      z_nd
  );

  wire        [N_LOG2-1:0] bf2i_ccntr;
  wire signed [M_WDTH-1:0] bf2i_meta;
  wire signed [X_WDTH  :0] bf2i_z_re;
  wire signed [X_WDTH  :0] bf2i_z_im;
  wire                     bf2i_z_nd;

  fft_r22sdf_bf2i #(
      .FSR_LEN  (2**(N_LOG2-2*S_INDX-1)),
      .X_WDTH   (X_WDTH),
      .M_WDTH   (N_LOG2+M_WDTH)
    )
    fft_r22sdf_bf2i_u1 (
      .clk      (clk),
      .rst_n    (rst_n),
      .sel      (c_in[N_LOG2-2*S_INDX-1]),
      .m_in     ({c_in, m_in}),
      .x_re     (x_re),
      .x_im     (x_im),
      .x_nd     (x_nd),
      .m_out    ({bf2i_ccntr, bf2i_meta}),
      .z_re     (bf2i_z_re),
      .z_im     (bf2i_z_im),
      .z_nd     (bf2i_z_nd)
    );

  fft_r22sdf_bf2ii #(
      .FSR_LEN  (2**(N_LOG2-2*S_INDX-2)),
      .X_WDTH   (X_WDTH+1),
      .M_WDTH   (N_LOG2+M_WDTH)
    )
    fft_r22sdf_bf2ii_u1 (
      .clk      (clk),
      .rst_n    (rst_n),
      .tgl      (bf2i_ccntr[N_LOG2-2*S_INDX-1]),
      .sel      (bf2i_ccntr[N_LOG2-2*S_INDX-2]),
      .m_in     ({bf2i_ccntr, bf2i_meta}),
      .x_re     (bf2i_z_re),
      .x_im     (bf2i_z_im),
      .x_nd     (bf2i_z_nd),
      .m_out    ({c_out, m_out}),
      .z_re     (z_re),
      .z_im     (z_im),
      .z_nd     (z_nd)
    );

endmodule

/** @} */ /* End of addtogroup ModMiscIpDspFftR22Sdc */
/* END OF FILE */
