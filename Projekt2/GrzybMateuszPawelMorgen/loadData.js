function range1(i) {
  return i ? range1(i - 1).concat(i) : []
}

const loadData = Promise.all(
  range1(731).map(
    id => d3.json("new_data/" + id + ".json")
  )
)
