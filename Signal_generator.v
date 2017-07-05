module  Signal_generator(
				CLOCK_50,
				VGA_clk,
				Vsyn,
				blank_n,
				Val_CY,
				KEY,
				ifft_Iout,
				ifft_Qout
					 );
					 
input CLOCK_50;
input VGA_clk;
input Vsyn;
input blank_n;
input KEY;
input wire signed [7:0] ifft_Iout;
input wire signed [7:0] ifft_Qout;

output reg[9:0] Val_CY;




parameter nc = 1;

//parameter num_bits=nc*2*8;

//reg [9:0] Val_CY; //Index for Coord_Y
///////////////////////////////
// Signal generator elements
reg [7:0] sinAddr = 0;
reg [15:0] sine;
reg [15:0] captured_Vals[64*nc-1:0];
reg [31:0] i;

integer inc=0;

reg[1:0] bit_increment = 2'd0;	//Increment for sinAddr, = 1 for bit=1, 2 for bit = 0 
reg[7:0] bit_index = 0;	

reg [7:0] abs =0;

/////////////////////////
//Parameter Display Oscilloscope
//Time
parameter Ttotal=0.000025;
parameter DivX=10;
parameter pixelsH=640;
//parameter integer nf= 4;     
parameter integer nf= 1;
//Amplitude
parameter Amp=4;
parameter Atotal=8;
parameter DivY=8;
parameter pixelsV=480;
parameter integer Apixels=pixelsV/4;

/////////////////////////////////////////////////
//Variables to hold captured values

reg [31:0] j=0;

reg [7:0] k=0;

//////////////////////////////////////////////////
//Control screen elements when movement is implemented (Section 5.2 and 5.3)

reg[2:0] cf=1;
reg[3:0] cf_counter=4'h0;
reg[1:0] mov=0;

reg[5:0] disp=0;
/////////////////////////////////////////////
//Sinusoidal generator

always@(posedge CLOCK_50)
begin

//abs <= ifft_Iout;
	if (disp >= 30)
	begin
		captured_Vals[i] <= ifft_Qout;
		disp <= 0;
	end
	else
		begin	
			disp <= disp + 1;
		end
//	i <= i + 1;
	//sinAddr <= sinAddr + 1;
		
	//abs <= ((ifft_Iout*ifft_Iout)+(ifft_Qout*ifft_Qout));
	
	//abs <= 2;
	//inc <= (abs/128);
	//sinAddr <= sinAddr + inc;
//	if (k >= 7)
//		begin	
//			k <= 8'd0;
//		end
//	else
//		begin
//			k <= k+1;
//		end
	
	if (i == nc*64-1)
		begin
			i <= 32'd0;
		end
	else	
	begin
		i<=i+1;
	end
//	captured_Vals[i] <= sine;
//	//i <= i + 1;
//	sinAddr <= sinAddr + bit_increment;
//	bit_increment <= 1'b0;
//	/*if(captured_Vals[i]>32767)
//		begin
//			captured_Vals[i]<=65535;
//		end
//	else
//		begin
//			captured_Vals[i]<=0;
//		end
//			*/
//	if(i < num_bits-1)
//		begin
//			i<=i+1;
//		end
//	
//	if(KEY==1'd1)
//		begin
//			bit_increment<=ifft_Iout[bit_index] == 1'b1 ? 2'd0 : 2'd1;
//		end
//	else
//		begin
//			bit_increment<=ifft_Qout[bit_index] == 1'b1 ? 2'd0 : 2'd1;
//		end
//	if (bit_index >=7)
//		begin
//			bit_index <= 0;
//		end
//	else
//		begin
//			bit_index <= bit_index + 1;
//		end	
	
end

///////////////////////////////////////////////////////
//Frame Control with movement (section 5.2)

always@(negedge Vsyn)
	begin
		
		if(cf_counter==cf)
			begin
				cf_counter<=4'h0;
				mov<=mov+nf;
				if(mov<=nc*64-1)
					begin
						mov<=0;
					end
			end
	else
		begin
				cf_counter=cf_counter+1;
		end
