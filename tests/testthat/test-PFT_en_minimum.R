library(psychTestR)
library(OSSAB)
library(testthat)

dir <-
  system.file("tests/PFT_en", package = "OSSAB", mustWork = TRUE)
app <- AppTester$new(dir)

app$expect_ui_text("Please enter your ID Continue")
app$set_inputs(p_id = "abcde")
app$click_next()

app$expect_ui_text("Instructions Your task is to imagine how the holes will be located on the unfolded sheet of paper, which was previously folded and punctured. In each task, you see how a square sheet of paper is folded step by step. In the last picture there is a black dot - this is a hole punctured by a needle, passing through the layers of paper located under it. If you unfold the sheet of paper, how will the holes be located on it? Choose one of the options. In the example below, the correct answer is C. The image below shows how the paper was folded and why C is the correct answer. The paper never rotates or moves in any way. It is only folded, pierced and then unfolded. You are given 20 seconds for each task. When you selected an answer, the next question is loaded automatically. If the time runs out before you click on the right answer, just click Next to continue to the next task. Good luck! Click on the button below to get started. Continue")
app$click_next()
app$expect_ui_text("Example question. Try to choose the correct answer. If you are not sure, click the Show answer button. Choose the correct answer. Show answer")
app$click_next()
app$expect_ui_text("Self-check For this question, the correct answer is option A. Click the Continue button to start the test. Click the Back button to return to the instructions. Back Continue")
app$click_next()

app$expect_ui_text("Question 1. What will a sheet of paper look like if it is folded, as shown in the example, and a needle pierced in it? Choose the correct answer. Next")
app$click("E")
app$expect_ui_text("Question 2. What will a sheet of paper look like if it is folded, as shown in the example, and a needle pierced in it? Choose the correct answer. Next")
app$click("A")
app$click("B")
app$click("E")
app$click("C")
app$click("D")
app$click("B")
app$click("D")
app$click("B")
app$click("E")
app$click("A")
app$click("E")
app$click("A")
app$click("E")
app$click("B")

app$expect_ui_text("Your results have been saved. You can close the browser window now.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("PFT"))
expect_equal(
  results[["PFT"]],
  list(
    i1 = "E",
    i2 = "A",
    i3 = "B",
    i4 = "E",
    i5 = "C",
    i6 = "D",
    i7 = "B",
    i8 = "D",
    i9 = "B",
    i10 = "E",
    i11 = "A",
    i12 = "E",
    i13 = "A",
    i14 = "E",
    i15 = "B",
    score = 0
  )
)

app$stop()
