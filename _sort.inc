#!/bin/bash
#
# Pure bash insertion and selection sort routines with customizable comparison function --@robzr

insertion_sort() {
  local a=($@) i=1
  while [ $i -lt ${#a[@]} ] ; do 
    local j=$((i++))
    while [ $j -gt 0 ] && first_is_gt "${a[$((j - 1))]}" "${a[$j]}" ; do
      local tmp=${a[$j]}
      a[$j]=${a[$((j - 1))]}
      a[$((--j))]=$tmp
    done
  done
  echo ${a[@]}
}

selection_sort() {
  local a=($@)
  local j=0
  local j_max=$((${#a[@]} - 1))
  while [ $((j++)) -lt $j_max ] ; do
    local min=$j
    local i=$((j + 1))
    local i_max=$((${#a[@]}))
    while [ $((i++)) -lt $i_max ] ; do
      first_is_gt "${a[$i]}" "${a[$min]}" || min=$i
    done
    local tmp=${a[$j]}
    a[$j]=${a[$min]}
    a[$min]=$tmp
  done 
  echo ${a[@]}
}

# Actual comparison function, in this case it is a bash alphabetical comparison with bias for p
first_is_gt() {
  if [[ "$1" =~ ^p ]] && [[ "$2" =~ ^p ]] ; then
    true
  elif [[ "$1" =~ ^p ]] ; then
    return 1 
  elif [[ "$2" =~ ^p ]] ; then
    return 0
  fi
  [ "$1" \> "$2" ]
}

iterations=250

unsorted_list_short='weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb'

unsorted_list_long='weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb weiuqbna zxcnvzoiuhw alskdjfasdf potatoes asdgjn9uerw 2435nnakjdsn pzzzz asdkfjnzxciuh gbjchbxbx gfknerwrqqui2e ncx,bnxb'

echo -n Timing $iterations iterations of insertion sort with small list:
n=0 ; time while [ $((n++)) -lt $iterations ] ; do
  insertion_sort $unsorted_list_short >/dev/null
done

echo -n Timing $iterations iterations of selection sort with small list:
n=0 ; time while [ $((n++)) -lt $iterations ] ; do
  selection_sort $unsorted_list_short >/dev/null
done

echo -n Timing $iterations iterations of insertion sort with long list:
n=0 ; time while [ $((n++)) -lt $iterations ] ; do
  insertion_sort $unsorted_list_long >/dev/null
done

echo -n Timing $iterations iterations of selection sort with long list:
n=0 ; time while [ $((n++)) -lt $iterations ] ; do
  selection_sort $unsorted_list_long >/dev/null
done

# TL;DR: insertion sort is consistently faster on the order of about 3x
#
# Timing 250 iterations of insertion sort with small list:
# real	0m0.864s
# user	0m0.811s
# sys	0m0.040s
# Timing 250 iterations of selection sort with small list:
# real	0m1.597s
# user	0m1.518s
# sys	0m0.067s
# Timing 250 iterations of insertion sort with long list:
# real	5m7.464s
# user	4m54.914s
# sys	0m9.579s
# Timing 250 iterations of selection sort with long list:
# real	15m59.379s
# user	15m16.794s
# sys	0m28.529s
