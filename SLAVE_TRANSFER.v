module SLAVE_TRANSFER(clk,rst,data_in,tx_dp,CPHA,sampling_edge,toggling_edge,data_out,MISO,CPOL,MOSI,slave_done,CS
);

input clk,rst,CPHA,toggling_edge,sampling_edge,MOSI,CPOL,tx_dp,CS;

input [7:0] data_in;

output reg [7:0] data_out;

output reg MISO;
output slave_done;

reg [7:0] r_byte;

reg [4:0] index;

parameter IDEAL = 2'd0,
          CHECK = 2'd1,
          TRANSFER =2'd2,
			 END =2'd3;

reg [1:0] current=IDEAL,next;

assign slave_done=(current==END)?1:0;

always@(posedge clk)
begin

case(current)

IDEAL :
       begin
		 if(tx_dp)
			begin
			r_byte=data_in;
			if(CPHA)
			begin
			MISO=r_byte[0];
			index=5'd1;
			end
			else
		   index=5'd0;
			
			end

		 end

TRANSFER :
          begin
	       if(index<5'd16)
           begin

			   if(sampling_edge)
				begin
                MISO=r_byte[0];
                index=index+5'd1;
				end
				if(toggling_edge)
		         begin
			       r_byte=r_byte>>1'd1;
					 r_byte[7]=MOSI; 
                index=index+5'd1;
	            end		
				
            end
				 end

END :
     begin
       data_out=r_byte;
     end	  

endcase

end


always@(*)
begin

case(current)

IDEAL :
       begin
		 
		 if(tx_dp)
		 begin	 
		 next=CHECK;
		 end
		 
		 else
		 next=IDEAL;
		 
		 end

CHECK :
       begin

       if(CS==1'd1)
		 next=TRANSFER;
		 else 
		 next=IDEAL;

       end		 
		 
		 
TRANSFER :
          begin
	
                if(index==5'd16)
             next=END;
               else
					 next=TRANSFER;

            end

			
END :
     begin
		 next=IDEAL; 
     end	 
	  
	  

endcase

end

always@(posedge clk or posedge rst)
begin

if(rst)
begin
current=IDEAL;
end

else
begin

current=next;

end

end

endmodule 