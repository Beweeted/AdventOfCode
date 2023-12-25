loop=0
rm -f *.plt

first_planet=$(head -n 1 input.txt | cut -d')' -f2)
base_planet=""

while [ "${base_planet}" == "" ] ; do
  echo "Testing planet: ${first_planet}"
  base_planet=$(egrep "${first_planet}$" input.txt | cut -d')' -f1)
  if [ "${base_planet}" != "" ] ; then
    first_planet=${base_planet}
    base_planet=""
  else
    core_planet=${first_planet}
    break
  fi
done

echo "Core planet found.  Planet: ${core_planet}"

get_orbits_for_planet() {
  local parent_planet=$1
  local parent_orbits=$2
  local total_orbits=${parent_orbits}
  for child in $(egrep "^${parent_planet}" input.txt | cut -d')' -f2) ; do
    echo "Getting orbits for ${child}.  Layer: ${parent_orbits}" >&2
    local child_orbits=$(get_orbits_for_planet ${child} $(( parent_orbits + 1)))
    total_orbits=$((total_orbits + child_orbits))
  done
  echo ${total_orbits}
}

orbits=$(get_orbits_for_planet ${core_planet} 0)

echo ""

echo "Total orbits: ${orbits}"

echo ""
