SET(PARSE_IF_DEBUG OFF)
SET(IF_PARAM1 "")
SET(IF_PARAM2 "")

function(parseIf line param1 param2)
    string(STRIP ${line} parseIf_line)
    string(REGEX REPLACE "^\\(" "" parseIf_line ${parseIf_line})
    string(REGEX REPLACE "\\)$" "" parseIf_line ${parseIf_line})
    if( "${parseIf_line}" MATCHES "^,.*" )
        string(REGEX REPLACE "^," ";" parseIf_line_list ${parseIf_line})
    elseif("${parseIf_line}" MATCHES ".*,$")
        string(REGEX REPLACE ",$" ";" parseIf_line_list ${parseIf_line})
    else()

        string(REPLACE "," ";" parseIf_line_list ${parseIf_line})
    endif()
    list(GET parseIf_line_list 0 parseIf_local_param1)
    list(GET parseIf_line_list 1 parseIf_local_param2)
    if(PARSE_IF_DEBUG)
        message("parseIf: param1 = ${parseIf_local_param1}")
        message("parseIf: param2 = ${parseIf_local_param2}")
    endif()

    parseMakeFileFunc("${parseIf_local_param1}" parseIf_local_param1)
    SET(${param1} ${parseIf_local_param1} PARENT_SCOPE)
    parseMakeFileFunc("${parseIf_local_param2}" parseIf_local_param2)
    SET(${param2} ${parseIf_local_param2} PARENT_SCOPE)
endfunction()

function(doIfeq line block)
    parseIf(${line} doIfeq_IF_PARAM1 doIfeq_IF_PARAM2)
    if(PARSE_IF_DEBUG)
        message("doIfeq: IF_PARAM1 = ${doIfeq_IF_PARAM1}")
        message("doIfeq: IF_PARAM2 = ${doIfeq_IF_PARAM2}")
    endif()
    if( "${doIfeq_IF_PARAM1}" STREQUAL "${doIfeq_IF_PARAM2}" )
        SET(${block} OFF PARENT_SCOPE)
    else()
        SET(${block} ON  PARENT_SCOPE)
    endif()
endfunction()

function(doIfneq line block)
    parseIf(${line} doIfneq_IF_PARAM1 doIfneq_IF_PARAM2)
    if(PARSE_IF_DEBUG)
        message("doIfneq: IF_PARAM1 = ${doIfneq_IF_PARAM1}")
        message("doIfneq: IF_PARAM2 = ${doIfneq_IF_PARAM2}")
    endif()
    if( "${doIfneq_IF_PARAM1}" STREQUAL "${doIfneq_IF_PARAM2}" )
        if(PARSE_IF_DEBUG)
            message("doIfneq: block = ON")
        endif()
        SET(${block} ON PARENT_SCOPE)
    else()
        if(PARSE_IF_DEBUG)
            message("doIfneq: block = OFF")
        endif()
        SET(${block} OFF  PARENT_SCOPE)
    endif()
endfunction()