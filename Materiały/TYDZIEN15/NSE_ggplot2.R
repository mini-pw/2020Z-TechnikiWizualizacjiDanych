library(ggplot2)

lm(Sepal.Length ~ Petal.Length, data = iris)
cor.test(~ Sepal.Length + Petal.Length, data = iris)
cor.test(iris[["Sepal.Length"]], iris[["Petal.Length"]])

ggplot(iris, aes(x = Sepal.Length)) +
  geom_density()

x <- "Sepal.Length"

ggplot(iris, aes(x = x)) +
  geom_density()


ggplot(iris, aes(x = "Sepal.Length")) +
  geom_density()

ggplot(iris, aes(x = eval(parse(text = eval(bquote(x)))))) +
  geom_density()

ggplot(iris, aes(x = !!ensym(x))) +
  geom_density()

eval(substitute(eval(x)))
substitute("Sepal.Length")

X <- c("uhh", "ioj", "lol", "kik", "lkl")

lapply(1L:5, function(i)
  list(i, substitute(i), eval(i), eval(substitute(i)))
  )

substitute(X, list(X = 1L:10))
