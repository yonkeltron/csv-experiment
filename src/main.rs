
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;
use std::io::BufReader;

extern crate clap;

use clap::{App, Arg};

fn main() {
    let matches = App::new("CSV Experiment in Rust")
        .version("0.1")
        .author("Jonathan E. Magen @yonkeltron")
        .about("Tests running out a CSV benchmark")
        .arg(Arg::with_name("input")
             .short("i")
             .long("input")
             .value_name("FILE")
             .help("The CSV file to be processed")
             .takes_value(true))
        .get_matches();

    let input_path = matches.value_of("input").unwrap_or("example.csv");

    println!("CSV: {}", input_path);

    let file = open_file(input_path);

    let reader = BufReader::new(file);

    for line in reader.lines() {
        match line {
            Err(problem) => panic!("Couldn't read line: {}", problem),
            Ok(ln) => { println!("{}", handle_line(&ln)); },
        }
    }
}

fn open_file(pathname: &str) -> File {
    let path = Path::new(pathname);
    let display = path.display();

    match File::open(path) {
        Err(problem) => panic!("Couldn't open {}: {}", display, problem.description()),
        Ok(file)     => file,
    }
}

fn handle_line(line: &str) -> String {
    let elements: Vec<&str> = line.split(",").collect::<Vec<&str>>();

    elements
        .iter()
        .map(|element| format!("x{}", element))
        .map(|element| format!("{}x", element))
        .collect::<Vec<String>>()
        .join(",")
}

#[cfg(test)]
mod test {
    use super::handle_line;

    #[test]
    fn test_handle_line() {
        let input = "a,b,c";
        let expected = "xax,xbx,xcx";
        let actual = handle_line(input);

        assert_eq!(actual, expected);
    }
}
