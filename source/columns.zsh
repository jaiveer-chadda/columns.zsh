#!/usr/bin/env zsh

# -c  -- format output to fit display of specified width
# -s  -- specify column delimiters in input data
# -t  -- create a table
# -x  -- print across before down

function columns() {
  setopt local_options warn_create_global

  local -ri 10 rand=$RANDOM

  local -ri 2 ignore_consec_delims=1
  local -r delim=' '
  local -r fill=' '
  local -r sep=' '

  local -r input="${$( cat "${@:--}"; echo END )%END}"
  local -a lines_in=( "${(@f)input}" )

  local -i 2 do_final_newline=$(( ${#lines_in[-1]} == 0 ))
  if (( do_final_newline )) lines_in=( "${(@)lines_in[1,-2]}" )

  local -ri 10 line_count=$#lines_in

  # ——————————————————————————————————————————————— #

  local line seg_max_len
  local -a line_arr
  local -i 10 line_num seg_no seg_count seg_len total_segs=0

  for line_num in {1..$line_count}; {
    line="$lines_in[line_num]"

    # split each line into an array, at each specified delimiter
    line_arr=( "${(@ps:$delim:)line}" )
    # if we're ignoring consecutive delimiters, then remove all empty items
    if (( ignore_consec_delims )) line_arr=( "${(@)line_arr:#}" )

    seg_count=$#line_arr

    if (( seg_count == 0 )) continue

    # if this line has more segments than we've seen before, make a new column
    #  array and max len var for each new segment/column that's gonna be added
    if (( seg_count > total_segs )) {
      for seg_no in {$(( total_segs + 1 ))..$(( seg_count - total_segs ))}; {
        eval "local -a column_$seg_no=( )"
        eval "local -i 10 col_${seg_no}_width=0"
      }
      # update the new total number of segments
      total_segs=$seg_count
    }

    # add each segment to its appropriate column array,
    #  and update the column's width (the max len in each row)
    for seg_no in {1..$seg_count}; {
      seg_len="${#line_arr[seg_no]}"
      seg_max_len="col_${seg_no}_width"  # get the name of the width var

      # update the column width if need be
      if (( seg_len > ${(P)seg_max_len} )) eval "col_${seg_no}_width=$seg_len"
      # add the segment to its column array
      eval "column_$seg_no+=( '$line_arr[seg_no]' )"
    }

    # echo -E - "${(j:•:)line_arr}"
  }

  # typeset -pm 'column_[0-9]'
  # typeset -pm 'col_[0-9]_width'

  local seg_name seg_width_nm
  local -a segment_arr
  local -i 10 seg_width

  for line_num in {1..$line_count}; {
    for seg_no in {1..$total_segs}; {
      seg_name="column_$seg_no"
      segment_arr=( "${(@P)seg_name}" )

      seg_width_nm="col_${seg_no}_width"
      seg_width="${(P)seg_width_nm}"

      echo -nE - "${(pr:$seg_width::$fill:)segment_arr[line_num]}$sep"
    }

    if (( line_num != line_count || do_final_newline )) echo
  }

}
