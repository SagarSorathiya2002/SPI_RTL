module edge_detector  #(parameter [3:0] baud_sel=4'd2)(clk,sclk,rst,toggling_edge,sampling_edge,CPOL,CPHA,tx_dp);

input clk,sclk,rst,CPOL,CPHA,tx_dp;

output reg toggling_edge,sampling_edge;

reg falling_edge,rising_edge;

reg [4:0] clk_counter=5'd0,edge_counter=5'd0;

always@(posedge clk or posedge rst)
begin

case({CPHA,CPOL})


2'd0 : begin

       sampling_edge=rising_edge;
		 toggling_edge=falling_edge;
		 
       end

2'd1 : begin

       sampling_edge=falling_edge;
		 toggling_edge=rising_edge;
		 
       end

2'd2 : begin

       sampling_edge=falling_edge;
		 toggling_edge=rising_edge;
		 
       end

2'd3 : begin

       sampling_edge=rising_edge;
		 toggling_edge=falling_edge;
		 
       end
		 
endcase


end

always@(posedge clk or posedge rst)
begin
if(rst)
begin


rising_edge=1'd0;

falling_edge=1'd0;

edge_counter=5'd0;

clk_counter=5'd0;


end

else
begin

rising_edge=1'd0;
falling_edge=1'd0;



if(tx_dp)
begin

edge_counter=5'd16;
rising_edge=1'd0;
falling_edge=1'd0;

end


else if(edge_counter>0)
begin

 
if(clk_counter==baud_sel-1'd1)
begin

edge_counter=edge_counter-5'd1;
clk_counter=clk_counter+5'd1;
if(sclk)
falling_edge=1'd1;
else
rising_edge=1'd1;

end


else if(clk_counter==2*baud_sel-1)
begin
edge_counter=edge_counter-5'd1;
clk_counter=5'd0;
if(sclk)
falling_edge=1'd1;
else
rising_edge=1'd1;
end 

else
clk_counter=clk_counter+5'd1;


end




end

end



endmodule 