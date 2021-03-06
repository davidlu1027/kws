`timescale 1ns/10ps
module fft_r22sdf_rom_1024_s1 (
    input  wire               clk,
    input  wire               rst_n,
    input  wire        [ 7:0] addr,
    input  wire               addr_vld,
    output reg signed [ 9:0] tf_re,
    output reg signed [ 9:0] tf_im
  );

  // reg  [19:0] dout;

  // assign tf_re = dout[19:10];
  // assign tf_im = dout[ 9: 0];

  // initial
  //   begin
  //    `ifndef USE_RESET
  //     dout = 20'd0;
  //    `endif
  //   end
 reg  [19:0] dout[0:255];
initial begin
dout[0]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[1]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[2]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[3]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[4]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[5]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[6]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[7]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[8]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[9]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[10]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[11]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[12]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[13]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[14]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[15]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[16]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[17]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[18]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[19]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[20]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[21]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[22]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[23]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[24]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[25]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[26]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[27]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[28]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[29]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[30]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[31]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[32]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[33]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[34]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[35]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[36]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[37]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[38]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[39]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[40]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[41]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[42]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[43]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[44]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[45]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[46]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[47]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[48]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[49]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[50]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[51]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[52]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[53]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[54]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[55]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[56]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[57]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[58]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[59]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[60]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[61]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[62]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[63]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[64]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[65]	= { 10'sd511   , -10'sd25    }; /* W[   8] =  0.9980  -0.0488i */	
dout[66]	= { 10'sd510   , -10'sd50    }; /* W[  16] =  0.9961  -0.0977i */	
dout[67]	= { 10'sd506   , -10'sd75    }; /* W[  24] =  0.9883  -0.1465i */	
dout[68]	= { 10'sd502   , -10'sd100   }; /* W[  32] =  0.9805  -0.1953i */	
dout[69]	= { 10'sd497   , -10'sd124   }; /* W[  40] =  0.9707  -0.2422i */	
dout[70]	= { 10'sd490   , -10'sd149   }; /* W[  48] =  0.9570  -0.2910i */	
dout[71]	= { 10'sd482   , -10'sd172   }; /* W[  56] =  0.9414  -0.3359i */	
dout[72]	= { 10'sd473   , -10'sd196   }; /* W[  64] =  0.9238  -0.3828i */	
dout[73]	= { 10'sd463   , -10'sd219   }; /* W[  72] =  0.9043  -0.4277i */	
dout[74]	= { 10'sd452   , -10'sd241   }; /* W[  80] =  0.8828  -0.4707i */	
dout[75]	= { 10'sd439   , -10'sd263   }; /* W[  88] =  0.8574  -0.5137i */	
dout[76]	= { 10'sd426   , -10'sd284   }; /* W[  96] =  0.8320  -0.5547i */	
dout[77]	= { 10'sd411   , -10'sd305   }; /* W[ 104] =  0.8027  -0.5957i */	
dout[78]	= { 10'sd396   , -10'sd325   }; /* W[ 112] =  0.7734  -0.6348i */	
dout[79]	= { 10'sd379   , -10'sd344   }; /* W[ 120] =  0.7402  -0.6719i */	
dout[80]	= { 10'sd362   , -10'sd362   }; /* W[ 128] =  0.7070  -0.7070i */	
dout[81]	= { 10'sd344   , -10'sd379   }; /* W[ 136] =  0.6719  -0.7402i */	
dout[82]	= { 10'sd325   , -10'sd396   }; /* W[ 144] =  0.6348  -0.7734i */	
dout[83]	= { 10'sd305   , -10'sd411   }; /* W[ 152] =  0.5957  -0.8027i */	
dout[84]	= { 10'sd284   , -10'sd426   }; /* W[ 160] =  0.5547  -0.8320i */	
dout[85]	= { 10'sd263   , -10'sd439   }; /* W[ 168] =  0.5137  -0.8574i */	
dout[86]	= { 10'sd241   , -10'sd452   }; /* W[ 176] =  0.4707  -0.8828i */	
dout[87]	= { 10'sd219   , -10'sd463   }; /* W[ 184] =  0.4277  -0.9043i */	
dout[88]	= { 10'sd196   , -10'sd473   }; /* W[ 192] =  0.3828  -0.9238i */	
dout[89]	= { 10'sd172   , -10'sd482   }; /* W[ 200] =  0.3359  -0.9414i */	
dout[90]	= { 10'sd149   , -10'sd490   }; /* W[ 208] =  0.2910  -0.9570i */	
dout[91]	= { 10'sd124   , -10'sd497   }; /* W[ 216] =  0.2422  -0.9707i */	
dout[92]	= { 10'sd100   , -10'sd502   }; /* W[ 224] =  0.1953  -0.9805i */	
dout[93]	= { 10'sd75    , -10'sd506   }; /* W[ 232] =  0.1465  -0.9883i */	
dout[94]	= { 10'sd50    , -10'sd510   }; /* W[ 240] =  0.0977  -0.9961i */	
dout[95]	= { 10'sd25    , -10'sd511   }; /* W[ 248] =  0.0488  -0.9980i */	
dout[96]	= { 10'sd0     , -10'sd512   }; /* W[ 256] =  0.0000  -1.0000i */	
dout[97]	= {-10'sd25    , -10'sd511   }; /* W[ 264] = -0.0488  -0.9980i */	
dout[98]	= {-10'sd50    , -10'sd510   }; /* W[ 272] = -0.0977  -0.9961i */	
dout[99]	= {-10'sd75    , -10'sd506   }; /* W[ 280] = -0.1465  -0.9883i */	
dout[100]	= {-10'sd100   , -10'sd502   }; /* W[ 288] = -0.1953  -0.9805i */	
dout[101]	= {-10'sd124   , -10'sd497   }; /* W[ 296] = -0.2422  -0.9707i */	
dout[102]	= {-10'sd149   , -10'sd490   }; /* W[ 304] = -0.2910  -0.9570i */	
dout[103]	= {-10'sd172   , -10'sd482   }; /* W[ 312] = -0.3359  -0.9414i */	
dout[104]	= {-10'sd196   , -10'sd473   }; /* W[ 320] = -0.3828  -0.9238i */	
dout[105]	= {-10'sd219   , -10'sd463   }; /* W[ 328] = -0.4277  -0.9043i */	
dout[106]	= {-10'sd241   , -10'sd452   }; /* W[ 336] = -0.4707  -0.8828i */	
dout[107]	= {-10'sd263   , -10'sd439   }; /* W[ 344] = -0.5137  -0.8574i */	
dout[108]	= {-10'sd284   , -10'sd426   }; /* W[ 352] = -0.5547  -0.8320i */	
dout[109]	= {-10'sd305   , -10'sd411   }; /* W[ 360] = -0.5957  -0.8027i */	
dout[110]	= {-10'sd325   , -10'sd396   }; /* W[ 368] = -0.6348  -0.7734i */	
dout[111]	= {-10'sd344   , -10'sd379   }; /* W[ 376] = -0.6719  -0.7402i */	
dout[112]	= {-10'sd362   , -10'sd362   }; /* W[ 384] = -0.7070  -0.7070i */	
dout[113]	= {-10'sd379   , -10'sd344   }; /* W[ 392] = -0.7402  -0.6719i */	
dout[114]	= {-10'sd396   , -10'sd325   }; /* W[ 400] = -0.7734  -0.6348i */	
dout[115]	= {-10'sd411   , -10'sd305   }; /* W[ 408] = -0.8027  -0.5957i */	
dout[116]	= {-10'sd426   , -10'sd284   }; /* W[ 416] = -0.8320  -0.5547i */	
dout[117]	= {-10'sd439   , -10'sd263   }; /* W[ 424] = -0.8574  -0.5137i */	
dout[118]	= {-10'sd452   , -10'sd241   }; /* W[ 432] = -0.8828  -0.4707i */	
dout[119]	= {-10'sd463   , -10'sd219   }; /* W[ 440] = -0.9043  -0.4277i */	
dout[120]	= {-10'sd473   , -10'sd196   }; /* W[ 448] = -0.9238  -0.3828i */	
dout[121]	= {-10'sd482   , -10'sd172   }; /* W[ 456] = -0.9414  -0.3359i */	
dout[122]	= {-10'sd490   , -10'sd149   }; /* W[ 464] = -0.9570  -0.2910i */	
dout[123]	= {-10'sd497   , -10'sd124   }; /* W[ 472] = -0.9707  -0.2422i */	
dout[124]	= {-10'sd502   , -10'sd100   }; /* W[ 480] = -0.9805  -0.1953i */	
dout[125]	= {-10'sd506   , -10'sd75    }; /* W[ 488] = -0.9883  -0.1465i */	
dout[126]	= {-10'sd510   , -10'sd50    }; /* W[ 496] = -0.9961  -0.0977i */	
dout[127]	= {-10'sd511   , -10'sd25    }; /* W[ 504] = -0.9980  -0.0488i */	
dout[128]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[129]	= { 10'sd511   , -10'sd13    }; /* W[   4] =  0.9980  -0.0254i */	
dout[130]	= { 10'sd511   , -10'sd25    }; /* W[   8] =  0.9980  -0.0488i */	
dout[131]	= { 10'sd511   , -10'sd38    }; /* W[  12] =  0.9980  -0.0742i */	
dout[132]	= { 10'sd510   , -10'sd50    }; /* W[  16] =  0.9961  -0.0977i */	
dout[133]	= { 10'sd508   , -10'sd63    }; /* W[  20] =  0.9922  -0.1230i */	
dout[134]	= { 10'sd506   , -10'sd75    }; /* W[  24] =  0.9883  -0.1465i */	
dout[135]	= { 10'sd504   , -10'sd88    }; /* W[  28] =  0.9844  -0.1719i */	
dout[136]	= { 10'sd502   , -10'sd100   }; /* W[  32] =  0.9805  -0.1953i */	
dout[137]	= { 10'sd500   , -10'sd112   }; /* W[  36] =  0.9766  -0.2188i */	
dout[138]	= { 10'sd497   , -10'sd124   }; /* W[  40] =  0.9707  -0.2422i */	
dout[139]	= { 10'sd493   , -10'sd137   }; /* W[  44] =  0.9629  -0.2676i */	
dout[140]	= { 10'sd490   , -10'sd149   }; /* W[  48] =  0.9570  -0.2910i */	
dout[141]	= { 10'sd486   , -10'sd161   }; /* W[  52] =  0.9492  -0.3145i */	
dout[142]	= { 10'sd482   , -10'sd172   }; /* W[  56] =  0.9414  -0.3359i */	
dout[143]	= { 10'sd478   , -10'sd184   }; /* W[  60] =  0.9336  -0.3594i */	
dout[144]	= { 10'sd473   , -10'sd196   }; /* W[  64] =  0.9238  -0.3828i */	
dout[145]	= { 10'sd468   , -10'sd207   }; /* W[  68] =  0.9141  -0.4043i */	
dout[146]	= { 10'sd463   , -10'sd219   }; /* W[  72] =  0.9043  -0.4277i */	
dout[147]	= { 10'sd457   , -10'sd230   }; /* W[  76] =  0.8926  -0.4492i */	
dout[148]	= { 10'sd452   , -10'sd241   }; /* W[  80] =  0.8828  -0.4707i */	
dout[149]	= { 10'sd445   , -10'sd252   }; /* W[  84] =  0.8691  -0.4922i */	
dout[150]	= { 10'sd439   , -10'sd263   }; /* W[  88] =  0.8574  -0.5137i */	
dout[151]	= { 10'sd433   , -10'sd274   }; /* W[  92] =  0.8457  -0.5352i */	
dout[152]	= { 10'sd426   , -10'sd284   }; /* W[  96] =  0.8320  -0.5547i */	
dout[153]	= { 10'sd419   , -10'sd295   }; /* W[ 100] =  0.8184  -0.5762i */	
dout[154]	= { 10'sd411   , -10'sd305   }; /* W[ 104] =  0.8027  -0.5957i */	
dout[155]	= { 10'sd404   , -10'sd315   }; /* W[ 108] =  0.7891  -0.6152i */	
dout[156]	= { 10'sd396   , -10'sd325   }; /* W[ 112] =  0.7734  -0.6348i */	
dout[157]	= { 10'sd388   , -10'sd334   }; /* W[ 116] =  0.7578  -0.6523i */	
dout[158]	= { 10'sd379   , -10'sd344   }; /* W[ 120] =  0.7402  -0.6719i */	
dout[159]	= { 10'sd371   , -10'sd353   }; /* W[ 124] =  0.7246  -0.6895i */	
dout[160]	= { 10'sd362   , -10'sd362   }; /* W[ 128] =  0.7070  -0.7070i */	
dout[161]	= { 10'sd353   , -10'sd371   }; /* W[ 132] =  0.6895  -0.7246i */	
dout[162]	= { 10'sd344   , -10'sd379   }; /* W[ 136] =  0.6719  -0.7402i */	
dout[163]	= { 10'sd334   , -10'sd388   }; /* W[ 140] =  0.6523  -0.7578i */	
dout[164]	= { 10'sd325   , -10'sd396   }; /* W[ 144] =  0.6348  -0.7734i */	
dout[165]	= { 10'sd315   , -10'sd404   }; /* W[ 148] =  0.6152  -0.7891i */	
dout[166]	= { 10'sd305   , -10'sd411   }; /* W[ 152] =  0.5957  -0.8027i */	
dout[167]	= { 10'sd295   , -10'sd419   }; /* W[ 156] =  0.5762  -0.8184i */	
dout[168]	= { 10'sd284   , -10'sd426   }; /* W[ 160] =  0.5547  -0.8320i */	
dout[169]	= { 10'sd274   , -10'sd433   }; /* W[ 164] =  0.5352  -0.8457i */	
dout[170]	= { 10'sd263   , -10'sd439   }; /* W[ 168] =  0.5137  -0.8574i */	
dout[171]	= { 10'sd252   , -10'sd445   }; /* W[ 172] =  0.4922  -0.8691i */	
dout[172]	= { 10'sd241   , -10'sd452   }; /* W[ 176] =  0.4707  -0.8828i */	
dout[173]	= { 10'sd230   , -10'sd457   }; /* W[ 180] =  0.4492  -0.8926i */	
dout[174]	= { 10'sd219   , -10'sd463   }; /* W[ 184] =  0.4277  -0.9043i */	
dout[175]	= { 10'sd207   , -10'sd468   }; /* W[ 188] =  0.4043  -0.9141i */	
dout[176]	= { 10'sd196   , -10'sd473   }; /* W[ 192] =  0.3828  -0.9238i */	
dout[177]	= { 10'sd184   , -10'sd478   }; /* W[ 196] =  0.3594  -0.9336i */	
dout[178]	= { 10'sd172   , -10'sd482   }; /* W[ 200] =  0.3359  -0.9414i */	
dout[179]	= { 10'sd161   , -10'sd486   }; /* W[ 204] =  0.3145  -0.9492i */	
dout[180]	= { 10'sd149   , -10'sd490   }; /* W[ 208] =  0.2910  -0.9570i */	
dout[181]	= { 10'sd137   , -10'sd493   }; /* W[ 212] =  0.2676  -0.9629i */	
dout[182]	= { 10'sd124   , -10'sd497   }; /* W[ 216] =  0.2422  -0.9707i */	
dout[183]	= { 10'sd112   , -10'sd500   }; /* W[ 220] =  0.2188  -0.9766i */	
dout[184]	= { 10'sd100   , -10'sd502   }; /* W[ 224] =  0.1953  -0.9805i */	
dout[185]	= { 10'sd88    , -10'sd504   }; /* W[ 228] =  0.1719  -0.9844i */	
dout[186]	= { 10'sd75    , -10'sd506   }; /* W[ 232] =  0.1465  -0.9883i */	
dout[187]	= { 10'sd63    , -10'sd508   }; /* W[ 236] =  0.1230  -0.9922i */	
dout[188]	= { 10'sd50    , -10'sd510   }; /* W[ 240] =  0.0977  -0.9961i */	
dout[189]	= { 10'sd38    , -10'sd511   }; /* W[ 244] =  0.0742  -0.9980i */	
dout[190]	= { 10'sd25    , -10'sd511   }; /* W[ 248] =  0.0488  -0.9980i */	
dout[191]	= { 10'sd13    , -10'sd512   }; /* W[ 252] =  0.0254  -1.0000i */	
dout[192]	= { 10'sd511   ,  10'sd0     }; /* W[   0] =  0.9980   0.0000i */	
dout[193]	= { 10'sd511   , -10'sd38    }; /* W[  12] =  0.9980  -0.0742i */	
dout[194]	= { 10'sd506   , -10'sd75    }; /* W[  24] =  0.9883  -0.1465i */	
dout[195]	= { 10'sd500   , -10'sd112   }; /* W[  36] =  0.9766  -0.2188i */	
dout[196]	= { 10'sd490   , -10'sd149   }; /* W[  48] =  0.9570  -0.2910i */	
dout[197]	= { 10'sd478   , -10'sd184   }; /* W[  60] =  0.9336  -0.3594i */	
dout[198]	= { 10'sd463   , -10'sd219   }; /* W[  72] =  0.9043  -0.4277i */	
dout[199]	= { 10'sd445   , -10'sd252   }; /* W[  84] =  0.8691  -0.4922i */	
dout[200]	= { 10'sd426   , -10'sd284   }; /* W[  96] =  0.8320  -0.5547i */	
dout[201]	= { 10'sd404   , -10'sd315   }; /* W[ 108] =  0.7891  -0.6152i */	
dout[202]	= { 10'sd379   , -10'sd344   }; /* W[ 120] =  0.7402  -0.6719i */	
dout[203]	= { 10'sd353   , -10'sd371   }; /* W[ 132] =  0.6895  -0.7246i */	
dout[204]	= { 10'sd325   , -10'sd396   }; /* W[ 144] =  0.6348  -0.7734i */	
dout[205]	= { 10'sd295   , -10'sd419   }; /* W[ 156] =  0.5762  -0.8184i */	
dout[206]	= { 10'sd263   , -10'sd439   }; /* W[ 168] =  0.5137  -0.8574i */	
dout[207]	= { 10'sd230   , -10'sd457   }; /* W[ 180] =  0.4492  -0.8926i */	
dout[208]	= { 10'sd196   , -10'sd473   }; /* W[ 192] =  0.3828  -0.9238i */	
dout[209]	= { 10'sd161   , -10'sd486   }; /* W[ 204] =  0.3145  -0.9492i */	
dout[210]	= { 10'sd124   , -10'sd497   }; /* W[ 216] =  0.2422  -0.9707i */	
dout[211]	= { 10'sd88    , -10'sd504   }; /* W[ 228] =  0.1719  -0.9844i */	
dout[212]	= { 10'sd50    , -10'sd510   }; /* W[ 240] =  0.0977  -0.9961i */	
dout[213]	= { 10'sd13    , -10'sd512   }; /* W[ 252] =  0.0254  -1.0000i */	
dout[214]	= {-10'sd25    , -10'sd511   }; /* W[ 264] = -0.0488  -0.9980i */	
dout[215]	= {-10'sd63    , -10'sd508   }; /* W[ 276] = -0.1230  -0.9922i */	
dout[216]	= {-10'sd100   , -10'sd502   }; /* W[ 288] = -0.1953  -0.9805i */	
dout[217]	= {-10'sd137   , -10'sd493   }; /* W[ 300] = -0.2676  -0.9629i */	
dout[218]	= {-10'sd172   , -10'sd482   }; /* W[ 312] = -0.3359  -0.9414i */	
dout[219]	= {-10'sd207   , -10'sd468   }; /* W[ 324] = -0.4043  -0.9141i */	
dout[220]	= {-10'sd241   , -10'sd452   }; /* W[ 336] = -0.4707  -0.8828i */	
dout[221]	= {-10'sd274   , -10'sd433   }; /* W[ 348] = -0.5352  -0.8457i */	
dout[222]	= {-10'sd305   , -10'sd411   }; /* W[ 360] = -0.5957  -0.8027i */	
dout[223]	= {-10'sd334   , -10'sd388   }; /* W[ 372] = -0.6523  -0.7578i */	
dout[224]	= {-10'sd362   , -10'sd362   }; /* W[ 384] = -0.7070  -0.7070i */	
dout[225]	= {-10'sd388   , -10'sd334   }; /* W[ 396] = -0.7578  -0.6523i */	
dout[226]	= {-10'sd411   , -10'sd305   }; /* W[ 408] = -0.8027  -0.5957i */	
dout[227]	= {-10'sd433   , -10'sd274   }; /* W[ 420] = -0.8457  -0.5352i */	
dout[228]	= {-10'sd452   , -10'sd241   }; /* W[ 432] = -0.8828  -0.4707i */	
dout[229]	= {-10'sd468   , -10'sd207   }; /* W[ 444] = -0.9141  -0.4043i */	
dout[230]	= {-10'sd482   , -10'sd172   }; /* W[ 456] = -0.9414  -0.3359i */	
dout[231]	= {-10'sd493   , -10'sd137   }; /* W[ 468] = -0.9629  -0.2676i */	
dout[232]	= {-10'sd502   , -10'sd100   }; /* W[ 480] = -0.9805  -0.1953i */	
dout[233]	= {-10'sd508   , -10'sd63    }; /* W[ 492] = -0.9922  -0.1230i */	
dout[234]	= {-10'sd511   , -10'sd25    }; /* W[ 504] = -0.9980  -0.0488i */	
dout[235]	= {-10'sd512   ,  10'sd13    }; /* W[ 516] = -1.0000   0.0254i */	
dout[236]	= {-10'sd510   ,  10'sd50    }; /* W[ 528] = -0.9961   0.0977i */	
dout[237]	= {-10'sd504   ,  10'sd88    }; /* W[ 540] = -0.9844   0.1719i */	
dout[238]	= {-10'sd497   ,  10'sd124   }; /* W[ 552] = -0.9707   0.2422i */	
dout[239]	= {-10'sd486   ,  10'sd161   }; /* W[ 564] = -0.9492   0.3145i */	
dout[240]	= {-10'sd473   ,  10'sd196   }; /* W[ 576] = -0.9238   0.3828i */	
dout[241]	= {-10'sd457   ,  10'sd230   }; /* W[ 588] = -0.8926   0.4492i */	
dout[242]	= {-10'sd439   ,  10'sd263   }; /* W[ 600] = -0.8574   0.5137i */	
dout[243]	= {-10'sd419   ,  10'sd295   }; /* W[ 612] = -0.8184   0.5762i */	
dout[244]	= {-10'sd396   ,  10'sd325   }; /* W[ 624] = -0.7734   0.6348i */	
dout[245]	= {-10'sd371   ,  10'sd353   }; /* W[ 636] = -0.7246   0.6895i */	
dout[246]	= {-10'sd344   ,  10'sd379   }; /* W[ 648] = -0.6719   0.7402i */	
dout[247]	= {-10'sd315   ,  10'sd404   }; /* W[ 660] = -0.6152   0.7891i */	
dout[248]	= {-10'sd284   ,  10'sd426   }; /* W[ 672] = -0.5547   0.8320i */	
dout[249]	= {-10'sd252   ,  10'sd445   }; /* W[ 684] = -0.4922   0.8691i */	
dout[250]	= {-10'sd219   ,  10'sd463   }; /* W[ 696] = -0.4277   0.9043i */	
dout[251]	= {-10'sd184   ,  10'sd478   }; /* W[ 708] = -0.3594   0.9336i */	
dout[252]	= {-10'sd149   ,  10'sd490   }; /* W[ 720] = -0.2910   0.9570i */	
dout[253]	= {-10'sd112   ,  10'sd500   }; /* W[ 732] = -0.2188   0.9766i */	
dout[254]	= {-10'sd75    ,  10'sd506   }; /* W[ 744] = -0.1465   0.9883i */	
dout[255]	= {-10'sd38    ,  10'sd511   }; /* W[ 756] = -0.0742   0.9980i */	
end

always @ (posedge clk) begin
  tf_re<=dout[addr][19:10];
  tf_im<=dout[addr][9:0];
end


endmodule

/** @} */ /* End of addtogroup ModMiscIpDspFftR22Sdc */
/* END OF FILE */
