module pwm_LED_03(clk, rst, led);
input clk, rst;
output[9:0]led;

//reg [3:0]in, trigger;
wire rst_deb;

wire [22:0]cnt_2mod20s;
wire en;
assign en=(cnt_2mod20s == 23'd5_000_000);

wire pwm_out[9:0];
//assign led={pwm_out[9], pwm_out[8], pwm_out[7], pwm_out[6], pwm_out[5], pwm_out[4], pwm_out[3], pwm_out[2], pwm_out[1], pwm_out[0]};
assign led={pwm_out[0], pwm_out[1], pwm_out[2], pwm_out[3], pwm_out[4], pwm_out[5], pwm_out[6], pwm_out[7], pwm_out[8], pwm_out[9]};

wire [3:0]cnt[9:0];
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

repeat_cycle rp_c9(.clk(clk), .rst(rst_deb), .bin(en), .ini(3'd10), .bout(cnt[9]));
repeat_cycle rp_c8(.clk(clk), .rst(rst_deb), .bin(en), .ini(3'd9), .bout(cnt[8]));
repeat_cycle rp_c7(.clk(clk), .rst(rst_deb), .bin(en), .ini(3'd8), .bout(cnt[7]));
repeat_cycle rp_c6(.clk(clk), .rst(rst_deb), .bin(en), .ini(3'd7), .bout(cnt[6]));
repeat_cycle rp_c5(.clk(clk), .rst(rst_deb), .bin(en), .ini(3'd6), .bout(cnt[5]));

PWM pwm9 (.clk(clk), .rst(rst_deb), .duty(cnt[5]), .pwm(pwm_out[9]));
PWM pwm8 (.clk(clk), .rst(rst_deb), .duty(cnt[6]), .pwm(pwm_out[8]));		
PWM pwm7 (.clk(clk), .rst(rst_deb), .duty(cnt[7]), .pwm(pwm_out[7]));		
PWM pwm6 (.clk(clk), .rst(rst_deb), .duty(cnt[8]), .pwm(pwm_out[6]));		
PWM pwm5 (.clk(clk), .rst(rst_deb), .duty(cnt[9]), .pwm(pwm_out[5]));		
PWM pwm4 (.clk(clk), .rst(rst_deb), .duty(cnt[9]), .pwm(pwm_out[4]));		
PWM pwm3 (.clk(clk), .rst(rst_deb), .duty(cnt[8]), .pwm(pwm_out[3]));		
PWM pwm2 (.clk(clk), .rst(rst_deb), .duty(cnt[7]), .pwm(pwm_out[2]));		
PWM pwm1 (.clk(clk), .rst(rst_deb), .duty(cnt[6]), .pwm(pwm_out[1]));		
PWM pwm0 (.clk(clk), .rst(rst_deb), .duty(cnt[5]), .pwm(pwm_out[0]));		
		
endmodule