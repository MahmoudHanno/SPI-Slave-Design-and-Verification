module spislavetb();
	
	logic MOSI,MISO,clk,rst_n,SS_n;
	integer i,j,index=0;
	bit [7:0]m=0,n=0;
	logic MISO2;
	initial begin
		clk=0;
		forever begin
			#1 ;
			clk=~clk;
		end
	end


	SPISLAVE test_golden(MOSI,MISO,SS_n,clk,rst_n);   //golden model
	SPI_Wrapper test(MOSI,MISO2,SS_n,clk,rst_n);	//device to be tested 


initial begin
	rst_n=0;
	SS_n=1;
	#2
	rst_n=1;
		for(i=0;i<256;i=i+1) begin
	//fill the whole memory
	write_addr();
	write_data();
	
end

		for(i=0;i<256;i=i+1) begin
			//read the whole memory
			 read_addr();
			 read_data();
		end

		for(i=0;i<10;i=i+1) begin
			//read memory randomly
			 read_addr_random();
			 read_data();
		end
		for(i=0;i<10;i=i+1) begin
			//overwrite random places in the memory
			 write_addr_random();
			 write_data();
		end

	$stop;

end


	task write_addr();
	SS_n=0;
	#2
	MOSI=0;
	#2
	MOSI=0;
	//#2
	//MOSI=0;
	for(j=7;j>=1;j=j-1) begin
		#2
		MOSI=m[j];
	end
	#2
	MOSI=m[0];
	m++;
	#2
	SS_n=1;
	#4;
endtask
task write_addr_random();
	SS_n=0;
	#2
	MOSI=0;
	#2
	MOSI=0;
	#2
	MOSI=0;
	for(j=7;j>=1;j=j-1) begin
		#2
		MOSI=$random;
	end
	#2
	MOSI=$random;
	m++;
	#2
	SS_n=1;
	#4;
endtask
task write_data();
	SS_n=0;
	#2
	MOSI=0;
	#2
	MOSI=0;
	#2
	MOSI=1;
	for(j=0;j<7;j=j+1) begin
		#2
		MOSI=$random;
	end
	#2
	MOSI=$random;
	#2
	SS_n=1;
	#4;
endtask

task read_addr();
	SS_n=0;
	#2
	MOSI=1;
	#2
	MOSI=1;
	#2
	MOSI=0;
	for(j=7;j>=1;j=j-1) begin
		#2
		MOSI=n[j];
		//MOSI=$random;
	end
	#2
	MOSI=n[0];
	//MOSI=$random;
	n++;
	#2
	SS_n=1;
	#4;
endtask
task read_data();
	SS_n=0;
	#2
	MOSI=1;
	#2
	MOSI=1;
	#2
	MOSI=1;
	for(j=0;j<7;j=j+1) begin
		#2
		MOSI=$random;
	end
	#2
	MOSI=$random;
	for(j=0;j<8;j=j+1) begin
		#2
		check();
	end
	SS_n=1;
	#4;
endtask

task check();

	if(MISO!==MISO2) begin
		$display("MISO should be %0b instead it's %0b", MISO, MISO2);
	end


endtask

task read_addr_random();
	SS_n=0;
	#2
	MOSI=1;
	#2
	MOSI=1;
	#2
	MOSI=0;
	for(j=7;j>=1;j=j-1) begin
		#2
		//MOSI=n[j];
		MOSI=$random;
	end
	#2
	//MOSI=n[0];
	MOSI=$random;
	n++;
	#2
	SS_n=1;
	#4;
endtask



endmodule