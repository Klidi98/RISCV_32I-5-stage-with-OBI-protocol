typedef struct packed {
    logic           valid;
    logic [1:0]     state;
    logic [31:7]    pc_tag;
    logic [31:2]    target;
}btb_s;


module branch_predictor (
    input  logic        clk,
    input  logic        rst_n,
    // Interfaccia Fetch (Lettura)
    input  logic [31:2] pc,
    output logic        predict_taken,
    output logic [31:0] predict_target,
    
    // Interfaccia Execute (Aggiornamento)
    input  logic        update_en,      // Attivo quando un branch viene risolto
    input  logic [31:0] pc_update,      // PC del branch che si sta risolvendo
    input  logic [31:0] actual_target,  // Dove doveva andare veramente
    input  logic        actual_taken    // Se doveva saltare veramente
);


btb_s btb_entry [0:31];
logic [4:0] btb_addr;
logic [4:0] btb_addr_upd;


assign btb_addr = pc[6:2];
assign btb_addr_upd = pc_update[6:2];


//combinational process for generating the prediction based on the current PC
//prediction is needed in the same cycle of fetching
always_comb begin

    predict_target = 32'b0;     //default value for the target, in case of not taken branch or invalid entry
    predict_taken = 1'b0;       //default value for the prediction, in case of invalid entry or not taken branch

    if (btb_entry[btb_addr].valid == 1'b1 && btb_entry[btb_addr].pc_tag == pc[31:7] ) begin

        if( btb_entry[btb_addr].state[1] ) begin
            predict_taken  = 1'b1;
            predict_target = {btb_entry[btb_addr].target, 2'b00};
        end 
    end
end


//process for updating the btb entry when a branch is resolved in the execute stage
always_ff @(posedge clk) begin

if(!rst_n) begin
    for (int i = 0; i < 32; i++) begin
        btb_entry[i].valid <= 1'b0;        //reset only valid bit
    end
end

else if (update_en) begin    //If branch instruction is resolved in exe stage

    if(actual_taken) begin   //if the branch is taken
    
        /* update btb entry only if branch is taken.
        If not taken, update only the state of the entry, but not the target and tag, 
        because not used in case of not taken branch. */
    
        

        if( btb_entry[btb_addr_upd].pc_tag == pc_update[31:7] && btb_entry[btb_addr_upd].valid ) begin
            case(btb_entry[btb_addr_upd].state)
                2'b00: btb_entry[btb_addr_upd].state <= 2'b01;
                2'b01: btb_entry[btb_addr_upd].state <= 2'b10;
                2'b10: btb_entry[btb_addr_upd].state <= 2'b11;
                2'b11: btb_entry[btb_addr_upd].state <= 2'b11;
                default: btb_entry[btb_addr_upd].state <= 2'b01;
            endcase
        end
        else begin    

            btb_entry[btb_addr_upd].valid <= 1'b1;
            btb_entry[btb_addr_upd].pc_tag  <= pc_update[31:7];
            btb_entry[btb_addr_upd].target  <= actual_target[31:2];
            btb_entry[btb_addr_upd].state   <= 2'b10;

        end
    end
    else begin       
        //if branch instruction, but not taken, check if the entry is already present in the btb,
         // if yes update the state, if not do nothing.
        if( btb_entry[btb_addr_upd].pc_tag == pc_update[31:7] && btb_entry[btb_addr_upd].valid ) begin
            case(btb_entry[btb_addr_upd].state) 
                2'b00: btb_entry[btb_addr_upd].state <= 2'b00;
                2'b01: btb_entry[btb_addr_upd].state <= 2'b00;
                2'b10: btb_entry[btb_addr_upd].state <= 2'b01;
                2'b11: btb_entry[btb_addr_upd].state <= 2'b10;
                default: btb_entry[btb_addr_upd].state <= 2'b01;
            endcase
        end

    end
end
    
end

endmodule
        
        
  