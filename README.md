# README

![Build status](https://semaphoreapp.com/api/v1/projects/ffbd1a3d48ed0c867b12ae6673be8360ff79eb54/20378/badge.png)

## Setting up for development

Link this folder to two Pow domains:

```
ln -n ~/this/folder ~/.pow/thisispencilbox
ln -n ~/this/folder ~/.pow/pencilboxes
```

Run

```
script/setup
```

This will run `bundler` and create the databases.

Create an application on Dropbox and add the following to a file named `.powenv`:

```
export DROPBOX_APP_KEY=
export DROPBOX_APP_SECRET=
```

Restart your Pow server with

```
touch tmp/restart.txt
```

And you are good to go!

## Testing

Pencilbox uses the standard Rails MiniTest suite. Run all the tests with:

```
rake test
```

## Deploying

Deploy configuration is located in the file `config/deploy.rb`.

To deploy the master branch to the servers run:

```
cap deploy
```

To deploy a specific branch to the servers run:

```
cap deploy BRANCH=name-of-the-branch
```