CLASS zrdo_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS for_read
      RETURNING
        VALUE(ro_operation) TYPE REF TO zrdo_operation.

    CLASS-METHODS for_create
      RETURNING
        VALUE(ro_operation) TYPE REF TO zrdo_operation.

    CLASS-METHODS for_update
      RETURNING
        VALUE(ro_operation) TYPE REF TO zrdo_operation.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zrdo_factory IMPLEMENTATION.

  METHOD for_read.
    ro_operation = NEW #( ).
    ro_operation->ls_request_r-op = if_abap_behv=>op-r-read.
    ro_operation->mv_operation = ro_operation->ls_request_r-op.
  ENDMETHOD.

  METHOD for_create.
    ro_operation = NEW #( ).
    ro_operation->ls_request_m-op = if_abap_behv=>op-m-create.
    ro_operation->mv_operation = ro_operation->ls_request_m-op.
  ENDMETHOD.


  METHOD for_update.
    ro_operation = NEW #( ).
    ro_operation->ls_request_M-op = if_abap_behv=>op-m-update.
    ro_operation->mv_operation = ro_operation->ls_request_m-op.
  ENDMETHOD.

ENDCLASS.
