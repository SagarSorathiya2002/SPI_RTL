module SPI_TB;
  
reg clk=0,rst;
reg [7:0] Master_Tx_byte,Slave_Tx_byte;
reg tx_dp;
wire tx_done,slave_done;

wire [7:0] Master_Rx_byte,Slave_Rx_byte;

reg CPOL,CPHA;

integer i=0,master_tx,master_rx,slave_rx,slave_tx;

spi_top #(4'd2) DUT(clk,rst,Master_Tx_byte,tx_dp,Master_Rx_byte,CPOL,CPHA,tx_done,Slave_Rx_byte,Slave_Tx_byte,slave_done);


initial
begin

rst=1'd1;
#5 rst=1'd0;


for(i=0;i<10;i=i+1)
begin
  
  {CPHA,CPOL}=i;

Master_Tx_byte=$random();

Slave_Tx_byte=$random();

tx_dp=1'd1;

repeat(2) @(posedge clk);

tx_dp=1'd0;


$display("\n\n Case %d : CPHA = %d CPOL = %d \n MASTER_TX_BYTE = %d \n SLAVE_TX_BYTE = %d ",i,CPHA,CPOL,Master_Tx_byte,Slave_Tx_byte);

master_tx=Master_Tx_byte;

slave_tx=Slave_Tx_byte;

wait(slave_done==1);

wait(tx_done==1);

#30;

$display("\n SLAVE_TX_BYTE = %d \n SLAVE_RX_BYTE = %d ",Master_Rx_byte,Slave_Rx_byte);

master_rx=Master_Rx_byte;

slave_rx=Slave_Rx_byte;

COMPARE();


repeat(10) @(posedge clk);

end

$finish;

end

task COMPARE;
  
  if((master_tx==slave_rx)&&(master_rx==slave_tx))
     $display("VALID FOR THE CASE : %d",i);
  
  else
       $display("INVALID FOR THE CASE : %d",i);  
endtask  

always #10 clk=~clk;

endmodule




