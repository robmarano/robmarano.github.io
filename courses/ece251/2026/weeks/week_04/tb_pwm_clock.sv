module tb_pwm_clock;
    logic clk_25_percent;
    logic clk_75_percent;

    // 25% Duty Cycle
    initial begin
        clk_25_percent = 0;
        forever begin
            #2.5 clk_25_percent = 1; // High for 2.5ns
            #7.5 clk_25_percent = 0; // Low for 7.5ns (Total Period = 10ns)
        end
    end

    // 75% Duty Cycle
    initial begin
        clk_75_percent = 0;
        forever begin
            #7.5 clk_75_percent = 1; 
            #2.5 clk_75_percent = 0; 
        end
    end

    initial begin
        $display("\n=========================================");
        $display("      Example 3C.1: PWM (Simulation)     ");
        $display("=========================================");
        $monitor("Time=%03.1f | 25%% Clk=%b | 75%% Clk=%b", $time, clk_25_percent, clk_75_percent);
        #30;
        $display("=========================================\n");
        $finish;
    end
endmodule
