
`timescale 1ns/1ps

module  tt_um_fifo_silicluster (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire write_en,
    input wire read_en,

    output reg [3:0] data_out,
    output wire full,
    output wire empty,
    output wire [2:0] count,
    output reg read_valid
);

    reg [3:0] mem [0:3];

    reg [1:0] wr_ptr;
    reg [1:0] rd_ptr;

    reg [2:0] used;

    wire do_write;
    wire do_read;

    assign count = used;
    assign full  = (used == 3'd4);
    assign empty = (used == 3'd0);

    assign do_write = write_en && !full;
    assign do_read  = read_en  && !empty;

    always @(posedge clk) begin

        if (rst) begin
            wr_ptr <= 2'd0;
            rd_ptr <= 2'd0;
            used <= 3'd0;
            data_out <= 4'd0;
            read_valid <= 1'b0;
        end

        else begin

            read_valid <= do_read;

            if (do_write) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 2'd1;
            end

            if (do_read) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 2'd1;
            end

            case ({do_write, do_read})
                2'b10: used <= used + 3'd1;
                2'b01: used <= used - 3'd1;
                default: used <= used;
            endcase

        end
    end

endmodule

