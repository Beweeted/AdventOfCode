loop=0

trace_tree() {
  local first_planet=$1
  local outer_planet=${first_planet}
  local inner_planet=""
  local path_to_root=${first_planet}
  while [ "${inner_planet}" == "" ] ; do
    #echo "Testing planet: ${first_planet}"
    inner_planet=$(egrep "${outer_planet}$" input.txt | cut -d')' -f1)
    if [ "${inner_planet}" != "" ] ; then
      outer_planet=${inner_planet}
      inner_planet=""
      path_to_root="${path_to_root} ${outer_planet}"
    else
      break
    fi
  done
  echo ${path_to_root}
}

your_planet=YOU
santa_planet=SAN

echo "Tracing your tree"
your_tree=$(trace_tree ${your_planet})
echo "Tracing Santa's tree"
santa_tree=$(trace_tree ${santa_planet})

echo ""
echo "Your tree: ${your_tree}"
echo "Santa tree: ${santa_tree}"
echo ""

#-1 for your position, -1 for santa position, -1 for transfers not positions
jump_count=-3
joint_planet=""
travel_path=""
for planet in ${your_tree} ; do
  jump_count=$((jump_count+1))
  travel_path="${travel_path} ${planet}"
  for p in ${santa_tree} ; do
    if [ ${planet} == ${p} ] ; then joint_planet=${p} ; fi
    if [ "${joint_planet}" != "" ] ; then break ; fi
  done
  if [ "${joint_planet}" != "" ] ; then break ; fi
  echo -ne "\rCounting jumps to joint planet: ${jump_count}"
done
echo ""
echo "Joint planet: ${joint_planet}"

for p in ${santa_tree} ; do
  if [ ${p} == ${joint_planet} ] ; then break ; fi
  #This will append to the previous travel_path but still in desc order.
  #This should be built separately, reversed, then appended
  travel_path="${travel_path} ${p}"
  jump_count=$((jump_count+1))
  echo -ne "\rCounting jumps from joint planet: ${jump_count}"
done

echo ""
echo "Final count: ${jump_count}"
echo "Trip plan: ${travel_path}"
echo ""
