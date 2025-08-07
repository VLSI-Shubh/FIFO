# 🧠 Synchronous FIFO (First-In-First-Out) Buffer

---

## 📘 Project Overview

This project implements a **synchronous FIFO** buffer in Verilog. FIFO memory structures are essential for temporary data storage in hardware pipelines, inter-module communication, and clock domain crossing (with asynchronous variants). The FIFO operates with **parameterized depth and width**, making it flexible for a variety of use-cases.

---

## 📚 Concept
![FIFO Concept](https://github.com/VLSI-Shubh/FIFO/blob/b34a639a8585a52b40fa94ca9ac9d35157e2afeb/fifo.png)
* **FIFO (First-In-First-Out)**: Data is written into the FIFO and read out in the exact order it was written.  
* **Synchronous**: Both read and write operations are clocked by the **same clock** signal.  
* **Pointer-Based**: Read and write pointers track positions.  
* **Flags**: `full` and `empty` status flags are maintained.

---

## ⚙️ Implementation Details

* **Reset** clears all flags and pointers.  
* Write (`wr`) and Read (`rd`) are **separate enables**.  
* When writing, data is stored and the write pointer increments.  
* When reading, data is output and the read pointer increments.  
* `data_out` is `zz` (high impedance) when no read is active.

---

## 🧪 Output Waveform
![FIFO Waveform](https://github.com/VLSI-Shubh/FIFO/blob/7f2c4ad7a8a67c25752c1d7e665ec7a0118ec4bf/Sync_fifo_output.png)
### ⏱️ Behavioral Transition Summary 

This table outlines critical FIFO transitions with clear commentary based on the waveform behavior.

| Time (ns) | rst | wr | rd | data_in | data_out | full | empty | Explanation                         |
| --------- | --- | -- | -- | ------- | -------- | ---- | ----- | --------------------------------- |
| 0         | 1   | 0  | 0  | 0       | 0        | 0    | 1     | Reset asserted — FIFO is cleared  |
| 13        | 0   | 0  | 0  | 0       | 0        | 0    | 1     | Reset deasserted — FIFO is empty  |
| 23        | 0   | 1  | 0  | 10      | zz       | 0    | 1     | First write of 10 initiated       |
| 25        | 0   | 1  | 0  | 10      | zz       | 0    | 0     | 10 committed — FIFO no longer empty |
| 33        | 0   | 1  | 0  | 20      | zz       | 0    | 0     | Write 20                         |
| 43        | 0   | 1  | 0  | 30      | zz       | 0    | 0     | Write 30                         |
| 53        | 0   | 0  | 0  | 30      | zz       | 0    | 0     | No operation                     |
| 63        | 0   | 0  | 1  | 30      | zz       | 0    | 0     | Read requested                   |
| 65        | 0   | 0  | 1  | 30      | 10       | 0    | 0     | Read outputs 10                  |
| 75        | 0   | 0  | 1  | 30      | 20       | 0    | 0     | Read outputs 20                  |
| 85        | 0   | 0  | 1  | 30      | 30       | 0    | 1     | Read outputs 30 — FIFO now empty |
| 103       | 0   | 1  | 0  | 40      | zz       | 0    | 1     | Write 40 initiated              |
| 105       | 0   | 1  | 0  | 40      | zz       | 0    | 0     | 40 committed                    |
| 113       | 0   | 1  | 0  | 50      | zz       | 0    | 0     | Write 50                       |
| 123       | 0   | 1  | 0  | 60      | zz       | 0    | 0     | Write 60                       |
| 133       | 0   | 1  | 0  | 70      | zz       | 0    | 0     | Write 70                       |
| 143       | 0   | 1  | 0  | 80      | zz       | 0    | 0     | Write 80                       |
| 153       | 0   | 0  | 0  | 80      | zz       | 0    | 0     | No operation                   |
| 163       | 0   | 0  | 1  | 80      | zz       | 0    | 0     | Read request                  |
| 165       | 0   | 0  | 1  | 80      | 40       | 0    | 0     | Read 40                       |
| 175       | 0   | 0  | 1  | 80      | 50       | 0    | 0     | Read 50                       |
| 185       | 0   | 0  | 1  | 80      | 60       | 0    | 0     | Read 60                       |
| 195       | 0   | 0  | 1  | 80      | 70       | 0    | 0     | Read 70                       |
| 205       | 0   | 0  | 1  | 80      | 80       | 0    | 1     | Read 80 — FIFO empty again    |

> 💡 `zz` indicates high impedance output when read is not asserted.

---

### 📊 VCD/Waveform Analysis

The VCD file shows FIFO working correctly:

* Writes happen sequentially, and data is held until reads occur.  
* Read data matches the order of written values.  
* Flags `full` and `empty` change accurately based on buffer usage.

---

## 📁 Project Files

| File        | Description              |
| ----------- | ------------------------ |
| `fifo.v`    | Main FIFO module         |
| `fifo_tb.v` | Testbench for FIFO       |
| `fifo.vcd`  | Simulation waveform dump |

---

## 🛠️ Tools Used

* **ModelSim / QuestaSim**: For simulation  
* **GTKWave**: For waveform visualization  
* **readme.so**: README builder  

---

## 📐 Sample FIFO Depth Calculation

Correctly sizing a FIFO is critical for maintaining data integrity and optimal system performance. Below are some key considerations:

- **Undersized FIFO:**
  - May lead to frequent overflows.
  - Causes loss of data during bursty or high-throughput input conditions.
  - Increases backpressure on upstream components.

- **Oversized FIFO:**
  - Wastes silicon area and power.
  - Increases latency unnecessarily.
  - Can complicate timing closure in high-speed designs.

➡️ Proper FIFO sizing is essential and should be based on system throughput, burst size, clock domain crossing considerations, and latency tolerance.

📎 [See this PDF](https://github.com/VLSI-Shubh/FIFO/blob/45c73236de36b09360d909a3c76a3f9d2e6ef76d/Sample%20FIFO%20Depth%20calculations.pdf) for example calculations.


---

## ✅ Conclusion

This project confirms functional operation of a **parameterized synchronous FIFO**. It demonstrates a solid understanding of memory buffering, pointer control, flag generation, and simulation-driven debugging.

---

## 🚀 Future Work

The next step is to implement an **asynchronous FIFO**, which allows reliable data transfer between two clock domains that are not synchronized. This involves using dual-clock logic, proper metastability handling (e.g., using Gray code pointers), and additional synchronizer stages to ensure safe read/write pointer comparisons. Asynchronous FIFOs are commonly used in systems like UARTs, network buffers, and DMA engines where clock domains differ.

---

## ⚖️ License

Open for educational and personal use under the [MIT License](https://github.com/VLSI-Shubh/FIFO/blob/000acc181063239838545712b3d4923562977808/License.txt)

