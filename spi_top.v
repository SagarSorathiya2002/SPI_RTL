module spi_top #(parameter [3:0] baud_sel=4'd2)(clk,rst,Master_Tx_byte,tx_dp,Master_Rx_byte,CPOL,CPHA,tx_done,Slave_Rx_byte,Slave_Tx_byte,slave_done);

input clk,rst;
input [7:0] Master_Tx_byte,Slave_Tx_byte;
input tx_dp;
output tx_done,slave_done;

output [7:0] Master_Rx_byte,Slave_Rx_byte;

wire sclk,MOSI,MISO,CS,sampling_edge,toggling_edge;
 
input CPOL,CPHA;

spi_master #(4'd2) master(.clk(clk),
                          .rst(rst),
								  .Tx_byte(Master_Tx_byte),
								  .tx_dp(tx_dp),
								  .Rx_byte(Master_Rx_byte),
								  .sclk(sclk),
								  .MOSI(MOSI),
								  .MISO(MISO),
								  .CPOL(CPOL),
								  .CPHA(CPHA),
								  .CS(CS),
								  .tx_done(tx_done),
								  .sampling_edge(sampling_edge),
								  .toggling_edge(toggling_edge));


spi_slave slave(.clk(clk),
                .sclk(sclk),
                .rst(rst),
					 .MISO(MISO),
					 .MOSI(MOSI),
					 .CPHA(CPHA),
					 .CPOL(CPOL),
					 .Tx_byte(Slave_Tx_byte),
					 .Rx_byte(Slave_Rx_byte),
					 .CS(CS),
					 .tx_dp(tx_dp),
					 .slave_done(slave_done));
								  
endmodule 


/*module tb;


reg clk=0,rst;
reg [7:0] Master_Tx_byte,Slave_Tx_byte;
reg tx_dp;
wire tx_done,slave_done;

wire [7:0] Master_Rx_byte,Slave_Rx_byte;

reg CPOL,CPHA;

spi_top #(4'd2) DUT(clk,rst,Master_Tx_byte,tx_dp,Master_Rx_byte,CPOL,CPHA,tx_done,Slave_Rx_byte,Slave_Tx_byte,slave_done);


initial
begin

rst=1'd1;
#5 rst=1'd0;

CPOL=0;
CPHA=1;

Master_Tx_byte=8'd10101010;
Slave_Tx_byte=8'd01010101;

tx_dp=1'd1;

#10 tx_dp=1'd0;


wait(slave_done);

#200;

$finish;

end

always #10 clk=~clk;

endmodule*/
