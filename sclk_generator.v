module sclk_generator #(parameter [3:0] baud_sel=4'd2) (clk,rst,CPOL,CPHA,sclk,tx_dp,tx_ready,sampling_edge,toggling_edge);

input clk,CPOL,tx_dp,rst,CPHA;

output reg sclk,tx_ready,sampling_edge,toggling_edge;

reg [4:0] clk_counter=5'd0,edge_counter=5'd0;

reg r_sclk,rising_edge,falling_edge;


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

r_sclk=1'd0;

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
r_sclk=CPOL;
edge_counter=5'd16;
clk_counter=5'd0;
tx_ready=1'd0;
rising_edge=1'd0;
falling_edge=1'd0;

end


else if(edge_counter>0)
begin


if(clk_counter==baud_sel-1'd1)
begin

r_sclk=~r_sclk;
edge_counter=edge_counter-5'd1;
clk_counter=clk_counter+5'd1;
if(r_sclk)
rising_edge=1'd1;
else
falling_edge=1'd1;
end

else if(clk_counter==2*baud_sel-1)
begin

edge_counter=edge_counter-5'd1;
clk_counter=5'd0;
r_sclk=~r_sclk;
if(r_sclk)
rising_edge=1'd1;
else
falling_edge=1'd1;

end 

else

clk_counter=clk_counter+5'd1;


end

else
begin
r_sclk=CPOL;
end


end

end


always@(posedge clk or posedge rst)
begin

if(rst)
begin

sclk=CPOL;

end

else
begin

sclk=r_sclk;

end

end


endmodule

/*

module sclk_generator #(parameter [3:0] baud_sel=4'd2) (clk,rst,CPOL,CPHA,sclk,tx_dp,tx_ready,sampling_edge,toggling_edge);

input clk,CPOL,tx_dp,rst,CPHA;

output reg sclk,tx_ready,sampling_edge,toggling_edge;

reg [4:0] clk_counter=5'd0,edge_counter=5'd0;

reg r_sclk,rising_edge,falling_edge;


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

r_sclk=1'd0;

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
r_sclk=CPOL;
edge_counter=5'd16;
tx_ready=1'd0;
rising_edge=1'd0;
falling_edge=1'd0;

end


else if(edge_counter>0)
begin

 
clk_counter=clk_counter+5'd1;

if(clk_counter==baud_sel-1'd1)
begin

r_sclk=~r_sclk;
edge_counter=edge_counter-5'd1;
clk_counter=clk_counter+5'd1;
if(r_sclk)
rising_edge=1'd1;
else
falling_edge=1'd1;
end

else if(clk_counter==2*baud_sel-1)
begin

edge_counter=edge_counter-5'd1;
r_sclk=~r_sclk;
if(r_sclk)
rising_edge=1'd1;
else
falling_edge=1'd1;
clk_counter=5'd0;


end 

end

else
begin

tx_ready=1'd1;
r_sclk=CPOL;

end


end

end


always@(posedge clk or posedge rst)
begin

if(rst)
begin

sclk=CPOL;

end

else
begin

sclk=r_sclk;

end

end


endmodule 


*/ 