end


////////////////////////////////////////////////////////////////
//Determine the value of Coordinate Y

always@(posedge VGA_clk)
begin
	if (blank_n == 1'd1) 
		begin
			j <= j + nf;
			//Val_CY <= (239+Apixels)-(captured_Vals[j]*2*Apixels/65535);
			Val_CY <= (239-(captured_Vals[j]*Apixels/255));
			if (j == nc*64-1-nf) 
			begin
				j <= 32'd0;
			end
		end	
	else	
		begin 
			j<=mov;
		end
end
	
//////////////////////////////////////	
//Sin Wave ROM Table
always@(sinAddr)
	begin
		case(sinAddr)
			8'd0: sine = 16'd32768 ;
			8'd1: sine = 16'd33572 ;
			8'd2: sine = 16'd34376 ;
			8'd3: sine = 16'd35179 ;
			8'd4: sine = 16'd35980 ;
			8'd5: sine = 16'd36779 ;
			8'd6: sine = 16'd37576 ;
			8'd7: sine = 16'd38370 ;
			8'd8: sine = 16'd39161;
			8'd9: sine = 16'd39948 ;
			8'd10: sine = 16'd40730 ;
			8'd11: sine = 16'd41508 ;
			8'd12: sine = 16'd42280 ;
			8'd13: sine = 16'd43047 ;
			8'd14: sine = 16'd43807 ;
			8'd15: sine = 16'd44561 ;
			8'd16: sine = 16'd45308 ;
			8'd17: sine = 16'd46047 ;
			8'd18: sine = 16'd46778 ;
			8'd19: sine = 16'd47501;
			8'd20: sine = 16'd48215;
			8'd21: sine = 16'd48919 ;
			8'd22: sine = 16'd49614 ;
			8'd23: sine = 16'd50299 ;	
			8'd24: sine = 16'd50973 ;
			8'd25: sine = 16'd51636 ;
			8'd26: sine = 16'd52288 ;
			8'd27: sine = 16'd52928 ;
			8'd28: sine = 16'd53556 ;
			8'd29: sine = 16'd54171 ;
			8'd30: sine = 16'd54774 ;
			8'd31: sine = 16'd55363 ;			
			8'd32: sine = 16'd55938;
			8'd33: sine = 16'd56500 ;
			8'd34: sine = 16'd57047 ;
			8'd35: sine = 16'd57580 ;
			8'd36: sine = 16'd58098 ;
			8'd37: sine = 16'd58601 ;
			8'd38: sine = 16'd59088 ;
			8'd39: sine = 16'd59559 ;		
			8'd40: sine = 16'd60014;
			8'd41: sine = 16'd60452 ;
			8'd42: sine = 16'd60874 ;
			8'd43: sine = 16'd61279;
			8'd44: sine = 16'd61667;
			8'd45: sine = 16'd62037 ;
			8'd46: sine = 16'd62390 ;
			8'd47: sine = 16'd62725 ;	
			8'd48: sine = 16'd63042 ;
			8'd49: sine = 16'd63340 ;
			8'd50: sine = 16'd63621 ;
			8'd51: sine = 16'd63882 ;
			8'd52: sine = 16'd64125 ;
			8'd53: sine = 16'd64349 ;
			8'd54: sine = 16'd64554 ;
			8'd55: sine = 16'd64740 ;
			8'd56: sine = 16'd64906;
			8'd57: sine = 16'd65054 ;
			8'd58: sine = 16'd65181 ;
			8'd59: sine = 16'd65290 ;
			8'd60: sine = 16'd65378 ;
			8'd61: sine = 16'd65447 ;
			8'd62: sine = 16'd65497 ;
			8'd63: sine = 16'd65526 ;
			8'd64: sine = 16'd65535 ;
			/*
			8'd0-8'd127: sine = 16'd65535;
			8'd128-8'd255: sine = 16'd0 ;
			*/
			default: sine = 16'd0;
		endcase
	end	
	
endmodule
