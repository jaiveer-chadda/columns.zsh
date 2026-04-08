
columns::simple() {

  (( $# >= 2 )) && { column "$@"; return; }
  # $sep will remain as a space if $1 isn't given
  # or if $# == 0
  local sep="${1:- }"
  # "(( $# ))" means: "if $# != 0",
  #  but since we've checked whether $# >= 2 already,
  #  this check is actually asking if $# == 1
  (( $# )) && {
      case "$sep" in
          t) sep=$'\t' ;;
          n) sep=$'\n' ;;
      esac
  }
  # I'll figure out the exact syntax later
  #  cos I'll need to read stuff infrom stdin
  column -t -s "$sep"
}
