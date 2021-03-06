use std::error::Error;
use std::fs::File;
use std::io::BufReader;
use std::io::prelude::*;
use std::path::Path;

extern crate clap;
use clap::{App, Arg};

extern crate jobsteal;
use jobsteal::make_pool;

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
             .required(true)
             .takes_value(true))
        .arg(Arg::with_name("mode")
             .short("m")
             .long("mode")
             .value_name("MODE")
             .help("One of sync,async")
             .required(true)
             .takes_value(true))
        .get_matches();

    let input_path = matches.value_of("input").unwrap_or("example.csv");

    let mode = matches.value_of("mode").unwrap_or("sync");

    run(input_path, mode);
}

// Main loop
fn run(input_path: &str, mode: &str) {
    let file = open_file(input_path);

    let reader = BufReader::new(file);

    match mode {
        "sync"  => run_sync(reader),
        "async" => run_async(reader),
        _       => { println!("Unknown mode"); }
    };
}

fn run_async(reader: BufReader<std::fs::File>) {
    let mut pool = make_pool(4).expect("Couldn't make jobsteal pool");

    pool.scope(|scope| {
        for line in reader.lines() {
            scope.submit(move || {
                let ln = line.expect("Major error: Couldn't read line in file!");
                println!("{}", handle_line(&ln));
            });
        }
    });
}

fn run_sync(reader: BufReader<std::fs::File>) {
    for line in reader.lines() {
        let ln = line.expect("Major error: Couldn't read line in file!");
        println!("{}", handle_line(&ln));
    }
}

// give me an open file
fn open_file(pathname: &str) -> File {
    let path = Path::new(pathname);
    let display = path.display();

    match File::open(path) {
        Err(problem) => panic!("Couldn't open {}: {}", display, problem.description()),
        Ok(file) => file,
    }
}

// split, traverse, transform, and join each line
fn handle_line(line: &str) -> String {
    let comma = ",";

    line.split(comma)
        .map(|element| format!("x{}", element))
        .map(|element| format!("{}x", element))
        .collect::<Vec<String>>()
        .join(comma)
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
