*&---------------------------------------------------------------------*
*& Program: ZREVENUE_REPORT_NOTES
*& Purpose: Data Dictionary Objects & System Setup Reference
*& Author:  Harshil Mainra | Roll: 2306028 | KIIT University
*&---------------------------------------------------------------------*
*
*  ================================================================
*  SAP TABLES USED IN THIS PROJECT
*  ================================================================
*
*  1. VBAK – Sales Document: Header Data
*     Key Fields: VBELN (Sales Doc No), ERDAT (Creation Date),
*                 AUART (Doc Type), VKORG (Sales Org),
*                 KUNNR (Customer No)
*
*  2. VBAP – Sales Document: Item Data
*     Key Fields: VBELN (Sales Doc No), POSNR (Item No),
*                 MATNR (Material), KWMENG (Quantity),
*                 NETWR (Net Value), WAERK (Currency)
*
*  3. KNA1 – Customer Master: General Data
*     Key Fields: KUNNR (Customer No), NAME1 (Customer Name),
*                 ORT01 (City), LAND1 (Country)
*
*  ================================================================
*  SAP TRANSACTIONS USED
*  ================================================================
*
*  SE38  – ABAP Editor (create/edit/activate report)
*  SE11  – Data Dictionary (view table structures)
*  SE80  – Object Navigator (full project view)
*  SM30  – Table Maintenance (view table data)
*  VA01  – Create Sales Order
*  VA03  – Display Sales Order
*  SE51  – Screen Painter (design Screen 100)
*  SE41  – Menu Painter (create GUI Status & Title)
*
*  ================================================================
*  SCREEN 100 DESIGN (SE51)
*  ================================================================
*
*  - Custom Container Control named: ZREV_CONT
*  - Full screen area assigned to container
*  - Module: STATUS_0100 (OUTPUT) -> sets PF-Status & Titlebar
*  - Module: USER_COMMAND_0100 (INPUT) -> handles user commands
*
*  ================================================================
*  GUI STATUS: ZREV_STATUS (SE41)
*  ================================================================
*
*  Function Keys:
*  F3  / BACK  -> Back
*  F15 / EXIT  -> Exit
*  F12 / CANC  -> Cancel
*  F5  / REFR  -> Refresh
*
*  ================================================================
*  UNIQUE FEATURES vs. BASIC ALV REPORT
*  ================================================================
*
*  1. SELECTION SCREEN with 5 dynamic filter criteria
*     (Sales Doc, Date Range, Customer, Sales Org, Doc Type)
*
*  2. THREE TABLE JOIN: VBAK + VBAP + KNA1
*     (friend's report only joins VBAK + VBAP)
*
*  3. CUSTOMER MASTER DATA included
*     (Customer Name, City, Country from KNA1)
*
*  4. SUBTOTALS by Customer (do_sum on NETWR and KWMENG)
*
*  5. SORT CRITERIA built programmatically
*     (by Customer then by Sales Document)
*
*  6. CUSTOM FIELD CATALOG with proper column headers,
*     widths, and justification for each field
*
*  7. REFRESH functionality (F5 key)
*
*  8. MAX ROWS parameter to control data volume
*
*  9. ZEBRA STRIPING toggle via checkbox parameter
*
*  ================================================================
*  HOW TO ACTIVATE AND RUN
*  ================================================================
*
*  Step 1: Open SE38 in SAP system
*  Step 2: Enter program name ZREVENUE_REPORT
*  Step 3: Paste the ZREVENUE_REPORT.abap code
*  Step 4: Activate (Ctrl+F3)
*  Step 5: Open SE51, create Screen 100 with custom container
*          named ZREV_CONT
*  Step 6: Open SE41, create GUI Status ZREV_STATUS with
*          standard Back/Exit/Cancel buttons + Refresh
*  Step 7: Execute (F8) - enter selection criteria - Execute
*
*  ================================================================
