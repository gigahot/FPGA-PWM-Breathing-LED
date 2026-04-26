module sync(clk, in, out);
input clk;
input in;
output out;

reg in_sync0, in_sync1, in_sync2;
assign out = ~in_sync2; //button no push is 1, push is 0

always@(posedge clk)
begin
		in_sync0 <= #1 in;
		in_sync1 <= #1 in_sync0;
		in_sync2 <= #1 in_sync1;
end
endmodule
