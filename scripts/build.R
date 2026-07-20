# Copyright 2023 Province of Alberta

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

styler::style_pkg(
  scope = "line_breaks",
  filetype = c("R", "Rmd")
)

lintr::lint_package(
  linters = lintr::linters_with_defaults(
    line_length_linter = lintr::line_length_linter(1000),
    object_name_linter = lintr::object_name_linter(regexes = ".*")
  )
)

roxygen2md::roxygen2md()
devtools::document()

devtools::build_readme()

# Note: Only use pkgdown to build a documentation website for public facing packages
pkgdown::build_home()
pkgdown::build_reference()
pkgdown::build_site()
browseURL("docs/index.html")

devtools::test()
devtools::check()

# Test files that have less then 100% coverage
covr:::tally_coverage(covr::package_coverage()) |>
  dplyr::summarize(
    percent_coverage = mean(value > 0) * 100,
    .by = filename
  ) |>
  dplyr::filter(percent_coverage < 100) |>
  dplyr::arrange(percent_coverage)

# Report for all test files
covr::report(covr::package_coverage())
