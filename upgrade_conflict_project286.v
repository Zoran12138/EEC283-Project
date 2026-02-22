//sw6-2conflict with sw4-0
module project286(
    input        ADC_CLK_10,
    input        MAX10_CLK1_50,
    input        MAX10_CLK2_50,

    input  [1:0] KEY,
    output [9:0] LEDR,
    input  [9:0] SW
);

    // =========================
    // Clock / Reset / Buttons
    // =========================
    wire clk   = MAX10_CLK1_50;
    wire rst_n = KEY[0];   // DE10-Lite KEY is typically active-low
    wire key1  = KEY[1];

    // Detect KEY1 press (1 -> 0 transition)
    reg key1_d;
    always @(posedge clk)
        key1_d <= key1;

    wire write_pulse = (key1_d == 1'b1) && (key1 == 1'b0);

    // =========================
    // Write data generator
    // =========================
    reg [31:0] counter;
    always @(posedge clk) begin
        if (!rst_n)
            counter <= 32'd0;
        else if (write_pulse)
            counter <= counter + 32'd1;
    end

    wire        we    = write_pulse;
    wire [4:0]  waddr = 5'd1;       // always write x1
    wire [31:0] wdata = counter;

    // =========================
    // Read addresses
    // =========================
    wire [4:0] raddr1 = SW[4:0];
    wire [4:0] raddr2 = 5'd0;

    // =========================
    // High-score fault controls (10 switches)
    // =========================
    // SW[9]   : fault_enable
    // SW[8:7] : fault_type: 00 none, 01 flip, 10 stuck-0, 11 stuck-1
    // SW[6:2] : fault_bit (0..31) -> chooses which bit is affected
    // fault_addr is tied to raddr1 (fault the register you are reading)
    wire        fault_enable = SW[9];
    wire [1:0]  fault_type   = SW[8:7];
    wire [4:0]  fault_bit    = SW[6:2];

    wire [4:0]  fault_addr   = raddr1;
    wire [31:0] fault_mask   = (32'h1 << fault_bit);

    // =========================
    // Regfile instance
    // =========================
    wire [31:0] rdata1, rdata2;

    regfile u_rf (
        .clk(clk),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .fault_enable(fault_enable),
        .fault_addr(fault_addr),
        .fault_mask(fault_mask),
        .fault_type(fault_type)
    );

    // Show low 10 bits on LEDs
    assign LEDR = rdata1[9:0];

endmodule
