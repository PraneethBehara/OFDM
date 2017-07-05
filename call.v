module call(clk,
            reset_n,
				output_sink_error,
				output_sink_sop,
				output_sink_eop,
				output_fftpts_in,
				output_fftpts_out,
				output_source_ready
//				output_source_error,
//				output_source_sop,
//				output_source_eop
				
    	);
			input clk;
			output reset_n=1'b0;
			output [1:0]output_sink_error;
			output wire [3:0] output_fftpts_in;
			output wire [3:0] output_fftpts_out;
			output reg output_sink_eop;
			output reg output_sink_sop;
			output wire output_source_ready;
//			output output_source_error;
//			output output_source_sop;
//			output output_source_eop;
//	
			reg [15:0] counter=0;
			
assign output_sink_error = 2'b00;
assign output_fftpts_out = 4'b1000;
assign output_fftpts_in  = 4'b1000; 
assign output_source_ready = 1'b1;

always @ (negedge clk)
    begin                                                                                         
      if(reset_n==1'b1)
        counter <= 0;
      else                                                                                       
        counter <= counter + 1;  
			 
			 
		if(reset_n==1'b1)
        output_sink_sop<=1'b0;                                                                              
     else                                                                                     
       begin                                                                                        
         if(counter==1)                                                     
           output_sink_sop<=1'b1;                                                                             
         else                                                                   
           output_sink_sop<=1'b0;                                                                   
       end
		 
		if(counter==65535)
		begin
        output_sink_eop<=1'b1;
		   counter <= 0;
		end
		else
		  output_sink_eop<=1'b0;
    end           


endmodule
	  

		
	        		