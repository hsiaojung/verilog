// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 USB API RTL Code
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/08/22  :| Initial Revision
//   V1.1 :| Johnny Chen       :| 05/11/08  :| Modify Flash Command     
//   V1.2 :| Johnny Chen       :| 06/07/26  :| Modify Timing for QuartusII 6.0    
// --------------------------------------------------------------------

module DE2_USB_API
	(
		////////////////////	Clock Input	 	////////////////////	 
		OSC_27,							//	27 MHz
		OSC_50,							//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Button[3:0]
		////////////////////	DPDT Switch		////////////////////
		DPDT_SW,						//	DPDT Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digital 0
		HEX1,							//	Seven Segment Digital 1
		HEX2,							//	Seven Segment Digital 2
		HEX3,							//	Seven Segment Digital 3
		HEX4,							//	Seven Segment Digital 4
		HEX5,							//	Seven Segment Digital 5
		HEX6,							//	Seven Segment Digital 6
		HEX7,							//	Seven Segment Digital 7
		////////////////////////	LED		////////////////////////
		LED_GREEN,						//	LED Green[8:0]
		LED_RED,						//	LED Red[17:0]
		////////////////////////	UART	////////////////////////
		UART_TXD,						//	UART Transmitter
		UART_RXD,						//	UART Rceiver
		////////////////////////	IRDA	////////////////////////
		IRDA_TXD,						//	IRDA Transmitter
		IRDA_RXD,						//	IRDA Rceiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 20 Bits
		FL_WE_N,						//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,						//	FLASH Output Enable
		FL_CE_N,						//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Adress bus 18 Bits
		SRAM_UB_N,						//	SRAM Low-byte Data Mask 
		SRAM_LB_N,						//	SRAM High-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	ISP1362 Interface	////////////////
		OTG_DATA,						//	ISP1362 Data bus 16 Bits
		OTG_ADDR,						//	ISP1362 Address 2 Bits
		OTG_CS_N,						//	ISP1362 Chip Select
		OTG_RD_N,						//	ISP1362 Write
		OTG_WR_N,						//	ISP1362 Read
		OTG_RST_N,						//	ISP1362 Reset
		OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
		OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
		OTG_INT0,						//	ISP1362 Interrupt 0
		OTG_INT1,						//	ISP1362 Interrupt 1
		OTG_DREQ0,						//	ISP1362 DMA Request 0
		OTG_DREQ1,						//	ISP1362 DMA Request 1
		OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
		OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
		////////////////////	LCD Module 16X2		////////////////
		LCD_ON,							//	LCD Power ON/OFF
		LCD_BLON,						//	LCD Back Light ON/OFF
		LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,							//	LCD Enable
		LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA,						//	LCD Data bus 8 bits
		////////////////////	SD_Card Interface	////////////////
		SD_DAT,							//	SD Card Data
		SD_DAT3,						//	SD Card Data 3
		SD_CMD,							//	SD Card Command Signal
		SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	    TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,						//	PS2 Data
		PS2_CLK,						//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		////////////	Ethernet Interface	////////////////////////
		ENET_DATA,						//	DM9000A DATA bus 16Bits
		ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
		ENET_CS_N,						//	DM9000A Chip Select
		ENET_WR_N,						//	DM9000A Write
		ENET_RD_N,						//	DM9000A Read
		ENET_RST_N,						//	DM9000A Reset
		ENET_INT,						//	DM9000A Interrupt
		ENET_CLK,						//	DM9000A Clock 25 MHz
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,						//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		TD_DATA,    					//	TV Decoder Data bus 8 bits
		TD_HS,							//	TV Decoder H_SYNC
		TD_VS,							//	TV Decoder V_SYNC
		TD_RESET,						//	TV Decoder Reset
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
input			OSC_27;					//	27 MHz
input			OSC_50;					//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Button[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	DPDT_SW;				//	DPDT Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digital 0
output	[6:0]	HEX1;					//	Seven Segment Digital 1
output	[6:0]	HEX2;					//	Seven Segment Digital 2
output	[6:0]	HEX3;					//	Seven Segment Digital 3
output	[6:0]	HEX4;					//	Seven Segment Digital 4
output	[6:0]	HEX5;					//	Seven Segment Digital 5
output	[6:0]	HEX6;					//	Seven Segment Digital 6
output	[6:0]	HEX7;					//	Seven Segment Digital 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LED_GREEN;				//	LED Green[8:0]
output	[17:0]	LED_RED;				//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
output			UART_TXD;				//	UART Transmitter
input			UART_RXD;				//	UART Rceiver
////////////////////////////	IRDA	////////////////////////////
output			IRDA_TXD;				//	IRDA Transmitter
input			IRDA_RXD;				//	IRDA Rceiver
///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output	[19:0]	FL_ADDR;				//	FLASH Address bus 20 Bits
output			FL_WE_N;				//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;				//	FLASH Output Enable
output			FL_CE_N;				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;				//	SRAM Adress bus 18 Bits
output			SRAM_UB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_LB_N;				//	SRAM High-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	ISP1362 Interface	////////////////////////
inout	[15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
output	[1:0]	OTG_ADDR;				//	ISP1362 Address 2 Bits
output			OTG_CS_N;				//	ISP1362 Chip Select
output			OTG_RD_N;				//	ISP1362 Write
output			OTG_WR_N;				//	ISP1362 Read
output			OTG_RST_N;				//	ISP1362 Reset
output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
input			OTG_INT0;				//	ISP1362 Interrupt 0
input			OTG_INT1;				//	ISP1362 Interrupt 1
input			OTG_DREQ0;				//	ISP1362 DMA Request 0
input			OTG_DREQ1;				//	ISP1362 DMA Request 1
output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
inout	[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
inout			SD_DAT;					//	SD Card Data
inout			SD_DAT3;				//	SD Card Data 3
inout			SD_CMD;					//	SD Card Command Signal
output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 	PS2_DAT;				//	PS2 Data
input			PS2_CLK;				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;					// CPLD -> FPGA (data in)
input  			TCK;					// CPLD -> FPGA (clk)
input  			TCS;					// CPLD -> FPGA (CS)
output 			TDO;					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
output			ENET_CS_N;				//	DM9000A Chip Select
output			ENET_WR_N;				//	DM9000A Write
output			ENET_RD_N;				//	DM9000A Read
output			ENET_RST_N;				//	DM9000A Reset
input			ENET_INT;				//	DM9000A Interrupt
output			ENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
output/*inout*/	AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data
inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			TD_HS;					//	TV Decoder H_SYNC
input			TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1
////////////////////////////////////////////////////////////////////

//	USB JTAG
wire [7:0] mRXD_DATA,mTXD_DATA;
wire mRXD_Ready,mTXD_Done,mTXD_Start;
wire mTCK;
//	FLASH
wire [19:0] mFL_ADDR;
wire [7:0] mFL2RS_DATA,mRS2FL_DATA;
wire [2:0] mFL_CMD;
wire mFL_Ready,mFL_Start;
//	SDRAM
wire [21:0] mSD_ADDR;
wire [15:0] mSD2RS_DATA,mRS2SD_DATA;
wire mSD_WR,mSD_RD,mSD_Done;
//	SRAM
wire [17:0]	mSR_ADDR;
wire [15:0]	mSR2RS_DATA,mRS2SR_DATA;
wire		mSR_OE,mSR_WE;
//	SEG7
wire [31:0] mSEG7_DIG;
//	LCD
wire [7:0]	mLCD_DATA;
wire		mLCD_RS;
wire		mLCD_Start;
wire		mLCD_Done;
//	PS2
wire [7:0] PS2_ASCII;
wire PS2_Error,PS2_Ready;
//	VGA
wire [9:0] mVGA_R;
wire [9:0] mVGA_G;
wire [9:0] mVGA_B;
wire [9:0] mOSD_R;
wire [9:0] mOSD_G;
wire [9:0] mOSD_B;
wire [9:0] mVIN_R;
wire [9:0] mVIN_G;
wire [9:0] mVIN_B;
wire [19:0]	mVGA_ADDR;
wire [9:0]	mCursor_X;
wire [9:0]	mCursor_Y;
wire [9:0]	mCursor_R;
wire [9:0]	mCursor_G;
wire [9:0]	mCursor_B;
wire [1:0]	mOSD_CUR_EN;
//	Async Port Select
wire [2:0] mSDR_Select;
wire [2:0] mFL_Select;
wire [2:0] mSR_Select;
//	External IO
wire [7:0] mExt_IO;
//	FLASH Async Port
wire [19:0] mFL_AS_ADDR_1;
wire [19:0] mFL_AS_ADDR_2;
wire [19:0] mFL_AS_ADDR_3;
wire [7:0]	mFL_AS_DATA_1;
wire [7:0]	mFL_AS_DATA_2;
wire [7:0]	mFL_AS_DATA_3;
//	SDRAM Async Port
wire [15:0] mSDR_AS_DATAOUT_1;
wire [15:0] mSDR_AS_DATAOUT_2;
wire [15:0] mSDR_AS_DATAOUT_3;
wire [21:0] mSDR_AS_ADDR_1	= 0;
wire [21:0] mSDR_AS_ADDR_2	= 0;
wire [21:0] mSDR_AS_ADDR_3	= 0;
wire [15:0] mSDR_AS_DATAIN_1= 0;
wire [15:0] mSDR_AS_DATAIN_2= 0;
wire [15:0] mSDR_AS_DATAIN_3= 0;
wire 		mSDR_AS_WR_n_1	= 0;
wire 		mSDR_AS_WR_n_2	= 0;
wire 		mSDR_AS_WR_n_3	= 0;
//	SRAM Async Port
wire [15:0]	mSRAM_VGA_DATA;

wire		VGA_CTRL_CLK;
wire		AUD_CTRL_CLK;

//	All inout port turn to tri-state
assign	OTG_DATA	=	16'hzzzz;
assign	SD_DAT		=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

//	LCD
assign	LCD_ON		=	1'b1;	//	LCD Power ON
assign	LCD_BLON	=	1'b1;	//	LCD Back Light ON
//	TV
assign	TD_RESET	=	1'b1;	//	Bypress 27 MHz
//	VGA Data Reorder
assign	mVIN_R		=	mVGA_ADDR[0]	?	mSRAM_VGA_DATA[15:8]<<2	:	mSRAM_VGA_DATA[7:0]<<2	;	
assign	mVIN_G		=	mVGA_ADDR[0]	?	mSRAM_VGA_DATA[15:8]<<2	:	mSRAM_VGA_DATA[7:0]<<2	;	
assign	mVIN_B		=	mVGA_ADDR[0]	?	mSRAM_VGA_DATA[15:8]<<2	:	mSRAM_VGA_DATA[7:0]<<2	;	
//	VGA Data Source Select
assign	mVGA_R		=	~mOSD_CUR_EN[1]	?	mOSD_R	:	mVIN_R;
assign	mVGA_G		=	~mOSD_CUR_EN[1]	?	mOSD_G	:	mVIN_G;
assign	mVGA_B		=	~mOSD_CUR_EN[1]	?	mOSD_B	:	mVIN_B;
//	Audio
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

CLK_LOCK 			p0	(	.inclk(TCK),.outclk(mTCK)	);

SEG7_LUT_8 			u0	(	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,mSEG7_DIG ); //control all 7 seg by one time.

USB_JTAG			u1	(	//	HOST
							.iTxD_DATA(mTXD_DATA),.oTxD_Done(mTXD_Done),.iTxD_Start(mTXD_Start),
							.oRxD_DATA(mRXD_DATA),.oRxD_Ready(mRXD_Ready),.iRST_n(KEY[0]),.iCLK(OSC_50),
							//	JTAG
							.TDO(TDO),.TDI(TDI),.TCS(TCS),.TCK(mTCK)	);

Multi_Flash			u2	(	//	Host Side
							mFL2RS_DATA,mRS2FL_DATA,mFL_ADDR,mFL_CMD,mFL_Ready,mFL_Start,
							//	Async Side 1
							mFL_AS_DATA_1,mFL_AS_ADDR_1,
							//	Async Side 2
							mFL_AS_DATA_2,mFL_AS_ADDR_2,
							//	Async Side 3
							mFL_AS_DATA_3,mFL_AS_ADDR_3,
							//	Control Signals
							mFL_Select,OSC_50,KEY[0],
							//	Flash Interface
							FL_DQ,FL_ADDR,FL_WE_N,FL_CE_N,FL_OE_N,FL_RST_N);

Multi_Sdram			u3	(	//	Host Side
							mSD2RS_DATA,mRS2SD_DATA,mSD_ADDR,mSD_RD,mSD_WR,mSD_Done,
							//	Async Side 1
							mSDR_AS_DATAOUT_1,mSDR_AS_DATAIN_1,mSDR_AS_ADDR_1,mSDR_AS_WR_n_1,
							//	Async Side 2
							mSDR_AS_DATAOUT_2,mSDR_AS_DATAIN_2,mSDR_AS_ADDR_2,mSDR_AS_WR_n_2,
							//	Async Side 3
							mSDR_AS_DATAOUT_3,mSDR_AS_DATAIN_3,mSDR_AS_ADDR_3,mSDR_AS_WR_n_3,
							//	Control Signals
							mSDR_Select,OSC_50,KEY[0],
							//	SDRAM Interface
        					DRAM_ADDR,{DRAM_BA_1,DRAM_BA_0},DRAM_CS_N,DRAM_CKE,DRAM_RAS_N,
							DRAM_CAS_N,DRAM_WE_N,DRAM_DQ,{DRAM_UDQM,DRAM_LDQM},DRAM_CLK);

ps2_keyboard		u4	(	.clk(OSC_50),.reset(~KEY[0]),
							.ps2_clk_i(PS2_CLK),.ps2_data_i(PS2_DAT),
							.rx_ascii(PS2_ASCII),.rx_data_ready(PS2_Ready),
							.rx_read(PS2_Ready)	);

CMD_Decode			u5	(	//	USB JTAG
							.iRXD_DATA(mRXD_DATA),.iRXD_Ready(mRXD_Ready),
						 	.oTXD_DATA(mTXD_DATA),.oTXD_Start(mTXD_Start),.iTXD_Done(mTXD_Done),
						 	//	FLASH
							.iFL_DATA(mFL2RS_DATA),.oFL_DATA(mRS2FL_DATA),
						 	.oFL_ADDR(mFL_ADDR),.iFL_Ready(mFL_Ready),
						 	.oFL_Start(mFL_Start),.oFL_CMD(mFL_CMD),
							//	SDRAM
							.iSDR_DATA(mSD2RS_DATA),.oSDR_DATA(mRS2SD_DATA),
							.oSDR_ADDR(mSD_ADDR),.iSDR_Done(mSD_Done),
							.oSDR_WR(mSD_WR),.oSDR_RD(mSD_RD),
							//	SRAM
							.iSR_DATA(mSR2RS_DATA),.oSR_DATA(mRS2SR_DATA),
							.oSR_ADDR(mSR_ADDR),
							.oSR_WE_N(mSR_WE),.oSR_OE_N(mSR_OE),
						 	//	LED + SEG7
							.oLED_GREEN(LED_GREEN),.oLED_RED(LED_RED),
							.oSEG7_DIG(mSEG7_DIG),
							//	LCD
							.oLCD_DATA(mLCD_DATA),.oLCD_RS(mLCD_RS),
							.oLCD_Start(mLCD_Start),.iLCD_Done(mLCD_Done),
							//	VGA
							.oCursor_X(mCursor_X),
							.oCursor_Y(mCursor_Y),
							.oCursor_R(mCursor_R),
							.oCursor_G(mCursor_G),
							.oCursor_B(mCursor_B),
							.oOSD_CUR_EN(mOSD_CUR_EN),	
							//	PS2
							.iPS2_ScanCode(PS2_ASCII),.iPS2_Ready(PS2_Ready),
							//	Async Port Select
							.oSDR_Select(mSDR_Select),
							.oFL_Select(mFL_Select),
							.oSR_Select(mSR_Select),
							//	Ext Control Signals
							.oExt_IO(mExt_IO),
							//	Control
						 	.iCLK(OSC_50),.iRST_n(KEY[0])	);

Multi_Sram			u6	(	//	Host Side
							.oHS_DATA(mSR2RS_DATA),.iHS_DATA(mRS2SR_DATA),.iHS_ADDR(mSR_ADDR),
							.iHS_WE_N(mSR_WE),.iHS_OE_N(mSR_OE),
							//	Async Side 1
							.oAS1_DATA(mSRAM_VGA_DATA),.iAS1_ADDR(mVGA_ADDR[19:1]),
							.iAS1_WE_N(1'b1),.iAS1_OE_N(1'b0),
							//	Control Signals
							.iSelect(mSR_Select),.iRST_n(KEY[0]),
							//	SRAM
							.SRAM_DQ(SRAM_DQ),
							.SRAM_ADDR(SRAM_ADDR),
							.SRAM_UB_N(SRAM_UB_N),
							.SRAM_LB_N(SRAM_LB_N),
							.SRAM_WE_N(SRAM_WE_N),
							.SRAM_CE_N(SRAM_CE_N),
							.SRAM_OE_N(SRAM_OE_N)	);

LCD_Controller 		u7	(	//	Host Side
							.iDATA(mLCD_DATA),.iRS(mLCD_RS),
							.iStart(mLCD_Start),.oDone(mLCD_Done),
							.iCLK(OSC_50),.iRST_N(KEY[0]),
							//	LCD Interface
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS)	);

VGA_Audio_PLL 		p1	(	.inclk0(OSC_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK)	);

VGA_Controller		u8	(	//	Host Side
							.iCursor_RGB_EN({mOSD_CUR_EN[0],3'h7}),
							.iCursor_X(mCursor_X),
							.iCursor_Y(mCursor_Y),
							.iCursor_R(mCursor_R),
							.iCursor_G(mCursor_G),
							.iCursor_B(mCursor_B),							
							.oAddress(mVGA_ADDR),
							.iRed(mVGA_R),
							.iGreen(mVGA_G),
							.iBlue(mVGA_B),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(VGA_G),
							.oVGA_B(VGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC),
							.oVGA_BLANK(VGA_BLANK),
							.oVGA_CLOCK(VGA_CLK),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(KEY[0])	);

VGA_OSD_RAM			u9	(	//	Read Out Side
							.oRed(mOSD_R),
							.oGreen(mOSD_G),
							.oBlue(mOSD_B),
							.iVGA_ADDR(mVGA_ADDR),
							.iVGA_CLK(VGA_CLK),
							//	CLUT
							.iON_R(1023),
							.iON_G(1023),
							.iON_B(1023),
							.iOFF_R(0),
							.iOFF_G(0),
							.iOFF_B(512),
							//	Control Signals
							.iRST_N(KEY[0])	);

I2C_AV_Config 		u10	(	//	Host Side
							.iCLK(OSC_50),
							.iRST_N(KEY[0]),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);

AUDIO_DAC 			u11	(	//	Memory Side
							.oFLASH_ADDR(mFL_AS_ADDR_1),
							.iFLASH_DATA(mFL_AS_DATA_1),
							//	Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							//	Control Signals
							.iSrc_Select(DPDT_SW[1:0]),
				            .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(KEY[0])	);

endmodule