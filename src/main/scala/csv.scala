package org.yonkeltron.csv

import akka.actor._
import akka.stream._
import akka.stream.scaladsl._
import akka.util.ByteString
import com.github.tototoshi.csv._
import java.io.File
import scala.annotation.switch
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import scala.concurrent.{Future, Await}
import scala.io.Source
import scala.util.{Failure, Success}
import java.util.UUID


object Main {
  def main(args: Array[String]) = {
    val parser = new scopt.OptionParser[Config]("scopt") {
      head("CSV", "0.1")

      opt[File]('i', "input") required() valueName("<file>") action { (x, c) =>
        c.copy(input = x)
      } text("Path to input file")

      opt[String]('m', "mode") required() action { (x, c) =>
        c.copy(mode = x)
      } text("Mode of operation (sync, future, stream, pc, actor)")
    }

    parser.parse(args, Config()) match {
      case Some(config) => begin(config)
      case None => println("Error")
    }
  }

  def begin(config: Config) = {
    val reader = CSVReader.open(config.input)

    config.mode match {
      case "sync"  => reader foreach { row => handleRowSync(row) }
      case "future" => reader foreach { row => handleRowAsync(row) }
      case "stream" => handleWithStreams(config.input, new File("panda.csv"))
      case "pc" => handleWithParallelCollections(config)
      case "actor" => handleWithActors(reader)
      case _ => println("ERROR: Unknown mode")
    }

    reader.close()
  }

  def handleWithActors(reader: CSVReader) = {
    val system = ActorSystem("csv-experiment")
    val props = Props[CsvActor]

    reader foreach { row =>
      val name = java.util.UUID.randomUUID.toString
      val handler = system.actorOf(props, name)
      handler ! CsvLine(row)
    }
  }

  def handleWithParallelCollections(config: Config) = {
    val lines = Source.fromFile(config.input).getLines().toList
    lines.par.foreach { line => handleRowSync(line.split(",")) }
  }

  def handleWithStreams(from: File, to: File) = {
    implicit val system = ActorSystem("csv-experiment")
    implicit val mat = ActorMaterializer()

    val r = FileIO.fromFile(from)
      .via(Framing.delimiter(ByteString("\n"), 1048576))
      .map(_.decodeString("UTF-8"))
      .map(_.split(",").toList)
      .map(process)
      .intersperse("\n")
      .map(ByteString(_))
      .runWith(FileIO.toFile(to))
      //.toMat(FileIO.toFile(to))(Keep.right)
      //.run()

    Await.result(r, 1.minutes)
  }

  def handleRowSync(row: Seq[String]) = println(process(row))

  def handleRowAsync(row: Seq[String]) = {
    Future { process(row) } onComplete {
      case Success(result) => println(result)
      case Failure(e) => e.printStackTrace
    }
  }

  def process(row: Seq[String]) = row
    .map(_ + "x")
    .map("x" + _)
    .mkString(",")
}
