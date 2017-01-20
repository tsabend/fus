# Fus: 

## Stop compiling things you don't use. 
Fus is a command line tool for finding unused Swift classes in your project.

This tool was inspired by [fui](https://github.com/dblock/fui)

## Installation
```
$ gem install fus
```

## Usage

#### Get Help

```
fus help
```

#### Find Unused Classes in the Current Directory

```
fus find
```

The `find` command lists the names of all unused classes.

#### List all Swift Classes in the Current Directory

```
fus list
```

The `list` command lists the names of all the Swift classes identified by FUS.

#### Find Unused Classes at a Path

```
fus find --path [the path to search at]
```

## Contributing

This project (like Swift itself) is a work in progress. 
Contributions are very welcome.

1. Fork it ( https://github.com/[my-github-username]/fus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
