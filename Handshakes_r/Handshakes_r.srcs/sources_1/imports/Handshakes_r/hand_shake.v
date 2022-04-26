`timescale 1ns/1ns
module top_module;
    reg clk_m,clk_s,rst_n;
    reg [9:0] RAM;
    wire [9:0] data;
    wire valid,ready;
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
        .RAM(RAM[9:0]),
        .data(data[9:0]),
        .valid(valid)
    );
    slave s1(
        .clk_s(clk_s),
        .rst_n(rst_n),
        .valid(valid),
        .data(data[9:0]),
        .ready(ready)
    );
endmodule
module master (
    input clk_m,
    input rst_n,
    input ready,
    input [9:0] RAM,
    output [9:0] data,
    output valid
);
    reg hand_shake_1,hand_shake_2;
    reg valid_r;
    reg [9:0] cnt;
    assign data[9:0]=cnt[9:0];
    assign valid=valid_r;
    always @(posedge clk_m) begin
        if(~rst_n) {hand_shake_1,hand_shake_2}=0;
        else {hand_shake_1,hand_shake_2}={valid&ready,hand_shake_1};
    end
    always @(posedge clk_m) begin
        if(~rst_n) cnt[9:0]=0;
        else if(hand_shake_1 && ~hand_shake_2) cnt[9:0]=RAM[9:0];
        else cnt[9:0]=cnt[9:0];
    end
    /*always @(posedge clk_m or negedge rst_n) begin
        if(~rst_n) cnt<=0;
        else if(data_ack_1 && ~data_ack_2) cnt<=0;
        else if(data_req) cnt<=cnt;
        else cnt<=cnt+1;
    end */
    always @(posedge clk_m) begin
        if(~rst_n) valid_r=0;
        //else if(ready) valid_r=0;
        else valid_r=1;
    end
endmodule

module slave (
    input clk_s,
    input rst_n,
    input valid,
    input [9:0] data,
    output ready);
    reg hand_shake_1,hand_shake_2;
    reg ready_r;
    reg [9:0] data_r;
    assign ready=ready_r;
    always @(posedge clk_s) begin
        if(~rst_n) {hand_shake_1,hand_shake_2}='d0;
        else {hand_shake_1,hand_shake_2}={valid&ready,hand_shake_1};
    end
    always @(posedge clk_s) begin
        if(~rst_n) ready_r=0;
        else if(hand_shake_1 && ~hand_shake_2) ready_r=0;
        else if(valid) ready_r=1;
        else ready_r=ready_r;
    end
    always @(posedge clk_s) begin
        if(~rst_n) data_r='d0;
        else if(hand_shake_1 && ~hand_shake_2) data_r=data;
        else data_r=data_r;
    end
endmodule