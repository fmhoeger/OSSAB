library(psychTestR)
library(OSSAB)
library(testthat)

dir <-
  system.file("tests/MRT_ru", package = "OSSAB", mustWork = TRUE)
app <- AppTester$new(dir)

app$expect_ui_text("Пожалуйста, введите логин Вперёд")
app$set_inputs(p_id = "aбвгд")
app$click_next()

app$expect_ui_text("Инструкция Вы увидите изображение с вопросом под ним, и три возможных варианта ответа. Пожалуйста, нажмите на правильный ответ и кнопку Вперёд, после чего будет загружено новое задание. На каждое задание дается 25 секунд. Если время закончится прежде, чем Вы успеете ответить, просто нажмите Далее, чтобы перейти к следующему заданию. Удачи! Нажмите на кнопку ниже, чтобы продолжить. Вперёд")
app$click_next()
app$expect_ui_text("Пример задания. Когда левая шестеренка вращается в направлении, показанном на картинке, в какую сторону движется правая шестеренка? Если Вы не уверены, нажмите кнопку Вперёд, чтобы увидеть ответ. Выберите правильный ответ: А. Б. В. Может повернуться в любом направлении. Вперёд Показать ответ")
app$click_next()
app$expect_ui_text("Самопроверка Для этого задания правильным ответом является вариант A. Нажмите кнопку Вперёд, чтобы приступить к заданиям. Назад Вперёд")
app$click_next()

app$expect_ui_text("Задание 1. Если рукоятка 2 повернется в указанном направлении, в каком направлении повернется шестеренка 1? Выберите правильный ответ: А. Б. В. Может повернуться в любом направлении. Вперёд Далее")
app$click("button-A")
app$click("A")
app$expect_ui_text("Задание 2. Если шестеренка 1 сделает один полный оборот, шестеренка 2 сделает… Выберите правильный ответ А. Два полных оборота Б. Пол-оборота В. Один полный оборот Вперёд Далее")
app$click("button-C")
app$click("C")
app$click("button-A")
app$click("A")
app$click("button-B")
app$click("B")
app$click("button-C")
app$click("C")
app$click("button-B")
app$click("B")
app$click("button-C")
app$click("C")
app$click("button-B")
app$click("B")
app$click("button-B")
app$click("B")
app$click("button-C")
app$click("C")
app$click("button-B")
app$click("B")
app$click("button-B")
app$click("B")
app$click("button-C")
app$click("C")
app$click("button-C")
app$click("C")
app$click("button-B")
app$click("B")
app$expect_ui_text("Задание 16. Какая рукоятка будет поворачиваться быстрее всего? Выберите правильный ответ А. Б. В. Вперёд Далее")
app$click("button-A")
app$click("A")

app$expect_ui_text("Ваш результат записан. Это окно можно закрыть.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MRT"))
expect_equal(
  results[["MRT"]],
  list(
    i1 = "A",
    i2 = "C",
    i3 = "A",
    i4 = "B",
    i5 = "C",
    i6 = "B",
    i7 = "C",
    i8 = "B",
    i9 = "B",
    i10 = "C",
    i11 = "B",
    i12 = "B",
    i13 = "C",
    i14 = "C",
    i15 = "B",
    i16 = "A",
    score = 16
  )
)

app$stop()
