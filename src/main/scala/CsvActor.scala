package org.yonkeltron.csv

import akka.actor.Actor

class CsvActor extends Actor {
  def receive = {
    case CsvLine(line) => {
      Main.handleRowSync(line.split(","))
      context stop self
    }
    case _ => context stop self
  }
}
