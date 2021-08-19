local utility = {}

function utility.subset_case_insensitive(s1, s2)
  s1 = string.lower(s1)
  s2 = string.lower(s2)

  return string.find(s2, s1)
end

return utility