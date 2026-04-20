# SAP ABAP Capstone Project
## Customer Order & Revenue Analysis Report (`ZREVENUE_REPORT`)

**Author:** Harshil Mainra  
**Roll Number:** 2306028  
**Course:** SAP ABAP Developer (IS30040)  
**Institute:** KIIT University, Bhubaneswar  
**Batch:** 2026  

---

## Project Overview

This project implements a **Custom ALV Grid Report** in SAP ABAP that provides an end-to-end Customer Order and Revenue Analysis. The report fetches and displays sales order data enriched with customer master information, enabling business users to analyze revenue, order volumes, and customer-wise performance directly from SAP.

---

## Problem Statement

Sales teams and finance departments need a consolidated, filterable view of customer orders with revenue data across multiple dimensions (customer, sales organization, date range, document type). Standard SAP reports are either too granular or too summarized. A custom ABAP report is required that:

- Combines data from Sales Order Header, Item, and Customer Master tables
- Allows dynamic filtering via a selection screen
- Displays results in an interactive ALV Grid with subtotals
- Supports sorting by customer and document number

---

## Solution & Features

| Feature | Details |
|---|---|
| **Selection Screen** | Filter by Sales Document, Date Range, Customer, Sales Org, Document Type |
| **3-Table JOIN** | VBAK (Header) + VBAP (Item) + KNA1 (Customer Master) |
| **ALV Grid Display** | Interactive grid with zebra stripes, column optimization |
| **Subtotals** | Revenue and Quantity subtotals grouped by Customer |
| **Sort Criteria** | Auto-sorted by Customer → Sales Document |
| **Custom Field Catalog** | 18 fields with proper headers, widths, justification |
| **Refresh Button** | Re-fetch data without leaving the screen |
| **Max Rows Control** | Configurable row limit (default 500) |

---

## Tech Stack

| Component | Technology |
|---|---|
| Language | SAP ABAP (Advanced Business Application Programming) |
| IDE | SAP SE38 / Eclipse with ADT |
| UI Framework | ALV Grid (`CL_GUI_ALV_GRID`) |
| Database Tables | VBAK, VBAP, KNA1 |
| SAP Module | SD (Sales & Distribution) |
| Screen | Custom Screen 100 with Container Control |
| GUI Tools | SE51 (Screen Painter), SE41 (Menu Painter) |

---

## SAP Tables Reference

| Table | Description | Key Fields Used |
|---|---|---|
| `VBAK` | Sales Order Header | VBELN, ERDAT, AUART, VKORG, KUNNR |
| `VBAP` | Sales Order Item | POSNR, MATNR, KWMENG, NETWR, WAERK |
| `KNA1` | Customer Master | NAME1, ORT01, LAND1 |

---

## SAP Transactions Used

| T-Code | Purpose |
|---|---|
| `SE38` | ABAP Editor — write and activate the report |
| `SE11` | Data Dictionary — view table structures |
| `SE51` | Screen Painter — design Screen 100 |
| `SE41` | Menu Painter — create GUI Status |
| `SE80` | Object Navigator — full project view |
| `VA01` | Create Sales Order (test data) |
| `VA03` | Display Sales Order |

---

## File Structure

```
SAP-ABAP-Capstone/
│
├── ZREVENUE_REPORT.abap          # Main ABAP report program
├── ZREVENUE_REPORT_NOTES.abap    # Setup notes & DD reference
└── README.md                     # This file
```

---

## How to Run

1. Open **SE38** in your SAP system
2. Enter program name `ZREVENUE_REPORT` and click Create
3. Paste the contents of `ZREVENUE_REPORT.abap`
4. **Activate** the program (`Ctrl+F3`)
5. Open **SE51**, create Screen 100 with a custom container named `ZREV_CONT`
6. Open **SE41**, create GUI Status `ZREV_STATUS` with Back/Exit/Cancel/Refresh
7. Press **F8** to execute → enter selection criteria → press Execute

---

## Unique Points (vs. standard ALV reports)

1. **3-table JOIN** including Customer Master (KNA1) — most basic reports only join VBAK+VBAP
2. **Dynamic selection screen** with 5 independent filter options
3. **Programmatic field catalog** with custom headers and justification per field
4. **Customer-wise subtotals** on both Revenue and Quantity
5. **Refresh capability** without re-running the report from scratch

---

## Future Improvements

- Add a **Summary Tab** showing total revenue per customer (grouped ALV)
- Include **Delivery Status** from VBUP table
- Add **Export to Excel** button using ALV built-in toolbar
- Implement **Top-of-Page** header with company logo and run timestamp
- Add **drill-down** — click a sales order to navigate to VA03

---

## References

- SAP Help Portal: https://help.sap.com
- SAP ABAP ALV Grid Documentation: https://help.sap.com/docs/SAP_NETWEAVER
- KIIT Kareer School SAP ABAP Developer Course (IS30040)
