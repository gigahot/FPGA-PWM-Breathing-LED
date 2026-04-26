module repeat_cycle(clk, rst, bin, ini, bout);
input clk, rst;
input bin;
input [3:0]ini;
output reg [3:0]bout;

parameter [3:0]duty_ten=4'd10, duty_nine=4'd9, duty_eight=4'd8, duty_seven=4'd7, duty_six=4'd6, duty_five=4'd5,
					duty_four=4'd4, duty_three=4'd3, duty_two=4'd2, duty_one=4'd1, duty_zero=4'd0;
reg [3:0]cs, ns;

reg tango;

always@(posedge clk or posedge rst)
begin
	if(rst) tango <= 1'b0;
	else if(cs == duty_ten) tango <= 1'b0;
	else if(cs == duty_zero)tango <= 1'b1;
end

always@(posedge clk or posedge rst)
begin
	if(rst) cs <= #1 ini;
	else 	  cs <= #1 ns;
end
always@(bin or tango or cs )
begin
	if(!bin) ns <= cs;
	else
	case(cs)
		duty_ten:				ns = duty_nine;
		duty_nine:if(tango)  ns = duty_ten;
					 else	   	ns = duty_eight;
		duty_eight:if(tango) ns = duty_nine;
					  else		ns = duty_seven;
		duty_seven:if(tango) ns = duty_eight;
					  else		ns = duty_six;
		duty_six:if(tango)   ns = duty_seven;
					else	   	ns = duty_five;
		duty_five:if(tango)  ns = duty_six;
					 else	   	ns = duty_four;
		duty_four:if(tango)  ns = duty_five;
					 else	   	ns = duty_three;
		duty_three:if(tango) ns = duty_four;
					  else		ns = duty_two;
		duty_two:if(tango)   ns = duty_three;
					else	   	ns = duty_one;
		duty_one:if(tango)   ns = duty_two;
					else	   	ns = duty_zero;
		duty_zero:				ns = duty_one;
		default: 				ns = duty_ten;
	endcase
end
always@(cs)
begin
	case(cs)
		duty_ten:	bout = 4'd10;
		duty_nine:  bout = 4'd9;
		duty_eight: bout = 4'd8;
		duty_seven: bout = 4'd7;
		duty_six: 	bout = 4'd6;
		duty_five:  bout = 4'd5;
		duty_four:  bout = 4'd4;
		duty_three: bout = 4'd3;
		duty_two:   bout = 4'd2;
		duty_one:   bout = 4'd1;
		duty_zero:  bout = 4'd0;
		default: 	bout = 4'd10;
	endcase
end
endmodule
