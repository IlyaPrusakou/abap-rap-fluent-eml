CLASS zrdo_buffer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC GLOBAL FRIENDS zrdo_operation.

  PUBLIC SECTION.
    CLASS-METHODS get_buffer
      RETURNING VALUE(ro_buffer) TYPE REF TO zrdo_buffer.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA so_buffer TYPE REF TO zrdo_buffer.

    DATA mt_package_m TYPE abp_behv_changes_tab.
    DATA mt_package_r TYPE abp_behv_retrievals_tab.
    DATA ls_request_m TYPE abp_behv_changes.
    DATA ls_request_r TYPE abp_behv_retrievals.

    DATA mt_mapped TYPE abp_behv_response_tab.
    DATA mt_failed TYPE abp_behv_response_tab.
    DATA mt_reported TYPE abp_behv_response_tab.
    DATA mt_result TYPE REF TO data.
    DATA mt_link TYPE REF TO data.

ENDCLASS.

CLASS zrdo_buffer IMPLEMENTATION.
  METHOD get_buffer.

    IF so_buffer IS BOUND.
      ro_buffer = so_buffer.
      RETURN.
    ENDIF.

    so_buffer = NEW zrdo_buffer( ).

  ENDMETHOD.

ENDCLASS.
