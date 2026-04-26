module pwm_LED_01(clk, rst, led);
input clk, rst;
output[9:0]led;

wire rst_deb;

wire [22:0]cnt_2mod20s;
wire en;
assign en=(cnt_2mod20s == 23'd5_000_000);

wire pwm_out;
assign led={10{pwm_out}};
wire [3:0]cnt;
sync sync_deb
(.clk(clk),
 .in(rst),
 .out(rst_deb));

up_cnt_pmtr #(.WIDTH(23))up_cnt23b
(.clk(clk),
 .rst(rst_deb),
 .en(1'b1),
 .clr(en),
 .cnt(cnt_2mod20s));

repeat_cycle rp_c
(.clk(clk), 
 .rst(rst_deb),
 .bin(en),
 .bout(cnt));

PWM pwm0 //repeat it 10 times(0~9)
(.clk(clk),
 .rst(rst_deb),
 .duty(cnt),
 .pwm(pwm_out));		

endmodule
