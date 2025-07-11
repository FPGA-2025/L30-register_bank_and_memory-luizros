module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input  wire        clk,

    input  wire        rd_en_i,
    input  wire        wr_en_i,

    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o,

    output wire        ack_o
);
    // Memória de palavras de 32 bits (4096 posições)
    reg [31:0] memory [0:MEMORY_SIZE-1];

    wire [31:2] word_addr = addr_i[31:2]; // alinhamento de palavra

    initial begin
        if (MEMORY_FILE != "") begin
            $readmemh(MEMORY_FILE, memory);
        end
    end

    assign ack_o = rd_en_i | wr_en_i;

    always @(posedge clk) begin
        if (rd_en_i) begin
            data_o <= memory[word_addr];
        end else begin
            data_o <= 32'd0;
        end

        if (wr_en_i) begin
            memory[word_addr] <= data_i;
        end
    end

endmodule
