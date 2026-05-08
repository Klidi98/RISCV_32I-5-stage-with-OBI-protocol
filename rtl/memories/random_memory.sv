/* random memory module that generates random ready and valid signals for validation of OBI protocol */


/* LATENCY_TYPE: 3 possible values:
-   0    -> full speed : ready always active, 1 cycle delay for valid 
-   1    -> light delay: ready active 80% of time, valid delay between [1:5] cycles  
-   2    -> esxtreme latency: ready active 30% of time, valid delay between [5:15] cycles
*/
module random_memory #(
    parameter string MEM_FILE = "main.hex",
    parameter int MEM_SIZE     = 1024,
    parameter int LATENCY      = 2
) (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] addr,
    input  logic [31:0] data_in,
    input  logic        req,
    input  logic        we,
    input  logic [3:0]  be,
    output logic        ready,
    output logic        valid,
    output logic [31:0] data_out
);

    // --- Dichiarazioni interne (devono stare dentro il modulo) ---
    int lat;
    int ready_dist;
    logic [31:0] mem [MEM_SIZE];
    logic [31:0] w_addr;
    logic [31:0] w_dout;
    logic        pending; 
   // logic        ready;


    initial begin
        pending = 1'b0;
        case (LATENCY) 
        0:  ready_dist = 100;
        1:  ready_dist = 80;
        2:  ready_dist = 30;
        default : ready_dist = 100;
        endcase

        $readmemh(MEM_FILE, mem);
        $display("Memory SUCCESSFULLY loaded with %s", MEM_FILE);

    end

    // --- Logica generazione Ready ---
    always @(posedge clk) begin
        if (!rst_n) begin
            ready <= 1'b0;
        end else begin
            //void'(ready_s.randomize());
//            ready <= $urandom;
            ready <= ($urandom_range(1,100) <= ready_dist);
        end
    end

    // --- Processo per accettazione e gestione richieste ---
always @(posedge clk) begin
        if (!rst_n) begin
            valid   <= 1'b0;
            pending = 1'b0; /// 
            lat     = 0;    
        end else begin
            valid <= 1'b0; 

            if (pending && lat == 1) begin
                valid    <= 1'b1;
                data_out <= w_dout;
                pending  = 1'b0; 
            end else if (pending) begin
                lat = lat - 1;
            end

        
            if (req && ready /* && !pending */) begin
                pending = 1'b1;  
                case(LATENCY)
                0:   lat     = $urandom_range(1, 1);
                1:   lat     = $urandom_range(1, 5);
                2:   lat     = $urandom_range(5, 15);
                endcase

                w_addr  <= addr;
                if (we == 1'b0) 
                    w_dout <= mem[int'(addr)];
                else begin
                    for (int i = 0; i < 4; i++) begin
                        if (be[i]) mem[int'(addr)][(i*8) +: 8] <= data_in[(i*8) +: 8];  
                    end
                end
                 if (lat == 1) begin
                    valid    <= 1'b1;
                    data_out <= mem[int'(addr)];
                    pending  = 1'b0; 
                end
            end
        end
    end
    

endmodule
                



