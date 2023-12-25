input=input.txt

TRANSPARENT=2

width=25
height=6

raw_image=$(cat ${input})
pixel_count=$(( ${#raw_image}))
pixels_per_layer=$(( width * height ))
layer_count=$(( pixel_count / pixels_per_layer ))

echo "Pixel count: ${pixel_count}"
echo "Pixels per layer: ${pixels_per_layer}"
echo "Total layer count: ${layer_count}"

asdf() {
  #Skipping this whole seciont because it's unneeded for 8b
  best_layer=-1
  best_zero_count=${pixels_per_layer}
  result=0
  for i in $(seq 0 $((layer_count - 1)) ) ; do
    cut_start=$((i * pixels_per_layer))
    layer=${raw_image:cut_start:pixels_per_layer}
    all_zeros=${layer//[!0]/}
    zero_count=${#all_zeros}
    if [ ${zero_count} -lt ${best_zero_count} ] ; then
      best_layer=${i}
      best_zero_count=${zero_count}
      ones=${layer//[!1]/}
      twos=${layer//[!2]/}
      result=$(( ${#ones} * ${#twos}))
    fi
  done

  echo ""
  echo "Best layer: ${best_layer}.  Zero count: ${best_zero_count}.  Result: ${result}"
}


prepare_blank_image() {
  image=()
  for rid in $(seq 0 $(( height - 1 )) ); do
    row=""
    for cid in $(seq ${width} ); do
      row=${row}${TRANSPARENT}
    done
    image[${rid}]=${row}
  done
}

print_image() {
  for row in ${image[*]} ; do
    for i in $(seq 0 $(( ${#row} - 1 )) ) ; do
      pixel=${row:i:1}
      if [ ${pixel} -eq 1 ] ; then
        echo -n "${pixel} "
      else
        echo -n "  "
      fi
    done
    echo ""
  done
}


echo ""
echo "Processing Space Image Format (SIF)."

echo "Preparing blank image..."
prepare_blank_image

for i in $(seq 0 $((${layer_count}-1))) ; do
  cut_start=$(( i * pixels_per_layer))
  layer=${raw_image:cut_start:pixels_per_layer}
  index=0
  for rid in $(seq 0 $(( height - 1 )) ) ; do
    new_row=""
    old_row=${image[rid]}
    for cid in $(seq 0 $(( width - 1 )) ); do
      pixel=${old_row:cid:1}
      if [ ${pixel} -eq ${TRANSPARENT} ] ; then
        new_row=${new_row}${layer:index:1}
      else
        new_row=${new_row}${old_row:cid:1}
      fi
      index=$((index+1))
    done
    image[${rid}]=${new_row}
  done

  echo "Current image: "
  print_image
  echo ""
done

echo -n ""
