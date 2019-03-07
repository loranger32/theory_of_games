a = Time.now.to_s.gsub(/-|:| |\+.*/, '') + rand(100..200).to_s
p a
