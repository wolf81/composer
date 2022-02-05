local PATH = (...):gsub('%.init$', '')

return require(PATH..".composer")
