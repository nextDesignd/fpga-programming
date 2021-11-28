module leading_ones # (
    parameter WIDTH = 16,
    parameter string IMPL = "UNIQUE_CASE"
)(
    input  wire [WIDTH-1:0] SW,
    output logic [$clog2(WIDTH):0] LED
);
    localparam LED_WIDTH = $clog2(WIDTH) + 1;

    generate
        if(IMPL == "UNIQUE_CASE") begin : g_UNIQUE_CASE
            always_comb begin
                LED = '0;
                unique case(1'b1)
                    SW[15] : LED = 16;
                    SW[14] : LED = 15;
                    SW[13] : LED = 14;
                    SW[12] : LED = 13;
                    SW[11] : LED = 12;
                    SW[10] : LED = 11;
                    SW[09] : LED = 10;
                    SW[08] : LED = 09;
                    SW[07] : LED = 08;
                    SW[06] : LED = 07;
                    SW[05] : LED = 06;
                    SW[04] : LED = 05;
                    SW[03] : LED = 04;
                    SW[02] : LED = 03;
                    SW[01] : LED = 02;
                    SW[00] : LED = 01;
                endcase
            end
        end else if(IMPL == "CASE") begin : g_CASE
            always_comb begin
                LED = '0;
                case(1'b1)
                    SW[15] : LED = 16;
                    SW[14] : LED = 15;
                    SW[13] : LED = 14;
                    SW[12] : LED = 13;
                    SW[11] : LED = 12;
                    SW[10] : LED = 11;
                    SW[09] : LED = 10;
                    SW[08] : LED = 09;
                    SW[07] : LED = 08;
                    SW[06] : LED = 07;
                    SW[05] : LED = 06;
                    SW[04] : LED = 05;
                    SW[03] : LED = 04;
                    SW[02] : LED = 03;
                    SW[01] : LED = 02;
                    SW[00] : LED = 01;
                endcase
            end
        end else if(IMPL == "DOWN_FOR") begin : g_DOWN_FOR
            always_comb begin
                LED = '0;
                for(int i = $high(SW) ; i >= $low(SW); --i) begin
                    if(SW[i]) begin
                        LED = LED_WIDTH'(i) + 1;
                        break;
                    end
                end
            end
        end else if(IMPL == "UP_FOR") begin : g_UP_FOR
            always_comb begin
                LED = '0;
                for(int i = $low(SW) ; i <= $high(SW); ++i) begin
                    if(SW[i]) begin
                        LED = LED_WIDTH'(i) + 1;
                    end
                end
            end
        end
    endgenerate

endmodule
