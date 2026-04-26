module PWM(
input clk, rst,
input [3:0]duty,
output reg pwm);

reg [3:0]cnt;
wire lt;
assign lt = (cnt<duty);

always@(posedge clk or posedge rst)
begin
	if(rst) cnt<=4'd0;
	else if(cnt==4'd9) cnt<=4'd0;
	else 	  cnt<=cnt+1'd1;
end
always@(posedge clk or posedge rst)
begin
	if(rst) pwm<=1'b0;
	else	  pwm<=lt;
end

endmodule