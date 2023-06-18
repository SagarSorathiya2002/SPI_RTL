
module spi_master #(parameter [3:0] baud_sel=4'd2)(clk,rst,Tx_byte,tx_dp,Rx_byte,sclk,MOSI,MISO,CPOL,CPHA,CS,tx_done,sampling_edge,toggling_edge);

input clk,rst;

input [7:0] Tx_byte;
input tx_dp;
output CS,tx_done;

output [7:0] Rx_byte;

output sclk;
output MOSI;

input MISO;

input CPOL,CPHA;

output sampling_edge,toggling_edge;
wire tx_ready;

// SCLK GENERATOR

sclk_generator #(4'd2) sg(.clk(clk),
                          .rst(rst),
								  .CPOL(CPOL),
								  .CPHA(CPHA),
								  .sclk(sclk),
								  .tx_dp(tx_dp),
								  .tx_ready(tx_ready),
								  .sampling_edge(sampling_edge),
				              .toggling_edge(toggling_edge));

TRANSFER tx(.clk(clk),
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
				.tx_done(tx_done),
				.CS(CS));
								  

			 

endmodule 

