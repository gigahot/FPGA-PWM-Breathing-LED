module up_cnt_pmtr
#(parameter WIDTH=32)(
input clk,
input rst,
input en,
input clr,
output reg [WIDTH-1:0]cnt);

wire[WIDTH-1:0]zero={{WIDTH}{1'B0}};
always@(posedge clk or posedge rst)
begin
	if (rst) cnt <=zero;
	else if(en)
			begin
				if(clr) cnt<=zero;
				else 	  cnt<=cnt+1'b1;
			end
end
endmodule
