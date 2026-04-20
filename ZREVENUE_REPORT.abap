*&---------------------------------------------------------------------*
*& Report  ZREVENUE_REPORT
*& Title:  Customer Order & Revenue Analysis Report
*& Author: Harshil Mainra
*& Roll No: 2306028
*& Course: SAP ABAP Developer (IS30040)
*& Institute: KIIT University, Bhubaneswar
*& Date: April 2026
*&---------------------------------------------------------------------*
*& Description:
*& This report provides an end-to-end Customer Order and Revenue
*& Analysis by joining Sales Order Header (VBAK), Sales Order Item
*& (VBAP), and Customer Master (KNA1) tables. It includes a dynamic
*& selection screen, ALV Grid display with subtotals, zebra striping,
*& and optimized column widths. The report helps business users
*& analyze order volumes and revenue by customer, document type,
*& and sales organization.
*&---------------------------------------------------------------------*

REPORT zrevenue_report.

*----------------------------------------------------------------------*
* TYPE DECLARATIONS
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_revenue,
         vbeln TYPE vbak-vbeln,       " Sales Document Number
         erdat TYPE vbak-erdat,       " Order Creation Date
         auart TYPE vbak-auart,       " Sales Document Type
         vkorg TYPE vbak-vkorg,       " Sales Organization
         vtweg TYPE vbak-vtweg,       " Distribution Channel
         spart TYPE vbak-spart,       " Division
         kunnr TYPE vbak-kunnr,       " Customer Number
         name1 TYPE kna1-name1,       " Customer Name
         ort01 TYPE kna1-ort01,       " Customer City
         land1 TYPE kna1-land1,       " Country
         posnr TYPE vbap-posnr,       " Item Number
         matnr TYPE vbap-matnr,       " Material Number
         arktx TYPE vbap-arktx,       " Short Description
         pstyv TYPE vbap-pstyv,       " Item Category
         kwmeng TYPE vbap-kwmeng,     " Order Quantity
         vrkme TYPE vbap-vrkme,       " Unit of Measure
         netwr TYPE vbap-netwr,       " Net Value
         waerk TYPE vbap-waerk,       " Currency
       END OF ty_revenue.

*----------------------------------------------------------------------*
* DATA DECLARATIONS
*----------------------------------------------------------------------*
DATA: gt_revenue    TYPE STANDARD TABLE OF ty_revenue,
      gs_revenue    TYPE ty_revenue,
      o_container   TYPE REF TO cl_gui_custom_container,
      o_grid        TYPE REF TO cl_gui_alv_grid,
      gs_layout     TYPE lvc_s_layo,
      gt_fieldcat   TYPE lvc_t_fcat,
      gs_fieldcat   TYPE lvc_s_fcat,
      gt_sort       TYPE lvc_t_sort,
      gs_sort       TYPE lvc_s_sort,
      gv_total_rev  TYPE vbap-netwr,
      gv_rec_count  TYPE i.

*----------------------------------------------------------------------*
* SELECTION SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_vbeln FOR gs_revenue-vbeln,     " Sales Document
                  s_erdat FOR gs_revenue-erdat,      " Creation Date
                  s_kunnr FOR gs_revenue-kunnr,      " Customer Number
                  s_vkorg FOR gs_revenue-vkorg,      " Sales Org
                  s_auart FOR gs_revenue-auart.       " Doc Type

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

  PARAMETERS: p_maxrow TYPE i DEFAULT 500,           " Max Rows
              p_zebra  TYPE c DEFAULT 'X'.            " Zebra Stripes

SELECTION-SCREEN END OF BLOCK b2.

*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
  TEXT-001 = 'Selection Criteria'.
  TEXT-002 = 'Display Options'.

*----------------------------------------------------------------------*
* START OF SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM check_data.

*----------------------------------------------------------------------*
* END OF SELECTION
*----------------------------------------------------------------------*
END-OF-SELECTION.

  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Form FETCH_DATA
*& Fetches data from VBAK, VBAP and KNA1 tables
*&---------------------------------------------------------------------*
FORM fetch_data.
  SELECT
      a~vbeln,
      a~erdat,
      a~auart,
      a~vkorg,
      a~vtweg,
      a~spart,
      a~kunnr,
      c~name1,
      c~ort01,
      c~land1,
      b~posnr,
      b~matnr,
      b~arktx,
      b~pstyv,
      b~kwmeng,
      b~vrkme,
      b~netwr,
      b~waerk
    UP TO @p_maxrow ROWS
    INTO TABLE @gt_revenue
    FROM vbak AS a
    INNER JOIN vbap AS b
      ON b~vbeln EQ a~vbeln
    LEFT OUTER JOIN kna1 AS c
      ON c~kunnr EQ a~kunnr
    WHERE a~vbeln IN @s_vbeln
      AND a~erdat IN @s_erdat
      AND a~kunnr IN @s_kunnr
      AND a~vkorg IN @s_vkorg
      AND a~auart IN @s_auart.

  IF sy-subrc <> 0.
    MESSAGE 'No records found for the given selection criteria.' TYPE 'I'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CHECK_DATA
