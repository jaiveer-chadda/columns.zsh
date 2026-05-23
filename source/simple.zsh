#!/usr/bin/env zsh


# Possible Inputs & Outputs
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
#   columns               ->   column -t -s $_dflt_sep
#   columns '...'         ->   column -t -s '...'
#   columns -s '...'      ->   column -t -s '...'

# × columns -t            ->   back to `column`
# × columns -t -s         ->   back to `column`
# × columns -t -s '...'   ->   back to `column`
# × columns -ts '...'     ->   back to `column`
# × columns -st '...'     ->   back to `column`
# × columns -x            ->   back to `column`
# × columns -c 100        ->   back to `column`
# × columns -cdstx        ->   back to `column`
# × columns -cdstx '...'  ->   back to `column`



columns::test() {

  local -rA _func_args=(
    ["a              "]='us'
    ["b '...'        "]='us'
    ["c -s '...'     "]='us'
    ["d -            "]='us'
    ["e '-'          "]='us'
    ["f file2.txt    "]='us'
    ["g -s           "]='them'
    ["h file.txt     "]='them'
    ["i -file.txt    "]='them'
    ["j -sfile.txt   "]='them'
    ["k -file2.txt   "]='them'
    ["l -sfile2.txt  "]='them'
    ["m -t           "]='them'
    ["n -t -s        "]='them'
    ["o -t -s '...'  "]='them'
    ["p -ts '...'    "]='them'
    ["q -st '...'    "]='them'
    ["r -x           "]='them'
    ["s -c 100       "]='them'
    ["t -cdstx '...' "]='them'
    ["u -scdtx       "]='them'
  )

  local function args exp_result result
  for args in "${(@ko)_func_args}"; do

    exp_result="${_func_args[$args]}"
    function="columns ${args[3,-1]}"

    echo "$function" \
      | bat -p --color='always' -l='zsh' \
      | perl -pe 'chomp if eof'

    result=$( "${(z)function}" )
    echo -n "${(r:100:: :)exp_result}"

    [[ "$result" == "$exp_result" ]] \
      && echo -ne $'\e[32m --> \e[0m' \
      || echo -ne $'\e[31m --> \e[0m'

    echo "$result"
  done
}



columns() {


  echo -n "${(j: \e[31m•\e[39m :)@}\t\t\t\t" >&2 

  local -r _dflt_sep=' '
  # local -r _unimpl_args='^-(c|x)$'
  local -ri 10 _delim=$RANDOM

  # if $1 is a file, send it to the main function

  [[ -e "$1"
  || -z "$1"
  || ( "$1" == '-s' && "$2" )
  || "$1" =~ '^-'

  ]]\
  && echo them || echo us

  #{
  #   echo 'send it over to the main args'
  #   return
  # }

  # # if $1
  # #  • is '-s', or
  # #  • starts with a hyphen

  # # # [[ "$1" =~ '^((-s)?$|[^-])' ]] && {
  # # [[ "$1" =~ '^(-s$|[^-])' ]] && {
  # #   echo "we're running it"
  # #   return
  # # }

  # echo 'unrecognised flag'

  return





  # echo "${(pj:$_delim:)@}"
  # (( $@[(I)$~_unimpl_args] )) && echo yes || echo no




  (( $# >= 2 )) && { column "$@"; return; }



  # [[  ]]

  local sep="${1:- }"
  [[ "$sep" == 't' ]] && sep=$'\t'

  # I'll figure out the exact syntax later
  #  cos I'll need to read stuff infrom stdin
  column -t -s "$sep"
}

# spell-checker:ignoreRegExp /(?<=\s#.*)\w|[-]\w+\b/g
