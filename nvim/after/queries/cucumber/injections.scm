;extends

        ;; Injects json into doc_strings marked with """JSON or """json
        (
          (doc_string
            (py_string_opener) @opener
            (py_string_content) @injection.content
          )
          (#match? @opener "^"""[Jj][Ss][Oo][Nn]")
          (#set! injection.language "json")
        )
      