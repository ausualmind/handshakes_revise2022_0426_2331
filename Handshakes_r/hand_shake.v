`timescale 1ns/1ns
module master (
    input clk_m,
	input rst_n,
	input ready,
    input [9:0] RAM,
    output reg [9:0]data,
	output reg valid
	);
    reg hand_shake_1,hand_shake_2;
//    reg [9:0] cnt;
    always @(posedge clk_m) begin
        if(~rst_n) {hand_shake_1,hand_shake_2}<=0;
        else {hand_shake_1,hand_shake_2}<={valid&ready,hand_shake_1};
    end
    always @(posedge clk_m) begin
        if(~rst_n) data<=0;
        else if(hand_shake_1 && ~hand_shake_2) data<=RAM;
        else data<=data;
    end
    /*always @(posedge clk_m or negedge rst_n) begin
        if(~rst_n) cnt<=0;
        else if(data_ack_1 && ~data_ack_2) cnt<=0;
        else if(data_req) cnt<=cnt;
        else cnt<=cnt+1;
    end */
    always @(posedge clk_m) begin
        if(~rst_n) valid<=0;
        else if(hand_shake_1 && ~hand_shake_2) valid<=0;
        else valid<=1;
    end
endmodule

module slave (
    input clk_s,
	input rst_n,
	input valid,
	input data,
    output reg ready);
    reg hand_shake_1,hand_shake_2;
    reg [9:0] data_r;
    always @(posedge clk_s) begin
        if(~rst_n) {hand_shake_1,hand_shake_2}<='d0;
        else {hand_shake_1,hand_shake_2}<={valid&ready,hand_shake_1};
    end
    always @(posedge clk_s) begin
        if(~rst_n) ready<=0;
        else if(valid) ready<=1;
        else if(hand_shake_1 && ~hand_shake_2) ready<=0;
        else ready<=ready;
    end
    always @(posedge clk_s) begin
        if(~rst_n) data_r<='d0;
        else if(hand_shake_1 && ~hand_shake_2) data_r=data;
        else data_r<=data_r;
    end
endmodule

module top_module ();
    reg clk_m,clk_s,rst_n;
    reg [9:0] RAM;
    reg [9:0] data;
    reg valid,ready;
    initial begin
        clk_m=0;
        forever #5 clk_m=~clk_m;
    end
    initial begin
        clk_s=0;
        forever #7 clk_s=~clk_s;
    end
    initial begin
        RAM=0;
        forever #1 RAM=RAM+1;
    end
    initial begin
        rst_n=0;
        #10 rst_n=1;
    end
    master m1(
        .clk_m(clk_m),
		.rst_n(rst_n),
		.ready(ready),
    	.RAM(RAM),
    	.data(data),
		.valid(valid)
    );
    slave s1(
    	.clk_s(clk_s),
		.rst_n(rst_n),
		.valid(valid),
		.data(data),
        .ready(ready)
    );
endmodule