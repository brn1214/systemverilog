# DUT
 
### 📝 Project Setup and Definitions

* **Configuration (`cfg`):** You created a `cfg` class to store test configuration parameters, such as the `latency` (the delay in driver operations) and the `amount` (the number of transactions to generate).
* **Transaction Definition (`transaction`):** You defined a `transaction` class to encapsulate all the data for a single operation (address, write data, write enable, read data, and read valid). This allows data to be passed between verification components in a structured way.
* **Interface Implementation (`sum_if`):** You created a `sum_if` interface to define the standard communication signals between your verification environment and the **DUT** (Design Under Test), ensuring a consistent connection.

### ⚙️ Component Development

* **Design Under Test (DUT - `opDUT` / `opDUT_e`):** You designed the `opDUT` module (or `opDUT_e` for the error-injection version) to simulate a basic arithmetic unit. This module includes registers for an operation `mode`, two operands (`operandA`, `operandB`), and a `result`. It handles read and write operations to these registers via an address and control signals. The `operation` function performs the addition of `operandA` and `operandB` when you write to the result address.
* **Generator (`generator`):** You developed the `generator` class, which is responsible for creating a sequence of `transaction` objects. It generates transactions to write and read the mode register, both operands, and then triggers the operation and reads the final result. The total number of transactions is determined by the `conf.amount` variable.
* **Driver (`driver`):** You implemented the `driver` class, which takes the transactions from the **generator** (via a `mailbox`) and applies the signals to the `sum_if` interface connected to the **DUT**. It also introduces a configurable latency (`conf.latency`) before each operation.
* **Monitor (`monitor`):** You created the `monitor` class, which passively observes the signals on the DUT's `sum_if` interface. It captures the signals on each clock cycle, packages them into `transaction` objects, and sends them to the **scoreboard** through another `mailbox`.
* **Scoreboard (`scoreboard`):** You implemented the `scoreboard` class, which receives the observed transactions from the **monitor**. It maintains an internal model of the DUT's logic (the `sum` function) to calculate the expected result. Finally, it compares the actual result (`rdata`) from the DUT with the expected result, reporting any matches or errors.

### 🔬 Test Execution

* **Environment (`env`):** The `env` (environment) class acts as the orchestrator. It creates, configures, and connects all the verification components using mailboxes for communication.
* **Test Class (`test`):** The `test` class is the entry point for the simulation. It instantiates the configuration (`cfg`) and the environment (`env`), runs the environment, and waits for the **scoreboard** to finish all its comparisons. It then displays a final summary of the simulation results, showing the total number of matches and errors.
* **Top-Level Testbench (`tb_operation`):** This is the top-level module for the simulation. It instantiates the clock, reset, interface, and the **DUT**. It then starts the execution of the `test` class to begin the verification process. 🚀
