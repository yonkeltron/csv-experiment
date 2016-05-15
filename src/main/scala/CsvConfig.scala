package org.yonkeltron.csv
import java.io.File

case class Config(
  input: File = new File("."),
  output: File = new File("."),
  mode: String = "ERROR")
