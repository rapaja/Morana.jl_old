using Coverage
using Pkg

Pkg.test(coverage=true)

coverage = process_folder()

open("lcov.info", "w") do io
    LCOV.write(io, coverage)
end