use std::io::{stdout, stderr, Write};

use argparse::{ArgumentParser, StoreTrue};

use config::Config;


pub fn print_list(config: &Config, mut args: Vec<String>)
    -> Result<i32, String>
{
    let mut all = false;
    let mut builtin = false;
    let mut hidden = false;
    let mut containers = false;
    {
        args.insert(0, String::from("vagga _list"));
        let mut ap = ArgumentParser::new();
        ap.refer(&mut containers)
            .add_option(&["--containers"], StoreTrue,
                "Show containers instead of commands");
        ap.refer(&mut all)
            .add_option(&["-A", "--all"], StoreTrue,
                "Show all commands");
        ap.refer(&mut builtin)
            .add_option(&["--builtin"], StoreTrue,
                "Show built-in commands (starting with underscore)");
        ap.refer(&mut hidden)
            .add_option(&["--hidden"], StoreTrue,
                "Show hidden commands");
        match ap.parse(args, &mut stdout(), &mut stderr()) {
            Ok(()) => {}
            Err(x) => return Ok(x),
        }
    }
    if containers {
        for (cname, _) in config.containers.iter() {
            println!("{}", cname);
        }
    } else {
        let mut out = stdout();
        for (k, cmd) in config.commands.iter() {
            if k.starts_with("_") && !(hidden || all) {
                continue;
            }
            out.write_all(k.as_bytes()).ok();
            match cmd.description() {
                Some(ref val) => {
                    if k.len() > 19 {
                        out.write_all(b"\n                    ").ok();
                    } else {
                        for _ in k.len()..19 {
                            out.write_all(b" ").ok();
                        }
                        out.write_all(b" ").ok();
                    }
                    if val.contains("\n") {
                        for line in val.lines() {
                            out.write_all(line.as_bytes()).ok();
                            out.write_all(b"\n                    ").ok();
                        };
                    } else {
                        out.write_all(val.as_bytes()).ok();
                    }
                }
                None => {}
            }
            out.write_all(b"\n").ok();
        }

        if all || builtin {
            // TODO(tailhook) fetch builtins from completion code
            write!(&mut out, "\
                _build              Build a container\n\
                _run                Run arbitrary command, \
                                    optionally building container\n\
                _clean              Clean containers and build artifacts\n\
                _list               List of built-in commands\n\
                _base_dir           Display a directory which contains \
                                    vagga.yaml\n\
                _relative_work_dir  Display a relative path from the current\n\
                                    working directory to the directory\n\
                                    containing vagga.yaml\n\
            ").ok();
        }
    }
    return Ok(0);
}

pub fn print_help(config: &Config)
    -> Result<i32, String>
{
    let mut err = stderr();
    writeln!(&mut err, "Available commands:").ok();
    for (k, cmd) in config.commands.iter() {
        if k.starts_with("_") {
            continue;
        }
        write!(&mut err, "    {}", k).ok();
        match cmd.description() {
            Some(ref val) => {
                if k.len() > 19 {
                    err.write_all(b"\n                        ").ok();
                } else {
                    for _ in k.len()..19 {
                        err.write_all(b" ").ok();
                    }
                    err.write_all(b" ").ok();
                }
                if val.contains("\n") {
                    for line in val.lines() {
                        err.write_all(line.as_bytes()).ok();
                        err.write_all(b"\n                        ").ok();
                    };
                } else {
                    err.write_all(val.as_bytes()).ok();
                }
            }
            None => {}
        }
        err.write_all(b"\n").ok();
    }
    Ok(127)
}
