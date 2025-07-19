CLASS zrdo_operation DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE GLOBAL FRIENDS zrdo_factory.

  PUBLIC SECTION.

    DATA mv_operation TYPE abp_behv_op_read.

    METHODS target_entity
      IMPORTING
        iv_target_entity TYPE abp_entity_name
      RETURNING
        VALUE(ro_api)    TYPE REF TO zrdo_operation.

    METHODS input_table
      IMPORTING
        it_input_table TYPE REF TO data
      RETURNING
        VALUE(ro_api)  TYPE REF TO zrdo_operation.

    METHODS execute
      RETURNING
        VALUE(ro_api) TYPE REF TO zrdo_operation.

    METHODS get_mapped
      RETURNING VALUE(rt_mapped) TYPE abp_behv_response_tab.
    METHODS get_failed
      RETURNING VALUE(rt_failed) TYPE abp_behv_response_tab.

    METHODS get_reported
      RETURNING VALUE(rt_reported) TYPE abp_behv_response_tab.

    METHODS get_result
      RETURNING VALUE(rt_result) TYPE REF TO data.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_buffer TYPE REF TO zrdo_buffer.

    METHODS constructor.


ENDCLASS.

CLASS zrdo_operation IMPLEMENTATION.

  METHOD constructor.
    mo_buffer = zrdo_buffer=>get_buffer( ).
  ENDMETHOD.

  METHOD target_entity.
    IF mv_operation = if_abap_behv=>op-m-create.
      mo_buffer->ls_request_m-entity_name = iv_target_entity.
    ELSE.
      mo_buffer->ls_request_r-entity_name = iv_target_entity.
    ENDIF.
    ro_api = me.
  ENDMETHOD.

  METHOD input_table.
    IF mv_operation = if_abap_behv=>op-m-create.
      mo_buffer->ls_request_m-instances = it_input_table.
    ELSE.
      mo_buffer->ls_request_r-instances = it_input_table.
    ENDIF.
    ro_api = me.
  ENDMETHOD.

  METHOD execute.

    IF mv_operation = if_abap_behv=>op-m-create.
      INSERT mo_buffer->ls_request_m INTO TABLE mo_buffer->mt_package_m.
      MODIFY ENTITIES OPERATIONS mo_buffer->mt_package_m
      FAILED   mo_buffer->mt_failed
      REPORTED mo_buffer->mt_reported
      MAPPED   mo_buffer->mt_mapped.
    ELSE.

      DATA Lt_result_read TYPE TABLE FOR READ RESULT /DMO/I_Travel_M\\travel.


      mo_buffer->ls_request_r-results = REF #(  Lt_result_read ).
      mo_buffer->ls_request_r-links = mo_buffer->mt_link.
      INSERT mo_buffer->ls_request_r INTO TABLE mo_buffer->mt_package_r.
      READ ENTITIES OPERATIONS mo_buffer->mt_package_r FAILED mo_buffer->mt_failed.
    ENDIF.
    ro_api = me.
  ENDMETHOD.

  METHOD get_failed.
    rt_failed = mo_buffer->mt_failed.
  ENDMETHOD.

  METHOD get_mapped.
    rt_mapped = mo_buffer->mt_mapped.
  ENDMETHOD.

  METHOD get_reported.
    rt_reported = mo_buffer->mt_reported.
  ENDMETHOD.

  METHOD get_result.
    rt_result = REF #( mo_buffer->mt_package_r[ 1 ]-results OPTIONAL ).
  ENDMETHOD.

ENDCLASS.
