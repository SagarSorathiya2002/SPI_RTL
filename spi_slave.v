module spi_slave(clk,sclk,rst,MISO,MOSI,CPHA,CPOL,Tx_byte,Rx_byte,CS,tx_dp,slave_done);

input sclk,rst,MOSI,CPOL,CPHA,CS,tx_dp,clk;

input [7:0] Tx_byte;

output [7:0] Rx_byte;

output MISO,slave_done;

wire toggling_edge,sampling_edge;

edge_detector#(4'd2) eg(.clk(clk),
								.sclk(sclk),
								.rst(rst),
								.toggling_edge(toggling_edge),
								.sampling_edge(sampling_edge),
								.CPOL(CPOL),
								.CPHA(CPHA),
								.tx_dp(tx_dp));

							  
SLAVE_TRANSFER tx(.clk(clk),
                  .rst(rst),
						.data_in(Tx_byte),
						.tx_dp(tx_dp),
						.CPHA(CPHA),
						.sampling_edge(sampling_edge),
						.toggling_edge(toggling_edge),
						.data_out(Rx_byte),
						.MISO(MISO),
						.CPOL(CPOL),
						.MOSI(MOSI),
						.slave_done(slave_done),
						.CS(CS));

endmodule 