*& Validates fetched data and computes summary statistics
*&---------------------------------------------------------------------*
FORM check_data.

  gv_rec_count = lines( gt_revenue ).

  LOOP AT gt_revenue INTO gs_revenue.
    gv_total_rev = gv_total_rev + gs_revenue-netwr.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*& Builds the field catalog for ALV Grid display
*&---------------------------------------------------------------------*
FORM build_fieldcat.

  DEFINE add_field.
    CLEAR gs_fieldcat.
    gs_fieldcat-fieldname  = &1.
    gs_fieldcat-coltext    = &2.
    gs_fieldcat-outputlen  = &3.
    gs_fieldcat-just       = &4.
    APPEND gs_fieldcat TO gt_fieldcat.
  END-OF-DEFINITION.

  add_field 'VBELN'  'Sales Doc'        12  'L'.
  add_field 'ERDAT'  'Created On'       10  'C'.
  add_field 'AUART'  'Doc Type'          6  'C'.
  add_field 'VKORG'  'Sales Org'         6  'C'.
  add_field 'VTWEG'  'Dist. Channel'     6  'C'.
  add_field 'SPART'  'Division'          6  'C'.
  add_field 'KUNNR'  'Customer No'      10  'L'.
  add_field 'NAME1'  'Customer Name'    30  'L'.
  add_field 'ORT01'  'City'             20  'L'.
  add_field 'LAND1'  'Country'           6  'C'.
  add_field 'POSNR'  'Item'              6  'C'.
  add_field 'MATNR'  'Material'         18  'L'.
  add_field 'ARKTX'  'Description'      25  'L'.
  add_field 'PSTYV'  'Item Cat'          6  'C'.
  add_field 'KWMENG' 'Quantity'         12  'R'.
  add_field 'VRKME'  'UOM'               4  'C'.
  add_field 'NETWR'  'Net Value'        15  'R'.
  add_field 'WAERK'  'Currency'          5  'C'.

  " Mark quantity and net value as numeric/amount fields
  READ TABLE gt_fieldcat INTO gs_fieldcat
    WITH KEY fieldname = 'KWMENG'.
  IF sy-subrc = 0.
    gs_fieldcat-do_sum = abap_true.
    MODIFY gt_fieldcat FROM gs_fieldcat
      TRANSPORTING do_sum
      WHERE fieldname = 'KWMENG'.
  ENDIF.

  READ TABLE gt_fieldcat INTO gs_fieldcat
    WITH KEY fieldname = 'NETWR'.
  IF sy-subrc = 0.
    gs_fieldcat-do_sum = abap_true.
    MODIFY gt_fieldcat FROM gs_fieldcat
      TRANSPORTING do_sum
      WHERE fieldname = 'NETWR'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_LAYOUT
*& Sets the ALV Grid layout properties
*&---------------------------------------------------------------------*
FORM build_layout.

  gs_layout-zebra      = p_zebra.
  gs_layout-cwidth_opt = abap_true.
  gs_layout-sel_mode   = 'A'.
  gs_layout-info_fname = space.
  gs_layout-grid_title = 'Customer Order & Revenue Analysis'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_SORT
*& Defines sort criteria for ALV output
*&---------------------------------------------------------------------*
FORM build_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'KUNNR'.
  gs_sort-spos      = 1.
  gs_sort-up        = abap_true.
  gs_sort-subtot    = abap_true.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'VBELN'.
  gs_sort-spos      = 2.
  gs_sort-up        = abap_true.
  APPEND gs_sort TO gt_sort.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*& Creates and displays the ALV Grid
*&---------------------------------------------------------------------*
FORM display_alv.

  PERFORM build_fieldcat.
  PERFORM build_layout.
  PERFORM build_sort.

  CREATE OBJECT o_container
    EXPORTING
      container_name = 'ZREV_CONT'
    EXCEPTIONS
      OTHERS         = 6.

  IF sy-subrc <> 0.
    MESSAGE 'Error creating container.' TYPE 'E'.
    RETURN.
  ENDIF.

  CREATE OBJECT o_grid
    EXPORTING
      i_parent = o_container
    EXCEPTIONS
      OTHERS   = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error creating ALV Grid.' TYPE 'E'.
    RETURN.
  ENDIF.

  CALL METHOD o_grid->set_table_for_first_display
    EXPORTING
      is_layout     = gs_layout
    CHANGING
      it_outtab     = gt_revenue
      it_fieldcatalog = gt_fieldcat
      it_sort       = gt_sort
    EXCEPTIONS
      OTHERS        = 4.

  IF sy-subrc <> 0.
    MESSAGE 'Error displaying ALV Grid.' TYPE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZREV_STATUS'.
  SET TITLEBAR  'ZREV_TITLE'.
  PERFORM display_alv.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module USER_COMMAND_0100 INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'REFR'.
      PERFORM fetch_data.
      IF o_grid IS BOUND.
        CALL METHOD o_grid->refresh_table_display.
      ENDIF.
  ENDCASE.
ENDMODULE.
