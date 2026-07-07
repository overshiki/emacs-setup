#!/bin/bash
set -e

# Install tree-sitter grammars for Emacs without blocking the UI.
# Grammars are pinned to ABI 14 compatible revisions for Emacs 30.
#
# Usage:
#   ./install-treesit-grammars.sh              # install default set
#   ./install-treesit-grammars.sh python go    # install specific languages

if [ $# -eq 0 ]; then
    LANGUAGES=(python go rust c cpp bash json yaml toml)
else
    LANGUAGES=("$@")
fi

# Language -> "URL TAG [SOURCE-DIR]"
# Tags are pinned to grammar revisions that produce tree-sitter ABI 14,
# which is what Emacs 30 expects.
declare -A GRAMMARS=(
    [python]="https://github.com/tree-sitter/tree-sitter-python v0.21.0"
    [go]="https://github.com/tree-sitter/tree-sitter-go v0.21.0"
    [rust]="https://github.com/tree-sitter/tree-sitter-rust v0.21.0"
    [c]="https://github.com/tree-sitter/tree-sitter-c v0.21.0"
    [cpp]="https://github.com/tree-sitter/tree-sitter-cpp v0.21.0"
    [bash]="https://github.com/tree-sitter/tree-sitter-bash v0.21.0"
    [json]="https://github.com/tree-sitter/tree-sitter-json v0.21.0"
    [javascript]="https://github.com/tree-sitter/tree-sitter-javascript v0.21.0"
    [typescript]="https://github.com/tree-sitter/tree-sitter-typescript v0.21.0 typescript"
    [tsx]="https://github.com/tree-sitter/tree-sitter-typescript v0.21.0 tsx"
    [yaml]="https://github.com/ikatyang/tree-sitter-yaml v0.5.0"
    [toml]="https://github.com/ikatyang/tree-sitter-toml v0.5.1"
)

EMACS=${EMACS:-emacs}

# Verify Emacs has tree-sitter support.
if ! "$EMACS" --batch --eval '(kill-emacs (if (fboundp '"'"'treesit-language-available-p) 0 1))' 2>/dev/null; then
    echo "Error: Emacs does not have tree-sitter support." >&2
    echo "Rebuild Emacs with --with-tree-sitter." >&2
    exit 1
fi

GRAMMAR_DIR="${HOME}/.emacs.d/tree-sitter"
mkdir -p "$GRAMMAR_DIR"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

FAILED=()
for LANG in "${LANGUAGES[@]}"; do
    SPEC="${GRAMMARS[$LANG]}"
    if [ -z "$SPEC" ]; then
        echo "Warning: no grammar mapping for '$LANG', skipping." >&2
        FAILED+=("$LANG")
        continue
    fi

    read -r REPO TAG SRC_DIR <<< "$SPEC"
    [ -z "$SRC_DIR" ] && SRC_DIR="nil"

    echo "Installing tree-sitter grammar for $LANG from $REPO @ $TAG ..."

    cat > "$TMPDIR/install-${LANG}.el" <<EOF
(require 'treesit)
(setq treesit-language-source-alist
      '((${LANG} "${REPO}" "${TAG}" ${SRC_DIR})))
(condition-case err
    (progn
      (treesit-install-language-grammar '${LANG})
      (if (treesit-language-available-p '${LANG} t)
          (kill-emacs 0)
        (message "Verification failed for ${LANG}")
        (kill-emacs 1)))
  (error
   (message "Error installing ${LANG}: %s" (error-message-string err))
   (kill-emacs 1)))
EOF

    set +e
    OUTPUT=$("$EMACS" --batch -l "$TMPDIR/install-${LANG}.el" 2>&1)
    STATUS=$?
    set -e

    if [ $STATUS -eq 0 ] && [ -f "$GRAMMAR_DIR/libtree-sitter-${LANG}.so" ]; then
        echo "  OK: $LANG"
    else
        echo "  FAILED: $LANG" >&2
        [ -n "$OUTPUT" ] && echo "  $OUTPUT" >&2
        FAILED+=("$LANG")
    fi
done

echo ""
if [ ${#FAILED[@]} -eq 0 ]; then
    echo "All grammars installed successfully to $GRAMMAR_DIR/"
else
    echo "Failed to install: ${FAILED[*]}" >&2
    echo "You can retry individual languages with:" >&2
    echo "  ./install-treesit-grammars.sh ${FAILED[*]}" >&2
    exit 1
fi
