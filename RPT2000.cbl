      **************************************************************
      * AUTHOR:    Jacob Schmp
      * DATE:      02/18/2026
      * PURPOSE:   CIS352 Chapter 3 - Year-to-Date Sales Report
      **************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. RPT2000.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-CUSTMAST ASSIGN TO CUSTMAST.
           SELECT OUTPUT-RPT2000 ASSIGN TO RPT2000.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-CUSTMAST
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 130 CHARACTERS
           BLOCK CONTAINS 130 CHARACTERS.
       01  CUSTOMER-MASTER-RECORD.
           05  CM-BRANCH-NUMBER        PIC 9(2).
           05  CM-SALESREP-NUMBER      PIC 9(2).
           05  CM-CUSTOMER-NUMBER      PIC 9(5).
           05  CM-CUSTOMER-NAME        PIC X(20).
           05  CM-SALES-THIS-YTD       PIC S9(5)V9(2).
           05  CM-SALES-LAST-YTD       PIC S9(5)V9(2).
           05  FILLER                  PIC X(87).

       FD  OUTPUT-RPT2000
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 130 CHARACTERS
           BLOCK CONTAINS 130 CHARACTERS.
       01  PRINT-AREA                  PIC X(130).

       WORKING-STORAGE SECTION.
       01  SWITCHES.
           05  CUSTMAST-EOF-SWITCH     PIC X         VALUE "N".

       01  PRINT-FIELDS.
           05  PAGE-COUNT              PIC S9(3)     VALUE ZERO.
           05  LINES-ON-PAGE           PIC S9(3)     VALUE +55.
           05  LINE-COUNT              PIC S9(3)     VALUE +99.
           05  SPACE-CONTROL           PIC S9.

       01  TOTAL-FIELDS.
           05  GRAND-TOTAL-THIS-YTD    PIC S9(7)V99  VALUE ZERO.
           05  GRAND-TOTAL-LAST-YTD    PIC S9(7)V99  VALUE ZERO.

       01  CALC-FIELDS.
           05  CHANGE-AMOUNT           PIC S9(7)V99  VALUE ZERO.
           05  CHANGE-PERCENT          PIC S9(4)V9   VALUE ZERO.

       01  CURRENT-DATE-AND-TIME.
           05  CD-YEAR                 PIC 9999.
           05  CD-MONTH                PIC 99.
           05  CD-DAY                  PIC 99.
           05  CD-HOURS                PIC 99.
           05  CD-MINUTES              PIC 99.
           05  FILLER                  PIC X(9).

       01  HEADING-LINE-1.
           05  FILLER           PIC X(7)      VALUE "DATE:  ".
           05  HL1-MONTH        PIC 9(2).
           05  FILLER           PIC X(1)      VALUE "/".
           05  HL1-DAY          PIC 9(2).
           05  FILLER           PIC X(1)      VALUE "/".
           05  HL1-YEAR         PIC 9(4).
           05  FILLER           PIC X(15)     VALUE SPACES.
           05  FILLER           PIC X(25)     VALUE
                               "YEAR-TO-DATE SALES REPORT".
           05  FILLER           PIC X(15)     VALUE SPACES.
           05  FILLER           PIC X(8)      VALUE "  PAGE: ".
           05  HL1-PAGE-NUMBER  PIC ZZZ9.
           05  FILLER           PIC X(46)     VALUE SPACES.

       01  HEADING-LINE-2.
           05  FILLER                  PIC X(7)      VALUE "TIME:  ".
           05  HL2-HOURS               PIC 9(2).
           05  FILLER                  PIC X(1)      VALUE ":".
           05  HL2-MINUTES             PIC 9(2).
           05  FILLER                  PIC X(48)     VALUE SPACE.
           05  FILLER                  PIC X(7)      VALUE "RPT2000".


       01  HEADING-LINE-3.
           05  FILLER      PIC X(13)  VALUE "BRANCH SALES ".
           05  FILLER      PIC X(25)  VALUE "CUST".
           05  FILLER      PIC X(14)  VALUE "SALES".
           05  FILLER      PIC X(14)  VALUE "SALES".
           05  FILLER      PIC X(6)   VALUE "CHANGE".
           05  FILLER      PIC X(58)  VALUE SPACES.

       01  HEADING-LINE-4.
           05  FILLER      PIC X(7)   VALUE "NUM".
           05  FILLER      PIC X(5)   VALUE "REP".
           05  FILLER      PIC X(7)   VALUE "NUM".
           05  FILLER      PIC X(23)  VALUE "CUSTOMER NAME".
           05  FILLER      PIC X(14)  VALUE "THIS YTD".
           05  FILLER      PIC X(14)  VALUE "LAST YTD".
           05  FILLER      PIC X(10)  VALUE "AMOUNT".
           05  FILLER      PIC X(7)   VALUE "PERCENT".
           05  FILLER      PIC X(43)  VALUE SPACES.

       01  HEADING-LINE-5.
           05  FILLER          PIC X(6)   VALUE ALL '-'.
           05  FILLER          PIC X(1)   VALUE SPACE.
           05  FILLER          PIC X(5)   VALUE ALL '-'.
           05  FILLER          PIC X(1)   VALUE SPACE.
           05  FILLER          PIC X(5)   VALUE ALL '-'.
           05  FILLER          PIC X(2)   VALUE SPACE.
           05  FILLER          PIC X(20)  VALUE ALL '-'.
           05  FILLER          PIC X(3)   VALUE SPACE.
           05  FILLER          PIC X(10)  VALUE ALL '-'.
           05  FILLER          PIC X(4)   VALUE SPACE.
           05  FILLER          PIC X(10)  VALUE ALL '-'.
           05  FILLER          PIC X(4)   VALUE SPACE.
           05  FILLER          PIC X(10)  VALUE ALL '-'.
           05  FILLER          PIC X(3)   VALUE SPACE.
           05  FILLER          PIC X(6)   VALUE ALL '-'.

       01  CUSTOMER-LINE.
           05  CL-BRANCH-NUMBER        PIC 99.
           05  FILLER                  PIC X(4)      VALUE SPACES.
           05  CL-SALESREP-NUMBER      PIC 99.
           05  FILLER                  PIC X(3)      VALUE SPACES.
           05  CL-CUSTOMER-NUMBER      PIC 9(5).
           05  FILLER                  PIC X(2)      VALUE SPACES.
           05  CL-CUSTOMER-NAME        PIC X(20).
           05  FILLER                  PIC X(3)      VALUE SPACES.
           05  CL-SALES-THIS-YTD       PIC ZZ,ZZ9.99-.
           05  FILLER                  PIC X(4)      VALUE SPACES.
           05  CL-SALES-LAST-YTD       PIC ZZ,ZZ9.99-.
           05  FILLER                  PIC X(4)      VALUE SPACES.
           05  CL-CHANGE-AMOUNT        PIC ZZ,ZZ9.99-.
           05  FILLER                  PIC X(3)      VALUE SPACES.
           05  CL-CHANGE-PERCENT       PIC ZZZ.9-.
           05  FILLER                  PIC X(41)     VALUE SPACES.

       01  GRAND-TOTAL-LINE-1.
           05  FILLER                  PIC X(27)     VALUE SPACE.
           05  FILLER                  PIC X(13)     VALUE ALL "=".
           05  FILLER                  PIC X(1)      VALUE SPACE.
           05  FILLER                  PIC X(13)     VALUE ALL "=".
           05  FILLER                  PIC X(1)      VALUE SPACE.
           05  FILLER                  PIC X(13)     VALUE ALL "=".
           05  FILLER                  PIC X(3)      VALUE SPACE.
           05  FILLER                  PIC X(6)      VALUE ALL "=".
           05  FILLER                  PIC X(53)     VALUE SPACES.

       01  GRAND-TOTAL-LINE-2.
           05  FILLER                  PIC X(29)     VALUE SPACE.
           05  GTL-SALES-THIS-YTD      PIC ZZZ,ZZ9.99-.
           05  FILLER                  PIC X(3)      VALUE SPACE.
           05  GTL-SALES-LAST-YTD      PIC ZZZ,ZZ9.99-.
           05  FILLER                  PIC X(3)      VALUE SPACE.
           05  GTL-CHANGE-AMOUNT       PIC ZZZ,ZZ9.99-.
           05  FILLER                  PIC X(4)      VALUE SPACE.
           05  GTL-CHANGE-PERCENT      PIC ZZZ.9-.
           05  FILLER                  PIC X(61)     VALUE SPACES.

       PROCEDURE DIVISION.
       000-PREPARE-SALES-REPORT.
           OPEN INPUT  INPUT-CUSTMAST
                OUTPUT OUTPUT-RPT2000.
           PERFORM 100-FORMAT-REPORT-HEADING.
           PERFORM 200-PREPARE-SALES-LINES
               UNTIL CUSTMAST-EOF-SWITCH = "Y".
           PERFORM 300-PRINT-GRAND-TOTALS.
           CLOSE INPUT-CUSTMAST
                 OUTPUT-RPT2000.
           STOP RUN.

       100-FORMAT-REPORT-HEADING.
           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME.
           MOVE CD-MONTH   TO HL1-MONTH.
           MOVE CD-DAY     TO HL1-DAY.
           MOVE CD-YEAR    TO HL1-YEAR.
           MOVE CD-HOURS   TO HL2-HOURS.
           MOVE CD-MINUTES TO HL2-MINUTES.

       200-PREPARE-SALES-LINES.
           PERFORM 210-READ-CUSTOMER-RECORD.
           IF CUSTMAST-EOF-SWITCH = "N"
               PERFORM 220-PRINT-CUSTOMER-LINE.

       210-READ-CUSTOMER-RECORD.
           READ INPUT-CUSTMAST
               AT END
                   MOVE "Y" TO CUSTMAST-EOF-SWITCH.

       220-PRINT-CUSTOMER-LINE.
           IF LINE-COUNT >= LINES-ON-PAGE
               PERFORM 230-PRINT-HEADING-LINES.
           PERFORM 225-CALCULATE-CHANGE-FIELDS.
           MOVE CM-CUSTOMER-NUMBER  TO CL-CUSTOMER-NUMBER.
           MOVE CM-CUSTOMER-NAME    TO CL-CUSTOMER-NAME.
           MOVE CM-SALES-THIS-YTD   TO CL-SALES-THIS-YTD.
           MOVE CM-SALES-LAST-YTD   TO CL-SALES-LAST-YTD.
           MOVE CM-BRANCH-NUMBER    TO CL-BRANCH-NUMBER.
           MOVE CM-SALESREP-NUMBER  TO CL-SALESREP-NUMBER.
           MOVE CHANGE-AMOUNT       TO CL-CHANGE-AMOUNT.
           MOVE CHANGE-PERCENT      TO CL-CHANGE-PERCENT.
           MOVE CUSTOMER-LINE TO PRINT-AREA.
           WRITE PRINT-AREA.
           ADD 1 TO LINE-COUNT.
           ADD CM-SALES-THIS-YTD TO GRAND-TOTAL-THIS-YTD.
           ADD CM-SALES-LAST-YTD TO GRAND-TOTAL-LAST-YTD.

       225-CALCULATE-CHANGE-FIELDS.
           SUBTRACT CM-SALES-LAST-YTD FROM CM-SALES-THIS-YTD
               GIVING CHANGE-AMOUNT.
           IF CM-SALES-LAST-YTD = 0
               MOVE 999.9 TO CHANGE-PERCENT
           ELSE
               COMPUTE CHANGE-PERCENT =
                   (CHANGE-AMOUNT / CM-SALES-LAST-YTD) * 100
           END-IF.

       230-PRINT-HEADING-LINES.
           ADD 1 TO PAGE-COUNT.
           MOVE PAGE-COUNT     TO HL1-PAGE-NUMBER.
           MOVE HEADING-LINE-1 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-2 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-3 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-4 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-5 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE ZERO TO LINE-COUNT.

       300-PRINT-GRAND-TOTALS.
           MOVE GRAND-TOTAL-LINE-1 TO PRINT-AREA.
           WRITE PRINT-AREA.
           SUBTRACT GRAND-TOTAL-LAST-YTD FROM GRAND-TOTAL-THIS-YTD
               GIVING CHANGE-AMOUNT.
           IF GRAND-TOTAL-LAST-YTD = 0
               MOVE 999.9 TO CHANGE-PERCENT
           ELSE
               COMPUTE CHANGE-PERCENT =
                   (CHANGE-AMOUNT / GRAND-TOTAL-LAST-YTD) * 100
           END-IF.
           MOVE GRAND-TOTAL-THIS-YTD TO GTL-SALES-THIS-YTD.
           MOVE GRAND-TOTAL-LAST-YTD TO GTL-SALES-LAST-YTD.
           MOVE CHANGE-AMOUNT        TO GTL-CHANGE-AMOUNT.
           MOVE CHANGE-PERCENT       TO GTL-CHANGE-PERCENT.
           MOVE GRAND-TOTAL-LINE-2   TO PRINT-AREA.
           WRITE PRINT-AREA.
