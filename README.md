# RPT2000 (COBOL) — Year-to-Date Sales Report

This COBOL program is designed to process customer master records and generate a comprehensive Year-to-Date (YTD) Sales Report. It reads data from a sequential input file, calculates critical sales performance metrics, and produces a professional, multi-page business document with automated system date and time stamps.

## What it does

For each customer record processed from the `CUSTMAST` input file, the program performs the following logic:
* **Data Retrieval:** Reads branch numbers, sales representative IDs, and customer names from the master record.
* **Financial Performance Calculation:** Uses a `SUBTRACT` statement to calculate the "Change Amount" between current year-to-date sales and last year's sales.
* **Growth Analysis:** Employs a `COMPUTE` statement to determine the "Change Percent" for each account.
* **Zero-Value Handling:** Includes specialized conditional logic to handle new accounts with zero previous sales, displaying a standard growth indicator of 999.9 to prevent division-by-zero errors.
* **Company Aggregation:** Accumulates corporation-wide grand totals for all sales categories, displaying a final summary with professional double-line dividers.

## COBOL Concepts Used

In this assignment, I implemented several enterprise computing concepts to meet professional standards:
* **Program Header Documentation:** Organized the `IDENTIFICATION DIVISION` with specific author details, project metadata, and dates as required for standard program headers.
* **File-Control & Data Definitions:** Configured `SELECT` and `ASSIGN` statements to bridge internal program file names with external JCL Data Definition (DD) names.
* **Numeric Editing:** Applied specialized `PIC` strings (such as `ZZ,ZZ9.99-`) to format raw financial data into human-readable formats with proper sign handling for negative values.
* **Procedural Logic & Looping:** Utilized `PERFORM` and `PERFORM UNTIL` for modular execution and iterative record processing until the End-Of-File (EOF) switch is triggered.
* **Report Engineering:** Implemented page overflow logic and multi-line heading structures (`HEADING-LINE-1` through `HEADING-LINE-5`) for a clean, professional output.



## Program Output

Below is a screenshot of the program execution showing the formatted report summary:

![RPT2000 Execution Output](assets/output.png)

## Self-Review

* **Accuracy:** The program successfully generates the correct **Change Amount** and **Change Percent** for all records, including negative growth accounts.
* **Formatting:** All output lines are exactly 130 characters and follow the required alignment for PIC and VALUE clauses.
* **JCL Configuration:** The accompanying `JCLRPT2` file correctly points to the `RPT2000` output dataset as specified.
* **Code Quality:** Naming conventions for new data items (`GRAND-TOTAL-LINE-2`, etc.) follow the provided project guidelines.

## Author

**Jacob Schamp** **GitHub:** [@jascha10](https://github.com/jascha10)
