module ramtb();

	class ramrand;
		rand bit [9:0]X,Y,Z,W;
		rand bit reset;
		constraint rst{
			reset dist{1:=98,0:=2};
		}
		constraint ram{
					   // write address
					   X[9]==0;
					   X[8]==0;
					   // write data
					   Y[9]==0;
					   Y[8]==1;
					   // read address
					   Z[9]==1;
					   Z[8]==0;
					   // read data
					   W[9]==1;
					   W[8]==1;
					   }


	endclass
	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	logic [9:0] din;
	logic clk , rst_n,rx_valid;
	logic [7:0] dout;
	logic tx_valid;
	ramrand values=new;
	logic [9:0] address;
	logic [7:0] checka;
	int i;
	ram dut(din,clk,rst_n,rx_valid,dout,tx_valid);
	initial begin
		clk=0;
		forever
		#1 clk=~clk;
	end
	initial begin
	@(posedge clk)
     rst_n = 0;
     #2
     rst_n = 1;
	end
	initial begin
		for (i=0;i<1000;i++)begin
			assert(values.randomize());
			// write
			rst_n=values.reset;
			rx_valid=1;
			din=values.X;
			address=din;
			address[9]=1;
			#2
			
			din=values.Y;
			checka=din;
			#2
			//read
			//rx_valid=0;
			din=address;
			#2
			din=values.W;
			#2;
		end
	$stop;
	end

	property check;
	@(posedge clk) $rose(tx_valid)|->(dout==checka);
		endproperty

a:   assert property(check);

endmodule