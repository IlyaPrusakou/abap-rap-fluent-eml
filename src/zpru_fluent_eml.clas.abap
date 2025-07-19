CLASS zpru_fluent_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    DATA mv_operation TYPE abp_behv_op_read.

    CLASS-METHODS for_read
      RETURNING
        VALUE(ro_api) TYPE REF TO zpru_fluent_eml.

    CLASS-METHODS for_create
      RETURNING
        VALUE(ro_api) TYPE REF TO zpru_fluent_eml.
    METHODS target_entity
      IMPORTING
        iv_target_entity TYPE abp_entity_name
      RETURNING
        VALUE(ro_api)    TYPE REF TO zpru_fluent_eml.

    METHODS input_table
      IMPORTING
        it_input_table TYPE REF TO data
      RETURNING
        VALUE(ro_api)  TYPE REF TO zpru_fluent_eml.

    METHODS execute
      RETURNING
        VALUE(ro_api) TYPE REF TO zpru_fluent_eml.

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

CLASS zpru_fluent_eml IMPLEMENTATION.

  METHOD for_read.
    ro_api = NEW #( ).
    ro_api->ls_request_r-op = if_abap_behv=>op-r-read.
    ro_api->mv_operation = ro_api->ls_request_r-op.
  ENDMETHOD.

  METHOD for_create.
    ro_api = NEW #( ).
    ro_api->ls_request_m-op = if_abap_behv=>op-m-create.
    ro_api->mv_operation = ro_api->ls_request_m-op.
  ENDMETHOD.

  METHOD target_entity.
    IF mv_operation = if_abap_behv=>op-m-create.
      ls_request_m-entity_name = iv_target_entity.
    ELSE.
      ls_request_r-entity_name = iv_target_entity.
    ENDIF.
    ro_api = me.
  ENDMETHOD.

  METHOD input_table.
    IF mv_operation = if_abap_behv=>op-m-create.
      ls_request_m-instances = it_input_table.
    ELSE.
      ls_request_r-instances = it_input_table.
    ENDIF.
    ro_api = me.
  ENDMETHOD.

  METHOD execute.

    IF mv_operation = if_abap_behv=>op-m-create.
      INSERT ls_request_m INTO TABLE mt_package_m.
      MODIFY ENTITIES OPERATIONS mt_package_m
      FAILED   mt_failed
      REPORTED mt_reported
      MAPPED   mt_mapped.
    ELSE.

      DATA Lt_result_read TYPE TABLE FOR READ RESULT /DMO/I_Travel_M\\travel.


      ls_request_r-results = REF #(  Lt_result_read ).
      ls_request_r-links = mt_link.
      INSERT ls_request_r INTO TABLE mt_package_r.
      READ ENTITIES OPERATIONS mt_package_r FAILED mt_failed.
    ENDIF.
    ro_api = me.
  ENDMETHOD.

  METHOD get_failed.
    rt_failed = mt_failed.
  ENDMETHOD.

  METHOD get_mapped.
    rt_mapped = mt_mapped.
  ENDMETHOD.

  METHOD get_reported.
    rt_reported = mt_reported.
  ENDMETHOD.

  METHOD get_result.
    rt_result = REF #( mt_package_r[ 1 ]-results OPTIONAL ).
  ENDMETHOD.

ENDCLASS.
