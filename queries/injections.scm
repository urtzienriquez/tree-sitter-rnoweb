; 1. Dynamic Engine Injection (e.g., engine="python" or engine="bash")
((rchunk
    (renv_sig_options
        (renv_key_pair
            key: (renv_key) @_key
            value: (renv_val) @injection.language))
    (renv_content) @injection.content)
 (#eq? @_key "engine")
 (#strip! @injection.language "\""))

; Fallback R Content Injection (matches when no specific engine is set)
((rchunk
    (renv_content) @injection.content)
 (#set! injection.language "r")
 (#set! injection.combined))

; Inline R Expressions (Sexpr)
((rinline
    (renv_content) @injection.content)
 (#set! injection.language "r"))

; LaTeX Content Injection
((latex) @injection.content
 (#set! injection.language "latex")
 (#set! injection.combined))
