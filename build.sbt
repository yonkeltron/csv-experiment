name := "CSV Handler"

version := "1.0"

scalaVersion := "2.11.8"

libraryDependencies += "com.typesafe.akka" % "akka-actor_2.11" % "2.4.4"
libraryDependencies += "com.typesafe.akka" %% "akka-stream" % "2.4.4"
libraryDependencies += "com.github.scopt" %% "scopt" % "3.4.0"
libraryDependencies += "com.github.tototoshi" %% "scala-csv" % "1.3.1"

resolvers += Resolver.sonatypeRepo("public")
